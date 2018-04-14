import Foundation

// The following imports are required for `CGKeyCode` extensions:
import Carbon.HIToolbox.TextInputSources
import CoreServices.CarbonCore.UnicodeUtilities
import Carbon.HIToolbox.Events
import Darwin.MacTypes


//
// MARK: - CGSKeyboardShortcut
//


/// A replacement API for the `Carbon.RegisterEventHotKey` function.
///
/// Note: Instead of following `SkyLight.CGSHotKey...` naming, the class is instead
/// uses the nomenclature of macOS's Keyboard Shortcuts, from System Preferences.
public final class CGSKeyboardShortcut: Hashable {
    
    
    //
    // MARK: - Internal Types
    //
    
    
    /// The `identifier` type of the `CGSKeyboardShortcut`.
    public struct Identifier: RawRepresentable, Hashable, Codable {
        public typealias RawValue = Int
        public let rawValue: Identifier.RawValue
        public init(rawValue: Identifier.RawValue) {
            self.rawValue = rawValue
        }
        public init(_ rawValue: Identifier.RawValue) {
            self.rawValue = rawValue
        }
    }
    
    /// Determines the policy to take in acquiring the shortcut at initialization.
    public enum AcquisitionPolicy: Int, Codable {
        
        /// The shortcut will not be acquired exclusively; that is, the shortcut
        /// can be registered again, and possibly by different applications.
        case none
        
        /// The shortcut will be acquired exclusively; that is, the WindowServer
        /// will not allow a shortcut with the same parameters to be registered
        /// more than once, regardless of which application is registering it.
        ///
        /// Note: it is undefined behavior to register a shortcut with the same
        /// identifier but different `keyCode` and `modifierFlags`.
        case exclusively
        
        /// The shortcut will be acquired exclusively if possible; that is, if
        /// the shortcut was already acquired, continue to acquire it non-exclusively.
        ///
        /// Note: this implies that other shortcut registration instances, possibly
        /// from different applications, may also acquire this shortcut.
        case exclusivelyIfPossible
    }
    
    /// A "frozen" shortcut definition to be used with `CGSKeyboardShortcut`. Use
    /// this to maintain an application or user-defined list of shortcuts.
    public struct Definition: Hashable, Codable {
        public let identifier: CGSKeyboardShortcut.Identifier
        public let keyCode: CGKeyCode
        public let modifierFlags: CGEventFlags
        public let acquisitionPolicy: AcquisitionPolicy
        
        public init(identifier: CGSKeyboardShortcut.Identifier, keyCode: CGKeyCode, modifierFlags: CGEventFlags, acquisitionPolicy: AcquisitionPolicy) {
            self.identifier = identifier
            self.keyCode = keyCode
            self.modifierFlags = modifierFlags
            self.acquisitionPolicy = acquisitionPolicy
        }
    }
    
    
    //
    // MARK: - Notifications
    //
    
    
    /// The notification that is posted upon the keyboard shortcut being pressed.
    /// Corresponds to `NSResponder.keyDown(_:)`.
    public static let pressedNotification = Notification.Name("CGSKeyboardShortcut.pressedNotification")
    
    /// The notification that is posted upon the keyboard shortcut being released.
    /// Corresponds to `NSResponder.keyUp(_:)`.
    public static let releasedNotification = Notification.Name("CGSKeyboardShortcut.releasedNotification")
    
    
    //
    // MARK: - Event Monitor & Registered Set
    //
    
    
    /// All application-registered non-`invalidate()`'d `CGSKeyboardShortcut`s.
    /// This does not include `AppKit`-registered or `Carbon`-registered shortcuts.
    public private(set) static var all: Set<CGSKeyboardShortcut> = []
    
    /// The `NSEvent` monitor intercepts all shortcut events and forwards them.
    private static var monitor = NSEvent.addLocalMonitorForEvents(matching: .systemDefined) { event in
        if [6, 9].contains(event.subtype.rawValue) {
            CGSKeyboardShortcut.all.filter { $0.identifier.rawValue == event.data1 }.forEach { obj in
                let name: Notification.Name = event.subtype.rawValue == 6
                    ? CGSKeyboardShortcut.pressedNotification /* 6 */
                    : CGSKeyboardShortcut.releasedNotification /* 9 */
                NotificationCenter.default.post(name: name, object: obj)
            }
            return nil // consumed
        }
        return event
    }
    
    
    //
    // MARK: - Shortcut Properties
    //
    
    
    /// The shortcut's unique identifier.
    public let identifier: CGSKeyboardShortcut.Identifier
    
    /// The shortcut's key code.
    public let keyCode: CGKeyCode
    
    /// The shortcut's modifier flags.
    public let modifierFlags: CGEventFlags
    
    /// The shortcut was aquired exclusively (i.e. with exclusion).
    public let acquisitionPolicy: AcquisitionPolicy
    
    /// Enable or disable the `CGSKeyboardShortcut`. If disabled, events will not
    /// reach the application and shortcut notifications will not be posted.
    public var isEnabled: Bool {
        // MARK: [Private SPI]
        get { return CGSIsHotKeyEnabled(CGSMainConnectionID(), self.identifier.rawValue) }
        set { _ = CGSSetHotKeyEnabled(CGSMainConnectionID(), self.identifier.rawValue, newValue) }
    }
    
    
    //
    // MARK: - Initialization & Deinitialization
    //
    
    
    /// Registers a global shortcut that activates the application-defined actions
    /// regardless of whether the application is front-most or not. The `modifierFlags`
    /// passed in will be intersected with `.maskShortcutFlags`. To handle a
    /// shortcut only when the application is front-most, check if `NSApp.isActive`
    /// is `true` in the notification observer.
    ///
    /// Throws `CGError.cannotComplete` if there already exists a registered shortcut
    /// with the same `identifier`.
    ///
    /// Throws `CGError.noneAvailable` if the `acquisitionPolicy` is `exclusively`,
    /// and a shortcut with the same parameters was already registered in the WindowServer.
    public init(identifier: CGSKeyboardShortcut.Identifier, keyCode: CGKeyCode,
                modifierFlags: CGEventFlags, acquisitionPolicy: AcquisitionPolicy = .none) throws
    {
        
        // Bootstrap the event monitor if needed, and throw if there's a previously
        // registered shortcut with the same `identifier`.
        _ = CGSKeyboardShortcut.monitor
        guard CGSKeyboardShortcut.all.filter({ $0.identifier == identifier }).count == 0 else {
            throw CGError.cannotComplete
        }
        
        self.identifier = identifier
        self.keyCode = keyCode
        self.modifierFlags = modifierFlags.intersection(.maskShortcutFlags)
        self.acquisitionPolicy = acquisitionPolicy
        
        // Register with WindowServer and cache ourselves.
        // MARK: [Private SPI]
        var error: CGError = .success
        error = CGSSetHotKeyWithExclusion(CGSMainConnectionID(), self.identifier.rawValue,
                                          0xffff, self.keyCode, self.modifierFlags.rawValue,
                                          self.acquisitionPolicy == .none ? 0x0 : 0x1)
        
        // If our acquisition policy can fallback, register non-exclusively.
        if error == .noneAvailable && self.acquisitionPolicy == .exclusivelyIfPossible {
            error = CGSSetHotKeyWithExclusion(CGSMainConnectionID(), self.identifier.rawValue,
                                              0xffff, self.keyCode, self.modifierFlags.rawValue, 0x0)
        }
        guard error == .success else { throw error }
        
        // TODO: I really don't know the significance of setting the hot key type...
        // MARK: [Private SPI]
        error = CGSSetHotKeyType(CGSMainConnectionID(), self.identifier.rawValue, 0x1)
        guard error == .success else { throw error }
        CGSKeyboardShortcut.all.insert(self)
    }
    
    /// Invalidates the shortcut upon deinitialize.
    deinit {
        self.invalidate()
    }
    
    
    //
    // MARK: - Invalidation
    //
    
    
    /// Invalidate the shortcut when deinitialized. Once invalidated, the shortcut
    /// will no longer receive activation events from the WindowServer. This
    /// process is irreversible.
    public func invalidate() {
        // Unregister with WindowServer and uncache ourselves.
        // MARK: [Private SPI]
        _ = CGSRemoveHotKey(CGSMainConnectionID(), self.identifier.rawValue)
        CGSKeyboardShortcut.all.remove(self)
    }
    
    /// Invalidates all application-defined shortcut.
    public static func invalidateAll() {
        CGSKeyboardShortcut.all = []
    }
    
    
    //
    // MARK: - Definition Conversion
    //
    
    
    /// Register a shortcut from a `CGSKeyboardShortcut.Definition`.
    public convenience init(definition: Definition) throws {
        try self.init(identifier: definition.identifier, keyCode: definition.keyCode,
                      modifierFlags: definition.modifierFlags,
                      acquisitionPolicy: definition.acquisitionPolicy)
    }
    
    /// Returns a `CGSKeyboardShortcut.Definition` from the shortcut.
    public var definition: Definition {
        return Definition(identifier: self.identifier, keyCode: self.keyCode,
                          modifierFlags: self.modifierFlags,
                          acquisitionPolicy: self.acquisitionPolicy)
    }
    
    
    //
    // MARK: - Hashable & Equatable
    //
    
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    public static func ==(lhs: CGSKeyboardShortcut, rhs: CGSKeyboardShortcut) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.keyCode == rhs.keyCode
            && lhs.modifierFlags == rhs.modifierFlags
    }
}


//
// MARK: - CGEventFlags Extensions
//


// Required to throw these errors.
extension CGError: Error {}
extension CGEventFlags: Hashable, Codable {
    public var hashValue: Int { return self.rawValue.hashValue }
}

public extension CGEventFlags {
    /// Convert `NSEvent.ModifierFlags` into `CGEventFlags`.
    public init(_ flags: NSEvent.ModifierFlags) {
        self.init(rawValue: UInt64(flags.rawValue))
    }
    
    /// Used to retrieve only the device-independent modifier flags, allowing
    /// applications to mask off the device-dependent modifier flags, including
    /// event coalescing information.
    public static let maskDeviceIndependentFlags = CGEventFlags(rawValue: 0x00000000ffff0000)
    
    /// Used to retrieve only the shortcut-usable modifier flags.
    public static let maskShortcutFlags = CGEventFlags(rawValue: 0x0000000000ff0000)
    
    /// Used to retrieve only the user transient modifier flags (i.e. no caps-lock).
    public static let maskUserFlags: CGEventFlags = [.maskCommand, .maskControl, .maskShift, .maskAlternate]
}

public extension NSEvent.ModifierFlags {
    /// Convert `CGEventFlags` into `NSEvent.ModifierFlags`.
    public init(_ flags: CGEventFlags) {
        self.init(rawValue: UInt(flags.rawValue))
    }
}


//
// MARK: - KeyCode & EventFlags String Conversion
//


public extension CGKeyCode {
    
    /// Is this virtual key code actually a function key?
    public var isFunctionKey: Bool {
        switch Int(self) {
        // Virtual key constants are *NOT* sequential like ASCII.
        case kVK_F1, kVK_F2, kVK_F3, kVK_F4, kVK_F5, kVK_F6, kVK_F7, kVK_F8,
             kVK_F9, kVK_F10, kVK_F11, kVK_F12, kVK_F13, kVK_F14, kVK_F15,
             kVK_F16, kVK_F17, kVK_F18, kVK_F19, kVK_F20:
            return true
        default:
            return false
        }
    }
    
    /// The human-readable representation of the virtual key code.
    ///
    /// Note: dead keys (dead key `´` is usually used to produce live key `é`)
    /// are not considered.
    public var characters: String {
        if let special = CGKeyCode._special[Int(self)] { return special }
        
        let source = TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeUnretainedValue()
        let layoutData = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
        let dataRef = unsafeBitCast(layoutData, to: CFData.self)
        let keyLayout = unsafeBitCast(CFDataGetBytePtr(dataRef), to: UnsafePointer<CoreServices.UCKeyboardLayout>.self)
        
        let keyTranslateOptions = OptionBits(CoreServices.kUCKeyTranslateNoDeadKeysBit)
        var deadKeyState: UInt32 = 0
        let maxChars = 256
        var chars = [UniChar](repeating: 0, count: maxChars)
        var length = 0
        
        let error = CoreServices.UCKeyTranslate(keyLayout, self,
                                                UInt16(CoreServices.kUCKeyActionDisplay),
                                                0, UInt32(LMGetKbdType()),
                                                keyTranslateOptions, &deadKeyState,
                                                maxChars, &length, &chars)
        
        if error != noErr { return "" }
        return NSString(characters: &chars, length: length).uppercased
    }
    
    // Internal: map certain virtual key codes to strings, like `Space`, `Fn` keys,
    // and virtual keys with a special keyboard glyph.
    private static var _special: [Int: String] = [
        kVK_F1: "F1",
        kVK_F2: "F2",
        kVK_F3: "F3",
        kVK_F4: "F4",
        kVK_F5: "F5",
        kVK_F6: "F6",
        kVK_F7: "F7",
        kVK_F8: "F8",
        kVK_F9: "F9",
        kVK_F10: "F10",
        kVK_F11: "F11",
        kVK_F12: "F12",
        kVK_F13: "F13",
        kVK_F14: "F14",
        kVK_F15: "F15",
        kVK_F16: "F16",
        kVK_F17: "F17",
        kVK_F18: "F18",
        kVK_F19: "F19",
        kVK_F20: "F20",
        kVK_Space: "Space", //␣
        kVK_Delete: "⌫",
        kVK_ForwardDelete: "⌦",
        kVK_ANSI_Keypad0: "⌧",
        kVK_LeftArrow: "←",
        kVK_RightArrow: "→",
        kVK_UpArrow: "↑",
        kVK_DownArrow: "↓",
        kVK_End: "↘",
        kVK_Home: "↖",
        kVK_Escape: "⎋",
        kVK_PageDown: "⇟",
        kVK_PageUp: "⇞",
        kVK_Tab: "⇥",
        kVK_Return: "↩",
        kVK_Help: "?⃝",
        kVK_ANSI_KeypadClear: "⌧",
        kVK_ANSI_KeypadEnter: "⌅",
    ]
    
    /// TODO: https://opensource.apple.com/source/WebCore/WebCore-7604.1.38.1.6/platform/mac/PlatformEventFactoryMac.mm.auto.html
    /// See the above link for a full virtual key <--> literal conversion set.
}

public extension CGEventFlags {
    
    /// The human-readable representation of the event modifier flags.
    public var characters: String {
        var string = ""
        if self.contains(.maskAlphaShift) { string.append("⇪") }
        if self.contains(.maskHelp) { string.append("?⃝") }
        if self.contains(.maskControl) { string.append("⌃") }
        if self.contains(.maskAlternate) { string.append("⌥") }
        if self.contains(.maskShift) { string.append("⇧") }
        if self.contains(.maskCommand) { string.append("⌘") }
        return string
    }
}
public extension NSEvent.ModifierFlags {
    
    /// The human-readable representation of the event modifier flags.
    public var characters: String {
        return CGEventFlags(self).characters
    }
}


//
// MARK: - [Private SPI] CGSHotKey
//


// Here lie dragons!
fileprivate typealias CGSConnectionID = UInt
@_silgen_name("CGSMainConnectionID")
fileprivate func CGSMainConnectionID() -> CGSConnectionID
@_silgen_name("CGSSetHotKeyWithExclusion")
fileprivate func CGSSetHotKeyWithExclusion(_ connection: CGSConnectionID,
                                           _ hotKeyID: Int,
                                           _ hotKeyMask: UInt16,
                                           _ keyCode: UInt16,
                                           _ modifierFlags: UInt64,
                                           _ options: Int8) -> CGError
@_silgen_name("CGSSetHotKeyType")
fileprivate func CGSSetHotKeyType(_ connection: CGSConnectionID,
                                  _ hotKeyID: Int,
                                  _ options: Int8) -> CGError
@_silgen_name("CGSSetHotKeyEnabled")
fileprivate func CGSSetHotKeyEnabled(_ connection: CGSConnectionID,
                                     _ hotKeyID: Int,
                                     _ enabled: Bool) -> CGError
@_silgen_name("CGSIsHotKeyEnabled")
fileprivate func CGSIsHotKeyEnabled(_ connection: CGSConnectionID,
                                    _ hotKeyID: Int) -> Bool
@_silgen_name("CGSRemoveHotKey")
fileprivate func CGSRemoveHotKey(_ connection: CGSConnectionID,
                                 _ hotKeyID: Int) -> CGError

// MARK: -

