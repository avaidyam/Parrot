import Foundation

/**
Allows the use of a shorthand notification syntax:
	`NotificationCenter.default().post("MyNote")`
Also has the benefit of not dealing with Notification.
*/
public extension NotificationCenter {
	
	@discardableResult
	public func subscribe(name: String, object: AnyObject? = nil, block: ((Notification) -> Void)) -> NSObjectProtocol {
		return self.addObserver(forName: Notification.Name(rawValue: name), object: object, queue: nil, using: block)
	}
	
	public func unsubscribe(observer: AnyObject, name: String? = nil, object: AnyObject? = nil) {
		self.removeObserver(observer, name: name.map { Notification.Name(rawValue: $0) }, object: object)
	}
	
	// Utility for subscribing multiple notifications at a time.
	@discardableResult
	public func subscribe(notifications: [String: ((Notification) -> Void)]) -> [NSObjectProtocol] {
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
