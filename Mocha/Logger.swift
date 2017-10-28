import Foundation.NSDate

/* TODO: Support Logger hierarchies like NSProgress. */
/* TODO: Support separator + terminator on Any... type. */
/* TODO: Support dumping backtraces using Thread.callStackSymbols. */

/// A Logger is responsible for persisting text information to disk or memory
/// for logging purposes. It relies on its Severity and Channel to do so.
public final class Logger {
	public typealias Subsystem = String
	public typealias Message = String //`Any...` ?
    
    /// A FileRef describes the spatial code location where the trace was caused.
    public struct FileRef: CustomStringConvertible {
        public let file: String
        public let line: Int
        public let function: String
        private var backtrace: Bool
        
        public init(_ file: String = #file, _ line: Int = #line, _ function: String = #function, backtrace: Bool = false) {
            self.file = file
            self.line = line
            self.function = function
            self.backtrace = backtrace
        }
        
        public var description: String {
            return self.backtrace ? "backtrace" : "\(self.file.split(separator: "/").last ?? "<?>"):\(self.line)[\(self.function)]"
        }
    }
	
	/// A Channel is a pathway in which the logged data flows. For example,
	/// it may simply be printed to stdout, stderr, or sent to a system logging
	/// facility, or even displayed to the user visually if needed.
	public struct Channel {
		public let operation: (FileRef, Message, Severity, Subsystem) -> ()
        public init(operation: @escaping (FileRef, Message, Severity, Subsystem) -> ()) {
            self.operation = operation
        }
		
		/// Channel.print sends the message to stdout, with a debugging-suitable transformation.
        /// Note: it does not log many particulars that ASL or os_log would log.
		public static let print = Channel {
			var output = ""
			_ = $2 >= .info
				? debugPrint($1, terminator: "", to: &output)
				: Swift.print($1, terminator: "", to: &output)
			Swift.print("[\(Date())] [\($3)] [\($2)]: \(output)")
		}
	}
	
	public enum Severity: Int, Comparable {
		
		/// The application has encountered a catastrophic failure.
		case fatal
		
		/// The application has encountered a serious failure in a major component.
		//case critical
		
		/// The application has encountered an error that may be possible to recover from.
		case error
		
		/// The application has noticed internal inconsistencies.
		//case warning
		
		/// The lowest priority in development, used for debugging purposes.
		case debug
        
        /// The lowest priority that you would normally log, purely informational in nature.
        case info
		
		/// The lowest priority, not commonly logged unless requested.
		//case verbose
        
        public static func ==(lhs: Logger.Severity, rhs: Logger.Severity) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        public static func <(lhs: Logger.Severity, rhs: Logger.Severity) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
	}
	
	public let subsystem: Subsystem
	public let channels: [Channel]
	public var severity: Severity
    
    public static let `default` = Logger(subsystem: "_Global")
    
    #if os(OSX)
    public static let defaultChannels: [Channel] = [.ASL]
    #else
    public static let defaultChannels: [Channel] = [.print]
    #endif
	
	/// Initialize a Logger for a particular subsystem. 
	/// Note: the subsystem should preferrably be a unique reverse domain name.
	/// Note: if channels is empty, the message will not enter a logging flow.
	/// Note: by default, the Logger is configured to act similarly to NSLog.
	public init(subsystem: Subsystem, channels: [Channel] = defaultChannels, severity: Severity = .info) {
		self.subsystem = subsystem
		self.channels = channels
		self.severity = severity
	}
	
	/// Post a message to the Logger with a given severity. This message will 
	/// flow through the Logger's Channel if the Severity allows it.
	public func trace(severity: Severity, message: @autoclosure () -> Message,
                      _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
		guard self.severity >= severity else { return }
        let ref = FileRef(file, line, function)
		self.channels.forEach { $0.operation(ref, message(), severity, self.subsystem) }
	}
    
    public func backtrace(severity: Severity) {
        guard self.severity >= severity else { return }
        let cs = Thread.callStackSymbols.dropFirst().joined(separator: "\n")
        self.channels.forEach { $0.operation(FileRef(backtrace: true), cs, severity, self.subsystem) }
    }
}

#if os(OSX)
import asl
public extension Logger.Channel {
    
    /// Channel.ASL uses the Apple System Logging facility to submit the message.
    /// Note: ASL may not accept the message flow if its configuration severity
    /// is at a different level than what is set here.
    public static let ASL = Logger.Channel { ref, message, severity, subsystem in
        withVaList([]) { args in
            var s = ASL_LEVEL_DEBUG
            switch severity {
            case .fatal: s = ASL_LEVEL_EMERG
            //case .critical: s = ASL_LEVEL_CRIT
            case .error: s = ASL_LEVEL_ERR
            //case .warning: s = ASL_LEVEL_WARNING
            case .debug: s = ASL_LEVEL_NOTICE
            case .info: s = ASL_LEVEL_INFO
            //case .verbose: s = ASL_LEVEL_DEBUG
            }
            
            // For whatever reason, ASL_LEVEL_NOTICE and *_DEBUG are swapped around?
            subsystem.withCString {
                let _l = asl_open(nil, $0, 0)
                defer { asl_close(_l) }
                asl_vlog(_l, asl_new(UInt32(ASL_TYPE_MSG)), s, ref.description + ":\n" + message, args)
            }
        }
    }
}
#endif

/// Shortcuts for Logger.trace(...)
public extension Logger {
	public func fatal(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
		self.trace(severity: .fatal, message: message, file, line, function)
	}
	
	//public func critical(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
	//	self.trace(severity: .critical, message: message, file, line, function)
	//}
	
	public func error(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
		self.trace(severity: .error, message: message, file, line, function)
	}
	
	//public func warning(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
	//	self.trace(severity: .warning, message: message, file, line, function)
	//}
	
	public func info(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
		self.trace(severity: .info, message: message, file, line, function)
	}
	
	public func debug(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
		self.trace(severity: .debug, message: message, file, line, function)
	}
	
	//public func verbose(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
	//	self.trace(severity: .verbose, message: message, file, line, function)
	//}
}
