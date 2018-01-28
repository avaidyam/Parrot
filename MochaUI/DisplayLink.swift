import Dispatch
import CoreVideo
import class Mocha.Observation

/* TODO: Use CVDisplayLinkIsRunning() instead of re-initializing the display link each time. */

/* TODO:
 public struct Frame: Equatable {
     var timestamp: Double = 0.0
     var duration: Double = 0.0
 
     public static func ==(lhs: DisplayLink.Frame, rhs: DisplayLink.Frame) -> Bool {
         return lhs.timestamp == rhs.timestamp && lhs.duration == rhs.duration
     }
 }
 */

open class DisplayLink {
    
    /// The internal CVDisplayLink to control.
    private var displayLink: CVDisplayLink? = nil
    
    /// The queue for the display link to call out to observers in.
    public var queue: DispatchQueue = .main
    
    /// An internal map of all active observers of the display link.
    private var observers: [Int: (Double) -> ()] = [:] {
        didSet {
            if self.displayLink == nil && self.observers.count > 0 { // start
                self.createDisplayLink()
            } else if self.displayLink != nil && self.observers.count == 0 { // stop
                self.stopDisplayLink()
            }
        }
    }
    
    /// An id generator for observation tracking.
    private var idVendor = (Int.min...).makeIterator()
    
    /// Observe each frame synchronized to the main display with a handler.
    /// To cancel the observation, call `invalidate()` on the returned object,
    /// or it will be automatically invalidated on deinit.
    public func observe(_ handler: @escaping (Double) -> ()) -> Observation {
        let id = self.idVendor.next()!
        self.observers[id] = handler
        return Observation { [weak self, id] in
            self?.observers[id] = nil
        }
    }
    
    ///
    private func createDisplayLink() {
        let error = CVDisplayLinkCreateWithActiveCGDisplays(&self.displayLink)
        guard let dLink = self.displayLink, kCVReturnSuccess == error else {
            self.displayLink = nil
            print("DisplayLink created with error: \(error)"); return
        }
        
        /// nowTime is the current frame time, and outputTime is when the frame will be displayed.
        CVDisplayLinkSetOutputHandler(dLink) { (_, nowTime, outputTime, _, _) in
            let fps = (outputTime.pointee.rateScalar * Double(outputTime.pointee.videoTimeScale) / Double(outputTime.pointee.videoRefreshPeriod))
            self.queue.async { self.observers.values.forEach { $0(fps) } }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(dLink)
    }
    
    ///
    private func stopDisplayLink() {
        if let v = self.displayLink {
            CVDisplayLinkStop(v)
            self.displayLink = nil
        }
    }
}
