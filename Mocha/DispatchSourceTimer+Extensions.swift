import Foundation
import Dispatch

/* TODO: Return a subscription object instead here. */

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

open class Wallclock {
    public typealias Target = (target: Any, id: UUID, action: () -> ())
    
    // The underlying DispatchSourceTimer.
    fileprivate var wallclock: DispatchSourceTimer?
    
    // The targets to fire when the DispatchSourceTimer fires.
    fileprivate var targets = [UUID: Target]()
    
    public init() {}
    
    //
    open func add(target: Target) {
        self.targets[target.id] = target
        if self.wallclock == nil && self.targets.count > 0 {
            
            // Create the underlying DispatchSourceTimer.
            self.wallclock = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            self.wallclock?.schedule(wallDeadline: .now() + Date().nearest(.minute).timeIntervalSinceNow, repeating: 60.0, leeway: .seconds(3))
            self.wallclock?.setEventHandler {
                self.targets.values.forEach { $0.action() }
            }
            self.wallclock?.resume()
        }
    }
    
    //
    open func remove(target: Target) {
        self.targets[target.id] = nil
        if self.wallclock != nil && self.targets.count == 0 {
            
            // Destroy the underlying DispatchSourceTimer.
            self.wallclock?.cancel()
            self.wallclock = nil
        }
    }
}
