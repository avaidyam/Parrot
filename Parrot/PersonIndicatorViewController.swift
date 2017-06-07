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
        return i
    }()
    
    public var person: Person? {
        return self.representedObject as? Person
    }
    
    public override var representedObject: Any? {
        didSet {
            guard let person = self.representedObject as? Person else { return }
            self.identifier = person.identifier
            //self.toolbarItem.itemIdentifier = person.identifier
            (self.view as? NSButton)?.image = person.image
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
    
    public func buttonPressed(_ sender: NSButton!) {
        print("\n\n", "This is the part where I show you a fancy contact card!", "\n\n")
        PersonIndicatorToolTipController.popover.performClose(nil)
    }
    
    public override func mouseEntered(with event: NSEvent) {
        guard let vc = PersonIndicatorToolTipController.popover.contentViewController
            as? PersonIndicatorToolTipController else { return }
        
        _ = vc.view // loadView()
        vc.text?.stringValue = self.person?.fullName ?? ""
        PersonIndicatorToolTipController.popover.show(relativeTo: view.bounds, of: view, preferredEdge: .maxY)
    }
}
