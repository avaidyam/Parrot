import AppKit

public extension NSRectEdge {
	
	/// `.leading` is equivalent to either `.minX` or `.maxX` depending on the
	/// system language's UI layout direction.
	public static var leading: NSRectEdge {
		switch NSApp.userInterfaceLayoutDirection {
		case .leftToRight: return .minX
		case .rightToLeft: return .maxX
		}
	}
	
	/// `.trailing` is equivalent to either `.minX` or `.maxX` depending on the
	/// system language's UI layout direction.
	public static var trailing: NSRectEdge {
		switch NSApp.userInterfaceLayoutDirection {
		case .leftToRight: return .maxX
		case .rightToLeft: return .minX
		}
	}
}

public extension NSDrawer {
	
	/// The NSDrawer's window; that is, not its parent window, but the drawer's frame.
	public var window: NSWindow? {
		return self.contentView?.window
	}
	
	/// This function must be invoked to enable the modern drawer theme for macOS 10.10+.
	/// Note: must be invoked at app launch with +initialize.
	public static func __activateModernDrawers() {
		let frameViewClassForStyleMaskR: @convention(block) () -> (AnyClass!) = {
			return NSClassFromString("NSThemeFrame")!
		}
		
		// Swizzle out the frameViewClassForStyleMask: to return a normal NSThemeFrame.
		let frameViewClassForStyleMaskB = imp_implementationWithBlock(unsafeBitCast(frameViewClassForStyleMaskR, to: AnyObject.self))
		let frameViewClassForStyleMaskM: Method = class_getClassMethod(NSClassFromString("NSDrawerWindow")!, Selector(("frameViewClassForStyleMask:")))
		method_setImplementation(frameViewClassForStyleMaskM, frameViewClassForStyleMaskB)
		
		/*
		// Disable the shadow for any drawer windows.
		let shadowR: @convention(block) ()->(Bool) = {false}
		let shadowB = imp_implementationWithBlock(unsafeBitCast(shadowR, to: AnyObject.self))
		let shadowM: Method = class_getInstanceMethod(NSClassFromString("NSDrawerWindow")!, Selector(("hasShadow")))
		method_setImplementation(shadowM, shadowB)
		*/
		
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
	
	/// This function must be invoked in addition to `__activateModernDrawers()` to enable
	/// modern drawers on macOS 10.10+. Note: must be invoked before drawer is displayed.
	public func __setupModernDrawer() {
		guard let w = self.window else { return }
		w.titlebarAppearsTransparent = true
		w.titleVisibility = .hidden
		w.styleMask = [w.styleMask, .fullSizeContentView] // .resizable
		w.isMovable = false
		w.hasShadow = false
	}
}

private var NSPopover_preferredEdge_key: UnsafePointer<Void>? = nil
private var NSPopover_positioningView_key: UnsafePointer<Void>? = nil

public extension NSPopover {
	
	@IBInspectable var edgeIB: Int {
		get { return Int(self.preferredEdge.rawValue) }
		set { self.preferredEdge = NSRectEdge(rawValue: UInt(newValue))! }
	}
	
	public var preferredEdge: NSRectEdge {
		get { return NSRectEdge(rawValue: objc_getAssociatedObject(self, &NSPopover_preferredEdge_key) as? UInt ?? 0)! }
		set { objc_setAssociatedObject(self, &NSPopover_preferredEdge_key, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	
	@IBOutlet public var positioningView: NSView? {
		get { return objc_getAssociatedObject(self, &NSPopover_positioningView_key) as? NSView }
		set { objc_setAssociatedObject(self, &NSPopover_positioningView_key, newValue, .OBJC_ASSOCIATION_ASSIGN) }
	}
	
	@IBAction public func performOpen(_ sender: AnyObject?) {
		guard let posView = self.positioningView else { return }
		log.debug("opening popover at \(posView) on edge \(self.preferredEdge.rawValue)")
		self.show(relativeTo: self.positioningRect, of: posView, preferredEdge: self.preferredEdge)
	}
	
	@IBAction public func performToggle(_ sender: AnyObject?) {
		if self.isShown {
			self.performClose(sender)
		} else {
			self.performOpen(sender)
		}
	}
}
