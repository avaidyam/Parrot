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

public extension NSPopover {
    
    @IBInspectable var edgeIB: Int {
        get { return Int(self.preferredEdge.rawValue) }
        set { self.preferredEdge = NSRectEdge(rawValue: UInt(newValue))! }
    }
    
    public var preferredEdge: NSRectEdge {
        get { return NSRectEdge(rawValue: objc_getAssociatedObject(self, &NSPopover_preferredEdge_key) as? UInt ?? 0)! }
        set { objc_setAssociatedObject(self, &NSPopover_preferredEdge_key, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @IBOutlet public var relativePositioningView: NSView? {
        get { return objc_getAssociatedObject(self, &NSPopover_positioningView_key) as? NSView }
        set { objc_setAssociatedObject(self, &NSPopover_positioningView_key, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    @IBAction public func performOpen(_ sender: AnyObject?) {
        guard let posView = self.relativePositioningView else { return }
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

private var NSPopover_preferredEdge_key: UnsafeRawPointer? = nil
private var NSPopover_positioningView_key: UnsafeRawPointer? = nil
