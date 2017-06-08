import Foundation

public enum ContentType: String {
	case text = "com.avaidyam.Parrot.MessageType.text"
	case richText = "com.avaidyam.Parrot.MessageType.richText"
	case image = "com.avaidyam.Parrot.MessageType.image"
	case audio = "com.avaidyam.Parrot.MessageType.audio"
	case video = "com.avaidyam.Parrot.MessageType.video"
	case link = "com.avaidyam.Parrot.MessageType.link"
	case snippet = "com.avaidyam.Parrot.MessageType.snippet"
	case summary = "com.avaidyam.Parrot.MessageType.summary"
}

public protocol EventStreamItem: ServiceOriginating {
	var identifier: String { get }
	var sender: Person? { get } // if nil, global event
	var timestamp: Date { get }
}

public protocol Message: EventStreamItem {
    var contentType: ContentType { get }
    var text: String { get }
}

public enum FocusMode {
    case away
    case here
    case typing
    case enteredText
}

/// A Peron's focus indicates their activity in a Conversation.
public protocol Focus: EventStreamItem {
	var mode: FocusMode { get }
}
