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
	
	/// The set of all events in this Conversation.
	var messages: [Message] { get }
	
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

/*
public extension ConversationList {
	
	public var sortedConversations: [Conversation] {
		return self.conversations.values.sorted { $0.timestamp > $1.timestamp }
	}
}*/

public protocol Person /*: Hashable, Equatable*/ {
	
	/// The Person's unique identifier (specific to the Service).
	var identifier: String { get }
	
	/// The Person's name as an array of components.
	/// For example, the first element of the array provides the first name,
	/// and the last element provides the last name. Concatenation of all the elements
	/// in the array should produce the full name.
	var nameComponents: [String] { get }
	
	/// The Person's photo as a remote (internet) or file URL (on disk).
	/// If there is no photo, nil should be returned.
	var photoURL: String? { get }
	
	/// Any possible locations for the Person. These can be physical or virtual.
	/// For example, it may contain email addresses and phone numbers, and even
	/// twitter handles, real physical addresses or coordinates.
	var locations: [String] { get }
	
	/// Is this Person the one logged into the Service?
	var me: Bool { get }
	
	/// Block this person from contacting the logged in user.
	//func block()
	
	/// Unblock this person from contacting the logged in user.
	//func unblock()
}

public extension Person {
	
	/// Computes the full name by taking the name components like so:
	/// ["John", "Mark", "Smith"] => "John Mark Smith"
	/// Will return an empty string if there are no name components.
	public var fullName: String {
		return self.nameComponents.joined(separator: " ")
	}
	
	/// Computes the first name by taking the first of the name components:
	/// ["John", "Mark", "Smith"] => "John"
	/// Will return an empty string if there are no name components.
	public var firstName: String {
		return self.nameComponents.first ?? ""
	}
}

public protocol Directory /*: Collection*/ {
	
	/// Return the user currently logged into the Service.
	var me: Person { get }
	
	/// Return all users the current user can locate mapped by their unique ID.
	var people: [String: Person] { get }
	
	/// Returns all pending invitations requested to the current user.
	var invitations: [String: Person] { get }
	
	/// Returns all the people blocked by the current user.
	var blocked: [String: Person] { get }
	
	/// Search for users given a set of identifiers.
	/// Identifiers can include anything including name components.
	/// Returns a set of users that could be possible matches.
	//func search(for: [String]) -> [Person]
}
