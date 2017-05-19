import Cocoa
import Mocha
import MochaUI
import Hangouts
import WebKit
import ParrotServiceExtension

/* TODO: Replace login/logout with removal of account from Preferences. */

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "Parrot.Global")

// Existing Parrot Settings keys.
public enum Parrot {
	public static let InterfaceStyle = "Parrot.InterfaceStyle"
	public static let SystemInterfaceStyle = "Parrot.SystemInterfaceStyle"
	public static let VibrancyStyle = "Parrot.VibrancyStyle"
	
	public static let AutoEmoji = "Parrot.AutoEmoji"
	public static let MessageTextSize = "Parrot.MessageTextSize"
	public static let Emoticons = "Parrot.Emoticons"
    public static let Completions = "Parrot.Completions"
    public static let MenuBarIcon = "Parrot.MenuBarIcon"
	
	public static let VibrateForceTouch = "Parrot.VibrateForceTouch"
	public static let VibrateInterval = "Parrot.VibrateInterval"
	public static let VibrateLength = "Parrot.VibrateLength"
}

@NSApplicationMain
public class ParrotAppController: NSApplicationController {
    
    let net = NetworkReachabilityManager(host: "google.com")
    
	/// Lazy-init for the main conversations NSWindowController.
	private lazy var conversationsController: NSWindowController = {
		ConversationListViewController()
	}()
    
    private lazy var statusItem: NSStatusItem = {
        NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    }()
	
	public override init() {
		super.init()
		
		// Check for updates if any are available.
        // Note: in the future, this will be invoked by the Parrot Daemon periodically
        // and the UI client will simply display the message; when updating, the
        // daemon will pre-cache the download and replace the executable.
		checkForUpdates(prerelease: true)
		
		// Register for AppleEvents that follow our URL scheme.
		NSAppleEventManager.shared().setEventHandler(self,
			andSelector: #selector(self.handleURL(event:withReply:)),
			forEventClass: UInt32(kInternetEventClass),
			andEventID: UInt32(kAEGetURL)
		)
        
        /*subscribe(on: .system, source: nil, Notification.Name("com.avaidyam.Parrot.Service.giveConversations")) {
            log.debug("RESULTS: \($0)")
        }*/
		
		// Register the default completions if none are in the user settings.
		if let c = Settings[Parrot.Completions] as? NSDictionary , c.count > 0 {} else {
			let defaultC = ["(": ")", "[": "]", "{": "}", "\"": "\"", "`": "`", "*": "*", "_": "_", "-": "-", "~": "~"]
			Settings[Parrot.Completions] = defaultC
		}
	}
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(_ notification: Notification) {
		
		log.verbose("Initializing Parrot...")
		//AppActivity.start("Authenticate")
        Authenticator.delegate = WebDelegate.delegate
		Authenticator.authenticateClient {
            let c = Client(configuration: $0)
			//AppActivity.end("Authenticate")
			
            _ = subscribe(source: c, Client.didConnectNotification) { _ in
                UserNotification(identifier: "Parrot.ConnectionStatus", title: "Parrot has connected.",
                                 contentImage: NSImage(named: NSImageNameCaution)).post()
                
                //AppActivity.start("Setup")
                if c.conversationList == nil {
                    c.buildUserConversationList {
                        // When reconnecting, buildUserConversationList causes Client to then
                        // re-create the entire userlist + conversationlist and reset it
                        // but the old ones are still alive, and their delegate is set to the
                        // conversations window; that means you'll receive double notifications.
                        
                        // TODO: FIXME: THIS IS A TERRIBLE DIRTY DISGUSTING HAX, DON'T DO ITS!
                        NotificationCenter.default.post(name: ServiceRegistry.didAddService, object: c)
                        //AppActivity.end("Setup")
                    }
                }
                
			}
            _ = subscribe(source: c, Client.didDisconnectNotification) { _ in
                UserNotification(identifier: "Parrot.ConnectionStatus", title: "Parrot has disconnected.",
                                 contentImage: NSImage(named: NSImageNameCaution)).post()
            }
            
            ServiceRegistry.add(service: c)
            self.net?.startListening()
            DispatchQueue.main.async {
                self.conversationsController.showWindow(nil)
            }
		}
        
        net?.listener = {
            for (name, service) in ServiceRegistry.services {
                switch $0 {
                case .reachable(_) where !service.connected:
                    log.debug("Connecting service <\(name)>...")
                    _ = service.connect() {_ in}
                case .notReachable where service.connected:
                    log.debug("Disconnecting service <\(name)>...")
                    _ = service.disconnect() {_ in}
                default: continue
                }
            }
        }
        
        /// This setting currently does not exist in the UI. Use `defaults` to set it.
        /// For a menubar-only experience, set the Info.plist `LSUIElement` to YES.
        if Settings[Parrot.MenuBarIcon] != nil {
            let image = NSImage(named: NSImageNameApplicationIcon)
            image?.size = NSSize(width: 16, height: 16)
            statusItem.image = image
            statusItem.button?.target = self
            statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
            statusItem.button?.action = #selector(self.showConversationWindow(sender:))
        }
    }
    
    /// Right clicking the status item causes the app to close; left click causes it to become visible.
    func showConversationWindow(sender: NSStatusBarButton?) {
        let event = NSApp.currentEvent!
        if event.type == NSEventType.rightMouseUp {
            NSApp.terminate(self)
        } else {
            DispatchQueue.main.async {
                self.conversationsController.showWindow(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    /// If the Conversations window is closed, tapping the dock icon will reopen it.
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        DispatchQueue.main.async {
            self.conversationsController.showWindow(nil)
        }
		return true
	}
	
	/// Handle any URLs that follow the scheme "parrot://" by forwarding them.
	func handleURL(event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
		guard	let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
				let url = URL(string: urlString) else { return }
		
		// Create an alert handler to catch any issues with the host or path fragments.
		let alertHandler = {
			let a = NSAlert()
			a.alertStyle = .informational
			a.messageText = "Parrot couldn't open that location!"
			a.informativeText = urlString
			a.addButton(withTitle: "OK")
			
			a.layout()
			a.window.appearance = ParrotAppearance.interfaceStyle().appearance()
			a.window.enableRealTitlebarVibrancy(.behindWindow) // FIXME
			if a.runModal() == 1000 /*NSAlertFirstButtonReturn*/ {
				log.warning("Done with alert.")
			}
		}
		
		/// If the URL host is a Service we have registered, comprehend it.
		if let service = ServiceRegistry.services[(url.host ?? "")] {
			let name = url.lastPathComponent.removingPercentEncoding ?? ""
			let convs = Array(service.conversations.conversations.values)
			if let found = (convs.filter { $0.name == name }).first {
				
				log.info("got conv: \(found)")
			} else {
				alertHandler()
			}
		} else {
			alertHandler()
		}
	}
	
	/// Provide an application dock menu. Note that because we aren't using an NSDockTilePlugin,
	/// we can't provide this menu when the application isn't already open.
	func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
		let menu = NSMenu(title: "Parrot")
		menu.addItem(title: "Open Conversations") {
			log.info("Open Conversations")
            DispatchQueue.main.async {
                self.conversationsController.showWindow(nil)
            }
		}
		menu.addItem(withTitle: "Log Out...",
		             action: #selector(self.logoutSelected(_:)),
		             keyEquivalent: "")
		return menu
	}
	
	/// If the user requests logging out, clear the authentication tokens.
	@IBAction func logoutSelected(_ sender: AnyObject) {
		let cookieStorage = HTTPCookieStorage.shared
		if let cookies = cookieStorage.cookies {
			for cookie in cookies {
				cookieStorage.deleteCookie(cookie)
			}
		}
		WebDelegate.delegate.authenticationTokens = nil
		NSApp.terminate(self)
	}
	
    ///
	@IBAction func feedback(_ sender: AnyObject?) {
		NSWorkspace.shared().open(URL(string: "https://gitreports.com/issue/avaidyam/Parrot")!)
    }
}

internal class WebDelegate: NSObject, WebPolicyDelegate, WebResourceLoadDelegate, AuthenticatorDelegate {
    
    private static let GROUP_DOMAIN = "group.com.avaidyam.Parrot"
    private static let ACCESS_TOKEN = "access_token"
    private static let REFRESH_TOKEN = "refresh_token"
    
    internal static var window: NSWindow? = nil
    internal static var validURL: URL? = nil
    internal static var handler: ((_ oauth_code: String) -> Void)? = nil
    internal static var delegate = WebDelegate()
    
    internal func webView(_ sender: WebView!, resource identifier: Any!, didFinishLoadingFrom dataSource: WebDataSource!) {
        guard   let cookiejar = dataSource.response as? HTTPURLResponse,
            let cookies = cookiejar.allHeaderFields["Set-Cookie"] as? String,
            let cookie = cookies.substring(between: "oauth_code=", and: ";")
            else { return }
        WebDelegate.handler?(cookie)
        sender.close()
    }
    
    internal class func prompt(url: URL, cb: @escaping AuthenticationResult) {
        var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comp.query = nil
        let valid = comp.url
        guard valid != nil else { return }
        
        WebDelegate.validURL = valid
        WebDelegate.handler = cb
        
        let webView = WebView(frame: NSMakeRect(0, 0, 386, 512))
        webView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
        //webView.policyDelegate = WebDelegate.delegate
        webView.resourceLoadDelegate = WebDelegate.delegate
        
        let window = NSWindow(contentRect: NSMakeRect(0, 0, 386, 512),
                              styleMask: [.titled, .closable],
                              backing: .buffered, defer: false)
        window.title = "Login to Parrot"
        window.isOpaque = false
        window.isMovableByWindowBackground = true
        window.contentView = webView
        window.center()
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.collectionBehavior = [.moveToActiveSpace, .transient, .ignoresCycle, .fullScreenAuxiliary, .fullScreenDisallowsTiling]
        window.makeKeyAndOrderFront(nil)
        
        WebDelegate.window = window
        webView.mainFrame.load(URLRequest(url: url as URL))
    }
    
    var authenticationTokens: AuthenticationTokens? {
        get {
            let at = SecureSettings[WebDelegate.ACCESS_TOKEN, domain: WebDelegate.GROUP_DOMAIN] as? String
            let rt = SecureSettings[WebDelegate.REFRESH_TOKEN, domain: WebDelegate.GROUP_DOMAIN] as? String
            
            if let at = at, let rt = rt {
                return (access_token: at, refresh_token: rt)
            } else {
                SecureSettings[WebDelegate.ACCESS_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = nil
                SecureSettings[WebDelegate.REFRESH_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = nil
                return nil
            }
        }
        set {
            SecureSettings[WebDelegate.ACCESS_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = newValue?.access_token ?? nil
            SecureSettings[WebDelegate.REFRESH_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = newValue?.refresh_token ?? nil
        }
    }
    
    func authenticationMethod(_ oauth_url: URL, _ result: @escaping AuthenticationResult) {
        WebDelegate.prompt(url: oauth_url, cb: result)
    }
}

@objc(ParrotApplication)
class ParrotApplication: NSApplication {
    /*public override func orderFrontCharacterPalette(_ sender: AnyObject?) {
        log.debug("CHARACTER PICKER DISABLED. \(self.keyWindow?.firstResponder)")
    }*/
}

// For initial release alerts.
public func checkForUpdates(prerelease: Bool = false) {
    guard let buildTag = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return }
    guard let release = GithubRelease.latest(prerelease: prerelease) else { return }
    guard release.buildTag > Semver(buildTag) else { return }
    
    let a = NSAlert(style: .informational, message: "\(release.releaseName) available",
                    information: release.releaseNotes, buttons: ["Update", "Ignore"],
                    showSuppression: true) // FIXME suppression
    a.window.appearance = ParrotAppearance.interfaceStyle().appearance()
    a.window.enableRealTitlebarVibrancy(.behindWindow) // FIXME
    if a.runModal() == 1000 /*NSAlertFirstButtonReturn*/ {
        NSWorkspace.shared().open(release.githubURL)
    }
}
