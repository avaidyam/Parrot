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

/*
public class DispatchOperation<Input, Output, Error: Error> {
	/* [.barrier, .detached, .assignCurrentContext, .noQoS, .inheritQoS, .enforceQoS] */
	
	private var workItem: DispatchWorkItem
	private var group: DispatchGroup
	
	private var input: Input! = nil
	private var output: Output! = nil
	private var error: Error! = nil
	
	public init(qos: DispatchQoS = .default, block: () -> (Output)) {
		self.group = DispatchGroup()
		self.workItem = DispatchWorkItem(group: self.group, qos: qos, flags: [.inheritQoS, .enforceQoS]) {
			block()
		}
	}
	
	private init(parent: DispatchOperation, block: () -> (Output)) {
		self.group = parent.group
		self.workItem = DispatchWorkItem(group: parent.group, qos: .userInitiated, flags: [.inheritQoS, .enforceQoS]) {
			block()
		}
		parent.workItem.notify(queue: DispatchQueue.main, execute: self.workItem)
	}
}
*/

