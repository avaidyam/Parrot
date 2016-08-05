import Foundation

// Modularize Conversations + ConversationsView
// for widget:
// - main view is conversation view selected
// - press (i) to show conversations list
// - select = show a new conversation

public enum MessageType {
	case text
	case richText
	case image
	case audio
	case video
	case link
	case snippet
	case summary
}

public protocol Message: EventStreamItem {
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
