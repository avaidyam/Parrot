import Foundation

private struct WeakRef<T: AnyObject>: Equatable {
	weak var value: T?
	init(_ value: T) {
		self.value = value
	}
}
private func ==<T>(lhs: WeakRef<T>, rhs: WeakRef<T>) -> Bool {
	return lhs.value === rhs.value
}

// from @tumtumtum: tumtumtum/SwiftMulticastDelegate
public class MulticastDelegate<T: AnyObject> {
	private var delegates: [WeakRef<T>]
	
	private init(delegate: T) {
		self.delegates = [WeakRef<T>(delegate)]
	}
	
	private init(delegates: Array<WeakRef<T>>) {
		self.delegates = delegates
	}
	
	private init(delegates: Array<WeakRef<T>>, delegate: T) {
		var copy = delegates
		copy.append(WeakRef(delegate))
		self.delegates = copy
	}
	
	public static func addDelegate(_ multicastDelegate: MulticastDelegate<T>, delegate: T) -> MulticastDelegate<T>? {
		return MulticastDelegate<T>(delegates: multicastDelegate.delegates, delegate: delegate)
	}
	
	public static func removeDelegate(_ multicastDelegate: MulticastDelegate<T>, delegate: T) -> MulticastDelegate<T>? {
		for (index, ref) in multicastDelegate.delegates.enumerated() {
			if ref.value === delegate {
				if multicastDelegate.delegates.count == 1 {
					return nil
				}
				var newDelegates = Array<WeakRef<T>>(multicastDelegate.delegates[0..<index])
				if multicastDelegate.delegates.count - index - 1 > 0 {
					newDelegates.append(contentsOf: multicastDelegate.delegates[index + 1..<multicastDelegate.delegates.count])
				}
				return MulticastDelegate<T>(delegates: newDelegates)
			}
		}
		
		return multicastDelegate
	}
	
	public static func invoke(_ multicastDelegate: MulticastDelegate<T>, invocation: (T) -> ()) -> MulticastDelegate<T>? {
		var newDelegates: Array<WeakRef<T>>? = nil
		for (index, ref) in multicastDelegate.delegates.enumerated() {
			if let delegate = ref.value {
				invocation(delegate)
				if var newDelegates = newDelegates {
					newDelegates.append(ref)
				}
			} else {
				if newDelegates == nil && index > 0 {
					newDelegates = Array(multicastDelegate.delegates[0..<index])
				}
			}
		}
		if let newDelegates = newDelegates {
			return MulticastDelegate<T>(delegates: newDelegates)
		}
		return multicastDelegate
	}
}

public func +=<T>(left: inout MulticastDelegate<T>?, right: T) {
	if left != nil {
		left = MulticastDelegate<T>.addDelegate(left!, delegate: right)
	} else {
		left = MulticastDelegate<T>(delegate: right)
	}
}

public func -=<T>(left: inout MulticastDelegate<T>?, right: T) {
	guard left != nil else { return }
	left = MulticastDelegate<T>.removeDelegate(left!, delegate: right)
}

infix operator => {}
public func =><T>(left: inout MulticastDelegate<T>?, invocation: (T) -> ()) {
	guard left != nil else { return }
	
	let old = left
	let cleaned = MulticastDelegate<T>.invoke(left!, invocation: invocation)
	
	if old === left {
		left = cleaned
	}
}
