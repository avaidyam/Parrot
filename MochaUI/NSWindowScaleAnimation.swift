import Cocoa

@objc fileprivate protocol _NSWindowPrivate {
    func _setTransformForAnimation(_: CGAffineTransform, anchorPoint: CGPoint)
}

public extension NSWindow {
    public func scale(to scale: Double = 1.0, by anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        let p = anchorPoint
        assert((p.x >= 0.0 && p.x <= 1.0) && (p.y >= 0.0 && p.y <= 1.0),
               "Anchor point coordinates must be between 0 and 1!")
        let q = CGPoint(x: p.x * self.frame.size.width,
                        y: p.y * self.frame.size.height)
        
        // Apply the transformation by transparently using CGSSetWindowTransformAtPlacement()
        let a = CGAffineTransform(scaleX: CGFloat(1.0 / scale), y: CGFloat(1.0 / scale))
        unsafeBitCast(self, to: _NSWindowPrivate.self)
            ._setTransformForAnimation(a, anchorPoint: q)
    }
}

public class NSWindowScaleAnimation: NSAnimation {
    
    public var window: NSWindow!
    public var startScale: Double = 1.0
    public var endScale: Double = 1.0
    public var anchorPoint: CGPoint!
    
    public override var currentProgress: NSAnimationProgress {
        get { return super.currentProgress }
        set { super.currentProgress = newValue
            assert(self.window != nil, "Window must be non-nil!")
            assert(self.startScale >= 0.0, "Start scale must be greater than 0!")
            assert(self.endScale >= 0.0, "End scale must be greater than 0!")
            assert(self.anchorPoint != nil, "Anchor point must be non-nil!")
            
            // Interpolate scale and apply.
            let scale = self.startScale + ((self.endScale - self.startScale) * Double(newValue))
            self.window.scale(to: scale, by: self.anchorPoint)
        }
    }
}
