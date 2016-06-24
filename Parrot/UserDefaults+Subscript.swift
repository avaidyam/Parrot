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

public extension UserDefaults {
	
	public class func add(observer object: AnyObject, forKey name: String, handler: (Void) -> Void) {
		KVOTrampoline.create(object: object, name: name, block: handler)
	}
	
	public class func remove(observer object: AnyObject, forKey name: String) {
		KVOTrampoline.remove(object: object, name: name)
	}
}

/* TODO: This works with UserDefaults too, but not very well... fix it at some point. */
public final class KVOTrampoline: NSObject {
	private let object: AnyObject
	private let name: String
	private let block: (Void) -> Void
	
	required public init(object: AnyObject, name: String, block: (Void) -> Void) {
		self.object = object
		self.name = name
		self.block = block
		
		super.init()
		NSUserDefaultsController.shared().addObserver(self, forKeyPath: "values." + name, options: .new, context: nil)
	}
	
	deinit {
		NSUserDefaultsController.shared().removeObserver(self, forKeyPath: self.name)
	}
	
	public static var _trampolines = [String: [KVOTrampoline]]()
	
	public static func create(object: AnyObject, name: String, block: (Void) -> Void) {
		if _trampolines[name] == nil {
			_trampolines[name] = []
		}
		
		// Create and add a KVO subscriber to monitor.
		_trampolines[name]!.append(KVOTrampoline(object: object, name: name, block: block))
	}
	
	public static func remove(object: AnyObject, name: String) {
		if let subs = _trampolines[name] {
			subs.filter { $0.object === object && $0.name == name }.forEach {
				_trampolines[name]!.remove($0)
			}
		}
	}
	
	public override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?,
	                                   change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
		guard let o = object as? NSObject where o === NSUserDefaultsController.shared() else { return }
		guard let k = keyPath where k == "values." + self.name else { return }
		
		// If we have the right UserDefaults and keyPath, we're good to go.
		self.block()
	}
}
