import Cocoa

public extension NSAppearance {
    public static let aqua = NSAppearance(named: NSAppearance.Name.aqua)!
    public static let light = NSAppearance(named: NSAppearance.Name.vibrantLight)!
    public static let dark = NSAppearance(named: NSAppearance.Name.vibrantDark)!
}

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController
extension NSAppearance {
    public static var darkInterfaceTheme: Bool {
        return CFPreferencesCopyAppValue("AppleInterfaceStyle" as CFString, "NSGlobalDomain" as CFString) as? String == "Dark"
    }
    
}

public extension NSWorkspace {
    
    public static var darkInterfaceTheme: Bool {
        return CFPreferencesCopyAppValue("AppleInterfaceStyle" as CFString, "NSGlobalDomain" as CFString) as? String == "Dark"
    }
    
    public static let menuBarAppearanceDidChangeNotification = NSNotification.Name(rawValue: "NSWorkspaceMenuBarAppearanceDidChangeNotification")
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
