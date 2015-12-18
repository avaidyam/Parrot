import Cocoa
import Hangouts

/* TODO: Support stickers, photos, videos, files, audio, and location. */

// Create and cache the default image template.
private let defaultImage = NSImage(named: "NSUserGuest")

// Default colors for both GVoice and Hangouts.
private let GVoiceColor = NSColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.0)
private let HangoutsColor = NSColor(red: 0.31, green: 0.63, blue: 0.25, alpha: 1.0)

class ConversationListItemView : NSTableCellView {
	
	@IBOutlet weak var photoView: NSImageView!
	@IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var textLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
	
	// Upon assignment of the represented object, configure the subview contents.
	override var objectValue: AnyObject? {
		didSet {
			guard let conversation = self.objectValue as? Conversation else {
				return
			}
			
			// Propogate info for data filling
			let a = conversation.messages.last?.user_id
			let b = conversation.users.filter { $0.isSelf }.first?.id
			let c = conversation.users.filter { !$0.isSelf }.first
			let d = conversation.conversation.network_type?[0] as? Int
			
			// Mask the photo layer as a circle to match Hangouts.
			self.photoView.layer?.masksToBounds = true
			self.photoView.layer?.borderWidth = 2.0
			
			// Patch for Google Voice contacts to show their numbers.
			// FIXME: Sometimes [1] is actually you, fix that.
			var title = conversation.name
			if title == "Unknown" {
				if let a = conversation.conversation.participant_data[1].fallback_name {
					title = a as String
				}
			}
			
			// Load all the field values from the conversation.
			ImageCache.sharedInstance.fetchImage(forUser: c) {
				self.photoView?.image = $0 ?? defaultImage
			}
			self.photoView?.layer?.borderColor = d == 2 ? GVoiceColor.CGColor : HangoutsColor.CGColor
			self.textLabel.font = NSFont.systemFontOfSize(self.textLabel.font!.pointSize,
				weight: conversation.hasUnreadEvents ? NSFontWeightBold : NSFontWeightRegular)
			
			self.nameLabel?.stringValue = title
			self.textLabel.stringValue = (a != b ? "" : "You: ") + (conversation.messages.last?.text ?? "")
			self.timeLabel.stringValue = conversation.messages.last?.timestamp.relativeString() ?? ""
		}
	}
	
	// Upon selection, make all the text visible, and restore it when unselected.
	override var backgroundStyle: NSBackgroundStyle {
		didSet {
			if self.backgroundStyle == .Light {
				self.nameLabel.textColor = NSColor.labelColor()
				self.textLabel.textColor = NSColor.secondaryLabelColor()
				self.timeLabel.textColor = NSColor.tertiaryLabelColor()
			} else if self.backgroundStyle == .Dark {
				self.nameLabel.textColor = NSColor.alternateSelectedControlTextColor()
				self.textLabel.textColor = NSColor.alternateSelectedControlTextColor()
				self.timeLabel.textColor = NSColor.alternateSelectedControlTextColor()
			}
		}
	}
	
	// Dynamically adjust subviews based on the indicated row size.
	// Technically should be unimplemented, as AutoLayout does this for free.
	override var rowSizeStyle: NSTableViewRowSizeStyle {
		didSet {
			// FIXME: What do we do here??
		}
	}
	
	// Return an array of all dragging components corresponding to our subviews.
	override var draggingImageComponents: [NSDraggingImageComponent] {
		get {
			return [
				self.photoView.draggingComponent("Photo"),
				self.nameLabel.draggingComponent("Name"),
				self.textLabel.draggingComponent("Text"),
				self.timeLabel.draggingComponent("Time"),
			]
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
