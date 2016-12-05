import Foundation
import Dispatch

open class Wallclock {
    public typealias Target = (target: Any, id: UUID, action: () -> ())
    
    fileprivate var wallclock: DispatchSourceTimer?
    fileprivate var targets = [UUID: Target]()
    
    public init() {}
    
    open func add(target: Target) {
        self.targets[target.id] = target
        if self.wallclock == nil && self.targets.count > 0 {
            createWallclock()
        }
    }
    
    open func remove(target: Target) {
        self.targets[target.id] = nil
        if self.wallclock != nil && self.targets.count == 0 {
            stopWallclock()
        }
    }
}

fileprivate extension Wallclock {
    
    fileprivate func createWallclock() {
        guard self.wallclock == nil else { return }
        self.wallclock = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        self.wallclock?.scheduleRepeating(wallDeadline: .now() + Date().nearestMinute().timeIntervalSinceNow, interval: 60.0, leeway: .seconds(3))
        self.wallclock?.setEventHandler {
            self.targets.values.forEach { $0.action() }
        }
        self.wallclock?.resume()
    }
    
    fileprivate func stopWallclock() {
        if self.wallclock != nil {
            self.wallclock?.cancel()
            self.wallclock = nil
        }
    }
}
