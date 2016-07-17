import Foundation.NSDate
import asl

/* TODO: Support Logger hierarchies like NSProgress. */
/* TODO: Support same parameters as Swift's print() or debugPrint(). */
/* TODO: Support dumping backtraces using Thread.callStackSymbols. */
/* TODO: Support for ASL facilities, objects, and parameters. */
/* TODO: Support logging date/time, file, function, line. */

/// A Logger is responsible for persisting text information to disk or memory
/// for logging purposes. It relies on its Severity and Channel to do so.
public final class Logger {
	public typealias Subsystem = String
	public typealias Message = String
	
	/// A Channel is a pathway in which the logged data flows. For example,
	/// it may simply be printed to stdout, stderr, or sent to a system logging
	/// facility, or even displayed to the user visually if needed.
	public struct Channel {
		public let operation: (Message, Severity, Subsystem) -> ()
		
		/// Channel.print sends the message to stdout with tags.
		public static let print = Channel {
			Swift.print("[\($2)] [\($1)]: \($0)")
		}
		
		/// Channel.print sends the message to stdout, with a debugging-suitable transformation.
		public static let debugPrint = Channel {
			$0.1 >= .info ? Swift.debugPrint($0.0) : Swift.print($0.0)
		}
		
		/// Channel.ASL uses the Apple System Logging facility to submit the message.
		/// Note: ASL may not accept the message flow if its configuration severity
		/// is at a different level than what is set here.
		public static let ASL = Channel { message, severity, subsystem in
			withVaList([]) { ignore in
				var s = ASL_LEVEL_DEBUG
				switch severity {
				case .fatal: s = ASL_LEVEL_EMERG
				case .critical: s = ASL_LEVEL_CRIT
				case .error: s = ASL_LEVEL_ERR
				case .warning: s = ASL_LEVEL_WARNING
				case .info: s = ASL_LEVEL_NOTICE
				case .debug: s = ASL_LEVEL_INFO
				case .verbose: s = ASL_LEVEL_DEBUG
				}
				asl_vlog(nil, nil, s, message, ignore)
			}
		}
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
	
	public let subsystem: Subsystem
	public let channels: [Channel]
	public var severity: Severity
	
	/// Initialize a Logger for a particular subsystem. 
	/// Note: the subsystem should preferrably be a unique reverse domain name.
	/// Note: if channels is empty, the message will not enter a logging flow.
	/// Note: by default, the Logger is configured to act similarly to NSLog.
	public init(subsystem: Subsystem, channels: [Channel] = [Channel.print/*, Channel.ASL*/], severity: Severity = .verbose) {
		self.subsystem = subsystem
		self.channels = channels
		self.severity = severity
	}
	
	/// Post a message to the Logger with a given severity. This message will 
	/// flow through the Logger's Channel if the Severity allows it.
	public func trace(severity: Severity, message: @autoclosure() -> Message) {
		guard self.severity >= severity else { return }
		self.channels.forEach { $0.operation(message(), severity, self.subsystem) }
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
	public func fatal(_ message: @autoclosure() -> Message) {
		self.trace(severity: .fatal, message: message)
	}
	
	public func critical(_ message: @autoclosure() -> Message) {
		self.trace(severity: .critical, message: message)
	}
	
	public func error(_ message: @autoclosure() -> Message) {
		self.trace(severity: .error, message: message)
	}
	
	public func warning(_ message: @autoclosure() -> Message) {
		self.trace(severity: .warning, message: message)
	}
	
	public func info(_ message: @autoclosure() -> Message) {
		self.trace(severity: .info, message: message)
	}
	
	public func debug(_ message: @autoclosure() -> Message) {
		self.trace(severity: .debug, message: message)
	}
	
	public func verbose(_ message: @autoclosure() -> Message) {
		self.trace(severity: .verbose, message: message)
	}
}
