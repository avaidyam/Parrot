import Cocoa
import protocol ParrotServiceExtension.Message

/* TODO: Add mini focus indicators that can be updated to show read status. */
/* TODO: Add Sending display with Retry/Delete support in failure case. */
/* TODO: Support Editable messages. */

public typealias SentMessage = (Message, Bool) /* message, focus */

public class SendMessageView: ListViewCell {
	@IBOutlet var photoView: NSImageView?
	@IBOutlet var textLabel: NSTextView?
	@IBOutlet var focusConstraint: NSLayoutConstraint?
	@IBOutlet var focusView: NSImageView? {
		didSet { setFocus(false) }
	}
	
	public func setFocus(_ active: Bool) {
		NSAnimationContext.runAnimationGroup({ ctx in
			self.focusView?.animator().isHidden = !active
			self.focusConstraint?.animator().constant = active ? 36 : 8
		}, completionHandler: nil)
	}
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var cellValue: Any? {
		didSet {
			guard let o = self.cellValue as? SentMessage else {
				log.warning("SendMessageView encountered faulty cellValue!")
				return
			}
			log.verbose("Configuring SendMessageView.")
			
			let user = o.0.sender
			let str = AttributedString(string: o.0.text as String)
			
			//self.color = o.color
			self.textLabel?.textStorage?.setAttributedString(str)
			self.textLabel?.toolTip = "\((o.0.timestamp ?? .origin).fullString())"
			let img: NSImage = fetchImage(user: user)
			self.photoView?.image = img
			//self.photoView?.toolTip = o.caption
			
			// Enable automatic links, etc.
			self.textLabel?.isEditable = true
			self.textLabel?.checkTextInDocument(nil)
			self.textLabel?.isEditable = false
		}
	}
	
	// Allows the circle crop to dynamically change.
	public override func layout() {
		super.layout()
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
		}
		if let text = self.textLabel, let layer = text.layer {
			layer.masksToBounds = true
			layer.cornerRadius = 2.0
			layer.backgroundColor = NSColor.darkOverlay(forAppearance: self.effectiveAppearance).cgColor
			
			// [BUG] [macOS 12] NSTextView doesn't fill width for some reason.
			text.frame = text.enclosingScrollView!.bounds
			
			// NSTextView doesn't automatically change its text color when the
			// backing view's appearance changes, so we need to set it each time.
			// In addition, make sure links aren't blue as usual.
			// Also, expand the text size if it's purely emoji.
			text.textColor = NSColor.labelColor()
			text.font = NSFont.systemFont(ofSize: 12.0 * (text.string!.isEmoji ? 3 : 1))
			text.typingAttributes = [
				NSForegroundColorAttributeName: text.textColor!,
				NSFontAttributeName: text.font!
			]
			text.linkTextAttributes = [
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSCursorAttributeName: NSCursor.pointingHand(),
				NSUnderlineStyleAttributeName: 1,
			]
			text.selectedTextAttributes = [
				NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.effectiveAppearance),
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
			text.markedTextAttributes = [
				NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.effectiveAppearance),
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
		}
	}
	
	public override class func cellHeight(forWidth width: CGFloat, cellValue: Any?) -> CGFloat {
		let text = (cellValue as! SentMessage).0.text ?? ""
		let focus = (cellValue as! SentMessage).1 ?? false
		let attr = AttributedString(string: text, attributes: [
			NSFontAttributeName: NSFont.systemFont(ofSize: 12.0 * (text.isEmoji ? 3 : 1))
		])
		let box = attr.boundingRect(with: NSSize(width: width, height: 10000000),
		                            options: [.usesLineFragmentOrigin, .usesFontLeading])
		return
			(box.size.height > 24.0 ? box.size.height : 24.0) /* text + photo */
			+ (focus ? 28.0 : 0) /* focus */
			+ 16.0 /* padding */
	}
}
