
/// Allows ServiceExtension objects to be traced back to a Service by its identifier.
public protocol ServiceOriginating {
    var serviceIdentifier: Service.IdentifierType { get }
}

/// A set of capabilities a Service can support.
public struct Capabilities: OptionSet {
    public typealias RawValue = Int
    public let rawValue: Capabilities.RawValue
    public init(rawValue: Capabilities.RawValue) {
        self.rawValue = rawValue
    }
    
    /// Service supports multi-user (group) conversations.
    /// There is no alternative if not supported.
    public static let groupMessage = Capabilities(rawValue: 1 << 0)
    
    /// Service supports public multi-user conversations or channels.
    /// There is no alternative if not supported.
    public static let publicGroup = Capabilities(rawValue: 1 << 1)
    
    /// Service supports named multi-user conversations (instead of just a list of users).
    /// There is no alternative if not supported.
    public static let namedGroup = Capabilities(rawValue: 1 << 2)
    
    /// Service supports multi-user conversations to have a set purpose.
    /// There is no alternative if not supported.
    public static let groupTopic = Capabilities(rawValue: 1 << 3)
    
    /// Service supports modifying notification status in conversations.
    public static let snooze = Capabilities(rawValue: 1 << 4)
    
    /// Service supports overall user presence.
    /// There is no alternative if not supported.
    public static let presence = Capabilities(rawValue: 1 << 5)
    
    /// Service supports a "last seen" indicator for the user.
    /// There is no alternative if not supported.
    public static let lastSeen = Capabilities(rawValue: 1 << 6)
    
    /// Service supports a presence status message for the user.
    /// There is no alternative if not supported.
    public static let presenceStatus = Capabilities(rawValue: 1 << 7)
    
    /// Service supports native encryption of conversations.
    /// If not supported, a public/private key pair encryption scheme can be used.
    /// Note that without decryption, archived messages will look garbled.
    public static let encryption = Capabilities(rawValue: 1 << 8)
    
    /// Service supports sending read receipts in conversations.
    /// There is no alternative if not supported.
    public static let watermark = Capabilities(rawValue: 1 << 9)
    
    /// Service supports disabling chat archival in conversations.
    /// While this is a server-side flag, this should be handled by clients as well.
    /// There is no alternative if not supported.
    public static let offTheRecord = Capabilities(rawValue: 1 << 10)
    
    /// Service supports starring messages in conversations.
    /// There is no alternative if not supported.
    public static let starredMessage = Capabilities(rawValue: 1 << 11)
    
    /// Service supports globally pinning messages in conversations.
    /// There is no alternative if not supported.
    public static let pinnedMessage = Capabilities(rawValue: 1 << 12)
    
    /// Service supports editing a previously sent message.
    /// There is no alternative if not supported.
    public static let editMessage = Capabilities(rawValue: 1 << 13)
    
    /// Service supports transfering a file peer-to-peer.
    /// There is no alternative if not supported.
    public static let fileTransfer = Capabilities(rawValue: 1 << 14)
}

/// Defines all possible capabilities that Parrot will understand that can be
/// vended by a remote messaging Service. Note that at the absolute minimum,
/// a Service must support [.text] to be compliant.
public protocol Service: class {
    
    typealias IdentifierType = String
	
	/// The reverse domain name identifier of this specific Service.
	/// Note that having a unique identifier is required, but more than one instance
	/// of the Service may exist if the user has logged into multiple accounts
	/// from the same Service extension point.
	static var identifier: IdentifierType { get }
	
	/// The user-friendly name of this Service. It will be used to display the
	/// discovered Service to a user for accounts or in notifications.
	static var name: String { get }
    
    /// The supported capabilities the Service can vend.
    static var capabilities: Capabilities { get }
	
	/// Connects the service to its server/host.
	/// Returns true if connection succeeded, or false if it failed.
	func connect()
	
	/// Disconnects the service from its service/host.
	/// Returns true if the disconnection succeeded, or false if it failed.
	func disconnect()
	
	/// Synchronizes events and dispatches a didReceiveUpdate event upon completion.
	/// This is required in case network connection is lost or switched.
	/// Returns true if synchronization succeeded, or false if it failed.
	func synchronize()
	
	/// The current connection state of the service.
	/// See connect() and disconnect().
	var connected: Bool { get }
	
	/// The directory of people (including the logged in user) that can be
	/// queried for presence or contacted in some form.
	var directory: Directory { get }
	
	/// The list of conversations that are either ongoing or have ended between
	/// the logged in user and other people on the Service.
	var conversations: ConversationList { get }
    
    /// The setInteractingIfNeeded follows the user's activity in the app and mirrors
    /// it across the entire platform; that is, if the user is currently looking
    /// at a screen in Parrot, they should not receive notifications on other devices.
    func setInteractingIfNeeded()
}
