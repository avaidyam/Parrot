import Foundation

// Finally, matching operations where append*() was applicable, for remove*()
public extension Array where Element : Equatable {
	public mutating func remove(_ item: Element) {
		if let index = self.index(of: item) {
			self.remove(at: index)
		}
	}
	
	public mutating func removeContentsOf<S : Sequence where S.Iterator.Element == Element>(_ newElements: S) {
		for object in newElements {
			self.remove(item: object)
		}
	}
	
	public mutating func removeContentsOf<C : Collection where C.Iterator.Element == Element>(_ newElements: C) {
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

// A nifty wrapper around NSOperationQueue (which is itself, a wrapper
// of dispatch_queue_t) to provide simple chaining and whatnot.
public typealias Dispatch = OperationQueue
public extension OperationQueue {
	
	@discardableResult
	public func pause() -> Self {
		self.isSuspended = true
		return self
	}
	
	@discardableResult
	public func resume() -> Self {
		self.isSuspended = false
		return self
	}
	
	@discardableResult
	public func stop() -> Self {
		self.cancelAllOperations()
		return self
	}
	
	@discardableResult
	public func wait() -> Self {
		self.waitUntilAllOperationsAreFinished()
		return self
	}
	
	@discardableResult
	public func quality(_ quality: QualityOfService) -> Self {
		self.qualityOfService = quality
		return self
	}
	
	@discardableResult
	public func add(_ block: () -> Void) -> Self {
		self.addOperation(BlockOperation(block: block))
		return self
	}
}

// Wrap a Dispatch Semaphore in a nice struct.
public struct Semaphore {
	let rawValue: DispatchSemaphore
	
	init(count: Int = 0) {
		self.rawValue = DispatchSemaphore(value: count)
	}
	
	@discardableResult
	public func signal() -> Int {
		return self.rawValue.signal()
	}
	
	/* TODO: Use dispatch_time_t until we replace it nicely. */
	@discardableResult
	public func wait(_ timeout: DispatchTime = DispatchTime.distantFuture) -> Int {
		return self.rawValue.wait(timeout: timeout)
	}
}

// alias for the UI thread
public func UI(_ block: () -> Void) {
	Dispatch.main().add(block)
}

// Provides the old-style @synchronized {} statements from Objective-C.
public func Synchronized(_ lock: AnyObject, closure: () -> ()) {
	objc_sync_enter(lock)
	closure()
	objc_sync_exit(lock)
}

/// A proxy for NSProcessInfo's NSActivity API.
/// Simplified for internal use only.
public struct NSActivity {
	public static var activities = [String: NSObjectProtocol]()
	public static let mode: ProcessInfo.ActivityOptions = [
		.userInitiated, // every Parrot action MUST be user-initiated
		.suddenTerminationDisabled, // prevent termination during action
		.automaticTerminationDisabled, // prevent termination during action
		//.userInitiatedAllowingIdleSystemSleep, // prevent idle sleep
		//.idleSystemSleepDisabled, // prevent idle sleep
		//.idleDisplaySleepDisabled, // prevent display sleep
		//.background, // for background notifications
		//.latencyCritical // for audio/video streaming
	]
	
	public static func begin(_ string: String) {
		let holder = ProcessInfo.processInfo().beginActivity(mode, reason: string)
		activities[string] = holder
	}
	
	public static func end(_ string: String) {
		if let act = activities[string] {
			ProcessInfo.processInfo().endActivity(act)
		}
	}
}


