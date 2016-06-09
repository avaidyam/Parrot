import Foundation

// A nifty wrapper around NSOperationQueue (which is itself, a wrapper
// of dispatch_queue_t) to provide simple chaining and whatnot.
public typealias Dispatch = NSOperationQueue
public extension NSOperationQueue {
	
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
	public func quality(quality: NSQualityOfService) -> Self {
		self.qualityOfService = quality
		return self
	}
	
	@discardableResult
	public func add(block: () -> Void) -> Self {
		self.addOperation(NSBlockOperation(block: block))
		return self
	}
}

// Wrap a Dispatch Semaphore in a nice struct.
public struct Semaphore {
	let rawValue: dispatch_semaphore_t
	
	init(count: Int = 0) {
		self.rawValue = dispatch_semaphore_create(count)
	}
	
	@discardableResult
	public func signal() -> Int {
		return dispatch_semaphore_signal(self.rawValue)
	}
	
	/* TODO: Use dispatch_time_t until we replace it nicely. */
	@discardableResult
	public func wait(timeout: dispatch_time_t = DISPATCH_TIME_FOREVER) -> Int {
		return dispatch_semaphore_wait(self.rawValue, timeout)
	}
}

// alias for the UI thread
public func UI(block: () -> Void) {
	Dispatch.main().add(block: block)
}

// Provides the old-style @synchronized {} statements from Objective-C.
public func Synchronized(lock: AnyObject, closure: () -> ()) {
	objc_sync_enter(lock)
	closure()
	objc_sync_exit(lock)
}
