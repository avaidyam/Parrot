import AppKit
import Mocha

/* TODO: Very naive and possibly incorrect implementation. */

///
public class TouchSwipeRecognizer: NSGestureRecognizer {
    public var wantsIndirectTouches: Bool { return true }
    
    /// The average current swipe position of the fingers on the trackpad.
    /// If observing a horizontal swipe, use the `x` value, and if observing
    /// a vertical swipe, use the `y` value. Negative values indicate closer
    /// to the origin (0, 0) of the trackpad in cartesian coordinates.
    public private(set) var value: CGPoint = .zero {
        didSet {
            self.delta = CGVector(dx: self.value.x - oldValue.x, dy: self.value.y - oldValue.y)
        }
    }
    
    /// The change in touch position since the previous touch event.
    /// See `value` for more details.
    public private(set) var delta: CGVector = .zero
    
    /// The internal raw time when the touch event was received.
    private var _time: CFTimeInterval = 0.0 {
        didSet { self.velocity = self._time - oldValue }
    }
    
    /// The duration taken to observe the change since the previous touch event.
    /// A negative value is invalid and implies no event was received.
    public private(set) var velocity: CFTimeInterval = -1.0
    
    ///
    private var initialTouches: Set<NSTouch> = []
    
    public override func reset() {
        self.value = .zero
        self.delta = .zero
        self._time = 0.0
        self.velocity = -1.0
        self.initialTouches = []
    }
    
    public override func touchesBegan(with event: NSEvent) {
        guard event.touches(matching: .any, in: nil).count != 0 else { return } /* already started */
        self.initialTouches = event.touches(matching: .any, in: nil)
        self._time = CACurrentMediaTime()
        self.state = .began
    }
    
    public override func touchesMoved(with event: NSEvent) {
        guard event.touches(matching: .any, in: nil).count == 2 else {
            self.state = .failed; return
        }
        
        let i = self.avg(of: self.initialTouches)
        let o = self.avg(of: event.touches(matching: .any, in: nil))
        self.value = CGPoint(x: o.x - i.x, y: o.y - i.y)
        self._time = CACurrentMediaTime()
        self.state = .changed
    }
    
    public override func touchesEnded(with event: NSEvent) {
        guard event.touches(matching: .any, in: nil).count == 0 else { return }
        self._time = CACurrentMediaTime()
        self.state = .ended
    }
    
    public override func touchesCancelled(with event: NSEvent) {
        guard event.touches(matching: .any, in: nil).count == 0 else { return }
        self._time = CACurrentMediaTime()
        self.state = .cancelled
    }
    
    /// Compute the average touch point of the set.
    private func avg(of touches: Set<NSTouch>) -> CGPoint {
        let total = CGFloat(touches.count)
        let sum = touches
            .map { $0.normalizedPosition }
            .reduce(.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
        return CGPoint(x: sum.x / total, y: sum.y / total)
    }
}
