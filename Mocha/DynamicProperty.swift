import Foundation

public protocol DynamicProperty {
    associatedtype T
    associatedtype U
    subscript(_ object: T) -> U? { mutating get mutating set }
    
    subscript(_ object: T, default default: @autoclosure () -> (U)) -> U { mutating get }
    subscript(_ object: T, creating creating: @autoclosure () -> (U)) -> U { mutating get }
}

public struct KeyValueProperty<T: NSObject, U>: DynamicProperty {
    
    public let propertyName: String
    public init(_ propertyName: String) {
        self.propertyName = propertyName
    }
    
    public subscript(_ object: T) -> U? {
        get { return object.value(forKey: self.propertyName) as? U }
        set { object.setValue(newValue, forKey: self.propertyName) }
    }
}

public struct AssociatedProperty<T, U>: DynamicProperty {
    private var key: UnsafeRawPointer? = nil
    
    public enum Strength {
        case strong
        case weak
        case copy
        
        fileprivate var _objc: objc_AssociationPolicy {
            switch self {
            case .strong: return .OBJC_ASSOCIATION_RETAIN
            case .weak: return .OBJC_ASSOCIATION_ASSIGN
            case .copy: return .OBJC_ASSOCIATION_COPY
            }
        }
    }
    
    public let strength: Strength
    public init(_ strength: Strength) {
        self.strength = strength
    }
    
    public subscript(_ object: T) -> U? {
        mutating get { return objc_getAssociatedObject(object, &key) as? U }
        mutating set { objc_setAssociatedObject(object, &key, newValue, self.strength._objc) }
    }
}

public extension DynamicProperty {
    public subscript(_ object: T, default default: @autoclosure () -> (U)) -> U {
        mutating get { return self[object] ?? `default`() }
    }
    
    public subscript(_ object: T, creating creating: @autoclosure () -> (U)) -> U {
        mutating get {
            if let ret = self[object] {
                return ret
            } else {
                let ret = creating()
                self[object] = ret
                return ret
            }
        }
    }
}

/* TODO: Multiple SelectorKey<...> to be generic-matched to the function prototype. */
/*
public protocol SelectorContainable {
    var method: String { get }
}
*/

public struct SelectorKey<T: NSObjectProtocol, A, B, X> {
    public let method: String
    public let retain: Bool
    
    public init(_ method: String, retain: Bool = false) {
        self.method = method
        self.retain = retain
    }
    
    // let m = class_getMethodImplementation(type(of: self), #selector(sel))
    // let c = unsafeBitCast(m, to: (@convention(c) (Any?, Selector!, Any?, Any?) -> Void).self)
    // c(self, #selector(sel), arg1, arg2)
    public subscript(_ object: T, with arg1: A?, with arg2: B?) -> X? {
        get {
            if X.self == Void.self {
                _ = object.perform(Selector(self.method), with: arg1, with: arg2)
                return nil
            } else {
                return object.perform(Selector(self.method), with: arg1, with: arg2)?.takeValue(self.retain) as? X
            }
        }
    }
}

// Internal: to make it easy for code duplication.
fileprivate extension Unmanaged {
    func takeValue(_ retaining: Bool) -> Instance {
        if retaining {
            return self.takeRetainedValue()
        } else {
            return self.takeUnretainedValue()
        }
    }
}
