import Cocoa

/* TODO: Needs a complete refactor, with something like CSS styling. */

// Serves as the "model" behind the view. Technically speaking, this is a translation
// layer between the application model and decouples it from the view.
public struct Message: Equatable {
	var photo: NSImage
	var caption: String
	var string: NSString
	var orientation: NSUserInterfaceLayoutDirection
	var color: NSColor
	var time: Date
}

// Message: Equatable
public func ==(lhs: Message, rhs: Message) -> Bool {
	return lhs.photo == rhs.photo &&
		lhs.string == rhs.string &&
		lhs.orientation == rhs.orientation &&
		lhs.color == rhs.color
}

public class MessageView : NSTableCellView {
	
	// Customization settings for rendering the message.
	// Support: fill percentages, text border and padding, optional photo,
	// decorators, etc. (anything NSView or CALayer can support!)
	internal static var FillPercentage = (x: CGFloat(0.75), y: CGFloat(1.00))
	internal static var TextBorder = (l: CGFloat(4), r: CGFloat(4), t: CGFloat(4), b: CGFloat(4))
	internal static var TextPadding = (v: CGFloat(8), h: CGFloat(8))
	
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
	
	private class func attributedStringForText(_ text: String) -> AttributedString {
		let attrString = NSMutableAttributedString(string: text)
		let linkDetector = try! NSDataDetector(types: TextCheckingResult.CheckingType.link.rawValue)
		for match in linkDetector.matches(in: text, options: [], range: NSMakeRange(0, text.characters.count)) {
			if let url = match.url {
				attrString.addAttribute(NSLinkAttributeName, value: url, range: match.range)
				attrString.addAttribute(
					NSUnderlineStyleAttributeName,
					value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),
					range: match.range
				)
				
				// TESTING:
				//_ = try? LinkPreviewParser.parse(url.absoluteString!)
			}
		}
		return attrString
	}
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: AnyObject? {
		didSet {
			guard let o = (self.objectValue as? Wrapper<Any>)?.element as? Message else {
				return
			}
			
			self.orientation = o.orientation
			self.color = o.color
			let str = MessageView.attributedStringForText(o.string as String)
			self.textLabel?.textStorage?.setAttributedString(str)
			self.textLabel?.toolTip = "\(o.time.fullString())"
			self.photoView?.image = o.photo
			self.photoView?.toolTip = o.caption
		}
	}
	
	// Allows the circle crop to dynamically change.
	public override func layout() {
		super.layout()
		self.userInterfaceLayoutDirection = self.orientation
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
			layer.borderWidth = 1.0
			layer.borderColor = self.color.cgColor
		}
		if let text = self.textLabel, let layer = text.layer {
			layer.masksToBounds = true
			layer.cornerRadius = 2.0
			layer.backgroundColor = self._textBack.cgColor
			
			// NSTextView doesn't automatically change its text color when the 
			// backing view's appearance changes, so we need to set it each time.
			// In addition, make sure links aren't blue as usual.
			text.textColor = NSColor.labelColor()
			text.font = NSFont.systemFont(ofSize: 12.0)
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
	
	/* TODO: Clean this up and out of here. */
	internal class func heightForContainerWidth(_ text: NSString, width: CGFloat) -> CGFloat {
		func widthOfText(_ backgroundWidth: CGFloat) -> CGFloat {
			return backgroundWidth
				- MessageView.TextBorder.r
				- MessageView.TextBorder.l
		}
		
		func widthOfBackground(_ textWidth: CGFloat) -> CGFloat {
			return textWidth
				+ MessageView.TextBorder.r
				+ MessageView.TextBorder.l
		}
		
		func textSizeInWidth(_ text: NSString, width: CGFloat) -> CGSize {
			var size = text.boundingRect(
				with: NSMakeSize(width, 0),
				options: [
					.usesLineFragmentOrigin,
					.usesFontLeading
				]
				).size
			size.width += TextPadding.h
			return size
		}
		
		let size = textSizeInWidth(text, width: widthOfText((width * FillPercentage.x)))
		let height = size.height + TextBorder.t + TextBorder.b
		return height
	}
}

// Container-type view for MessageView.
public class MessagesView: ElementContainerView {
	internal override func createView() -> MessageView {
		var view = self.tableView.make(withIdentifier: MessageView.className(), owner: self) as? MessageView
		if view == nil {
			view = MessageView(frame: NSZeroRect)
			view!.identifier = MessageView.className()
		}
		return view!
	}
}
