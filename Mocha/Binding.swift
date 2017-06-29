import Foundation

/* TODO: Support NSEditor/Registration, NSValidation*. */
/* TODO: Support NSMenu (ContentPlacementTag), ArrayController. */

/// A `Binding` connects two objects' properties such that if one object's property
/// value were to ever update, the other object's property value would do so as well.
/// Thus, both objects' properties are kept in sync. The objects and their properties
/// need not be the same, however, their individual properties' types must be the same.
public class Binding<T: NSObject, U: NSObject, X, Y>: AnyBinding {
    
    /// Describes the initial state the `Binding` should follow. That is, upon creation
    /// whether to set the "left hand side" object's value to the "right hand side"'s
    /// vice versa, or to do nothing and let the first event synchronize the values.
    public enum InitialState {
        
        /// Do nothing and let the first event synchronize the values.
        case none
        
        /// Set the "right hand side" object's value to the "left hand side"'s.
        case left
        
        /// Set the "left hand side" object's value to the "right hand side"'s.
        case right
    }
    
    /// Describes a KVO observation from `A` -> `B`, where `A` is the object
    /// and `B` is the KeyPath being observed on `A`. In a `Binding`, it is intended
    /// that there exist two of these, for the "left and right handed sides".
    private struct Descriptor<A: NSObject, B> {
        fileprivate weak var object: A? = nil
        fileprivate let keyPath: ReferenceWritableKeyPath<A, B>
        fileprivate var observation: NSKeyValueObservation?
    }
    
    /// The "left-hand-side" `Descriptor` in the Binding.
    /// See `Binding.Descriptor` for more information.
    private var left: Descriptor<T, X>
    
    /// The "right-hand-side" `Descriptor` in the Binding.
    /// See `Binding.Descriptor` for more information.
    private var right: Descriptor<U, Y>
    
    /// Returns whether the `Binding` is currently being propogated.
    /// This typically means something has triggered a KVO event.
    public private(set) var propogating: Bool = false
    
    /// Defines the `Transformer` to use when propogating this `Binding`. By
    /// default, it attempts a cast between `X` and `Y`, otherwise faulting.
    public let transformer: Transformer<X, Y>
    
    /// Executes if present when propogation has completed between the two ends
    /// of this `Binding`.
    public var propogationHandler: (() -> ())? = nil
    
    /// Creates a new `Binding<...>` between two objects on independent `KeyPath`s
    /// whose types are identical. The `Binding` will be unbound automatically
    /// when deallocated (set to `nil`).
    public init(between left: (T, ReferenceWritableKeyPath<T, X>), and right: (U, ReferenceWritableKeyPath<U, Y>),
                transformer: Transformer<X, Y> = Transformer(), with initialState: InitialState = .none) {
        
        // Assign descriptors and transformer.
        self.transformer = transformer
        self.left = Descriptor(object: left.0, keyPath: left.1, observation: nil)
        self.right = Descriptor(object: right.0, keyPath: right.1, observation: nil)
        super.init()
        
        // Set up the "between" observations.
        self.left.observation = left.0.observe(left.1) { _, _ in
            self.perform { l, r in
                r[keyPath: self.right.keyPath] = self.transformer.transform(x: l[keyPath: self.left.keyPath])
            }
        }
        self.right.observation = right.0.observe(right.1) { _, _ in
            self.perform { l, r in
                l[keyPath: self.left.keyPath] = self.transformer.transform(y: r[keyPath: self.right.keyPath])
            }
        }
        
        // Establish initial state.
        self.perform { l, r in
            switch initialState {
            case .none: break
            case .left: r[keyPath: self.right.keyPath] = self.transformer.transform(x: l[keyPath: self.left.keyPath])
            case .right: l[keyPath: self.left.keyPath] = self.transformer.transform(y: r[keyPath: self.right.keyPath])
            }
        }
    }
    
    /// Manually invalidate the "left-hand-side" and "right-hand-side" observations on deallocation.
    deinit {
        self.left.observation?.invalidate()
        self.right.observation?.invalidate()
    }
    
    /// Internally handles state management during propogation. The handler will
    /// not be invoked if either object in the `Binding` have been deallocated.
    private func perform(_ propogation: (T, U) -> ()) {
        guard let l = self.left.object, let r = self.right.object, !self.propogating else { return }
        self.propogating = true
        propogation(l, r)
        self.propogating = false
        self.propogationHandler?()
    }
}

/// A type-erased parent for `Binding<A, B, X, Y>`. See docs there.
public class AnyBinding {}
