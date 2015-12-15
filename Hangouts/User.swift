import Cocoa

// A chat user.
// Handles full_name or first_name being nil by creating an approximate
// first_name from the full_name, or setting both to DEFAULT_NAME.
public struct User {
    public static let DEFAULT_NAME = "Unknown"

    public let id: UserID
    public let full_name: String
    public let first_name: String
    public let photo_url: String?
    public let emails: [String]
    public let isSelf: Bool
	
	// Initialize a User.
    public init(user_id: UserID, full_name: String?=nil, first_name: String?=nil, photo_url: String?, emails: [String], is_self: Bool) {
		self.id = user_id
		let fname = full_name ?? User.DEFAULT_NAME
        self.full_name = fname
        self.first_name = first_name ?? fname.characters.split{$0==" "}.map{String($0)}.first!
		self.photo_url = photo_url != nil ? "https:" + photo_url! : nil
        self.emails = emails
        self.isSelf = is_self
    }
	
	// Initialize from a ClientEntity.
	// If self_user_id is nil, assume this is the self user.
    public init(entity: CLIENT_ENTITY, self_user_id: UserID?) {
        let user_id = UserID(chat_id: entity.id.chat_id as! String, gaia_id: entity.id.gaia_id as! String)
        var is_self = false
        if let sui = self_user_id {
            is_self = sui == user_id
        } else {
            is_self = true
        }
        self.init(user_id: user_id,
            full_name: entity.properties.display_name as String?,
            first_name: entity.properties.first_name as String?,
            photo_url: entity.properties.photo_url as String?,
            emails: entity.properties.emails.map { $0 as! String },
            is_self: is_self
        )

    }
	
	// Initialize from ClientConversationParticipantData.
	// If self_user_id is nil, assume this is the self user.
    public init(conv_part_data: CLIENT_CONVERSATION_PARTICIPANT_DATA, self_user_id: UserID?) {
        let user_id = UserID(chat_id: conv_part_data.id.chat_id as! String, gaia_id: conv_part_data.id.gaia_id as! String)
        var is_self = false
        if let sui = self_user_id {
            is_self = sui == user_id
        } else {
            is_self = true
        }
        self.init(user_id: user_id,
            full_name: conv_part_data.fallback_name as? String,
            first_name: nil,
            photo_url: nil,
            emails: [],
            is_self: is_self
        )
    }
}
