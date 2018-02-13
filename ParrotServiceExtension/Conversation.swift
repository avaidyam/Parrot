import struct Foundation.Date

/* TODO: Public/private conversations; conversation topic/purpose. */

/// A Conversation is uniquely identified by its ID, and consists of
/// the current user, along with either one or more persons as well.
public protocol Conversation: class, ServiceOriginating /*: Hashable, Equatable*/ {
	
    typealias IdentifierType = String
    
	/// The Conversation's unique identifier (specific to the Service).
	var identifier: IdentifierType { get }
	
	/// The user-facing Conversation name. This may only be displayed if the
	/// conversation is a Group one, but this setting can be overridden.
    /// If there is no explicit `name` set (as described above), an implicit
    /// name is provided, composed of `participants`' `fullName`s.
	var name: String { get set }
	
	/// The set of people involved in this Conversation.
    var participants: [Person] { get }
    
	/// The focus information for each participant in the Conversation.
	/// There is guaranteed to be one Focus item per participant.
	var focus: [Person.IdentifierType: FocusMode] { get }
	
	/// The set of all events in this Conversation.
	var eventStream: [Event] { get }
	
	/// The number of messages that are unread for this Conversation.
	var unreadCount: Int { get }
	
	/// Whether the conversation's notifications will be presented to the user.
	var muted: Bool { get set }
    
    var archived: Bool { get set }
    
	/// Create a Conversation from the identifier given on the Service given.
    //init?(withIdentifier: String, on: Service)
    
    func focus(mode: FocusMode)
    
    func send(message: Message) throws // MessageError
    
    func leave() // both group and one-on-one
    
    func syncEvents(count: Int, before: Event?, handler: @escaping ([Event]) -> ())
}

public extension Conversation {
    
    /// The timestamp used when sorting a list of recent conversations.
    public var sortTimestamp: Date {
        return self.eventStream.last?.timestamp ?? Date()
    }
}

public enum FocusMode {
    case away
    case here
    case typing
    case enteredText
}
