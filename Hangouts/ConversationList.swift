import Foundation // Date

public protocol ConversationListDelegate {
    func conversationList(_ list: ConversationList, didReceiveEvent event: IEvent)
    func conversationList(_ list: ConversationList, didChangeTypingStatusTo status: TypingType)
    func conversationList(_ list: ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification)
    func conversationList(didUpdate list: ConversationList)
    func conversationList(_ list: ConversationList, didUpdateConversation conversation: IConversation)
}

// Wrapper around Client that maintains a list of Conversations
public class ConversationList {
	
    public let client: Client
    private var conv_dict = [String : IConversation]()
    public var sync_timestamp: Date
    public let user_list: UserList
	
	public var delegate: ConversationListDelegate?
	private var tokens = [NSObjectProtocol]()

    public init(client: Client, conv_states: [ConversationState], user_list: UserList, sync_timestamp: UInt64?) {
        self.client = client
		self.sync_timestamp = Date.from(UTC: Double(sync_timestamp ?? 0))//Date(timeIntervalSince1970: 0)
        self.user_list = user_list
		
        // Initialize the list of conversations from Client's list of ClientConversationStates.
		for conv_state in conv_states {
            self.add_conversation(client_conversation: conv_state.conversation!, client_events: conv_state.event)
        }
		
		//
		// A notification-based delegate replacement:
		//
		
		let _c = NotificationCenter.default()
		let a = _c.addObserver(forName: Client.didConnectNotification, object: client, queue: nil) { _ in
			self.sync()
		}
		let b = _c.addObserver(forName: Client.didReconnectNotification, object: client, queue: nil) { _ in
			self.sync()
		}
		let c = _c.addObserver(forName: Client.didDisconnectNotification, object: client, queue: nil) { _ in
			// nothing here
		}
		let d = _c.addObserver(forName: Client.didUpdateStateNotification, object: client, queue: nil) { note in
			if let val = (note.userInfo)?[Client.didUpdateStateKey.rawValue] as? Wrapper<StateUpdate> {
				self.clientDidUpdateState(client: self.client, update: val.element)
			} else {
				print("Encountered an error! \(note)")
			}
		}
		self.tokens.append(contentsOf: [a, b, c, d])
    }
	
	deinit {
		
		// Remove all the observers so we aren't receiving calls later on.
		self.tokens.forEach {
			NotificationCenter.default().removeObserver($0)
		}
	}

    public var conversations: [IConversation] {
        get {
            let all = conv_dict.values.filter { !$0.is_archived }
            return all.sorted { $0.last_modified > $1.last_modified }
        }
    }

    public var all_conversations: [IConversation] {
        get {
            return conv_dict.values.sorted { $0.last_modified > $1.last_modified }
        }
    }
	
	// Return a Conversation from its ID.
    public func get(conv_id: String) -> IConversation? {
        return conv_dict[conv_id]
    }

    public var unreadEventCount: Int {
        get {
            return conversations.flatMap { $0.unread_events }.count
        }
    }
	
	// Add new conversation from Conversation
	@discardableResult
    public func add_conversation(
        client_conversation: Conversation,
        client_events: [Event] = []
    ) -> IConversation {
        let conv_id = client_conversation.conversationId!.id!
        let conv = IConversation(
            client: client,
            user_list: user_list,
            conversation: client_conversation,
            events: client_events,
            conversationList: self
        )
        conv_dict[conv_id] = conv
        return conv
    }
	
	// Leave conversation and remove it from ConversationList
    public func leave_conversation(conv_id: String) {
        conv_dict[conv_id]!.leave {
            self.conv_dict.removeValue(forKey: conv_id)
        }
    }
	
	// Receive a ClientEvent and fan out to Conversations
    public func on_client_event(event: Event) {
        sync_timestamp = Date.from(UTC: Double(event.timestamp ?? 0))
        if let conv = conv_dict[event.conversationId!.id!] {
            let conv_event = conv.add_event(event: event)

			delegate?.conversationList(self, didReceiveEvent: conv_event)
            conv.handleEvent(event: conv_event)
        } else {
            print("Received ClientEvent for unknown conversation \(event.conversationId!.id!)")
        }
    }
	
	// Receive Conversation and create or update the conversation
    public func handle_client_conversation(client_conversation: Conversation) {
        let conv_id = client_conversation.conversationId!.id!
        if let conv = conv_dict[conv_id] {
            conv.update_conversation(conversation: client_conversation)
			delegate?.conversationList(self, didUpdateConversation: conv)
        } else {
            self.add_conversation(client_conversation: client_conversation)
        }
		delegate?.conversationList(didUpdate: self)
    }
	
	// Receive ClientSetTypingNotification and update the conversation
    public func handle_set_typing_notification(set_typing_notification: SetTypingNotification) {
        let conv_id = set_typing_notification.conversationId!.id!
        if let conv = conv_dict[conv_id] {
            let res = parseTypingStatusMessage(p: set_typing_notification)
			delegate?.conversationList(self, didChangeTypingStatusTo: res.status)
            let user = user_list[UserID(
				
                chatID: set_typing_notification.senderId!.chatId!,
                gaiaID: set_typing_notification.senderId!.gaiaId!
            )]
            conv.handleTypingStatus(status: res.status, forUser: user)
        } else {
            print("Received ClientSetTypingNotification for unknown conversation \(conv_id)")
        }
    }
	
	// Receive ClientWatermarkNotification and update the conversation
    public func handle_watermark_notification(watermark_notification: WatermarkNotification) {
        let conv_id = watermark_notification.conversationId!.id!
        if let conv = conv_dict[conv_id] {
            let res = parseWatermarkNotification(client_watermark_notification: watermark_notification)
			delegate?.conversationList(self, didReceiveWatermarkNotification: res)
            conv.handleWatermarkNotification(status: res)
        } else {
            print("Received WatermarkNotification for unknown conversation \(conv_id)")
        }
    }
	
	
	// Sync conversation state and events that could have been missed
    public func sync(cb: (() -> Void)? = nil) {
        client.syncAllNewEvents(timestamp: sync_timestamp) { res in
            if let response = res {
                for conv_state in response.conversationState {
                    if let conv = self.conv_dict[conv_state.conversationId!.id!] {
                        conv.update_conversation(conversation: conv_state.conversation!)
                        for event in conv_state.event {
                            if event.timestamp > UInt64(self.sync_timestamp.toUTC()) {
								
                                // This updates the sync_timestamp for us, as well as triggering events.
                                self.on_client_event(event: event)
                            }
                        }
                    } else {
                        self.add_conversation(client_conversation: conv_state.conversation!, client_events: conv_state.event)
                    }
                }
            }
        }
    }

    // MARK: Calls from conversations
	
    public func conversationDidUpdate(conversation: IConversation) {
		delegate?.conversationList(self, didUpdateConversation: conversation)
    }
	
	// Receive a ClientStateUpdate and fan out to Conversations
	/* TODO: Refactor this to use the Oneof support in Protobuf. */
    public func clientDidUpdateState(client: Client, update: StateUpdate) {
        if let client_conversation = update.conversation {
            handle_client_conversation(client_conversation: client_conversation)
        }
        if let typing_notification = update.typingNotification {
            handle_set_typing_notification(set_typing_notification: typing_notification)
        }
        if let watermark_notification = update.watermarkNotification {
            handle_watermark_notification(watermark_notification: watermark_notification)
        }
        if let event_notification = update.eventNotification {
            on_client_event(event: event_notification.event!)
        }
    }
}
