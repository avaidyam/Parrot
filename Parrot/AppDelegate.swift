import Cocoa
import Hangouts

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	private var controller: AnyObject? = nil
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(notification: NSNotification) {
		Authenticator.authenticateClient {
			_hangoutsClient = Client(configuration: $0)
			Dispatch.main().add {
				
				// Instantiate and begin the UI from here.
				let s = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle())
				self.controller = s.instantiateControllerWithIdentifier("Main")
				(self.controller as! NSWindowController).showWindow(nil)
			}
		}
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
