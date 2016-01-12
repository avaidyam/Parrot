import Foundation

// Finally, matching operations where append*() was applicable, for remove*()
public extension Array where Element : Equatable {
	public mutating func remove(newElement: Element) {
		if let index = self.indexOf(newElement) {
			self.removeAtIndex(index)
		}
	}
	
	public mutating func removeContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S) {
		for object in newElements {
			self.remove(object)
		}
	}
	
	public mutating func removeContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) {
		for object in newElements {
			self.remove(object)
		}
	}
}
