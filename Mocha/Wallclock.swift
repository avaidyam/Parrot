import Foundation
import Dispatch

/* TODO: Return a subscription object instead here. */

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
            self.wallclock?.scheduleRepeating(wallDeadline: .now() + Date().nearestMinute().timeIntervalSinceNow, interval: 60.0, leeway: .seconds(3))
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
