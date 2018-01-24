import Foundation
import AppKit
import Mocha
import MochaUI
import Contacts
import ContactsUI
import protocol ParrotServiceExtension.Person

// A visual representation of a Conversation in a ListView.
public class PersonCell: NSCollectionViewItem {
    
    private lazy var photoButton: NSButton = {
        let b = NSButton(title: "", target: self, action: #selector(self.showContactCard(_:))).modernize(wantsLayer: true)
        b.isBordered = false
        return b
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
    
    private var presenceSubscription: Subscription? = nil
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.view.add(subviews: self.photoButton, self.nameLabel, self.timeLabel, self.textLabel)
        
        self.photoButton.left == self.view.left + 4
        self.photoButton.centerY == self.view.centerY
        self.photoButton.width == 40
        self.photoButton.height == 40
        self.photoButton.right == self.nameLabel.left - 4
        self.photoButton.right == self.textLabel.left - 4
        self.nameLabel.top == self.view.top + 4
        self.nameLabel.right == self.timeLabel.left - 4
        self.nameLabel.bottom == self.textLabel.top - 4
        self.nameLabel.centerY == self.timeLabel.centerY
        self.timeLabel.top == self.view.top + 4
        self.timeLabel.right == self.view.right - 4
        self.timeLabel.bottom == self.textLabel.top - 4
        self.textLabel.right == self.view.right - 4
        self.textLabel.bottom == self.view.bottom - 4
        
        self.presenceSubscription = AutoSubscription(kind: Notification.Person.DidChangePresence, self.updateStatusText)
    }
    
    // Upon assignment of the represented object, configure the subview contents.
    public override var representedObject: Any? {
        didSet {
            //self.presenceSubscription?.deactivate()
            guard let person = self.representedObject as? Person else { return }
            
            var prefix = " "
            switch person.reachability {
            case .unavailable: break
            case .phone: prefix = "📱 "
            case .tablet: prefix = "📱 " //💻
            case .desktop: prefix = "🖥 "
            }
            
            self.nameLabel.stringValue = person.fullName
            self.nameLabel.toolTip = person.fullName
            self.textLabel.stringValue = person.mood
            self.textLabel.toolTip = person.mood
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
        }
    }
    
    // Return a complete dragging component for this ConversationView.
    // Note that we hide the separator and show it again after snapshot.
    public override var draggingImageComponents: [NSDraggingImageComponent] {
        return [self.view.draggingComponent("Person")]
    }
    
    // Allows the photo view's circle crop to dynamically match size.
    public override func viewDidLayout() {
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
    
    @objc private func showContactCard(_ sender: Any? = nil) {
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
    }
}
