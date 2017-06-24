import Dispatch

public extension Int {
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
        }
    }
    
    public var later: DispatchTime {
        return DispatchTime.now() + self
    }
}

// Marks global and main queues in an accessible way. Must call setupQueues() on
// app init, and then current will work.
public extension DispatchQueue {
    
    public enum QueueType: Equatable {
        case main
        case global(DispatchQoS.QoSClass)
        case other(String)
        case unknown
        
        public static func ==(lhs: QueueType, rhs: QueueType) -> Bool {
            switch (lhs, rhs) {
            case (let .global(qos1), let .global(qos2)):
                return qos1 == qos2
            case (let .other(str1), let .other(str2)):
                return str1 == str2
            case (.main, .main):
                return true
            case (.unknown, .unknown):
                return true
            default:
                return false
            }
        }
    }
    
    /// Retrieve the current queue AuxType, and bootstrap the system if needed.
    /// Note: bootstrapping occurs on the invoking queue.
    public static var current: QueueType {
        _ = DispatchQueue.setupQueueToken
        return DispatchQueue.getSpecific(key: DispatchQueue._key) ?? .unknown
    }
    
    public var queueType: QueueType {
        get {
            _ = DispatchQueue.setupQueueToken
            return self.getSpecific(key: DispatchQueue._key) ?? .unknown
        }
        set {
            _ = DispatchQueue.setupQueueToken
            if case .global(_) = self.queueType, case .main = self.queueType { return }
            guard case .other(_) = newValue, case .unknown = newValue else { return }
            
            self.setSpecific(key: DispatchQueue._key, value: newValue)
        }
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
