import Cocoa
import Hangouts

class ConversationListItemView : NSTableCellView {
	
	// Create and cache the default image template.
	private static let defaultImage = NSImage(named: "NSUserGuest")
	
	// Default colors for both GVoice and Hangouts.
	private static let GVoiceColor = NSColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.0)
	private static let HangoutsColor = NSColor(red: 0.31, green: 0.63, blue: 0.25, alpha: 1.0)
	
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
			
			// Mask the photo layer as a circle to match Hangouts.
			self.photoView.layer?.masksToBounds = true
			self.photoView.layer?.borderWidth = 2.0
			
			// Show different rings based on network (Hangouts vs. GVoice)
			let layer = self.photoView?.layer
			if conversation.conversation.network_type?[0] as? Int == 2 {
				layer?.borderColor = ConversationListItemView.GVoiceColor.CGColor
			} else {
				layer?.borderColor = ConversationListItemView.HangoutsColor.CGColor
			}
			
			// Get the first image for the users in the conversation to display.
			// If we don't have an image, use a template image.
			Dispatch.main().run {
				if let user = c {
					ImageCache.sharedInstance.fetchImage(forUser: user) {
						self.photoView?.image = $0 ?? ConversationListItemView.defaultImage
					}
				} else {
					self.photoView?.image = ConversationListItemView.defaultImage
				}
			}
			
			// Patch for Google Voice contacts to show their numbers.
			// FIXME: Sometimes [1] is actually you, fix that.
			var title = conversation.name
			if title == "Unknown" {
				if let a = conversation.conversation.participant_data[1].fallback_name {
					title = a as String
				}
			}
			self.nameLabel?.stringValue = title
			
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
				_component(self.photoView, key: "Photo"),
				_component(self.nameLabel, key: "Name"),
				_component(self.textLabel, key: "Text"),
				_component(self.timeLabel, key: "Time"),
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
	
	// Automatically translate a subview into a NSDraggingImageComponent
	private func _component(view: NSView, key: String) -> NSDraggingImageComponent {
		var viewBounds = view.bounds
		let imageRep = view.bitmapImageRepForCachingDisplayInRect(viewBounds)
		view.cacheDisplayInRect(viewBounds, toBitmapImageRep: imageRep!)
		let draggedImage = NSImage(size: imageRep!.size)
		draggedImage.addRepresentation(imageRep!)
		viewBounds = self.convertRect(viewBounds, fromView: view)
		let component = NSDraggingImageComponent(key: key)
		component.contents = draggedImage
		component.frame = viewBounds
		return component
	}
}
