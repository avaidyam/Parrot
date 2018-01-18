import Cocoa
import Mocha
import MochaUI

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
public struct BezelAction: EventAction {
    private init() {}
    public static func perform(with event: Event) {
        SystemBezel.create(text: event.contents, image: event.image).show(autohide: .seconds(2))
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

/// An archive of all the Hangouts events we're watching; besides connect/disconnect,
/// they all have to do with Conversation changes like focus/events/participants.
private let watching: [AutoSubscription] = [
       AutoSubscription(kind: Notification.Service.DidConnect) { _ in
        
    }, AutoSubscription(kind: Notification.Service.DidDisconnect) { _ in
        
    }, AutoSubscription(kind: Notification.Conversation.DidJoin) { _ in
        
    }, AutoSubscription(kind: Notification.Conversation.DidLeave) { _ in
        
    }, AutoSubscription(kind: Notification.Conversation.DidChangeFocus) { _ in
        
    }, AutoSubscription(kind: Notification.Conversation.DidChangeTypingStatus) { _ in
        
    }, AutoSubscription(kind: Notification.Conversation.DidReceiveWatermark) { _ in
        
    }, AutoSubscription(kind: Notification.Conversation.DidReceiveEvent) { _ in
        
    },
]

public func registerEvents() {
    _ = watching // triggers the whole thing
}

/*
 FocusEvent: A person changed their focus (viewing or typing in a conversation). Includes self.
 PresenceEvent: A person's presence changed. Includes self. Includes dis/connections.
 MessageEvent: A message was sent or received. Includes self.
         Properties: Group?, Background?, Sent?
 InvitationEvent: A person was invited to join a conversation.
 MentionEvent: A name or a keyword was mentioned in a conversation.
 */







