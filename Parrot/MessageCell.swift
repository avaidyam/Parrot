import MochaUI
import AddressBook
import protocol ParrotServiceExtension.Message

/* TODO: Use NSPanGestureRecognizer or Force Touch to expand links. */

public class MessageCell: NSCollectionViewItem, NSTextViewDelegate {
    
    private var token: Subscription? = nil
    
    private lazy var photoView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var textLabel: ExtendedTextView = {
        let v = ExtendedTextView().modernize(wantsLayer: true)
        v.isEditable = false
        v.isSelectable = true
        v.drawsBackground = false
        v.backgroundColor = .clear
        v.textColor = .labelColor
        v.textContainerInset = NSSize(width: 4, height: 4)
        
        //v.setContentCompressionResistancePriority(1000, for: .vertical)
        //v.setContentHuggingPriority(1, for: .vertical)
        
        v.isAutomaticDataDetectionEnabled = true
        v.isAutomaticLinkDetectionEnabled = true
        v.isAutomaticTextReplacementEnabled = true
        
        v.delegate = self
        return v
    }()
    
	private var orientation: NSUserInterfaceLayoutDirection = .rightToLeft
    private var mask = CAShapeLayer()
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.token = AutoSubscription(from: nil, kind: .conversationAppearanceUpdated) { _ in
            self.setColors()
        }
        
        self.view.add(subviews: self.photoView, self.textLabel) {
            self.photoView.leftAnchor == self.view.leftAnchor + 8.0
            self.photoView.bottomAnchor == self.view.bottomAnchor - 4.0
            self.photoView.heightAnchor == 24.0
            self.photoView.widthAnchor == 24.0
            self.textLabel.leftAnchor == self.photoView.rightAnchor + 8.0
            self.textLabel.rightAnchor == self.view.rightAnchor - 8.0
            self.textLabel.topAnchor == self.view.topAnchor + 4.0
            self.textLabel.bottomAnchor == self.view.bottomAnchor - 4.0
        }
        
        // So, since the photoView can be hidden (height = 0), we should manually
        // declare the height minimum constraint here.
        self.textLabel.heightAnchor >= 24.0 /* photoView.height */
    }
    
    deinit {
        self.token = nil
    }
    
	/// Upon assignment of the represented object, configure the subview contents.
	public override var representedObject: Any? {
        didSet {
            guard let b = self.representedObject as? EventBundle else { return }
            guard let o = b.current as? Message else { return }
            let prev = b.previous as? Message
			
			let user = o.sender
            self.orientation = o.sender.me ? .rightToLeft : .leftToRight // FIXME
			//self.color = o.color
			self.textLabel.string = o.text ?? ""
			self.textLabel.toolTip = "\((o.timestamp /*?? .origin*/).fullString())"
			self.photoView.image = user.image
			//self.photoView?.toolTip = o.caption
            
            // Hide your own icon and hide the icon of a repeating message.
            self.photoView.isHidden = /*(o.sender.me ?? false) || */(prev?.sender.identifier == o.sender.identifier)
            //self.textLabel.alignment = (o.sender.me ?? false) ? .right : .left
            
            // Enable automatic links and data detectors.
            self.updateTextStyles()
            self.textLabel.isEditable = true
            self.textLabel.checkTextInDocument(nil)
            self.textLabel.isEditable = false
            self.textLabel.layer?.mask = self.mask
            
            let text = self.textLabel
            let appearance: NSAppearance = self.view.appearance ?? NSAppearance.current
            text.textColor = .labelColor
            self.setColors()
            
            // NSTextView doesn't automatically change its text color when the
            // backing view's appearance changes, so we need to set it each time.
            // In addition, make sure links aren't blue as usual.
            // Also, expand the text size if it's purely emoji.
            text.font = NSFont.systemFont(ofSize: 12.0 * (text.string.isEmoji ? 4 : 1))
            text.invalidateIntrinsicContentSize()
            
            text.typingAttributes = [
                NSAttributedStringKey.foregroundColor: text.textColor!,
                NSAttributedStringKey.font: text.font!
            ]
            text.linkTextAttributes = [
                NSAttributedStringKey.foregroundColor: NSColor.labelColor,
                NSAttributedStringKey.cursor: NSCursor.pointingHand,
                NSAttributedStringKey.underlineStyle: 1,
            ]
            text.selectedTextAttributes = [
                NSAttributedStringKey.backgroundColor: NSColor.lightOverlay(forAppearance: appearance),
                NSAttributedStringKey.foregroundColor: NSColor.labelColor,
                NSAttributedStringKey.underlineStyle: 0,
            ]
            text.markedTextAttributes = [
                NSAttributedStringKey.backgroundColor: NSColor.lightOverlay(forAppearance: appearance),
                NSAttributedStringKey.foregroundColor: NSColor.labelColor,
                NSAttributedStringKey.underlineStyle: 0,
            ]
		}
	}
    
    internal func setColors() {
        guard let b = self.representedObject as? EventBundle else { return }
        guard let o = b.current as? Message else { return }
        let text = self.textLabel
        let settings = ConversationSettings(serviceIdentifier: b.current.serviceIdentifier,
                                            identifier: b.conversationId)
        
        var color = NSColor.darkOverlay(forAppearance: self.view.effectiveAppearance)
        let setting = o.sender.me ? settings.outgoingColor : settings.incomingColor
        if  let c = setting, c.alphaComponent > 0.0 {
            color = c
            
            // This automatically adjusts labelColor to the right XOR mask.
            text.appearance = color.isLight() ? .light : .dark
        } else {
            text.appearance = self.view.effectiveAppearance
        }
        text.layer?.backgroundColor = color.cgColor
    }
    
    // Clear any text styles and re-compute them.
    private func updateTextStyles() {
        guard let storage = self.textLabel.textStorage else { return }
        
        let base = NSRange(location: 0, length: storage.length)
        let matches = MessageInputViewController.regex.matches(in: storage.string, options: [], range: base)
        storage.setAttributes(self.textLabel.typingAttributes, range: base)
        storage.applyFontTraits([.unboldFontMask, .unitalicFontMask], range: base)
        
        for res in matches {
            let range = res.range(at: 2)
            switch storage.attributedSubstring(from: res.range(at: 1)).string {
            case "*": // bold
                storage.applyFontTraits(.boldFontMask, range: range)
            case "_": // italics
                storage.applyFontTraits(.italicFontMask, range: range)
            case "~": // strikethrough
                storage.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            case "`": // underline
                storage.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            default: break
            }
        }
    }
    
    public override func viewWillAppear() {
        self.setColors() // just in case!
    }
    
	/// Allows the circle crop and masking to dynamically change.
	public override func viewDidLayout() {
		if let layer = self.photoView.layer {
			layer.masksToBounds = true
			layer.cornerRadius = layer.bounds.width / 2.0
		}
        
        //self.textLabel.layer?.masksToBounds = true
        //self.textLabel.layer?.cornerRadius = 10.0
        
        let radius = self.photoView.layer!.frame.width / 2.0
        var corners = CornerRadii(topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius)
        if let b = self.representedObject as? EventBundle, let curr = b.current as? Message {
            if let prev = b.previous as? Message, prev.sender.identifier == curr.sender.identifier {
                corners.bottomLeft = 4.0
            }
            if let next = b.next as? Message, next.sender.identifier == curr.sender.identifier {
                corners.topLeft = 4.0
            }
        }
        
        self.mask.frame = self.textLabel.layer!.bounds
        self.mask.path = NSBezierPath(roundedIn: self.textLabel.layer!.bounds,
                                      cornerRadii: corners).cgPath
	}
    
    /// Modify the textView menu to display the message's time.
    public func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        menu.insertItem(NSMenuItem(title: "Sent at " + (self.textLabel.toolTip ?? ""), action: nil, keyEquivalent: ""), at: 0)
        menu.insertItem(NSMenuItem.separator(), at: 1)
        return menu
    }
    
    // Given a string, a font size, and a base width, return the measured height of the cell.
    public static func measure(_ string: String, _ width: CGFloat) -> CGFloat {
        func lineSize(_ string: String, _ font: NSFont, _ width: CGFloat) -> CGFloat {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = font.leading
            let attr = NSAttributedString(string: string, attributes: [
                .font: font, .paragraphStyle: paragraphStyle
                ])
            
            let framesetter = CTFramesetterCreateWithAttributedString(attr)
            let constraints = NSSize(width: width, height: 10_000)
            let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attr.length),
                                                                    nil, constraints, nil)
            return size.height
        }
        
        let h = lineSize(string,
                         NSFont.systemFont(ofSize: 12.0 * (string.isEmoji ? 4 : 1)),
                         width - (24.0 + 24.0 + 16.0)) + 8.0
        return ((h < 24.0) ? 24.0 : h) + 8.0 /* add padding to max(h, 24) */
    }
}
