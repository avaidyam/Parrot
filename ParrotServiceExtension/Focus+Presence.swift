import Foundation

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
