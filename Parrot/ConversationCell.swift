import MochaUI
import protocol ParrotServiceExtension.Message
import protocol ParrotServiceExtension.Conversation

// A visual representation of a Conversation in a ListView.
public class ConversationCell: NSCollectionViewItem, DroppableViewDelegate {
    
    private static var wallclock = Wallclock() // global
    private var timeObserver: Any? = nil
    
    private lazy var effectView: NSVisualEffectView = {
        let v = NSVisualEffectView().modernize(wantsLayer: true)
        v.material = .selection
        v.blendingMode = .behindWindow
        v.state = .followsWindowActiveState
        return v
    }()
    
    private lazy var photoView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var badgeLabel: NSTextField = {
        let v = NSTextField(labelWithString: " ").modernize(wantsLayer: true)
        v.cornerRadius = 4.0
        v.layer?.backgroundColor = .ns(.selectedMenuItemColor)
        v.textColor = .white
        v.font = .systemFont(ofSize: 9.0, weight: .medium)
        v.usesSingleLineMode = true
        v.lineBreakMode = .byClipping
        return v
    }()
    
    private lazy var nameLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = .labelColor
        v.font = .systemFont(ofSize: 13.0, weight: .semibold)
        v.lineBreakMode = .byTruncatingTail
        v.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
        return v
    }()
    
    private lazy var textLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = .secondaryLabelColor
        v.font = .systemFont(ofSize: 11.0)
        v.usesSingleLineMode = false
        v.lineBreakMode = .byWordWrapping
        return v
    }()
    
    private lazy var timeLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = .tertiaryLabelColor
        v.font = .systemFont(ofSize: 11.0, weight: .light)
        v.alignment = .right
        
        v.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        return v
    }()
    
    private lazy var dropZone: DroppableView = {
        let v = DroppableView().modernize()
        v.acceptedTypes = [.of(kUTTypeImage)]
        v.operation = .copy
        v.allowsSpringLoading = true
        v.delegate = self
        return v
    }()
    
    private var visualSubscriptions: [Any] = []
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.view.add(subviews: self.effectView, self.photoView, self.nameLabel, self.timeLabel, self.textLabel, self.dropZone, self.badgeLabel) {
            self.edgeAnchors == self.effectView.edgeAnchors
            
            self.photoView.leftAnchor == self.view.leftAnchor + 8
            self.photoView.centerYAnchor == self.view.centerYAnchor
            self.photoView.widthAnchor == 48
            self.photoView.heightAnchor == 48
            self.photoView.rightAnchor == self.nameLabel.leftAnchor - 8
            self.photoView.rightAnchor == self.textLabel.leftAnchor - 8
            self.nameLabel.topAnchor == self.view.topAnchor + 8
            self.nameLabel.rightAnchor == self.timeLabel.leftAnchor - 4
            self.nameLabel.bottomAnchor == self.textLabel.topAnchor - 4
            self.nameLabel.centerYAnchor == self.timeLabel.centerYAnchor
            self.timeLabel.topAnchor == self.view.topAnchor + 8
            self.timeLabel.rightAnchor == self.view.rightAnchor - 8
            self.timeLabel.bottomAnchor == self.textLabel.topAnchor - 4
            self.textLabel.rightAnchor == self.view.rightAnchor - 8
            self.textLabel.bottomAnchor == self.view.bottomAnchor - 8
            self.dropZone.leftAnchor == self.view.leftAnchor
            self.dropZone.rightAnchor == self.view.rightAnchor
            self.dropZone.topAnchor == self.view.topAnchor
            self.dropZone.bottomAnchor == self.view.bottomAnchor
            
            self.photoView.centerXAnchor == self.badgeLabel.centerXAnchor
            self.photoView.bottomAnchor == self.badgeLabel.bottomAnchor
            self.photoView.edgeAnchors <= self.badgeLabel.edgeAnchors
        }
        
        self.photoView.addTrackingArea(NSTrackingArea(rect: self.photoView.bounds,
                                                      options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect],
                                                      owner: self, userInfo: ["item": "photo"]))
        self.view.addTrackingArea(NSTrackingArea(rect: self.view.bounds,
                                                 options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect],
                                                 owner: self, userInfo: ["item": "cell"]))
        
        // Set up dark/light notifications.
        self.visualSubscriptions = [
            Settings.observe(\.effectiveInterfaceStyle, options: [.initial, .new]) { _, _ in
                let appearance = InterfaceStyle.current.appearance()
                self.effectView.appearance = appearance == .light ? .dark : .light
            },
            Settings.observe(\.vibrancyStyle, options: [.initial, .new]) { _, _ in
                self.effectView.state = VibrancyStyle.current.state()
            },
        ]
    }
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var representedObject: Any? {
		didSet {
            guard let conversation = self.representedObject as? Conversation else { return }
			
			let messageSender = (conversation.eventStream.last as? Message)?.sender.identifier ?? ""
			let selfSender = conversation.participants.filter { $0.me }.first?.identifier
            
            // Get the first (last) participant to have sent a message in the conv:
            let firstParticipant = conversation.eventStream.lazy.compactMap { ($0 as? Message)?.sender }.filter { !$0.me }.last
                                    ?? (conversation.participants.filter { !$0.me }.first)
            
            self.photoView.image = firstParticipant?.image ?? NSImage(monogramOfSize: NSSize(width: 64.0, height: 64.0),
                                                                      string: "?", color: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), fontName: .compactRoundedMedium)
            
            // Set the badge if SMS or GROUP conversation:
            if firstParticipant?.locations.contains("OffNetworkPhone") ?? false { // GVoice
                self.badgeLabel.isHidden = false
                self.badgeLabel.stringValue = "SMS"
            } else if conversation.participants.count > 2 { // Group
                self.badgeLabel.isHidden = false
                self.badgeLabel.stringValue = "GROUP"
            } else {
                self.badgeLabel.isHidden = true
                self.badgeLabel.stringValue = ""
            }
            
			self.prefix = conversation.muted ? "◉ " : (messageSender != selfSender ? "↙ " : "↗ ")
			let subtitle = ((conversation.eventStream.last as? Message)?.text ?? "")
			let time = conversation.eventStream.last?.timestamp ?? .origin
			
			self.time = time
			self.nameLabel.stringValue = conversation.name
			self.nameLabel.toolTip = conversation.name
			self.textLabel.stringValue = subtitle
			self.textLabel.toolTip = subtitle
			self.timeLabel.stringValue = self.prefix + time.relativeString()
			self.timeLabel.toolTip = (conversation.muted ? "(muted) " : "") + time.fullString()
            
			if conversation.unreadCount > 0 && (messageSender != selfSender) {
				self.timeLabel.textColor = #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1)
            } else {
                self.timeLabel.textColor = .tertiaryLabelColor
            }
            
            self.view.menu = ConversationDetailsViewController.menu(for: conversation)
            self.visualSelect = self.highlightState != .none || self.isSelected
		}
	}
	
	// Dynamically update the visible timestamp for the Conversation.
	private var time: Date = .origin
	private var prefix = " "
	public func updateTimestamp() {
		self.timeLabel.stringValue = self.prefix + self.time.relativeString()
	}
    
    private var visualSelect: Bool = false {
        didSet {
            let appearance = self.view.effectiveAppearance
            if self.visualSelect {
                //self.layer.backgroundColor = CGColor.ns(.selectedMenuItemColor).copy(alpha: 0.25)
                self.view.appearance = appearance == .light ? .light : .dark
                self.effectView.isEmphasized = false
                self.effectView.isHidden = false
            } else {
                //self.layer.backgroundColor = .ns(.clear)
                self.view.appearance = appearance == .light ? .dark : .light
                self.effectView.isEmphasized = false
                self.effectView.isHidden = true
            }
        }
    }
    
    public override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            self.visualSelect = self.highlightState != .none || self.isSelected
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            self.visualSelect = self.highlightState != .none || self.isSelected
        }
    }
	
	// Return a complete dragging component for this ConversationView.
	// Note that we hide the separator and show it again after snapshot.
	public override var draggingImageComponents: [NSDraggingImageComponent] {
		return [self.view.draggingComponent("Person")]
	}
	
	// Allows the photo view's circle crop to dynamically match size.
	public override func viewDidLayout() {
        self.photoView.clipPath = NSBezierPath(ovalIn: self.photoView.bounds)
        //let p = self.photoView//, b = self.badgeLayer
        //b.frame = NSRect(x: p.frame.minX, y: p.frame.midY, width: p.frame.width / 2,
        //                    height: p.frame.width / 2).insetBy(dx: 4.0, dy: 4.0)
        //p.layer!.cornerRadius = p.frame.width / 2.0
        //b.cornerRadius = b.frame.width / 2.0
	}
    
    public override func viewDidAppear() {
        self.timeObserver = ConversationCell.wallclock.observe(self.updateTimestamp)
    }
    
    public override func viewDidDisappear() {
        self.timeObserver = nil
    }
    
    public func springLoading(phase: DroppableView.SpringLoadingPhase, for: NSDraggingInfo) {
        guard case .activated = phase else { return }
        NSAlert(message: "Sending document...").beginPopover(for: self.view, on: .minY)
    }
    
    public override func mouseEntered(with event: NSEvent) {
        guard let trackingArea = event.trackingArea else { return }
        
        if let item = trackingArea.userInfo?["item"] as? String, item == "cell" {
            
            let v = CATransaction.disableActions()
            CATransaction.setDisableActions(false)
            let layer = self.collectionView?.hoverLayer
            layer?.frame = self.view.bounds.insetBy(dx: 10, dy: 10)
            layer?.opacity = 0.5
            CATransaction.setDisableActions(v)
            
        } else if let item = trackingArea.userInfo?["item"] as? String, item == "photo" {
            guard let conversation = self.representedObject as? Conversation else { return }
            if conversation.participants.count > 2 { // group!
                guard let vc = GroupIndicatorToolTipController.popover.contentViewController
                    as? GroupIndicatorToolTipController else { return }
                
                vc.images = conversation.participants.filter { !$0.me }.map { $0.image }
                GroupIndicatorToolTipController.popover.show(relativeTo: self.photoView.bounds,
                                                             of: self.photoView, preferredEdge: .minY)
            } else {
                guard   let vc = PersonIndicatorToolTipController.popover.contentViewController
                    as? PersonIndicatorToolTipController,
                    let firstParticipant = (conversation.participants.filter { !$0.me }.first)
                    else { return }
                
                var prefix = ""
                switch firstParticipant.reachability {
                case .unavailable: break
                case .phone: prefix = "📱  "
                case .tablet: prefix = "📱  " //💻
                case .desktop: prefix = "🖥  "
                }
                
                _ = vc.view // loadView()
                vc.text?.stringValue = prefix + firstParticipant.fullName
                PersonIndicatorToolTipController.popover.show(relativeTo: self.photoView.bounds,
                                                              of: self.photoView, preferredEdge: .minY)
            }
        }
    }
    
    public override func mouseExited(with event: NSEvent) {
        guard let trackingArea = event.trackingArea else { return }
        
        if let item = trackingArea.userInfo?["item"] as? String, item == "cell" {
            
            let v = CATransaction.disableActions()
            CATransaction.setDisableActions(false)
            let layer = self.collectionView?.hoverLayer
            layer?.frame = self.view.bounds.insetBy(dx: 10, dy: 10)
            layer?.opacity = 0.0
            CATransaction.setDisableActions(v)
            
        } else if let item = trackingArea.userInfo?["item"] as? String, item == "photo" {
            guard let conversation = self.representedObject as? Conversation else { return }
            if conversation.participants.count > 2 { // group!
                GroupIndicatorToolTipController.popover.performClose(nil)
            } else {
                PersonIndicatorToolTipController.popover.performClose(nil)
            }
        }
    }
}


public extension NSCollectionView {
    private static var hoverProp = AssociatedProperty<NSCollectionView, CALayer>(.strong)
    @nonobjc fileprivate var hoverLayer: CALayer? {
        get { return NSCollectionView.hoverProp[self, creating: _newHoverLayer()] }
        set { NSCollectionView.hoverProp[self] = newValue }
    }
    
    private func _newHoverLayer() -> CALayer {
        let c = CALayer()
        c.backgroundColor = .black
        c.opacity = 0.0
        c.cornerRadius = 5.0
        c.zPosition = 200
        self.layer?.addSublayer(c)
        return c
    }
}
