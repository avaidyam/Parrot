import AppKit

public extension NSDrawer {
	
	public var window: NSWindow? {
		return self.contentView?.window
	}
	
	// Note: must be invoked at app launch with +initialize.
	public static func __activateModernDrawers() {
		let frameViewClassForStyleMaskR: @convention(block) () -> (AnyClass!) = {
			return NSClassFromString("NSThemeFrame")!
		}
		
		// Swizzle out the frameViewClassForStyleMask: to return a normal NSThemeFrame.
		let frameViewClassForStyleMaskB = imp_implementationWithBlock(unsafeBitCast(frameViewClassForStyleMaskR, to: AnyObject.self))
		let frameViewClassForStyleMaskM: Method = class_getClassMethod(NSClassFromString("NSDrawerWindow")!, Selector(("frameViewClassForStyleMask:")))
		method_setImplementation(frameViewClassForStyleMaskM, frameViewClassForStyleMaskB)
		
		// Unfortunately, special edge considerations don't work on NSThemeFrame.
		let replaceR: @convention(block) ()->() = {}
		let replaceB = imp_implementationWithBlock(unsafeBitCast(replaceR, to: AnyObject.self))
		
		// Swizzle out the setEdge: method.
		let setEdgeM: Method = class_getInstanceMethod(NSClassFromString("NSDrawerFrame")!, Selector(("setEdge:")))
		class_addMethod(NSClassFromString("NSFrameView")!, Selector(("setEdge:")), replaceB, method_getTypeEncoding(setEdgeM))
		
		// Swizzle out the registerForEdgeChanges: method.
		let registerForEdgeChangesM: Method = class_getInstanceMethod(NSClassFromString("NSDrawerFrame")!, Selector(("registerForEdgeChanges:")))
		class_addMethod(NSClassFromString("NSFrameView")!, Selector(("registerForEdgeChanges:")), replaceB, method_getTypeEncoding(registerForEdgeChangesM))
	}
	
	// Note: must be invoked before drawer is displayed.
	public func __setupModernDrawer() {
		guard let w = self.window else { return }
		w.titlebarAppearsTransparent = true
		w.titleVisibility = .hidden
		w.styleMask = [w.styleMask, .fullSizeContentView] // .resizable
		w.isMovable = false
		w.hasShadow = false
	}
}
