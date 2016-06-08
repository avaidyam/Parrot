import Foundation // NSNotificationCenter

// Collection of User instances.
public class UserList {
	
	private var observer: NSObjectProtocol? // for NSNotification
	private let selfUser: User
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
	public init(client: Client, selfEntity: Entity, entities: [Entity] = [], data: [ConversationParticipantData]) {
		self.selfUser = User(entity: selfEntity, selfUser: nil)
		self.users = [self.selfUser.id: self.selfUser]
		
		// Add each entity as a new User.
		for entity in entities {
			let user = User(entity: entity, selfUser: self.selfUser.id)
			self.users[user.id] = user
		}
		
		// Add each conversation participant as a new User if we didn't already add them from an entity.
		for participant in data {
			let user = User(data: participant, selfUser: self.selfUser.id)
			if self.users[user.id] == nil {
				self.users[user.id] = user
			}
		}
		
		self.observer = NSNotificationCenter.default()
			.addObserver(forName: Client.didUpdateStateNotification, object: client, queue: nil) {
			
			if let userInfo = $0.userInfo,
				state_update = userInfo[Client.didUpdateStateKey as NSString] {
				
				if let conversation = ((state_update as! Wrapper<StateUpdate>).wrapped).conversation {
					for participant in conversation.participantData {
						
						let user = User(data: participant, selfUser: self.selfUser.id)
						if self.users[user.id] == nil {
							self.users[user.id] = user
						}
					}
				}
			}
		}
	}
	
	deinit {
		NSNotificationCenter.default().removeObserver(self.observer!)
	}
}

// UserList Collection support.
extension UserList: Collection {
	public typealias Index = DictionaryIndex<UserID, User>
	
	public var startIndex : Index {
		return self.users.values.startIndex
	}
	
	public var endIndex : Index {
		return self.users.values.startIndex
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
	
	public subscript(bounds: Range<Index>) -> [Index] {
		return [] // FIXME!!!
	}
}
