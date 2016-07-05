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
	case heartbeat
}

public protocol ConversationList2 {
	// conversations() -> [Conversation]
	// begin([User]) -> Conversation
}

// Conversation consists of
public protocol Conversation2 {
	// leave()
	// archive()
	// delete()
	
	// watermark?
	// focus?
	
	// name(String)
	// participants() -> [User]
	// messages() -> [Message]
	
	// send(String)
	// send(Image)
	// send(Sticker)
	// typing()
}

public protocol Message2 {
	
}

public protocol Directory2 {
	
	/// Return the user currently logged into the Service.
	var me: Person { get }
	
	/// Return all users the current user can locate.
	var users: [Person] { get }
	
	//var invitations: [User2] { get }
	
	//var blocked: [User2] { get }
	
	/// Search for users given a set of identifiers.
	/// Identifiers can include anything including name components.
	/// Returns a set of users that could be possible matches.
	func search(for identifiers: [String]) -> [Person]
}

public protocol Person {
	
	/// The user's name as an array of components.
	///
	/// For example, the first element of the array provides the first name,
	/// and the last element provides the last name. Concatenation of all the elements
	/// in the array should produce the full name.
	var name: [String] { get }
	
	/// The user's photo as an array of bytes.
	/// If there is none, nil should be returned.
	var photo: [UInt8]? { get }
	
	/// The user's possible identifiers.
	/// Note: this could include email address, twitter handles, or anything else.
	var identifiers: [String] { get }
	
	/// Is this user the one logged into the Service?
	var me: Bool { get }
}
