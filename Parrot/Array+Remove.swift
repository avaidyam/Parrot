import Foundation

// Finally, matching operations where append*() was applicable, for remove*()
public extension Array where Element : Equatable {
	public mutating func remove(_ item: Element) {
		if let index = self.index(of: item) {
			self.remove(at: index)
		}
	}
	
	public mutating func removeContentsOf<S : Sequence where S.Iterator.Element == Element>(_ newElements: S) {
		for object in newElements {
			self.remove(object)
		}
	}
	
	public mutating func removeContentsOf<C : Collection where C.Iterator.Element == Element>(_ newElements: C) {
		for object in newElements {
			self.remove(object)
		}
	}
}

/// Can hold any (including non-object) type as an object type.
public class Wrapper<T> {
	public let element: T
	public init(_ value: T) {
		self.element = value
	}
}

// alias for the UI thread
public func UI(_ block: () -> Void) {
	DispatchQueue.main.async(execute: block)
}

// Provides the old-style @synchronized {} statements from Objective-C.
public func Synchronized(_ lock: AnyObject, closure: () -> ()) {
	objc_sync_enter(lock)
	closure()
	objc_sync_exit(lock)
}

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

public extension Timer {
	
	/// Trigger a notification every minute, starting from the next minute.
	public class func scheduledWallclock(_ target: AnyObject, selector: Selector) -> Timer {
		var comps = Calendar.current().components(_units, from: Date())
		comps.minute = (comps.minute ?? 0) + 1; comps.second = 0
		let date = Calendar.current().date(from: comps)!
		let timer = Timer(fireAt: date, interval: 60, target: target,
		                  selector: selector, userInfo: nil, repeats: true)
		RunLoop.main().add(timer, forMode: RunLoopMode.defaultRunLoopMode)
		return timer
	}
}

// Optional Setter
infix operator ??= { associativity right precedence 90 }
public func ??= <T>(lhs: inout T?,  rhs: @autoclosure () -> T) {
	lhs = lhs ?? rhs()
}
