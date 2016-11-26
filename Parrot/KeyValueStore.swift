import Foundation
import Security

/* TODO: Switch KeyValueStore to strongly-typed struct instead of String for Key. */
/* TODO: Find a way to do SecKeychain* snapshot(). */
/* TODO: Switch to SecItem API instead of SecKeychain API. */
/* TODO: Use kSecAttrSynchronizable for iCloud Keychain. */

/// A KeyValueStore is a container layer that stores values for given keys
/// and supports specific application-defined or special/protected domains.
public protocol KeyValueStore {
	subscript(key: String) -> Any? { get set }
    subscript(key: String, domain domain: String) -> Any? { get set }
    
    func snapshot() -> [String : Any]
    func snapshot(domain: String) -> [String : Any]
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
    
    public func snapshot() -> [String : Any] {
        return UserDefaults.standard.dictionaryRepresentation()
    }
    
    public func snapshot(domain: String) -> [String : Any] {
        if domain == SettingsStore.globalDomain {
            return UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) ?? [:]
        } else if domain == SettingsStore.ubiquitousDomain {
            NSUbiquitousKeyValueStore.default().synchronize()
            return NSUbiquitousKeyValueStore.default().dictionaryRepresentation
        } else {
            return UserDefaults(suiteName: domain)?.dictionaryRepresentation() ?? [:]
        }
    }
}

public final class FileStore: KeyValueStore {
    private let infoPlist = Bundle.main.bundlePath + "/Contents/Info.plist"
    
    public subscript(key: String) -> Any? {
        get { return self[key, domain: infoPlist] }
        set { self[key, domain: infoPlist] = newValue }
    }

    public subscript(key: String, domain domain: String) -> Any? {
        get {
            return NSDictionary(contentsOfFile: domain)?[key]
        }
        set {
            if let dict = NSDictionary(contentsOfFile: domain) {
                dict.setValue(newValue, forKey: key)
                dict.write(toFile: domain, atomically: true)
            }
        }
    }
    
    public func snapshot() -> [String : Any] {
        return snapshot(domain: infoPlist)
    }
    
    public func snapshot(domain: String) -> [String : Any] {
        return (NSDictionary(contentsOfFile: domain) as? [String: Any]) ?? [:]
    }
}

/// Aliased singleton for SettingsStore.
public let Settings = SettingsStore()
