import Cocoa
import Hangouts

extension NSView {
    public class func instantiateFromNib<T: NSView>(identifier identifier: String, owner: AnyObject?) -> T? {
        var objects: NSArray?
        let nibName = T.className().componentsSeparatedByString(".").last
        if NSBundle.mainBundle().loadNibNamed(nibName!, owner: owner, topLevelObjects: &objects) {
            if let objects = objects {
                let candidate = objects.filter { $0 is T }.map { $0 as! T }.filter { $0.identifier == identifier }.first
                assert(candidate != nil, "Could not find view with identifier \(identifier) in \(nibName).xib.")
                return candidate
            }
        }
        assert(false, "Could not find view with identifier \(identifier) in \(nibName).xib.")
        return nil
    }
}

// A nifty wrapper around NSOperationQueue (which is itself, a wrapper
// of dispatch_queue_t) to provide simple chaining and whatnot.
typealias Dispatch = NSOperationQueue
extension NSOperationQueue {
	public func async(block: () -> Void) {
		self.addOperations([NSBlockOperation(block: block)], waitUntilFinished: false)
		//return self
	}
	
	public func sync(block: () -> Void) -> NSOperationQueue {
		self.addOperations([NSBlockOperation(block: block)], waitUntilFinished: true)
		return self
	}
}