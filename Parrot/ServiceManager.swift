import Cocoa
import Hangouts

@NSApplicationMain
class ServiceManager: NSObject, NSApplicationDelegate{
	
	private var windowController: NSWindowController? = nil
	private var trans: WindowTransitionAnimator? = nil
	
	// First begin authentication and setup for any services.
	func applicationWillFinishLaunching(notification: NSNotification) {
		Authenticator.authenticateClient {
			_hangoutsClient = Client(configuration: $0)
			_hangoutsClient?.connect()
			
			NSNotificationCenter.defaultCenter()
				.addObserverForName(Client.didConnectNotification, object: _hangoutsClient!, queue: nil) { _ in
					_hangoutsClient!.buildUserConversationList { (userList, conversationList) in
						_REMOVE.forEach {
							$0(userList, conversationList)
						}
					}
			}
			
			// Instantiate storyboard and controller and begin the UI from here.
			Dispatch.main().add {
				let s = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle())
				let vc = s.instantiateControllerWithIdentifier("Conversations") as! ConversationsViewController
				self.trans = WindowTransitionAnimator()
				self.trans!.displayViewController(vc)
				
				/*
				let s = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle())
				self.windowController = s.instantiateControllerWithIdentifier("Main") as? NSWindowController
				self.windowController?.showWindow(nil)
				*/
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

// Private service points go here:
private var _hangoutsClient: Client? = nil

/* TODO: SHOULD NOT BE USED. */
public typealias _RM2 = (UserList, ConversationList) -> Void
public var _REMOVE = [_RM2]()

// In the future, this will be an extensible service point for all services.
public extension NSApplication {
	
	// Provides a global Hangouts.Client service point.
	public var hangoutsClient: Hangouts.Client? {
		get {
			return _hangoutsClient
		}
	}
}
