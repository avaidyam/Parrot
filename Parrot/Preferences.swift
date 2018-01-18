import Foundation
import AppKit
import Mocha
import MochaUI

/* TODO: Use UserDefaults.register(...) and force keys to be optional. */

public enum InterfaceStyle: Int {
    /// Vibrant Light theme.
    case Light
    /// Vibrant Dark theme.
    case Dark
    /// System-defined vibrant theme.
    case System
    
    /// Returns the currently indicated Parrot appearance based on user preference
    /// and if applicable, the global dark interface style preference (trampolined).
    public func appearance() -> NSAppearance {
        let style = InterfaceStyle(rawValue: Settings.interfaceStyle) ?? .Dark
        
        switch style {
        case .Light: return .light
        case .Dark: return .dark
            
        case .System: //TODO: "NSAppearanceNameMediumLight"
            let system = Settings.systemInterfaceStyle
            return system ? .dark : .light
        }
    }
}

public enum VibrancyStyle: Int {
    /// Windows will always be vibrant.
    case Always
    /// Windows will never be vibrant (opaque).
    case Never
    /// Windows will be vibrant when focused.
    case Automatic
    
    public func visualEffectState() -> NSVisualEffectView.State {
        switch self {
        case .Always: return .active
        case .Never: return .inactive
        case .Automatic: return .followsWindowActiveState
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
    
    public var prefersShoeboxAppStyle: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    
    public var systemInterfaceStyle: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    
    public var interfaceStyle: Int {
        get { return self.get(default: 0) }
        set { self.set(value: newValue) }
    }
    
    public var vibrancyStyle: Int {
        get { return self.get(default: 0) }
        set { self.set(value: newValue) }
    }
    
    public var autoEmoji: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    
    public var messageTextSize: Double {
        get { return self.get(default: 0.0) }
        set { self.set(value: newValue) }
    }
    
    public var completions: [String: String] {
        get { return self.get(default: [:]) }
        set { self.set(value: newValue) }
    }
    
    public var emoticons: [String: String] {
        get { return self.get(default: [:]) }
        set { self.set(value: newValue) }
    }
    
    public var menubarIcon: Bool {
        get { return self.get(default: false) }
        set { self.set(value: newValue) }
    }
    
    public var openConversations: [String] {
        get { return self.get(default: []) }
        set { self.set(value: newValue) }
    }
    
    public var conversationOutgoingColor: NSColor? {
        get { return self.archivedGet(default: nil) }
        set { self.archivedSet(value: newValue) }
    }
    
    public var conversationIncomingColor: NSColor? {
        get { return self.archivedGet(default: nil) }
        set { self.archivedSet(value: newValue) }
    }
    
    public var conversationBackground: NSImage? {
        get { return self.archivedGet(default: nil) }
        set { self.archivedSet(value: newValue) }
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
    
    func archivedGet<T: Decodable>(forKey key: String = #function, default: @autoclosure () -> (T)) -> T {
        if let data = self.object(forKey: key) as? Data {
            let value = try? PropertyListDecoder().decode(T.self, from: data)
            return value ?? `default`()
        }
        return `default`()
    }
    
    func archivedSet<T: Encodable>(forKey key: String = #function, value: T) {
        if let v = try? PropertyListEncoder().encode(value) {
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
