import Foundation
import Mocha
import asl

public extension Logger.Channel {
    
    /// Channel.ASL uses the Apple System Logging facility to submit the message.
    /// Note: ASL may not accept the message flow if its configuration severity
    /// is at a different level than what is set here.
    public static let ASL = Logger.Channel { message, severity, subsystem in
        var output = ""
        _ = severity >= .info
            ? debugPrint(message, terminator: "", to: &output)
            : Swift.print(subsystem, terminator: "", to: &output)
        output = "[\(subsystem)] [\(severity)]: "  + output
        withVaList([]) { ignore in
            var s = ASL_LEVEL_DEBUG
            switch severity {
            case .fatal: s = ASL_LEVEL_EMERG
            case .critical: s = ASL_LEVEL_CRIT
            case .error: s = ASL_LEVEL_ERR
            case .warning: s = ASL_LEVEL_WARNING
            case .info: s = ASL_LEVEL_NOTICE
            case .debug: s = ASL_LEVEL_INFO
            case .verbose: s = ASL_LEVEL_DEBUG
            }
            asl_vlog(nil, nil, s, output, ignore)
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
    
    public func snapshot() -> [String : Any] {
        return snapshot(domain: _defaultDomain)
    }
    
    public func snapshot(domain: String) -> [String : Any] {
        NSLog("SecureSettingsStore: SecKeychain cannot be queried for a snapshot!")
        return [:]
    }
}

/// Aliased singleton for SecureSettingsStore.
public let SecureSettings = SecureSettingsStore()
