import Foundation
import AppKit
import Mocha
import MochaUI
import protocol ParrotServiceExtension.Message
import protocol ParrotServiceExtension.Conversation

/* TODO: Selection: Overlay with NSVisualEffectView per-cell. */
/* TODO: Alternate mode with Card UI. */

// A visual representation of a Conversation in a ListView.
public class ConversationCell: NSCollectionViewItem {
    
    private static var wallclock = Wallclock()
    private var id = UUID() // for Wallclock
    
    private lazy var photoLayer: CALayer = {
        let l = CALayer()
        l.shadowRadius = 4
        l.shadowOpacity = 0.25
        l.shadowColor = NSColor.black.cgColor
        l.shadowOffset = CGSize(width: 0, height: 0)
        
        let s = CALayer()
        s.masksToBounds = true
        s.cornerRadius = 8.0
        s.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
        l.addSublayer(s)
        return l
    }()
    
    private lazy var badgeLayer: CALayer = {
        let l = CATextLayer()
        l.masksToBounds = true
        l.backgroundColor = NSColor.selectedMenuItemColor.cgColor
        l.foregroundColor = NSColor.white.cgColor
        l.fontSize = 9.0
        l.string = "1"
        return l
    }()
    
    private lazy var nameLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = NSColor.labelColor
        v.font = NSFont.systemFont(ofSize: 13.0, weight: NSFont.Weight.semibold)
        v.lineBreakMode = .byTruncatingTail
        
        v.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
        return v
    }()
    
    private lazy var textLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = NSColor.secondaryLabelColor
        v.font = NSFont.systemFont(ofSize: 11.0)
        v.usesSingleLineMode = false
        v.lineBreakMode = .byWordWrapping
        return v
    }()
    
    private lazy var timeLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = NSColor.tertiaryLabelColor
        v.font = NSFont.systemFont(ofSize: 11.0, weight: NSFont.Weight.light)
        v.alignment = .right
        
        v.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        return v
    }()
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSVibrantView()
        self.view.wantsLayer = true
        self.view.add(subviews: [self.nameLabel, self.timeLabel, self.textLabel])
        self.view.add(sublayer: self.photoLayer)
        //self.view.add(sublayer: self.badgeLayer) // will not participate in autolayout
        
        self.photoLayer.layout.left == self.view.left + 8
        self.photoLayer.layout.centerY == self.view.centerY
        self.photoLayer.layout.width == 48
        self.photoLayer.layout.height == 48
        self.photoLayer.layout.right == self.nameLabel.left - 8
        self.photoLayer.layout.right == self.textLabel.left - 8
        self.nameLabel.top == self.view.top + 8
        self.nameLabel.right == self.timeLabel.left - 4
        self.nameLabel.bottom == self.textLabel.top - 4
        self.nameLabel.centerY == self.timeLabel.centerY
        self.timeLabel.top == self.view.top + 8
        self.timeLabel.right == self.view.right - 8
        self.timeLabel.bottom == self.textLabel.top - 4
        self.textLabel.right == self.view.right - 8
        self.textLabel.bottom == self.view.bottom - 8
    }
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var representedObject: Any? {
		didSet {
            guard let conversation = self.representedObject as? Conversation else { return }
			
			let messageSender = conversation.eventStream.last?.sender?.identifier ?? ""
			let selfSender = conversation.participants.filter { $0.me }.first?.identifier
			if let firstParticipant = (conversation.participants.filter { !$0.me }.first) {
                self.photoLayer.sublayers?[0].contents = firstParticipant.image
			}
			self.prefix = messageSender != selfSender ? "↙ " : "↗ "
			let subtitle = ((conversation.eventStream.last as? Message)?.text ?? "")
			let time = conversation.eventStream.last?.timestamp ?? .origin
			
			self.time = time
			self.nameLabel.stringValue = conversation.name
			self.nameLabel.toolTip = conversation.name
			self.textLabel.stringValue = subtitle
			self.textLabel.toolTip = subtitle
			self.timeLabel.stringValue = self.prefix + time.relativeString()
			self.timeLabel.toolTip = time.fullString()
            
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
    
    public override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            if self.highlightState != .none {
                self.view.layer?.backgroundColor = NSColor.selectedMenuItemColor.cgColor
            } else {
                self.view.layer?.backgroundColor = NSColor.clear.cgColor
            }
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            //let appearance = self.view.appearance ?? NSAppearance.current()
            if self.isSelected {
                self.view.layer?.backgroundColor = NSColor.selectedMenuItemColor.cgColor
                //self.appearance = .light
                //self.view.layer?.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.1997270976).cgColor
                //self.effect?.animator().isHidden = false
                //self.separator?.animator().isHidden = true
            } else {
                self.view.layer?.backgroundColor = NSColor.clear.cgColor
                //self.appearance = .dark
                //self.view.layer?.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0).cgColor
                //self.effect?.animator().isHidden = true
                //self.separator?.animator().isHidden = false
            }
        }
    }
    
    public func menu(for event: NSEvent) -> NSMenu? {
        guard var conversation = self.representedObject as? Conversation else { return nil }
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
		return [self.view.draggingComponent("Person")]
	}
	
	// Allows the photo view's circle crop to dynamically match size.
	public override func viewDidLayout() {
        let p = self.photoLayer, b = self.badgeLayer
        p.syncLayout()
        b.frame = NSRect(x: p.frame.minX, y: p.frame.midY, width: p.frame.width / 2, height: p.frame.width / 2).insetBy(dx: 4.0, dy: 4.0)
        self.photoLayer.sublayers?[0].cornerRadius = p.frame.width / 2.0
        b.cornerRadius = b.frame.width / 2.0
	}
    
    public override func viewDidAppear() {
        ConversationCell.wallclock.add(target: (self, self.id, self.updateTimestamp))
    }
    
    public override func viewDidDisappear() {
        ConversationCell.wallclock.remove(target: (self, self.id, self.updateTimestamp))
    }
}

public class NSVibrantView: NSView {
    public override var allowsVibrancy: Bool {
        return true
    }
}
