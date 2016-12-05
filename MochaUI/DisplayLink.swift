import Dispatch
import CoreVideo

open class DisplayLink {
    
    public typealias Target = (target: Any, id: UUID, action: (Double) -> ())
    
    public static var backgroundQueue: DispatchQueue = DispatchQueue(label: "DisplayLinkCallbackQueue", qos: .userInteractive)
    public static var animationQueue: DispatchQueue = DispatchQueue.main
    
    private var displayLink: CVDisplayLink?
    private var targets = [UUID: Target]()
    
    private func createDisplayLink() {
        let error = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard let dLink = displayLink, kCVReturnSuccess == error else {
            NSLog("Display Link created with error: %d", error)
            self.displayLink = nil
            return
        }
        
        /// nowTime is the current frame time, and outputTime is when the frame will be displayed.
        CVDisplayLinkSetOutputHandler(dLink) { (_, nowTime, outputTime, _, _) in
            let fps = (outputTime.pointee.rateScalar * Double(outputTime.pointee.videoTimeScale) / Double(outputTime.pointee.videoRefreshPeriod))
            DisplayLink.animationQueue.async {
                self.targets.values.forEach {
                    $0.action(fps)
                }
            }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(dLink)
    }
    private func stopDisplayLink() {
        if let v = self.displayLink {
            CVDisplayLinkStop(v)
            self.displayLink = nil
        }
    }
    
    open func add(target: Target) {
        self.targets[target.id] = target
        if self.displayLink == nil && self.targets.count > 0 {
            createDisplayLink()
        }
    }
    
    open func remove(target: Target) {
        self.targets[target.id] = nil
        if self.displayLink != nil && self.targets.count == 0 {
            stopDisplayLink()
        }
    }
}
