import Cocoa
import QuartzCore

/* TODO: Track NSButton.Type values and fix LayerButton.State. */
/* TODO: Animate title<->alternateTitle changes. */
/* TODO: Respect {alternate}attributedTitle and isSpringLoaded. */
/* TODO: Track momentary, State.mixed, and NSImageScaling/Position. */
/* TODO: Support non-Template images (basically remove the mask layer). */
/* TODO: Support focus rings. */
/* TODO: Add scale transformation on selection. */

public class LayerButton: NSButton, CALayerDelegate {
    
    // pressed, pulsed, deeplyPressed, inactive, active, disabled, drag, rollover
    /*
     public struct State: OptionSet {
     public let rawValue: Int
     public init(rawValue: Int) { self.rawValue = rawValue }
     
     public static let none = State(rawValue: 0 << 0)
     public static let hover = State(rawValue: 1 << 0)
     public static let highlighted = State(rawValue: 0 << 1)
     public static let selected = State(rawValue: 1 << 1)
     public static let disabled = State(rawValue: 1 << 1) // ???
     public static let main = State(rawValue: 0 << 2)
     public static let key = State(rawValue: 1 << 2)
     public static let aqua = State(rawValue: 0 << 3)
     public static let graphite = State(rawValue: 1 << 3)
     public static let vibrant = State(rawValue: 1 << 4)
     public static let highContrast = State(rawValue: 1 << 5)
     }
     */
    
    public struct Properties {
        private static var activeShadow: NSShadow = {
            let s = NSShadow() // default shadowColor = black + 0.33 alpha
            s.shadowOffset = NSSize(width: 0, height: 5)
            s.shadowBlurRadius = 10
            return s
        }()
        
        public var cornerRadius: CGFloat
        public var borderWidth: CGFloat
        public var borderColor: NSColor
        public var shadow: NSShadow?
        public var bezelColor: NSColor
        public var rimOpacity: Float
        public var iconColor: NSColor
        public var textColor: NSColor
        public var duration: TimeInterval
        
        public init(cornerRadius: CGFloat = 0.0, borderWidth: CGFloat = 0.0, borderColor: NSColor = .clear,
                    shadow: NSShadow? = nil, bezelColor: NSColor = .clear, rimOpacity: Float = 0.0,
                    iconColor: NSColor = .clear, textColor: NSColor = .clear, duration: TimeInterval = 0.0)
        {
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.shadow = shadow
            self.bezelColor = bezelColor
            self.rimOpacity = rimOpacity
            self.iconColor = iconColor
            self.textColor = textColor
            self.duration = duration
        }
        
        public static let inactive = Properties(cornerRadius: 4.0, bezelColor: .darkGray,
                                                rimOpacity: 0.25, iconColor: .white,
                                                textColor: .white, duration: 0.5)
        public static let active = Properties(cornerRadius: 4.0, bezelColor: .white,
                                              rimOpacity: 0.25, iconColor: .darkGray,
                                              textColor: .darkGray, duration: 0.1)
    }
    
    private var containerLayer = CALayer()
    private var titleLayer = CATextLayer()
    private var iconLayer = CALayer()
    private var rimLayer = CALayer()
    
    public private(set) var isHovered = false {
        didSet { self.needsDisplay = true }
    }
    public var activeOnHighlight = true {
        didSet { self.needsDisplay = true }
    }
    public var inactiveProperties: Properties = .inactive {
        didSet { self.needsDisplay = true }
    }
    public var activeProperties: Properties = .active {
        didSet { self.needsDisplay = true }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    public override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }
    private func setup() {
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        self.layer?.masksToBounds = false
        self.containerLayer.masksToBounds = false
        self.titleLayer.masksToBounds = false
        self.iconLayer.masksToBounds = true
        self.rimLayer.masksToBounds = false
        
        self.iconLayer.mask = CALayer()
        self.iconLayer.mask?.contentsGravity = kCAGravityResizeAspect
        self.titleLayer.alignmentMode = kCAAlignmentCenter
        self.rimLayer.borderColor = .black
        self.rimLayer.borderWidth = 0.5
        
        self.layer?.addSublayer(self.containerLayer)
        self.containerLayer.addSublayer(self.iconLayer)
        self.containerLayer.addSublayer(self.titleLayer)
        self.layer?.addSublayer(self.rimLayer)
        
        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override open func layout() {
        super.layout()
        self.subviews.forEach { $0.removeFromSuperview() } // remove NSButtonCell's views
        
        let imageRect = (self.cell?.value(forKey: "_imageView") as? NSView)?.frame ?? .zero
        var titleRect = (self.cell?.value(forKey: "_titleTextField") as? NSView)?.frame ?? .zero
        titleRect.origin.y += 1 // CATextLayer baseline is +1.5px compared to NSTextLayer.
        
        let props = (self.isHighlighted) ? self.activeProperties : self.inactiveProperties
        let initState = self.containerLayer.frame == .zero // we just initialized
        if !initState {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.allowsImplicitAnimation = true
            NSAnimationContext.current.duration = props.duration
        }
        
        self.containerLayer.frame = self.layer?.bounds ?? .zero
        self.iconLayer.frame = imageRect
        self.iconLayer.mask?.frame = self.iconLayer.bounds
        self.titleLayer.frame = titleRect
        self.rimLayer.frame = self.layer?.bounds.insetBy(dx: -0.5, dy: -0.5) ?? .zero
        if !initState {
            NSAnimationContext.endGrouping()
        }
    }
    
    public override var allowsVibrancy: Bool { return false }
    public override var wantsUpdateLayer: Bool { return true }
    public override func updateLayer() {
        self.containerLayer.contents = nil // somehow this gets set by NSButtonCell?
        let props = (self.isHighlighted) ? self.activeProperties : self.inactiveProperties
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.allowsImplicitAnimation = true
        NSAnimationContext.current.duration = props.duration
        
        self.titleLayer.font = self.font
        self.titleLayer.fontSize = self.font?.pointSize ?? 0.0
        self.titleLayer.string = self.isHighlighted && self.alternateTitle != "" ? self.alternateTitle : self.title
        self.iconLayer.mask?.contents = self.isHighlighted && self.alternateImage != nil ? self.alternateImage : self.image
        
        self.layer?.cornerRadius = props.cornerRadius
        self.layer?.borderWidth = props.borderWidth
        self.layer?.borderColor = props.borderColor.cgColor
        self.layer?.backgroundColor = props.bezelColor.cgColor
        
        self.rimLayer.opacity = props.rimOpacity
        self.rimLayer.cornerRadius = props.cornerRadius
        
        self.shadow = props.shadow
        
        self.iconLayer.backgroundColor = props.iconColor.cgColor
        self.titleLayer.foregroundColor = props.textColor.cgColor
        NSAnimationContext.endGrouping()
    }
    
    public override func mouseEntered(with event: NSEvent) {
        self.isHovered = true
    }
    
    public override func mouseExited(with event: NSEvent) {
        self.isHovered = false
    }
    
    public override var focusRingMaskBounds: NSRect {
        return self.bounds
    }
    
    public override func drawFocusRingMask() {
        let props = (self.isHighlighted) ? self.activeProperties : self.inactiveProperties
        let path = NSBezierPath(roundedRect: self.bounds, xRadius: props.cornerRadius, yRadius: props.cornerRadius)
        path.fill()
    }
    
    public override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        guard let scale = self.window?.backingScaleFactor else { return }
        self.layer?.contentsScale = scale
        self.containerLayer.contentsScale = scale
        self.titleLayer.contentsScale = scale
        self.iconLayer.contentsScale = scale
    }
}

