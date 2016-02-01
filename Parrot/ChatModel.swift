import Foundation

// Modularize Conversations + ConversationsView
// for widget:
// - main view is conversation view selected
// - press (i) to show conversations list
// - select = show a new conversation

public enum Capabilities {
	
	/// Service supports plain text in conversations.
	/// Note: this should definitely be supported by all services.
	case Text
	
	/// Service supports rich text in conversations.
	/// If not supported, artificial tags (i.e. markdown syntax) can be used.
	case RichText
	
	/// Service supports sending photos in conversations.
	/// If not supported, a plain-text link to a CDN-hosted image can be used.
	case Photo
	
	/// Service supports sending audio in conversations.
	/// If not supported, a plain-text link to a CDN-hosted clip can be used.
	case Audio
	
	/// Service supports sending videos in conversations.
	/// If not supported, a plain-text link to a CDN-hosted video can be used.
	case Video
	
	/// Service supports sending stickers in conversations.
	/// If not supported, a plain-text link to a CDN-hosted image can be used.
	/// Alternatively, a set of emoji can be supplied and elarged for effect.
	case Stickers
	
	/// Service supports multi-user (group) conversations.
	case Groups
	
	/// Service supports modifying notification status in conversations.
	case Snooze
	
	/// Service supports user presence in conversations.
	case Presence
	
	/// Service supports native encryption of conversations.
	/// If not supported, a public/private key pair encryption scheme can be used.
	/// Note that without decryption, archived messages will look garbled.
	case Encryption
	
	/// Service supports sending read receipts in conversations.
	case ReadReceipt
	
	/// Service supports disabling chat archival in conversations.
	/// While this is a server-side flag, this should be handled by clients as well.
	case OffTheRecord
}

public protocol Service {
	
	/// Returns the notification key for the event fired when this service connects
	/// successfully to its server/host.
	static func didConnectNotification() -> String
	
	/// Returns the notification key for the event fired when this service reconnects
	/// upon a previous non-user-initiated disconnection.
	static func didReconnectNotification() -> String
	
	/// Returns the notification key for the event fired when this service disconnects
	/// from its server/host.
	static func didDisconnectNotification() -> String
	
	/// Returns the notification key for the event fired when this service receives
	/// an update of any kind; this should be used only by the service itself.
	static func didReceiveUpdateNotification() -> String
	
	/// Connects the service to its server/host.
	/// Returns true if connection succeeded, or false if it failed.
	func connect() -> Bool
	
	/// Disconnects the service from its service/host.
	/// Returns true if the disconnection succeeded, or false if it failed.
	func disconnect() -> Bool
	
	/// Synchronizes events and dispatches a didReceiveUpdate event upon completion.
	/// Returns true if synchronization succeeded, or false if it failed.
	func synchronize() -> Bool
	
	/// The current connection state of the service.
	/// See connect() and disconnect().
	var connected: Bool { get }
	
	/// Sets or returns whether the current service client is the active one.
	var active: Bool { get set }
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