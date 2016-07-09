import Foundation

private enum TaskExecutionState {
	case active
}

public final class DispatchTask<Result> {
	
	private var work: DispatchWorkItem!
	private var result: Result? = nil
	private var previous: DispatchTask!
	private weak var next: DispatchTask!
	
	public func wait(timeout: DispatchTime = .distantFuture) throws -> Result {
		throw NSError()
	}
	
	public func wait(timeout: DispatchWallTime = .distantFuture) throws -> Result {
		throw NSError()
	}
	
	public func perform(onQueue: DispatchQueue = .main) {
		
	}
	
	public func then<T>(do workItem: DispatchTask<T>) {
		//self.next = workItem
	}
	
	
	/*
	public init(group: DispatchGroup? = default, qos: DispatchQoS = default, flags: DispatchWorkItemFlags = default, block: @convention(block) () -> ())
	
	public func perform()
	
	public func notify(qos: DispatchQoS = default, flags: DispatchWorkItemFlags = default, queue: DispatchQueue, execute: @convention(block) () -> Swift.Void)
	
	public func notify(queue: DispatchQueue, execute: DispatchWorkItem)
	
	public func cancel()
	
	public var isCancelled: Bool { get }
	*/
	
}
