import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Users")

/// A chat user.
public class User: Person, Hashable, Equatable {
    public let serviceIdentifier: String

    public static let DEFAULT_NAME = "Unknown"
	
	/// A chat user identifier.
	public struct ID: Hashable, Equatable {
		public let chatID: String
		public let gaiaID: String
	}
	
    public let id: User.ID
	public var identifier: String {
		return id.gaiaID
	}
	public let nameComponents: [String]
    public let photoURL: String?
    public let locations: [String]
    public let isSelf: Bool
	public var me: Bool {
		return self.isSelf
	}
	
	public var lastSeen: Date {
		return Date(timeIntervalSince1970: 0)
	}
	public var reachability: Reachability {
		return .unavailable
	}
	public var mood: String {
		return ""
	}
	
	// Initialize a User directly.
	// Handles full_name or first_name being nil by creating an approximate
	// first_name from the full_name, or setting both to DEFAULT_NAME.
	//
	// Ignores firstName value.
    public init(_ serviceIdentifier: String, userID: User.ID, fullName: String? = nil, photoURL: String? = nil,
                locations: [String] = [], isSelf: Bool = false) {
        self.serviceIdentifier = serviceIdentifier
		self.id = userID
		self.nameComponents = (fullName ?? User.DEFAULT_NAME).characters.split{$0 == " "}.map(String.init)
        self.photoURL = photoURL
        self.locations = locations
        self.isSelf = isSelf
    }
	
	// Parse and initialize a User from an Entity.
	// Note: If selfUser is nil, assume this is the self user.
    public convenience init(_ serviceIdentifier: String, entity: Entity, selfUser: User.ID?) {
        
		// Parse User ID and self status.
		let userID = User.ID(chatID: entity.id!.chatId!,
			gaiaID: entity.id!.gaiaId!)
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
		// If the entity has no provided properties, bail here.
		guard let props = entity.properties else {
			self.init(serviceIdentifier, userID: userID, fullName: "", photoURL: "", locations: [], isSelf: isSelf)
			return
		}
		
		// Parse possible phone numbers.
		var phoneI18N: String? = nil // just use I18N and reformat it if needed.
		if	let r = props._unknownFields[14] as? [Any], r.count > 0 {
			if let a = r[0] as? [Any], let b = a[0] as? [Any], let d = b[1] as? [Any] { // retrieve the I18nData
				phoneI18N = d[1] as? String
			}
		}
		
		// Parse the user photo.
		let photo: String? = props.photoUrl != nil ? "https:" + props.photoUrl! : nil
		
		// Parse possible locations.
		var locations: [String] = []
		locations += props.email
		locations += props.phone
		if let c = props.canonicalEmail {
			locations.append(c)
		}
		if let p = phoneI18N {
			locations.append(p)
		}
		
		// Initialize the user.
        self.init(serviceIdentifier, userID: userID,
            fullName: phoneI18N ?? props.displayName,
            photoURL: photo, locations: locations, isSelf: isSelf
        )
    }
}

// Collection of User instances.
public class UserList: Directory, Collection {
	
	private var observer: NSObjectProtocol? /*Notification Token*/
	fileprivate var users: [User.ID: User]
    private let client: Client
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
	
	public private(set) var me: Person
	public var people: [String: Person] {
		var dict = [String: Person]()
		for (key, value) in self.users {
			dict[key.gaiaID] = value
		}
		return dict
	}
	public var invitations: [String: Person] {
		return [:]
	}
	public var blocked: [String: Person] {
		return [:]
	}
    
    public subscript(_ identifier: String) -> Person {
        return self[User.ID(chatID: identifier, gaiaID: identifier)]
    }
	
	// Return a User by their User.ID.
	// Logs and returns a placeholder User if not found.
	internal subscript(userID: User.ID) -> User {
		if let user = self.users[userID] {
			return user
		} else {
			//log.warning("UserList returning unknown User for User.ID \(userID)")
			return User(self.serviceIdentifier, userID: userID)
		}
	}
    
    // Convenience for the latter method.
    internal func addPeople(from conversations: [IConversation]) -> [Person] {
        return self.addPeople(from: conversations.map { $0.conversation })
    }
    
    internal func addPeople(from conversations: [Conversation]) -> [Person] {
        var ret = [Person]()
        let s = DispatchSemaphore(value: 0)
        
        // Prepare a set of all conversation participant data first to batch the query.
        var required = Set<ConversationParticipantData>()
        conversations.forEach { conv in conv.participantData.forEach { required.insert($0) } }
        
        self.client.opQueue.sync {
            self.client.getEntitiesByID(chat_id_list: required.flatMap { $0.id?.chatId }) { response in
                let entities = response?.entityResult.flatMap { $0.entity } ?? []
                for entity in entities {
                    guard entity.id != nil else { continue } // if no id, we can't use it!
                    let user = User(self.serviceIdentifier, entity: entity, selfUser: (self.me as! User).id)
                    if self.users[user.id] == nil {
                        self.users[user.id] = user
                    }
                    ret.append(user as Person)
                }
                s.signal()
            }
        }
        s.wait()
        return ret
    }
    
    internal func getSelfInfo() {
        self.client.getSelfInfo {
            let selfUser = User(self.serviceIdentifier, entity: $0!.selfEntity!, selfUser: nil)
            self.users[selfUser.id] = selfUser
            self.me = selfUser
        }
    }
    
    public func lookup(by: [String]) -> [Person] {
        return lookup(by: by, limit: 10)
    }
    public func lookup(by: [String], limit: Int) -> [Person] {
        var ret = [Person]()
        let s = DispatchSemaphore(value: 0)
        self.client.opQueue.sync {
            self.client.getSuggestedEntities(max_count: limit) { r in
                log.debug("got \(r)")
                s.signal()
            }
        }
        s.wait()
        return ret
    }
    
	// Initialize the list of Users.
	public init(client: Client, me: User, users: [User] = []) {
		var usersDict = Dictionary<User.ID, User>()
		users.forEach { usersDict[$0.id] = $0 }
        
		self.users = usersDict
		self.me = me
        self.client = client
        
		self.observer = NotificationCenter.default
			.addObserver(forName: Client.didUpdateStateNotification, object: client, queue: nil) {
				if  let userInfo = $0.userInfo, let state_update = userInfo[Client.didUpdateStateKey],
                    let conversation = ((state_update as! Wrapper<StateUpdate>).element).conversation {
					_ = self.addPeople(from: [conversation])
				}
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self.observer!)
	}
}


// EXTENSIONS:


/// User.ID: Hashable
public extension User.ID {
	public var hashValue: Int {
		return chatID.hashValue &+ gaiaID.hashValue
	}
    public static func ==(lhs: User.ID, rhs: User.ID) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/// User: Hashable
public extension User {
	public var hashValue: Int {
		return self.id.hashValue
	}
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

/// UserList: Collection
public extension UserList {
	public typealias Index = DictionaryIndex<User.ID, User>
	public typealias SubSequence = Slice<LazyMapCollection<Dictionary<User.ID, User>, User>>
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
