import AppKit
import Mocha

public extension NSDrawer {
    private static var drawerWindowKey = SelectorKey<NSDrawer, Void, Void, NSWindow>("_drawerWindow")
	
	/// The NSDrawer's window; that is, not its parent window, but the drawer's frame.
	public var drawerWindow: NSWindow? {
        return NSDrawer.drawerWindowKey[self, with: nil, with: nil]
    }
    
    public var resizableAxis: NSEvent.GestureAxis {
        get {
            guard let w = self.drawerWindow else { return .none }
            let s = w.resizeIncrements
            if s.width == .greatestFiniteMagnitude && s.height != .greatestFiniteMagnitude {
                return .vertical
            } else if s.width != .greatestFiniteMagnitude && s.height == .greatestFiniteMagnitude {
                return .horizontal
            }
            return .none
        }
        set (axis) {
            guard let w = self.drawerWindow else { return }
            w.resizeIncrements = NSSize(width: (axis == .horizontal ? 1.0 : .greatestFiniteMagnitude),
                                        height: (axis == .vertical ? 1.0 : .greatestFiniteMagnitude))
        }
    }
	
	/// This function must be invoked to enable the modern drawer theme for macOS 10.10+.
	/// Note: must be invoked at app launch with +initialize.
	public static func modernize() {
		let frameViewClassForStyleMaskR: @convention(block) () -> (AnyClass?) = {
			return NSClassFromString("NSThemeFrame")!
		}
		
		// Swizzle out the frameViewClassForStyleMask: to return a normal NSThemeFrame.
		let frameViewClassForStyleMaskB = imp_implementationWithBlock(unsafeBitCast(frameViewClassForStyleMaskR, to: AnyObject.self))
        let frameViewClassForStyleMaskM: Method = class_getClassMethod(NSClassFromString("NSDrawerWindow")!, Selector(("frameViewClassForStyleMask:")))!
		method_setImplementation(frameViewClassForStyleMaskM, frameViewClassForStyleMaskB)
        
		// Unfortunately, special edge considerations don't work on NSThemeFrame.
		let replaceR: @convention(block) ()->() = {}
		let replaceB = imp_implementationWithBlock(unsafeBitCast(replaceR, to: AnyObject.self))
		
		// Swizzle out the setEdge: method.
        let setEdgeM: Method = class_getInstanceMethod(NSClassFromString("NSDrawerFrame")!, Selector(("setEdge:")))!
		class_addMethod(NSClassFromString("NSFrameView")!, Selector(("setEdge:")), replaceB, method_getTypeEncoding(setEdgeM))
		
		// Swizzle out the registerForEdgeChanges: method.
        let registerForEdgeChangesM: Method = class_getInstanceMethod(NSClassFromString("NSDrawerFrame")!, Selector(("registerForEdgeChanges:")))!
		class_addMethod(NSClassFromString("NSFrameView")!, Selector(("registerForEdgeChanges:")), replaceB, method_getTypeEncoding(registerForEdgeChangesM))
        
        let attachM: Method = class_getInstanceMethod(NSClassFromString("NSDrawer")!, Selector(("_doSetParentWindow:")))!
        let attachS: Method = class_getInstanceMethod(NSClassFromString("NSDrawer")!, #selector(NSDrawer.swizzle__doSetParentWindow(_:)))!
        method_exchangeImplementations(attachM, attachS)
	}
}

fileprivate extension NSDrawer {
    
    /// This swizzle hook allows __setupModernDrawer to be invoked automatically.
    @objc func swizzle__doSetParentWindow(_ arg1: AnyObject!) {
        __setupModernDrawer()
        swizzle__doSetParentWindow(arg1)
    }
    
    /// This function must be invoked in addition to `__activateModernDrawers()` to enable
    /// modern drawers on macOS 10.10+. Note: must be invoked before drawer is displayed.
    func __setupModernDrawer() {
        guard let w = self.drawerWindow else { return }
        w.titlebarAppearsTransparent = true
        w.titleVisibility = .hidden
        w.styleMask = [w.styleMask, .fullSizeContentView, .resizable]
        w.isMovable = false
        w.hasShadow = false
        w.resizeIncrements = NSSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        w.standardWindowButton(.zoomButton)?.superview?.isHidden = true
    }
}
