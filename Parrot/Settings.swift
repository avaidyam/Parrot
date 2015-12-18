import Foundation

public func Settings(domain: String? = nil) -> NSUserDefaults {
	return NSUserDefaults(suiteName: domain)!
}

public extension NSUserDefaults {
	
	public class func set(key: String, value: AnyObject?, domain: String? = nil) {
		NSUserDefaults(suiteName: domain)?.setValue(value, forKey: key)
	}
	
	public class func get(key: String, domain: String? = nil) -> AnyObject? {
		return NSUserDefaults(suiteName: domain)?.valueForKey(key)
	}
	
	public class func set(keys: [String: AnyObject?], domain: String? = nil) {
		keys.forEach { key, value in
			NSUserDefaults(suiteName: domain)?.setValue(value, forKey: key)
		}
	}
	
	public class func get(keys: [String], domain: String? = nil) -> [String: AnyObject?] {
		var map = [String: AnyObject?]()
		for (key) in keys {
			map[key] = NSUserDefaults(suiteName: domain)?.valueForKey(key)
		}
		return map
	}
	
	subscript(key: String) -> AnyObject? {
		get {
			return self.valueForKey(key)
		}
		set (value) {
			self.setValue(value, forKey: key)
		}
	}
}

/*
private var _observers = [SettingsObserver]()
private class SettingsObserver : NSObject {
	private var path: String = ""
	private var ctx = 0
	private var action: (AnyObject? -> Void) = {a in }
	
	required init(path: String, action: (AnyObject? -> Void)) {
		super.init()
		self.path = "values." + path
		self.action = action
		
		print("obs path \(self.path)")
		
		NSUserDefaultsController.sharedUserDefaultsController().addObserver(self,
			forKeyPath: self.path, options: .New, context: nil)
	}
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
		change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
			print("got \(path)")
			if let newValue = change?[NSKeyValueChangeNewKey] {
				print("got \(newValue)")
				action(newValue)
			}
	}
	
	deinit {
		NSUserDefaultsController.sharedUserDefaultsController().removeObserver(self,
			forKeyPath: self.path, context: nil)
		print("dead")
	}
}
*/
