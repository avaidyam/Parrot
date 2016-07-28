import AppKit

/// For Interface Builder to not screw with NSTextView embedding.
public class NSAntiScrollView: NSScrollView {
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		hideScrollers()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		hideScrollers()
	}
	private func hideScrollers() {
		hasHorizontalScroller = false
		hasVerticalScroller = false
	}
	public override func scrollWheel(_ theEvent: NSEvent) {
		self.nextResponder?.scrollWheel(theEvent)
	}
	public override var intrinsicContentSize: NSSize {
		return self.documentView?.intrinsicContentSize ?? NSSize(width: -1, height: -1)
	}
}

/// For automatically flipping the NSView drawing.
public class NSAntiClipView: NSClipView {
	public override var isFlipped: Bool { return true }
}
