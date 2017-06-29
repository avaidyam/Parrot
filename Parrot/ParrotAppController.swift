import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts
import WebKit
import ParrotServiceExtension

/* TODO: Replace login/logout with removal of account from Preferences. */

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "Parrot.Global")

@NSApplicationMain
public class ParrotAppController: NSApplicationController {
    
    let net = NetworkReachabilityManager(host: "google.com")
    
    private var connectSub: Subscription? = nil
    private var disconnectSub: Subscription? = nil
    private var notificationHelper: Subscription? = nil
    private var notificationReplyHelper: Subscription? = nil
    
    /// Lazy-init for Preferences.
    public lazy var preferencesController: PreferencesViewController = {
        let p = PreferencesViewController()
        p.tabStyle = .toolbar
        p.transitionOptions = [.allowUserInteraction, .crossfade, .slideDown]
        
        let general = Preferences.Controllers.General()
        let generalTab = NSTabViewItem(viewController: general)
        generalTab.image = general.image
        
        let text = Preferences.Controllers.Text()
        let textTab = NSTabViewItem(viewController: text)
        textTab.image = text.image
        
        let accounts = Preferences.Controllers.Accounts()
        let accountsTab = NSTabViewItem(viewController: accounts)
        accountsTab.image = accounts.image
        
        p.addTabViewItem(generalTab)
        p.addTabViewItem(textTab)
        p.addTabViewItem(accountsTab)
        return p
    }()
    
	/// Lazy-init for the main conversations NSWindowController.
	private lazy var conversationsController: NSViewController = {
		ConversationListViewController()
	}()
    
    private lazy var directoryController: NSViewController = {
        DirectoryListViewController()
    }()
    
    private lazy var statusItem: NSStatusItem = {
        NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    }()
	
	public override init() {
		super.init()
		
		// Check for updates if any are available.
        // Note: in the future, this will be invoked by the Parrot Daemon periodically
        // and the UI client will simply display the message; when updating, the
        // daemon will pre-cache the download and replace the executable.
		checkForUpdates(prerelease: true)
        
        /*subscribe(on: .system, source: nil, Notification.Name("com.avaidyam.Parrot.Service.giveConversations")) {
            log.debug("RESULTS: \($0)")
        }*/
		
		// Register the default completions if none are in the user settings.
		if Settings.completions.count == 0 {
			let defaultC = ["(": ")", "[": "]", "{": "}", "\"": "\"", "`": "`", "*": "*", "_": "_", "-": "-", "~": "~"]
			Settings.completions = defaultC
		}
	}
    
    deinit {
        self.connectSub = nil
        self.disconnectSub = nil
        self.notificationHelper = nil
        self.notificationReplyHelper = nil
    }
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(_ notification: Notification) {
		
		log.verbose("Initializing Parrot...")
		//AppActivity.start("Authenticate")
        Authenticator.delegate = WebDelegate.delegate
        Authenticator.authenticateClient {
            //AppActivity.end("Authenticate")
            
            DispatchQueue.main.async {
                self.conversationsController.presentAsWindow()
            }
            
            let c = Client(configuration: $0)
            ServiceRegistry.add(service: c)
            self.net?.startListening()
            
            self.connectSub = AutoSubscription(from: c, kind: Notification.Service.DidConnect) { _ in
                UserNotification(identifier: "Parrot.ConnectionStatus", title: "Parrot has connected.",
                                 contentImage: NSImage(named: NSImage.Name.caution)).post()
                
                // FIXME: If an old opened conversation isn't in the recents, it won't open!
                Settings.openConversations
                    .flatMap { c.conversationList?.conversations[$0] }
                    .forEach { MessageListViewController.show(conversation: $0 as! IConversation) }
			}
            self.disconnectSub = AutoSubscription(from: c, kind: Notification.Service.DidDisconnect) { _ in
                DispatchQueue.main.async { // FIXME why does wrapping it twice work??
                    NSUserNotification.notifications()
                        .filter { $0.identifier == "Parrot.ConnectionStatus" }
                        .forEach { $0.remove() }
                    let u = UserNotification(identifier: "Parrot.ConnectionStatus", title: "Parrot has disconnected.",
                                             contentImage: NSImage(named: NSImage.Name.caution))
                    u.set(option: .alwaysShow, value: true)
                    u.post()
                }
            }
            self.notificationHelper = AutoSubscription(kind: Notification.Conversation.DidReceiveEvent) {
                guard let event = $0.userInfo?["event"] as? IChatMessageEvent else { return }
                
                var showNote = true
                if let c = MessageListViewController.openConversations[event.conversation_id] {
                    showNote = !(c.view.window?.isKeyWindow ?? false)
                }
                
                if let user = (c.conversationList.conversations[event.conversation_id] as? IConversation)?.user_list[event.userID.gaiaID],
                    !user.me && showNote {
                    
                    /*
                    let ev = Event(identifier: event.conversation_id, contents: user.firstName + " (via Hangouts)",
                                   description: event.text, image: fetchImage(user: user, monogram: true))
                    let actions: [EventAction.Type] = [BannerAction.self, BezelAction.self, SoundAction.self, VibrateAction.self, BounceDockAction.self, FlashLEDAction.self, SpeakAction.self, ScriptAction.self]
                    actions.forEach {
                        $0.perform(with: ev)
                    }
                    */
                    
                    ///*
                    let notification = NSUserNotification()
                    notification.identifier = event.conversation_id
                    notification.title = user.firstName + " (via Hangouts)" /* FIXME */
                    //notification.subtitle = "via Hangouts"
                    notification.informativeText = event.text
                    notification.deliveryDate = Date()
                    notification.alwaysShowsActions = true
                    notification.hasReplyButton = true
                    notification.otherButtonTitle = "Mute"
                    notification.responsePlaceholder = "Send a message..."
                    notification.identityImage = user.image
                    notification.identityStyle = .circle
                    //notification.soundName = "texttone:Bamboo" // this works!!
                    notification.set(option: .customSoundPath, value: "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/sms_alert_bamboo.caf")
                    notification.set(option: .vibrateForceTouch, value: true)
                    notification.set(option: .alwaysShow, value: true)
                    
                    // Post the notification "uniquely" -- that is, replace it while it is displayed.
                    NSUserNotification.notifications()
                        .filter { $0.identifier == notification.identifier }
                        .forEach { $0.remove() }
                    notification.post()
                    //*/
                }
            }
            self.notificationReplyHelper = AutoSubscription(kind: NSUserNotification.didActivateNotification) {
                guard	let notification = $0.object as? NSUserNotification,
                    var conv = c.conversationList?.conversations[notification.identifier ?? ""]
                    else { return }
                
                switch notification.activationType {
                case .contentsClicked:
                    MessageListViewController.show(conversation: conv as! IConversation)
                case .actionButtonClicked:
                    conv.muted = true
                case .replied where notification.response?.string != nil:
                    MessageListViewController.sendMessage(notification.response!.string, conv)
                default: break
                }
            }
		}
        
        net?.listener = {
            for (name, service) in ServiceRegistry.services {
                switch $0 {
                case .reachable(_) where !service.connected:
                    log.debug("Connecting service <\(name)>...")
                    _ = service.connect()
                case .notReachable where service.connected:
                    log.debug("Disconnecting service <\(name)>...")
                    _ = service.disconnect()
                default: continue
                }
            }
        }
        
        /// This setting currently does not exist in the UI. Use `defaults` to set it.
        if Settings.menubarIcon {
            let image = NSImage(named: NSImage.Name.applicationIcon)
            image?.size = NSSize(width: 16, height: 16)
            statusItem.image = image
            statusItem.button?.target = self
            statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
            statusItem.button?.action = #selector(self.showConversationWindow(_:))
            NSApp.setActivationPolicy(.accessory)
        }
    }
    
    /// Right clicking the status item causes the app to close; left click causes it to become visible.
    @objc func showConversationWindow(_ sender: NSStatusBarButton?) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            NSApp.terminate(self)
        } else {
            DispatchQueue.main.async {
                self.conversationsController.presentAsWindow()
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    /// If the Conversations window is closed, tapping the dock icon will reopen it.
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        DispatchQueue.main.async {
            self.conversationsController.presentAsWindow()
        }
		return true
	}
    
    public func application(_ application: NSApplication, open urls: [URL]) {
		// Create an alert handler to catch any issues with the host or path fragments.
		let alertHandler = {
			let a = NSAlert()
			a.alertStyle = .informational
			a.messageText = "Parrot couldn't open that location!"
			a.informativeText = urls[0].absoluteString
			a.addButton(withTitle: "OK")
			
			a.layout()
			a.window.appearance = ParrotAppearance.interfaceStyle().appearance()
            if let vev = a.window.titlebar.view as? NSVisualEffectView {
                vev.material = .appearanceBased
                vev.state = .active
                vev.blendingMode = .withinWindow
            }
			if a.runModal().rawValue == 1000 /*NSAlertFirstButtonReturn*/ {
				log.warning("Done with alert.")
			}
		}
		
		/// If the URL host is a Service we have registered, comprehend it.
		if let service = ServiceRegistry.services[(urls[0].host ?? "")] {
			let name = urls[0].lastPathComponent.removingPercentEncoding ?? ""
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
                self.conversationsController.presentAsWindow()
            }
		}
		menu.addItem(withTitle: "Log Out...",
		             action: #selector(self.logoutSelected(_:)),
		             keyEquivalent: "")
		return menu
	}
    
    @IBAction func showPreferences(_ sender: Any?) {
        self.preferencesController.presentAsWindow()
    }
    
    @IBAction func showConversations(_ sender: Any?) {
        self.conversationsController.presentAsWindow()
    }
    
    @IBAction func showDirectory(_ sender: Any?) {
        self.directoryController.presentAsWindow()
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
        NSWorkspace.shared.open(URL(string: "https://gitreports.com/issue/avaidyam/Parrot")!)
    }
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
    if let vev = a.window.titlebar.view as? NSVisualEffectView {
        vev.material = .appearanceBased
        vev.state = .active
        vev.blendingMode = .withinWindow
    }
    if a.runModal().rawValue == 1000 /*NSAlertFirstButtonReturn*/ {
        NSWorkspace.shared.open(release.githubURL)
    }
}
