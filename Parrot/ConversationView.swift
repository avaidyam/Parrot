import Cocoa
import protocol ParrotServiceExtension.Conversation

// A visual representation of a Conversation in a ListView.
public class ConversationView: ListViewCell {
	@IBOutlet private var photoView: NSImageView?
	@IBOutlet private var nameLabel: NSTextField?
	@IBOutlet private var textLabel: NSTextField?
	@IBOutlet private var timeLabel: NSTextField?
	@IBOutlet private var separator: NSView?
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var cellValue: Any? {
		didSet {
			guard let conversation = self.cellValue as? Conversation else {
				log.warning("ConversationView encountered faulty cellValue!")
				return
			}
			
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
			self.nameLabel?.stringValue = conversation.name
			self.nameLabel?.toolTip = conversation.name
			self.textLabel?.stringValue = subtitle
			self.textLabel?.toolTip = subtitle
			self.timeLabel?.stringValue = time.relativeString()
			self.timeLabel?.toolTip = "\(time.fullString())"
			
			if conversation.unreadCount > 0 {
				self.timeLabel!.textColor = #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1)
			}
		}
	}
	
	// Dynamically update the visible timestamp for the Conversation.
	var time: Date = .origin
	public func updateTimestamp() {
		self.timeLabel?.stringValue = self.time.relativeString()
	}
	
	// Return a complete dragging component for this ConversationView.
	// Note that we hide the separator and show it again after snapshot.
	public override var draggingImageComponents: [NSDraggingImageComponent] {
		self.separator?.isHidden = true
		let ret = [self.draggingComponent("Person")]
		self.separator?.isHidden = false
		return ret
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
