import MochaUI
import ParrotServiceExtension
import Carbon // FIXME: dear lord why

/* TODO: Storing everything in UserDefaults is a bad idea... */
public struct ConversationSettings {
    public let serviceIdentifier: Service.IdentifierType
    public let identifier: Conversation.IdentifierType
    
    private var keyName: String {
        return "settings/\(self.serviceIdentifier)/\(self.identifier)/"
    }
    
    public var vibrate: Bool {
        get { return Settings.get(forKey: self.keyName + #function, default: false) }
        set { Settings.set(forKey: self.keyName + #function, value: newValue) }
    }
    
    public var sound: NSSound? {
        get { return Settings.archivedGet(forKey: self.keyName + #function, default: nil) }
        set { Settings.archivedSet(forKey: self.keyName + #function, value: newValue) }
    }
    
    public var outgoingColor: NSColor? {
        get { return Settings.archivedGet(forKey: self.keyName + #function, default: nil) }
        set { Settings.archivedSet(forKey: self.keyName + #function, value: newValue) }
    }
    
    public var incomingColor: NSColor? {
        get { return Settings.archivedGet(forKey: self.keyName + #function, default: nil) }
        set { Settings.archivedSet(forKey: self.keyName + #function, value: newValue) }
    }
    
    public var backgroundImage: NSImage? {
        get { return Settings.archivedGet(forKey: self.keyName + #function, default: nil) }
        set { Settings.archivedSet(forKey: self.keyName + #function, value: newValue) }
    }
}

public struct EventDescriptor {
    public let identifier: String
    public let contents: String?
    public let description: String?
    public let image: NSImage?
    public let sound: URL?
    public let script: URL?
}

public protocol EventAction {
    static func perform(with: EventDescriptor)
}

// input: identifier, contents, description, image
// properties: actions
public struct BannerAction: EventAction {
    private init() {}
    public static func perform(with event: EventDescriptor) {
        let notification = NSUserNotification()
        notification.identifier = event.identifier
        notification.title = event.contents ?? ""
        //notification.subtitle = event.contents
        notification.informativeText = event.description ?? ""
        notification.deliveryDate = Date()
        //notification.alwaysShowsActions = true
        //notification.hasReplyButton = true
        //notification.otherButtonTitle = "Mute"
        //notification.responsePlaceholder = "Send a message..."
        notification.identityImage = event.image
        notification.identityStyle = .circle
        //notification.soundName = event.sound?.absoluteString//"texttone:Bamboo" // this works!!
        //notification.set(option: .customSoundPath, value: event.sound?.absoluteString)
        //notification.set(option: .vibrateForceTouch, value: true)
        notification.set(option: .alwaysShow, value: true)
        
        // Post the notification "uniquely" -- that is, replace it while it is displayed.
        NSUserNotification.notifications()
            .filter { $0.identifier == notification.identifier }
            .forEach { $0.remove() }
        notification.post()
    }
}

// input: contents, image
public struct BezelAction: EventAction {
    private init() {}
    
    public static func perform(with event: EventDescriptor) {
        SystemBezel(image: event.image, text: event.contents)
            .show().hide(after: 5.seconds)
    }
}

// input: none
// properties: filename
public struct SoundAction: EventAction {
    private init() {}
    public static func perform(with event: EventDescriptor) {
        guard let s = event.sound?.absoluteString else { return }
        NSSound(contentsOfFile: s, byReference: true)?.play()
    }
}

// input: none
public struct VibrateAction: EventAction {
    private init() {}
    public static func perform(with event: EventDescriptor) {
        NSHapticFeedbackManager.vibrate(length: 1000, interval: 10)
    }
}

// input: none
public struct BounceDockAction: EventAction {
    private init() {}
    public static func perform(with event: EventDescriptor) {
        let id = NSApp.requestUserAttention(.criticalRequest)
        DispatchQueue.main.asyncAfter(deadline: 2.seconds.later) {
            NSApp.cancelUserAttentionRequest(id)
        }
    }
}

// input: none
public struct FlashLEDAction: EventAction {
    private init() {}
    public static func perform(with event: EventDescriptor) {
        KeyboardBrightnessAnimation().start()
    }
}

// input: contents, description
public struct SpeakAction: EventAction {
    private init() {}
    public static func perform(with event: EventDescriptor) {
        let text = (event.contents ?? "") + (event.description ?? "")
        NSApp.say(text)
    }
}

// input: none
// properties: script path
public struct ScriptAction: EventAction {
    private init() {}
    public static func perform(with event: EventDescriptor) {
        guard let s = event.script else { return }
        
        // Branch to each possible script type:
        if s.pathExtension.starts(with: "wflow") || s.pathExtension.starts(with: "workflow") { // Automator
            let task = try? NSUserAutomatorTask(url: s)
            //task?.variables = nil
            task?.execute(withInput: "Event!" as NSString, completionHandler: {print($0 ?? $1 ?? "undefined")})
        } else if s.pathExtension.starts(with: "scpt") { // AppleScript/JSX
            let message = NSAppleEventDescriptor(string: "Event!")
            let desc = ScriptAction.descriptor(for: "main", [message])
            
            _ = try? NSUserAppleScriptTask(url: s).execute(withAppleEvent: desc, completionHandler: {print($0 ?? $1 ?? "undefined")})
        } else { // probably Unix
            _ = try? NSUserUnixTask(url: s).execute(withArguments: ["Event!"], completionHandler: {print($0 ?? "undefined")})
        }
    }
    
    // Create a "function call" AEDesc to invoke the script with.
    private static func descriptor(for functionName: String, _ parameters: [NSAppleEventDescriptor]) -> NSAppleEventDescriptor {
        let event = NSAppleEventDescriptor(
            eventClass: UInt32(kASAppleScriptSuite),
            eventID: UInt32(kASSubroutineEvent),
            targetDescriptor: .currentProcess(),
            returnID: Int16(kAutoGenerateReturnID),
            transactionID: Int32(kAnyTransactionID)
        )
        
        let function = NSAppleEventDescriptor(string: functionName)
        let params = NSAppleEventDescriptor.list()
        parameters.forEach { params.insert($0, at: 1) }
        event.setParam(function, forKeyword: AEKeyword(keyASSubroutineName))
        event.setParam(params, forKeyword: AEKeyword(keyDirectObject))
        return event
    }
}

public extension ParrotAppController {
    
    /// An archive of all the Hangouts events we're watching; besides connect/disconnect,
    /// they all have to do with Conversation changes like focus/events/participants.
    public func registerEvents() {
        self.watching = [
               AutoSubscription(kind: Notification.Service.DidConnect) { _ in
                let event = EventDescriptor(identifier: "Parrot.ConnectionStatus", contents: "Parrot has connected.",
                                  description: nil, image: NSImage(named: .connectionOutline), sound: nil, script: nil)
                let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self, BezelAction.self]
                actions.forEach { $0.perform(with: event) }
            }, AutoSubscription(kind: Notification.Service.DidDisconnect) { _ in
                DispatchQueue.main.async { // FIXME why does wrapping it twice work??
                    let event = EventDescriptor(identifier: "Parrot.ConnectionStatus", contents: "Parrot has disconnected.",
                                      description: nil, image: NSImage(named: .connectionOutline), sound: nil, script: nil)
                    let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self, BezelAction.self]
                    actions.forEach { $0.perform(with: event) }
                }
                
            }, AutoSubscription(kind: Notification.Conversation.DidJoin) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidLeave) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidChangeFocus) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidReceiveWatermark) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidReceiveEvent) { e in
                let c = ServiceRegistry.services.first!.value
                guard let event = e.userInfo?["event"] as? Event, let conv = e.object as? Conversation else { return }
                let settings = ConversationSettings(serviceIdentifier: conv.serviceIdentifier, identifier: conv.identifier)
                
                // if we've set a sound or vibration, play it
                settings.sound?.play()
                if settings.vibrate { NSHapticFeedbackManager.vibrate(length: 1000, interval: 10) }
                
                var showNote = true
                if let m = MessageListViewController.openConversations[conv.identifier] {
                    showNote = !(m.view.window?.isKeyWindow ?? false)
                }
                
                guard let msg = event as? Message else { return }
                if !msg.sender.me && showNote {
                    if (msg.text ?? "").contains(c.directory.me.firstName) || (msg.text ?? "").contains(c.directory.me.fullName) {
                        let event2 = EventDescriptor(identifier: conv.identifier, contents: msg.sender.firstName,
                                           description: "Mentioned you", image: msg.sender.image, sound: nil, script: nil)
                        let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self]
                        actions.forEach { $0.perform(with: event2) }
                        
                    } else { // not a mention
                        let event2 = EventDescriptor(identifier: conv.identifier, contents: msg.sender.firstName,
                                           description: msg.text, image: msg.sender.image, sound: nil, script: nil)
                        let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self]
                        actions.forEach { $0.perform(with: event2) }
                    }
                }
                
            }, AutoSubscription(kind: NSUserNotification.didActivateNotification) {
                let c = ServiceRegistry.services.first!.value
                guard   let notification = $0.object as? NSUserNotification,
                        let conv = c.conversations.conversations[notification.identifier ?? ""]
                else { return }
                
                switch notification.activationType {
                case .contentsClicked:
                    MessageListViewController.show(conversation: conv, parent: self.conversationsController)
                case .actionButtonClicked:
                    conv.muted = true
                case .replied where notification.response?.string != nil:
                    MessageListViewController.sendMessage(notification.response!.string, conv)
                default: break
                }
            }
        ]
    }
}

/*
 FocusEvent: A person changed their focus (viewing or typing in a conversation). Includes self.
 PresenceEvent: A person's presence changed. Includes self. Includes dis/connections.
 MessageEvent: A message was sent or received. Includes self.
         Properties: Group?, Background?, Sent?
 InvitationEvent: A person was invited to join a conversation.
 MentionEvent: A name or a keyword was mentioned in a conversation.
 */


// add "action" property -- if the event is "acted on", the handler is invoked
// i.e. notification button
// i.e. dock bounce --> NSAppDelegate checks if bounce, then calls handler (otherwise bail)
/*
 let ev = Event(identifier: event.conversation_id, contents: user.firstName + " (via Hangouts)",
 description: event.text, image: fetchImage(user: user, monogram: true))
 let actions: [EventAction.Type] = [BannerAction.self, BezelAction.self, SoundAction.self, VibrateAction.self, BounceDockAction.self, FlashLEDAction.self, SpeakAction.self, ScriptAction.self]
 actions.forEach {
 $0.perform(with: ev)
 }
 */






