import Cocoa
import protocol ParrotServiceExtension.Conversation

// A visual representation of a Conversation in a ListView.
public class ConversationCell: ListViewCell {
	@IBOutlet private var photoView: NSImageView?
	@IBOutlet private var nameLabel: NSTextField?
	@IBOutlet private var textLabel: NSTextField?
	@IBOutlet private var timeLabel: NSTextField?
	@IBOutlet private var separator: NSView?
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var representedObject: Any? {
		didSet {
            guard self.representedObject != nil else {
                return // the cell is being reset
            }
			guard let conversation = self.representedObject as? Conversation else {
				log.warning("ConversationCell encountered faulty cellValue! \(self.representedObject)")
				return
			}
			
			let messageSender = conversation.messages.last?.sender?.identifier ?? ""
			let selfSender = conversation.participants.filter { $0.me }.first?.identifier
			if let firstParticipant = (conversation.participants.filter { !$0.me }.first) {
				let photo = fetchImage(user: firstParticipant, conversation: conversation)
				self.photoView?.image = photo
			}
			// FIXME: Group conversation prefixing doesn't work yet.
			self.prefix = messageSender != selfSender ? "↙ " : "↗ "
			//let prefix = conversation.users.count > 2 ? "Person: " : (messageSender != selfSender ? "" : "You: ")
			let subtitle = (conversation.messages.last?.text ?? "")
			let time = conversation.messages.last?.timestamp ?? .origin
			
			self.time = time
			self.nameLabel?.stringValue = conversation.name
			self.nameLabel?.toolTip = conversation.name
			self.textLabel?.stringValue = subtitle
			self.textLabel?.toolTip = subtitle
			self.timeLabel?.stringValue = self.prefix + time.relativeString()
			self.timeLabel?.toolTip = "\(time.fullString())"
            
            //self.view.canDrawSubviewsIntoLayer = true
			
			if conversation.unreadCount > 0 {
				self.timeLabel?.textColor = #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1)
			}
		}
	}
	
	// Dynamically update the visible timestamp for the Conversation.
	private var time: Date = .origin
	private var prefix = " "
	public func updateTimestamp() {
		self.timeLabel?.stringValue = self.prefix + self.time.relativeString()
	}
	
	// Return a complete dragging component for this ConversationView.
	// Note that we hide the separator and show it again after snapshot.
	public override var draggingImageComponents: [NSDraggingImageComponent] {
		self.separator?.isHidden = true
		let ret = [self.view.draggingComponent("Person")]
		self.separator?.isHidden = false
		return ret
	}
	
    
	// Allows the photo view's circle crop to dynamically match size.
	public override func viewWillLayout() {
		super.viewWillLayout()
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
		}
	}
}
