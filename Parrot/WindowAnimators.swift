<<<<<<< Updated upstream
=======
import Cocoa
>>>>>>> Stashed changes
import MochaUI

/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */
// states: nothing-loaded, loading, error, valid view

public protocol WindowAnimator {
    static func show(_ window: NSWindow)
    static func hide(_ window: NSWindow)
}

public struct PopWindowAnimator: WindowAnimator {
    private init() {}
    
    public static func show(_ window: NSWindow) {
        let scale = Interpolate(from: 0.25, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak window] scale in
            window?.scale(to: scale, by: CGPoint(x: 0.5, y: 0.5))
        }
        let alpha = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak window] alpha in
            window?.alphaValue = CGFloat(alpha)
        }
        
        window.scale(to: 0.25, by: CGPoint(x: 0.5, y: 0.5))
        window.alphaValue = 0.0
        window.makeKeyAndOrderFront(nil)
        
<<<<<<< Updated upstream
        let group = AnyInterpolate.group(scale, alpha)
=======
        let group = Interpolate.group(scale, alpha)
>>>>>>> Stashed changes
        group.animate(duration: 0.35)
    }
    
    public static func hide(_ window: NSWindow) {
        let scale = Interpolate(from: 1.0, to: 0.25, interpolator: EaseInOutInterpolator()) { [weak window] scale in
            window?.scale(to: scale, by: CGPoint(x: 0.5, y: 0.5))
        }
        let alpha = Interpolate(from: 1.0, to: 0.0, interpolator: EaseInOutInterpolator()) { [weak window] alpha in
            window?.alphaValue = CGFloat(alpha)
        }
<<<<<<< Updated upstream
        let group = AnyInterpolate.group(scale, alpha)
=======
        let group = Interpolate.group(scale, alpha)
>>>>>>> Stashed changes
        group.add(at: 1.0) {
            DispatchQueue.main.async { [weak window] in
                window?.close()
            }
        }
        group.animate(duration: 0.35)
    }
}

public struct ZoomWindowAnimator: WindowAnimator {
    private init() {}
    
    public static func show(_ window: NSWindow) {
        let new_rect = window.frame
        var rect = window.frame
        rect.origin.y = -(rect.height)
        
        let scale = Interpolate(from: 0.25, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak window] scale in
            window?.scale(to: scale, by: CGPoint(x: 0.5, y: 0.5))
        }
        let alpha = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInInterpolator()) { [weak window] alpha in
            window?.alphaValue = alpha
        }
        let frame = Interpolate(from: rect, to: new_rect, interpolator: EaseInInterpolator()) { [weak window] frame in
            window?.setFrame(frame, display: false)
        }
        
        window.scale(to: 0.25, by: CGPoint(x: 0.5, y: 0.5))
        window.alphaValue = 0.0
        window.setFrame(rect, display: false)
        window.makeKeyAndOrderFront(nil)
        
<<<<<<< Updated upstream
        let group = AnyInterpolate.group(scale, alpha, frame)
=======
        let group = Interpolate.group(scale, alpha, frame)
>>>>>>> Stashed changes
        group.animate(duration: 0.25)
    }
    
    public static func hide(_ window: NSWindow) {
        let old_rect = window.frame
        var rect = window.frame
        rect.origin.y = -(rect.height)
        
        let scale = Interpolate(from: 1.0, to: 0.25, interpolator: EaseInOutInterpolator()) { [weak window] scale in
            window?.scale(to: scale, by: CGPoint(x: 0.5, y: 0.5))
        }
        let alpha = Interpolate(from: 1.0, to: 0.0, interpolator: EaseInInterpolator()) { [weak window] alpha in
            window?.alphaValue = alpha
        }
        let frame = Interpolate(from: old_rect, to: rect, interpolator: EaseInInterpolator()) { [weak window] frame in
            window?.setFrame(frame, display: false)
        }
        
<<<<<<< Updated upstream
        let group = AnyInterpolate.group(scale, alpha, frame)
        group.add {
            DispatchQueue.main.asyncAfter(deadline: 200.milliseconds.later) { [weak window] in
=======
        let group = Interpolate.group(scale, alpha, frame)
        group.add {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { [weak window] in
>>>>>>> Stashed changes
                window?.setFrame(old_rect, display: false)
                window?.alphaValue = 1.0
                window?.scale()
                window?.close()
            }
        }
        group.animate(duration: 0.25)
    }
}
