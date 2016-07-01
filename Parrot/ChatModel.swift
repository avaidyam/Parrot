import Foundation

// Modularize Conversations + ConversationsView
// for widget:
// - main view is conversation view selected
// - press (i) to show conversations list
// - select = show a new conversation

/// Defines all possible capabilities that Parrot will understand that can be
/// vended by a remote messaging Service. Note that at the absolute minimum,
/// a Service must support [.text] to be compliant.
public struct Capabilities: OptionSet {
	public let rawValue: Int
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	/// Service supports plain text in conversations.
	/// Note: this should definitely be supported by all services.
	public static let text = Capabilities(rawValue: 1 << 0)
	
	/// Service supports rich text in conversations.
	/// If not supported, artificial tags (i.e. markdown syntax) can be used.
	public static let richText = Capabilities(rawValue: 1 << 1)
	
	/// Service supports sending photos in conversations.
	/// If not supported, a plain-text link to a CDN-hosted image can be used.
	public static let photo = Capabilities(rawValue: 1 << 2)
	
	/// Service supports sending audio in conversations.
	/// If not supported, a plain-text link to a CDN-hosted clip can be used.
	public static let audio = Capabilities(rawValue: 1 << 3)
	
	/// Service supports sending videos in conversations.
	/// If not supported, a plain-text link to a CDN-hosted video can be used.
	public static let video = Capabilities(rawValue: 1 << 4)
	
	/// Service supports uploading files to conversations.
	/// If not supported, upload to a separate server and link in the conversation.
	public static let fileUpload = Capabilities(rawValue: 1 << 5)
	
	/// Service supports posting text messages above a character limit.
	/// If not supported, chunk message and send individually.
	public static let posts = Capabilities(rawValue: 1 << 6)
	
	/// Service supports sending stickers in conversations.
	/// If not supported, a plain-text link to a CDN-hosted image can be used.
	/// Alternatively, a set of emoji can be supplied and elarged for effect.
	public static let stickers = Capabilities(rawValue: 1 << 7)
	
	/// Service supports reaction emoji per-message.
	/// There is no alternative if not supported.
	public static let reactions = Capabilities(rawValue: 1 << 8)
	
	/// Service supports multi-user (group) conversations.
	/// There is no alternative if not supported.
	public static let groups = Capabilities(rawValue: 1 << 9)
	
	/// Service supports public multi-user conversations or channels.
	/// There is no alternative if not supported.
	public static let publicGroups = Capabilities(rawValue: 1 << 10)
	
	/// Service supports named multi-user conversations (instead of just a list of users).
	/// There is no alternative if not supported.
	public static let namedGroups = Capabilities(rawValue: 1 << 11)
	
	/// Service supports multi-user conversations to have a set purpose.
	/// There is no alternative if not supported.
	public static let groupPurpose = Capabilities(rawValue: 1 << 12)
	
	/// Service supports modifying notification status in conversations.
	public static let snooze = Capabilities(rawValue: 1 << 13)
	
	/// Service supports overall user presence.
	/// There is no alternative if not supported.
	public static let presence = Capabilities(rawValue: 1 << 14)
	
	/// Service supports a "last seen" indicator for the user.
	/// There is no alternative if not supported.
	public static let lastSeen = Capabilities(rawValue: 1 << 15)
	
	/// Service supports a presence status message for the user.
	/// There is no alternative if not supported.
	public static let presenceStatus = Capabilities(rawValue: 1 << 16)
	
	/// Service supports native encryption of conversations.
	/// If not supported, a public/private key pair encryption scheme can be used.
	/// Note that without decryption, archived messages will look garbled.
	public static let encryption = Capabilities(rawValue: 1 << 17)
	
	/// Service supports sending read receipts in conversations.
	/// There is no alternative if not supported.
	public static let readReceipt = Capabilities(rawValue: 1 << 18)
	
	/// Service supports disabling chat archival in conversations.
	/// While this is a server-side flag, this should be handled by clients as well.
	/// There is no alternative if not supported.
	public static let offTheRecord = Capabilities(rawValue: 1 << 19)
	
	/// Service supports starring messages in conversations.
	/// There is no alternative if not supported.
	public static let starred = Capabilities(rawValue: 1 << 20)
	
	/// Service supports globally pinning messages in conversations.
	/// There is no alternative if not supported.
	public static let pinned = Capabilities(rawValue: 1 << 21)
	
	/// Service supports editing a previously sent message.
	/// There is no alternative if not supported.
	public static let editMessage = Capabilities(rawValue: 1 << 22)
}

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

public enum ServiceNotification2 {
	case didConnect
	case didReconnect
	case didDisconnect
	case didReceiveUpdate(Any)
}

public protocol Service: class {
	
	/// Returns the notification key for the event fired when this service connects
	/// successfully to its server/host.
	//static var didConnectNotification: Notification.Name { get }
	
	/// Returns the notification key for the event fired when this service reconnects
	/// upon a previous non-user-initiated disconnection.
	//static var didReconnectNotification: Notification.Name { get }
	
	/// Returns the notification key for the event fired when this service disconnects
	/// from its server/host.
	//static var didDisconnectNotification: Notification.Name { get }
	
	/// Returns the notification key for the event fired when this service receives
	/// an update of any kind; this should be used only by the service itself.
	//static var didReceiveUpdateNotification: Notification.Name { get }
	
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
	var me: User2 { get }
	
	/// Return all users the current user can locate.
	var users: [User2] { get }
	
	//var invitations: [User2] { get }
	
	//var blocked: [User2] { get }
	
	/// Search for users given a set of identifiers.
	/// Identifiers can include anything including name components.
	/// Returns a set of users that could be possible matches.
	func search(for identifiers: [String]) -> [User2]
}

public protocol User2 {
	
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
