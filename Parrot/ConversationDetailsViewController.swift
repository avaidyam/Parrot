import MochaUI
import ParrotServiceExtension

/* TODO: Requires Observables & EventBus built on NotificationCenter...? */

public class ConversationDetailsViewController: NSViewController {
    
    // Internally used to identify different controls on action sent.
    private enum Tags: Int {
        case mute, block, archive, delete
    }
    
    public var conversation: Conversation? {
        get { return representedObject as? Conversation }
        set { self.representedObject = newValue }
    }
    
    private lazy var muteButton: NSButton = {
        let v = LayerButton(title: "Mute", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Unmute"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedSquare
        v.imageHugsTitle = true
        v.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        
        v.setButtonType(.pushOnPushOff)
        v.state = .off
        v.tag = Tags.mute.rawValue
        return v
    }()
    
    private lazy var blockButton: NSButton = {
        let v = LayerButton(title: "Block", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Unblock"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedSquare
        v.imageHugsTitle = true
        v.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        
        v.setButtonType(.pushOnPushOff)
        v.state = .off
        v.tag = Tags.block.rawValue
        return v
    }()
    
    private lazy var archiveButton: NSButton = {
        let v = LayerButton(title: "Archive", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Unarchive"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedSquare
        v.imageHugsTitle = true
        v.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        
        v.setButtonType(.pushOnPushOff)
        v.state = .off
        v.tag = Tags.archive.rawValue
        return v
    }()
    
    private lazy var deleteButton: NSButton = {
        let v = LayerButton(title: "Delete", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Undelete"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedSquare
        v.imageHugsTitle = true
        v.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        
        v.setButtonType(.pushOnPushOff)
        v.state = .off
        v.tag = Tags.delete.rawValue
        return v
    }()
    
    public override var representedObject: Any? {
        didSet {
            self.muteButton.state = self.conversation?.muted ?? false ? .on : .off
            self.blockButton.state = self.conversation?.participants.first { !$0.me }?.blocked ?? false ? .on : .off
            self.archiveButton.state = self.conversation?.archived ?? false ? .on : .off
            // self.deleteButton.state = ... // can't be seeing this if the conv is deleted!
        }
    }
    
    public override func loadView() {
        let stack: NSStackView = NSStackView(views: [
            self.muteButton,
            self.blockButton,
            self.archiveButton,
            self.deleteButton
        ]).modernize()
        
        stack.edgeInsets = NSEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        stack.spacing = 8.0
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.distribution = .fillEqually
        self.view = stack
    }
    
    @objc private func buttonAction(_ sender: Any?) {
        guard   let conversation = self.conversation,
                let button = sender as? NSButton,
                let tag = Tags(rawValue: button.tag)
        else { return }
        
        switch tag {
        case .mute:
            log.info("Mute [conv: \(conversation.identifier)]")
            conversation.muted = button.state == .on
        case .block:
            log.info("Block [conv: \(conversation.identifier)]")
            conversation.participants.first { !$0.me }?.blocked = button.state == .on
        case .archive:
            log.info("Archive [conv: \(conversation.identifier)]")
            conversation.archived = button.state == .on
            //conversation.move(to: .archive)
        case .delete:
            log.info("Delete [conv: \(conversation.identifier)]")
            conversation.leave()
        }
    }
    
    public static func menu(for conversation: Conversation) -> NSMenu? {
        let person = conversation.participants.first { !$0.me }
        let m = NSMenu(title: "Settings")
        m.addItem(title: conversation.muted ? "Unmute" : "Mute") {
            log.info("Mute [conv: \(conversation.identifier)]")
            conversation.muted = !conversation.muted
        }
        m.addItem(title: person?.blocked ?? false ? "Unblock" : "Block") {
            log.info("Block [conv: \(conversation.identifier)]")
            person?.blocked = !(person?.blocked ?? false)
        }
        m.addItem(NSMenuItem.separator())
        m.addItem(title: conversation.archived ? "Unarchive" : "Archive") {
            log.info("Archive [conv: \(conversation.identifier)]")
            conversation.archived = !conversation.archived
            //conversation.move(to: .archive)
        }
        m.addItem(title: "Delete") {
            log.info("Delete [conv: \(conversation.identifier)]")
            conversation.leave()
        }
        return m
    }
    
    @IBAction func colorChanged(_ sender: AnyObject?) {
        /*if let well = sender as? NSColorWell, well.identifier == "MyBubbleColor" {
         
         } else if let well = sender as? NSColorWell, well.identifier == "TheirBubbleColor" {
         
         } else if let img = sender as? NSImageView, img.identifier == "BackgroundImage" {
         
         }*/
        
        Subscription.Event(name: .conversationAppearanceUpdated, object: self).post()
    }
    
    /*@IBAction public func colorWellSelected(_ sender: AnyObject?) {
     guard let sender = sender as? NSColorWell else { return }
     publish(Notification(name: Notification.Name("_ColorChanged")))
     }*/
    
    // TODO:
    //
    // notification: ?
    // sound: ?
    // vibrate: ?
    //
    // outcolor: com.avaidyam.Parrot.ConversationOutgoingColor
    // incolor: com.avaidyam.Parrot.ConversationIncomingColor
    // bgimage: Parrot.ConversationBackground
}
