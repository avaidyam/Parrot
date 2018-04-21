import AppKit
import Mocha

/// Dispatch indirect touch events to `NSGestureRecognizer`s.
/// TODO: It's better to set `NSWindow.gestureMask` and do this in `sendEvent:`.
public final class IndirectTouchTracker {
    private var listener: SystemEventListener? = nil
    
    public init() {
        self.listener = SystemEventListener(for: .touches) {
            self.dispatch($0)
        }
        DispatchQueue.main.async {
            RunLoop.current.add(self.listener!, to: .defaultRunLoopMode, .eventTrackingMode)
        }
    }
    
    /// Dispatch the `event` to any interested `NSGestureRecognizer`s.
    private func dispatch(_ event: NSEvent) {
        guard event.touches(matching: .any, in: nil).count >= 2 else { return } /* two-finger swipe only */
        guard   let window = NSApp.window(withWindowNumber: event.windowNumber),
            let view = (window.value(forKey: "borderView") as! NSView)
                .hitTest(event.locationInWindow)
            else { return } /* locate the specific view under the pointer */
        
        event.touches(matching: .any, in: nil).forEach { $0.setValue(view, forKey: "view") }
        view.gestureRecognizers
            .filter { ($0 as TouchableRecognizer).wantsIndirectTouches ?? false }
            .forEach { g in
                if event.touches(matching: .began, in: nil).count > 0 {
                    let sel = Selector("touchesBeganWithEvent" + ":")
                    if g.responds(to: sel) { g.perform(sel, with: event) }
                }
                if event.touches(matching: .moved, in: nil).count > 0 {
                    let sel = Selector("touchesMovedWithEvent" + ":")
                    if g.responds(to: sel) { g.perform(sel, with: event) }
                }
                if event.touches(matching: .ended, in: nil).count > 0 {
                    let sel = Selector("touchesEndedWithEvent" + ":")
                    if g.responds(to: sel) { g.perform(sel, with: event) }
                }
                if event.touches(matching: .cancelled, in: nil).count > 0 {
                    let sel = Selector("touchesCancelledWithEvent" + ":")
                    if g.responds(to: sel) { g.perform(sel, with: event) }
                }
        }
    }
}

public extension NSGestureRecognizer {
    
    /// `NSGestureRecognizer`s that request indirect touches (`wantsIndirectTouches`)
    /// will receive them if the value of this property is `true`.
    public class var wantsIndirectTouches: Bool {
        get { return _tracker != nil }
        set {
            if _tracker != nil && !newValue {
                _tracker = nil
            } else if _tracker == nil && newValue {
                _tracker = IndirectTouchTracker()
            }
        }
    }
}
fileprivate var _tracker: IndirectTouchTracker? = nil

@objc public protocol TouchableRecognizer { // pre-Sierra support.
    @objc optional var wantsIndirectTouches: Bool { get }
}
extension NSGestureRecognizer: TouchableRecognizer {}
