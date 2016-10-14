import AppKit

@objc public protocol NSTextViewExtendedDelegate: NSTextViewDelegate {
	@objc(textView:didInsertText:replacementRange:)
	optional func textView(_ textView: NSTextView, didInsertText: Any, replacementRange: NSRange)
}

@IBDesignable
public class NSExtendedTextView: NSTextView {
	
	@IBInspectable
	public var shouldAlwaysPasteAsPlainText: Bool = false
	
	// Apparently this property has been private on macOS since 10.7.
	@IBInspectable
	public var placeholderString: String? = nil
	public var placeholderAttributedString: NSAttributedString? = nil
	
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
	
	// FOR AUTOLAYOUT:
	/*
	public override var intrinsicContentSize: NSSize {
		self.layoutManager?.ensureLayout(for: self.textContainer!)
		return (self.layoutManager?.usedRect(for: self.textContainer!).size)!
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
	*/
}

public extension NSTextView {
	public func characterRect() -> NSRect {
		let glyphRange = NSMakeRange(0, self.layoutManager!.numberOfGlyphs)
		return self.characterRect(forRange: glyphRange)
	}
	public func characterRect(forRange glyphRange: NSRange) -> NSRect {
		let glyphRect = self.layoutManager!.boundingRect(forGlyphRange: glyphRange, in: self.textContainer!)
		return NSInsetRect(glyphRect, -self.textContainerInset.width * 2, -self.textContainerInset.height * 2)
	}
}
