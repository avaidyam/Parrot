import Foundation

public let ClientStateUpdatedNotification = "ClientStateUpdated"
public let ClientStateUpdatedNewStateKey = "ClientStateNewState"

// Collection of User instances.
public class UserList : NSObject {
	
	private let client: Client
	private let self_user: User
	private var user_dict: [UserID : User]
	
	// Initialize the list of Users.
	// Creates users from the given ClientEntity and
	// ClientConversationParticipantData instances. The latter is used only as
	// a fallback, because it doesn't include a real first_name.
	public init(client: Client, self_entity: ENTITY, entities: [ENTITY], conv_parts: [CONVERSATION_PARTICIPANT_DATA]) {
		
		self.client = client
		self.self_user = User(entity: self_entity, self_user_id: nil)
		self.user_dict = [self.self_user.id: self.self_user]
		
		super.init()
		
		// Add each entity as a new User.
		for entity in entities {
			let user = User(entity: entity, self_user_id: self.self_user.id)
			self.user_dict[user.id] = user
		}
		
		// Add each conversation participant as a new User if we didn't already add them from an entity.
		for participant in conv_parts {
			self.add_user_from_conv_part(participant)
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
	
	// Return a User by their UserID.
	// Raises KeyError if the User is not available.
	public func get_user(user_id: UserID) -> User {
		if let elem = self.user_dict[user_id] {
			return elem
		} else {
			print("UserList returning unknown User for UserID \(user_id)")
			return User(user_id: user_id,
				full_name: User.DEFAULT_NAME,
				first_name: nil,
				photo_url: nil,
				emails: [],
				is_self: false
			)
		}
	}
	
	// Returns all the users known
	public func get_all() -> [User] {
		return Array(self.user_dict.values)
	}
	
	// Add new User from ClientConversationParticipantData
	public func add_user_from_conv_part(conv_part: CONVERSATION_PARTICIPANT_DATA) -> User {
		let user = User(conv_part_data: conv_part, self_user_id: self.self_user.id)
		if self.user_dict[user.id] == nil {
			print("Adding fallback User: \(user)")
			self.user_dict[user.id] = user
		}
		return user
	}
	
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
			self.add_user_from_conv_part(participant)
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
	
	// Let's request our own entity first.
	var self_entity = ENTITY()
	client.getSelfInfo {
		self_entity = $0!.self_entity!
		
		// Retrieve recent conversations so we can preemptively look up their participants.
		client.syncRecentConversations { response in
			let conv_states = response!.conversation_state
			let sync_timestamp = from_timestamp(response!.sync_timestamp)
			
			var required_user_ids = Set<UserID>()
			for conv_state in conv_states {
				required_user_ids = required_user_ids.union(Set(conv_state.conversation.participant_data.map {
					UserID(chat_id: $0.id.chat_id as! String, gaia_id: $0.id.gaia_id as! String)
				}))
			}
			
			var required_entities = Array<ENTITY>()
			if required_user_ids.count > 0 {
				client.getEntitiesByID(required_user_ids.map { $0.chat_id }) { resp in
					required_entities = resp.entities
				}
			}
			
			var conv_part_list = Array<CONVERSATION_PARTICIPANT_DATA>()
			for conv_state in conv_states {
				conv_part_list.appendContentsOf(conv_state.conversation.participant_data)
			}
			
			let userList = UserList(client: client, self_entity: self_entity, entities: required_entities, conv_parts: conv_part_list)
			let conversationList = ConversationList(client: client, conv_states: conv_states, user_list: userList, sync_timestamp: sync_timestamp)
			cb(userList, conversationList)
		}
	}
}
