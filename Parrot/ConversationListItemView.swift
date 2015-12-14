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
			self.photoView?.wantsLayer = true
			self.photoView?.layer?.masksToBounds = true
			self.photoView?.layer?.borderWidth = 2.0
			
			// Show different rings based on network (Hangouts vs. GVoice)
			let layer = self.photoView?.layer
			if conversation.conversation.network_type?[0] as? Int == 2 {
				layer?.borderColor = NSColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.0).CGColor
			} else {
				layer?.borderColor = NSColor(red: 0.31, green: 0.63, blue: 0.25, alpha: 1.0).CGColor
			}
			
			// Get the first image for the users in the conversation to display.
			// If we don't have an image, use a template image.
			let otherUsers = conversation.users.filter { !$0.isSelf }
			
			NSOperationQueue.mainQueue().addOperationWithBlock { 
				if let user = otherUsers.first {
					ImageCache.sharedInstance.fetchImage(forUser: user) {
						self.photoView?.image = $0 ?? ConversationListItemView.defaultImage
					}
				} else {
					self.photoView?.image = ConversationListItemView.defaultImage
				}
			}
			
			// Patch for Google Voice contacts to show their numbers.
			var title = conversation.name
			if title == "Unknown" {
				if let a = conversation.conversation.participant_data[1].fallback_name {
					title = a as String
				}
			}
			self.nameLabel?.stringValue = title
			
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
			//Swift.print("backgroundStyle \(self.backgroundStyle.rawValue)")
		}
	}
	
	override var rowSizeStyle: NSTableViewRowSizeStyle {
		didSet {
			//Swift.print("rowSizeStyle \(self.rowSizeStyle.rawValue)")
		}
	}
	
	override var draggingImageComponents: [NSDraggingImageComponent] {
		get {
			//Swift.print("dragging!")
			return []
		}
	}
	
	// Allows the circle crop to dynamically change.
	override func layout() {
		super.layout()
		if let layer = self.photoView?.layer {
			layer.cornerRadius = self.photoView!.bounds.width / 2.0
		}
	}
}