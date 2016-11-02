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
    @IBInspectable
    public var passthroughScrollEvents: Bool = false {
        didSet {
            self.hasHorizontalScroller = !self.passthroughScrollEvents
            self.hasVerticalScroller = !self.passthroughScrollEvents
        }
    }
	private func hideScrollers() {
		hasHorizontalScroller = false
		hasVerticalScroller = false
	}
	public override func scrollWheel(with theEvent: NSEvent) {
        if self.passthroughScrollEvents {
            self.nextResponder?.scrollWheel(with: theEvent)
        } else {
            super.scrollWheel(with: theEvent)
        }
	}
    public override var fittingSize: NSSize {
        return self.documentView?.fittingSize ?? NSSize(width: 0, height: 0)
    }
	public override var intrinsicContentSize: NSSize {
		return self.documentView?.intrinsicContentSize ?? NSSize(width: NSViewNoIntrinsicMetric, height: NSViewNoIntrinsicMetric)
	}
}

/// For automatically flipping the NSView drawing.
public class NSAntiClipView: NSClipView {
	public override var isFlipped: Bool { return true }
}
