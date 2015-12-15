import Foundation

// A nifty wrapper around NSOperationQueue (which is itself, a wrapper
// of dispatch_queue_t) to provide simple chaining and whatnot.
typealias Dispatch = NSOperationQueue
extension NSOperationQueue {
	
	public class func main() -> NSOperationQueue {
		return NSOperationQueue.mainQueue()
	}
	
	public class func current() -> NSOperationQueue {
		return NSOperationQueue.currentQueue() ?? NSOperationQueue.mainQueue()
	}
	
	public func pause() -> NSOperationQueue {
		self.suspended = true
		return self
	}
	
	public func resume() -> NSOperationQueue {
		self.suspended = false
		return self
	}
	
	public func stop() -> NSOperationQueue {
		self.cancelAllOperations()
		return self
	}
	
	public func wait() -> NSOperationQueue {
		self.waitUntilAllOperationsAreFinished()
		return self
	}
	
	public func quality(quality: NSQualityOfService) -> NSOperationQueue {
		self.qualityOfService = quality
		return self
	}
	
	public func run(block: () -> Void) -> NSOperationQueue {
		self.addOperation(NSBlockOperation(block: block))
		return self
	}
}

public func mainQueue() -> NSOperationQueue {
	return NSOperationQueue.mainQueue()
}

public func currentQueue() -> NSOperationQueue {
	return NSOperationQueue.currentQueue() ?? NSOperationQueue.mainQueue()
}

