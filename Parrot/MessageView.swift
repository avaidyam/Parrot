import Cocoa

/* TODO: Needs a complete refactor, with something like CSS styling. */

// Serves as the "model" behind the view. Technically speaking, this is a translation
// layer between the application model and decouples it from the view.
public struct Message {
	var string: NSAttributedString, orientation: NSTextAlignment, color: NSColor
}

public class MessageView : NSTableCellView {
	
	// Customization settings for rendering the message.
	// Support: fill percentages, text border and padding, optional photo,
	// decorators, etc. (anything NSView or CALayer can support!)
	internal static var FillPercentage = (x: CGFloat(0.75), y: CGFloat(1.00))
	internal static var TextBorder = (l: CGFloat(2), r: CGFloat(2), t: CGFloat(2), b: CGFloat(2))
	internal static var TextPadding = (v: CGFloat(4), h: CGFloat(4))
	
	var backgroundView: NSImageView!
	var textLabel: NSTextField!
	var orientation: NSTextAlignment = .Left
	
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
		
		self.backgroundView = NSImageView(frame: NSZeroRect)
		self.backgroundView.wantsLayer = true
		self.backgroundView.layer?.cornerRadius = 4.0
		self.backgroundView.layer?.masksToBounds = true
        self.backgroundView.imageScaling = .ScaleAxesIndependently
		self.addSubview(self.backgroundView)

        self.textLabel = NSTextField(frame: NSZeroRect)
        self.textLabel.bezeled = false
        self.textLabel.bordered = false
        self.textLabel.editable = false
        self.textLabel.drawsBackground = false
        self.textLabel.allowsEditingTextAttributes = true
		self.textLabel.selectable = true
		self.textLabel.textColor = NSColor.whiteColor()
        self.addSubview(self.textLabel)
	}
	
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: AnyObject? {
		didSet {
			guard let o = (self.objectValue as? Wrapper<Message>)?.element else {
				return
			}
			self.orientation = o.orientation
			self.textLabel.attributedStringValue = o.string
			self.backgroundView.layer?.backgroundColor = o.color.CGColor
		}
	}
	
	//
	// FRAME ADJUSTMENT
	//

    public override var frame: NSRect {
        didSet {
            var backgroundFrame = frame

            backgroundFrame.size.width *= MessageView.FillPercentage.x

            let textMaxWidth = MessageView.widthOfText(backgroundWidth: backgroundFrame.size.width)
            let textSize = MessageView.textSizeInWidth(
                self.textLabel.attributedStringValue,
                width: textMaxWidth
            )

            backgroundFrame.size.width = MessageView.widthOfBackground(textWidth: textSize.width)

            switch (orientation) {
            case .Left:
                backgroundFrame.origin.x = frame.origin.x
            case .Right:
				backgroundFrame.origin.x = frame.size.width - backgroundFrame.size.width
			default:
				backgroundFrame.origin.x = frame.origin.x
            }

            self.backgroundView.frame = backgroundFrame

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
            }
        }
    }
	
    private class func widthOfText(backgroundWidth backgroundWidth: CGFloat) -> CGFloat {
        return backgroundWidth
            - MessageView.TextBorder.r
            - MessageView.TextBorder.l
    }

    private class func widthOfBackground(textWidth textWidth: CGFloat) -> CGFloat {
        return textWidth
            + MessageView.TextBorder.r
            + MessageView.TextBorder.l
    }

    private class func textSizeInWidth(text: NSAttributedString, width: CGFloat) -> CGSize {
        var size = text.boundingRectWithSize(
            NSMakeSize(width, 0),
            options: [
                NSStringDrawingOptions.UsesLineFragmentOrigin,
                NSStringDrawingOptions.UsesFontLeading
            ]
        ).size
        size.width += TextPadding.h
        return size
    }
	
	internal class func heightForContainerWidth(text: NSAttributedString, width: CGFloat) -> CGFloat {
        let size = textSizeInWidth(text, width: widthOfText(backgroundWidth: (width * FillPercentage.x)))
        let height = size.height + TextBorder.t + TextBorder.b
        return height
    }
}