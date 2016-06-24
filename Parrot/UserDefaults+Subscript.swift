import Cocoa

/// Settings is a subscripting-only alias for NS/UserDefaults, and can be used like so:
///
/// let myValue = Settings["myKey"]	// get
/// Settings["myKey"] = myValue // set
/// Settings["myKey"] = nil // remove
public let Settings = _Settings()
public final class _Settings {
	private init() {}
	
	/// Quick access subscripting for NS/UserDefaults.
	subscript(key: String) -> AnyObject? {
		get {
			return UserDefaults.standard().value(forKey: key)
		}
		set (value) {
			UserDefaults.standard().setValue(value, forKey: key)
		}
	}
	
	/// Quick access subscripting for NS/UserDefaults with domain support.
	/// Note: Use this sparingly as it is not cached and might be expensive.
	subscript(key: String, domain domain: String) -> AnyObject? {
		get {
			return UserDefaults(suiteName: domain)?.value(forKey: key)
		}
		set (value) {
			UserDefaults(suiteName: domain)?.setValue(value, forKey: key)
		}
	}
}

/*
private let UserDefaultsTrampoline = KVOTrampoline(observeOn: UserDefaults.standard()) {
	print("DEFAULT UPDATE!")
}
private let CocoaBindingsTrampoline = KVOTrampoline(observeOn: NSUserDefaultsController.shared()) {
	print("BINDING UPDATE!")
}
public extension UserDefaults {
	
	public class func add(observer object: AnyObject, forKey name: String, handler: (Void) -> Void) {
		//KVOTrampoline.create(object: object, name: name, block: handler)
		UserDefaultsTrampoline.observe(keyPath: name)
		CocoaBindingsTrampoline.observe(keyPath: "values." + name)
	}
	
	public class func remove(observer object: AnyObject, forKey name: String) {
		//KVOTrampoline.remove(object: object, name: name)
		UserDefaultsTrampoline.release(keyPath: name)
		CocoaBindingsTrampoline.observe(keyPath: "values." + name)
	}
}
*/

/// Completely dysfunctional with UserDefaults for some insane reason.
public final class KVOTrampoline: NSObject {
	private let refObject: NSObject
	private let refAction: (Void) -> Void
	private var refCounts = [String: UInt]()
	
	public required init(observeOn object: NSObject, perform handler: (Void) -> Void) {
		self.refObject = object
		self.refAction = handler
	}
	
	public func observe(keyPath: String) {
		if (self.refCounts[keyPath] ?? 0) == 0 {
			self.refObject.addObserver(self, forKeyPath: keyPath, options: [.initial, .new], context: nil)
		}
		self.refCounts[keyPath] = (self.refCounts[keyPath] ?? 0) + 1
	}
	
	public func release(keyPath: String) {
		self.refCounts[keyPath] = (self.refCounts[keyPath] ?? 0) - 1
		if (self.refCounts[keyPath] ?? 0) == 0 {
			self.refObject.removeObserver(self, forKeyPath: keyPath)
		}
	}
	
	public override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?,
	                                  change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
		guard let o = object where o === self.refObject else { return }
		guard let k = keyPath where self.refCounts.keys.contains(k) else { return }
		self.refAction()
	}
}

