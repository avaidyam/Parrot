import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts
import WebKit
import XPCTransport
import ParrotServiceExtension

/* TODO: Replace login/logout with removal of account from Preferences. */

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "Parrot.Global")

@NSApplicationMain
public class ParrotAppController: NSApplicationController {
    
    private let net = NetworkReachabilityManager(host: "google.com")
    private var menubarSub: NSKeyValueObservation? = nil
    private var idleTimer: DispatchSourceTimer? = nil
    internal var watching: [Subscription] = []
    
    fileprivate var server = XPCConnection(name: "com.avaidyam.Parrot.parrotd", active: true)
    private static let xpcChannel = Logger.Channel { unit in
        // any failure in these ?'s will kill the logunit
        try? (NSApp.delegate as? ParrotAppController)?.server.async(SendLogInvocation.self, with: unit)
    }
    
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
	internal lazy var conversationsController: NSViewController = {
		ConversationListViewController()
	}()
    
    private lazy var directoryController: NSViewController = {
        DirectoryListViewController()
    }()
    
    private lazy var dualController: NSSplitViewController = {
        let sp = SplitWindowController()
        let item = NSSplitViewItem(sidebarWithViewController: self.conversationsController)
        item.isSpringLoaded = true
        item.collapseBehavior = .preferResizingSiblingsWithFixedSplitView
        sp.addSplitViewItem(item)
        return sp
    }()
    
    private lazy var statusItem: NSStatusItem = {
        NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    }()
	
    // cached!
    private lazy var _prefersShoeboxAppStyle: Bool = {
        return Settings.prefersShoeboxAppStyle
    }()
    private var mainController: NSViewController {
        if self._prefersShoeboxAppStyle {
            return self.dualController
        } else {
            return self.conversationsController
        }
    }
    
	public override init() {
		super.init()
        
        // Well let's see if this works.
        Logger.globalChannels = [ParrotAppController.xpcChannel]
        
        // Set up the Google Analytics reporting.
        GoogleAnalytics.sessionTrackingIdentifier = "UA-63931980-2"
		
		// Register the default completions if none are in the user settings.
        // Note: we're not using the registered defaults domain on purpose for this.
		if Settings.completions.count == 0 {
			let defaultC = ["(": ")", "[": "]", "{": "}", "\"": "\"", "`": "`", "*": "*", "_": "_", "-": "-", "~": "~"]
			Settings.completions = defaultC
		}
	}
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(_ notification: Notification) {
        log.info("Initializing Parrot...")
        self.registerEvents()
        
        // Sign in first.
        let cookies = try! server.sync(AuthenticationInvocation.self)
        let config = URLSessionConfiguration.default
        AuthenticationInvocation.unpackage(cookies).forEach {
            config.httpCookieStorage?.setCookie($0)
        }
        ServiceRegistry.add(service: Client(configuration: config))
        
        // Install reachability for connect/disconnect.
        self.net?.listen() {
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
        
        // Show main window.
        DispatchQueue.main.async {
            self.mainController.presentAsWindow()
            let c = ServiceRegistry.services.first!.value as! Client
            
            // FIXME: If an old opened conversation isn't in the recents, it won't open!
            if self._prefersShoeboxAppStyle { // only open one recent conv
                if let id = Settings.openConversations.first, let conv = c.conversationList?.conversations[id] {
                    MessageListViewController.show(conversation: conv as! IConversation,
                                                   parent: self.conversationsController)
                }
            } else {
                Settings.openConversations
                    .flatMap { c.conversationList?.conversations[$0] }
                    .forEach { MessageListViewController.show(conversation: $0 as! IConversation,
                                                              parent: self.conversationsController) }
            }
        }
        
        // Watch the menubarIcon setting to toggle the statusbar item.
        self.menubarSub = Settings.observe(\.menubarIcon, options: [.new, .initial]) { _, _ in
            if Settings.menubarIcon {
                let image = NSImage(named: NSImage.Name.applicationIcon)
                image?.size = NSSize(width: 16, height: 16)
                self.statusItem.image = image
                self.statusItem.button?.target = self
                self.statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
                self.statusItem.button?.action = #selector(self.showConversationWindow(_:))
                
                NSApp.setActivationPolicy(.accessory)
            } else {
                NSStatusBar.system.removeStatusItem(self.statusItem)
                NSApp.setActivationPolicy(.regular)
            }
        }
        
        // Wallclock for system idle -> service interaction.
        self.idleTimer = DispatchSource.makeTimerSource(queue: .main)
        self.idleTimer?.schedule(wallDeadline: .now(), repeating: 5.minutes, leeway: 1.minutes)
        self.idleTimer?.setEventHandler {
            let CGEventType_anyInput = CGEventType(rawValue: ~0)!
            let idleTime = CGEventSource.secondsSinceLastEventType(.combinedSessionState, eventType: CGEventType_anyInput)
            
            if idleTime < 5.minutes.toSeconds() {
                for (_, s) in ServiceRegistry.services {
                    s.setInteractingIfNeeded()
                }
            }
        }
        self.idleTimer?.resume()
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        GoogleAnalytics.sessionTrackingIdentifier = nil
    }
    
    /// Right clicking the status item causes the app to close; left click causes it to become visible.
    @objc func showConversationWindow(_ sender: NSStatusBarButton?) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            NSApp.terminate(self)
        } else {
            DispatchQueue.main.async {
                self.mainController.presentAsWindow()
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    /// If the Conversations window is closed, tapping the dock icon will reopen it.
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        DispatchQueue.main.async {
            self.mainController.presentAsWindow()
        }
		return true
	}
    
    public func application(_ application: NSApplication, open urls: [URL]) {
		// Create an alert handler to catch any issues with the host or path fragments.
		let alertHandler = {
            NSAlert(style: .informational, message: "Parrot couldn't open that location!",
                    information: urls[0].absoluteString, buttons: ["OK"]).beginModal()
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
                self.mainController.presentAsWindow()
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
        self.mainController.presentAsWindow()
    }
    
    @IBAction func showDirectory(_ sender: Any?) {
        self.directoryController.presentAsWindow()
    }
    
	@IBAction func logoutSelected(_ sender: AnyObject) {
        try! server.sync(LogOutInvocation.self)
        NSApp.terminate(self)
	}
	
	@IBAction func feedback(_ sender: AnyObject?) {
        NSWorkspace.shared.open(URL(string: "https://gitreports.com/issue/avaidyam/Parrot")!)
    }
}
