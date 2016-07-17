import Cocoa
import protocol ParrotServiceExtension.Conversation

// A visual representation of a Conversation in a ListView.
public class ConversationView: ListViewCell {
	@IBOutlet private var photoView: NSImageView?
	@IBOutlet private var nameLabel: NSTextField?
	@IBOutlet private var textLabel: NSTextField?
	@IBOutlet private var timeLabel: NSTextField?
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var cellValue: Any? {
		didSet {
			guard let conversation = self.cellValue as? Conversation else {
				log.warning("ConversationView encountered faulty cellValue!")
				return
			}
			log.verbose("Configuring ConversationView.")
			
			let messageSender = conversation.messages.last?.sender.identifier
			let selfSender = conversation.participants.filter { $0.me }.first?.identifier
			let firstParticipant = conversation.participants.filter { !$0.me }.first!
			let photo = fetchImage(user: firstParticipant, conversation: conversation)
			// FIXME: Group conversation prefixing doesn't work yet.
			let prefix = messageSender != selfSender ? "" : "You: "
			//let prefix = conversation.users.count > 2 ? "Person: " : (messageSender != selfSender ? "" : "You: ")
			let subtitle = prefix + (conversation.messages.last?.text ?? "")
			let time = conversation.messages.last?.timestamp ?? .origin
			
			self.time = time
			self.photoView?.image = photo
			//self.photoView?.toolTip = caption
			//self.photoView?.layer?.borderColor = highlight.cgColor
			self.nameLabel?.stringValue = conversation.name
			self.nameLabel?.toolTip = conversation.name
			self.textLabel?.stringValue = subtitle
			self.textLabel?.toolTip = subtitle
			self.timeLabel?.stringValue = time.relativeString()// + (o.indicator > 0 ? " (\(o.indicator))" : "")
			self.timeLabel?.toolTip = "\(time.fullString())"
			/*//self.unreadLabel?.stringValue = "\(o.indicator)"
			self.unreadLabel?.layer?.backgroundColor = o.highlight.cgColor
			
			// Set the unread label and its spacing constraint visibility.
			self.unreadLabel?.isHidden = o.indicator <= 0
			let c = self.unreadLabel?.constraints.filter { $0.identifier == "TimeUnreadSpacing" }
			if o.indicator <= 0 {
				NSLayoutConstraint.deactivate(c ?? [])
			} else {
				NSLayoutConstraint.activate(c ?? [])
			}*/
			//self.unreadLabel?.isHidden = true
			// bold the message contents
			if let t = self.textLabel {
				t.font = NSFont.systemFont(ofSize: t.font!.pointSize,
						weight: NSFontWeightRegular)//o.indicator > 0 ? NSFontWeightBold : NSFontWeightRegular
			}
		}
	}
	
	// Dynamically update the visible timestamp for the Conversation.
	var time: Date = .origin
	public func updateTimestamp() {
		log.verbose("Updated visible timestamp for Conversation.")
		self.timeLabel?.stringValue = self.time.relativeString()
	}
	
	// Return a complete dragging component for this ConversationView.
	public override var draggingImageComponents: [NSDraggingImageComponent] {
		return [self.draggingComponent("Person")]
	}
	
	// Allows the photo view's circle crop to dynamically match size.
	public override func layout() {
		super.layout()
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
		}
	}
}
