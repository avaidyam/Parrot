import MochaUI
import ParrotServiceExtension

// TODO:
//
// notification: ?
// sound: ?
// vibrate: ?
//
// outcolor: com.avaidyam.Parrot.ConversationOutgoingColor
// incolor: com.avaidyam.Parrot.ConversationIncomingColor
// bgimage: Parrot.ConversationBackground

fileprivate let _clearColor = NSColor(genericGamma22White: 0, alpha: 0)

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
                         action: #selector(self.buttonAction(_:))).modernize()
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
                         action: #selector(self.buttonAction(_:))).modernize()
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
                         action: #selector(self.buttonAction(_:))).modernize()
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
                         action: #selector(self.buttonAction(_:))).modernize()
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
    
    private lazy var theirColorWell: NSColorWell = {
        let clz = NSClassFromString("NSPopoverColorWell") as! NSColorWell.Type
        let v = clz.init(frame: .zero).modernize()
        v.sizeAnchors == CGSize(width: 36, height: 22)
        v.setValue(true, forKey: "emptyColorEnabled")
        v.tag = 4
        v.target = self
        v.action = #selector(self.toolbarAction(_:))
        return v
    }()
    
    private lazy var ourColorWell: NSColorWell = {
        let clz = NSClassFromString("NSPopoverColorWell") as! NSColorWell.Type
        let v = clz.init(frame: .zero).modernize()
        v.sizeAnchors == CGSize(width: 36, height: 22)
        v.setValue(true, forKey: "emptyColorEnabled")
        v.tag = 3
        v.target = self
        v.action = #selector(self.toolbarAction(_:))
        return v
    }()
    
    private lazy var imageWell: NSImageView = {
        let v = NSImageView(frame: .zero).modernize()
        v.sizeAnchors == CGSize(width: 24, height: 24)
        v.animates = true
        v.isEditable = true
        v.allowsCutCopyPaste = true
        v.imageAlignment = .alignCenter
        v.imageScaling = .scaleProportionallyUpOrDown
        v.imageFrameStyle = .grayBezel
        v.focusRingType = .none
        v.target = self
        v.action = #selector(self.toolbarAction(_:))
        return v
    }()
    
    private lazy var toolbarStack: NSStackView = {
        let a = NSTextField(labelWithString: "My Color: ")
        a.font = NSFont.from(name: .compactRoundedRegular, size: 11.0)
        let b = NSTextField(labelWithString: "Background: ")
        b.font = NSFont.from(name: .compactRoundedRegular, size: 11.0)
        let c = NSTextField(labelWithString: "Their Color: ")
        c.font = NSFont.from(name: .compactRoundedRegular, size: 11.0)
        
        let stack: NSStackView = NSStackView(views: [
            a, self.ourColorWell,
            b, self.imageWell,
            c, self.theirColorWell
        ]).modernize()
        
        stack.edgeInsets = NSEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        stack.spacing = 4.0
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.distribution = .equalCentering
        return stack
    }()
    
    private var subscriptions: [String: Subscription] = [:]
    
    private var settings: ConversationSettings? = nil
    
    public override var representedObject: Any? {
        didSet {
            self.muteButton.state = self.conversation?.muted ?? false ? .on : .off
            self.blockButton.state = self.conversation?.participants.first { !$0.me }?.blocked ?? false ? .on : .off
            self.archiveButton.state = self.conversation?.archived ?? false ? .on : .off
            // self.deleteButton.state = ... // can't be seeing this if the conv is deleted!
            
            // Synchronize with ConversationSettings
            guard let conversation = self.conversation else { return }
            self.settings = ConversationSettings(serviceIdentifier: conversation.serviceIdentifier,
                                                 identifier: conversation.identifier)
            let sub = AutoSubscription(from: conversation, kind: .conversationAppearanceUpdated) { _ in
                self.ourColorWell.color = self.settings?.outgoingColor ?? _clearColor
                self.theirColorWell.color = self.settings?.incomingColor ?? _clearColor
                self.imageWell.image = self.settings?.backgroundImage
            }
            sub.trigger()
            self.subscriptions["sub"] = sub // replace if needed, auto-unsub occurs.
        }
    }
    
    public override func loadView() {
        let stack: NSStackView = NSStackView(views: [
            self.muteButton,
            self.blockButton,
            self.archiveButton,
            self.deleteButton,
            self.toolbarStack
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
    
    @objc private func toolbarAction(_ sender: Any?) {
        if let well = sender as? NSColorWell, well.tag == 3 { // ours
            self.settings?.outgoingColor = well.objectValue as? NSColor
        } else if let well = sender as? NSColorWell, well.tag == 4 { // theirs
            self.settings?.incomingColor = well.objectValue as? NSColor
        } else if let well = sender as? NSImageView { // bg
            self.settings?.backgroundImage = well.objectValue as? NSImage
        } else { return }
        
        guard let conv = self.conversation else { return }
        Subscription.Event(name: .conversationAppearanceUpdated, object: conv).post()
    }
    
    public static func menu(for conversation: Conversation) -> NSMenu? {
        let person = conversation.participants.first { !$0.me }
        let m = NSMenu(title: "Settings")
        m.addItem(title: conversation.muted ? "Unmute" : "Mute") { [weak conversation] in
            log.info("Mute [conv: \(conversation?.identifier ?? "<dead>")]")
            conversation?.muted = !(conversation?.muted ?? false)
        }
        m.addItem(title: person?.blocked ?? false ? "Unblock" : "Block") { [weak conversation, person] in
            log.info("Block [conv: \(conversation?.identifier ?? "<dead>")]")
            person?.blocked = !(person?.blocked ?? false)
        }
        m.addItem(NSMenuItem.separator())
        m.addItem(title: conversation.archived ? "Unarchive" : "Archive") { [weak conversation] in
            log.info("Archive [conv: \(conversation?.identifier ?? "<dead>")]")
            conversation?.archived = !(conversation?.archived ?? false)
            //conversation.move(to: .archive)
        }
        m.addItem(title: "Delete") { [weak conversation] in
            log.info("Delete [conv: \(conversation?.identifier ?? "<dead>")]")
            conversation?.leave()
        }
        return m
    }
}
