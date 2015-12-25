import Cocoa
import Hangouts

class ChatMessageView : NSTableCellView {
    enum Orientation {
        case Left
        case Right
    }

    var string: NSAttributedString?
    var textLabel: NSTextField!
    var backgroundView: NSImageView!
	var backgroundColor: NSColor = NSColor(red: 0.38, green: 0.49, blue: 0.54, alpha: 1.0)

    var orientation: Orientation = .Left
    //static let font = NSFont.systemFontOfSize(NSFont.systemFontSize())

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
		//self.wantsLayer = true

		backgroundView = NSImageView(frame: NSZeroRect)
		backgroundView.wantsLayer = true
		backgroundView.layer?.cornerRadius = 4.0
		backgroundView.layer?.masksToBounds = true
        backgroundView.imageScaling = .ScaleAxesIndependently
        backgroundView.image = NSImage(named: "gray_bubble_left")
        addSubview(backgroundView)

        textLabel = NSTextField(frame: NSZeroRect)
        textLabel.bezeled = false
        textLabel.bordered = false
        textLabel.editable = false
        textLabel.drawsBackground = false
        textLabel.allowsEditingTextAttributes = true
        textLabel.selectable = true
        addSubview(textLabel)
		
		Notifications.subscribe(NSUserDefaultsDidChangeNotification) { note in
			
			// Handle appearance colors.
			//let dark = Settings.get(Parrot.InvertChatStyle) as? Bool ?? false
			//self.layer?.backgroundColor = self.backgroundColor.CGColor
		}
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	func configureWithText(string: String, orientation: Orientation, bubble: Int) {
        self.orientation = orientation
        self.string = TextMapper.attributedStringForText(string)
        textLabel.attributedStringValue = self.string!
			
		backgroundView.image = NSImage(named: orientation == .Right ? "gray_bubble_right" : "gray_bubble_left")
		
		// Properly color the text and background based on network type.
		textLabel.textColor = NSColor.whiteColor()
		if bubble == 2 { // Hangouts
			//backgroundView.layer?.backgroundColor = NSColor.labelColor().CGColor
			backgroundView.layer?.backgroundColor = NSColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.0).CGColor
		} else if bubble == 1 { // GVoice
			//backgroundView.layer?.backgroundColor = NSColor.labelColor().CGColor
			backgroundView.layer?.backgroundColor = NSColor(red: 0.31, green: 0.63, blue: 0.25, alpha: 1.0).CGColor
		} else { // Self
			//backgroundView.layer?.backgroundColor = NSColor.secondaryLabelColor().CGColor
			backgroundView.layer?.backgroundColor = NSColor(red: 0.38, green: 0.49, blue: 0.54, alpha: 1.0).CGColor
		}
    }
	
	// FRAME ADJUSTMENT

    static let WidthPercentage: CGFloat = 0.75
    static let TextPointySideBorder: CGFloat = 12
    static let TextRoundSideBorder: CGFloat = 8
    static let TextTopBorder: CGFloat = 4
    static let TextBottomBorder: CGFloat = 4
    static let VerticalTextPadding: CGFloat = 4
    static let HorizontalTextMeasurementPadding: CGFloat = 5

    override var frame: NSRect {
        didSet {
            var backgroundFrame = frame

            backgroundFrame.size.width *= ChatMessageView.WidthPercentage

            let textMaxWidth = ChatMessageView.widthOfText(backgroundWidth: backgroundFrame.size.width)
            let textSize = ChatMessageView.textSizeInWidth(
                textLabel.attributedStringValue,
                width: textMaxWidth
            )

            backgroundFrame.size.width = ChatMessageView.widthOfBackground(textWidth: textSize.width)

            switch (orientation) {
            case .Left:
                backgroundFrame.origin.x = frame.origin.x
            case .Right:
                backgroundFrame.origin.x = frame.size.width - backgroundFrame.size.width
            }

            backgroundView.frame = backgroundFrame

            switch (orientation) {
            case .Left:
                textLabel.frame = NSRect(
                    x: backgroundView.frame.origin.x + ChatMessageView.TextPointySideBorder,
                    y: backgroundView.frame.origin.y + ChatMessageView.TextTopBorder - (ChatMessageView.VerticalTextPadding / 2),
                    width: textSize.width,
                    height: textSize.height + ChatMessageView.VerticalTextPadding / 2
                )
            case .Right:
                textLabel.frame = NSRect(
                    x: backgroundView.frame.origin.x + ChatMessageView.TextRoundSideBorder,
                    y: backgroundView.frame.origin.y + ChatMessageView.TextTopBorder - (ChatMessageView.VerticalTextPadding / 2),
                    width: textSize.width,
                    height: textSize.height + ChatMessageView.VerticalTextPadding / 2
                )
            }
        }
    }

	// MEASUREMENT
	
    class func widthOfText(backgroundWidth backgroundWidth: CGFloat) -> CGFloat {
        return backgroundWidth
            - ChatMessageView.TextRoundSideBorder
            - ChatMessageView.TextPointySideBorder
    }

    class func widthOfBackground(textWidth textWidth: CGFloat) -> CGFloat {
        return textWidth
            + ChatMessageView.TextRoundSideBorder
            + ChatMessageView.TextPointySideBorder
    }

    class func textSizeInWidth(text: NSAttributedString, width: CGFloat) -> CGSize {
        var size = text.boundingRectWithSize(
            NSMakeSize(width, 0),
            options: [
                NSStringDrawingOptions.UsesLineFragmentOrigin,
                NSStringDrawingOptions.UsesFontLeading
            ]
        ).size
        size.width += HorizontalTextMeasurementPadding
        return size
    }

    class func heightForContainerWidth(text: NSAttributedString, width: CGFloat) -> CGFloat {
        let size = textSizeInWidth(text, width: widthOfText(backgroundWidth: (width * WidthPercentage)))
        let height = size.height + TextTopBorder + TextBottomBorder
        return height
    }
}