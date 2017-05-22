import AppKit

@IBDesignable
public class Switch: NSControl {
    
    private lazy var backgroundLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        return layer
    }()
    
    private lazy var knobContainer: CALayer = {
        let layer = CALayer()
        layer.frame = self.calculateFrame(forState: false, pressed: false)
        return layer
    }()
    
    private lazy var knobLayer: CALayer = {
        let layer = CALayer()
        layer.autoresizingMask = [.layerWidthSizable]
        layer.backgroundColor = NSColor.white.cgColor
        layer.frame = self.knobContainer.bounds
        layer.cornerRadius = ceil(self.knobContainer.bounds.height / 2)
        return layer
    }()
    
    private lazy var knobSmallStroke: CALayer = {
        let layer = CALayer()
        layer.frame = self.knobContainer.bounds.insetBy(dx: -1, dy: -1)
        layer.autoresizingMask = [.layerWidthSizable]
        layer.backgroundColor = NSColor.black.withAlphaComponent(0.06).cgColor
        layer.cornerRadius = ceil(layer.bounds.height / 2)
        return layer
    }()
    
    private lazy var knobSmallShadow: CALayer = {
        let layer = CALayer()
        layer.frame = self.knobContainer.bounds.insetBy(dx: 2, dy: 2)
        layer.autoresizingMask = [.layerWidthSizable]
        layer.cornerRadius = ceil(layer.bounds.height / 2)
        layer.backgroundColor = NSColor.red.cgColor
        layer.shadowColor = NSColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3 * self.scaleFactor)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 2.0 * self.scaleFactor
        return layer
    }()
    
    private var scaleFactor: CGFloat {
        return ceil(self.frame.size.height / 62) // Hardcoded base height
    }
    
    @IBInspectable
    public var tintColor: NSColor = NSColor(deviceRed: 76/255, green: 217/255, blue: 100/255, alpha: 1.0) {
        didSet {
            self.needsDisplay = true
        }
    }
    
    @IBInspectable
    public var rimColor: NSColor = NSColor.black.withAlphaComponent(0.09) {
        didSet {
            self.needsDisplay = true
        }
    }
    
    @IBInspectable
    public var on: Bool = false {
        didSet {
            self.needsDisplay = true
        }
    }
    
    private var pressed = false {
        didSet {
            self.isHighlighted = self.pressed
            self.needsDisplay = true
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        self.layer?.addSublayer(self.backgroundLayer)
        self.knobContainer.addSublayer(self.knobLayer)
        self.knobContainer.insertSublayer(self.knobSmallStroke, below: self.knobLayer)
        self.knobContainer.insertSublayer(self.knobSmallShadow, below: self.knobSmallStroke)
        self.layer?.addSublayer(self.knobContainer)
    }
    
    public override func updateLayer() {
        self.backgroundLayer.cornerRadius = ceil(self.bounds.height / 2)
        self.backgroundLayer.borderWidth = (self.on || self.pressed) ? ceil(self.bounds.height) : 3.0 * self.scaleFactor
        self.backgroundLayer.borderColor = self.on ? self.tintColor.cgColor : self.rimColor.cgColor
        
        self.knobContainer.frame = self.calculateFrame(forState: self.on, pressed: pressed)
        self.knobLayer.frame = self.knobContainer.bounds
        self.knobLayer.cornerRadius = ceil(self.knobContainer.bounds.height / 2)
        self.knobSmallStroke.frame = self.knobContainer.bounds.insetBy(dx: -1, dy: -1)
        self.knobSmallShadow.frame = self.knobContainer.bounds.insetBy(dx: 2, dy: 2)
        
        self.knobSmallStroke.cornerRadius = ceil(self.knobSmallStroke.bounds.height / 2)
        self.knobSmallShadow.shadowOffset = CGSize(width: 0, height: -3 * self.scaleFactor)
        self.knobSmallShadow.shadowRadius = 2.0 * self.scaleFactor
    }
    
    public override var allowsVibrancy: Bool {
        return false
    }
    
    public override var wantsUpdateLayer: Bool {
        return true
    }
    
    public override var intrinsicContentSize: NSSize {
        return CGSize(width: 52, height: 32)
    }
    
    public override func sizeToFit() {
        var f = self.frame
        f.size = self.intrinsicContentSize
        self.frame = f
    }
    
    public override func mouseDown(with event: NSEvent) {
        self.pressed = true
    }
    
    public override func mouseUp(with event: NSEvent) {
        self.pressed = false
        
        // Only continue toggling if the mouseUp was _in_ the view.
        let point = self.convert(event.locationInWindow, from: nil)
        if self.mouse(point, in: self.bounds) {
            self.on = !self.on
            
            // Fire the action only on user interaction.
            self.sendAction(self.action, to: self.target)
        }
    }
    
    private func calculateFrame(forState: Bool, pressed: Bool) -> CGRect {
        let borderWidth = 3.0 * self.scaleFactor
        var origin: CGPoint
        var size: CGSize {
            if pressed {
                return CGSize(
                    width: ceil(bounds.width * 0.69) - (2 * borderWidth),
                    height: bounds.height - (2 * borderWidth)
                )
            }
            return CGSize(width: bounds.height - (2 * borderWidth), height: bounds.height - (2 * borderWidth))
        }
        
        if on {
            origin = CGPoint(x: bounds.width - size.width - borderWidth, y: borderWidth)
        } else {
            origin = CGPoint(x: borderWidth, y: borderWidth)
        }
        return CGRect(origin: origin, size: size)
    }
}
