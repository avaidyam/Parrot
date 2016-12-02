import Foundation
import AppKit
import CoreVideo
import QuartzCore

/* TODO: addHandler(): Run arbitrary blocks at intervals like 0.3, 0.38473, etc. */
// Imp. detail.: dictionary with keys as timings, values as blocks.
/* TODO: Remap to UIViewPropertyAnimator and use CAAnimation to enable presentation layer. */
/* TODO: Global CVDisplayLink to register/unregister with, not per-interpolation. */
/* TODO: Different interpolators between values. */

public protocol Interpolator {
    func apply(_ progress: CGFloat) -> CGFloat
}

public protocol Interpolatable {
    func vectorize() -> IPValue
}

open class Interpolate {
    
    /// Progress variable. Takes a value between 0.0 and 1,0. CGFloat. Setting it triggers the apply closure.
    open var progress: CGFloat = 0.0 {
        didSet {
            // We make sure progress is between 0.0 and 1.0
            progress = max(0, min(progress, 1.0))
            internalProgress = self.internalAdjustedProgress(progress)
            let valueForProgress = internalProgress*(valuesCount - 1)
            let diffVectorIndex = max(Int(ceil(valueForProgress)) - 1, 0)
            let diffVector = diffVectors[diffVectorIndex]
            let originValue = values[diffVectorIndex]
            let adjustedProgress = valueForProgress - CGFloat(diffVectorIndex)
            for index in 0..<vectorCount {
                current.vectors[index] = originValue.vectors[index] + diffVector[index]*adjustedProgress
            }
            apply?(current.toInterpolatable())
        }
    }
    
    fileprivate var current: IPValue
    fileprivate let values: [IPValue]
    fileprivate var valuesCount: CGFloat { get { return CGFloat(values.count) } }
    fileprivate var vectorCount: Int { get { return current.vectors.count } }
    fileprivate var duration: CGFloat = 0.2
    fileprivate var diffVectors = [[CGFloat]]()
    fileprivate let function: Interpolator
    fileprivate var internalProgress: CGFloat = 0.0
    fileprivate var targetProgress: CGFloat = 0.0
    fileprivate var apply: ((Interpolatable) -> ())?
    fileprivate var displayLink: CVDisplayLink?
    fileprivate var animationCompletion:(()->())?
    
    /**
     Initialises an Interpolate object.
     
     - parameter values:   Array of interpolatable objects, in order.
     - parameter apply:    Apply closure.
     - parameter function: Interpolation function (Basic / Spring / Custom).
     
     - returns: an Interpolate object.
     */
    public init<T: Interpolatable>(values: [T], function: Interpolator = LinearInterpolator(), apply: @escaping ((T) -> ())) {
        assert(values.count >= 2, "You should provide at least two values")
        let vectorizedValues = values.map({$0.vectorize()})
        self.values = vectorizedValues
        self.current = IPValue(value: self.values[0])
        self.apply = { let _ = ($0 as? T).flatMap(apply) }
        self.function = function
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
    public convenience init<T: Interpolatable>(from: T, to: T, function: Interpolator = LinearInterpolator(), apply: @escaping ((T) -> ())) {
        let values = [from, to]
        self.init(values: values, function: function, apply: apply)
    }
    
    
    
    /**
     Invalidates the apply function
     */
    open func invalidate() {
        apply = nil
    }
    
    private func createDisplayLink() {
        let displayID = CGMainDisplayID()
        let error = CVDisplayLinkCreateWithCGDisplay(displayID, &displayLink)
        
        guard let dLink = displayLink, kCVReturnSuccess == error else {
            NSLog("Display Link created with error: %d", error)
            displayLink = nil
            return
        }
        
        CVDisplayLinkSetOutputHandler(dLink) { (displayLink, inNow, inOutputTime, flagsIn, flagsOut) -> CVReturn in
            //let deltaTime = 1.0 / (inOutputTime.pointee.rateScalar * Double(inOutputTime.pointee.videoTimeScale) / Double(inOutputTime.pointee.videoRefreshPeriod))
            //print(deltaTime)
            self.next(); return 1
        }
        CVDisplayLinkStart(dLink)
    }
    private func stopDisplayLink() {
        if let v = self.displayLink {CVDisplayLinkStop(v)}
    }
    
    /**
     Animates to a targetProgress with a given duration.
     
     - parameter targetProgress: Target progress value. Optional. If left empty assumes 1.0.
     - parameter duration:       Duration in seconds. CGFloat.
     - parameter completion:     Completion handler. Optional.
     */
    open func animate(_ targetProgress: CGFloat = 1.0, duration: CGFloat, completion:(()->())? = nil) {
        self.targetProgress = targetProgress
        self.duration = duration
        self.animationCompletion = completion
        stopDisplayLink()
        createDisplayLink()
    }
    
    /**
     Stops animation.
     */
    open func stopAnimation() {
        stopDisplayLink()
        animationCompletion?()
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
     Adjusted progress using interpolation function.
     
     - parameter progressValue: Actual progress value. CGFloat.
     
     - returns: Adjusted progress value. CGFloat.
     */
    fileprivate func internalAdjustedProgress(_ progressValue: CGFloat) -> CGFloat {
        return function.apply(progressValue)
    }
    
    /**
     Next function used by animation(). Increments progress based on the duration.
     */
    @objc fileprivate func next(_ fps: Double = 60.0) {
        let direction: CGFloat = (targetProgress > progress) ? 1.0 : -1.0
        progress += 1/(self.duration*CGFloat(fps))*direction
        if (direction > 0 && progress >= targetProgress) || (direction < 0 && progress <= targetProgress) {
            progress = targetProgress
            stopAnimation()
        }
    }
    
}















/**
 Supported interpolatable types.
 */
public enum InterpolatableType {
    /// CATransform3D type.
    case caTransform3D
    /// CGAffineTransform type.
    case cgAffineTransform
    /// CGFloat type.
    case cgFloat
    /// CGPoint type.
    case cgPoint
    /// CGRect type.
    case cgRect
    /// CGSize type.
    case cgSize
    /// ColorHSB type.
    case colorHSB
    /// ColorMonochrome type.
    case colorMonochrome
    /// ColorRGB type.
    case colorRGB
    /// Double type.
    case double
    /// Int type.
    case int
    /// NSNumber type.
    case nsNumber
    /// UIEdgeInsets type.
    case uiEdgeInsets
}

// MARK: Extensions

/// CATransform3D Interpolatable extension.
extension CATransform3D: Interpolatable {
    /**
     Vectorize CATransform3D.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .caTransform3D, vectors: [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44])
    }
}

/// CGAffineTransform Interpolatable extension.
extension CGAffineTransform: Interpolatable {
    /**
     Vectorize CGAffineTransform.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgAffineTransform, vectors: [a, b, c, d, tx, ty])
    }
}

/// CGFloat Interpolatable extension.
extension CGFloat: Interpolatable {
    /**
     Vectorize CGFloat.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgFloat, vectors: [self])
    }
}

/// CGPoint Interpolatable extension.
extension CGPoint: Interpolatable {
    /**
     Vectorize CGPoint.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgPoint, vectors: [x, y])
    }
}

/// CGRect Interpolatable extension.
extension CGRect: Interpolatable {
    /**
     Vectorize CGRect.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgRect, vectors: [origin.x, origin.y, size.width, size.height])
    }
}

/// CGSize Interpolatable extension.
extension CGSize: Interpolatable {
    /**
     Vectorize CGSize.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgSize, vectors: [width, height])
    }
}

/// Double Interpolatable extension.
extension Double: Interpolatable {
    /**
     Vectorize Double.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .double, vectors: [CGFloat(self)])
    }
}

/// Int Interpolatable extension.
extension Int: Interpolatable {
    /**
     Vectorize Int.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .int, vectors: [CGFloat(self)])
    }
}

/// NSNumber Interpolatable extension.
extension NSNumber: Interpolatable {
    /**
     Vectorize NSNumber.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .nsNumber, vectors: [CGFloat(self)])
    }
}

/// UIColor Interpolatable extension.
extension NSColor: Interpolatable {
    /**
     Vectorize UIColor.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if [NSCalibratedRGBColorSpace, NSDeviceRGBColorSpace].contains(colorSpaceName) {
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return IPValue(type: .colorRGB, vectors: [red, green, blue, alpha])
        }
        
        var white: CGFloat = 0
        if [NSCalibratedWhiteColorSpace, NSDeviceWhiteColorSpace].contains(colorSpaceName) {
            getWhite(&white, alpha: &alpha)
            return IPValue(type: .colorMonochrome, vectors: [white, alpha])
        }
        
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return IPValue(type: .colorHSB, vectors: [hue, saturation, brightness, alpha])
    }
}

/// UIEdgeInsets Interpolatable extension.
extension EdgeInsets: Interpolatable {
    /**
     Vectorize UIEdgeInsets.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .uiEdgeInsets, vectors: [top, left, bottom, right])
    }
}

/// IPValue class. Contains a vectorized version of an Interpolatable type.
open class IPValue {
    
    let type: InterpolatableType
    var vectors: [CGFloat]
    
    init(value: IPValue) {
        self.vectors = value.vectors
        self.type = value.type
    }
    
    init (type: InterpolatableType, vectors: [CGFloat]) {
        self.vectors = vectors
        self.type = type
    }
    
    func toInterpolatable() -> Interpolatable {
        switch type {
        case .caTransform3D:
            return CATransform3D(m11: vectors[0], m12: vectors[1], m13: vectors[2], m14: vectors[3], m21: vectors[4], m22: vectors[5], m23: vectors[6], m24: vectors[7], m31: vectors[8], m32: vectors[9], m33: vectors[10], m34: vectors[11], m41: vectors[12], m42: vectors[13], m43: vectors[14], m44: vectors[15])
        case .cgAffineTransform:
            return CGAffineTransform(a: vectors[0], b: vectors[1], c: vectors[2], d: vectors[3], tx: vectors[4], ty: vectors[5])
        case .cgFloat:
            return vectors[0]
        case .cgPoint:
            return CGPoint(x: vectors[0], y: vectors[1])
        case .cgRect:
            return CGRect(x: vectors[0], y: vectors[1], width: vectors[2], height: vectors[3])
        case .cgSize:
            return CGSize(width: vectors[0], height: vectors[1])
        case .colorRGB:
            return NSColor(red: vectors[0], green: vectors[1], blue: vectors[2], alpha: vectors[3])
        case .colorMonochrome:
            return NSColor(white: vectors[0], alpha: vectors[1])
        case .colorHSB:
            return NSColor(hue: vectors[0], saturation: vectors[1], brightness: vectors[2], alpha: vectors[3])
        case .double:
            return Double(vectors[0])
        case .int:
            return Int(vectors[0])
        case .nsNumber:
            return NSNumber(value: Double(vectors[0]))
        case .uiEdgeInsets:
            return NSEdgeInsetsMake(vectors[0], vectors[1], vectors[2], vectors[3]) as EdgeInsets
        }
    }
    
}































public struct LinearInterpolator: Interpolator {
    public func apply(_ progress: CGFloat) -> CGFloat {
        return progress
    }
}

public struct EaseInInterpolator: Interpolator {
    public func apply(_ progress: CGFloat) -> CGFloat {
        return progress*progress*progress
    }
}

public struct EaseOutInterpolator: Interpolator {
    public func apply(_ progress: CGFloat) -> CGFloat {
        return (progress - 1)*(progress - 1)*(progress - 1) + 1.0
    }
}

public struct EaseInOutInterpolator: Interpolator {
    public func apply(_ progress: CGFloat) -> CGFloat {
        if progress < 0.5 {
            return 4.0*progress*progress*progress
        } else {
            let adjustment = (2*progress - 2)
            return 0.5 * adjustment * adjustment * adjustment + 1.0
        }
    }
}

public struct SpringInterpolator: Interpolator {
    
    public var damping: CGFloat = 10.0
    public var velocity: CGFloat = 0.0
    public var mass: CGFloat = 1.0
    public var stiffness: CGFloat = 100.0
    
    public func apply(_ progress: CGFloat) -> CGFloat {
        if damping <= 0.0 || stiffness <= 0.0 || mass <= 0.0 {
            fatalError("Incorrect animation values")
        }
        
        let beta = damping / (2 * mass)
        let omega0 = sqrt(stiffness / mass)
        let omega1 = sqrt((omega0 * omega0) - (beta * beta))
        let omega2 = sqrt((beta * beta) - (omega0 * omega0))
        
        let x0: CGFloat = -1
        let oscillation: (CGFloat) -> CGFloat
        if beta < omega0 { // Underdamped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                
                let part2: CGFloat = x0 * cos(omega1 * t)
                let part3: CGFloat = ((beta * x0 + self.velocity) / omega1) * sin(omega1 * t)
                return -x0 + envelope * (part2 + part3)
            }
        } else if beta == omega0 { // Critically damped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                return -x0 + envelope * (x0 + (beta * x0 + self.velocity) * t)
            }
        } else { // Overdamped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                let part2: CGFloat = x0 * cosh(omega2 * t)
                let part3: CGFloat = ((beta * x0 + self.velocity) / omega2) * sinh(omega2 * t)
                return -x0 + envelope * (part2 + part3)
            }
        }
        return oscillation(progress)
    }
}
