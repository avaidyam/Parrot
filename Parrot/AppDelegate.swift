import Cocoa
import Hangouts

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	private var windowController: NSWindowController? = nil
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(notification: NSNotification) {
		Authenticator.authenticateClient {
			_hangoutsClient = Client(configuration: $0)
			Dispatch.main().add {
				
				// Instantiate storyboard and controller and begin the UI from here.
				let s = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle())
				self.windowController = s.instantiateControllerWithIdentifier("Main") as? NSWindowController
				self.windowController?.showWindow(nil)
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
	func applicationDockMenu(sender: NSApplication) -> NSMenu? {
		return nil
	}
}

// In the future, this will be an extensible service point for all services.
public extension NSApplication {
	
	// Provides a global Hangouts.Client service point.
	public var hangoutsClient: Hangouts.Client? {
		get {
			return _hangoutsClient
		}
	}
}

// Private service points go here:
private var _hangoutsClient: Client? = nil
