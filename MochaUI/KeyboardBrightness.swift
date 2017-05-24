import AppKit
import IOKit

/* TODO: Never tested on non-MacBooks! */

public extension NSScreen {
    
    /// A refrence to the keyboard backlight brightness commonly on MacBooks.
    /// If animating, use the `KeyboardBrightnessAnimation` class.
    public static var keyboardBrightness: Float {
        get {
            let inputCount: UInt64 = 1
            let inputValues: [UInt64] = [0]
            
            var outputCount: UInt32 = 1
            let outputValues: [UInt64] = []
            var out_brightness: UInt32 = 0
            
            let ptr = UnsafeMutablePointer(mutating: outputValues)
            let kr = IOConnectCallScalarMethod(io.port, 1 /*kGetLEDBrightnessID*/,
                inputValues, UInt32(inputCount), ptr, &outputCount)
            let arrary = Array(UnsafeBufferPointer(start: ptr, count: Int(outputCount)))
            out_brightness = UInt32(arrary[0])
            
            if kr != KERN_SUCCESS {
                return -1
            }
            return Float(out_brightness) / 0xfff
        }
        set {
            let inputCount: UInt64 = 2
            let in_unknown: UInt64 = 0
            let in_brightness: UInt64 = UInt64(newValue * 0xfff)
            let inputValues: [UInt64] = [in_unknown, in_brightness]
            
            var outputCount: UInt32 = 1
            var outputValues: [UInt64] = []
            var _: UInt32 = 0
            
            let kr = IOConnectCallScalarMethod(io.port, 2 /*kSetLEDBrightnessID*/,
                inputValues, UInt32(inputCount), &outputValues, &outputCount)
            
            if kr != KERN_SUCCESS {
                return
            }
        }
    }
}

/// Since we're not animating CALayers or anything, we need to do this the old-fashioned
/// way and use an NSAnimation. Set the `blinkCount` and `duration` to ramp the 
/// keyboard brightness in and out in a blinking fashion. Adjusting other parameters
/// is undefined. The keyboard brightness will be reset at the end of animation.
public class KeyboardBrightnessAnimation: NSAnimation {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.frameRate = 60.0
        self.animationBlockingMode = .nonblocking
        self.animationCurve = .linear
    }
    public override init(duration: TimeInterval, animationCurve: NSAnimationCurve) {
        super.init(duration: duration, animationCurve: .linear)
        self.frameRate = 60.0
        self.animationBlockingMode = .nonblocking
    }
    public convenience init(duration: TimeInterval = 1.0, blinkCount: Int = 3) {
        self.init(duration: duration, animationCurve: .linear)
        self.blinkCount = 3
    }
    
    public var blinkCount = 3
    private var initialValue: Float = 0
    
    public override var currentProgress: NSAnimationProgress {
        didSet {
            let stage = self.currentProgress * Float(self.blinkCount) * 2
            let progress = stage.truncatingRemainder(dividingBy: 1)
            let ramp: Float = Int(stage) % 2 == 0 ? 0 : 1
            //print("ANIM: | \(Int(stage)) | \(progress) | \(ramp) |")
            
            switch Int(stage) {
            case 0...(self.blinkCount * 2): // alternating ramp
                NSScreen.keyboardBrightness = abs((ramp) - (progress))
            default: // we're done
                NSScreen.keyboardBrightness = self.initialValue
            }
        }
    }
    
    public override func start() {
        self.initialValue = NSScreen.keyboardBrightness
        super.start()
    }
    
    public override func stop() {
        NSScreen.keyboardBrightness = self.initialValue
        super.stop()
    }
}

/// Grab the AppleLMUController service for keyboard brightness.
fileprivate let io = try! IOServicePort(forService: "AppleLMUController")

/// A small wrapper around an IOServicePort to use above.
fileprivate class IOServicePort {
    fileprivate private(set) var port: io_connect_t = 0
    
    fileprivate init(forService s: String) throws {
        let serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(s))
        if serviceObject == 0 {
            throw NSError()
        }
        
        let kr = IOServiceOpen(serviceObject, mach_task_self_, 0, &self.port)
        IOObjectRelease(serviceObject)
        if kr != KERN_SUCCESS {
            throw NSError()
        }
    }
}
