<<<<<<< Updated upstream
import MochaUI
import Contacts
import ContactsUI
=======
import Foundation
import AppKit
import Mocha
import MochaUI
>>>>>>> Stashed changes
import protocol ParrotServiceExtension.Person

// A visual representation of a Conversation in a ListView.
public class PersonCell: NSCollectionViewItem {
    
<<<<<<< Updated upstream
    private lazy var photoButton: NSButton = {
        let b = NSButton(title: "", target: self, action: #selector(self.showContactCard(_:))).modernize(wantsLayer: true)
        b.isBordered = false
        return b
=======
    private lazy var photoLayer: CALayer = {
        let l = CALayer()
        l.masksToBounds = true
        return l
>>>>>>> Stashed changes
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
    
<<<<<<< Updated upstream
    private var presenceSubscription: Subscription? = nil
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.view.add(subviews: self.photoButton, self.nameLabel, self.timeLabel, self.textLabel) {
            self.photoButton.leftAnchor == self.view.leftAnchor + 4
            self.photoButton.centerYAnchor == self.view.centerYAnchor
            self.photoButton.widthAnchor == 40
            self.photoButton.heightAnchor == 40
            self.photoButton.rightAnchor == self.nameLabel.leftAnchor - 4
            self.photoButton.rightAnchor == self.textLabel.leftAnchor - 4
            self.nameLabel.topAnchor == self.view.topAnchor + 4
            self.nameLabel.rightAnchor == self.timeLabel.leftAnchor - 4
            self.nameLabel.bottomAnchor == self.textLabel.topAnchor - 4
            self.nameLabel.centerYAnchor == self.timeLabel.centerYAnchor
            self.timeLabel.topAnchor == self.view.topAnchor + 4
            self.timeLabel.rightAnchor == self.view.rightAnchor - 4
            self.timeLabel.bottomAnchor == self.textLabel.topAnchor - 4
            self.textLabel.rightAnchor == self.view.rightAnchor - 4
            self.textLabel.bottomAnchor == self.view.bottomAnchor - 4
        }
        
        self.presenceSubscription = AutoSubscription(kind: Notification.Person.DidChangePresence, self.updateStatusText)
=======
    
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
>>>>>>> Stashed changes
    }
    
    // Upon assignment of the represented object, configure the subview contents.
    public override var representedObject: Any? {
        didSet {
<<<<<<< Updated upstream
            //self.presenceSubscription?.deactivate()
            guard let person = self.representedObject as? Person else { return }
            
            var prefix = " "
            switch person.reachability {
            case .unavailable: break
            case .phone: prefix = "📱 "
            case .tablet: prefix = "📱 " //💻
            case .desktop: prefix = "🖥 "
            }
            
=======
            guard let person = self.representedObject as? Person else { return }
            
>>>>>>> Stashed changes
            self.nameLabel.stringValue = person.fullName
            self.nameLabel.toolTip = person.fullName
            self.textLabel.stringValue = person.mood
            self.textLabel.toolTip = person.mood
<<<<<<< Updated upstream
            self.timeLabel.stringValue = prefix + person.lastSeen.relativeString()
            self.timeLabel.toolTip = person.lastSeen.fullString()
            self.photoButton.image = person.image
        }
    }
    
    // When selected, ensure a selection background color.
    public override var isSelected: Bool {
        didSet {
            self.view.layer?.backgroundColor = isSelected
                ? .ns(.selectedMenuItemColor)
                : .ns(.clear)
=======
            self.timeLabel.stringValue = person.lastSeen.relativeString()
            self.timeLabel.toolTip = "\(person.lastSeen.fullString())"
            self.photoLayer.contents = person.image
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            
>>>>>>> Stashed changes
        }
    }
    
    // Return a complete dragging component for this ConversationView.
    // Note that we hide the separator and show it again after snapshot.
    public override var draggingImageComponents: [NSDraggingImageComponent] {
        return [self.view.draggingComponent("Person")]
    }
    
    // Allows the photo view's circle crop to dynamically match size.
    public override func viewDidLayout() {
<<<<<<< Updated upstream
        self.photoButton.layer!.cornerRadius = self.photoButton.frame.width / 2.0
    }
    
    private func updateStatusText(_ event: Subscription.Event) {
        guard let person = self.representedObject as? Person else { return }
        self.textLabel.stringValue = person.mood
        self.textLabel.toolTip = person.mood
        
        var prefix = " "
        switch person.reachability {
        case .unavailable: break
        case .phone: prefix = "📱 "
        case .tablet: prefix = "📱 " //💻
        case .desktop: prefix = "🖥 "
        }
        
        self.timeLabel.stringValue = prefix + person.lastSeen.relativeString()
        self.timeLabel.toolTip = person.lastSeen.fullString()
    }
    
    @objc dynamic private func showContactCard(_ sender: Any? = nil) {
        func show(_ c: CNContact) {
            let cv = CNContactViewController()
            cv.contact = c
            cv.preferredContentSize = CGSize(width: 300, height: 400)
            //guard let cell = self else { return }
            
            self.presentViewController(cv, asPopoverRelativeTo: self.photoButton.bounds,
                                       of: self.photoButton, preferredEdge: .maxX,
                                       behavior: .transient)
            
            // The VC shows up offset so it's important to adjust it.
            cv.view.frame.origin.x -= 40.0
            cv.view.frame.size.width += 52.0
        }
        
        // contact fetching first, then showing up there ^
        guard let person = self.representedObject as? Person else { return }
        let request = CNContactFetchRequest(keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        request.predicate = CNContact.predicateForContacts(matchingName: person.fullName)
        DispatchQueue.global(qos: .background).async {
            do {
                try PersonIndicatorViewController.contactStore.enumerateContacts(with: request) { c, stop in
                    stop.pointee = true
                    UI { show(c) }
                }
            } catch { }
        }
=======
        self.photoLayer.syncLayout()
        self.photoLayer.cornerRadius = self.photoLayer.frame.width / 2.0
>>>>>>> Stashed changes
    }
}
