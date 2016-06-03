import Foundation

public func Settings(domain: String? = nil) -> NSUserDefaults {
	return NSUserDefaults(suiteName: domain)!
}

public extension NSUserDefaults {
	
	// Set a settings key with a given non-nil value.
	// If the value is nil, the key will be removed.
	public func set(key: String, value: AnyObject?, domain: String? = nil) {
		self.setValue(value, forKey: key)
	}
	
	public func get(key: String, domain: String? = nil) -> AnyObject? {
		return self.value(forKey: key)
	}
	
	// Utility for setting multiple settings at a time.
	public func set(keys: [String: AnyObject?], domain: String? = nil) {
		keys.forEach { key, value in
			self.setValue(value, forKey: key)
		}
	}
	
	// Utility for getting multiple settings at a time.
	/* TODO: Replace with a map from an array to a dictionary. */
	public func get(keys: [String], domain: String? = nil) -> [String: AnyObject?] {
		var map = [String: AnyObject?]()
		for (key) in keys {
			map[key] = self.value(forKey: key)
		}
		return map
	}
	
	// Allows shorter syntax, like so: Settings()["Test"] = 42
	subscript(key: String) -> AnyObject? {
		get {
			return self.value(forKey: key)
		}
		set (value) {
			self.setValue(value, forKey: key)
		}
	}
}
