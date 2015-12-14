import Foundation

/**
Allows the use of a shorthand notification syntax:
	`Notifications.post("MyNote")`
Also has the benefit of not dealing with NSNotification.
*/

@nonobjc public let Notifications = NSNotificationCenter.defaultCenter()
public typealias Event = NSNotification
public typealias NotificationToken = NSObjectProtocol
public extension NSNotificationCenter {
	
	/* POST */
	
	public func post(name: String, object: AnyObject, userInfo: [NSObject: AnyObject]) {
		postNotificationName(name, object: object, userInfo: userInfo)
	}
	
	public func post(name: String, object: AnyObject) {
		postNotificationName(name, object: object)
	}
	
	public func post(name: String) {
		postNotificationName(name, object: nil)
	}
	
	/* SUBSCRIBE */
	
	public func subscribe(name: String, block: (Event -> Void)) -> NotificationToken {
		return addObserverForName(name, object: nil, queue: nil) { notification in
			block(notification)
		}
	}
	
	public func subscribe(notifications: [String: (Event -> Void)]) -> [NotificationToken] {
		var tokens: [NotificationToken] = []
		for (name, block) in notifications {
			tokens.append(addObserverForName(name, object: nil, queue: nil) { notification in
				block(notification)
			})
		}
		return tokens
	}
	
	/* UNSUBSCRIBE */
	
	public func unsubscribe(observer: AnyObject) {
		removeObserver(observer)
	}
	
	public func unsubscribe(observer: AnyObject, name: String) {
		removeObserver(observer, name: name, object: nil)
	}
	
	public func unsubscribe(observer: AnyObject, _ names: [String]) {
		for name in names {
			removeObserver(observer, name: name, object: nil)
		}
	}
}
