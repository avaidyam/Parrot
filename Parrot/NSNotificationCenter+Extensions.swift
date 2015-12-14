import Foundation

public extension NSNotificationCenter {
	
	@nonobjc public static let Notifications = NSNotificationCenter.defaultCenter()
	
	public class func postNote(notification: NSNotification) {
		Notifications.postNotification(notification)
	}
	
	public class func post(name: String, object: AnyObject, userInfo: [NSObject: AnyObject]) {
		Notifications.postNotificationName(name, object: object, userInfo: userInfo)
	}
	
	public class func post(name: String, object: AnyObject) {
		Notifications.postNotificationName(name, object: object)
	}
	
	public class func post(name: String) {
		Notifications.postNotificationName(name, object: nil)
	}
	
	public class func subscribe(name: String, block: (NSNotification -> Void)) -> NSObjectProtocol {
		return Notifications.addObserverForName(name, object: nil, queue: nil) { notification in
			block(notification)
		}
	}
	
	public class func subscribe(observer: AnyObject, name: String, selector: Selector) {
		return Notifications.addObserver(observer, selector: selector, name: name, object: nil)
	}
	
	public class func subscribe(observer: AnyObject, _ notifications: [String: Selector]) {
		for (name, selector) in notifications {
			subscribe(observer, name: name, selector: selector)
		}
	}
	
	public class func unsubscribe(token: NSObjectProtocol) {
		Notifications.removeObserver(token)
	}
	
	public class func unsubscribe(observer: AnyObject, name: String) {
		return Notifications.removeObserver(observer, name: name, object: nil)
	}
	
	public class func unsubscribe(observer: AnyObject, _ names: [String]) {
		for name in names {
			unsubscribe(observer, name: name)
		}
	}
	
	public class func unsubscribeAll(observer: AnyObject) {
		Notifications.removeObserver(observer)
	}
}
