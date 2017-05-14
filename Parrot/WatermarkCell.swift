import AppKit
import MochaUI

public class WatermarkCell: NSTableCellView {
    
    private lazy var photoView: NSImageView = {
        return self.prepare(NSImageView(frame: NSZeroRect)) { v in
            v.allowsCutCopyPaste = false
            v.isEditable = false
            v.animates = true
        }
    }()
    
    private lazy var textLabel: NSTextField = {
        return self.prepare(NSTextField(labelWithString: "")) { v in
            v.textColor = NSColor.labelColor
            v.font = NSFont.systemFont(ofSize: 13.0)
        }
    }()
    
    // Set up constraints after init.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        prepareLayout()
    }
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        prepareLayout()
    }
    
    // Constraint setup here.
    private func prepareLayout() {
        self.height == 32.0
        self.photoView.width == 24.0
        self.photoView.height == 24.0
        self.photoView.left == self.left + 8.0
        self.photoView.centerY == self.centerY
        self.textLabel.left == self.photoView.right + 8.0
        //self.textLabel.right == self.right - 8.0
        self.textLabel.centerY == self.centerY
    }
    
    public override var objectValue: Any? {
        didSet {
            log.debug("got objectValue \(self.objectValue)")
        }
    }
}
