import AppKit
import Mocha

public extension NSAppearance {
    public static let aqua = NSAppearance(named: .aqua)!
    public static let light = NSAppearance(named: .vibrantLight)!
    public static let dark = NSAppearance(named: .vibrantDark)!
}

public extension NSAppearance {
    public static var systemAppearance: NSAppearance {
        let d = CFPreferencesCopyAppValue("AppleInterfaceStyle" as CFString, "NSGlobalDomain" as CFString) as? String == "Dark"
        return NSAppearance(named: d ? .vibrantDark : .vibrantLight)!
    }
    public static let systemAppearanceDidChangeNotification = NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification")
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
