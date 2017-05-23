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
	var eventStream: [EventStreamItem] { get }
	
	/// The number of messages that are unread for this Conversation.
	var unreadCount: Int { get }
	
	/// Whether the conversation's notifications will be presented to the user.
	var muted: Bool { get set }
    
    var archived: Bool { get set }
    
    var timestamp: Date { get }
    
	/// Create a Conversation from the identifier given on the Service given.
    init?(withIdentifier: String, on: Service)
    
	//var myFocus
	
	/// Set the current user's focus for the conversation.
	func setFocus(_: Bool)
	
	//var blocked: Bool { get set }
	
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

public protocol ConversationList: class /*: Collection*/ {
	
	/// A list of all conversations mapped by their unique ID.
    /// This list will only contain a certain set of conversations,
    /// locally cached when requested for it. If no conversations are synced,
    /// such as upon first launch, then this dictionary is empty.
	var conversations: [String: Conversation] { get }
    
    /// Subscripted direct access support for mapping conversations to their
    /// identifiers. If a conversation isn't loaded, it will be transiently
    /// synchronized and returned, but NOT added to the `conversations` set.
    subscript(_ identifier: String) -> Conversation? { get }
    
    /// Synchronize all remote <--> local conversations, returning the
    /// set of conversations synchronized upon invocation, if any.
    /// If nil is returned, it can be assumed that there are no more conversations
    /// left to cache. The results of this method append the `conversations`
    /// set and are indexed by conversation ID.
    func syncConversations(count: Int, since: Date?, handler: @escaping ([String: Conversation]?) -> ())
    
    /// The last timestamp for the conversations synchronized; this can be used
    /// to synchronize more conversations.
    var syncTimestamp: Date? { get }
    
	/// Begin a new conversation with the people provided.
	/// Note that this may be a one-on-one conversation if only one exists.
	func begin(with: [Person]) -> Conversation?
	
    // TODO: These should be invoked within the Conversation object.
	//func mute(conversation: Conversation)
	//func block(conversation: Conversation)
	//func archive(conversation: Conversation)
	//func delete(conversation: Conversation)
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

