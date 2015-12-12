import Foundation

protocol ConversationListDelegate {
    func conversationList(list: ConversationList, didReceiveEvent event: ConversationEvent)
    func conversationList(list: ConversationList, didChangeTypingStatusTo status: TypingType)
    func conversationList(list: ConversationList, didReceiveWatermarkNotification status: WatermarkNotification)
    func conversationListDidUpdate(list: ConversationList)
    func conversationList(list: ConversationList, didUpdateConversation conversation: Conversation)
}

// Wrapper around Client that maintains a list of Conversations
class ConversationList : ClientDelegate {
    let client: Client
    private var conv_dict = [String : Conversation]()
    var sync_timestamp: NSDate
    let user_list: UserList

    var delegate: ConversationListDelegate?

    init(client: Client, conv_states: [CLIENT_CONVERSATION_STATE], user_list: UserList, sync_timestamp: NSDate?) {
        self.client = client
        self.sync_timestamp = sync_timestamp ?? NSDate(timeIntervalSince1970: 0)
        self.user_list = user_list

        // Initialize the list of conversations from Client's list of ClientConversationStates.
        for conv_state in conv_states {
            self.add_conversation(conv_state.conversation, client_events: conv_state.event)
        }

        client.delegate = self
    }

    var conversations: [Conversation] {
        get {
            let all = conv_dict.values.filter { !$0.is_archived }
            return all.sort { $0.last_modified > $1.last_modified }
        }
    }

    var all_conversations: [Conversation] {
        get {
            return conv_dict.values.sort { $0.last_modified > $1.last_modified }
        }
    }
	
	// Return a Conversation from its ID.
    func get(conv_id: String) -> Conversation? {
        return conv_dict[conv_id]
    }

    var unreadEventCount: Int {
        get {
            return conversations.flatMap { $0.unread_events }.count
        }
    }
	
	// Add new conversation from Conversation
    func add_conversation(
        client_conversation: CLIENT_CONVERSATION,
        client_events: [CLIENT_EVENT] = []
    ) -> Conversation {
        let conv_id = client_conversation.conversation_id!.id
        let conv = Conversation(
            client: client,
            user_list: user_list,
            client_conversation: client_conversation,
            client_events: client_events,
            conversationList: self
        )
        conv_dict[conv_id as String] = conv
        return conv
    }
	
	// Leave conversation and remove it from ConversationList
    func leave_conversation(conv_id: String) {
        conv_dict[conv_id]!.leave {
            conv_dict.removeValueForKey(conv_id)
        }
    }
	
	// Receive a ClientEvent and fan out to Conversations
    func on_client_event(event: CLIENT_EVENT) {
        sync_timestamp = event.timestamp
        if let conv = conv_dict[event.conversation_id.id as String] {
            let conv_event = conv.add_event(event)

            delegate?.conversationList(self, didReceiveEvent: conv_event)
            conv.handleConversationEvent(conv_event)
        } else {
            print("Received ClientEvent for unknown conversation \(event.conversation_id.id)")
        }
    }
	
	// Receive Conversation and create or update the conversation
    func handle_client_conversation(client_conversation: CLIENT_CONVERSATION) {
        let conv_id = client_conversation.conversation_id!.id
        if let conv = conv_dict[conv_id as String] {
            conv.update_conversation(client_conversation)
            delegate?.conversationList(self, didUpdateConversation: conv)
        } else {
            self.add_conversation(client_conversation)
        }
        delegate?.conversationListDidUpdate(self)
    }
	
	// Receive ClientSetTypingNotification and update the conversation
    func handle_set_typing_notification(set_typing_notification: CLIENT_SET_TYPING_NOTIFICATION) {
        let conv_id = set_typing_notification.conversation_id.id
        if let conv = conv_dict[conv_id as String] {
            let res = parse_typing_status_message(set_typing_notification)
            delegate?.conversationList(self, didChangeTypingStatusTo: res.status)
            let user = user_list.get_user(UserID(
                chat_id: set_typing_notification.user_id.chat_id as String,
                gaia_id: set_typing_notification.user_id.gaia_id as String
            ))
            conv.handleTypingStatus(res.status, forUser: user)
        } else {
            print("Received ClientSetTypingNotification for unknown conversation \(conv_id)")
        }
    }
	
	// Receive ClientWatermarkNotification and update the conversation
    func handle_watermark_notification(watermark_notification: CLIENT_WATERMARK_NOTIFICATION) {
        let conv_id = watermark_notification.conversation_id.id
        if let conv = conv_dict[conv_id as String] {
            let res = parse_watermark_notification(watermark_notification)
            delegate?.conversationList(self, didReceiveWatermarkNotification: res)
            conv.handleWatermarkNotification(res)
        } else {
            print("Received WatermarkNotification for unknown conversation \(conv_id)")
        }
    }
	
	// Sync conversation state and events that could have been missed
    func sync(cb: (() -> Void)? = nil) {
        client.syncAllNewEvents(sync_timestamp) { res in
            if let response = res {
                for conv_state in response.conversation_state {
                    if let conv = self.conv_dict[conv_state.conversation_id.id as String] {
                        conv.update_conversation(conv_state.conversation)
                        for event in conv_state.event {
                            if event.timestamp > self.sync_timestamp {
								
                                // This updates the sync_timestamp for us, as well as triggering events.
                                self.on_client_event(event)
                            }
                        }
                    } else {
                        self.add_conversation(conv_state.conversation, client_events: conv_state.event)
                    }
                }
            }
        }
    }

    // MARK: Calls from conversations
	
    func conversationDidUpdate(conversation: Conversation) {
        delegate?.conversationList(self, didUpdateConversation: conversation)
    }

    //  MARK: ClientDelegate

    func clientDidConnect(client: Client, initialData: InitialData) {
        sync()
    }

    func clientDidDisconnect(client: Client) {
		
    }

    func clientDidReconnect(client: Client) {
        sync()
    }
	
	// Receive a ClientStateUpdate and fan out to Conversations
    func clientDidUpdateState(client: Client, update: CLIENT_STATE_UPDATE) {
        if let client_conversation = update.client_conversation {
            handle_client_conversation(client_conversation)
        }

        if let typing_notification = update.typing_notification {
            handle_set_typing_notification(typing_notification)
        }
        if let watermark_notification = update.watermark_notification {
            handle_watermark_notification(watermark_notification)
        }
        if let event_notification = update.event_notification {
            on_client_event(event_notification.event)
        }
    }
}