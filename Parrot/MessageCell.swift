import Cocoa
import AddressBook
import protocol ParrotServiceExtension.Message

/* TODO: Use NSPanGestureRecognizer or Force Touch to expand links. */

public class MessageCell: ListViewCell, NSTextViewDelegate {
	@IBOutlet var photoView: NSImageView?
	@IBOutlet var textLabel: NSTextView?
	private var orientation: NSUserInterfaceLayoutDirection = .rightToLeft
    
    public override func loadView() {
        super.loadView()
        
        // Since we struggle with IB shoving the NSScrollView down our throats, 
        // remove the scroll view entirely and re-constrain the text view.
        let scroll = self.textLabel?.enclosingScrollView
        self.textLabel?.removeFromSuperview()
        self.view.addSubview(self.textLabel!)
        scroll?.removeFromSuperview()
        
        // Match the same constraints that the scroll view had in IB and turn off autoresizing.
        self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel?.leadingAnchor.constraint(equalTo: self.photoView!.trailingAnchor, constant: 8).isActive = true
        self.textLabel?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        self.textLabel?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        self.textLabel?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        self.textLabel?.heightAnchor.constraint(greaterThanOrEqualTo: self.photoView!.heightAnchor).isActive = true
    }
    
	/// Upon assignment of the represented object, configure the subview contents.
	public override var representedObject: Any? {
        didSet {
            guard let o = self.representedObject as? Message else { return }
			
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
            
            // Enable automatic links and data detectors.
            self.textLabel?.isEditable = true
            self.textLabel?.checkTextInDocument(nil)
            self.textLabel?.isEditable = false
            
            guard let text = self.textLabel else { return }
            let appearance = self.view.appearance ?? NSAppearance.current()
            
            // NSTextView doesn't automatically change its text color when the
            // backing view's appearance changes, so we need to set it each time.
            // In addition, make sure links aren't blue as usual.
            // Also, expand the text size if it's purely emoji.
            text.textColor = NSColor.labelColor
            text.font = NSFont.systemFont(ofSize: 12.0 * (text.string!.isEmoji ? 3 : 1))
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
            
            // Only clip the text if the text isn't purely Emoji.
            if !text.string!.isEmoji {
                text.layer?.backgroundColor = NSColor.darkOverlay(forAppearance: appearance).cgColor
            } else {
                text.layer?.backgroundColor = NSColor.clear.cgColor
            }
		}
	}
    
	/// Allows the circle crop and masking to dynamically change.
	public override func viewDidLayout() {
        super.viewDidLayout()
		if let layer = self.photoView?.layer {
			layer.masksToBounds = true
			layer.cornerRadius = layer.bounds.width / 2.0
		}
		if let text = self.textLabel {
            text.layer?.masksToBounds = true
            text.layer?.cornerRadius = 2.0
		}
	}
    
    /// If we're right-clicked outside of the text view, just popUp the textView's menu.
    /// Note: make sure we SELECT ALL and then DESELECT ALL after the popUp menu.
    public override func rightMouseUp(with event: NSEvent) {
        self.textLabel?.selectAll(nil)
        self.textLabel?.menu(for: event)?.popUp(positioning: nil, at: self.view.convert(event.locationInWindow, from: nil), in: self.view)
        self.textLabel?.setSelectedRange(NSRange())
    }
    
    /// Modify the textView menu to display the message's time.
    public func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        menu.insertItem(NSMenuItem(title: "Sent at " + (self.textLabel?.toolTip ?? ""), action: nil, keyEquivalent: ""), at: 0)
        menu.insertItem(NSMenuItem.separator(), at: 1)
        return menu
    }
}
