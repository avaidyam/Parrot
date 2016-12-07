import Cocoa
import Mocha
import MochaUI
import protocol ParrotServiceExtension.Conversation

/* TODO: Selection: Overlay with NSVisualEffectView per-cell. */
/* TODO: Alternate mode with Card UI. */

// A visual representation of a Conversation in a ListView.
public class ConversationCell: NSTableCellView, NSTableViewCellProtocol {
    
    private static var wallclock = Wallclock()
    private var id = UUID() // for wallclock
    
	@IBOutlet private var photoView: NSImageView?
	@IBOutlet private var nameLabel: NSTextField?
	@IBOutlet private var textLabel: NSTextField?
    @IBOutlet private var timeLabel: NSTextField?
    @IBOutlet private var effect: NSVisualEffectView?
	@IBOutlet private var separator: NSView?
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: Any? {
		didSet {
            guard let conversation = self.objectValue as? Conversation else { return }
			
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
            
			if conversation.unreadCount > 0 && (messageSender != selfSender) {
				self.timeLabel?.textColor = #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1)
            } else {
                self.timeLabel?.textColor = .tertiaryLabelColor
            }
		}
	}
	
	// Dynamically update the visible timestamp for the Conversation.
	private var time: Date = .origin
	private var prefix = " "
	public func updateTimestamp() {
		self.timeLabel?.stringValue = self.prefix + self.time.relativeString()
	}
    
    public var isSelected: Bool = false {
        didSet {
            //let appearance = self.view.appearance ?? NSAppearance.current()
            if self.isSelected {
                //self.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
                //self.view.layer?.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.1997270976).cgColor
                //self.effect?.animator().isHidden = false
                //self.separator?.animator().isHidden = true
            } else {
                //self.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
                //self.view.layer?.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0).cgColor
                //self.effect?.animator().isHidden = true
                //self.separator?.animator().isHidden = false
            }
        }
    }
    
    public override func menu(for event: NSEvent) -> NSMenu? {
        guard var conversation = self.objectValue as? Conversation else { return nil }
        let m = NSMenu(title: "Settings")
        m.addItem(title: conversation.muted ? "Unmute" : "Mute") {
            log.info("Mute conv: \(conversation.identifier)")
            conversation.muted = !conversation.muted
        }
        m.addItem(title: "Block") {
            log.info("Block conv: \(conversation.identifier)")
            //conversation.participants.first?.blocked = true
        }
        m.addItem(NSMenuItem.separator())
        m.addItem(title: "Delete") {
            log.info("Delete conv: \(conversation.identifier)")
            //conversation.delete()
        }
        m.addItem(title: "Archive") {
            log.info("Archive conv: \(conversation.identifier)")
            //conversation.move(to: .archive)
        }
        return m
        //m.popUp(positioning: nil, at: self.convert(event.locationInWindow, from: nil), in: self)
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
        self.separator?.layer?.backgroundColor = NSColor.labelColor.cgColor
		if let photo = self.photoView, let layer = photo.layer {
			layer.masksToBounds = true
			layer.cornerRadius = photo.bounds.width / 2.0
		}
	}
    
    public override func viewDidMoveToSuperview() {
        if let _ = self.superview { // onscreen
            ConversationCell.wallclock.add(target: (self, self.id, self.updateTimestamp))
        } else { // offscreen
            ConversationCell.wallclock.remove(target: (self, self.id, self.updateTimestamp))
        }
    }
}
