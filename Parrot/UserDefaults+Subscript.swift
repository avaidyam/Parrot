import Foundation

public extension UserDefaults {
	
	// Set a settings key with a given non-nil value.
	// If the value is nil, the key will be removed.
	public func set(_ key: String, value: AnyObject?, domain: String? = nil) {
		self.setValue(value, forKey: key)
	}
	
	public func get(_ key: String, domain: String? = nil) -> AnyObject? {
		return self.value(forKey: key)
	}
	
	// Utility for setting multiple settings at a time.
	public func set(_ keys: [String: AnyObject?], domain: String? = nil) {
		keys.forEach { key, value in
			self.setValue(value, forKey: key)
		}
	}
	
	// Utility for getting multiple settings at a time.
	public func get(_ keys: [String], domain: String? = nil) -> [String: AnyObject?] {
		var map = [String: AnyObject?]()
		for (key) in keys {
			map[key] = self.value(forKey: key)
		}
		return map
	}
	
	// Allows shorter syntax, like so: UserDefaults.standard()["Test"] = 42
	subscript(key: String) -> AnyObject? {
		get {
			return self.value(forKey: key)
		}
		set (value) {
			self.setValue(value, forKey: key)
		}
	}
}
