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

public extension CALayer {
    
    /// Creates a `CALayer` that mirrors the given window ID (can either be within the same
    /// app, or from another app entirely) into its contents. Note: this will only work if
    /// the containing window hosts its layers in windowserver (`layerUsesCoreImageFilters=NO`).
    public class func mirroring(windowID: CGWindowID, includesShadow: Bool = true, contentsGravity: String = kCAGravityResizeAspect) -> CALayer {
        let clz = NSClassFromString("CAPluginLayer") as! CALayer.Type
        let layer = clz.init()
        layer.setValue("com.apple.WindowServer.CGSWindow", forKey: "pluginType")
        layer.setValue(windowID, forKey: "pluginId")
        layer.setValue(contentsGravity, forKey: "pluginGravity")
        layer.setValue(includesShadow ? 0x0 : 0x4, forKey: "pluginFlags")
        return layer
    }
}
