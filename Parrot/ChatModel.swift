import Foundation

// Modularize Conversations + ConversationsView
// for widget:
// - main view is conversation view selected
// - press (i) to show conversations list
// - select = show a new conversation

public protocol Service2 {
	// connect()
	// disconnect()
	// synchronize()
	// active(Bool)
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

public protocol UserList2 {
	// me() -> User
	// users() -> [User]
	// invitations -> [User]
	// blocked -> [User]
}

public protocol User2 {
	// name() -> [String]
	// photo() -> URL
	// identifiers() -> [AnyObject]
	// me() -> Bool
}