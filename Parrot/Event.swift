import Cocoa
import Mocha
import MochaUI

private let SOUNDFILE = "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/sms_alert_bamboo.caf"

public struct Event {
    public let identifier: String
    public let contents: String?
    public let description: String?
    public let image: NSImage?
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
        //notification.soundName = "texttone:Bamboo" // this works!!
        //notification.set(option: .customSoundPath, value: SOUNDFILE)
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
        NSSound(contentsOfFile: SOUNDFILE, byReference: true)?.play()
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
        NSApp.requestUserAttention(.criticalRequest)
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
        _ = try? NSUserAppleScriptTask(url: URL(fileURLWithPath: "")).execute(withAppleEvent: nil, completionHandler: nil)
    }
}
