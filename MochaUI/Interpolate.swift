import Foundation
import AppKit
import CoreVideo
import QuartzCore

/* TODO: Multiple animation blocks (after adding generics to Interpolate). */
/* TODO: Different interpolators between values (a la CAKeyframeAnimation). */
/* TODO: Use CAAnimation to enable presentation layer (a la UIViewPropertyAnimator). */

public protocol Interpolator {
    func apply(_ progress: CGFloat) -> CGFloat
}

public protocol Interpolatable {
    func vectorize() -> IPValue
}

public class DisplayLink {
    
    public typealias Target = (target: Any, id: UUID, action: (Double) -> ())
    
    public static var backgroundQueue: DispatchQueue = DispatchQueue(label: "DisplayLinkCallbackQueue", qos: .userInteractive)
    public static var animationQueue: DispatchQueue = DispatchQueue.main
    
    private var displayLink: CVDisplayLink?
    private var targets = [UUID: Target]()
    
    private func createDisplayLink() {
        let error = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard let dLink = displayLink, kCVReturnSuccess == error else {
            NSLog("Display Link created with error: %d", error)
            self.displayLink = nil
            return
        }
        
        /// nowTime is the current frame time, and outputTime is when the frame will be displayed.
        CVDisplayLinkSetOutputHandler(dLink) { (_, nowTime, outputTime, _, _) in
            let fps = (outputTime.pointee.rateScalar * Double(outputTime.pointee.videoTimeScale) / Double(outputTime.pointee.videoRefreshPeriod))
            DisplayLink.animationQueue.async {
                self.targets.values.forEach {
                    $0.action(fps)
                }
            }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(dLink)
    }
    private func stopDisplayLink() {
        if let v = self.displayLink {
            CVDisplayLinkStop(v)
            self.displayLink = nil
        }
    }
    
    public func add(target: Target) {
        self.targets[target.id] = target
        if self.displayLink == nil && self.targets.count > 0 {
            createDisplayLink()
        }
    }
    public func remove(target: Target) {
        self.targets[target.id] = nil
        if self.displayLink != nil && self.targets.count == 0 {
            stopDisplayLink()
        }
    }
}

open class Interpolate {
    
    public enum HandlerRunPolicy {
        case never
        case onlyWhenAnimating
        case always
    }
    
    private static let displayLink = DisplayLink()
    
    fileprivate let id = UUID()
    fileprivate var current: IPValue
    fileprivate let values: [IPValue]
    fileprivate var valuesCount: CGFloat { get { return CGFloat(values.count) } }
    fileprivate var vectorCount: Int { get { return current.vectors.count } }
    fileprivate var duration: CGFloat = 0.2
    fileprivate var diffVectors = [[CGFloat]]()
    fileprivate let function: Interpolator
    fileprivate var internalProgress: CGFloat = 0.0
    fileprivate var targetProgress: CGFloat = 0.0
    fileprivate var apply: ((Interpolatable) -> ())? = nil
    fileprivate var animationCompletion: (()->())?
    fileprivate var handlers = [Double: [() -> ()]]()
    
    public var handlerRunPolicy = HandlerRunPolicy.onlyWhenAnimating
    
    /// All interpolations in the group will not execute their handlers unless the policy is set to .always.
    public static func group(_ interpolations: Interpolate ...) -> Interpolate {
        return Interpolate(from: 0.0, to: 1.0, interpolator: LinearInterpolator()) { progress in
            interpolations.forEach {
                $0.fractionComplete = CGFloat(progress)
            }
        }
    }
    
    /**
     Initialises an Interpolate object.
     
     - parameter values:   Array of interpolatable objects, in order.
     - parameter apply:    Apply closure.
     - parameter function: Interpolation function (Basic / Spring / Custom).
     
     - returns: an Interpolate object.
     */
    public init<T: Interpolatable>(values: [T], interpolator: Interpolator = LinearInterpolator(), apply: @escaping ((T) -> ())) {
        assert(values.count >= 2, "You should provide at least two values")
        let vectorizedValues = values.map({$0.vectorize()})
        self.values = vectorizedValues
        self.current = IPValue(value: self.values[0])
        self.apply = { let _ = ($0 as? T).flatMap(apply) }
        self.function = interpolator
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
    public convenience init<T: Interpolatable>(from: T, to: T, interpolator: Interpolator = LinearInterpolator(), apply: @escaping ((T) -> ())) {
        let values = [from, to]
        self.init(values: values, interpolator: interpolator, apply: apply)
    }
    
    /// Progress variable. Takes a value between 0.0 and 1,0. CGFloat. Setting it triggers the apply closure.
    open var fractionComplete: CGFloat = 0.0 {
        didSet {
            // We make sure fractionComplete is between 0.0 and 1.0
            fractionComplete = max(0, min(fractionComplete, 1.0))
            internalProgress = function.apply(fractionComplete)
            let valueForProgress = internalProgress*(valuesCount - 1)
            let diffVectorIndex = max(Int(ceil(valueForProgress)) - 1, 0)
            let diffVector = diffVectors[diffVectorIndex]
            let originValue = values[diffVectorIndex]
            let adjustedProgress = valueForProgress - CGFloat(diffVectorIndex)
            for index in 0..<vectorCount {
                current.vectors[index] = originValue.vectors[index] + diffVector[index]*adjustedProgress
            }
            apply?(current.toInterpolatable())
            
            // Execute handlers if only when animating.
            if self.handlerRunPolicy == .always {
                self._executeHandlers(Double(oldValue), Double(fractionComplete))
            }
        }
    }
    
    public func add(at fractionComplete: Double = 1.0, handler: @escaping () -> ()) {
        if self.handlers[fractionComplete] != nil {
            self.handlers[fractionComplete]! += [handler]
        } else {
            self.handlers[fractionComplete] = [handler]
        }
    }
    
    /**
     Invalidates the apply function
     */
    open func invalidate() {
        apply = nil
    }
    
    ///
    public private(set) var animating: Bool = false {
        didSet {
            if self.animating {
                Interpolate.displayLink.add(target: (self, self.id, self.next))
            } else {
                Interpolate.displayLink.remove(target: (self, self.id, self.next))
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
    fileprivate func calculateDiff(_ values: [IPValue]) -> [[CGFloat]] {
        var valuesDiffArray = [[CGFloat]]()
        for i in 0..<(values.count - 1) {
            var diffArray = [CGFloat]()
            let from = values[i]
            let to = values[i+1]
            for index in 0..<from.vectors.count {
                let vectorDiff = to.vectors[index] - from.vectors[index]
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
        DisplayLink.backgroundQueue.async {
            // This is required because we check `progress > old` and not `>=`...
            /*if (old == 0.0) { self.handlers[0.0]?.forEach { $0() } }*/
            Array(self.handlers.keys).lazy.sorted()
                .filter { (old < $0 && $0 <= new) || (new < $0 && $0 <= old) }
                .forEach { self.handlers[$0]?.forEach { $0() } }
        }
    }
}
