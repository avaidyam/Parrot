import Foundation

/// Defines all possible capabilities that Parrot will understand that can be
/// vended by a remote messaging Service. Note that at the absolute minimum,
/// a Service must support [.text] to be compliant.
public protocol Service: class {
	
	/// The reverse domain name identifier of this specific Service.
	/// Note that having a unique identifier is required, but more than one instance
	/// of the Service may exist if the user has logged into multiple accounts
	/// from the same Service extension point.
	static var identifier: String { get }
	
	/// The user-friendly name of this Service. It will be used to display the
	/// discovered Service to a user for accounts or in notifications.
	static var name: String { get }
	
	/// Connects the service to its server/host.
	/// Returns true if connection succeeded, or false if it failed.
	func connect(_ onConnect: (ErrorProtocol?) -> ())
	
	/// Disconnects the service from its service/host.
	/// Returns true if the disconnection succeeded, or false if it failed.
	func disconnect(_ onDisconnect: (ErrorProtocol?) -> ())
	
	/// Synchronizes events and dispatches a didReceiveUpdate event upon completion.
	/// This is required in case network connection is lost or switched.
	/// Returns true if synchronization succeeded, or false if it failed.
	func synchronize(_ onSynchronize: (ErrorProtocol?) -> ())
	
	/// The current connection state of the service.
	/// See connect() and disconnect().
	var connected: Bool { get }
	
	/// The directory of people (including the logged in user) that can be
	/// queried for presence or contacted in some form.
	var directory: Directory { get }
	
	/// The list of conversations that are either ongoing or have ended between
	/// the logged in user and other people on the Service.
	var conversations: ConversationList { get }
}

/// Service supports plain text in conversations.
/// Note: this should definitely be supported by all services.
public protocol SendTextSupport {}

/// Service supports rich text in conversations.
/// If not supported, artificial tags (i.e. markdown syntax) can be used.
public protocol SendRichTextSupport {}

/// Service supports sending photos in conversations.
/// If not supported, a plain-text link to a CDN-hosted image can be used.
public protocol SendPhotoSupport {}

/// Service supports sending audio in conversations.
/// If not supported, a plain-text link to a CDN-hosted clip can be used.
public protocol SendAudioSupport {}

/// Service supports sending videos in conversations.
/// If not supported, a plain-text link to a CDN-hosted video can be used.
public protocol SendVideoSupport {}

/// Service supports uploading files to conversations.
/// If not supported, a plain-text link to a CDN-hosted file can be used.
public protocol SendFileSupport {}

/// Service supports posting text messages above a character limit.
/// If not supported, chunk message and send individually.
public protocol SendTextPostSupport {}

/// Service supports sending stickers in conversations.
/// If not supported, a plain-text link to a CDN-hosted image can be used.
/// Alternatively, a set of emoji can be supplied and elarged for effect.
public protocol SendStickerSupport {}

/// Service supports reaction emoji per-message.
/// There is no alternative if not supported.
public protocol SendReactionSupport {}

/// Service supports multi-user (group) conversations.
/// There is no alternative if not supported.
public protocol GroupMessageSupport {}

/// Service supports public multi-user conversations or channels.
/// There is no alternative if not supported.
public protocol PublicGroupSupport {}

/// Service supports named multi-user conversations (instead of just a list of users).
/// There is no alternative if not supported.
public protocol NamedGroupSupport {}

/// Service supports multi-user conversations to have a set purpose.
/// There is no alternative if not supported.
public protocol GroupTopicSupport {}

/// Service supports modifying notification status in conversations.
public protocol SnoozeSupport {}

/// Service supports overall user presence.
/// There is no alternative if not supported.
public protocol PresenceSupport {}

/// Service supports a "last seen" indicator for the user.
/// There is no alternative if not supported.
public protocol LastSeenSupport {}

/// Service supports a presence status message for the user.
/// There is no alternative if not supported.
public protocol PresenceStatusSupport {}

/// Service supports native encryption of conversations.
/// If not supported, a public/private key pair encryption scheme can be used.
/// Note that without decryption, archived messages will look garbled.
public protocol EncryptionSupport {}

/// Service supports sending read receipts in conversations.
/// There is no alternative if not supported.
public protocol WatermarkSupport {}

/// Service supports disabling chat archival in conversations.
/// While this is a server-side flag, this should be handled by clients as well.
/// There is no alternative if not supported.
public protocol OffTheRecordSupport {}

/// Service supports starring messages in conversations.
/// There is no alternative if not supported.
public protocol StarredMessageSupport {}

/// Service supports globally pinning messages in conversations.
/// There is no alternative if not supported.
public protocol PinnedMessageSupport {}

/// Service supports editing a previously sent message.
/// There is no alternative if not supported.
public protocol EditMessageSupport {}
