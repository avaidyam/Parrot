import MochaUI
import Hangouts // TODO: REMOVE

public struct Event {
    public let identifier: String
    public let contents: String?
    public let description: String?
    public let image: NSImage?
    public let sound: URL?
    public let script: URL?
}

public protocol EventAction {
    static func perform(with: Event)
}

// input: identifier, contents, description, image
// properties: actions
public struct BannerAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
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
// FIXME: there's a crashing zombie somewhere here
public struct BezelAction: EventAction {
    private init() {}
    
    private static var bezels: [SystemBezel] = [] {
        didSet {
            DispatchQueue.main.async {
                if bezels.count > 0 {
                    bezels.first?.show(autohide: 2.seconds)
                    DispatchQueue.main.asyncAfter(deadline: 2.seconds.later) {
                        bezels.remove(at: 0)
                    }
                }
            }
        }
    }
    
    public static func perform(with event: Event) {
        let bezel = SystemBezel.create(text: event.contents, image: event.image)
        bezels.append(bezel)
    }
}

// input: none
// properties: filename
public struct SoundAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
        guard let s = event.sound?.absoluteString else { return }
        NSSound(contentsOfFile: s, byReference: true)?.play()
    }
}

// input: none
public struct VibrateAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
        NSHapticFeedbackManager.vibrate(length: 1000, interval: 10)
    }
}

// input: none
public struct BounceDockAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
        let id = NSApp.requestUserAttention(.criticalRequest)
        DispatchQueue.main.asyncAfter(deadline: 2.seconds.later) {
            NSApp.cancelUserAttentionRequest(id)
        }
    }
}

// input: none
public struct FlashLEDAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
        KeyboardBrightnessAnimation().start()
    }
}

// input: contents, description
public struct SpeakAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
        let text = (event.contents ?? "") + (event.description ?? "")
        NSApp.perform(Selector(("speakString:")), with: text)
    }
}

// input: none
// properties: script path
public struct ScriptAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
        guard let s = event.script else { return }
        _ = try? NSUserAppleScriptTask(url: s).execute(withAppleEvent: nil, completionHandler: nil)
    }
}

public extension ParrotAppController {
    
    /// An archive of all the Hangouts events we're watching; besides connect/disconnect,
    /// they all have to do with Conversation changes like focus/events/participants.
    public func registerEvents() {
        self.watching = [
               AutoSubscription(kind: Notification.Service.DidConnect) { _ in
                let event = Event(identifier: "Parrot.ConnectionStatus", contents: "Parrot has connected.",
                                  description: nil, image: NSImage(named: .caution), sound: nil, script: nil)
                let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self]
                actions.forEach { $0.perform(with: event) }
            }, AutoSubscription(kind: Notification.Service.DidDisconnect) { _ in
                DispatchQueue.main.async { // FIXME why does wrapping it twice work??
                    let event = Event(identifier: "Parrot.ConnectionStatus", contents: "Parrot has disconnected.",
                                      description: nil, image: NSImage(named: .caution), sound: nil, script: nil)
                    let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self]
                    actions.forEach { $0.perform(with: event) }
                }
                
            }, AutoSubscription(kind: Notification.Conversation.DidJoin) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidLeave) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidChangeFocus) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidChangeTypingStatus) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidReceiveWatermark) { _ in
                
            }, AutoSubscription(kind: Notification.Conversation.DidReceiveEvent) { e in
                let c = ServiceRegistry.services.first!.value as! Client
                guard let event = e.userInfo?["event"] as? IChatMessageEvent else { return }
                
                var showNote = true
                if let m = MessageListViewController.openConversations[event.conversation_id] {
                    showNote = !(m.view.window?.isKeyWindow ?? false)
                }
                
                if let user = c.userList.people[event.userID.gaiaID], !user.me && showNote {
                    if event.text.contains(c.userList.me.firstName) || event.text.contains(c.userList.me.fullName) {
                        let event2 = Event(identifier: event.conversation_id, contents: user.firstName,
                                           description: "Mentioned you", image: user.image, sound: nil, script: nil)
                        let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self]
                        actions.forEach { $0.perform(with: event2) }
                        
                    } else { // not a mention
                        let event2 = Event(identifier: event.conversation_id, contents: user.firstName,
                                           description: event.text, image: user.image, sound: nil, script: nil)
                        let actions: [EventAction.Type] = [BannerAction.self, SoundAction.self]
                        actions.forEach { $0.perform(with: event2) }
                    }
                }
                
            }, AutoSubscription(kind: NSUserNotification.didActivateNotification) {
                let c = ServiceRegistry.services.first!.value as! Client
                guard   let notification = $0.object as? NSUserNotification,
                        var conv = c.conversationList?.conversations[notification.identifier ?? ""]
                else { return }
                
                switch notification.activationType {
                case .contentsClicked:
                    MessageListViewController.show(conversation: conv as! IConversation, parent: self.conversationsController)
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






