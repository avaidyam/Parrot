import MochaUI

/* TODO: Use UserDefaults.register(...) and force keys to be optional. */

internal var _systemCurrentlyDark: Bool = false
internal var registerSystemAppearanceObservers: [Any] = {
    func _systemDark() -> Bool {
        return CFPreferencesCopyAppValue("AppleInterfaceStyle" as CFString, "NSGlobalDomain" as CFString) as? String == "Dark"
    }
    func _updateEffectivity() {
        _systemCurrentlyDark = _systemDark()
        // The effective style is changed to the new system style iff it was dynamic to begin with.
        Settings.effectiveInterfaceStyle = (InterfaceStyle.current != .System ? InterfaceStyle.current : (_systemDark() ? .Dark : .Light)).rawValue
    }
    
    return [
        DistributedNotificationCenter.default().addObserver(forName: NSAppearance.systemAppearanceDidChangeNotification, object: nil, queue: nil) { _ in
            _updateEffectivity()
        },
        Settings.observe(\.interfaceStyle, options: [.initial, .new]) { _, change in
            _updateEffectivity()
        },
    ]
}()

public enum InterfaceStyle: Int {
    /// System-defined vibrant theme.
    case System
    /// Vibrant Light theme.
    case Light
    /// Vibrant Dark theme.
    case Dark
    
    public static var current: InterfaceStyle {
        return InterfaceStyle(rawValue: Settings.interfaceStyle)!
    }
    
    public func appearance() -> NSAppearance {
        switch self {
        case .System: return _systemCurrentlyDark ? .dark : .light
        case .Light: return .light
        case .Dark: return .dark
        }
    }
}

public enum VibrancyStyle: Int {
    /// Windows will be vibrant when focused.
    case Automatic
    /// Windows will always be vibrant.
    case Always
    /// Windows will never be vibrant (opaque).
    case Never
    
    public static var current: VibrancyStyle {
        return VibrancyStyle(rawValue: Settings.vibrancyStyle)!
    }
    
    public func state() -> NSVisualEffectView.State {
        switch self {
        case .Automatic: return .followsWindowActiveState
        case .Always: return .active
        case .Never: return .inactive
        }
    }
}

public enum WindowInteraction: Int {
    /// App windows can be tabbed.
    case Tabbed
    /// App windows can be docked.
    case Docking
}

public enum InterfaceMode: Int {
    ///
    case MasterDetail
    ///
    case InlineExpansion
    /// Sidebar for all conversations, content has a single conversation.
    case SplitView
    ///
    case PopoverDetail
    ///
    case OverlayBubble
}//document, utility, shoebox

//
//
//

public struct Preferences {
    private init() {}
    public struct Controllers {
        private init() {}
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
    
    /*
    @objc public var systemInterfaceStyle: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    */
    
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

// why is this here again?
public extension NSObject {
    
    public static func exchange<A: NSObject, B: NSObject>(from: (A.Type, Selector), to: (B.Type, Selector), _ classMethod: Bool = false) {
        let old = classMethod ? class_getClassMethod(from.0, from.1) : class_getInstanceMethod(from.0, from.1)
        let new = classMethod ? class_getClassMethod(to.0, to.1)     : class_getInstanceMethod(to.0, to.1)
        method_exchangeImplementations(old!, new!)
    }
    
}
