import AppKit
import MochaUI

public class WatermarkCell: NSTableCellView {
    
    private lazy var photoView: NSImageView = {
        let v = NSImageView().modernize()
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var textLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = NSColor.labelColor
        v.font = NSFont.systemFont(ofSize: 13.0)
        return v
    }()
    
    // Set up constraints after init.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareLayout()
    }
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        prepareLayout()
    }
    
    // Constraint setup here.
    private func prepareLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        self.add(subviews: [self.photoView, self.textLabel])
        
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
            log.debug("got objectValue \(String(describing: self.objectValue))")
        }
    }
}
