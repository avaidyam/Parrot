import Foundation

// Finally, matching operations where append*() was applicable, for remove*()
public extension Array where Element : Equatable {
	public mutating func remove(_ item: Element) {
		if let index = self.index(of: item) {
			self.remove(at: index)
		}
	}
}

// Optional Setter
infix operator ??= { associativity right precedence 90 }
public func ??= <T>(lhs: inout T?,  rhs: @autoclosure () -> T) {
	lhs = lhs ?? rhs()
}

/// Can hold any (including non-object) type as an object type.
public class Wrapper<T> {
	public let element: T
	public init(_ value: T) {
		self.element = value
	}
}
