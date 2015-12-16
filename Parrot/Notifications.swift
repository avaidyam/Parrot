import Foundation

/**
Allows the use of a shorthand notification syntax:
	`Notifications.post("MyNote")`
Also has the benefit of not dealing with NSNotification.
*/

public typealias Notifications = NSNotificationCenter
public typealias Notification = NSNotification
public typealias TokenObserver = NSObjectProtocol
private let _note = NSNotificationCenter.defaultCenter()

public extension NSNotificationCenter {
	
	/* POST */
	
	public class func post(name: String, object: AnyObject, userInfo: [NSObject: AnyObject]) {
		_note.postNotificationName(name, object: object, userInfo: userInfo)
	}
	
	public class func post(name: String, object: AnyObject) {
		_note.postNotificationName(name, object: object)
	}
	
	public class func post(name: String) {
		_note.postNotificationName(name, object: nil)
	}
	
	/* SUBSCRIBE */
	
	public class func subscribe(name: String, block: (Notification -> Void)) -> TokenObserver {
		return _note.addObserverForName(name, object: nil, queue: nil) { notification in
			block(notification)
		}
	}
	
	public class func subscribe(notifications: [String: (Notification -> Void)]) -> [TokenObserver] {
		var tokens: [TokenObserver] = []
		for (name, block) in notifications {
			tokens.append(_note.addObserverForName(name, object: nil, queue: nil) { notification in
				block(notification)
			})
		}
		return tokens
	}
	
	/* UNSUBSCRIBE */
	
	public class func unsubscribe(observer: AnyObject) {
		_note.removeObserver(observer)
	}
	
	public class func unsubscribe(observer: AnyObject, name: String) {
		_note.removeObserver(observer, name: name, object: nil)
	}
	
	public class func unsubscribe(observer: AnyObject, _ names: [String]) {
		for name in names {
			_note.removeObserver(observer, name: name, object: nil)
		}
	}
}
