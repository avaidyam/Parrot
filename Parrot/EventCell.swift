import MochaUI
import protocol ParrotServiceExtension.Event
import protocol ParrotServiceExtension.Voicemail
import protocol ParrotServiceExtension.VoiceCall
import protocol ParrotServiceExtension.VideoCall
import protocol ParrotServiceExtension.MembershipChanged
import protocol ParrotServiceExtension.ConversationRenamed

public class EventCell: NSCollectionViewItem {
    
    private lazy var textLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize(wantsLayer: true)
        //v.layer?.backgroundColor = .ns(.red)
        v.isEditable = false
        v.isSelectable = false
        v.drawsBackground = false
        v.backgroundColor = .clear
        v.textColor = .labelColor
        v.alignment = .center
        v.font = NSFont.from(name: .compactRoundedMedium, size: 12.0, weight: .medium)
        return v
    }()
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.view.add(subviews: self.textLabel) {
            self.view.edgeAnchors == self.textLabel.edgeAnchors
        }
    }
    
    /// Upon assignment of the represented object, configure the subview contents.
    public override var representedObject: Any? {
        didSet {
            guard let b = self.representedObject as? EventBundle else { return }
            if b.current is Voicemail {
                self.textLabel.stringValue = "Voicemail"
            } else if b.current is VoiceCall {
                self.textLabel.stringValue = "Voice Call"
            } else if b.current is VideoCall {
                self.textLabel.stringValue = "Video Call"
            } else if let c = b.current as? MembershipChanged {
                let people = c.participants.map { $0.fullName }.joined(separator: ", ")
                if let mod = c.moderator {
                    self.textLabel.stringValue = "\(mod.fullName) \(c.joined ? "added" : "removed") \(people) \(c.joined ? "to" : "from") the conversation."
                } else {
                    self.textLabel.stringValue = "\(people) \(c.joined ? "joined" : "left") the conversation."
                }
            } else if let c = b.current as? ConversationRenamed {
                self.textLabel.stringValue = "\(c.sender.fullName) renamed the conversation from \"\(c.oldValue)\" to \"\(c.newValue)\""
            } else {
                self.textLabel.stringValue = "Unknown conversation event."
            }
            self.textLabel.toolTip = "\(b.current.timestamp.fullString())"
        }
    }
    
    // Given a string, a font size, and a base width, return the measured height of the cell.
    public static func measure(_ width: CGFloat) -> CGFloat {
        return 22.0
    }
}

