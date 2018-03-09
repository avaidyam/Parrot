import MochaUI

public enum Preferences {
    public enum Controllers {}
}

//
//
//

/// Describes the Parrot UI interface style.
public enum InterfaceStyle: Int {
    
    /// The current system-wide interface style.
    case system
    
    /// The VibrantLight style.
    case light
    
    /// The VibrantDark style.
    case dark
    
    /// Get the current Parrot UI `InterfaceStyle`.
    public static var current: InterfaceStyle {
        return InterfaceStyle(rawValue: Settings.effectiveInterfaceStyle)!
    }
    
    /// Get the underlying `NSAppearance` matching the `InterfaceStyle`.
    /// Note: `.system` dynamically resolves to the system-wide appearance at
    /// the time of invocation, and so call this function only as late as possible.
    public func appearance() -> NSAppearance {
        switch self {
        case .system: return .system
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    /// Install system appearance and `effectiveInterfaceStyle` handlers.
    /// Ideally, this should be done at app startup time.
    public static func bootstrap() {
        _ = registerSystemAppearanceObservers;
    }
}

/// Describes the Parrot UI vibrancy style. This style is particularly applied
/// only to content backdrops and not to auxiliary/inspector windows.
public enum VibrancyStyle: Int {
    
    /// Windows will be vibrant when focused and opaque otherwise.
    case automatic
    
    /// Windows will always be vibrant (never opaque).
    case always
    
    /// Windows will never be vibrant (always opaque).
    case never
    
    /// Get the current Parrot UI `VibrancyStyle`.
    public static var current: VibrancyStyle {
        return VibrancyStyle(rawValue: Settings.vibrancyStyle)!
    }
    
    /// Get the underlying `NSVisualEffectViewState` matching the `VibrancyStyle`.
    public func state() -> NSVisualEffectView.State {
        switch self {
        case .automatic: return .followsWindowActiveState
        case .always: return .active
        case .never: return .inactive
        }
    }
}

/// Describes the Parrot UI interface mode. This is currently unused.
public enum InterfaceMode: Int {
    
    /// The conversation list and all selected conversations have independent
    /// windows.
    case independentWindows
    
    /// The conversation list and directory are tabbed within one window, and
    /// all selected conversations are tabbed within a separate window.
    case tabbedWindows
    
    /// A single window is used for the conversation list and selecting a
    /// conversation will cause a transition within the window.
    case unifiedWindow
    
    /// A single window is used for the conversation list and selecting a
    /// conversation will expand it below the selected item in the list.
    case expandInWindow
    
    /// A single window is used for the conversation list and selecting a
    /// conversation will display it within a transient attached popover.
    case popoverInWindow
    
    /// A single window is used for the conversation list and the currently
    /// selected conversation, which appears to the right of the list.
    case singleSplitWindow
    
    /// A single window is used for the conversation list and all currently
    /// selected conversations, which appear to the right of the list.
    case multipleSplitWindow
    
    /// Get the current Parrot UI `InterfaceMode`.
    public static var current: InterfaceMode {
        return Settings.prefersShoeboxAppStyle ? .multipleSplitWindow : .independentWindows
    }
}

//
//
//

public extension UserDefaults {
    
    @objc public var prefersShoeboxAppStyle: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    
    /// Always `.light` or `.dark` and dynamically updated based on `\.interfaceStyle`
    /// and `\.systemInterfaceStyle` -- use this to track UI changes.
    @objc public var effectiveInterfaceStyle: Int {
        get { return self.get(default: 0) }
        set { self.set(value: newValue) }
    }
    
    @objc public var interfaceStyle: Int {
        get { return self.get(default: 0) }
        set { self.set(value: newValue) }
    }
    
    @objc public var vibrancyStyle: Int {
        get { return self.get(default: 0) }
        set { self.set(value: newValue) }
    }
    
    @objc public var autoEmoji: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    
    @objc public var messageTextSize: Double {
        get { return self.get(default: 0.0) }
        set { self.set(value: newValue) }
    }
    
    @objc public var completions: [String: String] {
        get { return self.get(default: [:]) }
        set { self.set(value: newValue) }
    }
    
    @objc public var emoticons: [String: String] {
        get { return self.get(default: [:]) }
        set { self.set(value: newValue) }
    }
    
    @objc public var menubarIcon: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    
    @objc public var openConversations: [String] {
        get { return self.get(default: []) }
        set { self.set(value: newValue) }
    }
}

public let Settings = UserDefaults.standard
public extension UserDefaults { // number, array, dictionary, data, url
    
    func get<T>(forKey key: String = #function, default: @autoclosure () -> (T)) -> T {
        return self.object(forKey: key) as? T ?? `default`()
    }
    
    func set<T>(forKey key: String = #function, value: T) {
        self.set(value, forKey: key)
    }
    
    func archivedGet<T: NSCoding>(forKey key: String = #function, default: @autoclosure () -> (T?)) -> T? {
        if let data = self.object(forKey: key) as? Data {
            let value = NSKeyedUnarchiver.unarchiveObject(with: data) as? T
            return value ?? `default`()
        }
        return `default`()
    }
    
    func archivedSet<T: NSCoding>(forKey key: String = #function, value: T?) {
        if value != nil {
            let v = NSKeyedArchiver.archivedData(withRootObject: value!)
            self.set(v, forKey: key)
        } else {
            self.set(nil, forKey: key)
        }
    }
}


//
// Private:
//


public extension NSObject {
    public static func exchange<A: NSObject, B: NSObject>(from: (A.Type, Selector), to: (B.Type, Selector), _ classMethod: Bool = false) {
        let old = classMethod ? class_getClassMethod(from.0, from.1) : class_getInstanceMethod(from.0, from.1)
        let new = classMethod ? class_getClassMethod(to.0, to.1)     : class_getInstanceMethod(to.0, to.1)
        method_exchangeImplementations(old!, new!)
    }
}

internal var registerSystemAppearanceObservers: [Any] = {
    func _systemDark() -> Bool {
        return CFPreferencesCopyAppValue("AppleInterfaceStyle" as CFString, "NSGlobalDomain" as CFString) as? String == "Dark"
    }
    func _updateEffectivity() {
        // The effective style is changed to the new system style iff it was dynamic to begin with.
        let _style: InterfaceStyle = InterfaceStyle.current != .system ? .current : (_systemDark() ? .dark : .light)
        Settings.effectiveInterfaceStyle = _style.rawValue
    }
    
    let _n = NSAppearance.systemAppearanceDidChangeNotification
    return [
        DistributedNotificationCenter.default().addObserver(forName: _n, object: nil, queue: nil) { _ in
            _updateEffectivity()
        },
        Settings.observe(\.interfaceStyle, options: [.initial, .new]) { _, _ in
            _updateEffectivity()
        },
    ]
}()
