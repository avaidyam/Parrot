import Cocoa

public extension SequenceType {
	
	/// Returns the first element where `predicate` returns `true`, or `nil`
	/// if such value is not found.
	public func find(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
		for element in self {
			if try predicate(element) {
				return element
			}
		}
		return nil
	}
}

// Safe access extension
public extension CollectionType {
	public subscript(safe index: Index) -> Generator.Element? {
		get {
			return self.indices.contains(index) ? self[index] : nil
		}
	}
}

// Safe access extension
public extension MutableCollectionType {
	public subscript(safe index: Index) -> Generator.Element? {
		get {
			return self.indices.contains(index) ? self[index] : nil
		}
		set(newValue) {
			if let val = newValue where self.indices.contains(index) {
				self[index] = val
			}
		}
	}
}

// Unwrappers
internal func _unwrap<T>(value: T.Type) -> T.Type {
	return T.self
}
internal func _unwrap<T>(value: Optional<T>.Type) -> T.Type {
	return T.self
}
internal func _unwrap<T>(value: Array<T>.Type) -> T.Type {
	return T.self
}
internal func _unwrap<T>(value: Optional<Array<T>>.Type) -> T.Type {
	return T.self
}

// Optional Setter
infix operator ??= { associativity right precedence 90 }
public func ??= <T>(inout lhs: T?,  @autoclosure rhs: () -> T) {
	lhs = lhs ?? rhs()
}

// Convenience methods for Mirror
public extension Mirror {
	
	/// Label of instance's type.
	public var subjectTypeLabel: String {
		return "\(self.subjectType)"
	}
	
	/// Labels of properties.
	public var labels: [String?] {
		return self.children.map { $0.label }
	}
	
	/// Values of properties.
	public var values: [Any] {
		return self.children.map { $0.value }
	}
	
	/// Types of properties.
	public var types: [Any.Type] {
		return self.children.map { $0.value.dynamicType }
	}
	
	/// Returns a property value for a property name.
	public subscript(key: String) -> Any? {
		let res = self.children.find { $0.label == key }
		return res.map { $0.value }
	}
	
	/// Returns a value for a property name with a generic type.
	public func getValue<U>(forKey key: String) -> U? {
		let res = self.children.find { $0.label == key }
		return res.flatMap { $0.value as? U }
	}
}

/// SwiftyStride (https://github.com/alexjamesa/SwiftyStride)
infix operator .. { associativity left }
infix operator ..< { associativity left }
public func ..(lhs: Int, rhs: Int) -> (Int, Int) {
	return (lhs, rhs)
}
public func ..(lhs: (Int, Int), rhs: Int) -> [Int] {
	return Array(lhs.0.stride(through: rhs, by: lhs.1))
}
public func ..< (lhs: (Int, Int), rhs: Int) -> [Int] {
	return Array(lhs.0.stride(to: rhs, by: lhs.1))
}

///: Tests

print(0..2..10)
print(4..4..<16)

let arr = (["abc", "abc", "cdef"] as NSArray) as? [NSString]
let arr2 : [NSData] = []
arr!.dynamicType
arr!.dynamicType.Element.self

let abc: Any = arr2

let m2 = Mirror(reflecting: abc)
if let d = m2.displayStyle where d == .Collection {
	print(m2.children)
} else {
	print("no")
}

var itemsA:[String]? = nil
var itemsB:[String]? = [String()]
itemsA ??= [String]() // itemsA is set since its value is .None
itemsB ??= [String]() // itemsB's value isn't changed since its value is .Some

var array = [0, 1, 2]
array[safe: 0] // same as array[0]
array[safe: 3] // out of bounds, evaluates to nil
array[safe: 0] = 42 // same as array[0] = 42
array[safe: 3] = 42 // out of bounds, no operation
array[safe: 0] = nil // out of bounds, no operation
print((array))

var dict = ["a": 0, "b": 1, "d": 5]
dict["a"] // same as array[0]
dict["q"] // out of bounds, evaluates to nil
dict["a"] = 42 // same as array[0] = 42
dict["q"] = 42 // out of bounds, no operation
dict["a"] = nil // out of bounds, no operation
print((dict))

var str: String? = "Hello, playground"
struct abc22 {
	var ab0: String  = str!
	var ab1: String? = str!
	var ab2: Float? = nil
	var ab3: [Int] = [3, 6]
	var ab4: [Double]? = nil
}

var mirror = Mirror(reflecting: abc22())

print("getting: \(_typeName(abc22().dynamicType))")
//_typeByName("Swift.NonObjectiveCBase")

/*for (key, val) in mirror.children {
print("got \(key) -> \(_unwrap(val.dynamicType))")
}*/
