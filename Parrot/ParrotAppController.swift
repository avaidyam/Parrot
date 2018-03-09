import MochaUI
import WebKit
import XPCTransport
import ParrotServiceExtension
import class Hangouts.Client // required for Client.init(configuration:)

/* TODO: Replace login/logout with removal of account from Preferences. */

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "Parrot.Global")

@NSApplicationMain
public class ParrotAppController: NSApplicationController {
    
    /// An easy accessor for the current `ParrotAppController`.
    public static var main: ParrotAppController? { return NSApp.delegate as? ParrotAppController }
    
    /// The internal connection to the `parrotd` daemon.
    public var server = XPCConnection(name: .xpcServer, active: true)
    
    /// Intended to be a global logger that feeds logs to `parrotd` from all XPC clients.
    public let serverChannel = Logger.Channel { unit in
        try? ParrotAppController.main?.server.async(SendLogInvocation.self, with: unit)
    }
    
    /// A reachability manager to detect network changes for `ServiceRegistry`.
    private let reachability = NetworkReachabilityManager(host: .reachabilityURL)
    
    /// A catalog of all the subscriptions we're holding on to.
    internal var watching: [Any] = []
    
    /// If we're in menubar-only mode, we have a status item.
    private lazy var statusItem: NSStatusItem = {
        NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    }()
    
    /// The application's dock menu - this can be dynamically configured.
    /// Note that because we aren't using an NSDockTilePlugin, we can't provide
    /// this menu when the application isn't already open.
    private lazy var dockMenu: NSMenu = {
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
    }()
    
    /// Lazy-init for all the preferences panes.
    private lazy var preferencesController: PreferencesViewController = {
        let p = PreferencesViewController()
        p.add(pane: Preferences.Controllers.General())
        p.add(pane: Preferences.Controllers.Text())
        p.add(pane: Preferences.Controllers.Accounts())
        return p
    }()
    
	/// Lazy-init for the conversations NSViewController.
	internal lazy var conversationsController: NSViewController = {
		ConversationListViewController()
	}()
    
    /// Lazy-init for the directory NSViewController.
    private lazy var directoryController: NSViewController = {
        DirectoryListViewController()
    }()
    
    /// Lazy-init for the dual conversations+directory NSViewController.
    /// This won't be initialized unless `Settings.prefersShoeboxAppStyle` = true.
    private lazy var dualController: NSSplitViewController = {
        let sp = SplitWindowController()
        let item = NSSplitViewItem(sidebarWithViewController: self.conversationsController)
        item.isSpringLoaded = true
        item.collapseBehavior = .preferResizingSiblingsWithFixedSplitView
        sp.addSplitViewItem(item)
        return sp
    }()
    
    /// Cached form of `Settings.prefersShoeboxAppStyle` since this setting is volatile.
    private lazy var _prefersShoeboxAppStyle: Bool = {
        return Settings.prefersShoeboxAppStyle
    }()
    
    /// Depending on `Settings.prefersShoeboxAppStyle`, we return the correct UI.
    private var mainController: NSViewController {
        if self._prefersShoeboxAppStyle {
            return self.dualController
        } else {
            return self.conversationsController
        }
    }
	
	// First begin authentication and setup for any services.
	public func applicationWillFinishLaunching(_ notification: Notification) {
        log.info("Initializing Parrot...")
        
        ToolTipManager.modernize()
        Logger.globalChannels = [self.serverChannel]
        Analytics.sessionTrackingIdentifier = "UA-63931980-2"
        InterfaceStyle.bootstrap()
        self.registerEvents()
        
        // Register the default completions.
        Settings.register(defaults: ["completions": ["(": ")", "[": "]", "{": "}", "\"": "\"", "`": "`", "*": "*", "_": "_", "-": "-", "~": "~"]])
        
        // Sign in first.
        let cookies = try! server.sync(AuthenticationInvocation.self)
        let config = URLSessionConfiguration.default
        AuthenticationInvocation.unpackage(cookies).forEach {
            config.httpCookieStorage?.setCookie($0)
        }
        ServiceRegistry.add(service: Client(configuration: config))
        
        // Install reachability for connect/disconnect.
        self.reachability?.listen() {
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
            let c = ServiceRegistry.services.first!.value
            
            // FIXME: If an old opened conversation isn't in the recents, it won't open!
            if self._prefersShoeboxAppStyle { // only open one recent conv
                if let id = Settings.openConversations.first, let conv = c.conversations.conversations[id] {
                    MessageListViewController.show(conversation: conv,
                                    parent: self.conversationsController.parent)
                }
            } else {
                Settings.openConversations
                    .flatMap { c.conversations.conversations[$0] }
                    .forEach { MessageListViewController.show(conversation: $0,
                                     parent: self.conversationsController.parent) }
            }
        }
        
        // Watch the menubarIcon setting to toggle the statusbar item.
        let sub = Settings.observe(\.menubarIcon, options: [.new, .initial]) { _, _ in
            if Settings.menubarIcon {
                let image = NSImage(named: .applicationIcon)
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
        self.watching += [sub]
        
        // Wallclock for system idle -> service interaction.
        let work = DispatchWorkItem {
            let idleTime = CGEventSource.secondsSinceLastEventType(.combinedSessionState,
                                         eventType: CGEventType(rawValue: ~0)!)
            if idleTime < 5.minutes.toSeconds() {
                for (_, s) in ServiceRegistry.services {
                    s.setInteractingIfNeeded()
                }
            }
        }
        self.watching += [DispatchSource.timer(flags: .strict, queue: .global(qos: .background),
                          wallDeadline: .now(), repeating: 5.minutes, leeway: 1.minutes, handler: work)]
    }
    
    /// Before we quit, we have to send the "sign out" analytics.
    public func applicationWillTerminate(_ notification: Notification) {
        Analytics.sessionTrackingIdentifier = nil
        SystemBezel._space = nil // MUST be deinitialized upon app exit.
    }
    
    /// If the Conversations window is closed, tapping the dock icon will reopen it.
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        self.mainController.presentAsWindow()
		return true
	}
    
    public func application(_ application: NSApplication, open urls: [URL]) {
		// Create an alert handler to catch any issues with the host or path fragments.
		let alertHandler = {
            NSAlert(style: .informational, message: .openLocationFailed,
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
	
	func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
		return self.dockMenu
	}
    
    /// Right clicking the status item causes the app to close; left click causes it to become visible.
    @objc func showConversationWindow(_ sender: NSStatusBarButton?) {
        if NSApp.currentEvent!.type == NSEvent.EventType.rightMouseUp {
            NSApp.terminate(self)
        } else {
            self.mainController.presentAsWindow()
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    @objc func showPreferences(_ sender: Any?) {
        self.preferencesController.presentAsWindow()
        Analytics.view(screen: .preferences)
    }
    
    @objc func showConversations(_ sender: Any?) {
        self.mainController.presentAsWindow()
    }
    
    @objc func showDirectory(_ sender: Any?) {
        self.directoryController.presentAsWindow()
    }
    
	@objc func logoutSelected(_ sender: AnyObject) {
        try! server.sync(LogOutInvocation.self)
        NSApp.terminate(self)
	}
	
	@objc func feedback(_ sender: AnyObject?) {
        NSWorkspace.shared.open(URL(string: .feedbackURL)!)
    }
}
