import Cocoa
import Hangouts

class ConversationListItemView : NSTableCellView {
	
	// Create and cache the default image template.
	private static let defaultImage = NSImage(named: "NSUserGuest")
	
	@IBOutlet weak var photoView: NSImageView!
	@IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var textLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
	
	override var objectValue: AnyObject? {
		didSet {
			guard let conversation = self.objectValue as? Conversation else {
				return
			}
			
			// Mask the photo layer as a circle to match Hangouts.
			/*self.photoView?.wantsLayer = true
			if let layer = self.photoView?.layer {
				layer.borderWidth = 0.0
				layer.cornerRadius = layer.bounds.width / 2.0
				layer.masksToBounds = true
			}*/
			
			// Get the first image for the users in the conversation to display.
			// If we don't have an image, use a template image.
			let otherUsers = conversation.users.filter { !$0.isSelf }
			if let user = otherUsers.first {
				ImageCache.sharedInstance.fetchImage(forUser: user) {
					self.photoView?.image = $0 ?? ConversationListItemView.defaultImage
				}
			} else {
				self.photoView?.image = ConversationListItemView.defaultImage
			}
			
			self.nameLabel?.stringValue = conversation.name
			
			let a = conversation.messages.last?.user_id
			let b = conversation.users.filter { $0.isSelf }.first?.id
			if a != b {
				self.textLabel.stringValue = conversation.messages.last?.text ?? ""
				
				if conversation.hasUnreadEvents {
					self.textLabel.font = NSFont.boldSystemFontOfSize(self.textLabel.font!.pointSize)
				} else {
					self.textLabel.font = NSFont.systemFontOfSize(self.textLabel.font!.pointSize)
				}
			} else {
				self.textLabel.stringValue = "You: " + (conversation.messages.last?.text ?? "")
			}
			
			self.timeLabel.stringValue = conversation.messages.last?.timestamp.timeAgo() ?? ""
		}
	}
	
	override var backgroundStyle: NSBackgroundStyle {
		didSet {
			Swift.print("backgroundStyle \(self.backgroundStyle.rawValue)")
		}
	}
	
	override var rowSizeStyle: NSTableViewRowSizeStyle {
		didSet {
			Swift.print("rowSizeStyle \(self.rowSizeStyle.rawValue)")
		}
	}
	
	override var draggingImageComponents: [NSDraggingImageComponent] {
		get {
			Swift.print("dragging!")
			return []
		}
	}
}