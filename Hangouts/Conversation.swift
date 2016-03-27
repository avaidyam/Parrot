
public protocol ConversationDelegate {
    func conversation(conversation: Conversation, didChangeTypingStatusForUser: User, toStatus: TypingType)
    func conversation(conversation: Conversation, didReceiveEvent: Event)
    func conversation(conversation: Conversation, didReceiveWatermarkNotification: WatermarkNotification)
    func conversationDidUpdateEvents(conversation: Conversation)

    //  The conversation did receive an update to its internal state - 
    //  the sort timestamp probably changed, at least.
    func conversationDidUpdate(conversation: Conversation)
}

// Wrapper around Client for working with a single chat conversation.
public class Conversation {
    public typealias EventID = String

    public var client: Client
    public var user_list: UserList
    public var conversation: CONVERSATION
    public var events_dict: Dictionary<EventID, Event> = Dictionary<EventID, Event>() {
        didSet {
            self._cachedEvents = nil
        }
    }
    public var typingStatuses = Dictionary<UserID, TypingType>()

    public var delegate: ConversationDelegate?
    public var conversationList: ConversationList?

    public init(client: Client,
        user_list: UserList,
        conversation: CONVERSATION,
        events: [EVENT] = [],
        conversationList: ConversationList
    ) {
        self.client = client
        self.user_list = user_list
        self.conversation = conversation
        self.conversationList = conversationList

        for event in events {
            add_event(event)
        }
    }
	
	// Update the conversations latest_read_timestamp.
    public func on_watermark_notification(notif: WatermarkNotification) {
        if self.get_user(notif.userID).isSelf {
            self.conversation.self_conversation_state.self_read_state.latest_read_timestamp = notif.readTimestamp
        }
    }
	
	// Update the internal Conversation.
	// StateUpdate.conversation is actually a delta; fields that aren't
	// specified are assumed to be unchanged. Until this class is
	// refactored, hide this by saving and restoring previous values where
	// necessary.
    public func update_conversation(conversation: CONVERSATION) {
		
		/* TODO: Enable this. */
		/*
		let new_state = conversation.self_conversation_state
		if new_state.delivery_medium_option.count == 0 {
			let old_state = self.conversation.self_conversation_state
			new_state.delivery_medium_option.appendContentsOf(old_state.delivery_medium_option)
		}
		*/
		
        let old_timestamp = self.latest_read_timestamp
        self.conversation = conversation
        
        if to_timestamp(self.latest_read_timestamp) == 0 {
            self.conversation.self_conversation_state.self_read_state.latest_read_timestamp = old_timestamp
        }

        delegate?.conversationDidUpdate(self)
    }
	
	// Wrap ClientEvent in Event subclass.
    private class func wrap_event(event: EVENT) -> Event {
        if event.chat_message != nil {
            return ChatMessageEvent(event: event)
        } else if event.conversation_rename != nil {
            return RenameEvent(event: event)
        } else if event.membership_change != nil {
            return MembershipChangeEvent(event: event)
        } else {
            return Event(event: event)
        }
    }

    private var _cachedEvents = [Event]?()
    public var events: [Event] {
        get {
            if _cachedEvents == nil {
                _cachedEvents = events_dict.values.sort { $0.timestamp < $1.timestamp }
            }
            return _cachedEvents!
        }
    }
	
	// Add a ClientEvent to the Conversation.
	// Returns an instance of Event or subclass.
    public func add_event(event: EVENT) -> Event {
        let conv_event = Conversation.wrap_event(event)
		/* TODO: Enable this. */
		/*if !self.events_dict.contains(conv_event.id) {
			self.events.append(conv_event)
			self.events_dict[conv_event.id] = conv_event
		} else {
			return nil
		}*/
		self.events_dict[conv_event.id] = conv_event
        return conv_event
    }
	
	// Return the User instance with the given UserID.
    public func get_user(user_id: UserID) -> User {
        return self.user_list[user_id]
    }
	
	/* TODO: Translate these methods: */
	/*
	    def _get_default_delivery_medium(self):
	        """Return default DeliveryMedium to use for sending messages.
	
	        Use the first option, or an option that's marked as the current
	        default.
	        """
	        medium_options = (
	            self._conversation.self_conversation_state.delivery_medium_option
	        )
	        try:
	            default_medium = medium_options[0].delivery_medium
	        except IndexError:
	            logger.warning('Conversation %r has no delivery medium')
	            default_medium = hangouts_pb2.DeliveryMedium(
	                medium_type=hangouts_pb2.DELIVERY_MEDIUM_BABEL
	            )
	        for medium_option in medium_options:
	            if medium_option.current_default:
	                default_medium = medium_option.delivery_medium
	        return default_medium
	
	    def _get_event_request_header(self):
	        """Return EventRequestHeader for conversation."""
	        otr_status = (hangouts_pb2.OFF_THE_RECORD_STATUS_OFF_THE_RECORD
	                      if self.is_off_the_record else
	                      hangouts_pb2.OFF_THE_RECORD_STATUS_ON_THE_RECORD)
	        return hangouts_pb2.EventRequestHeader(
	            conversation_id=hangouts_pb2.ConversationId(id=self.id_),
	            client_generated_id=self._client.get_client_generated_id(),
	            expected_otr=otr_status,
	            delivery_medium=self._get_default_delivery_medium(),
	        )
	*/

    public var otherUserIsTyping: Bool {
        get {
            return self.typingStatuses.filter {
                (k, v) in !self.user_list[k].isSelf
            }.map {
                (k, v) in v == TypingType.STARTED
            }.first ?? false
        }
    }

    public func setFocus() {
        self.client.setFocus(id)
    }
	
	// Send a message to this conversation.
	// A per-conversation lock is acquired to ensure that messages are sent in
	// the correct order when this method is called multiple times
	// asynchronously.
	// segments is a list of ChatMessageSegments to include in the message.
	// image_file is an optional file-like object containing an image to be
	// attached to the message.
	// image_id is an optional ID of an image to be attached to the message
	// (if you specify both image_file and image_id together, image_file
	// takes precedence and supplied image_id will be ignored)
	// Send messages with OTR status matching the conversation's status.
    public func sendMessage(segments: [ChatMessageSegment],
		image_data: NSData? = nil,
		image_name: String? = nil,
		image_id: String? = nil,
		image_user_id: String? = nil,
        cb: (() -> Void)? = nil
    ) {
        let otr_status = (is_off_the_record ? OffTheRecordStatus.OFF_THE_RECORD : OffTheRecordStatus.ON_THE_RECORD)

		/* TODO: Fix the conditionality here. */
        if let image_data = image_data, image_name = image_name {
			client.uploadImage(image_data, filename: image_name) { photoID in
				self.client.sendChatMessage(self.id,
					segments: segments.map { $0.serialize() },
					image_id: image_id,
					image_user_id: nil,
					otr_status: otr_status,
					cb: cb
				)
			}
            return
        }

        client.sendChatMessage(id,
            segments: segments.map { $0.serialize() },
            image_id: image_id,
            otr_status: otr_status,
            cb: cb
        )
    }

    public func leave(cb: (() -> Void)? = nil) {
        switch (self.conversation.type) {
        case ConversationType.GROUP:
            //print("Remove Not Implemented!")
            client.removeUser(id, cb: cb)
        case ConversationType.ONE_TO_ONE:
            client.deleteConversation(id, cb: cb)
        default:
            break
        }
    }
	
	// Rename the conversation.
	// Hangouts only officially supports renaming group conversations, so
	// custom names for one-to-one conversations may or may not appear in all
	// first party clients.
    public func rename(name: String, cb: (() -> Void)?) {
        self.client.renameConversation(self.id, name: name, cb: cb)
    }
	
	// Set the notification level of the conversation.
	// Pass .QUIET to disable notifications or .RING to enable them.
	public func setConversationNotificationLevel(level: NotificationLevel, cb: (() -> Void)?) {
		self.client.setConversationNotificationLevel(self.id, level: level, cb: cb)
    }
	
	// Set typing status.
	// TODO: Add rate-limiting to avoid unnecessary requests.
    public func setTyping(typing: TypingType = TypingType.STARTED, cb: (() -> Void)? = nil) {
        client.setTyping(id, typing: typing, cb: cb)
    }
	
	// Update the timestamp of the latest event which has been read.
	// By default, the timestamp of the newest event is used.
	// This method will avoid making an API request if it will have no effect.
    public func updateReadTimestamp(read_timestamp: NSDate? = nil, cb: (() -> Void)? = nil) {
		var read_timestamp = read_timestamp
        if read_timestamp == nil {
            read_timestamp = self.events.last!.timestamp
        }
        if let new_read_timestamp = read_timestamp {
            if new_read_timestamp > self.latest_read_timestamp {

                // Prevent duplicate requests by updating the conversation now.
                latest_read_timestamp = new_read_timestamp
                delegate?.conversationDidUpdate(self)
                conversationList?.conversationDidUpdate(self)
                client.updateWatermark(id, read_timestamp: new_read_timestamp, cb: cb)
            }
        }
    }

    public func handleEvent(event: Event) {
        if let delegate = delegate {
            delegate.conversation(self, didReceiveEvent: event)
        } else {
            let user = user_list[event.userID]
            if !user.isSelf {
				print("Notification \(event) from User \(user)!");
            }
        }
    }

    public func handleTypingStatus(status: TypingType, forUser user: User) {
        let existingTypingStatus = typingStatuses[user.id]
        if existingTypingStatus == nil || existingTypingStatus! != status {
            typingStatuses[user.id] = status
            delegate?.conversation(self, didChangeTypingStatusForUser: user, toStatus: status)
        }
    }

    public func handleWatermarkNotification(status: WatermarkNotification) {
        delegate?.conversation(self, didReceiveWatermarkNotification: status)
    }

    public var messages: [ChatMessageEvent] {
        get {
            return events.flatMap { $0 as? ChatMessageEvent }
        }
    }
	
	// Return list of Events ordered newest-first.
	// If event_id is specified, return events preceding this event.
	// This method will make an API request to load historical events if
	// necessary. If the beginning of the conversation is reached, an empty
	// list will be returned.
    public func getEvents(event_id: String? = nil, max_events: Int = 50, cb: (([Event]) -> Void)? = nil) {
        guard let event_id = event_id else {
            cb?(events)
            return
        }

        // If event_id is provided, return the events we have that are
        // older, or request older events if event_id corresponds to the
        // oldest event we have.
        if let conv_event = self.get_event(event_id) {
            if events.first!.id != event_id {
                if let indexOfEvent = self.events.indexOf({ $0 == conv_event }) {
                    cb?(Array(self.events[indexOfEvent...self.events.endIndex]))
                    return
                }
            }
			
            client.getConversation(id, event_timestamp: conv_event.timestamp, max_events: max_events) { res in
				if res!.response_header.status == ResponseStatus.INVALID_REQUEST {
					print("Invalid request! \(res!.response_header)")
					return
				}
				let conv_events = res!.conversation_state.event.map { Conversation.wrap_event($0) }

                for conv_event in conv_events {
                    self.events_dict[conv_event.id] = conv_event
                }
                cb?(conv_events)
                self.delegate?.conversationDidUpdateEvents(self)
            }
        } else {
            print("Event not found.")
        }
    }

//    func next_event(event_id, prev=False) {
//        // Return Event following the event with given event_id.
//        // If prev is True, return the previous event rather than the following
//        // one.
//        // Raises KeyError if no such Event is known.
//        // Return nil if there is no following event.
//
//        i = self.events.index(self._events_dict[event_id])
//        if prev and i > 0:
//        return self.events[i - 1]
//        elif not prev and i + 1 < len(self.events) {
//            return self.events[i + 1]
//            else:
//            return nil
//        }
//    }

    public func get_event(event_id: EventID) -> Event? {
        return events_dict[event_id]
    }
	
	// The conversation's ID.
    public var id: String {
        get {
            return self.conversation.conversation_id!.id as! String
        }
    }

    public var users: [User] {
        get {
            return conversation.participant_data.map {
                self.user_list[UserID(
                    chatID: $0.id!.chat_id as! String,
                    gaiaID: $0.id!.gaia_id as! String
                )]
            }
        }
    }

    public var name: String {
        get {
            if let name = self.conversation.name {
                return name as String
            } else {
                return users.filter { !$0.isSelf }.map { $0.fullName }.joinWithSeparator(", ")
            }
        }
    }

    public var last_modified: NSDate {
        get {
			return conversation.self_conversation_state.sort_timestamp
				?? NSDate(timeIntervalSinceReferenceDate: 0)
        }
    }
	
	// datetime timestamp of the last read Event.
    public var latest_read_timestamp: NSDate {
        get {
            return conversation.self_conversation_state.self_read_state.latest_read_timestamp
        }
        set(newLatestReadTimestamp) {
            conversation.self_conversation_state.self_read_state.latest_read_timestamp = newLatestReadTimestamp
        }
    }
	
	// List of Events that are unread.
	// Events are sorted oldest to newest.
	// Note that some Hangouts clients don't update the read timestamp for
	// certain event types, such as membership changes, so this method may
	// return more unread events than these clients will show. There's also a
	// delay between sending a message and the user's own message being
	// considered read.
    public var unread_events: [Event] {
        get {
            return events.filter { $0.timestamp > self.latest_read_timestamp }
        }
    }

    public var hasUnreadEvents: Bool {
        get {
            if unread_events.first != nil {
                //print("Conversation \(name) has unread events, latest read timestamp is \(self.latest_read_timestamp)")
            }
            return unread_events.first != nil
        }
    }
	
	// True if this conversation has been archived.
    public var is_archived: Bool {
        get {
            return self.conversation.self_conversation_state.view.contains(ConversationView.ARCHIVED)
        }
    }
	
	// True if notification level for this conversation is quiet.
	public var is_quiet: Bool {
		get {
			return self.conversation.self_conversation_state.notification_level == NotificationLevel.QUIET
		}
	}
	
	// True if conversation is off the record (history is disabled).
    public var is_off_the_record: Bool {
        get {
            return self.conversation.otr_status == OffTheRecordStatus.OFF_THE_RECORD
        }
    }
}