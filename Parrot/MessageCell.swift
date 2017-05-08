import Cocoa
import Mocha
import MochaUI
import AddressBook
import protocol ParrotServiceExtension.Message

/* TODO: Use NSPanGestureRecognizer or Force Touch to expand links. */

public class MessageCell: NSTableCellView, NSTextViewDelegate {
	@IBOutlet var photoView: NSImageView?
	@IBOutlet var textLabel: NSTextView?
    private var outline: CAShapeLayer?
	private var orientation: NSUserInterfaceLayoutDirection = .rightToLeft
    
    private var token: Any? = nil
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.token = subscribe(source: nil, Notification.Name("com.avaidyam.Parrot.UpdateColors")) { _ in
            self.setColors()
        }
        
        self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel?.enclosingScrollView?.replaceInSuperview(with: self.textLabel!)
    }
    
    deinit {
        unsubscribe(self.token)
    }
    
	/// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: Any? {
        didSet {
            guard let b = self.objectValue as? EventStreamItemBundle else { return }
            guard let o = b.current as? Message else { return }
			
			let user = o.sender
			let str = NSAttributedString(string: o.text as String)
            self.orientation = o.sender!.me ? .rightToLeft : .leftToRight // FIXME
			//self.textLabel?.alignment = o.sender!.me ? .right : .left // FIXME
			//self.color = o.color
			self.textLabel?.textStorage?.setAttributedString(str)
			self.textLabel?.toolTip = "\((o.timestamp /*?? .origin*/).fullString())"
			let img: NSImage = fetchImage(user: user!)
			self.photoView?.image = img
			//self.photoView?.toolTip = o.caption
            
            // Hide your own icon and hide the icon of a repeating message.
            self.photoView?.isHidden = /*(o.sender?.me ?? false) || */(b.previous?.sender?.identifier == o.sender?.identifier)
            self.textLabel?.alignment = (o.sender?.me ?? false) ? .right : .left
            
            // Enable automatic links and data detectors.
            self.textLabel?.isEditable = true
            self.textLabel?.checkTextInDocument(nil)
            self.textLabel?.isEditable = false
            
            guard let text = self.textLabel else { return }
            let appearance = self.appearance ?? NSAppearance.current()
            text.textColor = NSColor.labelColor
            self.setColors()
            
            // NSTextView doesn't automatically change its text color when the
            // backing view's appearance changes, so we need to set it each time.
            // In addition, make sure links aren't blue as usual.
            // Also, expand the text size if it's purely emoji.
            text.font = NSFont.systemFont(ofSize: 12.0 * (text.string!.isEmoji ? 4 : 1))
            text.invalidateIntrinsicContentSize()
            
            text.typingAttributes = [
                NSForegroundColorAttributeName: text.textColor!,
                NSFontAttributeName: text.font!
            ]
            text.linkTextAttributes = [
                NSForegroundColorAttributeName: NSColor.labelColor,
                NSCursorAttributeName: NSCursor.pointingHand(),
                NSUnderlineStyleAttributeName: 1,
            ]
            text.selectedTextAttributes = [
                NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: appearance),
                NSForegroundColorAttributeName: NSColor.labelColor,
                NSUnderlineStyleAttributeName: 0,
            ]
            text.markedTextAttributes = [
                NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: appearance),
                NSForegroundColorAttributeName: NSColor.labelColor,
                NSUnderlineStyleAttributeName: 0,
            ]
		}
	}
    
    private func setColors() {
        guard let b = self.objectValue as? EventStreamItemBundle else { return }
        guard let o = b.current as? Message else { return }
        guard let text = self.textLabel else { return }
        
        // Only clip the text if the text isn't purely Emoji.
        if !text.string!.isEmoji {
            var color = NSColor.tertiaryLabelColor
            let setting = "com.avaidyam.Parrot.Conversation" + ((o.sender?.me ?? false) ? "OutgoingColor" : "IncomingColor")
            if  let q = Settings[setting] as? Data,
                let c = NSUnarchiver.unarchiveObject(with: q) as? NSColor,
                c.alphaComponent > 0.0 {
                color = c
                
                // This automatically adjusts labelColor to the right XOR mask.
                text.appearance = NSAppearance(named: color.isLight() ? NSAppearanceNameVibrantLight : NSAppearanceNameVibrantDark)
            } else {
                text.appearance = self.appearance
            }
            text.layer?.backgroundColor = color.cgColor
        } else {
            text.layer?.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0).cgColor
        }
    }
    
	/// Allows the circle crop and masking to dynamically change.
	public override func layout() {
        super.layout()
		if let layer = self.photoView?.layer {
			layer.masksToBounds = true
			layer.cornerRadius = layer.bounds.width / 2.0
		}
		if let text = self.textLabel {
            text.layer?.masksToBounds = true
            text.layer?.cornerRadius = 10.0
		}
	}
    
    /// If we're right-clicked outside of the text view, just popUp the textView's menu.
    /// Note: make sure we SELECT ALL and then DESELECT ALL after the popUp menu.
    public override func menu(for event: NSEvent) -> NSMenu? {
        self.textLabel?.selectAll(nil)
        return self.textLabel?.menu(for: event)
        //self.textLabel?.setSelectedRange(NSRange())
    }
    
    /// Modify the textView menu to display the message's time.
    public func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        menu.insertItem(NSMenuItem(title: "Sent at " + (self.textLabel?.toolTip ?? ""), action: nil, keyEquivalent: ""), at: 0)
        menu.insertItem(NSMenuItem.separator(), at: 1)
        return menu
    }
    
    
    
    private static var storage: NSTextStorage = {
        return NSTextStorage(string: "")
    }()
    private static var container: NSTextContainer = {
        let x = NSTextContainer(containerSize: NSZeroSize)
        x.lineFragmentPadding = 0.0
        return x
    }()
    private static var manager: NSLayoutManager = {
        let x = NSLayoutManager()
        x.addTextContainer(MessageCell.container)
        MessageCell.storage.addLayoutManager(x)
        return x
    }()
    
    // Given a string, a font size, and a base width, return the measured height of the cell.
    public static func measure(_ string: String, _ width: CGFloat, _ font: NSFont = .systemFont(ofSize: 13.0)) -> Double {
        MessageCell.container.containerSize = NSSize(width: width - 40.0 /* padding + image*/, height: CGFloat.greatestFiniteMagnitude)
        MessageCell.storage.setAttributedString(NSAttributedString(string: string))
        MessageCell.storage.font = font
        
        _ = MessageCell.manager.glyphRange(for: MessageCell.container)
        let h = Double(MessageCell.manager.usedRect(for: MessageCell.container).size.height)
        return (h < 24.0) ? 32.0 : (h + 16.0)
    }
}
