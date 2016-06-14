import Foundation

/**
Allows the use of a shorthand notification syntax:
	`Notifications.post("MyNote")`
Also has the benefit of not dealing with NSNotification.
*/

public typealias TokenObserver = NSObjectProtocol
public typealias Notification = (name: String, object: AnyObject?, userInfo: [NSObject: AnyObject]?)

// 99% of the time, you don't need to create your own notification center.
// Here's a quick alias for the default one, which is shorter to type.
public let Notifications = NotificationCenter.default()

/* TODO: Support the global/Darwin notification center via CF and proxying. */

public extension NotificationCenter {
	
	@discardableResult
	public func subscribe(name: String, object: AnyObject? = nil, block: ((Notification) -> Void)) -> TokenObserver {
		return self.addObserver(forName: NSNotification.Name(rawValue: name), object: object, queue: nil) { n in
			block((n.name.rawValue, n.object, n.userInfo))
		}
	}
	
	public func unsubscribe(observer: AnyObject, name: String? = nil, object: AnyObject? = nil) {
		self.removeObserver(observer, name: name.map { NSNotification.Name(rawValue: $0) }, object: object)
	}
	
	// Utility for subscribing multiple notifications at a time.
	@discardableResult
	public func subscribe(notifications: [String: ((Notification) -> Void)]) -> [TokenObserver] {
		return notifications.map {
			self.subscribe(name: $0, block: $1)
		}
	}
	
	// Utility for unsubscribing multiple notifications at a time.
	public func unsubscribe(observer: AnyObject, _ names: [String]) {
		names.forEach {
			self.unsubscribe(observer: observer, name: $0)
		}
	}
}

// Post a notification like so:  Notifications <- ("Test", self, ["a": 42])
// CAUTION: USE SPARINGLY! Makes little to no sense what's going on in code.
infix operator <- { associativity left precedence 160 }
public func <- (left: NotificationCenter, right: String) {
	left.post(name: NSNotification.Name(rawValue: right), object: nil, userInfo: nil)
}
public func <- (left: NotificationCenter, right: Notification) {
	left.post(name: NSNotification.Name(rawValue: right.name), object: right.object, userInfo: right.userInfo)
}

// Post a notification like so:  ("Test", self, ["a": 42])^+>
// CAUTION: USE SPARINGLY! Makes little to no sense what's going on in code.
// Like, really, it's just a fun experiment. Bad idea...
postfix operator ^+> { }
public postfix func ^+> (right: String) {
	Notifications.post(name: NSNotification.Name(rawValue: right), object: nil, userInfo: nil)
}
public postfix func ^+> (right: Notification) {
	Notifications.post(name: NSNotification.Name(rawValue: right.name), object: right.object, userInfo: right.userInfo)
}
