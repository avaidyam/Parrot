import Cocoa

/* TODO: Needs a complete refactor, with something like CSS styling. */

// Serves as the "model" behind the view. Technically speaking, this is a translation
// layer between the application model and decouples it from the view.
public struct Message: Equatable {
	var photo: NSImage
	var string: NSString
	var orientation: NSUserInterfaceLayoutDirection
	var color: NSColor
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
	
	private class func attributedStringForText(_ text: String) -> NSAttributedString {
		let attrString = NSMutableAttributedString(string: text)
		let linkDetector = try! NSDataDetector(types: NSTextCheckingType.link.rawValue)
		for match in linkDetector.matches(in: text, options: [], range: NSMakeRange(0, text.characters.count)) {
			if let url = match.url {
				attrString.addAttribute(NSLinkAttributeName, value: url, range: match.range)
				attrString.addAttribute(
					NSUnderlineStyleAttributeName,
					value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),
					range: match.range
				)
				
				let q = try? LinkPreviewParser.parse(link: url.absoluteString)
				Swift.print(q)
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
			let str = MessageView.attributedStringForText(o.string as String)
			self.textLabel?.textStorage?.setAttributedString(str)
			self.photoView?.image = o.photo
		}
	}
	
	// Allows the circle crop to dynamically change.
	public override func layout() {
		super.layout()
		self.userInterfaceLayoutDirection = self.orientation
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
		}
		if let text = self.textLabel, let layer = text.layer {
			layer.masksToBounds = true
			layer.cornerRadius = 2.0
			layer.backgroundColor = self._textBack.cgColor
			
			// NSTextView doesn't automatically change its text color when the 
			// backing view's appearance changes, so we need to set it each time.
			// In addition, make sure links aren't blue as usual.
			text.textColor = NSColor.label()
			text.linkTextAttributes = [
				NSCursorAttributeName: NSColor.label()
			]
			text.selectedTextAttributes = [
				NSBackgroundColorAttributeName: self._textFront,
				NSForegroundColorAttributeName: NSColor.label(),
			]
		}
	}
	
	//
	// FRAME ADJUSTMENT
	//

    /*public override var frame: NSRect {
        didSet {
            var backgroundFrame = frame

            backgroundFrame.size.width *= MessageView.FillPercentage.x

            let textMaxWidth = MessageView.widthOfText(backgroundWidth: backgroundFrame.size.width)
            let textSize = MessageView.textSizeInWidth(
                text: self.textLabel!.attributedStringValue,
                width: textMaxWidth
            )

            backgroundFrame.size.width = MessageView.widthOfBackground(textWidth: textSize.width)

            switch (orientation) {
            case .left:
                backgroundFrame.origin.x = frame.origin.x
            case .right:
				backgroundFrame.origin.x = frame.size.width - backgroundFrame.size.width
			default:
				backgroundFrame.origin.x = frame.origin.x
            }

			/*
            switch (orientation) {
            case .Left:
                self.textLabel.frame = NSRect(
                    x: self.backgroundView.frame.origin.x + MessageView.TextBorder.l,
                    y: self.backgroundView.frame.origin.y + MessageView.TextBorder.t - (MessageView.TextPadding.v / 2),
                    width: textSize.width,
                    height: textSize.height + MessageView.TextPadding.v / 2
                )
            case .Right:
                self.textLabel.frame = NSRect(
                    x: self.backgroundView.frame.origin.x + MessageView.TextBorder.r,
                    y: self.backgroundView.frame.origin.y + MessageView.TextBorder.t - (MessageView.TextPadding.v / 2),
                    width: textSize.width,
                    height: textSize.height + MessageView.TextPadding.v / 2
				)
			default:
				self.textLabel.frame = NSRect(
					x: self.backgroundView.frame.origin.x + MessageView.TextBorder.l,
					y: self.backgroundView.frame.origin.y + MessageView.TextBorder.t - (MessageView.TextPadding.v / 2),
					width: textSize.width,
					height: textSize.height + MessageView.TextPadding.v / 2
				)
            }*/
        }
    }*/
	
    private class func widthOfText(backgroundWidth: CGFloat) -> CGFloat {
        return backgroundWidth
            - MessageView.TextBorder.r
            - MessageView.TextBorder.l
    }

    private class func widthOfBackground(textWidth: CGFloat) -> CGFloat {
        return textWidth
            + MessageView.TextBorder.r
            + MessageView.TextBorder.l
	}
	
	private class func textSizeInWidth(text: NSString, width: CGFloat) -> CGSize {
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
	
	internal class func heightForContainerWidth(text: NSString, width: CGFloat) -> CGFloat {
		let size = textSizeInWidth(text: text, width: widthOfText(backgroundWidth: (width * FillPercentage.x)))
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
