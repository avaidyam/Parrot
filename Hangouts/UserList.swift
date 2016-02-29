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
		
		self.observer = NSNotificationCenter.defaultCenter()
			.addObserverForName(Client.didUpdateStateNotification, object: client, queue: nil) {
			
			if let userInfo = $0.userInfo,
				state_update = userInfo[Client.didUpdateStateKey as NSString] {
				
				if let conversation = (state_update as! StateUpdate).client_conversation {
					for participant in conversation.participant_data {
						
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
		NSNotificationCenter.defaultCenter().removeObserver(self.observer!)
	}
}

// UserList CollectionType support.
extension UserList: CollectionType {
	public typealias Index = DictionaryIndex<UserID, User>
	
	// UserList: CollectionType
	public var startIndex : UserList.Index {
		return self.users.values.startIndex
	}
	
	// UserList: CollectionType
	public var endIndex : UserList.Index {
		return self.users.values.startIndex
	}
	
	// UserList: CollectionType
	public subscript(index: UserList.Index) -> User {
		return self.users.values[index]
	}
}
