import Cocoa
import Hangouts
import WebKit
import ParrotServiceExtension

/* TODO: Support /cmd's (i.e. /remove <username>) for power-users. */
/* TODO: Support Slack-like plugin integrations. */

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "com.avaidyam.Parrot.global")
public let defaultUserImage = NSImage(named: "NSUserGuest")!

// Existing Parrot Settings keys.
public final class Parrot {
	public static let InterfaceStyle = "Parrot.InterfaceStyle"
	public static let SystemInterfaceStyle = "Parrot.SystemInterfaceStyle"
	
	public static let AutoEmoji = "Parrot.AutoEmoji"
	public static let InvertChatStyle = "Parrot.InvertChatStyle"
	public static let ShowSidebar = "Parrot.ShowSidebar"
	
	public static let VibrateForceTouch = "Parrot.VibrateForceTouch"
	public static let VibrateInterval = "Parrot.VibrateInterval"
	public static let VibrateLength = "Parrot.VibrateLength"
}

@NSApplicationMain
public class ServiceManager: ApplicationController {
	
	private var trans: WindowTransitionAnimator? = nil
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(_ notification: Notification) {
		log.verbose("Initializing Parrot...")
		AppActivity.start("Authenticate")
		Authenticator.authenticateClient {
			let c = Client(configuration: $0)
			AppActivity.end("Authenticate")
			
			NotificationCenter.default()
				.addObserver(forName: Client.didConnectNotification, object: c, queue: nil) { _ in
					AppActivity.start("Setup")
					c.buildUserConversationList {
						AppActivity.end("Setup")
						ServiceRegistry.add(service: c)
					}
			}
			_ = c.connect()
			
			// Instantiate storyboard and controller and begin the UI from here.
			DispatchQueue.main.async {
				let vc = ConversationsViewController(nibName: "ConversationsViewController", bundle: nil)
				vc?.selectionProvider = { row in
					let vc2 = ConversationViewController(nibName: "ConversationViewController", bundle: nil)
					let ic = vc?.conversationList?.conversations[row]
					vc2?.representedObject = ic
					vc?.presentViewController(vc2!, animator: WindowTransitionAnimator { w in
						w.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView]
						w.collectionBehavior = [.managed, .participatesInCycle, .fullScreenAuxiliary, .fullScreenDisallowsTiling]
						w.appearance = ParrotAppearance.current()
						w.enableRealTitlebarVibrancy()
						
						// Because autosave is miserable.
						w.setFrameAutosaveName("\(ic!.conversation.conversationId!.id!)")
						if w.frame == .zero {
							w.setFrame(NSRect(x: 0, y: 0, width: 480, height: 320), display: false, animate: true)
							w.center()
						}
					})
				}
				
				// The .titlebar material has no transluency in dark appearances, and
				// has a standard window gradient in light ones.
				self.trans = WindowTransitionAnimator { w in
					w.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView]
					w.collectionBehavior = [.managed, .participatesInCycle, .fullScreenPrimary, .fullScreenAllowsTiling]
					w.appearance = ParrotAppearance.current()
					w.enableRealTitlebarVibrancy()
					
					// Because autosave is miserable.
					w.setFrameAutosaveName("Conversations")
					if w.frame == .zero {
						w.setFrame(NSRect(x: 0, y: 0, width: 386, height: 512), display: false, animate: true)
						w.center()
					}
				}
				self.trans!.displayViewController(vc!)
			}
		}
	}
	
	// So clicking on the dock icon actually shows the window again.
	func applicationShouldHandleReopen(sender: NSApplication, flag: Bool) -> Bool {
		self.trans?.showWindow(nil)
		return true
	}
	
	// We need to provide a useful dock menu.
	/* TODO: Provide a dock menu for options. */
	func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
		return nil
	}
	
	@IBAction func logoutSelected(_ sender: AnyObject) {
		let cookieStorage = HTTPCookieStorage.shared()
		if let cookies = cookieStorage.cookies {
			for cookie in cookies {
				cookieStorage.deleteCookie(cookie)
			}
		}
		Authenticator.clearTokens();
		NSApplication.shared().terminate(self)
	}
}
