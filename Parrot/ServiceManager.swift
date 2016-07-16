import Cocoa
import Hangouts
import WebKit
import ParrotServiceExtension

@NSApplicationMain
public class ServiceManager: NSApplicationController {
	
	private var windowController: NSWindowController? = nil
	
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
			_ = c.connect() {_ in}
			
			// Instantiate storyboard and controller and begin the UI from here.
			DispatchQueue.main.async {
				self.windowController = ConversationListViewController.display()
			}
		}
	}
	
	// So clicking on the dock icon actually shows the window again.
	func applicationShouldHandleReopen(sender: NSApplication, flag: Bool) -> Bool {
		self.windowController?.showWindow(nil)
		return true
	}
	
	// We need to provide a useful dock menu.
	/* TODO: Provide a dock menu for options. */
	func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
		let menu = NSMenu(title: "Parrot")
		menu.addItem(title: "Open Conversations") {
			log.info("Open Conversations")
			self.windowController?.showWindow(nil)
		}
		return menu
	}
	
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
}
