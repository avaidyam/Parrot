import Foundation

// A nifty wrapper around NSOperationQueue (which is itself, a wrapper
// of dispatch_queue_t) to provide simple chaining and whatnot.
public typealias Dispatch = NSOperationQueue
public extension NSOperationQueue {
	
	public class func main() -> NSOperationQueue {
		return NSOperationQueue.mainQueue()
	}
	
	public class func current() -> NSOperationQueue {
		return NSOperationQueue.currentQueue() ?? NSOperationQueue.mainQueue()
	}
	
	public func pause() -> Self {
		self.suspended = true
		return self
	}
	
	public func resume() -> Self {
		self.suspended = false
		return self
	}
	
	public func stop() -> Self {
		self.cancelAllOperations()
		return self
	}
	
	public func wait() -> Self {
		self.waitUntilAllOperationsAreFinished()
		return self
	}
	
	public func quality(quality: NSQualityOfService) -> Self {
		self.qualityOfService = quality
		return self
	}
	
	public func add(block: () -> Void) -> Self {
		self.addOperation(NSBlockOperation(block: block))
		return self
	}
}

// Provides the old-style @synchronized {} statements from Objective-C.
public func Synchronized(lock: AnyObject, closure: () -> ()) {
	objc_sync_enter(lock)
	closure()
	objc_sync_exit(lock)
}
