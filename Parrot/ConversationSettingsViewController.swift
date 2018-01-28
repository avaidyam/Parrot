import Foundation
import AppKit
import Mocha
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
        let v = NSButton(title: "Mute", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Unmute"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedRounded
        
        v.setButtonType(.pushOnPushOff)
        v.state = NSControl.StateValue(rawValue: 0)
        v.tag = Tags.mute.rawValue
        return v
    }()
    
    private lazy var blockButton: NSButton = {
        let v = NSButton(title: "Block", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Unblock"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedRounded
        
        v.setButtonType(.pushOnPushOff)
        v.state = NSControl.StateValue(rawValue: 0)
        v.tag = Tags.block.rawValue
        return v
    }()
    
    private lazy var archiveButton: NSButton = {
        let v = NSButton(title: "Archive", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Unarchive"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedRounded
        
        v.setButtonType(.pushOnPushOff)
        v.state = NSControl.StateValue(rawValue: 0)
        v.tag = Tags.archive.rawValue
        return v
    }()
    
    private lazy var deleteButton: NSButton = {
        let v = NSButton(title: "Delete", image: #imageLiteral(resourceName: "MaterialVolumeMute"), target: self,
                         action: #selector(ConversationDetailsViewController.buttonAction(_:))).modernize()
        v.alternateTitle = "Undelete"
        v.alternateImage = #imageLiteral(resourceName: "MaterialVolumeMute")
        v.bezelStyle = .texturedRounded
        
        v.setButtonType(.pushOnPushOff)
        v.state = NSControl.StateValue(rawValue: 0)
        v.tag = Tags.delete.rawValue
        return v
    }()
    
    public override func loadView() {
        let stack: NSStackView = NSStackView(views: [
            self.muteButton,
            self.blockButton,
            self.archiveButton,
            self.deleteButton
        ]).modernize()
        
        stack.edgeInsets = NSEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        stack.spacing = 8.0
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.distribution = .fill
        
        stack.widthAnchor == 128.0
        self.view = stack
    }
    
    @objc
    private func buttonAction(_ sender: Any?) {
        guard   let _ = self.conversation,
                let button = sender as? NSButton,
                let tag = Tags(rawValue: button.tag)
        else { return }
        
        switch tag {
        case .mute:
            print("MUTE TOGGLE")
        case .block:
            print("BLOCK TOGGLE")
        case .archive:
            print("ARCHIVE TOGGLE")
        case .delete:
            print("DELETE TOGGLE")
        }
    }
    
    @IBAction func colorChanged(_ sender: AnyObject?) {
        /*if let well = sender as? NSColorWell, well.identifier == "MyBubbleColor" {
         
         } else if let well = sender as? NSColorWell, well.identifier == "TheirBubbleColor" {
         
         } else if let img = sender as? NSImageView, img.identifier == "BackgroundImage" {
         
         }*/
        
        Subscription.Event(name: .updateColors, object: self).post()
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
