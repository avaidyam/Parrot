import Foundation

/* TODO: More extensive support for Keychain attributes. */
/* TODO: InternetSettings to wrap SecKeychain*InternetPassword. */

/// A KeyValueStore is a container layer that stores values for given keys
/// and supports specific application-defined or special/protected domains.
public protocol KeyValueStore {
	subscript(key: String) -> Any? { get set }
	subscript(key: String, domain domain: String) -> Any? { get set }
}

/// A KeyValueStore that encodes its contents in the OS defaults database.
public final class SettingsStore: KeyValueStore {
	fileprivate init() {}
	
	/// A special protected SettingsStore domain.
	/// In case this is used as the domain for the SettingsStore, it will read from
	/// the system-wide KeyValueStore internally. It cannot be used to set values.
	public static let globalDomain = UserDefaults.globalDomain
	
	/// A special protected SettingsStore domain.
	/// In the case this is used as the domain for the SettingsStore, it will read
	/// and write from the user's global iCloud KeyValueStore.
	public static let ubiquitousDomain = "SettingsStore.UbiquitousKeyValueDomain"
	
	/// Set or get a  key's value with the default domain (global search list).
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String) -> Any? {
		get {
			return UserDefaults.standard.value(forKey: key)
		}
		set (value) {
			UserDefaults.standard.setValue(value, forKey: key)
		}
	}
	
	/// Set or get a key's value with a custom specified domain.
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String, domain domain: String) -> Any? {
		get {
			if domain == SettingsStore.globalDomain {
				return UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain)?[key]
			} else if domain == SettingsStore.ubiquitousDomain {
				NSUbiquitousKeyValueStore.default().synchronize()
				return NSUbiquitousKeyValueStore.default().object(forKey: key)
			} else {
				return UserDefaults(suiteName: domain)?.value(forKey: key)
			}
		}
		set (value) {
			if domain == SettingsStore.globalDomain {
				// FIXME: Unsupported.
			} else if domain == SettingsStore.ubiquitousDomain {
				NSUbiquitousKeyValueStore.default().set(value, forKey: key)
				NSUbiquitousKeyValueStore.default().synchronize()
			} else {
				UserDefaults(suiteName: domain)?.setValue(value, forKey: key)
			}
		}
	}
}

/// A KeyValueStore that securely encodes its contents in the OS keychain.
public final class SecureSettingsStore: KeyValueStore {
	fileprivate init() {}
	private var _defaultDomain = Bundle.main.bundleIdentifier ?? "SecureSettings:ERR"
	
	/// Set or get a secure key's value with the default domain (the bundle identifier).
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String) -> Any? {
		get {
			return self[key, domain: _defaultDomain]
		}
		set (value) {
			self[key, domain: _defaultDomain] = value
		}
	}
	
	/// Set or get a secure key's value with a custom specified domain.
	/// Note: setting a key's value to nil will delete the key from the store.
	public subscript(key: String, domain domain: String) -> Any? {
		get {
			var passwordLength: UInt32 = 0
			var passwordPtr: UnsafeMutableRawPointer? = nil
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
				if let item = itemRef , status == OSStatus(errSecSuccess) {
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

/// Aliased singleton for SettingsStore.
public let Settings = SettingsStore()

/// Aliased singleton for SecureSettingsStore.
public let SecureSettings = SecureSettingsStore()
