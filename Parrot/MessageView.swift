import Cocoa

/* TODO: Needs a complete refactor, with something like CSS styling. */

public class MessageView: NSTableCellView {
	
	// Serves as the "model" behind the view. Technically speaking, this is a translation
	// layer between the application model and decouples it from the view.
	public struct Info: Equatable {
		var photo: NSImage
		//var caption: String
		var string: String
		var orientation: NSUserInterfaceLayoutDirection
		//var color: NSColor
		var time: Date
	}
	
	@IBOutlet var photoView: NSImageView?
	@IBOutlet var textLabel: NSTextView?
	var color: NSColor = NSColor.black()
	var orientation: NSUserInterfaceLayoutDirection = .leftToRight
	
	public override init(frame: NSRect) {
		super.init(frame: frame)
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private var _textBack: NSColor {
		if self.effectiveAppearance.name == NSAppearanceNameVibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.2)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.1)
		}
	}
	
	private var _textFront: NSColor {
		if self.effectiveAppearance.name == NSAppearanceNameVibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.5)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.6)
		}
	}
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: AnyObject? {
		didSet {
			guard let o = (self.objectValue as? Wrapper<Any>)?.element as? MessageView.Info else {
				return
			}
			let str = AttributedString(string: o.string as String)
			
			self.orientation = o.orientation
			//self.color = o.color
			self.textLabel?.textStorage?.setAttributedString(str)
			self.textLabel?.toolTip = "\(o.time.fullString())"
			self.photoView?.image = o.photo
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
		self.userInterfaceLayoutDirection = self.orientation
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
			//layer.borderWidth = 1.0
			//layer.borderColor = self.color.cgColor
		}
		if let text = self.textLabel, let layer = text.layer {
			layer.masksToBounds = true
			layer.cornerRadius = 2.0
			layer.backgroundColor = self._textBack.cgColor
			
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
				NSBackgroundColorAttributeName: self._textFront,
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
			text.markedTextAttributes = [
				NSBackgroundColorAttributeName: self._textFront,
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
		}
	}
	
	/* TODO: Clean this up and out of here: */
	internal class func heightForContainerWidth(_ text: String, size: CGFloat, width: CGFloat) -> CGFloat {
		let attr = AttributedString(string: text, attributes: [
			NSFontAttributeName: NSFont.systemFont(ofSize: size * (text.isEmoji ? 3 : 1))
		])
		let fake = NSSize(width: width, height: 10000000)
		let box = attr.boundingRect(with: fake, options: [.usesLineFragmentOrigin, .usesFontLeading])
		let height = box.size.height
		return (height > 24.0 ? height : 24.0) + 16.0
	}
}

// Message: Equatable
public func ==(lhs: MessageView.Info, rhs: MessageView.Info) -> Bool {
	return lhs.photo == rhs.photo &&
		lhs.string == rhs.string &&
		lhs.orientation == rhs.orientation //&&
		//lhs.color == rhs.color
}

// Container-type view for MessageView.
public class MessageListView: ListView {
	internal override func createView() -> MessageView {
		var view = self.tableView.make(withIdentifier: MessageView.className(), owner: self) as? MessageView
		if view == nil {
			view = MessageView(frame: NSZeroRect)
			view!.identifier = MessageView.className()
		}
		return view!
	}
}
