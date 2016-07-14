import Foundation
import ParrotServiceExtension

public protocol ConversationListDelegate {
	/*
	conversationNotification(note)
	eventNotification(note)
	focusNotification(note)
	typingNotification(note)
	notificationLevelNotification(note)
	watermarkNotification(note)
	viewModification(note)
	selfPresenceNotification(note)
	deleteNotification(note)
	presenceNotification(note)
	*/
	
    func conversationList(_ list: ConversationList, didReceiveEvent event: IEvent)
    func conversationList(_ list: ConversationList, didChangeTypingStatusTo status: TypingType)
    func conversationList(_ list: ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification)
    func conversationList(didUpdate list: ConversationList)
    func conversationList(_ list: ConversationList, didUpdateConversation conversation: IConversation)
}

// Wrapper around Client that maintains a list of Conversations
public class ConversationList: ParrotServiceExtension.ConversationList {
	
    public let client: Client
    public var conv_dict = [String : IConversation]()
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
				log.error("Encountered an error! \(note)")
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
	
	public var conversations: [String: ParrotServiceExtension.Conversation] {
		var dict = Dictionary<String, ParrotServiceExtension.Conversation>()
		for (key, conv) in self.conv_dict {
			dict[key] = conv
		}
		return dict
	}

    public var _conversations: [IConversation] {
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
            return _conversations.flatMap { $0.unread_events }.count
        }
    }
	
	
	/// Begin a new conversation with the people provided.
	/// Note that this may be a one-on-one conversation if only one exists.
	public func begin(with: [Person]) -> ParrotServiceExtension.Conversation? {
		return nil
	}
	
	/// Archive a conversation provided.
	public func archive(conversation: ParrotServiceExtension.Conversation) {
		
	}
	
	/// Delete a conversation provided.
	public func delete(conversation: ParrotServiceExtension.Conversation) {
		
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
                                //self._eventNotification(event: event)
								self.sync_timestamp = Date.from(UTC: Double(event.timestamp ?? 0))
								if let conv = self.conv_dict[event.conversationId!.id!] {
									let conv_event = conv.add_event(event: event)
									
									self.delegate?.conversationList(self, didReceiveEvent: conv_event)
									conv.handleEvent(event: conv_event)
								} else {
									log.warning("Received ClientEvent for unknown conversation \(event.conversationId!.id!)")
								}
                            }
                        }
                    } else {
                        self.add_conversation(client_conversation: conv_state.conversation!, client_events: conv_state.event)
                    }
                }
            }
        }
    }
	
    public func conversationDidUpdate(conversation: IConversation) {
		delegate?.conversationList(self, didUpdateConversation: conversation)
    }
	
	// Receive a ClientStateUpdate and fan out to Conversations
    public func clientDidUpdateState(client: Client, update: StateUpdate) {
        if let note = update.conversationNotification {
            _conversationNotification(note)
		} else if let note = update.eventNotification {
			_eventNotification(note)
		} else if let note = update.focusNotification {
			_focusNotification(note)
		} else if let note = update.typingNotification {
			_typingNotification(note)
		} else if let note = update.notificationLevelNotification {
			_notificationLevelNotification(note)
		} else if let note = update.watermarkNotification {
			_watermarkNotification(note)
		} else if let note = update.viewModification {
			_viewModification(note)
		} else if let note = update.selfPresenceNotification {
			_selfPresenceNotification(note)
		} else if let note = update.deleteNotification {
			_deleteNotification(note)
		} else if let note = update.presenceNotification {
			_presenceNotification(note)
		}
	}
	
	public func _conversationNotification(_ note: ConversationNotification) {
		let client_conversation = note.conversation!
		let conv_id = client_conversation.conversationId!.id!
		if let conv = conv_dict[conv_id] {
			conv.update_conversation(conversation: client_conversation)
			delegate?.conversationList(self, didUpdateConversation: conv)
		} else {
			self.add_conversation(client_conversation: client_conversation)
		}
		delegate?.conversationList(didUpdate: self)
	}
	
	public func _focusNotification(_ note: SetFocusNotification) {
		log.verbose("UNIMPLEMENTED: \(#function) => \(note)")
	}
	
	public func _eventNotification(_ note: EventNotification) {
		let event = note.event!
		sync_timestamp = Date.from(UTC: Double(event.timestamp ?? 0))
		if let conv = conv_dict[event.conversationId!.id!] {
			let conv_event = conv.add_event(event: event)
			
			delegate?.conversationList(self, didReceiveEvent: conv_event)
			conv.handleEvent(event: conv_event)
		} else {
			log.warning("Received ClientEvent for unknown conversation \(event.conversationId!.id!)")
		}
	}
	
	public func _typingNotification(_ note: SetTypingNotification) {
		let conv_id = note.conversationId!.id!
		if let conv = conv_dict[conv_id] {
			let res = parseTypingStatusMessage(p: note)
			delegate?.conversationList(self, didChangeTypingStatusTo: res.status)
			let user = user_list[User.ID(
				chatID: note.senderId!.chatId!,
				gaiaID: note.senderId!.gaiaId!
			)]
			conv.handleTypingStatus(status: res.status, forUser: user)
		} else {
			log.warning("Received ClientSetTypingNotification for unknown conversation \(conv_id)")
		}
	}
	
	public func _notificationLevelNotification(_ note: SetConversationNotificationLevelNotification) {
		log.verbose("UNIMPLEMENTED: \(#function) => \(note)")
	}
	
	public func _watermarkNotification(_ note: WatermarkNotification) {
		let conv_id = note.conversationId!.id!
		if let conv = self.conv_dict[conv_id] {
			let res = parseWatermarkNotification(client_watermark_notification: note)
			self.delegate?.conversationList(self, didReceiveWatermarkNotification: res)
			conv.handleWatermarkNotification(status: res)
		} else {
			log.warning("Received WatermarkNotification for unknown conversation \(conv_id)")
		}
	}
	
	public func _viewModification(_ note: ConversationViewModification) {
		log.verbose("UNIMPLEMENTED: \(#function) => \(note)")
	}
	
	public func _selfPresenceNotification(_ note: SelfPresenceNotification) {
		log.verbose("UNIMPLEMENTED: \(#function) => \(note)")
	}
	
	public func _deleteNotification(_ note: DeleteActionNotification) {
		log.verbose("UNIMPLEMENTED: \(#function) => \(note)")
	}
	
	public func _presenceNotification(_ note: PresenceNotification) {
		log.verbose("UNIMPLEMENTED: \(#function) => \(note)")
	}
}
