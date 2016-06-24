import Foundation

/// A proxy for NSProcessInfo's BackgroundActivity API.
/// Simplified for internal use only.
/* TODO: Use NSBackgroundActivityScheduler as well. */
public struct BackgroundActivity {
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
