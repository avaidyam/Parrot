import Foundation
import AppKit
import Mocha
import MochaUI
import protocol ParrotServiceExtension.Message
import protocol ParrotServiceExtension.Conversation

/* TODO: Selection: Overlay with NSVisualEffectView per-cell. */
/* TODO: Alternate mode with Card UI. */
/* TODO: Make canDrawSubviewsIntoLayer work better. */

// A visual representation of a Conversation in a ListView.
public class ConversationCell: NSTableCellView, NSTableViewCellProtocol {
    
    public override var allowsVibrancy: Bool { return true }
    
    private static var wallclock = Wallclock()
    private var id = UUID() // for wallclock
    
    private lazy var photoView: NSImageView = {
        return self.prepare(NSImageView(frame: NSZeroRect)) { v in
            v.allowsCutCopyPaste = false
            v.isEditable = false
            v.animates = true
        }
    }()
    
    private lazy var nameLabel: NSTextField = {
        return self.prepare(NSTextField(labelWithString: "")) { v in
            v.textColor = NSColor.labelColor
            v.font = NSFont.systemFont(ofSize: 13.0)
        }
    }()
    
    private lazy var textLabel: NSTextField = {
        return self.prepare(NSTextField(labelWithString: "")) { v in
            v.textColor = NSColor.secondaryLabelColor
            v.font = NSFont.systemFont(ofSize: 11.0)
            v.usesSingleLineMode = false
            v.lineBreakMode = .byWordWrapping
        }
    }()
    
    private lazy var timeLabel: NSTextField = {
        return self.prepare(NSTextField(labelWithString: "")) { v in
            v.textColor = NSColor.tertiaryLabelColor
            v.font = NSFont.systemFont(ofSize: 11.0)
            v.alignment = .right
        }
    }()
    
    // Set up constraints after init.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareLayout()
    }
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        prepareLayout()
    }
    
    // Constraint setup here.
    private func prepareLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.canDrawSubviewsIntoLayer = true
        self.wantsLayer = true
        
        self.photoView.left == self.left + 8
        self.photoView.centerY == self.centerY
        self.photoView.width == 48
        self.photoView.height == 48
        self.photoView.right == self.nameLabel.left - 8
        self.photoView.right == self.textLabel.left - 8
        self.nameLabel.top == self.top + 8
        self.nameLabel.right == self.timeLabel.left - 4
        self.nameLabel.bottom == self.textLabel.top - 4
        self.nameLabel.centerY == self.timeLabel.centerY
        self.timeLabel.top == self.top + 8
        self.timeLabel.right == self.right - 8
        self.timeLabel.bottom == self.textLabel.top - 4
        self.textLabel.right == self.right - 8
        self.textLabel.bottom == self.bottom - 8
    }
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: Any? {
		didSet {
            guard let conversation = self.objectValue as? Conversation else { return }
			
			let messageSender = conversation.eventStream.last?.sender?.identifier ?? ""
			let selfSender = conversation.participants.filter { $0.me }.first?.identifier
			if let firstParticipant = (conversation.participants.filter { !$0.me }.first) {
				let photo = fetchImage(user: firstParticipant, monogram: true)
				self.photoView.image = photo
			}
			// FIXME: Group conversation prefixing doesn't work yet.
			self.prefix = messageSender != selfSender ? "↙ " : "↗ "
			//let prefix = conversation.users.count > 2 ? "Person: " : (messageSender != selfSender ? "" : "You: ")
            let _m = conversation.eventStream.last as? Message
			let subtitle = (_m?.text ?? "")
			let time = conversation.eventStream.last?.timestamp ?? .origin
			
			self.time = time
			self.nameLabel.stringValue = conversation.name
			self.nameLabel.toolTip = conversation.name
			self.textLabel.stringValue = subtitle
			self.textLabel.toolTip = subtitle
			self.timeLabel.stringValue = self.prefix + time.relativeString()
			self.timeLabel.toolTip = "\(time.fullString())"
            
			if conversation.unreadCount > 0 && (messageSender != selfSender) {
				self.timeLabel.textColor = #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1)
            } else {
                self.timeLabel.textColor = .tertiaryLabelColor
            }
		}
	}
	
	// Dynamically update the visible timestamp for the Conversation.
	private var time: Date = .origin
	private var prefix = " "
	public func updateTimestamp() {
		self.timeLabel.stringValue = self.prefix + self.time.relativeString()
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
		return [self.draggingComponent("Person")]
	}
	
	// Allows the photo view's circle crop to dynamically match size.
	public override func layout() {
		super.layout()
		if let layer = self.photoView.layer {
			layer.masksToBounds = true
			layer.cornerRadius = self.photoView.bounds.width / 2.0
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
