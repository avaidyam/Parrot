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
            guard let conversation = self.representedObject as? Conversation else { return }
			
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
    
    public override var isSelected: Bool {
        didSet {
            //let appearance = self.view.appearance ?? NSAppearance.current()
            if self.isSelected {
                self.view.layer?.backgroundColor = #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1).cgColor
                self.separator?.animator().isHidden = true
            } else {
                self.view.layer?.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0).cgColor
                self.separator?.animator().isHidden = false
            }
        }
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
        self.separator?.layer?.backgroundColor = NSColor.labelColor.cgColor
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
		}
	}
    
    // TODO: not called.
    public override func preferredLayoutAttributesFitting(_ attr: NSCollectionViewLayoutAttributes) -> NSCollectionViewLayoutAttributes {
        attr.size = NSSize(width: attr.size.width, height: 64.0)
        return attr
    }
}
