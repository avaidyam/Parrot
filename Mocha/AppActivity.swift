import Foundation

private let log = Logger(subsystem: "MochaUI.AppActivity")

/* TODO: Create Services using NSBackgroundActivityScheduler. */
/* TODO: Finish DispatchOperation. */
/* TODO: Integrate NSProgress, Logger, os_activity, and os_trace. */
/* TODO: Add property .cancellable and ensure NSApplication doesn't quit until .cancellable propogates. */
/* TODO: Use applicationShouldTerminate() to control this behavior. */
/* TODO: Merge with DispatchOperation perhaps? */

/*public var log: Logger {
	return AppActivity.current.logger
}*/

// sessions: app launch -> death
// exceptions: swift.Error
// event: ??
// screenview: ??

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
		let holder = ProcessInfo.processInfo.beginActivity(options: mode, reason: string)
		activities[string] = holder
		log.info("Starting activity \"\(string)\"")
        //GoogleReporter.shared.event(<#T##category: String##String#>, action: <#T##String#>, label: <#T##String#>, parameters: <#T##[String : String]#>)
        //GoogleReporter.shared.screenView(<#T##name: String##String#>, parameters: <#T##[String : String]#>)
	}
    
    public static func report(error: LocalizedError, fatal: Bool = false) {
        GoogleReporter.shared.exception(error.localizedDescription, isFatal: fatal, parameters: [
            NSLocalizedDescriptionKey: error.errorDescription ?? "",
            NSLocalizedFailureReasonErrorKey: error.failureReason ?? "",
        ])
    }
	
	public static func end(_ string: String) {
		if let act = activities[string] {
			ProcessInfo.processInfo.endActivity(act)
			log.info("Ending activity \"\(string)\"")
		}
	}
}
