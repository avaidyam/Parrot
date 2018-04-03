import Foundation.NSDate

/// A Logger is responsible for persisting text information to disk or memory
/// for logging purposes. It relies on its Severity and Channel to do so.
public final class Logger {
	public typealias Subsystem = String
	public typealias Message = String //`Any...` ?
    
    /// The serial queue to queue all logging on.
    fileprivate static let queue = DispatchQueue(label: "com.avaidyam.Mocha.Logger", qos: .utility)
    
    /// A FileRef describes the spatial code location where the trace was caused.
    public struct FileRef: Codable, CustomStringConvertible {
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
    
    /// A LogUnit describes an instance of a log.
    public struct LogUnit: Codable, CustomStringConvertible {
        public let timestamp: TimeInterval = Date().timeIntervalSince1970
        public let fileRef: FileRef
        public let subsystem: Subsystem
        public let severity: Severity
        public let message: Message
        
        public init(_ fileRef: FileRef, _ subsystem: Subsystem, _ severity: Severity, _ message: Message) {
            self.fileRef = fileRef
            self.subsystem = subsystem
            self.severity = severity
            self.message = message
        }
        
        public var description: String {
            let date = Date(timeIntervalSince1970: self.timestamp)
            return "\(date) @ \(self.fileRef) [\(self.subsystem): \(self.severity)]:\n\(self.message)"
        }
    }
	
	/// A Channel is a pathway in which the logged data flows. For example,
	/// it may simply be printed to stdout, stderr, or sent to a system logging
	/// facility, or even displayed to the user visually if needed.
	public struct Channel {
		public let operation: (LogUnit) -> ()
        public init(operation: @escaping (LogUnit) -> ()) {
            self.operation = operation
        }
		
		/// Channel.print sends the message to stdout, with a debugging-suitable transformation.
        /// Note: it does not log many particulars that ASL or os_log would log.
		public static let print = Channel { Swift.print($0) }
	}
	
	public enum Severity: Int, Comparable, Codable {
		
		/// The application has encountered a catastrophic failure.
		case fatal
		
		/// The application has encountered an error that may be possible to recover from.
		case error
		
		/// The application has noticed internal inconsistencies.
		case warning
		
		/// The lowest priority in development, used for debugging purposes.
		case debug
        
        /// The lowest priority that you would normally log, purely informational in nature.
        case info
        
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
    
    // This can be globally mutated (NOT THREAD SAFE) to force Loggers.
    public static var globalChannels: [Channel] = []
	
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
        let ref = FileRef(file, line, function), message = message()
        Logger.queue.async {
            (self.channels + Logger.globalChannels).forEach {
                $0.operation(LogUnit(ref, self.subsystem, severity, message))
            }
        }
	}
    
    public func backtrace(_ severity: Severity) {
        guard self.severity >= severity else { return }
        let cs = Thread.callStackSymbols.dropFirst().joined(separator: "\n")
        Logger.queue.async {
            (self.channels + Logger.globalChannels).forEach {
                $0.operation(LogUnit(FileRef(backtrace: true), self.subsystem, severity, cs))
            }
        }
    }
}

#if os(OSX)
import asl
public extension Logger.Channel {
    
    /// Channel.ASL uses the Apple System Logging facility to submit the message.
    /// Note: ASL may not accept the message flow if its configuration severity
    /// is at a different level than what is set here.
    public static let ASL = Logger.Channel { unit in
        withVaList([]) { args in
            var s = ASL_LEVEL_DEBUG
            switch unit.severity {
            case .fatal: s = ASL_LEVEL_EMERG
            case .error: s = ASL_LEVEL_ERR
            case .warning: s = ASL_LEVEL_WARNING
            case .debug: s = ASL_LEVEL_NOTICE
            case .info: s = ASL_LEVEL_INFO
            }
            
            // For whatever reason, ASL_LEVEL_NOTICE and *_DEBUG are swapped around?
            unit.subsystem.withCString {
                let _l = asl_open(nil, $0, 0)
                defer { asl_close(_l) }
                asl_vlog(_l, asl_new(UInt32(ASL_TYPE_MSG)), s, unit.fileRef.description + ":\n" + unit.message, args)
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
	
	public func error(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
		self.trace(severity: .error, message: message, file, line, function)
	}
	
	public func warning(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
		self.trace(severity: .warning, message: message, file, line, function)
	}
	
	public func debug(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
		self.trace(severity: .debug, message: message, file, line, function)
	}
    
    public func info(_ message: @autoclosure () -> Message, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.trace(severity: .info, message: message, file, line, function)
    }
}
