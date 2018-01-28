import Foundation
import CoreGraphics

/* TODO: Multiple animation blocks. */
/* TODO: Different interpolators between values (a la CAKeyframeAnimation). */
/* TODO: Use CAAnimation to enable presentation layer (a la UIViewPropertyAnimator). */
/* TODO: Turn on implicit animation in a CATransaction group. */
/* TODO: Better NSColor interpolation. */

private let Interpolate_displayLink = DisplayLink() // global!!
private let Interpolate_backgroundQueue = DispatchQueue(label: "InterpolateCallbackQueue", qos: .userInteractive)

public class AnyInterpolate {
    open var fractionComplete: CGFloat = 0.0
    
    /// All interpolations in the group will not execute their handlers unless the policy is set to .always.
    //@available(*, deprecated: 1.0)
    public static func group(_ interpolations: AnyInterpolate...) -> Interpolate<Double> {
        return Interpolate(from: 0.0, to: 1.0, interpolator: LinearInterpolator()) { progress in
            interpolations.forEach { interp in
                interp.fractionComplete = CGFloat(progress)
            }
        }
    }
}


public class Interpolate<T: Interpolatable>: AnyInterpolate {
    
    public enum HandlerRunPolicy {
        case never
        case onlyWhenAnimating
        case always
    }
    
    fileprivate var fpsObserver: Any? = nil
    
    fileprivate var current: IPValue<T>
    fileprivate let values: [IPValue<T>]
    fileprivate var valuesCount: CGFloat { get { return CGFloat(values.count) } }
    fileprivate var vectorCount: Int { get { return current.components.count } }
    fileprivate var duration: CGFloat = 0.2
    fileprivate var diffVectors = [[CGFloat]]()
    fileprivate let function: Interpolator
    fileprivate var internalProgress: CGFloat = 0.0
    fileprivate var targetProgress: CGFloat = 0.0
    fileprivate var apply: ((Interpolatable) -> ())? = nil
    fileprivate var animationCompletion: (()->())?
    fileprivate var handlers = [Double: [() -> ()]]()
    
    public var handlerRunPolicy = HandlerRunPolicy.onlyWhenAnimating
    
    /**
     Initialises an Interpolate object.
     
     - parameter values:   Array of interpolatable objects, in order.
     - parameter apply:    Apply closure.
     - parameter function: Interpolation function (Basic / Spring / Custom).
     
     - returns: an Interpolate object.
     */
    public init(values: [T], interpolator: Interpolator = LinearInterpolator(), apply: @escaping ((T) -> ())) {
        assert(values.count >= 2, "You should provide at least two values")
        let vectorizedValues = values.map({IPValue(value: $0)})
        self.values = vectorizedValues
        self.current = IPValue(from: self.values[0])
        self.apply = { let _ = ($0 as? T).flatMap(apply) }
        self.function = interpolator
        super.init()
        self.diffVectors = self.calculateDiff(vectorizedValues)
    }
    
    /**
     Initialises an Interpolate object.
     
     - parameter from:     Source interpolatable object.
     - parameter to:       Target interpolatable object.
     - parameter apply:    Apply closure.
     - parameter function: Interpolation function (Basic / Spring / Custom).
     
     - returns: an Interpolate object.
     */
    public convenience init(from: T, to: T, interpolator: Interpolator = LinearInterpolator(), apply: @escaping ((T) -> ())) {
        self.init(values: [from, to], interpolator: interpolator, apply: apply)
    }
    
    public convenience init<A: AnyObject>(values: [T], interpolator: Interpolator = LinearInterpolator(),
                                          on object: A, keyPath: ReferenceWritableKeyPath<A, T>) {
        self.init(values: values, interpolator: interpolator) { value in
            object[keyPath: keyPath] = value
        }
    }
    
    public convenience init<A: AnyObject>(from: T, to: T, interpolator: Interpolator = LinearInterpolator(),
                                          on object: A, keyPath: ReferenceWritableKeyPath<A, T>) {
        self.init(values: [from, to], interpolator: interpolator, on: object, keyPath: keyPath)
    }
    
    /// Progress variable. Takes a value between 0.0 and 1.0. CGFloat. Setting it triggers the apply closure.
    open override var fractionComplete: CGFloat {
        didSet {
            // We make sure fractionComplete is between 0.0 and 1.0
            guard (0.0...1.0).contains(fractionComplete) else {
                fractionComplete = fractionComplete.clamped(to: 0.0...1.0)
                return
            }
            internalProgress = function.apply(fractionComplete)
            let valueForProgress = internalProgress*(valuesCount - 1)
            let diffVectorIndex = max(Int(ceil(valueForProgress)) - 1, 0)
            let diffVector = diffVectors[diffVectorIndex]
            let originValue = values[diffVectorIndex]
            let adjustedProgress = valueForProgress - CGFloat(diffVectorIndex)
            for index in 0..<vectorCount {
                current.components[index] = originValue.components[index] + diffVector[index]*adjustedProgress
            }
            apply?(current.value)
            
            // Execute handlers if only when animating.
            if self.handlerRunPolicy == .always {
                self._executeHandlers(Double(oldValue), Double(fractionComplete))
            }
        }
    }
    
    public func add(at fractionComplete: Double = 1.0, handler: @escaping () -> ()) {
        self.handlers[fractionComplete, default: []] += [handler]
    }
    
    /**
     Invalidates the apply function
     */
    open func invalidate() {
        self.apply = nil
    }
    
    ///
    public private(set) var animating: Bool = false {
        didSet {
            guard self.animating != oldValue else { return }
            if self.animating {
                self.fpsObserver = Interpolate_displayLink.observe(self.next)
            } else {
                self.fpsObserver = nil
            }
        }
    }
    
    /**
     Animates to a targetProgress with a given duration.
     
     - parameter targetProgress: Target progress value. Optional. If left empty assumes 1.0.
     - parameter duration:       Duration in seconds. CGFloat.
     - parameter completion:     Completion handler. Optional.
     */
    open func animate(_ fractionComplete: CGFloat = 1.0, duration: CGFloat) {
        self.targetProgress = fractionComplete
        self.duration = duration
        
        self.animating = true
    }
    
    /**
     Stops animation.
     */
    open func stop() {
        self.animating = false
    }
    
    /**
     Calculates diff between two IPValues.
     
     - parameter from: Source IPValue.
     - parameter to:   Target IPValue.
     
     - returns: Array of diffs. CGFloat
     */
    fileprivate func calculateDiff(_ values: [IPValue<T>]) -> [[CGFloat]] {
        var valuesDiffArray = [[CGFloat]]()
        for i in 0..<(values.count - 1) {
            var diffArray = [CGFloat]()
            let from = values[i]
            let to = values[i+1]
            for index in 0..<from.components.count {
                let vectorDiff = to.components[index] - from.components[index]
                diffArray.append(vectorDiff)
            }
            valuesDiffArray.append(diffArray)
        }
        return valuesDiffArray
    }
    
    /**
     Next function used by animation(). Increments fractionComplete based on the duration.
     */
    @objc fileprivate func next(_ fps: Double = 60.0) {
        
        let direction: CGFloat = (targetProgress > fractionComplete) ? 1.0 : -1.0
        let oldProgress = fractionComplete
        var newProgress = fractionComplete + 1 / (self.duration * CGFloat(fps)) * direction // FIXME: Don't use fps...
        
        // Snap back if the current fractionComplete calls for the animation to stop.
        if (direction > 0 && newProgress >= targetProgress) || (direction < 0 && newProgress <= targetProgress) {
            newProgress = targetProgress
        }
        
        self.fractionComplete = newProgress
        if newProgress == targetProgress {
            stop()
        }
        
        // Execute handlers if only when animating.
        if self.handlerRunPolicy == .onlyWhenAnimating {
            self._executeHandlers(Double(oldProgress), Double(fractionComplete))
        }
    }
    
    // Determine and run all handlers between the previous fractionComplete and the current one.
    private func _executeHandlers(_ old: Double, _ new: Double) {
        Interpolate_backgroundQueue.async {
            // This is required because we check `progress > old` and not `>=`...
            if (old == 0.0) { self.handlers[0.0]?.forEach { $0() } }
            Array(self.handlers.keys).lazy.sorted()
                .filter { (old < $0 && $0 <= new) || (new < $0 && $0 <= old) }
                .forEach { self.handlers[$0]?.forEach { $0() } }
        }
    }
}
