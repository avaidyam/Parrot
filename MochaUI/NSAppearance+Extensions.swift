import Cocoa

public extension NSAppearance {
    public static let aqua = NSAppearance(named: .aqua)!
    public static let light = NSAppearance(named: .vibrantLight)!
    public static let dark = NSAppearance(named: .vibrantDark)!
}

public extension NSWorkspace {
    public var darkInterfaceTheme: Bool {
        return CFPreferencesCopyAppValue("AppleInterfaceStyle" as CFString, "NSGlobalDomain" as CFString) as? String == "Dark"
    }
    
    public static let menuBarAppearanceDidChangeNotification = NSNotification.Name(rawValue: "NSWorkspaceMenuBarAppearanceDidChangeNotification")
}

public extension NSWindow {
    public func enableRealTitlebarVibrancy(_ blendingMode: NSVisualEffectView.BlendingMode = .withinWindow) {
        let t = self.standardWindowButton(.closeButton)?.superview as? NSVisualEffectView
        t?.material = .appearanceBased
        t?.blendingMode = blendingMode
    }
}

public extension NSControl {
    
    /// Sigh. More AppKit "magic" to defeat. When placed in the titlebarview of a window,
    /// views are given a semanticContext of 0x5 and marked explicit. Setting an explicit
    /// value of 0x0 disables that. Not sure what the thing is used for...
    public func disableToolbarLook() {
        self.perform(Selector(("_setSemanticContext:")), with: 0)
    }
}

/// NSVisualEffectView allows events to bleed through. This blocks that.
public class NSAntiVisualEffectView: NSVisualEffectView {
    public override var acceptsTouchEvents: Bool {
        get { return true }
        set {}
    }
    
    public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    public override func mouseDown(with event: NSEvent) {
        //
    }
}
