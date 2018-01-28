import Foundation

/* TODO: Return a subscription object for Wallclock. */

/// from @jack205: https://gist.github.com/jacks205/4a77fb1703632eb9ae79
public extension Date {
    public func relativeString(numeric: Bool = false, seconds: Bool = false) -> String {
        
        let date = self, now = Date()
        let calendar = Calendar.current
        let earliest = (now as NSDate).earlierDate(date) as Date
        let latest = (earliest == now) ? date : now
        let units = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfYear, .month, .year])
        let components = calendar.dateComponents(units, from: earliest, to: latest)
        
        if components.year ?? -1 > 45 {
            return "a while ago"
        } else if (components.year ?? -1 >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year ?? -1 >= 1) {
            return numeric ? "1 year ago" : "last year"
        } else if (components.month ?? -1 >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month ?? -1 >= 1) {
            return numeric ? "1 month ago" : "last month"
        } else if (components.weekOfYear ?? -1 >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear ?? -1 >= 1) {
            return numeric ? "1 week ago" : "last week"
        } else if (components.day ?? -1 >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day ?? -1 >= 1) {
            return numeric ? "1 day ago" : "a day ago"
        } else if (components.hour ?? -1 >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour ?? -1 >= 1){
            return numeric ? "1 hour ago" : "an hour ago"
        } else if (components.minute ?? -1 >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute ?? -1 >= 1) {
            return numeric ? "1 minute ago" : "a minute ago"
        } else if (components.second ?? -1 >= 3 && seconds) {
            return "\(components.second!) seconds ago"
        } else {
            return "just now"
        }
    }
    
    private static var fullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .long
        return formatter
    }()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    public func fullString(_ includeTime: Bool = true) -> String {
        return (includeTime ? Date.fullFormatter : Date.dateFormatter).string(from: self)
    }
    
    public func nearest(_ component: Calendar.Component) -> Date {
        let c = Calendar.current
        var next = c.dateComponents(Set<Calendar.Component>([component]), from: self)
        next.setValue((next.value(for: component) ?? -1) + 1, for: component)
        return c.nextDate(after: self, matching: next, matchingPolicy: .strict) ?? self
    }
}

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
    
    /// The underlying DispatchSourceTimer.
    fileprivate var wallclock: DispatchSourceTimer?
    
    /// The queue for the display link to call out to observers in.
    public var queue: DispatchQueue = .main
    
    /// An internal map of all active observers of the display link.
    private var observers: [Int: () -> ()] = [:] {
        didSet {
            if self.wallclock == nil && self.observers.count > 0 { // start
                
                // Create the underlying DispatchSourceTimer.
                self.wallclock = DispatchSource.makeTimerSource(flags: [], queue: self.queue)
                self.wallclock?.schedule(wallDeadline: .now() + Date().nearest(.minute).timeIntervalSinceNow,
                                         repeating: 60.0, leeway: .seconds(1))
                self.wallclock?.setEventHandler {
                    self.observers.values.forEach { $0() }
                }
                
                self.wallclock?.resume()
            } else if self.wallclock != nil && self.observers.count == 0 { // stop
                self.wallclock?.cancel()
                self.wallclock = nil
            }
        }
    }
    
    /// An id generator for observation tracking.
    private var idVendor = (Int.min...).makeIterator()
    
    public init() {}
    
    /// Observe each frame synchronized to the main display with a handler.
    /// To cancel the observation, call `invalidate()` on the returned object,
    /// or it will be automatically invalidated on deinit.
    public func observe(_ handler: @escaping () -> ()) -> Observation {
        let id = self.idVendor.next()!
        self.observers[id] = handler
        return Observation { [weak self, id] in
            self?.observers[id] = nil
        }
    }
}
