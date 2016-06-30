import Foundation

// A chat user identifier.
// Use the much more full-featured User class for more data.
public struct UserID : Hashable, Equatable {
	public let chatID: String
	public let gaiaID: String
}

// UserID: Hashable, Equatable
public extension UserID {
	public var hashValue: Int {
		return chatID.hashValue &+ gaiaID.hashValue
	}
}
public func ==(lhs: UserID, rhs: UserID) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

// A chat user.
public struct User: Hashable, Equatable {
    public static let DEFAULT_NAME = "Unknown"
	
    public let id: UserID
	public let nameComponents: [String]
    public let photoURL: String?
    public let emails: [String]
    public let isSelf: Bool
	
	// Initialize a User directly.
	// Handles full_name or first_name being nil by creating an approximate
	// first_name from the full_name, or setting both to DEFAULT_NAME.
	//
	// Ignores firstName value.
    public init(userID: UserID, fullName: String? = nil, firstName: String? = nil,
		photoURL: String? = nil, emails: [String] = [], isSelf: Bool = false)
	{
		self.id = userID
		self.nameComponents = (fullName ?? User.DEFAULT_NAME).characters.split{$0 == " "}.map(String.init)
        self.photoURL = photoURL != nil ? "https:" + photoURL! : nil
        self.emails = emails
        self.isSelf = isSelf
    }
	
	// Initialize a User from an Entity.
	// If selfUser is nil, assume this is the self user.
    public init(entity: Entity, selfUser: UserID?) {
		let userID = UserID(chatID: entity.id!.chatId!,
			gaiaID: entity.id!.gaiaId!)
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
		var phoneI18N: String? = nil // just use I18N and reformat it if needed.
		if	let r = entity.properties?._unknownFields[14] as? [AnyObject] where r.count > 0 {
			if let d = r[0][0][1] as? [AnyObject] { // retrieve the I18nData
				phoneI18N = d[1] as? String
			}
		}
		
        self.init(userID: userID,
            fullName: phoneI18N ?? (entity.properties!.displayName as String?),
            firstName: entity.properties!.firstName as String?,
            photoURL: entity.properties!.photoUrl as String?,
            emails: entity.properties!.email.map { $0 as String },
            isSelf: isSelf
        )
    }
	
	// TODO: REMOVE THIS
	// Initialize from ClientConversationParticipantData.
	// If selfUser is nil, assume this is the self user.
    /*public init(data: ConversationParticipantData, selfUser: UserID?) {
		let userID = UserID(chatID: data.id!.chatId!,
			gaiaID: data.id!.gaiaId!)
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
        self.init(userID: userID,
            fullName: data.fallbackName,
            firstName: nil,
            photoURL: nil,
            emails: [],
            isSelf: isSelf
        )
	}*/
	
	// Computes the full name by taking the name components like so:
	// ["John", "Mark", "Smith"] => "John Mark Smith"
	// Will return an empty string if there are no name components.
	public var fullName: String {
		return self.nameComponents.joined(separator: " ")
	}
	
	// Computes the first name by taking the first of the name components:
	// ["John", "Mark", "Smith"] => "John"
	// Will return an empty string if there are no name components.
	public var firstName: String {
		return self.nameComponents.first ?? ""
	}
}

// User: Hashable, Equatable
public extension User {
	public var hashValue: Int {
		return self.id.hashValue
	}
}
public func ==(lhs: User, rhs: User) -> Bool {
	return lhs.id == rhs.id
}


// Collection of User instances.
public class UserList: Collection {
	
	private var observer: NSObjectProtocol? // for Notification
	private let me: User
	private var users: [UserID: User]
	
	// Returns all users as an array.
	public var allUsers: [User] {
		return Array(self.users.values)
	}
	
	// Return a User by their UserID.
	// Logs and returns a placeholder User if not found.
	public subscript(userID: UserID) -> User {
		if let user = self.users[userID] {
			return user
		} else {
			print("UserList returning unknown User for UserID \(userID)")
			return User(userID: userID)
		}
	}
	
	// Initialize the list of Users.
	// Creates users from the given ClientEntity and
	// ClientConversationParticipantData instances. The latter is used only as
	// a fallback, because it doesn't include a real first_name.
	public init(client: Client, me: User, users: [User] = []) {
		var usersDict = [UserID: User]()
		users.forEach { usersDict[$0.id] = $0 }
		self.users = usersDict
		self.me = me
		
		self.observer = NotificationCenter.default()
			.addObserver(forName: Client.didUpdateStateNotification, object: client, queue: nil) {
				
				if let userInfo = $0.userInfo,
					state_update = userInfo[Client.didUpdateStateKey.rawValue] {
					
					if let conversation = ((state_update as! Wrapper<StateUpdate>).element).conversation {
						client.getEntitiesByID(chat_id_list: conversation.participantData.flatMap { $0.id?.chatId }) { response in
							let entities = response?.entityResult.flatMap { $0.entity } ?? []
							for entity in entities {
								let user = User(entity: entity, selfUser: self.me.id)
								if self.users[user.id] == nil {
									self.users[user.id] = user
								}
							}
						}
						
						// TODO: REMOVE THIS
						/*for participant in conversation.participantData {
							let user = User(data: participant, selfUser: self.me.id)
							if self.users[user.id] == nil {
								self.users[user.id] = user
							}
						}*/
					}
				}
		}
	}
	
	deinit {
		NotificationCenter.default().removeObserver(self.observer!)
	}
}

// UserList Collection support.
public extension UserList {
	public typealias Index = DictionaryIndex<UserID, User>
	public typealias SubSequence = Slice<LazyMapCollection<Dictionary<UserID, User>, User>>
	
	public var startIndex : Index {
		return self.users.values.startIndex
	}
	
	public var endIndex : Index {
		return self.users.values.endIndex
	}
	
	public func index(after i: Index) -> Index {
		return self.users.values.index(after: i)
	}
	
	public func formIndex(after i: inout Index) {
		return self.users.values.formIndex(after: &i)
	}
	
	public subscript(index: Index) -> User {
		return self.users.values[index]
	}
	
	public subscript(bounds: Range<Index>) -> SubSequence {
		return self.users.values[bounds]
	}
}
