import Foundation
import AppKit
import Social
import Mocha
import Hangouts
import ParrotServiceExtension

// Does not support kUTTypeAudiovisualContent, kUTTypeMovie, kUTTypeAudio
// Or any file/folder/archive/bundle/document yet.
public final class ShareViewController: SLComposeServiceViewController {
    private static var adjustAudiencePopUpFrameKey = SelectorKey<SLComposeServiceViewController, Void, Void, Void>("adjustAudiencePopUpFrame")
    
    // The internal Hangouts.Client.
    private var client: Client! = nil
    
    public override func loadView() {
        super.loadView()
        self.title = "Parrot"
        self.placeholder = "Send a message..."
        self.showProgressIndicator = true
        print("Initializing...")
        
        if let button = self.value(forKey: "sendButton") as? NSButton {
            button.title = "Send"
        }
    }
    
    // Show an indicator only while signing in, and invoke dispatch() when done.
    public override func presentationAnimationDidFinish() {
        self.validateContent()
        DispatchQueue.global(qos: .background).async {
            self.client = Auth.signin()
            self.dispatch()
            
            DispatchQueue.main.async {
                self.showProgressIndicator = false
                self.showAudienceList = true
                self.validateContent()
            }
        }
    }
    
    // The actual work of propogating the directory list.
    private func dispatch() {
        if let button = self.value(forKey: "audiencePopUpButton") as? NSPopUpButton {
            button.menu?.removeAllItems()
            
            // Add a menu item for each recent conversation in the list.
            for conv in self.client.conversations.conversations.values {
                let m = NSMenuItem(title: conv.name, action: nil, keyEquivalent: "")
                m.representedObject = conv
                button.menu?.addItem(m)
            }
            
            button.selectItem(at: 0)
            DispatchQueue.main.async {
                _ = ShareViewController.adjustAudiencePopUpFrameKey[self, with: nil, with: nil]
            }
        }
    }
    
    // Fix the visual appearance to match a vibrant dark style.
    public override func viewDidAppear() {
        super.viewDidAppear()
        self.textView.textColor = NSColor.labelColor
        self.view.superview?.appearance = NSAppearance(named: .vibrantDark)
        if let img = self.value(forKey: "imageView") as? NSImageView {
            img.setValue(0, forKey: "imageStyle")
        }
    }
    
    public override func didSelectPost() {
        self.validateContent()
        let inputItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let outputItem = inputItem.copy() as! NSExtensionItem
        outputItem.attributedContentText = NSAttributedString(string: self.contentText)
        
        // Send all image attachments and bail for any error in loading them.
        for item in self.items() {
            item.loadItem(forTypeIdentifier: kUTTypeImage as String, options: [:]) { obj, err in
                if let data = obj as? Data {
                    do {
                        let url = URL(temporaryFileWithExtension: "png")
                        try data.write(to: url, options: .atomic)
                        self.send(.image(url))
                    } catch(let error) {
                        self.extensionContext!.cancelRequest(withError: error)
                    }
                } else if let url = obj as? URL {
                    self.send(.image(url))
                } else {
                    self.extensionContext!.cancelRequest(withError: err)
                }
            }
        }
        
        // Only send text if there is any.
        if let str = self.contentText, str != "" {
            self.send(.text(self.contentText))
        }
        
        // Complete the request and play a notification sound.
        self.extensionContext!.completeRequest(returningItems: [outputItem]) { _ in }
        NSSound(named: NSSound.Name("Tink"))?.play()
    }
	
    public override func didSelectCancel() {
        self.extensionContext!.cancelRequest(withError: CocoaError(.userCancelled))
        DispatchQueue.main.async {
            NSApp.terminate(self)
        }
    }
    
    public override func isContentValid() -> Bool {
        if self.client == nil { return false }
        
        for item in self.items() where !item.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
            return true
        }
        return true
    }
    
    // Convenience to grab all the attachments from all input items.
    private func items() -> [NSItemProvider] {
        return self.extensionContext!.inputItems
            .map { $0 as! NSExtensionItem }
            .flatMap { ($0.attachments ?? []) }
            .map { $0 as! NSItemProvider }
    }
    
    private func send(_ content: Content) {
        guard   let button = self.value(forKey: "audiencePopUpButton") as? NSPopUpButton,
                let conv = button.selectedItem?.representedObject as? ParrotServiceExtension.Conversation
        else {
                self.extensionContext!.cancelRequest(withError: CocoaError(.featureUnsupported)); return
        }
        
        // Send the message if we can now.
        do {
            try conv.send(message: PlaceholderMessage(sender: self.client.directory.me, content: content))
        } catch(let error) {
            self.extensionContext!.cancelRequest(withError: error)
        }
    }
}








//
//
//



// TODO: REMOVE THIS?
public struct PlaceholderMessage: Message {
    public let serviceIdentifier: String = ""
    public let identifier: String = ""
    public let sender: Person
    public let timestamp: Date = Date()
    public var content: Content
}

public extension SLComposeServiceViewController {
    
    private static var showsProgressIndicatorProp = KeyValueProperty<SLComposeServiceViewController, Bool>("showsProgressIndicator")
    private static var showsAudiencePopUpProp = KeyValueProperty<SLComposeServiceViewController, Bool>("showsAudiencePopUp")
    
    @nonobjc public fileprivate(set) var showProgressIndicator: Bool {
        get { return SLComposeServiceViewController.showsProgressIndicatorProp[self, default: false] }
        set { SLComposeServiceViewController.showsProgressIndicatorProp[self] = newValue }
    }
    
    @nonobjc public fileprivate(set) var showAudienceList: Bool {
        get { return SLComposeServiceViewController.showsAudiencePopUpProp[self, default: false] }
        set { SLComposeServiceViewController.showsAudiencePopUpProp[self] = newValue }
    }
}

public struct Auth: AuthenticatorDelegate {
    
    private static let GROUP_DOMAIN = "group.com.avaidyam.Parrot"
    private static let ACCESS_TOKEN = "access_token"
    private static let REFRESH_TOKEN = "refresh_token"
    
    public var authenticationTokens: AuthenticationTokens? {
        get {
            let at = SecureSettings[Auth.ACCESS_TOKEN, domain: Auth.GROUP_DOMAIN] as? String
            let rt = SecureSettings[Auth.REFRESH_TOKEN, domain: Auth.GROUP_DOMAIN] as? String
            
            if let at = at, let rt = rt {
                return (access_token: at, refresh_token: rt)
            } else {
                SecureSettings[Auth.ACCESS_TOKEN, domain: Auth.GROUP_DOMAIN] = nil
                SecureSettings[Auth.REFRESH_TOKEN, domain: Auth.GROUP_DOMAIN] = nil
                return nil
            }
        }
        set {}//assert(false, "Cannot authenticate from the console! You must launch the GUI.") }
    }
    public func authenticationMethod(_ oauth_url: URL, _ result: @escaping AuthenticationResult) {
        assert(false, "Cannot authenticate from the console! You must launch the GUI.")
    }
    
    private static var con: xpc_connection_t? = nil
    public static func signin() -> Client {
        Authenticator.delegate = Auth()
        
        var client: Client!
        let sem = DispatchSemaphore(value: 0)
        Authenticator.authenticateClient {
            client = Client(configuration: $0)
            sem.signal()
        }
        sem.wait()
        
        return client
    }
}

public extension NSImage {
    
    /// Produce Data from this NSImage with the contained FileType image information.
    public func data(for type: NSBitmapImageRep.FileType) -> Data? {
        guard   let tiff = self.tiffRepresentation,
            let rep = NSBitmapImageRep(data: tiff),
            let dat = rep.representation(using: type, properties: [:])
            else { return nil }
        return dat
    }
}
