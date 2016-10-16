import Foundation
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.ConversationList")

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
	func conversationList(_ list: ConversationList, didChangeTypingStatus status: ITypingStatusMessage, forUser: User)
    func conversationList(_ list: ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification)
    func conversationList(didUpdate list: ConversationList)
    func conversationList(_ list: ConversationList, didUpdateConversation conversation: IConversation)
}

// Wrapper around Client that maintains a list of Conversations
public class ConversationList: ParrotServiceExtension.ConversationList {
	
    public let client: Client
    public var conv_dict = [String : IConversation]()
	public var delegate: ConversationListDelegate?
	private var token: NSObjectProtocol? = nil

    public init(client: Client) {
        self.client = client
        self.token = NotificationCenter.default.addObserver(forName: Client.didUpdateStateNotification, object: client, queue: nil) { note in
            if let val = (note.userInfo)?[Client.didUpdateStateKey] as? Wrapper<StateUpdate> {
                self.clientDidUpdateState(client: self.client, update: val.element)
            } else {
                log.error("Encountered an error! \(note)")
            }
        }
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self.token)
	}
    
    
    ///
    ///
    ///
    
	
	public var conversations: [String: ParrotServiceExtension.Conversation] {
		var dict = Dictionary<String, ParrotServiceExtension.Conversation>()
		for (key, conv) in self.conv_dict {
			dict[key] = conv
		}
		return dict
    }
    
    public subscript(_ identifier: String) -> ParrotServiceExtension.Conversation? {
        return self.conv_dict[identifier] as? ParrotServiceExtension.Conversation
    }
    
    // Retrieve recent conversations so we can preemptively look up their participants.
    public func syncConversations(count: Int = 25) -> [String: ParrotServiceExtension.Conversation]? {
        let s = DispatchSemaphore(value: 0)
        var ret = [IConversation]()
        self.client.opQueue.sync {
            self.client.syncRecentConversations { response in
                let conv_states = response!.conversationState
                //let sync_timestamp = response!.syncTimestamp// use current_server_time?
                //self.sync_timestamp = Date.from(UTC: Double(sync_timestamp ?? 0))//.origin
                
                // Initialize the list of conversations from Client's list of ClientConversationStates.
                for conv_state in conv_states {
                    ret.append(self.add_conversation(client_conversation: conv_state.conversation!, client_events: conv_state.event))
                }
                _ = self.client.userList.addPeople(from: ret)
                s.signal()
            }
        }
        s.wait()
        return ret.count > 0
            ? ret.dictionaryMap { return [$0.id: $0 as ParrotServiceExtension.Conversation] }
            : nil
    }
    
    public func begin(with: [Person]) -> ParrotServiceExtension.Conversation? {
        return nil
    }
    
    public func archive(conversation: ParrotServiceExtension.Conversation) {
        
    }
    
    public func delete(conversation: ParrotServiceExtension.Conversation) {
        
    }
    
    
    ///
    ///
    ///
	
    public var unreadCount: Int {
        return Array(self.conv_dict.values)
            .filter { !$0.is_archived && $0.unread_events.count > 0 }
            .count
	}
	
	
	// Add new conversation from Conversation
	@discardableResult
    internal func add_conversation(
        client_conversation: Conversation,
        client_events: [Event] = []
    ) -> IConversation {
        let conv_id = client_conversation.conversationId!.id!
        let conv = IConversation(
            client: client,
            user_list: client.userList,
            conversation: client_conversation,
            events: client_events,
            conversationList: self
        )
        conv_dict[conv_id] = conv
        return conv
    }
	
	// Leave conversation and remove it from ConversationList
    /*public func leave_conversation(conv_id: String) {
        conv_dict[conv_id]!.leave {
            self.conv_dict.removeValue(forKey: conv_id)
        }
    }*/
    
    ///
    ///
    ///
	
    public func conversationDidUpdate(conversation: IConversation) {
		delegate?.conversationList(self, didUpdateConversation: conversation)
    }
	
	// Receive a ClientStateUpdate and fan out to Conversations
    public func clientDidUpdateState(client: Client, update: StateUpdate) {
        if let note = update.conversationNotification {
            log.debug("clientDidUpdateState: conversationNotification")
            _conversationNotification(note)
        } else if let note = update.eventNotification {
            log.debug("clientDidUpdateState: eventNotification")
			_eventNotification(note)
        } else if let note = update.focusNotification {
            log.debug("clientDidUpdateState: focusNotification")
			_focusNotification(note)
        } else if let note = update.typingNotification {
            log.debug("clientDidUpdateState: typingNotification")
			_typingNotification(note)
        } else if let note = update.notificationLevelNotification {
            log.debug("clientDidUpdateState: notificationLevelNotification")
			_notificationLevelNotification(note)
        } else if let note = update.watermarkNotification {
            log.debug("clientDidUpdateState: watermarkNotification")
			_watermarkNotification(note)
        } else if let note = update.viewModification {
            log.debug("clientDidUpdateState: viewModification")
			_viewModification(note)
        } else if let note = update.selfPresenceNotification {
            log.debug("clientDidUpdateState: selfPresenceNotification")
			_selfPresenceNotification(note)
        } else if let note = update.deleteNotification {
            log.debug("clientDidUpdateState: deleteNotification")
			_deleteNotification(note)
        } else if let note = update.presenceNotification {
            log.debug("clientDidUpdateState: presenceNotification")
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
		
        // Be sure to maintain the event sync_timestamp for sync'ing.
        //sync_timestamp = Date.from(UTC: Double(event.timestamp ?? 0))
        
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
			let user = self.client.userList[User.ID(
				chatID: note.senderId!.chatId!,
				gaiaID: note.senderId!.gaiaId!
				)]
			delegate?.conversationList(self, didChangeTypingStatus: res, forUser: user)
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
