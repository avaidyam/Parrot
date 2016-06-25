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

/// Completely dysfunctional with UserDefaults for some insane reason.
public final class KVOTrampoline: NSObject {
	private let refObject: NSObject
	private let refAction: (Void) -> Void
	private var refCounts = [String: UInt]()
	
	public required init(observeOn object: NSObject, perform handler: (Void) -> Void) {
		self.refObject = object
		self.refAction = handler
	}
	
	public func observe(keyPath: String) {
		if (self.refCounts[keyPath] ?? 0) == 0 {
			self.refObject.addObserver(self, forKeyPath: keyPath, options: [.initial, .new], context: nil)
		}
		self.refCounts[keyPath] = (self.refCounts[keyPath] ?? 0) + 1
	}
	
	public func release(keyPath: String) {
		self.refCounts[keyPath] = (self.refCounts[keyPath] ?? 0) - 1
		if (self.refCounts[keyPath] ?? 0) == 0 {
			self.refObject.removeObserver(self, forKeyPath: keyPath)
		}
	}
	
	public override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?,
	                                  change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
		guard let o = object where o === self.refObject else { return }
		guard let k = keyPath where self.refCounts.keys.contains(k) else { return }
		self.refAction()
	}
}
