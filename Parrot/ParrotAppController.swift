import Cocoa
import Hangouts
import WebKit
import ParrotServiceExtension

/* TODO: Replace login/logout with removal of account from Preferences. */

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "com.avaidyam.Parrot.global")

// Existing Parrot Settings keys.
public enum Parrot {
	public static let InterfaceStyle = "Parrot.InterfaceStyle"
	public static let SystemInterfaceStyle = "Parrot.SystemInterfaceStyle"
	public static let VibrancyStyle = "Parrot.VibrancyStyle"
	
	public static let AutoEmoji = "Parrot.AutoEmoji"
	public static let MessageTextSize = "Parrot.MessageTextSize"
	public static let Emoticons = "Parrot.Emoticons"
	public static let Completions = "Parrot.Completions"
	
	public static let VibrateForceTouch = "Parrot.VibrateForceTouch"
	public static let VibrateInterval = "Parrot.VibrateInterval"
	public static let VibrateLength = "Parrot.VibrateLength"
}

@NSApplicationMain
public class ParrotAppController: NSApplicationController {
	
	/// Lazy-init for the main conversations NSWindowController.
	private lazy var conversationsController: NSWindowController = {
		ConversationListViewController(windowNibName: "ConversationListViewController")
	}()
	
	public static override func initialize() {
		NSDrawer.__activateModernDrawers()
	}
	
	public override init() {
		super.init()
		
		// Check for updates if any are available.
		checkForUpdates("v0.6-alpha") {
			NSWorkspace.shared().open($0.githubURL)
		}
		
		// Register for AppleEvents that follow our URL scheme.
		NSAppleEventManager.shared().setEventHandler(self,
			andSelector: #selector(self.handleURL(event:withReply:)),
			forEventClass: UInt32(kInternetEventClass),
			andEventID: UInt32(kAEGetURL)
		)
		
		// Register the default completions if none are in the user settings.
		if let c = Settings[Parrot.Completions] as? NSDictionary where c.count > 0 {} else {
			let defaultC = ["(": ")", "[": "]", "{": "}", "\"": "\"", "`": "`", "*": "*", "_": "_", "-": "-", "~": "~"]
			Settings[Parrot.Completions] = defaultC
		}
		
	}
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(_ notification: Notification) {
		
		log.verbose("Initializing Parrot...")
		//AppActivity.start("Authenticate")
		Authenticator.authenticateClient {
			let c = Client(configuration: $0)
			//AppActivity.end("Authenticate")
			
			NotificationCenter.default()
				.addObserver(forName: Client.didConnectNotification, object: c, queue: nil) { _ in
					//AppActivity.start("Setup")
					c.buildUserConversationList {
						//AppActivity.end("Setup")
						ServiceRegistry.add(service: c)
					}
			}
			_ = c.connect() {_ in}
			
			self.conversationsController.showWindow()
		}
	}
	
	/// If the Conversations window is closed, tapping the dock icon will reopen it.
	func applicationShouldHandleReopen(sender: NSApplication, flag: Bool) -> Bool {
		self.conversationsController.showWindow()
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
			let name = url.lastPathComponent?.removingPercentEncoding ?? ""
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
			self.conversationsController.showWindow()
		}
		menu.addItem(withTitle: "Log Out...",
		             action: #selector(self.logoutSelected(_:)),
		             keyEquivalent: "")
		return menu
	}
	
	/// If the user requests logging out, clear the authentication tokens.
	@IBAction func logoutSelected(_ sender: AnyObject) {
		let cookieStorage = HTTPCookieStorage.shared()
		if let cookies = cookieStorage.cookies {
			for cookie in cookies {
				cookieStorage.deleteCookie(cookie)
			}
		}
		Authenticator.clearTokens()
		NSApplication.shared().terminate(self)
	}
	
	@IBAction func feedback(_ sender: AnyObject?) {
		NSWorkspace.shared().open(URL(string: "https://gitreports.com/issue/avaidyam/Parrot")!)
	}
}


