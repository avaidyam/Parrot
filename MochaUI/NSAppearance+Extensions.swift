import Cocoa

/* TODO: Make NSWorkspaceAccessibilityDisplayOptionsDidChangeNotification available. */
/* TODO: Make NSWorkspace.accessibilityDisplayShould* properties available. */

public extension NSAppearance {
    public static let aqua = NSAppearance(named: NSAppearance.Name.aqua)!
    public static let light = NSAppearance(named: NSAppearance.Name.vibrantLight)!
    public static let dark = NSAppearance(named: NSAppearance.Name.vibrantDark)!
}

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController
extension NSAppearance {
    public static var darkMode: Bool {
        return CFPreferencesCopyAppValue("AppleInterfaceStyle" as CFString, "NSGlobalDomain" as CFString) as? String == "Dark"
    }
    public static var reduceTransparency: Bool {
        return CFPreferencesGetAppBooleanValue("reduceTransparency" as CFString, "com.apple.universalaccess" as CFString, nil)
    }
    public static var increaseContrast: Bool {
        return CFPreferencesGetAppBooleanValue("increaseContrast" as CFString, "com.apple.universalaccess" as CFString, nil)
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
