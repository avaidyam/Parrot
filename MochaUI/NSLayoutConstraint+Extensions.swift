//  Anchorage
//  Copyright 2016 Raizlabs (Rob Visentin) and other contributors (http://raizlabs.com/)

#if os(macOS)
    import Cocoa
    internal typealias View = NSView
    internal typealias ViewController = NSViewController
    internal typealias LayoutGuide = NSLayoutGuide
    
#if swift(>=4.0)
    public typealias LayoutPriority = NSLayoutConstraint.Priority
    public typealias EdgeInsets = NSEdgeInsets
    public typealias ConstraintAttribute = NSLayoutConstraint.Attribute
    
    internal let LayoutPriorityRequired = NSLayoutConstraint.Priority.required
    internal let LayoutPriorityHigh = NSLayoutConstraint.Priority.defaultHigh
    internal let LayoutPriorityLow = NSLayoutConstraint.Priority.defaultLow
    internal let LayoutPriorityFittingSize = NSLayoutConstraint.Priority.fittingSizeCompression
#else
    public typealias LayoutPriority = NSLayoutPriority
    public typealias ConstraintAttribute = NSLayoutAttribute
    
    internal let LayoutPriorityRequired = NSLayoutPriorityRequired
    internal let LayoutPriorityHigh = NSLayoutPriorityDefaultHigh
    internal let LayoutPriorityLow = NSLayoutPriorityDefaultLow
    internal let LayoutPriorityFittingSize = NSLayoutPriorityFittingSizeCompression
#endif
#else
    import UIKit
    internal typealias View = UIView
    internal typealias ViewController = UIViewController
    internal typealias LayoutGuide = UILayoutGuide
    
    public typealias LayoutPriority = UILayoutPriority
    public typealias EdgeInsets = UIEdgeInsets
    public typealias ConstraintAttribute = NSLayoutAttribute
#if swift(>=4.0)
    internal let LayoutPriorityRequired = UILayoutPriority.required
    internal let LayoutPriorityHigh = UILayoutPriority.defaultHigh
    internal let LayoutPriorityLow = UILayoutPriority.defaultLow
    internal let LayoutPriorityFittingSize = UILayoutPriority.fittingSizeLevel
#else
    internal let LayoutPriorityRequired = UILayoutPriorityRequired
    internal let LayoutPriorityHigh = UILayoutPriorityDefaultHigh
    internal let LayoutPriorityLow = UILayoutPriorityDefaultLow
    internal let LayoutPriorityFittingSize = UILayoutPriorityFittingSizeLevel
#endif
#endif

#if swift(>=4.0)
#else
    extension LayoutPriority {
        var rawValue: Float {
            return self
        }
        init(rawValue: Float) {
            self.init(rawValue)
        }
    }
#endif

public protocol LayoutConstantType {}
extension CGFloat: LayoutConstantType {}
extension CGSize: LayoutConstantType {}
extension EdgeInsets: LayoutConstantType {}

public protocol LayoutAnchorType {}
extension NSLayoutAnchor: LayoutAnchorType {}

extension CGFloat {
    init<T: BinaryFloatingPoint>(_ value: T) {
        switch value {
        case is Double:
            self.init(value as! Double)
        case is Float:
            self.init(value as! Float)
        case is CGFloat:
            self.init(value as! CGFloat)
        default:
            fatalError("Unable to initialize CGFloat with value \(value) of type \(type(of: value))")
        }
    }
}

extension Float {
    init<T: BinaryFloatingPoint>(_ value: T) {
        switch value {
        case is Double:
            self.init(value as! Double)
        case is Float:
            self.init(value as! Float)
        case is CGFloat:
            self.init(value as! CGFloat)
        default:
            fatalError("Unable to initialize CGFloat with value \(value) of type \(type(of: value))")
        }
    }
}

public struct LayoutExpression<T: LayoutAnchorType, U: LayoutConstantType> {
    public var anchor: T?
    public var constant: U
    public var multiplier: CGFloat
    public var priority: Priority
    
    internal init(anchor: T? = nil, constant: U, multiplier: CGFloat = 1.0, priority: Priority = .required) {
        self.anchor = anchor
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
    }
}

public struct AnchorPair<T: LayoutAnchorType, U: LayoutAnchorType>: LayoutAnchorType {
    public var first: T
    public var second: U
    
    internal init(first: T, second: U) {
        self.first = first
        self.second = second
    }
}

internal extension AnchorPair {
    func finalize(constraintsEqualToConstant size: CGSize, priority: Priority = .required) -> ConstraintPair {
        return constraints(forConstant: size, priority: priority, builder: ConstraintBuilder.equality);
    }
    
    func finalize(constraintsLessThanOrEqualToConstant size: CGSize, priority: Priority = .required) -> ConstraintPair {
        return constraints(forConstant: size, priority: priority, builder: ConstraintBuilder.lessThanOrEqual);
    }
    
    func finalize(constraintsGreaterThanOrEqualToConstant size: CGSize, priority: Priority = .required) -> ConstraintPair {
        return constraints(forConstant: size, priority: priority, builder: ConstraintBuilder.greaterThanOrEqual);
    }
    
    func finalize(constraintsEqualToEdges anchor: AnchorPair<T, U>?, constant c: CGFloat = 0.0, priority: Priority = .required) -> ConstraintPair {
        return constraints(forAnchors: anchor, constant: c, priority: priority, builder: ConstraintBuilder.equality)
    }
    
    func finalize(constraintsLessThanOrEqualToEdges anchor: AnchorPair<T, U>?, constant c: CGFloat = 0.0, priority: Priority = .required) -> ConstraintPair {
        return constraints(forAnchors: anchor, constant: c, priority: priority, builder: ConstraintBuilder.lessThanOrEqual)
    }
    
    func finalize(constraintsGreaterThanOrEqualToEdges anchor: AnchorPair<T, U>?, constant c: CGFloat = 0.0, priority: Priority = .required) -> ConstraintPair {
        return constraints(forAnchors: anchor, constant: c, priority: priority, builder: ConstraintBuilder.greaterThanOrEqual)
    }
    
    func constraints(forConstant size: CGSize, priority: Priority, builder: ConstraintBuilder) -> ConstraintPair {
        var constraints: ConstraintPair!
        performInBatch {
            switch (first, second) {
            case let (first as NSLayoutDimension, second as NSLayoutDimension):
                constraints = ConstraintPair(
                    first: builder.dimensionBuilder(first, size.width ~ priority),
                    second: builder.dimensionBuilder(second, size.height ~ priority)
                )
            default:
                preconditionFailure("Only AnchorPair<NSLayoutDimension, NSLayoutDimension> can be constrained to a constant size.")
            }
        }
        return constraints;
    }
    
    func constraints(forAnchors anchors: AnchorPair<T, U>?, constant c: CGFloat, priority: Priority, builder: ConstraintBuilder) -> ConstraintPair {
        return constraints(forAnchors: anchors, firstConstant: c, secondConstant: c, priority: priority, builder: builder)
    }
    
    func constraints(forAnchors anchors: AnchorPair<T, U>?, firstConstant c1: CGFloat, secondConstant c2: CGFloat, priority: Priority, builder: ConstraintBuilder) -> ConstraintPair {
        guard let anchors = anchors else {
            preconditionFailure("Encountered nil edge anchors, indicating internal inconsistency of this API.")
        }
        
        var constraints: ConstraintPair!
        performInBatch {
            switch (first, anchors.first, second, anchors.second) {
            // Leading, Trailing
            case let (firstX as NSLayoutXAxisAnchor, otherFirstX as NSLayoutXAxisAnchor,
                      secondX as NSLayoutXAxisAnchor, otherSecondX as NSLayoutXAxisAnchor):
                constraints = ConstraintPair(
                    first: builder.leadingBuilder(firstX, otherFirstX + c1 ~ priority),
                    second: builder.trailingBuilder(secondX, otherSecondX - c2 ~ priority)
                )
            // Top, Bottom
            case let (firstY as NSLayoutYAxisAnchor, otherFirstY as NSLayoutYAxisAnchor,
                      secondY as NSLayoutYAxisAnchor, otherSecondY as NSLayoutYAxisAnchor):
                constraints = ConstraintPair(
                    first: builder.topBuilder(firstY, otherFirstY + c1 ~ priority),
                    second: builder.bottomBuilder(secondY, otherSecondY - c2 ~ priority)
                )
            // CenterX, CenterY
            case let (firstX as NSLayoutXAxisAnchor, otherFirstX as NSLayoutXAxisAnchor,
                      firstY as NSLayoutYAxisAnchor, otherFirstY as NSLayoutYAxisAnchor):
                constraints = ConstraintPair(
                    first: builder.centerXBuilder(firstX, otherFirstX + c1 ~ priority),
                    second: builder.centerYBuilder(firstY, otherFirstY + c2 ~ priority)
                )
            // Width, Height
            case let (first as NSLayoutDimension, otherFirst as NSLayoutDimension,
                      second as NSLayoutDimension, otherSecond as NSLayoutDimension):
                constraints = ConstraintPair(
                    first: builder.dimensionBuilder(first, otherFirst + c1 ~ priority),
                    second: builder.dimensionBuilder(second, otherSecond + c2 ~ priority)
                )
            default:
                preconditionFailure("Constrained anchors must match in either axis or type.")
            }
        }
        return constraints
    }
}

internal extension EdgeInsets {
    init(constant: CGFloat) {
        top = constant
        left = constant
        bottom = constant
        right = constant
    }
}

internal prefix func - (rhs: EdgeInsets) -> EdgeInsets {
    return EdgeInsets(
        top: -rhs.top,
        left: -rhs.left,
        bottom: -rhs.bottom,
        right: -rhs.right
    )
}

internal extension EdgeAnchors {
    init(horizontal: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor>, vertical: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor>) {
        self.horizontalAnchors = horizontal
        self.verticalAnchors = vertical
    }
    
    func finalize(constraintsEqualToEdges anchor: EdgeAnchors?, insets: EdgeInsets, priority: Priority = .required) -> ConstraintGroup {
        return constraints(forAnchors: anchor, insets: insets, priority: priority, builder: ConstraintBuilder.equality)
    }
    
    func finalize(constraintsLessThanOrEqualToEdges anchor: EdgeAnchors?, insets: EdgeInsets, priority: Priority = .required) -> ConstraintGroup {
        return constraints(forAnchors: anchor, insets: insets, priority: priority, builder: ConstraintBuilder.lessThanOrEqual)
    }
    
    func finalize(constraintsGreaterThanOrEqualToEdges anchor: EdgeAnchors?, insets: EdgeInsets, priority: Priority = .required) -> ConstraintGroup {
        return constraints(forAnchors: anchor, insets: insets, priority: priority, builder: ConstraintBuilder.greaterThanOrEqual)
    }
    
    func finalize(constraintsEqualToEdges anchor: EdgeAnchors?, constant c: CGFloat = 0.0, priority: Priority = .required) -> ConstraintGroup {
        return constraints(forAnchors: anchor, insets: EdgeInsets(constant: c), priority: priority, builder: ConstraintBuilder.equality)
    }
    
    func finalize(constraintsLessThanOrEqualToEdges anchor: EdgeAnchors?, constant c: CGFloat = 0.0, priority: Priority = .required) -> ConstraintGroup {
        return constraints(forAnchors: anchor, insets: EdgeInsets(constant: c), priority: priority, builder: ConstraintBuilder.lessThanOrEqual)
    }
    
    func finalize(constraintsGreaterThanOrEqualToEdges anchor: EdgeAnchors?, constant c: CGFloat = 0.0, priority: Priority = .required) -> ConstraintGroup {
        return constraints(forAnchors: anchor, insets: EdgeInsets(constant: c), priority: priority, builder: ConstraintBuilder.greaterThanOrEqual)
    }
    
    func constraints(forAnchors anchors: EdgeAnchors?, insets: EdgeInsets, priority: Priority, builder: ConstraintBuilder) -> ConstraintGroup {
        guard let anchors = anchors else {
            preconditionFailure("Encountered nil edge anchors, indicating internal inconsistency of this API.")
        }
        
        var constraints: ConstraintGroup!
        performInBatch {
            let horizontalConstraints = horizontalAnchors.constraints(forAnchors: anchors.horizontalAnchors, firstConstant: insets.left, secondConstant: insets.right, priority: priority, builder: builder)
            let verticalConstraints = verticalAnchors.constraints(forAnchors: anchors.verticalAnchors, firstConstant: insets.top, secondConstant: insets.bottom, priority: priority, builder: builder)
            constraints = ConstraintGroup(
                top: verticalConstraints.first,
                leading: horizontalConstraints.first,
                bottom: verticalConstraints.second,
                trailing: horizontalConstraints.second
            )
        }
        return constraints
    }
}

internal struct ConstraintBuilder {
    typealias Horizontal = (NSLayoutXAxisAnchor, LayoutExpression<NSLayoutXAxisAnchor, CGFloat>) -> NSLayoutConstraint
    typealias Vertical = (NSLayoutYAxisAnchor, LayoutExpression<NSLayoutYAxisAnchor, CGFloat>) -> NSLayoutConstraint
    typealias Dimension = (NSLayoutDimension, LayoutExpression<NSLayoutDimension, CGFloat>) -> NSLayoutConstraint
    
    static let equality = ConstraintBuilder(horizontal: ==, vertical: ==, dimension: ==)
    static let lessThanOrEqual = ConstraintBuilder(leading: <=, top: <=, trailing: >=, bottom: >=, centerX: <=, centerY: <=, dimension: <=)
    static let greaterThanOrEqual = ConstraintBuilder(leading: >=, top: >=, trailing: <=, bottom: <=, centerX: >=, centerY: >=, dimension: >=)
    
    var topBuilder: Vertical
    var leadingBuilder: Horizontal
    var bottomBuilder: Vertical
    var trailingBuilder: Horizontal
    var centerYBuilder: Vertical
    var centerXBuilder: Horizontal
    var dimensionBuilder: Dimension
    
    init(horizontal: @escaping Horizontal, vertical: @escaping Vertical, dimension: @escaping Dimension) {
        topBuilder = vertical
        leadingBuilder = horizontal
        bottomBuilder = vertical
        trailingBuilder = horizontal
        centerYBuilder = vertical
        centerXBuilder = horizontal
        dimensionBuilder = dimension
    }
    
    init(leading: @escaping Horizontal, top: @escaping Vertical, trailing: @escaping Horizontal,
         bottom: @escaping Vertical, centerX: @escaping Horizontal, centerY: @escaping Vertical, dimension: @escaping Dimension) {
        leadingBuilder = leading
        topBuilder = top
        trailingBuilder = trailing
        bottomBuilder = bottom
        centerYBuilder = centerY
        centerXBuilder = centerX
        dimensionBuilder = dimension
    }
}

internal var batches: [ConstraintBatch] = []
internal class ConstraintBatch {
    var constraints = [NSLayoutConstraint]()
    
    func add(constraint: NSLayoutConstraint) {
        constraints.append(constraint)
    }
    
    func activate() {
        NSLayoutConstraint.activate(constraints)
    }
}

/// Perform a closure immediately if a batch is already active,
/// otherwise executes the closure in a new batch.
///
/// - Parameter closure: The work to perform inside of a batch
internal func performInBatch(closure: () -> Void) {
    if batches.isEmpty {
        batch(closure)
    }
    else {
        closure()
    }
}

internal func finalize(constraint: NSLayoutConstraint, withPriority priority: Priority = .required) -> NSLayoutConstraint {
    // Only disable autoresizing constraints on the LHS item, which is the one definitely intended to be governed by Auto Layout
    if let first = constraint.firstItem as? View {
        first.translatesAutoresizingMaskIntoConstraints = false
    }
    
    constraint.priority = priority.value
    
    if let lastBatch = batches.last {
        lastBatch.add(constraint: constraint)
    }
    else {
        constraint.isActive = true
    }
    return constraint
}

public enum Priority: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Equatable {
    case required
    case high
    case low
    case fittingSize
    case custom(LayoutPriority)
    
    public var value: LayoutPriority {
        switch self {
        case .required: return LayoutPriorityRequired
        case .high: return LayoutPriorityHigh
        case .low: return LayoutPriorityLow
        case .fittingSize: return LayoutPriorityFittingSize
        case .custom(let priority): return priority
        }
    }
    
    public init(floatLiteral value: Float) {
        self = .custom(LayoutPriority(value))
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init(_ value: Int) {
        self = .custom(LayoutPriority(Float(value)))
    }
    
    public init<T: BinaryFloatingPoint>(_ value: T) {
        self = .custom(LayoutPriority(Float(value)))
    }
    
}

/// Any Anchorage constraints created inside the passed closure are returned in the array.
///
/// - Parameter closure: A closure that runs some Anchorage expressions.
/// - Returns: An array of new, active `NSLayoutConstraint`s.
@discardableResult
public func batch(_ closure: () -> Void) -> [NSLayoutConstraint] {
    return batch(active: true, closure: closure)
}

/// Any Anchorage constraints created inside the passed closure are returned in the array.
///
/// - Parameter active: Whether the created constraints should be active when they are returned.
/// - Parameter closure: A closure that runs some Anchorage expressions.
/// - Returns: An array of new `NSLayoutConstraint`s.
public func batch(active: Bool, closure: () -> Void) -> [NSLayoutConstraint] {
    let batch = ConstraintBatch()
    batches.append(batch)
    defer {
        batches.removeLast()
    }
    closure()
    if active {
        batch.activate()
    }
    return batch.constraints
}

public protocol AnchorGroupProvider {
    var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> { get }
    var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> { get }
    var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> { get }
    var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> { get }
}

extension AnchorGroupProvider {
    public var edgeAnchors: EdgeAnchors {
        return EdgeAnchors(horizontal: horizontalAnchors, vertical: verticalAnchors)
    }
}

extension View: AnchorGroupProvider {
    public var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> {
        return AnchorPair(first: leadingAnchor, second: trailingAnchor)
    }
    
    public var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: topAnchor, second: bottomAnchor)
    }
    
    public var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: centerXAnchor, second: centerYAnchor)
    }
    
    public var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> {
        return AnchorPair(first: widthAnchor, second: heightAnchor)
    }
}

extension ViewController: AnchorGroupProvider {
    public var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> {
        return view.horizontalAnchors
    }
    
    public var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> {
        #if os(macOS)
            return view.verticalAnchors
        #else
            return AnchorPair(first: topLayoutGuide.bottomAnchor, second: bottomLayoutGuide.topAnchor)
        #endif
    }
    
    public var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> {
        return view.centerAnchors
    }
    
    public var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> {
        return view.sizeAnchors
    }
}

extension LayoutGuide: AnchorGroupProvider {
    public var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor> {
        return AnchorPair(first: leadingAnchor, second: trailingAnchor)
    }
    
    public var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: topAnchor, second: bottomAnchor)
    }
    
    public var centerAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutYAxisAnchor> {
        return AnchorPair(first: centerXAnchor, second: centerYAnchor)
    }
    
    public var sizeAnchors: AnchorPair<NSLayoutDimension, NSLayoutDimension> {
        return AnchorPair(first: widthAnchor, second: heightAnchor)
    }
}

public struct EdgeAnchors: LayoutAnchorType {
    public var horizontalAnchors: AnchorPair<NSLayoutXAxisAnchor, NSLayoutXAxisAnchor>
    public var verticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor>
}

public struct ConstraintPair {
    public var first: NSLayoutConstraint
    public var second: NSLayoutConstraint
}

public struct ConstraintGroup {
    public var top: NSLayoutConstraint
    public var leading: NSLayoutConstraint
    public var bottom: NSLayoutConstraint
    public var trailing: NSLayoutConstraint
    
    public var horizontal: [NSLayoutConstraint] {
        return [leading, trailing]
    }
    
    public var vertical: [NSLayoutConstraint] {
        return [top, bottom]
    }
    
    public var all: [NSLayoutConstraint] {
        return [top, leading, bottom, trailing]
    }
}

extension NSLayoutXAxisAnchor {
    func constraint(equalTo anchor: NSLayoutXAxisAnchor,
                    multiplier m: CGFloat,
                    constant c: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: c)
        return constraint.with(multiplier: m)
    }
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                    multiplier m: CGFloat,
                    constant c: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: c)
        return constraint.with(multiplier: m)
    }
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor,
                    multiplier m: CGFloat,
                    constant c: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: anchor, constant: c)
        return constraint.with(multiplier: m)
    }
}

extension NSLayoutYAxisAnchor {
    func constraint(equalTo anchor: NSLayoutYAxisAnchor,
                    multiplier m: CGFloat,
                    constant c: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: c)
        return constraint.with(multiplier: m)
    }
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor,
                    multiplier m: CGFloat,
                    constant c: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: c)
        return constraint.with(multiplier: m)
    }
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor,
                    multiplier m: CGFloat,
                    constant c: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: anchor, constant: c)
        return constraint.with(multiplier: m)
    }
}

private extension NSLayoutConstraint {
    func with(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstItem!,
                                  attribute: firstAttribute,
                                  relatedBy: relation,
                                  toItem: secondItem,
                                  attribute: secondAttribute,
                                  multiplier: multiplier,
                                  constant: constant)
    }
}

precedencegroup PriorityPrecedence {
    associativity: none
    higherThan: ComparisonPrecedence
    lowerThan: AdditionPrecedence
}
infix operator ~: PriorityPrecedence

public func == (lhs: Priority, rhs: Priority) -> Bool {
    return lhs.value == rhs.value
}

public func + <T: BinaryFloatingPoint>(lhs: Priority, rhs: T) -> Priority {
    return .custom(LayoutPriority(rawValue: lhs.value.rawValue + Float(rhs)))
}

public func + <T: BinaryFloatingPoint>(lhs: T, rhs: Priority) -> Priority {
    return .custom(LayoutPriority(rawValue: Float(lhs) + rhs.value.rawValue))
}

public func - <T: BinaryFloatingPoint>(lhs: Priority, rhs: T) -> Priority {
    return .custom(LayoutPriority(rawValue: lhs.value.rawValue - Float(rhs)))
}

public func - <T: BinaryFloatingPoint>(lhs: T, rhs: Priority) -> Priority {
    return .custom(LayoutPriority(rawValue: Float(lhs) - rhs.value.rawValue))
}

@discardableResult
public func == <T: BinaryFloatingPoint>(lhs: NSLayoutDimension, rhs: T) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(equalToConstant: CGFloat(rhs)))
}

@discardableResult
public func == (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(equalTo: rhs))
}

@discardableResult
public func == (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(equalTo: rhs))
}

@discardableResult
public func == (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(equalTo: rhs))
}

@discardableResult
public func == (lhs: NSLayoutXAxisAnchor, rhs: LayoutExpression<NSLayoutXAxisAnchor, CGFloat>) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(equalTo: rhs.anchor!, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
}

@discardableResult
public func == (lhs: NSLayoutYAxisAnchor, rhs: LayoutExpression<NSLayoutYAxisAnchor, CGFloat>) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(equalTo: rhs.anchor!, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
}

@discardableResult
public func == (lhs: NSLayoutDimension, rhs: LayoutExpression<NSLayoutDimension, CGFloat>) -> NSLayoutConstraint {
    if let anchor = rhs.anchor {
        return finalize(constraint: lhs.constraint(equalTo: anchor, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
    }
    else {
        return finalize(constraint: lhs.constraint(equalToConstant: rhs.constant), withPriority: rhs.priority)
    }
}

@discardableResult
public func == (lhs: EdgeAnchors, rhs: EdgeAnchors) -> ConstraintGroup {
    return lhs.finalize(constraintsEqualToEdges: rhs)
}

@discardableResult
public func == (lhs: EdgeAnchors, rhs: LayoutExpression<EdgeAnchors, CGFloat>) -> ConstraintGroup {
    return lhs.finalize(constraintsEqualToEdges: rhs.anchor, constant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func == (lhs: EdgeAnchors, rhs: LayoutExpression<EdgeAnchors, EdgeInsets>) -> ConstraintGroup {
    return lhs.finalize(constraintsEqualToEdges: rhs.anchor, insets: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func == <T, U>(lhs: AnchorPair<T, U>, rhs: AnchorPair<T, U>) -> ConstraintPair {
    return lhs.finalize(constraintsEqualToEdges: rhs)
}

@discardableResult
public func == <T, U>(lhs: AnchorPair<T, U>, rhs: LayoutExpression<AnchorPair<T, U>, CGFloat>) -> ConstraintPair {
    return lhs.finalize(constraintsEqualToEdges: rhs.anchor, constant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func == (lhs: AnchorPair<NSLayoutDimension, NSLayoutDimension>, rhs: CGSize) -> ConstraintPair {
    return lhs.finalize(constraintsEqualToConstant: rhs)
}

@discardableResult
public func == (lhs: AnchorPair<NSLayoutDimension, NSLayoutDimension>, rhs: LayoutExpression<AnchorPair<NSLayoutDimension, NSLayoutDimension>, CGSize>) -> ConstraintPair {
    return lhs.finalize(constraintsEqualToConstant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func <= <T: BinaryFloatingPoint>(lhs: NSLayoutDimension, rhs: T) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(lessThanOrEqualToConstant: CGFloat(rhs)))
}

@discardableResult
public func <= (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(lessThanOrEqualTo: rhs))
}

@discardableResult
public func <= (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(lessThanOrEqualTo: rhs))
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(lessThanOrEqualTo: rhs))
}

@discardableResult
public func <= (lhs: NSLayoutXAxisAnchor, rhs: LayoutExpression<NSLayoutXAxisAnchor, CGFloat>) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(lessThanOrEqualTo: rhs.anchor!, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
}

@discardableResult
public func <= (lhs: NSLayoutYAxisAnchor, rhs: LayoutExpression<NSLayoutYAxisAnchor, CGFloat>) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(lessThanOrEqualTo: rhs.anchor!, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: LayoutExpression<NSLayoutDimension, CGFloat>) -> NSLayoutConstraint {
    if let anchor = rhs.anchor {
        return finalize(constraint: lhs.constraint(lessThanOrEqualTo: anchor, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
    }
    else {
        return finalize(constraint: lhs.constraint(lessThanOrEqualToConstant: rhs.constant), withPriority: rhs.priority)
    }
}

@discardableResult
public func <= (lhs: EdgeAnchors, rhs: EdgeAnchors) -> ConstraintGroup {
    return lhs.finalize(constraintsLessThanOrEqualToEdges: rhs)
}

@discardableResult
public func <= (lhs: EdgeAnchors, rhs: LayoutExpression<EdgeAnchors, CGFloat>) -> ConstraintGroup {
    return lhs.finalize(constraintsLessThanOrEqualToEdges: rhs.anchor, constant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func <= (lhs: EdgeAnchors, rhs: LayoutExpression<EdgeAnchors, EdgeInsets>) -> ConstraintGroup {
    return lhs.finalize(constraintsLessThanOrEqualToEdges: rhs.anchor, insets: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func <= <T, U>(lhs: AnchorPair<T, U>, rhs: AnchorPair<T, U>) -> ConstraintPair {
    return lhs.finalize(constraintsLessThanOrEqualToEdges: rhs)
}

@discardableResult
public func <= <T, U>(lhs: AnchorPair<T, U>, rhs: LayoutExpression<AnchorPair<T, U>, CGFloat>) -> ConstraintPair {
    return lhs.finalize(constraintsLessThanOrEqualToEdges: rhs.anchor, constant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func <= (lhs: AnchorPair<NSLayoutDimension, NSLayoutDimension>, rhs: CGSize) -> ConstraintPair {
    return lhs.finalize(constraintsLessThanOrEqualToConstant: rhs)
}

@discardableResult
public func <= (lhs: AnchorPair<NSLayoutDimension, NSLayoutDimension>, rhs: LayoutExpression<AnchorPair<NSLayoutDimension, NSLayoutDimension>, CGSize>) -> ConstraintPair {
    return lhs.finalize(constraintsLessThanOrEqualToConstant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func >= <T: BinaryFloatingPoint>(lhs: NSLayoutDimension, rhs: T) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(greaterThanOrEqualToConstant: CGFloat(rhs)))
}

@discardableResult
public func >= (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(greaterThanOrEqualTo: rhs))
}

@discardableResult
public func >= (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(greaterThanOrEqualTo: rhs))
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: NSLayoutDimension) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(greaterThanOrEqualTo: rhs))
}

@discardableResult
public func >= (lhs: NSLayoutXAxisAnchor, rhs: LayoutExpression<NSLayoutXAxisAnchor, CGFloat>) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(greaterThanOrEqualTo: rhs.anchor!, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
}

@discardableResult
public func >= (lhs: NSLayoutYAxisAnchor, rhs: LayoutExpression<NSLayoutYAxisAnchor, CGFloat>) -> NSLayoutConstraint {
    return finalize(constraint: lhs.constraint(greaterThanOrEqualTo: rhs.anchor!, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: LayoutExpression<NSLayoutDimension, CGFloat>) -> NSLayoutConstraint {
    if let anchor = rhs.anchor {
        return finalize(constraint: lhs.constraint(greaterThanOrEqualTo: anchor, multiplier: rhs.multiplier, constant: rhs.constant), withPriority: rhs.priority)
    }
    else {
        return finalize(constraint: lhs.constraint(greaterThanOrEqualToConstant: rhs.constant), withPriority: rhs.priority)
    }
}

@discardableResult
public func >= (lhs: EdgeAnchors, rhs: EdgeAnchors) -> ConstraintGroup {
    return lhs.finalize(constraintsGreaterThanOrEqualToEdges: rhs)
}

@discardableResult
public func >= (lhs: EdgeAnchors, rhs: LayoutExpression<EdgeAnchors, CGFloat>) -> ConstraintGroup {
    return lhs.finalize(constraintsGreaterThanOrEqualToEdges: rhs.anchor, constant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func >= (lhs: EdgeAnchors, rhs: LayoutExpression<EdgeAnchors, EdgeInsets>) -> ConstraintGroup {
    return lhs.finalize(constraintsGreaterThanOrEqualToEdges: rhs.anchor, insets: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func >= <T, U>(lhs: AnchorPair<T, U>, rhs: AnchorPair<T, U>) -> ConstraintPair {
    return lhs.finalize(constraintsGreaterThanOrEqualToEdges: rhs)
}

@discardableResult
public func >= <T, U>(lhs: AnchorPair<T, U>, rhs: LayoutExpression<AnchorPair<T, U>, CGFloat>) -> ConstraintPair {
    return lhs.finalize(constraintsGreaterThanOrEqualToEdges: rhs.anchor, constant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func >= (lhs: AnchorPair<NSLayoutDimension, NSLayoutDimension>, rhs: CGSize) -> ConstraintPair {
    return lhs.finalize(constraintsGreaterThanOrEqualToConstant: rhs)
}

@discardableResult
public func >= (lhs: AnchorPair<NSLayoutDimension, NSLayoutDimension>, rhs: LayoutExpression<AnchorPair<NSLayoutDimension, NSLayoutDimension>, CGSize>) -> ConstraintPair {
    return lhs.finalize(constraintsGreaterThanOrEqualToConstant: rhs.constant, priority: rhs.priority)
}

@discardableResult
public func ~ <T: BinaryFloatingPoint>(lhs: T, rhs: Priority) -> LayoutExpression<NSLayoutDimension, CGFloat> {
    return LayoutExpression(constant: CGFloat(lhs), priority: rhs)
}

@discardableResult
public func ~ (lhs: CGSize, rhs: Priority) -> LayoutExpression<AnchorPair<NSLayoutDimension, NSLayoutDimension>, CGSize> {
    return LayoutExpression(constant: lhs, priority: rhs)
}

@discardableResult
public func ~ <T>(lhs: T, rhs: Priority) -> LayoutExpression<T, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: 0.0, priority: rhs)
}

@discardableResult
public func ~ <T, U>(lhs: LayoutExpression<T, U>, rhs: Priority) -> LayoutExpression<T, U> {
    var expr = lhs
    expr.priority = rhs
    return expr
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: NSLayoutDimension, rhs: T) -> LayoutExpression<NSLayoutDimension, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: 0.0, multiplier: CGFloat(rhs))
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: T, rhs: NSLayoutDimension) -> LayoutExpression<NSLayoutDimension, CGFloat> {
    return LayoutExpression(anchor: rhs, constant: 0.0, multiplier: CGFloat(lhs))
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: LayoutExpression<NSLayoutDimension, CGFloat>, rhs: T) -> LayoutExpression<NSLayoutDimension, CGFloat> {
    var expr = lhs
    expr.multiplier *= CGFloat(rhs)
    return expr
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: T, rhs: LayoutExpression<NSLayoutDimension, CGFloat>) -> LayoutExpression<NSLayoutDimension, CGFloat> {
    var expr = rhs
    expr.multiplier *= CGFloat(lhs)
    return expr
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: NSLayoutXAxisAnchor, rhs: T) -> LayoutExpression<NSLayoutXAxisAnchor, CGFloat> {
    return LayoutExpression(anchor: Optional<NSLayoutXAxisAnchor>.some(lhs), constant: 0.0, multiplier: CGFloat(rhs))
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: T, rhs: NSLayoutXAxisAnchor) -> LayoutExpression<NSLayoutXAxisAnchor, CGFloat> {
    return LayoutExpression(anchor: rhs, constant: 0.0, multiplier: CGFloat(lhs))
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: LayoutExpression<NSLayoutXAxisAnchor, CGFloat>, rhs: T) -> LayoutExpression<NSLayoutXAxisAnchor, CGFloat> {
    var expr = lhs
    expr.multiplier *= CGFloat(rhs)
    return expr
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: T, rhs: LayoutExpression<NSLayoutXAxisAnchor, CGFloat>) -> LayoutExpression<NSLayoutXAxisAnchor, CGFloat> {
    var expr = rhs
    expr.multiplier *= CGFloat(lhs)
    return expr
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: NSLayoutYAxisAnchor, rhs: T) -> LayoutExpression<NSLayoutYAxisAnchor, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: 0.0, multiplier: CGFloat(rhs))
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: T, rhs: NSLayoutYAxisAnchor) -> LayoutExpression<NSLayoutYAxisAnchor, CGFloat> {
    return LayoutExpression(anchor: rhs, constant: 0.0, multiplier: CGFloat(lhs))
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: LayoutExpression<NSLayoutYAxisAnchor, CGFloat>, rhs: T) -> LayoutExpression<NSLayoutYAxisAnchor, CGFloat> {
    var expr = lhs
    expr.multiplier *= CGFloat(rhs)
    return expr
}

@discardableResult
public func * <T: BinaryFloatingPoint>(lhs: T, rhs: LayoutExpression<NSLayoutYAxisAnchor, CGFloat>) -> LayoutExpression<NSLayoutYAxisAnchor, CGFloat> {
    var expr = rhs
    expr.multiplier *= CGFloat(lhs)
    return expr
}

@discardableResult
public func / <T: BinaryFloatingPoint>(lhs: NSLayoutDimension, rhs: T) -> LayoutExpression<NSLayoutDimension, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: 0.0, multiplier: 1.0 / CGFloat(rhs))
}

@discardableResult
public func / <T: BinaryFloatingPoint>(lhs: LayoutExpression<NSLayoutDimension, CGFloat>, rhs: T) -> LayoutExpression<NSLayoutDimension, CGFloat> {
    var expr = lhs
    expr.multiplier /= CGFloat(rhs)
    return expr
}

@discardableResult
public func / <T: BinaryFloatingPoint>(lhs: NSLayoutXAxisAnchor, rhs: T) -> LayoutExpression<NSLayoutXAxisAnchor, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: 0.0, multiplier: 1.0 / CGFloat(rhs))
}

@discardableResult
public func / <T: BinaryFloatingPoint>(lhs: LayoutExpression<NSLayoutXAxisAnchor, CGFloat>, rhs: T) -> LayoutExpression<NSLayoutXAxisAnchor, CGFloat> {
    var expr = lhs
    expr.multiplier /= CGFloat(rhs)
    return expr
}

@discardableResult
public func / <T: BinaryFloatingPoint>(lhs: NSLayoutYAxisAnchor, rhs: T) -> LayoutExpression<NSLayoutYAxisAnchor, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: 0.0, multiplier: 1.0 / CGFloat(rhs))
}

@discardableResult
public func / <T: BinaryFloatingPoint>(lhs: LayoutExpression<NSLayoutYAxisAnchor, CGFloat>, rhs: T) -> LayoutExpression<NSLayoutYAxisAnchor, CGFloat> {
    var expr = lhs
    expr.multiplier /= CGFloat(rhs)
    return expr
}

@discardableResult
public func + <T, U: BinaryFloatingPoint>(lhs: T, rhs: U) -> LayoutExpression<T, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: CGFloat(rhs))
}

@discardableResult
public func + <T: BinaryFloatingPoint, U>(lhs: T, rhs: U) -> LayoutExpression<U, CGFloat> {
    return LayoutExpression(anchor: rhs, constant: CGFloat(lhs))
}

@discardableResult
public func + <T, U: BinaryFloatingPoint>(lhs: LayoutExpression<T, CGFloat>, rhs: U) -> LayoutExpression<T, CGFloat> {
    var expr = lhs
    expr.constant += CGFloat(rhs)
    return expr
}

@discardableResult
public func + <T: BinaryFloatingPoint, U>(lhs: T, rhs: LayoutExpression<U, CGFloat>) -> LayoutExpression<U, CGFloat> {
    var expr = rhs
    expr.constant += CGFloat(lhs)
    return expr
}

@discardableResult
public func + (lhs: EdgeAnchors, rhs: EdgeInsets) -> LayoutExpression<EdgeAnchors, EdgeInsets> {
    return LayoutExpression(anchor: lhs, constant: rhs)
}

@discardableResult
public func - <T, U: BinaryFloatingPoint>(lhs: T, rhs: U) -> LayoutExpression<T, CGFloat> {
    return LayoutExpression(anchor: lhs, constant: -CGFloat(rhs))
}

@discardableResult
public func - <T: BinaryFloatingPoint, U>(lhs: T, rhs: U) -> LayoutExpression<U, CGFloat> {
    return LayoutExpression(anchor: rhs, constant: -CGFloat(lhs))
}

@discardableResult
public func - <T, U: BinaryFloatingPoint>(lhs: LayoutExpression<T, CGFloat>, rhs: U) -> LayoutExpression<T, CGFloat> {
    var expr = lhs
    expr.constant -= CGFloat(rhs)
    return expr
}

@discardableResult
public func - <T: BinaryFloatingPoint, U>(lhs: T, rhs: LayoutExpression<U, CGFloat>) -> LayoutExpression<U, CGFloat> {
    var expr = rhs
    expr.constant -= CGFloat(lhs)
    return expr
}

@discardableResult
public func - (lhs: EdgeAnchors, rhs: EdgeInsets) -> LayoutExpression<EdgeAnchors, EdgeInsets> {
    return LayoutExpression(anchor: lhs, constant: -rhs)
}
