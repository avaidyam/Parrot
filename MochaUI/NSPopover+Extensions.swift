import AppKit
import Mocha

public extension NSPopover {
    private static var edgeProp = AssociatedProperty<NSPopover, NSRectEdge>(.strong)
    private static var positioningViewProp = AssociatedProperty<NSPopover, NSView>(.strong)
    
    public var preferredEdge: NSRectEdge {
        get { return NSPopover.edgeProp[self, default: .minX] }
        set { NSPopover.edgeProp[self] = newValue }
    }
    
    @IBOutlet public var relativePositioningView: NSView? {
        get { return NSPopover.positioningViewProp[self] }
        set { NSPopover.positioningViewProp[self] = newValue }
    }
    
    @IBOutlet public var contentView: NSView? {
        get { return self.contentViewController?.view }
        set {
            guard newValue != nil else { return }
            if self.contentViewController == nil {
                self.contentViewController = NSViewController()
            }
            self.contentViewController?.view = newValue!
        }
    }
    
    @IBAction public func performOpen(_ sender: Any?) {
        guard let posView = self.relativePositioningView else { return }
        self.show(relativeTo: self.positioningRect, of: posView, preferredEdge: self.preferredEdge)
    }
    
    @IBAction public func performToggle(_ sender: Any?) {
        if self.isShown {
            self.performClose(sender)
        } else {
            self.performOpen(sender)
        }
    }
}
