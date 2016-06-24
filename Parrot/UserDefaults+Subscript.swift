import Foundation

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
