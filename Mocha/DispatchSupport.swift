import Dispatch

/* TODO: DispatchWorkItem: name, dependencies, isExecuting, Result<Any, Error> + retry. */

public extension Int {
    public var hours: DispatchTimeInterval {
        return DispatchTimeInterval.seconds(self * 60 * 60)
    }
    public var minutes: DispatchTimeInterval {
        return DispatchTimeInterval.seconds(self * 60)
    }
    public var seconds: DispatchTimeInterval {
        return DispatchTimeInterval.seconds(self)
    }
    public var milliseconds: DispatchTimeInterval {
        return DispatchTimeInterval.milliseconds(self)
    }
    public var microseconds: DispatchTimeInterval {
        return DispatchTimeInterval.microseconds(self)
    }
    public var nanoseconds: DispatchTimeInterval {
        return DispatchTimeInterval.nanoseconds(self)
    }
}

public extension DispatchTimeInterval {
    
    public func toSeconds() -> Double {
        switch self {
        case let .seconds(s):
            return Double(s)
        case let .milliseconds(ms):
            return Double(Double(ms) / 1000.0)
        case let .microseconds(us):
            return Double(UInt64(us) * NSEC_PER_USEC) / Double(NSEC_PER_SEC)
        case let .nanoseconds(ns):
            return Double(ns) / Double(NSEC_PER_SEC)
        case .never:
            return .greatestFiniteMagnitude
        }
    }
    
    public var later: DispatchTime {
        return DispatchTime.now() + self
    }
}

public extension DispatchSource {
    public static func timer(flags: DispatchSource.TimerFlags = [], queue: DispatchQueue? = nil,
                              deadline: DispatchTime, repeating interval: DispatchTimeInterval = .never,
                              leeway: DispatchTimeInterval = .nanoseconds(0), handler: DispatchWorkItem) -> DispatchSourceTimer
    {
        let t = DispatchSource.makeTimerSource(flags: flags, queue: queue)
        t.schedule(deadline: deadline, repeating: interval, leeway: leeway)
        t.setEventHandler(handler: handler)
        t.resume()
        return t
    }
    
    public static func timer(flags: DispatchSource.TimerFlags = [], queue: DispatchQueue? = nil,
                              wallDeadline: DispatchWallTime, repeating interval: DispatchTimeInterval = .never,
                              leeway: DispatchTimeInterval = .nanoseconds(0), handler: DispatchWorkItem) -> DispatchSourceTimer
    {
        let t = DispatchSource.makeTimerSource(flags: flags, queue: queue)
        t.schedule(wallDeadline: wallDeadline, repeating: interval, leeway: leeway)
        t.setEventHandler(handler: handler)
        t.resume()
        return t
    }
}

// Marks global and main queues in an accessible way.
public extension DispatchQueue {
    
    public enum QueueType: Equatable {
        case main
        case global(DispatchQoS.QoSClass)
        case custom(String?)
        
        public static func ==(lhs: QueueType, rhs: QueueType) -> Bool {
            switch (lhs, rhs) {
            case (let .global(qos1), let .global(qos2)):
                return qos1 == qos2
            case (let .custom(str1), let .custom(str2)):
                return str1 == str2
            case (.main, .main):
                return true
            default:
                return false
            }
        }
    }
    
    /// Retrieve the current queue AuxType, and bootstrap the system if needed.
    /// Note: bootstrapping occurs on the invoking queue.
    /// Note: if invoked, no label is returned for a custom queue.
    public static var current: QueueType {
        _ = DispatchQueue.setupQueueToken
        return DispatchQueue.getSpecific(key: DispatchQueue._key) ?? .custom(nil)
    }
    
    public var queueType: QueueType {
        _ = DispatchQueue.setupQueueToken
        return self.getSpecific(key: DispatchQueue._key) ?? .custom(self.label)
    }
    
    private static let _key = DispatchSpecificKey<DispatchQueue.QueueType>()
    private static var setupQueueToken: Void = {
        DispatchQueue.main.setSpecific(key: _key, value: .main)
        DispatchQueue.global(qos: .background).setSpecific(key: _key, value: .global(.background))
        DispatchQueue.global(qos: .default).setSpecific(key: _key, value: .global(.default))
        DispatchQueue.global(qos: .userInitiated).setSpecific(key: _key, value: .global(.userInitiated))
        DispatchQueue.global(qos: .userInteractive).setSpecific(key: _key, value: .global(.userInteractive))
        DispatchQueue.global(qos: .utility).setSpecific(key: _key, value: .global(.utility))
        return ()
    }()
}
