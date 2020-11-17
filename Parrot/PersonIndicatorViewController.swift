<<<<<<< Updated upstream
import MochaUI
import Contacts
import ContactsUI
import ParrotServiceExtension

// away vs here == alphaValue of toolbar item
// typing == hidden value of tooltipcontroller messageprogressview

/// TODO: this class isn't very composable yet...
public class PersonIndicatorViewController: NSViewController {
    public static let contactStore = CNContactStore()
    
    public lazy var toolbarItem: NSToolbarItem = {
        assert(self.person != nil, "Cannot create a toolbar item without an assigned person!")
        let i = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: self.person!.identifier))
        i.visibilityPriority = .high
        i.view = self.view
        i.label = self.person?.fullName ?? ""
=======
import Cocoa
import Mocha
import MochaUI
import ParrotServiceExtension

//away vs here == alphaValue of toolbar item
//typing == hidden value of tooltipcontroller messageprogressview

fileprivate class PersonIndicatorToolTipController: NSViewController {
    fileprivate static var popover: NSPopover = {
        let p = NSPopover()
        p.behavior = .transient
        p.contentViewController = PersonIndicatorToolTipController()
        return p
    }()
    
    public var text: NSTextField!
    public override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
        self.text = NSTextField(labelWithString: "")
        self.text.translatesAutoresizingMaskIntoConstraints = false
        self.text.alignment = .center
        self.view.addSubview(self.text)
        
        self.text.top == self.view.top + 4.0
        self.text.bottom == self.view.bottom - 4.0
        self.text.left == self.view.left + 4.0
        self.text.right == self.view.right - 4.0
    }
}

public class PersonIndicatorViewController: NSViewController {
    
    public lazy var toolbarItem: NSToolbarItem = {
        let i = NSToolbarItem(itemIdentifier: self.identifier ?? "")
        i.visibilityPriority = NSToolbarItemVisibilityPriorityHigh
        i.view = self.view
        //i.label = $0.fullName
>>>>>>> Stashed changes
        return i
    }()
    
    public var person: Person? {
<<<<<<< Updated upstream
        didSet {
            guard self.person != nil else { return }
            self.identifier = NSUserInterfaceItemIdentifier(rawValue: self.person!.identifier)
            (self.view as? NSButton)?.image = self.person!.image
            self.cacheContact()
        }
    }
    
    private var contact: CNContact! = nil
    
    public var isDimmed: Bool = false {
        didSet {
            UI {
                self.view.animator().alphaValue = self.isDimmed ? 0.6 : 1.0
            }
=======
        return self.representedObject as? Person
    }
    
    public override var representedObject: Any? {
        didSet {
            guard let person = self.representedObject as? Person else { return }
            self.identifier = person.identifier
            //self.toolbarItem.itemIdentifier = person.identifier
            (self.view as? NSButton)?.image = person.image
>>>>>>> Stashed changes
        }
    }
    
    public override func loadView() {
        let b = NSButton(title: "", target: self, action: #selector(PersonIndicatorViewController.buttonPressed(_:)))
        b.isBordered = false
        b.wantsLayer = true
        
        b.layer!.cornerRadius = 16
        b.frame.size.width = 32
        self.view = b
    }
    
    public override func viewDidLayout() {
        self.view.trackingAreas.forEach {
            self.view.removeTrackingArea($0)
        }
        
        let trackingArea = NSTrackingArea(rect: self.view.frame,
                                          options: [.activeAlways, .mouseEnteredAndExited],
                                          owner: self, userInfo: nil)
        self.view.addTrackingArea(trackingArea)
    }
    
<<<<<<< Updated upstream
    // Cache the associated CNContact for the person.
    private func cacheContact() {
        let request = CNContactFetchRequest(keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        request.predicate = CNContact.predicateForContacts(matchingName: self.person?.fullName ?? "")
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                try PersonIndicatorViewController.contactStore.enumerateContacts(with: request) { [weak self] c, stop in
                    stop.pointee = true
                    self?.contact = c
                }
            } catch {
                self?.contact = CNContact()
            }
        }
    }
    
    @objc dynamic public func buttonPressed(_ sender: NSButton!) {
        PersonIndicatorToolTipController.popover.performClose(nil)
        
        let cv = CNContactViewController()
        cv.contact = self.contact
        cv.preferredContentSize = CGSize(width: 300, height: 400)
        self.presentViewController(cv, asPopoverRelativeTo: self.view.bounds,
                                   of: self.view, preferredEdge: .maxY,
                                   behavior: .transient)
        
        // The VC shows up offset so it's important to adjust it.
        cv.view.frame.origin.x -= 40.0
        cv.view.frame.size.width += 52.0
=======
    public func buttonPressed(_ sender: NSButton!) {
        print("\n\n", "This is the part where I show you a fancy contact card!", "\n\n")
        PersonIndicatorToolTipController.popover.performClose(nil)
>>>>>>> Stashed changes
    }
    
    public override func mouseEntered(with event: NSEvent) {
        guard let vc = PersonIndicatorToolTipController.popover.contentViewController
            as? PersonIndicatorToolTipController else { return }
        
<<<<<<< Updated upstream
        var prefix = ""
        switch self.person?.reachability ?? .unavailable {
        case .unavailable: break
        case .phone: prefix = "📱  "
        case .tablet: prefix = "📱  " //💻
        case .desktop: prefix = "🖥  "
        }
        
        _ = vc.view // loadView()
        vc.text?.stringValue = prefix + (self.person?.fullName ?? "")
        PersonIndicatorToolTipController.popover.show(relativeTo: view.bounds, of: view, preferredEdge: .maxY)
    }
    
    public override func mouseExited(with event: NSEvent) {
        PersonIndicatorToolTipController.popover.performClose(nil)
    }
=======
        _ = vc.view // loadView()
        vc.text?.stringValue = self.person?.fullName ?? ""
        PersonIndicatorToolTipController.popover.show(relativeTo: view.bounds, of: view, preferredEdge: .maxY)
    }
>>>>>>> Stashed changes
}
