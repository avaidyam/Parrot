import AppKit

@objc public protocol NSTextViewExtendedDelegate: NSTextViewDelegate {
	@objc(textView:didInsertText:replacementRange:)
	optional func textView(_ textView: NSTextView, didInsertText: Any, replacementRange: NSRange)
}

@IBDesignable
public class ExtendedTextView: NSTextView {
	
	@IBInspectable
	public var shouldAlwaysPasteAsPlainText: Bool = false
	
	// Apparently this property has been private on macOS since 10.7.
	@IBInspectable
	public var placeholderString: String? = nil
	public var placeholderAttributedString: NSAttributedString? = nil
    
    public var providesContentSize: Bool = true {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    public var preferredMaxLayoutWidth: CGFloat = 0.0 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    public var maximumNumberOfLines: Int = 0 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
	
	public override func insertText(_ string: Any, replacementRange: NSRange) {
		super.insertText(string, replacementRange: replacementRange)
		
		if let d = self.delegate as? NSTextViewExtendedDelegate {
			d.textView?(self, didInsertText: string, replacementRange: replacementRange)
		}
	}
	
	public override func paste(_ sender: Any?) {
		if self.shouldAlwaysPasteAsPlainText {
			self.pasteAsPlainText(sender)
		} else {
			super.paste(sender)
		}
	}
	
	public override var intrinsicContentSize: NSSize {
        guard self.providesContentSize else {
            return super.intrinsicContentSize
        }
        return self.layoutRect().size
	}
	public override func didChangeText() {
		super.didChangeText()
		self.invalidateIntrinsicContentSize()
	}
	public override func becomeFirstResponder() -> Bool {
		self.needsDisplay = true
		return super.becomeFirstResponder()
	}
	public override func resignFirstResponder() -> Bool {
		self.needsDisplay = true
		return super.resignFirstResponder()
	}
    
    /*
    public override func drawBackground(in rect: NSRect) {
        NSColor.red.setFill()
        NSRectFill(self.layoutRect())
    }*/
}

public extension NSTextView {
    public func layoutRect() -> NSRect {
        self.layoutManager?.ensureLayout(for: self.textContainer!)
        let baseR = self.layoutManager!.usedRect(for: self.textContainer!)
        let insetR = baseR.insetBy(dx: -self.textContainerInset.width, dy: -self.textContainerInset.height)
        let offsetR = insetR.offsetBy(dx: self.textContainerOrigin.x, dy: self.textContainerOrigin.y)
        return offsetR.insetBy(dx: -4.0, dy: 0.0) // FIXME
    }
    
	public func characterRect() -> NSRect {
		let glyphRange = NSMakeRange(0, self.layoutManager!.numberOfGlyphs)
		return self.characterRect(forRange: glyphRange)
	}
	public func characterRect(forRange glyphRange: NSRange) -> NSRect {
		let glyphRect = self.layoutManager!.boundingRect(forGlyphRange: glyphRange, in: self.textContainer!)
		return NSInsetRect(glyphRect, -self.textContainerInset.width, -self.textContainerInset.height)
	}
}
