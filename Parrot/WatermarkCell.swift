import AppKit
import MochaUI

public class WatermarkCell: NSTableCellView {
    @IBOutlet var photoView: NSImageView?
    @IBOutlet var textLabel: NSTextField?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override var objectValue: Any? {
        didSet {
            log.debug("got objectValue \(self.objectValue)")
        }
    }
}
