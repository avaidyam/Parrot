import AppKit
import Mocha

/// Recognizes force touch and pressure events on a view.
public class PressureGestureRecognizer: NSGestureRecognizer {
    
    /// Whether the recognizer should begin tracking pressure changes immediately
    /// upon `-mouseDown`. Defaults to `false`.
    public var recognizesOnMouseDown: Bool = false
    
    /// Whether the recognizer should continue tracking pressure changes during
    /// `-tabletPoint`. Defaults to `true`.
    public var recognizesOnTabletPoint: Bool = true
    
    /// See `NSEvent.PressureBehavior` for details.
    /// Note: The `pressureConfiguration` of the recognizer cannot be changed or reset.
    public var behavior: NSEvent.PressureBehavior = .primaryDeepClick
    
    /// See `NSEvent.pressure` for details.
    public private(set) var pressure: Float = 0.0
    
    /// See `NSEvent.stage` for details.
    public private(set) var stage: Int = 0
    
    /// See `NSEvent.stageTransition` for details.
    public private(set) var stageTransition: CGFloat = 0.0
    
    /// The last reported `NSEvent.locationInWindow`.
    private var location: NSPoint = .zero
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delaysPrimaryMouseButtonEvents = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delaysPrimaryMouseButtonEvents = true
    }
    
    public override var pressureConfiguration: NSPressureConfiguration {
        get { return NSPressureConfiguration(pressureBehavior: self.behavior) }
        set { /* noop */ }
    }
    
    public override func location(in view: NSView?) -> NSPoint {
        return view?.convert(self.location, from: nil) ?? self.location
    }
    
    public override func reset() {
        super.reset()
        self.location = .zero
        self.pressure = 0.0
        self.stage = 0
        self.stageTransition = 0.0
    }
    
    public override func mouseDown(with event: NSEvent) {
        if event.associatedEventsMask.contains(.pressure) && !self.recognizesOnMouseDown {
            self.state = .changed
        } else if self.state == .possible {
            self.location = event.locationInWindow
            self.pressure = 0.0
            self.stage = 1
            self.stageTransition = 0.0
            self.state = .began
        }
        super.mouseDown(with: event)
    }
    public override func mouseDragged(with event: NSEvent) {
        self.location = event.locationInWindow
        self.state = .changed
        super.mouseDragged(with: event)
    }
    public override func mouseUp(with event: NSEvent) {
        self.state = .recognized
        super.mouseUp(with: event)
    }
    public override func rightMouseDown(with event: NSEvent) {
        self.state = .failed
        super.rightMouseDown(with: event)
    }
    public override func otherMouseDown(with event: NSEvent) {
        self.state = .failed
        super.otherMouseDown(with: event)
    }
    public override func pressureChange(with event: NSEvent) {
        self.pressure = event.pressure
        self.stage = event.stage
        self.stageTransition = event.stageTransition
        if [.changed, .began, .possible].contains(self.state) {
            self.state = .changed
        }
        super.pressureChange(with: event)
    }
    public override func tabletPoint(with event: NSEvent) {
        guard self.recognizesOnTabletPoint else {
            return super.tabletPoint(with: event)
        }
        
        self.pressure = event.pressure
        self.stage = event.stage
        self.stageTransition = event.stageTransition
        if [.changed, .began, .possible].contains(self.state) {
            self.state = .changed
        }
        super.tabletPoint(with: event)
    }
}
