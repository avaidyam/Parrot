import Foundation
import class ParrotServiceExtension.Logger

/* TODO: Create Services using NSBackgroundActivityScheduler. */
/* TODO: Finish DispatchOperation. */
/* TODO: Integrate NSProgress, Logger, os_activity, and os_trace. */
/* TODO: Add property .cancellable and ensure NSApplication doesn't quit until .cancellable propogates. */
/* TODO: Use applicationShouldTerminate() to control this behavior. */

/*public var log: Logger {
	return AppActivity.current.logger
}*/

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
	
	public private(set) static var current: AppActivity! = nil
	public var logger: Logger! = nil
	
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
