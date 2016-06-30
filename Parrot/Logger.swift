import func Foundation.NSLog
import asl

/* TODO: Support Logger hierarchies like NSProgress. */
/* TODO: Support same parameters as Swift's print() or debugPrint(). */
/* TODO: Support dumping backtraces using Thread.callStackSymbols. */
/* TODO: Finish support for ASL facilities, using userInfo parameters. */
/* TODO: Support logging date/time, file, function, line. */

/// A Logger is responsible for persisting text information to disk or memory
/// for logging purposes. It relies on its Severity and Channel to do so.
public final class Logger {
	
	/// A Channel is a pathway in which the logged data flows. For example,
	/// it may simply be printed to stdout, stderr, or sent to a system logging
	/// facility, or even displayed to the user visually if needed.
	public struct Channel {
		public let operation: (String, Severity) -> ()
		
		/// Channel.ignore does not submit the message anywhere.
		public static let ignore = Channel { _ in }
		
		/// Channel.print sends the message to stdout with tags.
		public static let print = Channel { Swift.print("[\($1)] \($0)") }
		
		/// Channel.print sends the message to stdout, with a debugging-suitable transformation.
		public static let debugPrint = Channel { $1 >= .info ? Swift.debugPrint($0) : Swift.print($0) }
		
		/// Channel.NSLog uses the NSLog function to submit the message.
		public static let NSLog = Channel { Foundation.NSLog($0.0) }
		
		/// Channel.ASL uses the Apple System Logging facility to submit the message.
		/*public static let ASL = Channel { a, b in
			let log_client = asl_open("Parrot", "Parrot Facility", UInt32(ASL_OPT_STDERR));
			asl_log(log_client, nil, ASL_LEVEL_EMERG, "Test: Error %m: %d", 42);
			asl_close(log_client)
		}*/
	}
	
	public enum Severity: Int, Comparable {
		
		/// The application has encountered a catastrophic failure.
		case fatal
		
		/// The application has encountered a serious failure in a major component.
		case critical
		
		/// The application has encountered an error that may be possible to recover from.
		case error
		
		/// The application has noticed internal inconsistencies.
		case warning
		
		/// The lowest priority that you would normally log, purely informational in nature.
		case info
		
		/// The lowest priority in development, used for debugging purposes.
		case debug
		
		/// The lowest priority, not commonly logged unless requested.
		case verbose
	}
	
	public let subsystem: String
	public let channels: [Channel]
	public var severity: Severity
	
	/// Initialize a Logger for a particular subsystem. 
	/// Note: the subsystem should preferrably be a unique reverse domain name.
	public init(subsystem: String, channels: [Channel] = [Channel.print], severity: Severity = .verbose) {
		self.subsystem = subsystem
		self.channels = channels
		self.severity = severity
	}
	
	/// Post a message to the Logger with a given severity. This message will 
	/// flow through the Logger's Channel if the Severity allows it.
	public func post(severity: Severity, message: @autoclosure() -> String) {
		guard self.severity >= severity else { return }
		self.channels.forEach { $0.operation(message(), self.severity) }
	}
}

public func ==(lhs: Logger.Severity, rhs: Logger.Severity) -> Bool {
	return lhs.rawValue == rhs.rawValue
}

public func <(lhs: Logger.Severity, rhs: Logger.Severity) -> Bool {
	return lhs.rawValue < rhs.rawValue
}

/// Shortcuts for Logger.post(...)
public extension Logger {
	public func fatal(_ message: @autoclosure() -> String) {
		self.post(severity: .fatal, message: message)
	}
	
	public func critical(_ message: @autoclosure() -> String) {
		self.post(severity: .critical, message: message)
	}
	
	public func error(_ message: @autoclosure() -> String) {
		self.post(severity: .error, message: message)
	}
	
	public func warning(_ message: @autoclosure() -> String) {
		self.post(severity: .warning, message: message)
	}
	
	public func info(_ message: @autoclosure() -> String) {
		self.post(severity: .info, message: message)
	}
	
	public func debug(_ message: @autoclosure() -> String) {
		self.post(severity: .debug, message: message)
	}
	
	public func verbose(_ message: @autoclosure() -> String) {
		self.post(severity: .verbose, message: message)
	}
}
