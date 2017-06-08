import Foundation
import AppKit
import Mocha
import MochaUI
import protocol ParrotServiceExtension.Person

// A visual representation of a Conversation in a ListView.
public class PersonCell: NSCollectionViewItem {
    
    private lazy var photoLayer: CALayer = {
        let l = CALayer()
        l.masksToBounds = true
        return l
    }()
    
    private lazy var nameLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = NSColor.labelColor
        v.font = NSFont.systemFont(ofSize: 13.0)
        return v
    }()
    
    private lazy var textLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = NSColor.secondaryLabelColor
        v.font = NSFont.systemFont(ofSize: 11.0)
        return v
    }()
    
    private lazy var timeLabel: NSTextField = {
        let v = NSTextField(labelWithString: "").modernize()
        v.textColor = NSColor.tertiaryLabelColor
        v.font = NSFont.systemFont(ofSize: 11.0)
        v.alignment = .right
        return v
    }()
    
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSVibrantView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        //self.canDrawSubviewsIntoLayer = true
        self.view.wantsLayer = true
        self.view.add(subviews: [self.nameLabel, self.timeLabel, self.textLabel])
        self.view.add(sublayer: self.photoLayer)
        
        self.photoLayer.layout.left == self.view.left + 4
        self.photoLayer.layout.centerY == self.view.centerY
        self.photoLayer.layout.width == 40
        self.photoLayer.layout.height == 40
        self.photoLayer.layout.right == self.nameLabel.left - 4
        self.photoLayer.layout.right == self.textLabel.left - 4
        self.nameLabel.top == self.view.top + 4
        self.nameLabel.right == self.timeLabel.left - 4
        self.nameLabel.bottom == self.textLabel.top - 4
        self.nameLabel.centerY == self.timeLabel.centerY
        self.timeLabel.top == self.view.top + 4
        self.timeLabel.right == self.view.right - 4
        self.timeLabel.bottom == self.textLabel.top - 4
        self.textLabel.right == self.view.right - 4
        self.textLabel.bottom == self.view.bottom - 4
    }
    
    // Upon assignment of the represented object, configure the subview contents.
    public override var representedObject: Any? {
        didSet {
            guard let person = self.representedObject as? Person else { return }
            
            self.nameLabel.stringValue = person.fullName
            self.nameLabel.toolTip = person.fullName
            self.textLabel.stringValue = person.mood
            self.textLabel.toolTip = person.mood
            self.timeLabel.stringValue = person.lastSeen.relativeString()
            self.timeLabel.toolTip = "\(person.lastSeen.fullString())"
            self.photoLayer.contents = person.image
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            
        }
    }
    
    // Return a complete dragging component for this ConversationView.
    // Note that we hide the separator and show it again after snapshot.
    public override var draggingImageComponents: [NSDraggingImageComponent] {
        return [self.view.draggingComponent("Person")]
    }
    
    // Allows the photo view's circle crop to dynamically match size.
    public override func viewDidLayout() {
        self.photoLayer.syncLayout()
        self.photoLayer.cornerRadius = self.photoLayer.frame.width / 2.0
    }
}
