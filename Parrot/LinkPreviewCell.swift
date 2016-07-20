import AppKit

public class LinkPreviewCell: ListViewCell {
	@IBOutlet var faviconView: NSImageView?
	@IBOutlet var titleView: NSTextField?
	@IBOutlet var descView: NSTextField?
	@IBOutlet var photoView: NSImageView?
	
	public override var cellValue: Any? {
		didSet {
			guard let preview = self.cellValue as? LinkPreviewType else {
				log.warning("LinkPreviewCell encountered faulty cellValue!")
				return
			}
			
			self.layer?.backgroundColor = NSColor.red().cgColor
			
			switch preview {
			case .link(let linkmeta):
				log.info("meta: \(linkmeta)")
				
				self.titleView?.stringValue = linkmeta.title[0]
				self.descView?.stringValue = linkmeta.description[0]
				//self.faviconView?.image = linkmeta.icon[0]
				//self.photoView?.image = linkmeta.image[0]
			default:
				log.warning("LinkPreviewCell only supports Links!")
			}
		}
	}
	
	// Allows the circle crop to dynamically change.
	public override func layout() {
		super.layout()
		if let layer = self.faviconView?.layer {
			layer.masksToBounds = true
			layer.cornerRadius = layer.bounds.width / 2.0
		}
		if let text = self.descView, let layer = text.layer {
			
			// Only clip the text if the text isn't purely Emoji.
			layer.masksToBounds = true
			layer.cornerRadius = 2.0
			layer.backgroundColor = NSColor.darkOverlay(forAppearance: self.effectiveAppearance).cgColor
		}
	}
	
	public override class func cellHeight(forWidth: CGFloat, cellValue: Any?) -> CGFloat {
		return 96
	}
}
