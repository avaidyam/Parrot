import AppKit
import Mocha

public extension NSAppearance {
    public static let aqua = NSAppearance(named: .aqua)!
    public static let light = NSAppearance(named: .vibrantLight)!
    public static let dark = NSAppearance(named: .vibrantDark)!
}

public extension NSAppearance {
    public static var system: NSAppearance {
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

public extension NSVisualEffectView {
    private static var cornerRadiusKey = AssociatedProperty<NSVisualEffectView, CGFloat>(.strong)
    
    /// Note: modifying the `cornerMaskRadius` modifies `maskImage`!
    public var cornerMaskRadius: CGFloat {
        get { return NSVisualEffectView.cornerRadiusKey[self, default: 0.0] }
        set {
            NSVisualEffectView.cornerRadiusKey[self] = newValue
            guard newValue != 0.0 else {
                self.maskImage = nil; return
            }
            
            // Generates a corner mask image.
            func mask(_ radius: CGFloat) -> NSImage {
                let edge = 2.0 * radius + 1.0
                let mask = NSImage(size: NSSize(width: edge, height: edge), flipped: false) {
                    NSColor.black.set()
                    NSBezierPath(roundedRect: $0, xRadius: radius, yRadius: radius).fill()
                    return true
                }
                mask.capInsets = NSEdgeInsets(top: radius, left: radius, bottom: radius, right: radius)
                mask.resizingMode = .stretch
                return mask
            }
            
            self.maskImage = mask(newValue)
        }
    }
    
}
