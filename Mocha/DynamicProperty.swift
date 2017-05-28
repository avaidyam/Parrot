import Foundation

public protocol DynamicProperty {
    associatedtype T
    associatedtype U
    
    mutating func get(_ object: T) -> U?
    mutating func set(_ object: T, value: U?)
}

public struct KeyValueProperty<T: NSObject, U>: DynamicProperty {
    
    public let propertyName: String
    public init(_ propertyName: String) {
        self.propertyName = propertyName
    }
    
    public mutating func get(_ object: T) -> U? {
        return object.value(forKey: self.propertyName) as? U
    }
    
    public mutating func set(_ object: T, value: U?) {
        object.setValue(value, forKey: self.propertyName)
    }
}

public struct AssociatedProperty<T, U>: DynamicProperty {
    
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
    
    private var key: UnsafeRawPointer? = nil
    
    public let strength: Strength
    public init(_ strength: Strength) {
        self.strength = strength
    }
    
    public mutating func get(_ object: T) -> U? {
        return objc_getAssociatedObject(object, &key) as? U
    }
    
    public mutating func set(_ object: T, value: U?) {
        objc_setAssociatedObject(object, &key, value, self.strength._objc)
    }
}
