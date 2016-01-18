import Foundation // NSNotificationCenter

/* TODO: Support DictionaryLiteralConvertible, CollectionType, Indexable. */
/* TODO: Support SequenceType, MutableCollectionType, MutableIndexable. */

// Collection of User instances.
public class UserList {
	
	/* TODO: Don't hold a reference to client. */
	private let client: Client
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
	
	// UserList: SequenceType
	/*public func generate() -> AnyGenerator<User> {
		var index = 0
		return anyGenerator {
			defer { index++ }
			return Array(self.users.values)[index]
		}
	}*/
	
	// Initialize the list of Users.
	// Creates users from the given ClientEntity and
	// ClientConversationParticipantData instances. The latter is used only as
	// a fallback, because it doesn't include a real first_name.
	public init(client: Client, selfEntity: ENTITY, entities: [ENTITY] = [], data: [CONVERSATION_PARTICIPANT_DATA]) {
		self.client = client
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
		
		let n = NSNotificationCenter.defaultCenter()
		n.addObserverForName(ClientStateUpdatedNotification, object: self.client, queue: nil) {
			self.on_state_update_notification($0)
		}
		
		/*n.addObserver(
			self,
			selector: Selector("on_state_update_notification:"),
			name: ClientStateUpdatedNotification,
			object: self.client
		)*/
	}
	
	deinit {
		//NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	/* TODO: Switch away from the old API to a nicer EventBus-style one. */
	public func on_state_update_notification(notification: NSNotification) {
		if let userInfo = notification.userInfo, state_update = userInfo[ClientStateUpdatedNewStateKey as NSString] {
			if let conversation = (state_update as! STATE_UPDATE).client_conversation {
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

public func buildUserConversationList(client: Client, cb: (UserList, ConversationList) -> Void) {
	
	// Retrieve recent conversations so we can preemptively look up their participants.
	client.syncRecentConversations { response in
		let conv_states = response!.conversation_state
		
		// syncrecentconversations seems to return a sync_timestamp 4 minutes
		// before the present. To prevent syncallnewevents later breaking
		// requesting events older than what we already have, use
		// current_server_time instead. use:
		//
		// from_timestamp(response!.response_header!.current_server_time)
		let sync_timestamp = from_timestamp(response!.sync_timestamp)
		
		var required_user_ids = Set<UserID>()
		for conv_state in conv_states {
			let participants = conv_state.conversation!.participant_data
			required_user_ids = required_user_ids.union(Set(participants.map {
				UserID(chatID: $0.id.chat_id as! String, gaiaID: $0.id.gaia_id as! String)
			}))
		}
		
		var required_entities = Array<ENTITY>()
		if required_user_ids.count > 0 {
			client.getEntitiesByID(required_user_ids.map { $0.chatID }) { resp in
				required_entities = resp!.entities
			}
		}
		
		var conv_part_list = Array<CONVERSATION_PARTICIPANT_DATA>()
		for conv_state in conv_states {
			let participants = conv_state.conversation!.participant_data
			conv_part_list.appendContentsOf(participants)
		}
		
		// Let's request our own entity now.
		var self_entity = ENTITY()
		client.getSelfInfo {
			self_entity = $0!.self_entity!
			
			let userList = UserList(client: client, selfEntity: self_entity, entities: required_entities, data: conv_part_list)
			let conversationList = ConversationList(client: client, conv_states: conv_states, user_list: userList, sync_timestamp: sync_timestamp)
			cb(userList, conversationList)
		}
	}
}
