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
    
    public enum AuxType: Equatable {
        case main
        case global(DispatchQoS.QoSClass)
        case other(String)
        case unknown
        
        public static func ==(lhs: AuxType, rhs: AuxType) -> Bool {
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
    
    private static let _key = DispatchSpecificKey<DispatchQueue.AuxType>()
    public static func setupQueues() {
        DispatchQueue.main.async {
            DispatchQueue.main.setSpecific(key: _key, value: .main)
            DispatchQueue.global(qos: .background).setSpecific(key: _key, value: .global(.background))
            DispatchQueue.global(qos: .default).setSpecific(key: _key, value: .global(.default))
            DispatchQueue.global(qos: .userInitiated).setSpecific(key: _key, value: .global(.userInitiated))
            DispatchQueue.global(qos: .userInteractive).setSpecific(key: _key, value: .global(.userInteractive))
            DispatchQueue.global(qos: .utility).setSpecific(key: _key, value: .global(.utility))
        }
    }
    
    public static var current: AuxType {
        return DispatchQueue.getSpecific(key: DispatchQueue._key) ?? .unknown
    }
    
    public var auxType: AuxType {
        get { return self.getSpecific(key: DispatchQueue._key) ?? .unknown }
        set {
            if case .global(_) = self.auxType, case .main = self.auxType { return }
            self.setSpecific(key: DispatchQueue._key, value: newValue)
        }
    }
}
