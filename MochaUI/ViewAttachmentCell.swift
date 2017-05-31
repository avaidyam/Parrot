import Cocoa

public class ViewAttachmentCell : NSTextAttachmentCell {
    
    /// The view to be embed in the NSTextView this attachment is contained within.
    public private(set) var view: NSView
    
    /// The textView being tracked (the container of this attachment).
    /// Note: we track the NSTextDidChange notification to see if we should remove
    /// or migrate the view from/to the textView as needed.
    private weak var textView: NSTextView? = nil {
        didSet {
            let n = NotificationCenter.default
            if oldValue != nil {
                n.removeObserver(self, name: .NSTextDidChange, object: oldValue!)
                self.view.removeFromSuperview()
            }
            if self.textView != nil {
                n.addObserver(self, selector: #selector(ViewAttachmentCell.verifyAttached(_:)),
                              name: .NSTextDidChange, object: self.textView!)
                self.textView!.addSubview(self.view)
            }
        }
    }
    
    public init(for view: NSView) {
        self.view = view
        super.init()
    }
    
    public required init(coder: NSCoder) {
        self.view = NSView()
        super.init(coder: coder)
    }
    
    /// We forget the tracking and remove the view from any container on deinit.
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.view.removeFromSuperview()
    }
    
    public override func cellSize() -> NSSize {
        return self.view.intrinsicContentSize
    }
    
    public override func draw(withFrame cellFrame: NSRect, in controlView: NSView!) {
        if let control = controlView as? NSTextView, control != self.textView {
            self.textView = control
        }
        self.view.frame = cellFrame
    }
    
    @objc private func verifyAttached(_ note: Notification) {
        let str = (note.object as? NSTextView)?.attributedString()
        var attached = false
        
        // Enumerate all possible attributes to ensure we are attached still.
        str?.enumerateAttributes(in: NSMakeRange(0, str?.length ?? 0), options: []) {
            if let a = $0.0["NSAttachment"] as? NSTextAttachment, let cell = a.attachmentCell, cell === self {
                attached = true; $0.2.pointee = true
            }
        }
        
        // If we're not attached, make sure to remove the view from the textView.
        if !attached {
            self.view.removeFromSuperview()
        }
    }
}

public extension NSTextAttachment {
    public convenience init(attachmentCell cell: NSTextAttachmentCell) {
        self.init()
        self.attachmentCell = cell
    }
}

public extension NSAttributedString {
    public convenience init(attachmentCell cell: NSTextAttachmentCell) {
        self.init(attachment: NSTextAttachment(attachmentCell: cell))
    }
}
