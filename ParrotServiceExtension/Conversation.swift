import Foundation

/// A Conversation is uniquely identified by its ID, and consists of
/// the current user, along with either one or more persons as well.
public protocol Conversation: ServiceOriginating /*: Hashable, Equatable*/ {
	
    typealias IdentifierType = String
    
	/// The Conversation's unique identifier (specific to the Service).
	var identifier: IdentifierType { get }
	
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
    //init?(withIdentifier: String, on: Service)
    
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
