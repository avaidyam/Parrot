import Foundation

// Modularize Conversations + ConversationsView
// for widget:
// - main view is conversation view selected
// - press (i) to show conversations list
// - select = show a new conversation

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

public protocol Message: EventStreamItem {
    var contentType: ContentType { get }
	var text: String { get }
}

public protocol EventStreamItem {
	//var identifier: String { get }
	var sender: Person? { get } // if nil, global event
	var timestamp: Date { get }
}

public enum TypingProgress { // FIXME: FocusType
	case away
	case here
	case typing
	case enteredText
}

/// A Person's presence in the Service can contain information such as
/// the time they were last seen or what device they are on, in addition
/// to AIM or XMPP-style status messages.

/// A Peron's focus indicates their activity in a Conversation.
public protocol Focus: EventStreamItem {
	var typing: TypingProgress { get }
	var present: Bool { get }
}


public enum EventStreamNotification {
	case message
	case focus
	
}
