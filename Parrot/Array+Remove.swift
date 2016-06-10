import Foundation

// Finally, matching operations where append*() was applicable, for remove*()
public extension Array where Element : Equatable {
	public mutating func remove(item: Element) {
		if let index = self.index(of: item) {
			self.remove(at: index)
		}
	}
	
	public mutating func removeContentsOf<S : Sequence where S.Iterator.Element == Element>(newElements: S) {
		for object in newElements {
			self.remove(item: object)
		}
	}
	
	public mutating func removeContentsOf<C : Collection where C.Iterator.Element == Element>(newElements: C) {
		for object in newElements {
			self.remove(item: object)
		}
	}
}

/// Can hold any (including non-object) type as an object type.
public class Wrapper<T> {
	public let element: T
	public init(_ value: T) {
		self.element = value
	}
}
