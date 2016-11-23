import Cocoa

@objc fileprivate protocol _NSWindowPrivate {
    func _setTransformForAnimation(_: CGAffineTransform, anchorPoint: CGPoint)
}
public class NSWindowScaleAnimation: NSAnimation {
    
    public var window: NSWindow!
    public var startScale: Double = 1.0
    public var endScale: Double = 1.0
    public var normalizedAnchorPoint: CGPoint!
    
    public override var currentProgress: NSAnimationProgress {
        get { return super.currentProgress }
        set { super.currentProgress = newValue
            
            // Clear all assertions first.
            let p = self.normalizedAnchorPoint
            assert(self.window != nil, "Window must be non-nil!")
            assert(self.startScale >= 0.0, "Start transform must be non-nil!")
            assert(self.endScale >= 0.0, "End transform must be non-nil!")
            assert(p != nil, "Anchor point must be non-nil!")
            assert((p!.x >= 0.0 && p!.x <= 1.0) && (p!.y >= 0.0 && p!.y <= 1.0),
                   "Anchor point coordinates must be between 0 and 1!")
            
            // Interpolate transform and normalize anchor point.
            let q = CGPoint(x: p!.x * self.window.frame.size.width,
                            y: p!.y * self.window.frame.size.height)
            let ss = 1.0 / self.startScale, es = 1.0 / self.endScale
            let scale = ss + ((es - ss) * Double(newValue))
            let a = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            
            // Apply the transformation by transparently using CGSSetWindowTransformAtPlacement()
            unsafeBitCast(self.window, to: _NSWindowPrivate.self)
                ._setTransformForAnimation(a, anchorPoint: q)
        }
    }
}
