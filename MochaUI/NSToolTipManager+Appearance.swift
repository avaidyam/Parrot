import AppKit
import Mocha

/// Apply the modern tool tip style by invoking `ToolTipManager.modernize()`.
/// This causes the tool tip panel to match the appearance of the origin view's
/// parent window, with rounded corners.
@objc public class ToolTipManager: NSObject {
    
    /// This function must be invoked to enable the modern tooltip theme for macOS 10.10+.
    /// Note: must be invoked at app launch with +initialize.
    public static func modernize() {
        let clz = NSClassFromString("NSToolTipManager")! as! NSObject.Type
        
        /// Swizzle: `-drawToolTip:attributedString:inView:` → `-swizzle_drawToolTip:attributedString:inView:`
        let displayN: IMP = imp_implementationWithBlock(unsafeBitCast(self.swizzle_drawToolTip_attributedString_inView, to: AnyObject.self))
        let displayM: Method = class_getInstanceMethod(clz, Selector(("drawToolTip:attributedString:inView:")))!
        class_addMethod(clz, Selector(("swizzle_drawToolTip:attributedString:inView:")), displayN, method_getTypeEncoding(displayM))
        let displayS: Method = class_getInstanceMethod(clz, Selector(("swizzle_drawToolTip:attributedString:inView:")))!
        method_exchangeImplementations(displayM, displayS)
        
        /// Swizzle: `-toolTipTextColor` → `-swizzle_toolTipTextColor`
        let colorM: Method = class_getInstanceMethod(clz, Selector(("toolTipTextColor")))!
        let colorS: Method = class_getInstanceMethod(self, #selector(ToolTipManager.swizzle_toolTipTextColor))!
        method_exchangeImplementations(colorM, colorS)
        
        /// Swizzle: `-_newToolTipWindow` → `-swizzle__newToolTipWindow`
        let windowN: IMP = imp_implementationWithBlock(unsafeBitCast(self.swizzle__newToolTipWindow, to: AnyObject.self))
        let windowM: Method = class_getInstanceMethod(clz, Selector(("_newToolTipWindow")))!
        class_addMethod(clz, Selector(("swizzle__newToolTipWindow")), windowN, method_getTypeEncoding(windowM))
        let windowS: Method = class_getInstanceMethod(clz, Selector(("swizzle__newToolTipWindow")))!
        method_exchangeImplementations(windowM, windowS)
    }
    
    /// Swizzle: make sure we return a dynamic system color to match the visual
    /// effect view.
    @objc func swizzle_toolTipTextColor() -> NSColor! {
        return NSColor.labelColor
    }
    
    /// Swizzle: modify the tool tip panel's visual effect view to have a 4.0
    /// corner radius and always match the panel's current appearance.
    private static var swizzle__newToolTipWindow: @convention(block) (NSObject) -> (NSWindow) = { manager in
        let window = manager.perform(Selector(("swizzle__newToolTipWindow"))).takeUnretainedValue() as! NSWindow
        if let view = window.contentView as? NSVisualEffectView {
            view.material = .appearanceBased
            view.state = .active
            view.cornerMaskRadius = 4.0
        }
        return window
    }
    
    /// Swizzle: update the tool tip panel's current appearance and return to normal control.
    private static var swizzle_drawToolTip_attributedString_inView: @convention(block) (NSObject, NSObject, NSAttributedString, NSView) -> () =
    { manager, tooltip, attrString, contentView in
        
        // Get the current/effective appearance of the origin view's window or itself.
        if let view = tooltip.value(forKey: "view") as? NSView {
            let appearance = view.window?.appearance ?? view.effectiveAppearance
            
            // Update the default tool tip panel.
            if let window = manager.value(forKey: "toolTipWindow") as? NSPanel {
                window.appearance = appearance
                window.displayIfNeeded()
            }
            
            // Update the expansion tool tip panel.
            if let window = manager.value(forKey: "expansionToolTipWindow") as? NSPanel {
                window.appearance = appearance
                window.displayIfNeeded()
            }
        }
        
        // Call the original `-drawToolTip:attributedString:inView:`.
        ToolTipManager.drawToolTipIMP()(manager, tooltip, attrString, contentView)
    }
    
    /// Retrieve the original `-drawToolTip:attributedString:inView:` IMP as a block.
    /// Basically, do what `-performSelector` does, but with 3+ arguments.
    private static func drawToolTipIMP() -> ((AnyObject, NSObject, NSAttributedString, NSView) -> ()) {
        typealias DrawToolTipIMP = @convention(c) (AnyObject, Selector, NSObject, NSAttributedString, NSView) -> ()
        let clz = NSClassFromString("NSToolTipManager")! as! NSObject.Type
        let sel = Selector(("swizzle_drawToolTip:attributedString:inView:"))
        
        let imp = class_getMethodImplementation(clz, sel)
        let output = unsafeBitCast(imp, to: DrawToolTipIMP.self)
        return { output($0, sel, $1, $2, $3) }
    }
}
