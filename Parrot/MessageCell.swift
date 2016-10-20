import Cocoa
import AddressBook
import protocol ParrotServiceExtension.Message

public class MessageCell: ListViewCell {
	@IBOutlet var photoView: NSImageView?
	@IBOutlet var textLabel: NSTextView?
	private var orientation: NSUserInterfaceLayoutDirection = .rightToLeft
    
	// Upon assignment of the represented object, configure the subview contents.
	public override var representedObject: Any? {
        didSet {
            guard let o = self.representedObject as? Message else { return }
			
			let user = o.sender
			let str = NSAttributedString(string: o.text as String)
			//self.orientation = o.sender!.me ? .rightToLeft : .leftToRight // FIXME
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
	
	// Allows the circle crop to dynamically change.
	public override func viewWillLayout() {
		super.viewWillLayout()
		//self.userInterfaceLayoutDirection = self.orientation // FIXME
		if let layer = self.photoView?.layer {
			layer.masksToBounds = true
			layer.cornerRadius = layer.bounds.width / 2.0
		}
		if let text = self.textLabel {
			
			// [BUG] [macOS 12] NSTextView doesn't fill width if layer-backed?
			text.frame = text.enclosingScrollView!.bounds
			
			// Vertically center text which can fit in the bounds of the text view.
			// Note: only do this if the text isn't Emoji.
			if !text.string!.isEmoji && text.bounds.height <= 24.0 {
				let charRect = text.characterRect()
				let rectDiff = text.bounds.height - charRect.height
				if rectDiff > 0 { text.textContainerInset.height = rectDiff / 2.0 }
            }
            
            // Set background masking.
            text.layer?.masksToBounds = true
            text.layer?.cornerRadius = 2.0
		}
	}
    
    public override func rightMouseUp(with event: NSEvent) {
        self.textLabel?.selectAll(nil)
        self.textLabel?.menu(for: event)?.popUp(positioning: nil, at: self.view.convert(event.locationInWindow, from: nil), in: self.view)
        self.textLabel?.setSelectedRange(NSRange())
    }
	
    // TODO: not called.
    public override func preferredLayoutAttributesFitting(_ attr: NSCollectionViewLayoutAttributes) -> NSCollectionViewLayoutAttributes {
        let h = MessageCell.cellHeight(forWidth: attr.size.width, cellValue: self.representedObject)
        attr.size = NSSize(width: attr.size.width, height: h)
        return attr
    }
    
	/*
	private static var abc: NSLayoutManager = {
		var textStorage = NSTextStorage()
		var layoutManager = NSLayoutManager()
		textStorage.addLayoutManager(layoutManager)
		var textContainer = NSTextContainer()
		layoutManager.addTextContainer(textContainer)
		return layoutManager
	}()
	public static func _hAbc(_ width: CGFloat, _ attr: AttributedString) -> CGFloat {
		abc.textContainers[0].containerSize = NSSize(width: width, height: 10000000)
		abc.textStorage?.setAttributedString(attr)
		let glyphRange = NSMakeRange(0, abc.numberOfGlyphs)
		let glyphRect = abc.boundingRect(forGlyphRange: glyphRange, in: abc.textContainers[0])
		return (glyphRect.size.height > 24.0 ? glyphRect.size.height : 24.0) + 16.0
	}
	*/
	
	public override class func cellHeight(forWidth width: CGFloat, cellValue: Any?) -> CGFloat {
		let text = (cellValue as! Message).text //?? ""
		let attr = NSAttributedString(string: text, attributes: [
			NSFontAttributeName: NSFont.systemFont(ofSize: 12.0 * (text.isEmoji ? 3 : 1)),
			NSParagraphStyleAttributeName: NSParagraphStyle.default()
		])
		
		let ourWidth = width - 50.0 // to account for padding and icon: |- 4 - [icon (24)] - 4 - [4 - text - 4] - 8 -|
		let box = attr.boundingRect(with: NSSize(width: ourWidth, height: .greatestFiniteMagnitude),
		                            options: [.usesLineFragmentOrigin, .usesFontLeading])
        
        let expectedHeight = box.size.height + 16.0, defaultHeight = CGFloat(24.0) + 16.0
		return (expectedHeight > defaultHeight ? expectedHeight : defaultHeight)
	}
}
