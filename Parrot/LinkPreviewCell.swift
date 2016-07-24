import AppKit
import Quartz

public class LinkPreviewCell: ListViewCell, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
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
	
	public override func quickLook(with event: NSEvent) {
		log.debug("quicklook")
		QLPreviewPanel.shared().makeKeyAndOrderFront(nil)
	}
	
	public override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
		return true
	}
	
	public override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
		log.debug("looking...")
		let ql = QLPreviewPanel.shared()
		ql?.dataSource = self
		ql?.delegate = self
	}
	
	public func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
		return 1
	}
	
	public func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
		switch (self.cellValue as! LinkPreviewType) {
		case .link(let linkmeta):
			return URL(string: linkmeta.image.first ?? "")
		default: return nil
		}
	}
	
	public func previewPanel(_ panel: QLPreviewPanel!, sourceFrameOnScreenFor item: QLPreviewItem!) -> NSRect {
		return self.window!.convertToScreen(self.frame)
	}
	
	public override class func cellHeight(forWidth: CGFloat, cellValue: Any?) -> CGFloat {
		return 96
	}
}
