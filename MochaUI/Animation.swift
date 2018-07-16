import AppKit
import Mocha
import QuartzCore

// custom interpolators?
// isAdditive, isCumulative?
//
// auto-fill-forward without keeping anim
// auto-fill-backward before start of anim
// delegate + removedOnCompletion ignored in groups...
//    - use CACurrentMediaTime() and beginTime offset for everything
//    - calayer's addAnim:... allows individual completion blocks

protocol Animatable {
    func animate(_: Animation)
}

public struct Animation {
    fileprivate let underlying: CAAnimation
    
    /// repeat amount and whether to autoreverse
    public enum Repeat {
        case times(Float, Bool)
        case `for`(DispatchTimeInterval, Bool)
    }
    
    //
    private class UnderlyingDelegate: NSObject, CAAnimationDelegate {
        private let handler: () -> ()
        fileprivate init(_ handler: @escaping () -> ()) {
            self.handler = handler
        }
        @objc dynamic public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            self.handler()
        }
    }
    
    ///
    public static func of<T>(_ keyPath: KeyPath<CALayer, T>, from fromValue: T? = nil,
                             by byValue: T? = nil, to toValue: T? = nil,
                             for duration: DispatchTimeInterval = 250.milliseconds,
                             then handler: (() -> ())? = nil) -> Animation
    {
        assert(!(fromValue == nil && byValue == nil && toValue == nil),
               "An animation must always have at least one interpolating segment.")
        
        let anim = CABasicAnimation(keyPath: keyPath._kvcKeyPathString!)
        anim.duration = duration.toSeconds()
        anim.fromValue = fromValue
        anim.byValue = byValue
        anim.toValue = toValue
        //anim.isAdditive = ???
        
        if let handler = handler {
            anim.delegate = UnderlyingDelegate(handler)
        }
        return Animation(underlying: anim)
    }
    
    ///
    public static func with(animation anim: CAAnimation) -> Animation {
        return Animation(underlying: anim)
    }
    
    ///
    public static func `repeat`(_ root: Animation, behavior: Repeat) -> Animation {
        let anim = root.underlying
        switch behavior {
        case .times(let t, let a):
            anim.repeatCount = t
            anim.autoreverses = a
        case .for(let t, let a):
            anim.repeatDuration = t.toSeconds()
            anim.autoreverses = a
        }
        //anim.isCumulative = ???
        return Animation(underlying: anim)
    }
    
    ///
    public static func group(_ group: [Animation], timing: CAMediaTimingFunction = .linear,
                             then handler: (() -> ())? = nil) -> Animation {
        assert(group.count > 0, "An animation group must always have at least one element.")
        
        let anim = CAAnimationGroup()
        anim.timingFunction = timing
        anim.animations = group.map { $0.underlying }
        anim.duration = group.map { $0.underlying.duration }.max() ?? 0.0
        
        if let handler = handler {
            anim.delegate = UnderlyingDelegate(handler)
        }
        return Animation(underlying: anim)
    }
    
    ///
    public static func sequence(_ group: [Animation], timing: CAMediaTimingFunction = .linear,
                                then handler: (() -> ())? = nil) -> Animation {
        assert(group.count > 0, "An animation sequence must always have at least one element.")
        
        let anim = CAAnimationGroup()
        anim.timingFunction = timing
        anim.animations = group.map { $0.underlying }
        
        // Adjust beginTimes to sequentialize:
        var _time: CFTimeInterval = 0
        anim.animations?.forEach {
            $0.beginTime = _time
            _time += $0.duration
            
            // FILL MODE ISSUE HERE:
            $0.fillMode = kCAFillModeForwards
        }
        anim.duration = _time
        
        if let handler = handler {
            anim.delegate = UnderlyingDelegate(handler)
        }
        return Animation(underlying: anim)
    }
}

extension NSView: Animatable {
    public func animate(_ anim: Animation) {
        self.layer?.add(anim.underlying, forKey: nil)
    }
}

extension CALayer: Animatable {
    public func animate(_ anim: Animation) {
        self.add(anim.underlying, forKey: nil)
    }
}

public extension CGColor {
    public static func ns(_ color: NSColor) -> CGColor {
        return color.cgColor
    }
}

public extension CAMediaTimingFunction {
    public static let `default` = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
    public static let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    public static let easeIn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    public static let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    public static let easeInOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
}

// TODO: Switch for actually using NSUIAnimator or the animator() proxy.
public extension NSAnimationContext {
    
    @discardableResult
    public static func animate(duration: DispatchTimeInterval = 250.milliseconds,
                               timingFunction: CAMediaTimingFunction = .linear,
                               _ animations: () -> ()) -> NSAnimationContext
    {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.allowsImplicitAnimation = true
        NSAnimationContext.current.duration = duration.toSeconds()
        NSAnimationContext.current.timingFunction = timingFunction
        animations()
        NSAnimationContext.endGrouping()
        return NSAnimationContext.current
    }
    
    public static func disableAnimations(_ animations: () -> ()) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0
        animations()
        NSAnimationContext.endGrouping()
    }
    
    public func onCompletion(_ handler: @escaping () -> ()) {
        self.completionHandler = handler
    }
}

/*
func sample() -> Animation {
    return .group([
        .sequence([
            .of(\.position, from: layer.position, to: .zero, for: 2.seconds),
            .of(\.position, from: .zero, to: layer.position, for: 2.seconds),
        ]),
        .sequence([
            .of(\.opacity, from: 1.0, to: 0.2, for: 2.seconds) {
                print("opacity forward")
            },
            .of(\.opacity, from: 0.2, to: 1.0, for: 2.seconds) {
                print("opacity backward")
            },
        ]),
        .sequence([
            .of(\.cornerRadius, from: 0.0, to: 10.0, for: 2.seconds) {
                print("oh boy 'round we go")
            },
            .of(\.backgroundColor, from: .black, to: .ns(.red), for: 1.seconds),
            .of(\.cornerRadius, from: 10.0, to: 0.0, for: 1.seconds),
            .of(\.backgroundColor, from: .ns(.red), to: .black, for: 2.seconds),
        ]) {
            print("sequenced")
        }
    ]) {
        print("all done")
    }
}
*/


