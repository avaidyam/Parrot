import Foundation

// Collection of User instances.
public class UserList {
	
	private let client: Client
	private let selfUser: User
	private var users: [UserID : User]
	
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
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: Selector("on_state_update_notification:"),
			name: ClientStateUpdatedNotification,
			object: self.client
		)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	/* TODO: Switch away from the old API to a nicer Notification one. */
	
	// Receive a ClientStateUpdatedNotification
	public func on_state_update_notification(notification: NSNotification) {
		if let userInfo = notification.userInfo, state_update = userInfo[ClientStateUpdatedNewStateKey as NSString] {
			on_state_update(state_update as! STATE_UPDATE)
		}
	}
	
	// Receive a ClientStateUpdate
	private func on_state_update(state_update: STATE_UPDATE) {
		if let conversation = state_update.client_conversation {
			self.handle_client_conversation(conversation)
		}
	}
	
	// Receive Conversation and update list of users
	private func handle_client_conversation(client_conversation: CONVERSATION) {
		for participant in client_conversation.participant_data {
			let user = User(data: participant, selfUser: self.selfUser.id)
			if self.users[user.id] == nil {
				self.users[user.id] = user
			}
		}
	}
}

// Return UserList from initial contact data and an additional request.
// The initial data contains the user's contacts, but there may be conversations
// containing users that are not in the contacts. This function takes care of
// requesting data for those users and constructing the UserList.
/* INITIALDATA
public func buildUserList(client: Client, initial_data: InitialData, cb: (UserList) -> Void) {
	let all_entities = initial_data.entities + [initial_data.self_entity]
	let present_user_ids = Set(all_entities.map {
		UserID(chat_id: $0.id.chat_id as! String, gaia_id: $0.id.gaia_id as! String)
	})
	
	var required_user_ids = Set<UserID>()
	for conv_state in initial_data.conversation_states {
		required_user_ids = required_user_ids.union(Set(conv_state.conversation.participant_data.map {
			UserID(chat_id: $0.id.chat_id as! String, gaia_id: $0.id.gaia_id as! String)
		}))
	}
	
	let missing_user_ids = required_user_ids.subtract(present_user_ids)
	if missing_user_ids.count > 0 {
		client.getEntitiesByID(missing_user_ids.map { $0.chat_id }) { missing_entities in
			cb(UserList(
				client: client,
				self_entity: initial_data.self_entity,
				entities: initial_data.entities + missing_entities.entities,
				conv_parts: initial_data.conversation_participants
			))
		}
	} else {
		cb(UserList(
			client: client,
			self_entity: initial_data.self_entity,
			entities: initial_data.entities,
			conv_parts: initial_data.conversation_participants
		))
	}
}
*/

public func buildUserConversationList(client: Client, cb: (UserList, ConversationList) -> Void) {
	
	// Retrieve recent conversations so we can preemptively look up their participants.
	client.syncRecentConversations { response in
		
		/* TODO: Still a little work here. Not sure why [CONVERSATION_STATE] keeps dying. */
		// Essentially, without this fixing code here, everything crashes.
		// I'm guessing PBLite skips over the elements here for some reason?
		var conv_states = [CONVERSATION_STATE]()
		for conv_state in (response!.conversation_state as [AnyObject]) {
			let a = PBLiteSerialization.parseArray(CONVERSATION_STATE.self, input: conv_state as? NSArray)!
			conv_states.append(a)
		}
		
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
				required_entities = resp.entities
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
