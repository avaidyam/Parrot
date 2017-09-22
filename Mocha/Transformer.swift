import Foundation

/// A `Transformer` converts values between `X` and `Y` and can be chained to
/// other transformers to process an origin type to its destination type through
/// any number of intermediate `Transformer`s.
///
/// It is intended that this class be subclassed for implementation.
///
/// Implementation Note: It is required that `transform(x:)` and `transform(y:)`
/// remain separately typed functions, as subclasses with generic parameters
/// `where X == Y` will not compile otherwise due to conflicting overrides.
public class Transformer<X, Y> {
    
    public init() {}
    
    /// Transform the value `x` from origin type `X` to destination type `Y`.
    /// Note: this is considered to be the reverse transformation of `transform(y:)`.
    public func transform(x: X) -> Y {
        if let x = x as? Y { //X.self is Y.Type
            return x
        }
        fatalError("Cannot transform-cast \(X.self) to \(Y.self)! Define and use a Transformer<\(X.self),\(Y.self)>.")
    }
    
    /// Transform the value `y` from origin type `Y` to destination type `X`.
    /// Note: this is considered to be the reverse transformation of `transform(x:)`.
    public func transform(y: Y) -> X {
        if let y = y as? X { //Y.self is X.Type
            return y
        }
        fatalError("Cannot transform-cast \(Y.self) to \(X.self)! Define and use a Transformer<\(X.self),\(Y.self)>.")
    }
}

/// A `ReverseTransformer` composes an original `Transformer` with its generic
/// parameters `X` and `Y` reversed. Using this will allow fitting a square block
/// into a circular hole, in essence.
///
/// Note: this is only necessary until a better "swappable generic parameter"
/// method is found.
public class ReverseTransformer<Y, X>: Transformer<Y, X> {
    private let originalTransformer: Transformer<X, Y>
    
    /// Create a `Transformer` that acts in reverse of the `from` `Transformer`.
    public init(from originalTransformer: Transformer<X, Y>) {
        self.originalTransformer = originalTransformer
    }
    
    /// Transform the value `x` from origin type `Y` to destination type `X`.
    /// Note: this is considered to be the reverse transformation of `transform(y:)`.
    public override func transform(x: Y) -> X {
        return self.originalTransformer.transform(y: x)
    }
    
    /// Transform the value `y` from origin type `X` to destination type `Y`.
    /// Note: this is considered to be the reverse transformation of `transform(x:)`.
    public override func transform(y: X) -> Y {
        return self.originalTransformer.transform(x: y)
    }
}

/// A `Transformer` that allows custom transformation closure between `X` and `Y`.
public class CustomTransformer<X, Y>: Transformer<X, Y> {
    
    /// The operation closure transforming `X` into `Y`.
    public var forward: (X) -> (Y)
    
    /// The operation closure transforming `Y` into `X`.
    public var backward: (Y) -> (X)
    
    /// Create a `CustomTransformer` providing closures.
    public init(forward: @escaping (X) -> (Y), backward: @escaping (Y) -> (X)) {
        self.forward = forward
        self.backward = backward
    }
    
    /// Transform the value `x` from origin type `X` to destination type `Y`.
    /// Note: this is considered to be the reverse transformation of `transform(y:)`.
    public override func transform(x: X) -> Y {
        return self.forward(x)
    }
    
    /// Transform the value `y` from origin type `Y` to destination type `X`.
    /// Note: this is considered to be the reverse transformation of `transform(x:)`.
    public override func transform(y: Y) -> X {
        return self.backward(y)
    }
}

/// Provides a wrapper type for `NSValueTransformer`. Not recommended for usage.
public class NSTransformer: Transformer<Any?, Any?> {
    private let originalTransformer: ValueTransformer
    
    /// Create a `Transformer` that wraps the given `NSValueTransformer`.
    public init(from originalTransformer: ValueTransformer) {
        self.originalTransformer = originalTransformer
    }
    
    public override func transform(x: Any?) -> Any? {
        return self.originalTransformer.transformedValue(x)
    }
    
    public override func transform(y: Any?) -> Any? {
        if !type(of: self.originalTransformer).allowsReverseTransformation() {
            fatalError("The NSValueTransformer does not allow reverse transformation.")
        }
        return self.originalTransformer.reverseTransformedValue(y)
    }
}

/// Transformes a `LosslessStringConvertible` to and from a `String`. For more
/// information, see the `LosslessStringConvertible` documentation. This will generally
/// work for any number/boolean to String (and vice versa) conversion.
public class LosslessStringTransformer<T: LosslessStringConvertible>: Transformer<String, T> {
    private var defaultValue: () -> (T)
    
    /// Create a `LosslessStringTransformer` with a given default value.
    public init(default: @autoclosure @escaping () -> (T)) {
        self.defaultValue = `default`
    }
    
    public override func transform(x: String) -> T {
        return T(x) ?? self.defaultValue()
    }
    
    public override func transform(y: T) -> String {
        return y.description
    }
}

/// Transforms an `Optional` type to a non-`Optional` type, substituting `nil`
/// for a provided default value.
public class OptionalTransformer<A>: Transformer<A?, A> {
    private var defaultValue: () -> (A)
    
    /// Create an `OptionalTransformer` with a given default value.
    public init(default: @autoclosure @escaping () -> (A)) {
        self.defaultValue = `default`
    }
    
    public override func transform(x: A?) -> A {
        return x ?? self.defaultValue()
    }
    
    public override func transform(y: A) -> A? {
        return y
    }
}

/// Similar to the `OptionalTransformer`, but instead, the `NilTransformer` infers
/// the `Optional`'s existence and transforms it into a true or false.
///
/// Note: a "reverse" transformation yields a useless Optional(Bool).
public class NilTransformer: Transformer<Any?, Bool> {
    private var reversed: Bool
    
    /// Create a `NilTransformer` that is optionally reversed. (That is, instead
    /// of checking for a non-nil value, check for a nil value.)
    public init(reversed: Bool = false) {
        self.reversed = reversed
    }
    
    public override func transform(x: Any?) -> Bool {
        return self.reversed ? x == nil : x != nil
    }
    
    public override func transform(y: Bool) -> Any? {
        return Optional(y)
    }
}

/// Negates a `Bool` value. Not very interesting. :(
public class NegateTransformer: Transformer<Bool, Bool> {
    public override func transform(x: Bool) -> Bool {
        return !x
    }
    
    public override func transform(y: Bool) -> Bool {
        return !y
    }
}

