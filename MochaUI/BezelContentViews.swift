import Cocoa

public class BezelImageView: NSView {
    
    private lazy var imageView: NSImageView = {
        let v = NSImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.imageScaling = .scaleProportionallyUpOrDown
        return v
    }()
    
    public var image: NSImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }
    
    //
    //
    //
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    public func setup() {
        self.addSubview(self.imageView)
        
        self.leftAnchor.constraint(equalTo: self.imageView.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: self.imageView.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
    }
}

public class BezelImageTextView: NSView {
    
    private lazy var imageView: NSImageView = {
        let v = NSImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.imageScaling = .scaleProportionallyUpOrDown
        return v
    }()
    
    private lazy var textField: NSTextField = {
        let v = NSTextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = NSFont.systemFont(ofSize: 16.0, weight: .regular)
        v.isSelectable = false
        v.isEnabled = true
        v.isBezeled = false
        v.isBordered = false
        v.drawsBackground = false
        v.isContinuous = false
        v.isEditable = false
        v.textColor = NSColor.labelColor
        v.lineBreakMode = .byTruncatingTail
        v.alignment = .center
        // TODO: set hugging and resistance priorities
        return v
    }()
    
    public var image: NSImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }
    
    public var text: String? {
        get { return self.textField.stringValue }
        set { self.textField.stringValue = newValue ?? "" }
    }
    
    //
    //
    //
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    public func setup() {
        self.addSubview(self.imageView)
        self.addSubview(self.textField)
        
        self.leftAnchor.constraint(equalTo: self.imageView.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: self.imageView.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        
        self.leftAnchor.constraint(equalTo: self.textField.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: self.textField.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: self.textField.bottomAnchor).isActive = true
        
        self.imageView.bottomAnchor.constraint(equalTo: self.textField.topAnchor, constant: 10).isActive = true
    }
}

public class BezelImageIndicatorView: NSView {
    
    private lazy var imageView: NSImageView = {
        let v = NSImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.imageScaling = .scaleProportionallyUpOrDown
        return v
    }()
    
    private lazy var indicator: VolumeIndicator = {
        let v = VolumeIndicator()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    public var image: NSImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }
    
    public var level: Int {
        get { return self.indicator.level }
        set { self.indicator.level = newValue }
    }
    
    //
    //
    //
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    public func setup() {
        self.addSubview(self.imageView)
        self.addSubview(self.indicator)
        
        self.leftAnchor.constraint(equalTo: self.imageView.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: self.imageView.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        
        self.leftAnchor.constraint(equalTo: self.indicator.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: self.indicator.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: self.indicator.bottomAnchor).isActive = true
        
        self.indicator.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        self.indicator.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10).isActive = true
    }
}
