import AppKit
import Mocha

// FIXME: The tooltip text appears blank either for the first tooltip or after an appearance change.
@objc public class ToolTipManager: NSObject {
    private static var displayTooltipKey = SelectorKey<NSObject, NSObject, Void, Void>("swizzle_displayToolTip:")
    
    /// This function must be invoked to enable the modern tooltip theme for macOS 10.10+.
    /// Note: must be invoked at app launch with +initialize.
    public static func modernize() {
        let clz = NSClassFromString("NSToolTipManager")! as! NSObject.Type
        
        let displayN: IMP = imp_implementationWithBlock(unsafeBitCast(self.swizzle_displayToolTip, to: AnyObject.self))
        let displayM: Method = class_getInstanceMethod(clz, Selector(("displayToolTip:")))!
        class_addMethod(clz, Selector(("swizzle_displayToolTip:")), displayN, method_getTypeEncoding(displayM))
        let displayS: Method = class_getInstanceMethod(clz, Selector(("swizzle_displayToolTip:")))!
        method_exchangeImplementations(displayM, displayS)
        
        let colorM: Method = class_getInstanceMethod(clz, Selector(("toolTipTextColor")))!
        let colorS: Method = class_getInstanceMethod(self, #selector(ToolTipManager.swizzle_toolTipTextColor))!
        method_exchangeImplementations(colorM, colorS)
    }
    
    @objc func swizzle_toolTipTextColor() -> NSColor! {
        return NSColor.labelColor
    }
    
    private static var swizzle_displayToolTip: @convention(block) (NSObject, NSObject) -> () = { manager, tooltip in
        //_ = ToolTipManager.displayTooltipKey[self, with: tooltip, with: nil]
        manager.perform(Selector(("swizzle_displayToolTip:")), with: tooltip)
        
        // Default ToolTip Window
        guard let view = tooltip.value(forKey: "view") as? NSView else { return }
        if  let tooltipWindow = manager.value(forKey: "toolTipWindow") as? NSPanel,
            let contentView = tooltipWindow.contentView as? NSVisualEffectView
        {
            tooltipWindow.appearance = view.window?.appearance
            contentView.material = .appearanceBased
            tooltipWindow.displayIfNeeded()
        }
        
        // Expansion ToolTip Window
        if  let expansionWindow = manager.value(forKey: "expansionToolTipWindow") as? NSPanel,
            let contentView = expansionWindow.contentView as? NSVisualEffectView
        {
            expansionWindow.appearance = view.window?.appearance
            contentView.material = .appearanceBased
            expansionWindow.displayIfNeeded()
        }
    }
}
