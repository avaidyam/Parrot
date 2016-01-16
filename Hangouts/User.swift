import Cocoa

// A chat user identifier.
// Use the much more full-featured User class for more data.
public struct UserID : Hashable, Equatable {
	public let chatID: String
	public let gaiaID: String
	
	// UserID: Equatable
	public var hashValue: Int {
		return chatID.hashValue &+ gaiaID.hashValue
	}
}

// UserID: Equatable
public func ==(lhs: UserID, rhs: UserID) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

// A chat user.
public struct User: Hashable, Equatable {
    public static let DEFAULT_NAME = "Unknown"

    public let id: UserID
    public let fullName: String
    public let firstName: String
    public let photoURL: String?
    public let emails: [String]
    public let isSelf: Bool
	
	// Initialize a User directly.
	// Handles full_name or first_name being nil by creating an approximate
	// first_name from the full_name, or setting both to DEFAULT_NAME.
    public init(userID: UserID, var fullName: String? = nil, firstName: String? = nil,
		photoURL: String? = nil, emails: [String] = [], isSelf: Bool = false) {
		fullName = fullName ?? User.DEFAULT_NAME
		
		self.id = userID
        self.fullName = fullName!
        self.firstName = firstName ?? fullName!.characters.split { $0 == " " }.map{ String($0) }.first!
		self.photoURL = photoURL != nil ? "https:" + photoURL! : nil
        self.emails = emails
        self.isSelf = isSelf
    }
	
	// Initialize a User from an Entity.
	// If selfUser is nil, assume this is the self user.
    public init(entity: ENTITY, selfUser: UserID?) {
		let userID = UserID(chatID: entity.id.chat_id as! String,
			gaiaID: entity.id.gaia_id as! String)
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
        self.init(userID: userID,
            fullName: entity.properties.display_name as String?,
            firstName: entity.properties.first_name as String?,
            photoURL: entity.properties.photo_url as String?,
            emails: entity.properties.emails.map { $0 as! String },
            isSelf: isSelf
        )

    }
	
	// Initialize from ClientConversationParticipantData.
	// If selfUser is nil, assume this is the self user.
    public init(data: CONVERSATION_PARTICIPANT_DATA, selfUser: UserID?) {
		let userID = UserID(chatID: data.id.chat_id as! String,
			gaiaID: data.id.gaia_id as! String)
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
        self.init(userID: userID,
            fullName: data.fallback_name as? String,
            firstName: nil,
            photoURL: nil,
            emails: [],
            isSelf: isSelf
        )
    }
	
	// User: Hashable
	public var hashValue: Int {
		return self.id.hashValue
	}
}

// User: Equatable
public func ==(lhs: User, rhs: User) -> Bool {
	return lhs.id == rhs.id
}
