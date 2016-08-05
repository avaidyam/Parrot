import Foundation

/// A Conversation is uniquely identified by its ID, and consists of
/// the current user, along with either one or more persons as well.
public protocol Conversation /*: Hashable, Equatable*/ {
	
	/// The Conversation's unique identifier (specific to the Service).
	var identifier: String { get }
	
	/// The user-facing Conversation name. This may only be displayed if the
	/// conversation is a Group one, but this setting can be overridden.
	var name: String { get set }
	
	/// The set of people involved in this Conversation.
	var participants: [Person] { get }
	
	/// The focus information for each participant in the Conversation.
	/// There is guaranteed to be one Focus item per participant.
	var focus: [Focus] { get }
	
	/// The set of all events in this Conversation.
	var messages: [Message] { get }
	
	/// The number of messages that are unread for this Conversation.
	var unreadCount: Int { get }
	
	
	//var myFocus
	
	/// Set the current user's focus for the conversation.
	func setFocus(_: Bool)
	
	// leave()
	// archive()
	// delete()
	// watermark?
	// focus?
	// send(String)
	// send(Image)
	// send(Sticker)
	// typing()
}

public protocol ConversationList /*: Collection*/ {
	
	/// A list of all conversations mapped by their unique ID.
	var conversations: [String: Conversation] { get }
	
	/// Begin a new conversation with the people provided.
	/// Note that this may be a one-on-one conversation if only one exists.
	func begin(with: [Person]) -> Conversation?
	
	/// Archive a conversation provided.
	func archive(conversation: Conversation)
	
	/// Delete a conversation provided.
	func delete(conversation: Conversation)
}

public enum ConversationNotification {
	case create
	case delete
	case join
	case leave
	case mute
}

public enum ConversationListNotification {
	case conversation
	case presence
}

/*
public extension ConversationList {
	
	public var sortedConversations: [Conversation] {
		return self.conversations.values.sorted { $0.timestamp > $1.timestamp }
	}
}*/

