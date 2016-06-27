import Foundation

/* TODO: More extensive support for Keychain attributes. */
/* TODO: InternetSettings to wrap SecKeychain*InternetPassword. */

/// A KeyValueStore is a container layer that stores values for given keys.
public protocol KeyValueStore {
	subscript(key: String) -> AnyObject? { get set }
}

/// A KeyValueStore that supports specific application-defined domains.
public protocol DomainSpecificKeyValueStore: KeyValueStore {
	subscript(key: String, domain domain: String) -> AnyObject? { get set }
}

/// A KeyValueStore that encodes its contents in the OS defaults database.
public final class SettingsStore: DomainSpecificKeyValueStore {
	private init() {}
	
	/// Set or get a  key's value with the default domain (global search list).
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String) -> AnyObject? {
		get {
			return UserDefaults.standard().value(forKey: key)
		}
		set (value) {
			UserDefaults.standard().setValue(value, forKey: key)
		}
	}
	
	/// Set or get a key's value with a custom specified domain.
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String, domain domain: String) -> AnyObject? {
		get {
			return UserDefaults(suiteName: domain)?.value(forKey: key)
		}
		set (value) {
			UserDefaults(suiteName: domain)?.setValue(value, forKey: key)
		}
	}
}

/// A KeyValueStore that securely encodes its contents in the OS keychain.
public final class SecureSettingsStore: DomainSpecificKeyValueStore {
	private init() {}
	private var _defaultDomain = Bundle.main().bundleIdentifier ?? "SecureSettings:ERR"
	
	/// Set or get a secure key's value with the default domain (the bundle identifier).
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String) -> AnyObject? {
		get {
			return self[key, domain: _defaultDomain]
		}
		set (value) {
			self[key, domain: _defaultDomain] = value
		}
	}
	
	/// Set or get a secure key's value with a custom specified domain.
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String, domain domain: String) -> AnyObject? {
		get {
			var passwordLength: UInt32 = 0
			var passwordPtr: UnsafeMutablePointer<Void>? = nil
			let status = SecKeychainFindGenericPassword(nil,
			                                            UInt32(domain.utf8.count), domain,
			                                            UInt32(key.utf8.count), key,
			                                            &passwordLength, &passwordPtr,
			                                            nil)
			if status == OSStatus(errSecSuccess) {
				return NSString(bytes: passwordPtr!,
				                length: Int(passwordLength),
				                encoding: String.Encoding.utf8.rawValue)
			} else { return nil }
		}
		set (_value) {
			if _value == nil {
				var itemRef: SecKeychainItem? = nil
				let status = SecKeychainFindGenericPassword(nil,
				                                            UInt32(domain.utf8.count), domain,
				                                            UInt32(key.utf8.count), key,
				                                            nil, nil, &itemRef)
				if let item = itemRef where status == OSStatus(errSecSuccess) {
					SecKeychainItemDelete(item)
				}
			} else {
				guard let value = _value as? String else { return }
				SecKeychainAddGenericPassword(nil,
				                              UInt32(domain.utf8.count), domain,
				                              UInt32(key.utf8.count), key,
				                              UInt32(value.utf8.count), value,
				                              nil)
			}
		}
	}
}

/// A KeyValueStore that encodes its contents in the user's iCloud database.
/// Note: UbiqutousStore does not support domains.
public final class UbiquitousStore: KeyValueStore {
	private init() {}
	
	public subscript(key: String) -> AnyObject? {
		get {
			NSUbiquitousKeyValueStore.default().synchronize()
			return NSUbiquitousKeyValueStore.default().object(forKey: key)
		}
		set(value) {
			NSUbiquitousKeyValueStore.default().set(value, forKey: key)
			NSUbiquitousKeyValueStore.default().synchronize()
		}
	}
}

/// Aliased singleton for SettingsStore.
public let Settings = SettingsStore()

/// Aliased singleton for SecureSettingsStore.
public let SecureSettings = SecureSettingsStore()

/// Aliased singleton for UbiquitousStore.
public let CloudSettings = UbiquitousStore()
