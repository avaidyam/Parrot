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
			
			switch preview {
			case .link(let linkmeta):
				var url = linkmeta.icon.first ?? ""
				if url.hasPrefix("//") { url = "https:\(url)" }
				if let dl = URLSession.shared().synchronousRequest(URL(string: url)!).0 {
					self.faviconView?.image = NSImage(data: dl)
				}
				
				url = linkmeta.image.first ?? ""
				if let dl = URLSession.shared().synchronousRequest(URL(string: url)!).0 {
					self.photoView?.image = NSImage(data: dl)
				}
				
				self.titleView?.stringValue = linkmeta.title.first ?? ""
				self.descView?.stringValue = linkmeta.description.first ?? ""
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
			layer.masksToBounds = true
			layer.cornerRadius = 2.0
			layer.backgroundColor = NSColor.darkOverlay(forAppearance: self.effectiveAppearance).cgColor
		}
	}
	
	public override class func cellHeight(forWidth: CGFloat, cellValue: Any?) -> CGFloat {
		return 96
	}
}
