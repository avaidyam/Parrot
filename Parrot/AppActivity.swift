import Foundation

/* TODO: Create Services using NSBackgroundActivityScheduler. */
/* TODO: Finish DispatchOperation. */
/* TODO: Integrate NSProgress, Logger, os_activity, and os_trace. */
/* TODO: Add property .cancellable and ensure NSApplication doesn't quit until .cancellable propogates. */
/* TODO: Use applicationShouldTerminate() to control this behavior. */

/// A proxy for NSProcessInfo's BackgroundActivity API.
/// Simplified for internal use only.
public struct AppActivity {
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
	
	public private(set) static var current: AppActivity? = nil
	
	public static func start(_ string: String, cancellable: Bool = false) {
		let holder = ProcessInfo.processInfo().beginActivity(mode, reason: string)
		activities[string] = holder
		log.info("Starting activity \"\(string)\"")
	}
	
	public static func end(_ string: String) {
		if let act = activities[string] {
			ProcessInfo.processInfo().endActivity(act)
			log.info("Ending activity \"\(string)\"")
		}
	}
}

/*
public class DispatchOperation<Input, Output, Error: ErrorProtocol> {
	/* [.barrier, .detached, .assignCurrentContext, .noQoS, .inheritQoS, .enforceQoS] */
	
	public init(group: DispatchGroup? = nil, qos: DispatchQoS = .default, block: (Input) -> (Output, Error)) {
		
	}
	
	public func perform() -> (Output, Error) {
		return ()
	}
	
	public func wait() -> (Output, Error) {
		return ()
	}
	
	public func wait(timeout: DispatchTime) -> (Output, Error, DispatchTimeoutResult) {
		return ()
	}
	
	public func wait(wallTimeout: DispatchWallTime) -> (Output, Error, DispatchTimeoutResult) {
		return ()
	}
	
	public func notify(qos: DispatchQoS = .default, queue: DispatchQueue, execute: () -> Void) {
		
	}
	
	public func notify(queue: DispatchQueue, execute: DispatchWorkItem) {
		
	}
	
	public func cancel() {
		
	}
	
	public var isCancelled: Bool {
		return false
	}
}*/
