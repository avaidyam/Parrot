import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Users")

/// A chat user.
public class User: Person, Hashable, Equatable {
    private unowned let client: Client
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }

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
	public private(set) var me: Bool
    
    public internal(set) var lastSeen: Date = Date(timeIntervalSince1970: 0)
    public internal(set) var reachability: Reachability = .unavailable
    public internal(set) var mood: String = ""
	
	// Initialize a User directly.
	// Handles full_name or first_name being nil by creating an approximate
	// first_name from the full_name, or setting both to DEFAULT_NAME.
	//
	// Ignores firstName value.
    public init(_ client: Client, userID: User.ID, fullName: String? = nil, photoURL: String? = nil,
                locations: [String] = [], me: Bool = false) {
        self.client = client
		self.id = userID
		self.nameComponents = (fullName ?? User.DEFAULT_NAME).characters.split{$0 == " "}.map(String.init)
        self.photoURL = photoURL
        self.locations = locations
        self.me = me
    }
	
	// Parse and initialize a User from an Entity.
	// Note: If selfUser is nil, assume this is the self user.
    public convenience init(_ client: Client, entity: Entity, selfUser: User.ID?) {
        
		// Parse User ID and self status.
		let userID = User.ID(chatID: entity.id!.chatId!,
			gaiaID: entity.id!.gaiaId!)
		let isSelf = (selfUser != nil ? (selfUser == userID) : true)
		
		// If the entity has no provided properties, bail here.
		guard let props = entity.properties else {
			self.init(client, userID: userID, fullName: "", photoURL: "", locations: [], me: isSelf)
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
        self.init(client, userID: userID,
            fullName: phoneI18N ?? props.displayName,
            photoURL: photo, locations: locations, me: isSelf
        )
    }
}

// Collection of User instances.
public class UserList: Directory, Collection {
	
	fileprivate var users: [User.ID: User]
    private unowned let client: Client
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
			return User(self.client, userID: userID)
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
            
            // Required step: get the base User objects prepared.
            self.client.getEntitiesByID(chat_id_list: required.flatMap { $0.id?.chatId }) { response in
                let entities = response?.entityResult.flatMap { $0.entity } ?? []
                for entity in entities {
                    guard entity.id != nil else { continue } // if no id, we can't use it!
                    let user = User(self.client, entity: entity, selfUser: (self.me as! User).id)
                    if self.users[user.id] == nil {
                        self.users[user.id] = user
                    }
                    ret.append(user as Person)
                }
                s.signal()
            }
            s.wait()
            
            // Optional: Once we have all the entities, get their presence data.
            self.client.queryPresence(chat_ids: required.flatMap { $0.id?.chatId }) {
                for pres2 in $0!.presenceResult {
                    let userid = pres2.userId!
                    let pres = pres2.presence!
                    
                    let available = pres.available ?? false
                    let reachable = pres.reachable ?? false
                    let mobile = pres.deviceStatus?.mobile ?? false
                    let desktop = pres.deviceStatus?.desktop ?? false
                    let tablet = pres.deviceStatus?.tablet ?? false
                    let none = !mobile && !desktop && !tablet
                    let reach = Reachability.unavailable
                    
                    let lastSeenUTC = pres.lastSeen?.lastSeenTimestampUsec ?? 0
                    let lastSeenDate = Date.from(UTC: Double(lastSeenUTC))
                    
                    var lines = [""]
                    let moodSegments = pres.moodSetting?.moodMessage?.moodContent?.segment ?? []
                    for segment in moodSegments {
                        if segment.type == nil { continue }
                        switch (segment.type) {
                        case SegmentType.Text, SegmentType.Link:
                            let replacement = lines.last! + segment.text!
                            lines.removeLast()
                            lines.append(replacement)
                        case SegmentType.LineBreak:
                            lines.append("\n")
                        default:
                            log.warning("Ignoring unknown chat message segment type: \(segment.type)")
                        }
                    }
                    let moodText = lines.filter { $0 != "" }.joined(separator: "\n")
                    var user = self.users[User.ID(chatID: userid.chatId!, gaiaID: userid.gaiaId!)]
                    user?.lastSeen = lastSeenDate
                    user?.reachability = reach
                    user?.mood = moodText
                }
            }
        }
        return ret
    }
    
    internal static func getSelfInfo(_ client: Client) -> User {
        var selfUser: User! = nil
        let s = DispatchSemaphore(value: 0)
        client.opQueue.async {
            client.getSelfInfo {
                selfUser = User(client, entity: $0!.selfEntity!, selfUser: nil)
                s.signal()
            }
        }
        s.wait()
        return selfUser
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
    public init(client: Client, users: [User] = []) {
        self.client = client
        
		var usersDict = Dictionary<User.ID, User>()
		users.forEach { usersDict[$0.id] = $0 }
		self.users = usersDict
        
        let me = UserList.getSelfInfo(self.client)
        self.users[me.id] = me
        self.me = me
        
        hangoutsCenter.addObserver(self, selector: #selector(UserList._updatedState(_:)),
                                               name: Client.didUpdateStateNotification, object: client)
	}
	
	deinit {
		hangoutsCenter.removeObserver(self)
	}
    
    @objc
    internal func _updatedState(_ notification: Notification) {
        if  let userInfo = notification.userInfo, let state_update = userInfo[Client.didUpdateStateKey],
            let conversation = ((state_update as! Wrapper<StateUpdate>).element).conversation {
            _ = self.addPeople(from: [conversation])
        }
    }
}

// TODO: Make this better...
/*
func await(qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], _ block: @escaping () -> Void) {
    let s = DispatchSemaphore(value: 0)
    let w = DispatchWorkItem(flags: .assignCurrentContext, block: block)
    w.notify(queue: .main) {
        s.signal()
    }
    s.wait()
}
*/


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
