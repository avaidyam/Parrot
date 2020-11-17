<<<<<<< Updated upstream
import MochaUI
import WebKit
import XPCTransport
import ParrotServiceExtension
import class Hangouts.Client // required for Client.init(configuration:)
=======
import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts
import WebKit
import ParrotServiceExtension
>>>>>>> Stashed changes

/* TODO: Replace login/logout with removal of account from Preferences. */

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "Parrot.Global")

<<<<<<< Updated upstream
public class ParrotAppController: NSApplicationController {
    
    /// An easy accessor for the current `ParrotAppController`.
    public static var main: ParrotAppController? { return NSApp.delegate as? ParrotAppController }
    
    /// The internal connection to the `parrotd` daemon.
    public var server = XPCConnection(name: .xpcServer, active: true)
    
    /// Intended to be a global logger that feeds logs to `parrotd` from all XPC clients.
    public let serverChannel = Logger.Channel { unit in
        try? ParrotAppController.main?.server.async(SendLogInvocation.self, with: unit)
    }
    
    /// Intended to be a UI logger that presents to the user.
    public let alertChannel = Logger.Channel { unit in
        var style = NSAlert.Style.informational
        switch unit.severity {
        case .fatal:
            style = .critical
        case .error:
            style = .critical
        case .warning:
            style = .warning
        case .debug:
            style = .informational
        case .info:
            style = .informational
        }
        let a = NSAlert(style: style, message: unit.message,
                        information: "Encountered in Parrot subsystem [\(unit.subsystem)].")
        _ = a.beginModal()
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
                self.mainController.showWindow(nil)
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
        p.add(pane: Preferences.Controllers.Shortcuts())
        p.add(pane: Preferences.Controllers.Sounds())
        p.add(pane: Preferences.Controllers.Accounts())
        return p
    }()
    
	/// Lazy-init for the conversations NSViewController.
	internal lazy var conversationsController: NSViewController = {
		ConversationListViewController()
	}()
    
    /// Lazy-init for the directory NSViewController.
=======
@NSApplicationMain
public class ParrotAppController: NSApplicationController {
    
    let net = NetworkReachabilityManager(host: "google.com")
    
    private var connectSub: Subscription? = nil
    private var disconnectSub: Subscription? = nil
    private var notificationHelper: Subscription? = nil
    private var notificationReplyHelper: Subscription? = nil
    
	/// Lazy-init for the main conversations NSWindowController.
	private lazy var conversationsController: NSViewController = {
		ConversationListViewController()
	}()
    
>>>>>>> Stashed changes
    private lazy var directoryController: NSViewController = {
        DirectoryListViewController()
    }()
    
<<<<<<< Updated upstream
    /// Lazy-init for the dual conversations+directory ParrotWindowController.
    /// This won't be initialized unless `Settings.prefersShoeboxAppStyle` = true.
    private lazy var dualController: ParrotWindowController = {
        let sp = ParrotWindowController()
        sp.addViewController(self.conversationsController)
        return sp
    }()
    
    /// Lazy-init for the single conversations+directory ParrotWindowController.
    /// This won't be initialized unless `Settings.prefersShoeboxAppStyle` = false.
    private lazy var singleController: ParrotWindowController = {
        let sp = ParrotWindowController()
        sp.addViewController(self.conversationsController)
        return sp
    }()
    
    /// Cached form of `Settings.prefersShoeboxAppStyle` since this setting is volatile.
    private lazy var _prefersShoeboxAppStyle: Bool = {
        return Settings.prefersShoeboxAppStyle
    }()
    
    /// Depending on `Settings.prefersShoeboxAppStyle`, we return the correct UI.
    private var mainController: NSWindowController {
        if self._prefersShoeboxAppStyle {
            return self.dualController
        } else {
            return self.singleController
        }
    }
	
	// First begin authentication and setup for any services.
	public func applicationWillFinishLaunching(_ notification: Notification) {
        log.info("Initializing Parrot...")
        
        ParrotAppController.configureDefaultAppMenus()
        ToolTipManager.modernize()
        Logger.globalChannels = [self.serverChannel]
        Analytics.sessionTrackingIdentifier = "UA-63931980-2"
        InterfaceStyle.bootstrap()
        NSGestureRecognizer.wantsIndirectTouches = true
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
=======
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
        
        /*subscribe(on: .system, source: nil, Notification.Name("com.avaidyam.Parrot.Service.giveConversations")) {
            log.debug("RESULTS: \($0)")
        }*/
		
		// Register the default completions if none are in the user settings.
		if let c = Settings[Preferences.Key.Completions] as? NSDictionary , c.count > 0 {} else {
			let defaultC = ["(": ")", "[": "]", "{": "}", "\"": "\"", "`": "`", "*": "*", "_": "_", "-": "-", "~": "~"]
			Settings[Preferences.Key.Completions] = defaultC
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
                                 contentImage: NSImage(named: NSImageNameCaution)).post()
                
                // FIXME: If an old opened conversation isn't in the recents, it won't open!
                (Settings["Parrot.OpenConversations"] as? [String])?
                    .flatMap { c.conversationList?.conversations[$0] }
                    .forEach { MessageListViewController.show(conversation: $0 as! IConversation) }
			}
            self.disconnectSub = AutoSubscription(from: c, kind: Notification.Service.DidDisconnect) { _ in
                DispatchQueue.main.async { // FIXME why does wrapping it twice work??
                    NSUserNotification.notifications()
                        .filter { $0.identifier == "Parrot.ConnectionStatus" }
                        .forEach { $0.remove() }
                    let u = UserNotification(identifier: "Parrot.ConnectionStatus", title: "Parrot has disconnected.",
                                             contentImage: NSImage(named: NSImageNameCaution))
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
>>>>>>> Stashed changes
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
        
<<<<<<< Updated upstream
        // Show main window.
        DispatchQueue.main.async {
            self.mainController.showWindow(nil)
            let c = ServiceRegistry.services.first!.value
            
            // FIXME: If an old opened conversation isn't in the recents, it won't open!
            if self._prefersShoeboxAppStyle { // only open one recent conv
                if let id = Settings.openConversations.first, let conv = c.conversations.conversations[id] {
                    MessageListViewController.show(conversation: conv,
                                    parent: self.conversationsController.parent)
                }
            } else {
                Settings.openConversations
                    .compactMap { c.conversations.conversations[$0] }
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
=======
        /// This setting currently does not exist in the UI. Use `defaults` to set it.
        /// For a menubar-only experience, set the Info.plist `LSUIElement` to YES.
        if Settings[Preferences.Key.MenuBarIcon] != nil {
            let image = NSImage(named: NSImageNameApplicationIcon)
            image?.size = NSSize(width: 16, height: 16)
            statusItem.image = image
            statusItem.button?.target = self
            statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
            statusItem.button?.action = #selector(self.showConversationWindow(_:))
        }
    }
    
    /// Right clicking the status item causes the app to close; left click causes it to become visible.
    func showConversationWindow(_ sender: NSStatusBarButton?) {
        let event = NSApp.currentEvent!
        if event.type == NSEventType.rightMouseUp {
            NSApp.terminate(self)
        } else {
            DispatchQueue.main.async {
                self.conversationsController.presentAsWindow()
                NSApp.activate(ignoringOtherApps: true)
            }
        }
>>>>>>> Stashed changes
    }
    
    /// If the Conversations window is closed, tapping the dock icon will reopen it.
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
<<<<<<< Updated upstream
        self.mainController.showWindow(nil)
=======
        DispatchQueue.main.async {
            self.conversationsController.presentAsWindow()
        }
>>>>>>> Stashed changes
		return true
	}
    
    public func application(_ application: NSApplication, open urls: [URL]) {
		// Create an alert handler to catch any issues with the host or path fragments.
		let alertHandler = {
<<<<<<< Updated upstream
            NSAlert(style: .informational, message: .openLocationFailed,
                    information: urls[0].absoluteString, buttons: ["OK"]).beginModal()
=======
			let a = NSAlert()
			a.alertStyle = .informational
			a.messageText = "Parrot couldn't open that location!"
			a.informativeText = urls[0].absoluteString
			a.addButton(withTitle: "OK")
			
			a.layout()
			a.window.appearance = ParrotAppearance.interfaceStyle().appearance()
			a.window.enableRealTitlebarVibrancy(.behindWindow) // FIXME
			if a.runModal() == 1000 /*NSAlertFirstButtonReturn*/ {
				log.warning("Done with alert.")
			}
>>>>>>> Stashed changes
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
	
<<<<<<< Updated upstream
	func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
		return self.dockMenu
	}
}

public extension ParrotAppController {
    
    
    //
    // Menu Actions
    //
    
    
    @objc dynamic func sendFeedback(_ sender: Any?) {
        NSWorkspace.shared.open(URL(string: .feedbackURL)!)
    }
    
    @objc dynamic func showPreferences(_ sender: Any?) {
        self.preferencesController.presentAsWindow()
        Analytics.view(screen: .preferences)
    }
    
    @objc dynamic func showConversations(_ sender: Any?) {
        self.mainController.showWindow(nil)
    }
    
    @objc dynamic func showDirectory(_ sender: Any?) {
        self.directoryController.presentAsWindow()
    }
    
	@objc dynamic func logoutSelected(_ sender: Any?) {
        try! server.sync(LogOutInvocation.self)
        NSApp.terminate(self)
	}
    
    /// Right clicking the status item causes the app to close; left click causes it to become visible.
    @objc dynamic func showConversationWindow(_ sender: NSStatusBarButton?) {
        if NSApp.currentEvent!.type == NSEvent.EventType.rightMouseUp {
            NSApp.terminate(self)
        } else {
            self.mainController.showWindow(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    
    //
    // Default Apple Menu
    //
    
    
    /// Configures a default menu as provided by Interface Builder.
    public static func configureDefaultAppMenus() {
        let appName: NSString = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? NSString ?? "App"
        let appMenu = NSMenuItem(title: "", [
            NSMenuItem(title: "\(appName)", [
                NSMenuItem(title: "About \(appName)", action: "orderFrontStandardAboutPanel:"),
                NSMenuItem(title: "Send Feedback…", action: "sendFeedback:"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Preferences…", action: "showPreferences:", keyEquivalent: ",", modifierMask: [.command]),
                NSMenuItem(title: "Accounts…", isEnabled: false),
                NSMenuItem.separator(),
                NSMenuItem(title: "Add Account", isEnabled: false),
                NSMenuItem(title: "Logout", action: "logoutSelected:"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Services", []),
                NSMenuItem.separator(),
                NSMenuItem(title: "Hide \(appName)", action: "hide:", keyEquivalent: "h", modifierMask: [.command]),
                NSMenuItem(title: "Hide Others", action: "hideOtherApplications:", keyEquivalent: "h", modifierMask: [.command, .option]),
                NSMenuItem(title: "Show All", action: "unhideAllApplications:"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Quit \(appName)", action: "terminate:", keyEquivalent: "q", modifierMask: [.command]),
            ]),
            NSMenuItem(title: "File", [
                NSMenuItem(title: "New", action: "newDocument:", keyEquivalent: "n", modifierMask: [.command]),
                NSMenuItem(title: "Open…", action: "openDocument:", keyEquivalent: "o", modifierMask: [.command]),
                NSMenuItem(title: "Open Recent", [
                    NSMenuItem(title: "Clear Menu", action: "clearRecentDocuments:", modifierMask: [.command]),
                ]),
                NSMenuItem.separator(),
                NSMenuItem(title: "Close", action: "performClose:", keyEquivalent: "w", modifierMask: [.command]),
                NSMenuItem(title: "Close All", target: NSApplication.shared, action: "closeAll:", keyEquivalent: "w", modifierMask: [.command, .option]),
                NSMenuItem(title: "Save…", action: "saveDocument:", keyEquivalent: "s", modifierMask: [.command]),
                NSMenuItem(title: "Save As…", action: "saveDocumentAs:", keyEquivalent: "S", modifierMask: [.command]),
                NSMenuItem(title: "Revert to Saved", action: "revertDocumentToSaved:", keyEquivalent: "r", modifierMask: [.command]),
                NSMenuItem.separator(),
                NSMenuItem(title: "Page Setup…", action: "runPageLayout:", keyEquivalent: "P", modifierMask: [.command, .shift]),
                NSMenuItem(title: "Print…", action: "print:", keyEquivalent: "p", modifierMask: [.command]),
            ]),
            NSMenuItem(title: "Edit", [
                NSMenuItem(title: "Undo", action: "undo:", keyEquivalent: "z", modifierMask: [.command]),
                NSMenuItem(title: "Redo", action: "redo:", keyEquivalent: "Z", modifierMask: [.command]),
                NSMenuItem.separator(),
                NSMenuItem(title: "Cut", action: "cut:", keyEquivalent: "x", modifierMask: [.command]),
                NSMenuItem(title: "Copy", action: "copy:", keyEquivalent: "c", modifierMask: [.command]),
                NSMenuItem(title: "Paste", action: "paste:", keyEquivalent: "v", modifierMask: [.command]),
                NSMenuItem(title: "Paste and Match Style", action: "pasteAsPlainText:", keyEquivalent: "V", modifierMask: [.command, .option]),
                NSMenuItem(title: "Delete", action: "delete:", keyEquivalent: "\u{8}"/*backspace*/),
                NSMenuItem(title: "Select All", action: "selectAll:", keyEquivalent: "a", modifierMask: [.command]),
                NSMenuItem.separator(),
                NSMenuItem(title: "Find", [
                    NSMenuItem(title: "Find…", action: "performFindPanelAction:", keyEquivalent: "f", modifierMask: [.command]),
                    NSMenuItem(title: "Find and Replace…", action: "performFindPanelAction:", keyEquivalent: "f", modifierMask: [.command, .option]),
                    NSMenuItem(title: "Find Next", action: "performFindPanelAction:", keyEquivalent: "g", modifierMask: [.command]),
                    NSMenuItem(title: "Find Previous", action: "performFindPanelAction:", keyEquivalent: "G", modifierMask: [.command]),
                    NSMenuItem(title: "Use Selection for Find", action: "performFindPanelAction:", keyEquivalent: "e", modifierMask: [.command]),
                    NSMenuItem(title: "Jump to Selection", action: "centerSelectionInVisibleArea:", keyEquivalent: "j", modifierMask: [.command]),
                ]),
                NSMenuItem(title: "Spelling and Grammar", [
                    NSMenuItem(title: "Show Spelling and Grammar", action: "showGuessPanel:", keyEquivalent: ":", modifierMask: [.command]),
                    NSMenuItem(title: "Check Document Now", action: "checkSpelling:", keyEquivalent: ";", modifierMask: [.command]),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Check Spelling While Typing", action: "toggleContinuousSpellChecking:"),
                    NSMenuItem(title: "Check Grammar With Spelling", action: "toggleGrammarChecking:"),
                    NSMenuItem(title: "Correct Spelling Automatically", action: "toggleAutomaticSpellingCorrection:"),
                ]),
                NSMenuItem(title: "Substitutions", [
                    NSMenuItem(title: "Show Substitutions", action: "orderFrontSubstitutionsPanel:"),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Smart Copy/Paste", action: "toggleSmartInsertDelete:"),
                    NSMenuItem(title: "Smart Quotes", action: "toggleAutomaticQuoteSubstitution:"),
                    NSMenuItem(title: "Smart Dashes", action: "toggleAutomaticDashSubstitution:"),
                    NSMenuItem(title: "Smart Links", action: "toggleAutomaticLinkDetection:"),
                    NSMenuItem(title: "Data Detectors", action: "toggleAutomaticDataDetection:"),
                    NSMenuItem(title: "Text Replacement", action: "toggleAutomaticTextReplacement:"),
                ]),
                NSMenuItem(title: "Transformations", [
                    NSMenuItem(title: "Make Upper Case", action: "uppercaseWord:"),
                    NSMenuItem(title: "Make Lower Case", action: "lowercaseWord:"),
                    NSMenuItem(title: "Capitalize", action: "capitalizeWord:"),
                ]),
                NSMenuItem(title: "Speech", [
                    NSMenuItem(title: "Start Speaking", action: "startSpeaking:"),
                    NSMenuItem(title: "Stop Speaking", action: "stopSpeaking:"),
                ]),
                NSMenuItem.separator(),
                NSMenuItem(title: "Start Dictation…", target: NSApplication.shared, action: "startDictation:", modifierMask: [.command]),
                NSMenuItem(title: "Emoji & Symbols", action: "orderFrontCharacterPalette:", keyEquivalent: " ", modifierMask: [.command, .control]),
            ]),
            NSMenuItem(title: "Format", [
                NSMenuItem(title: "Font", [
                    NSMenuItem(title: "Show Fonts", target: NSFontManager.shared, action: "orderFrontFontPanel:", keyEquivalent: "t", modifierMask: [.command]),
                    NSMenuItem(title: "Bold", target: NSFontManager.shared, action: "addFontTrait:", keyEquivalent: "b", modifierMask: [.command]),
                    NSMenuItem(title: "Italic", target: NSFontManager.shared, action: "addFontTrait:", keyEquivalent: "i", modifierMask: [.command]),
                    NSMenuItem(title: "Underline", action: "underline:", keyEquivalent: "u", modifierMask: [.command]),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Bigger", target: NSFontManager.shared, action: "modifyFont:", keyEquivalent: "+", modifierMask: [.command]),
                    NSMenuItem(title: "Smaller", target: NSFontManager.shared, action: "modifyFont:", keyEquivalent: "-", modifierMask: [.command]),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Kern", [
                        NSMenuItem(title: "Use Default", action: "useStandardKerning:"),
                        NSMenuItem(title: "Use None", action: "turnOffKerning:"),
                        NSMenuItem(title: "Tighten", action: "tightenKerning:"),
                        NSMenuItem(title: "Loosen", action: "loosenKerning:"),
                    ]),
                    NSMenuItem(title: "Ligatures", [
                        NSMenuItem(title: "Use Default", action: "useStandardLigatures:"),
                        NSMenuItem(title: "Use None", action: "turnOffLigatures:"),
                        NSMenuItem(title: "Use All", action: "useAllLigatures:"),
                    ]),
                    NSMenuItem(title: "Baseline", [
                        NSMenuItem(title: "Use Default", action: "unscript:"),
                        NSMenuItem(title: "Superscript", action: "superscript:"),
                        NSMenuItem(title: "Subscript", action: "subscript:"),
                        NSMenuItem(title: "Raise", action: "raiseBaseline:"),
                        NSMenuItem(title: "Lower", action: "lowerBaseline:"),
                    ]),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Show Colors", action: "orderFrontColorPanel:", keyEquivalent: "C", modifierMask: [.command]),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Copy Style", action: "copyFont:", keyEquivalent: "c", modifierMask: [.command, .option]),
                    NSMenuItem(title: "Paste Style", action: "pasteFont:", keyEquivalent: "v", modifierMask: [.command, .option]),
                ]),
                NSMenuItem(title: "Text", [
                    NSMenuItem(title: "Align Left", action: "alignLeft:", keyEquivalent: "{", modifierMask: [.command]),
                    NSMenuItem(title: "Center", action: "alignCenter:", keyEquivalent: "|", modifierMask: [.command]),
                    NSMenuItem(title: "Justify", action: "alignJustified:"),
                    NSMenuItem(title: "Align Right", action: "alignRight:", keyEquivalent: "}", modifierMask: [.command]),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Writing Direction", [
                        NSMenuItem(title: "Paragraph"),
                        NSMenuItem(title: "\tDefault", action: "makeBaseWritingDirectionNatural:"),
                        NSMenuItem(title: "\tLeft to Right", action: "makeBaseWritingDirectionLeftToRight:"),
                        NSMenuItem(title: "\tRight to Left", action: "makeBaseWritingDirectionRightToLeft:"),
                        NSMenuItem.separator(),
                        NSMenuItem(title: "Selection"),
                        NSMenuItem(title: "\tDefault", action: "makeTextWritingDirectionNatural:"),
                        NSMenuItem(title: "\tLeft to Right", action: "makeTextWritingDirectionLeftToRight:"),
                        NSMenuItem(title: "\tRight to Left", action: "makeTextWritingDirectionRightToLeft:"),
                    ]),
                    NSMenuItem.separator(),
                    NSMenuItem(title: "Show Ruler", action: "toggleRuler:"),
                    NSMenuItem(title: "Copy Ruler", action: "copyRuler:", keyEquivalent: "c", modifierMask: [.command, .control]),
                    NSMenuItem(title: "Paste Ruler", action: "pasteRuler:", keyEquivalent: "v", modifierMask: [.command, .control]),
                ]),
            ]),
            NSMenuItem(title: "View", [
                NSMenuItem(title: "Show Toolbar", action: "toggleToolbarShown:", keyEquivalent: "t", modifierMask: [.command, .option]),
                NSMenuItem(title: "Customize Toolbar…", action: "runToolbarCustomizationPalette:"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Show Sidebar", action: "toggleSourceList:", keyEquivalent: "s", modifierMask: [.command, .control]),
                NSMenuItem(title: "Enter Full Screen", action: "toggleFullScreen:", keyEquivalent: "f", modifierMask: [.command, .control]),
            ]),
            NSMenuItem(title: "Window", [
                NSMenuItem(title: "Minimize", action: "performMiniaturize:", keyEquivalent: "m", modifierMask: [.command]),
                NSMenuItem(title: "Zoom", action: "performZoom:"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Bring All to Front", action: "arrangeInFront:"),
                NSMenuItem.separator(),
                NSMenuItem(title: "Conversations", action: "showConversations:"),
                NSMenuItem(title: "Directory", action: "showDirectory:"),
                NSMenuItem.separator(),
            ]),
            NSMenuItem(title: "Help", [
                NSMenuItem(title: "\(appName) Help", action: "showHelp:", keyEquivalent: "?", modifierMask: [.command]),
            ]),
        ])
        
        NSApp.mainMenu = appMenu.submenu!
        NSApp.servicesMenu = appMenu.submenu!.items.first!.submenu!.item(withTitle: "Services")!.submenu!
        NSApp.windowsMenu = appMenu.submenu!.item(withTitle: "Window")!.submenu!
        NSApp.helpMenu = appMenu.submenu!.item(withTitle: "Help")!.submenu!
=======
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
		NSWorkspace.shared().open(URL(string: "https://gitreports.com/issue/avaidyam/Parrot")!)
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
    a.window.enableRealTitlebarVibrancy(.behindWindow) // FIXME
    if a.runModal() == 1000 /*NSAlertFirstButtonReturn*/ {
        NSWorkspace.shared().open(release.githubURL)
>>>>>>> Stashed changes
    }
}
