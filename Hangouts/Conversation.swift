import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Conversation")

public struct IFocus: Focus {
    public let serviceIdentifier: String
    public let identifier: String
	public let sender: Person?
	public let timestamp: Date
	public let mode: FocusMode
    public init(_ serviceIdentifier: String, identifier: String, sender: Person?, timestamp: Date, mode: FocusMode) {
        self.serviceIdentifier = serviceIdentifier
        self.identifier = identifier
        self.sender = sender
        self.timestamp = timestamp
        self.mode = mode
    }
}

// Wrapper around Client for working with a single chat conversation.
public class IConversation: ParrotServiceExtension.Conversation {
    public typealias EventID = String
    
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    public var client: Client
    public var conversation: Conversation
    public var events_dict: Dictionary<EventID, IEvent> = Dictionary<EventID, IEvent>() {
        didSet {
            self._cachedEvents = nil
        }
    }
	public var readStates: [UserReadState] = []
    public var typingStatuses = Dictionary<User.ID, TypingType>()

    //public var delegate: ConversationDelegate?
    public var user_list: UserList {
        return self.client.userList
    }
    public var conversationList: ConversationList {
        return self.client.conversationList
    }
    
    public init(client: Client,
        conversation: Conversation,
        events: [Event] = []
    ) {
        self.client = client
        self.conversation = conversation
        for event in events {
            add_event(event: event)
        }
    }
	
	public var participants: [Person] {
		return self.users.map { $0 as Person }
	}
	
	// Update the conversations latest_read_timestamp.
    public func on_watermark_notification(notif: IWatermarkNotification) {
        if self.get_user(user_id: notif.userID).me {
			//FIXME: Oops.
            //self.conversation.selfConversationState.selfReadState.latestReadTimestamp = notif.readTimestamp
        }
		log.info("watermark for \(notif.userID)")
    }
	
	// Update the internal Conversation.
	// StateUpdate.conversation is actually a delta; fields that aren't
	// specified are assumed to be unchanged. Until this class is
	// refactored, hide this by saving and restoring previous values where
	// necessary.
    public func update_conversation(conversation: Conversation) {
		
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
        
		if self.latest_read_timestamp.toUTC() == 0 {//to_timestamp(date: ) == 0 {
			// FIXME: I think this is supposed to repair the read timestamp...
            self.conversation.selfConversationState!.selfReadState!.latestReadTimestamp = UInt64(old_timestamp.toUTC())
        }

        NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: self)
        //delegate?.conversationDidUpdate(conversation: self)
    }
	
	// Wrap ClientEvent in Event subclass.
    private class func wrap_event(_ client: Client, event: Event) -> IEvent {
        if event.chatMessage != nil {
            return IChatMessageEvent(client, event: event)
        } else if event.conversationRename != nil {
            return IRenameEvent(client, event: event)
        } else if event.membershipChange != nil {
            return IMembershipChangeEvent(client, event: event)
        } else {
            return IEvent(client, event: event)
        }
    }

	private var _cachedEvents: [IEvent]? = nil
    public var events: [IEvent] {
        get {
            if _cachedEvents == nil {
                _cachedEvents = events_dict.values.sorted { $0.timestamp < $1.timestamp }
            }
            return _cachedEvents!
        }
    }
    
    public var archived: Bool {
        get {
            return self.is_archived
        }
        set {
            // FIXME:
            //self.client.setView(self.conversation, archived)
        }
    }
    
	// Add a ClientEvent to the Conversation.
	// Returns an instance of Event or subclass.
	@discardableResult
    public func add_event(event: Event) -> IEvent {
        let conv_event = IConversation.wrap_event(self.client, event: event)
		//conv_event.client = self.client
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
	
	// Return the User instance with the given User.ID.
    public func get_user(user_id: User.ID) -> User {
        return self.user_list[user_id]
    }
	
	// Return default DeliveryMedium to use for sending messages.
	// Use the first option, or an option that's marked as the current default.
	public func getDefaultDeliveryMedium() -> DeliveryMedium {
		let medium_options = self.conversation.selfConversationState?.deliveryMediumOption
		
		var default_medium: DeliveryMedium = DeliveryMedium()
		default_medium.mediumType = .Babel
		if let r = medium_options?[0].deliveryMedium {
			default_medium = r
		}
		for medium_option in medium_options! {
			if let m = medium_option.currentDefault, m {
				default_medium = medium_option.deliveryMedium!; break
			}
		}
		return default_medium
	}
	
	public func getEventRequestHeader() -> EventRequestHeader {
		let otr_status: OffTheRecordStatus = (self.is_off_the_record ? .OffTheRecord : .OnTheRecord)
		var e = EventRequestHeader()
		e.conversationId = self.conversation.conversationId
		//e.clientGeneratedId = UInt64(self.client.generateClientID())
		e.expectedOtr = otr_status
		e.deliveryMedium = getDefaultDeliveryMedium()
		return e
	}

    public var otherUserIsTyping: Bool {
        get {
            return self.typingStatuses.filter {
                (arg) -> Bool in let (k, _) = arg; return !self.user_list[k].me
            }.map {
                (arg) -> Bool in let (_, v) = arg; return v == TypingType.Started
            }.first ?? false
        }
    }
	
    /* FIXME: only send if changed!! */
    public var selfFocus: FocusMode {
        get {
            return .away
        }
        set {
            guard newValue != self.selfFocus else { return }
            switch newValue {
            case .away:
                self.client.setFocus(conversation_id: id, focused: false)
                self.client.setTyping(conversation_id: id, typing: .Stopped)
            case .here:
                self.client.setFocus(conversation_id: id, focused: true)
                self.client.setTyping(conversation_id: id, typing: .Stopped)
            case .typing:
                self.client.setFocus(conversation_id: id, focused: true)
                self.client.setTyping(conversation_id: id, typing: .Started)
            case .enteredText:
                self.client.setFocus(conversation_id: id, focused: true)
                self.client.setTyping(conversation_id: id, typing: .Paused)
            }
        }
    }
	
	public var focus: [Focus] {
		var focuses = [Focus]()
		for r in self.conversation.readState {
			let person = self.client.directory.people[r.participantId!.gaiaId!]
			let read = Date.from(UTC: Double(r.latestReadTimestamp!))
			//let t = self.typingStatuses[id]
			let f = IFocus(self.serviceIdentifier, identifier: "", sender: person, timestamp: read, mode: .away)
			focuses.append(f)
		}
		return focuses
	}
	
	public var muted: Bool {
		get {
            log.debug("NOT IMPLEMENTED: Conversation.muted.get!")
			return false
			//return self.setConversationNotificationLevel(level: <#T##NotificationLevel#>, cb: nil)
		}
		set {
			self.setConversationNotificationLevel(level: (newValue ? .Quiet : .Ring), cb: nil)
		}
	}
    
    public func send(message text: String) {
        guard text.characters.count > 0 else { return }
        let s = DispatchSemaphore(value: 0)
        self.client.opQueue.async {
            self.sendMessage(segments: [IChatMessageSegment(text: text)]) {
                s.signal()
            }
        }
        s.wait()
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
    public func sendMessage(segments: [IChatMessageSegment],
		image_data: Data? = nil,
		image_name: String? = nil,
		image_id: String? = nil,
		image_user_id: String? = nil,
        cb: (() -> Void)? = nil
    ) {
        let otr_status = (is_off_the_record ? OffTheRecordStatus.OffTheRecord : OffTheRecordStatus.OnTheRecord)
        if let image_data = image_data, let image_name = image_name {
			client.uploadImage(data: image_data, filename: image_name) { photoID in
				self.client.sendChatMessage(conversation_id: self.id,
					segments: segments.map { $0.serialize() },
					image_id: image_id,
					image_user_id: nil,
					otr_status: otr_status) { _ in cb?() }
			}
		} else {
			client.sendChatMessage(conversation_id: id,
				segments: segments.map { $0.serialize() },
				image_id: nil,
				otr_status: otr_status,
				delivery_medium: getDefaultDeliveryMedium().mediumType!) { _ in cb?() }
		}
    }

    public func leave(cb: (() -> Void)? = nil) {
        switch (self.conversation.type!) {
        case ConversationType.Group:
			client.removeUser(conversation_id: id) { _ in cb?() }
        case ConversationType.OneToOne:
            client.deleteConversation(conversation_id: id) { _ in cb?() }
        default:
            break
        }
    }
	
	// Rename the conversation.
	// Hangouts only officially supports renaming group conversations, so
	// custom names for one-to-one conversations may or may not appear in all
	// first party clients.
    public func rename(name: String, cb: (() -> Void)?) {
        self.client.renameConversation(conversation_id: self.id, name: name) { _ in cb?() }
    }
	
	// Set the notification level of the conversation.
	// Pass .QUIET to disable notifications or .RING to enable them.
	public func setConversationNotificationLevel(level: NotificationLevel, cb: (() -> Void)?) {
		self.client.setConversationNotificationLevel(conversation_id: self.id, level: level) { _ in cb?() }
    }
	
	// Set typing status.
	// TODO: Add rate-limiting to avoid unnecessary requests.
    public func setTyping(typing: TypingType = TypingType.Started, cb: (() -> Void)? = nil) {
        client.setTyping(conversation_id: id, typing: typing) { _ in cb?() }
    }
	
	// Update the timestamp of the latest event which has been read.
	// By default, the timestamp of the newest event is used.
	// This method will avoid making an API request if it will have no effect.
    public func updateReadTimestamp(read_timestamp: Date? = nil, cb: (() -> Void)? = nil) {
		var read_timestamp = read_timestamp
        if read_timestamp == nil {
            read_timestamp = self.events.last!.timestamp
        }
        if let new_read_timestamp = read_timestamp {
            if new_read_timestamp > self.latest_read_timestamp {

                // Prevent duplicate requests by updating the conversation now.
                self.latest_read_timestamp = new_read_timestamp
                NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: self)
                //delegate?.conversationDidUpdate(conversation: self)
                //conversationList.conversationDidUpdate(conversation: self)
                client.updateWatermark(conv_id: id, read_timestamp: new_read_timestamp) { _ in cb?() }
            }
        }
    }

    public func handleEvent(event: IEvent) {
        NotificationCenter.default.post(name: Notification.Conversation.DidReceiveEvent, object: self, userInfo: ["event": event])
        /*if let delegate = delegate {
			delegate.conversation(self, didReceiveEvent: event)
        } else {
            let user = user_list[event.userID]
			if !user.me {
				//log.info("Notification \(event) from User \(user)!");
            }
        }*/
    }
	
    public func handleTypingStatus(status: TypingType, forUser user: User) {
        let existingTypingStatus = typingStatuses[user.id]
        if existingTypingStatus == nil || existingTypingStatus! != status {
            typingStatuses[user.id] = status
            NotificationCenter.default.post(name: Notification.Conversation.DidChangeTypingStatus, object: self, userInfo: ["user": user, "status": status])
            //delegate?.conversation(self, didChangeTypingStatusForUser: user, toStatus: status)
        }
    }

    public func handleWatermarkNotification(status: IWatermarkNotification) {
        NotificationCenter.default.post(name: Notification.Conversation.DidReceiveWatermark, object: self, userInfo: ["status": status])
		//delegate?.conversation(self, didReceiveWatermarkNotification: status)
    }

    public var _messages: [IChatMessageEvent] {
		get {
			return events.flatMap { $0 as? IChatMessageEvent }
        }
    }
	
	// Return list of Events ordered newest-first.
	// If event_id is specified, return events preceding this event.
	// This method will make an API request to load historical events if
	// necessary. If the beginning of the conversation is reached, an empty
	// list will be returned.
    public func getEvents(event_id: String? = nil, max_events: Int = 50, cb: (([IEvent]) -> Void)? = nil) {
        /*guard let event_id = event_id else {
            cb?(events)
            return
		}*/

        // If event_id is provided, return the events we have that are
        // older, or request older events if event_id corresponds to the
        // oldest event we have.
		var ts = Date()
        if	let event_id = event_id,
			let conv_event = self.get_event(event_id: event_id) {
			
            if events.first!.id != event_id {
                if let indexOfEvent = self.events.index(where: { $0 == conv_event }) {
                    cb?(Array(self.events[indexOfEvent..<self.events.endIndex]))
                    return
                }
            }
			ts = conv_event.timestamp
        }/* else {
            log.error("Event not found.")
			return
		}*/
		
		client.getConversation(conversation_id: id, event_timestamp: ts, max_events: max_events) { res in
			if res!.responseHeader!.status == ResponseStatus.InvalidRequest {
                log.error("Invalid request! \(String(describing: res!.responseHeader))")
				return
			}
			let conv_events = res!.conversationState!.event.map { IConversation.wrap_event(self.client, event: $0) }
			self.readStates = res!.conversationState!.conversation!.readState
			
			for conv_event in conv_events {
				//conv_event.client = self.client
				self.events_dict[conv_event.id] = conv_event
			}
			cb?(conv_events)
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateEvents, object: self)
			//self.delegate?.conversationDidUpdateEvents(self)
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

    public func get_event(event_id: EventID) -> IEvent? {
        return events_dict[event_id]
    }
	
	// The conversation's ID.
    public var id: String {
        get {
            return self.conversation.conversationId!.id!
        }
    }
	
	public var identifier: String {
		return self.id
	}
	
	public var eventStream: [EventStreamItem] {
		return self._messages.map { $0 as Message }
	}

    public var users: [User] {
        get {
            return conversation.participantData.map {
                self.user_list[User.ID(
                    chatID: $0.id!.chatId!,
                    gaiaID: $0.id!.gaiaId!
                )]
            }
        }
    }

    public var name: String {
        get {
			if let name = self.conversation.name {
                return name
            } else {
                return users.filter { !$0.me }.map { $0.fullName }.joined(separator: ", ")
            }
		}
		set {
			log.info("can't set name yet!")
		}
    }

    public var timestamp: Date {
        get {
			return Date.from(UTC: Double(conversation.selfConversationState?.sortTimestamp ?? 0))
			//.origin
        }
    }
	
	// datetime timestamp of the last read Event.
    public var latest_read_timestamp: Date {
        get {
			return Date.from(UTC: Double(conversation.selfConversationState?.selfReadState?.latestReadTimestamp ?? 0))
        }
        set(newLatestReadTimestamp) {
			// FIXME: Oops.
            //conversation.selfConversationState.selfReadState.latestReadTimestamp = newLatestReadTimestamp
        }
    }
	
	// List of Events that are unread.
	// Events are sorted oldest to newest.
	// Note that some Hangouts clients don't update the read timestamp for
	// certain event types, such as membership changes, so this method may
	// return more unread events than these clients will show. There's also a
	// delay between sending a message and the user's own message being
	// considered read.
    public var unread_events: [IEvent] {
        get {
            return events.filter { $0.timestamp > self.latest_read_timestamp }
        }
    }
	
	public var unreadCount: Int {
		return self.unread_events.count
	}

    public var hasUnreadEvents: Bool {
        get {
            if unread_events.first != nil {
                //log.info("Conversation \(name) has unread events, latest read timestamp is \(self.latest_read_timestamp)")
            }
            return unread_events.first != nil
        }
    }
	
	// True if this conversation has been archived.
    public var is_archived: Bool {
        get {
            return self.conversation.selfConversationState!.view.contains(ConversationView.Archived)
        }
    }
	
	// True if notification level for this conversation is quiet.
	public var is_quiet: Bool {
		get {
			return self.conversation.selfConversationState!.notificationLevel == NotificationLevel.Quiet
		}
	}
	
	// True if conversation is off the record (history is disabled).
    public var is_off_the_record: Bool {
        get {
            return self.conversation.otrStatus == OffTheRecordStatus.OffTheRecord
        }
    }
}

// Wrapper around Client that maintains a list of Conversations
public class ConversationList: ParrotServiceExtension.ConversationList {
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    fileprivate unowned let client: Client
    internal var conv_dict = [String: IConversation]() /* TODO: Should be fileprivate! */
    public var syncTimestamp: Date? = nil
    
    public init(client: Client) {
        self.client = client
        self._sync()
        hangoutsCenter.addObserver(self, selector: #selector(ConversationList.clientDidUpdateState(_:)),
                                   name: Client.didUpdateStateNotification, object: client)
    }
    
    deinit {
        hangoutsCenter.removeObserver(self)
    }
    
    public var conversations: [String: ParrotServiceExtension.Conversation] {
        var dict = Dictionary<String, ParrotServiceExtension.Conversation>()
        for (key, conv) in self.conv_dict {
            dict[key] = conv
        }
        return dict
    }
    
    private func _sync() {
        let s = DispatchSemaphore(value: 0)
        syncConversations { _ in
            s.signal()
        }
        s.wait()
    }
    
    /// Retrieve recent conversations so we can preemptively look up their participants.
    public func syncConversations(count: Int = 25, since: Date? = nil, handler: @escaping ([String: ParrotServiceExtension.Conversation]?) -> ()) {
        self.client.opQueue.async {
            self.client.syncRecentConversations(maxConversations: count, since: since) { response in
                let conv_states = response!.conversationState
                if let ts = response?._unknownFields[4] as? Int {
                    //let sync_timestamp = response!.syncTimestamp// use current_server_time?
                    self.syncTimestamp = Date.from(UTC: Double(ts))//.origin
                }
                
                // Initialize the list of conversations from Client's list of ClientConversationStates.
                var ret = [IConversation]()
                for conv_state in conv_states {
                    ret.append(self.add_conversation(client_conversation: conv_state.conversation!, client_events: conv_state.event))
                }
                _ = self.client.userList.addPeople(from: ret)
                
                let r: [String: ParrotServiceExtension.Conversation]? = ret.count > 0
                    ? ret.dictionaryMap { return [$0.id: $0 as ParrotServiceExtension.Conversation] }
                    : nil
                handler(r)
            }
        }
    }
    
    public func begin(with: [Person]) -> ParrotServiceExtension.Conversation? {
        let s = DispatchSemaphore(value: 0)
        var conv: IConversation? = nil
        self.client.createConversation(chat_id_list: with.map { $0.identifier }) {
            guard let c = $0?.conversation else { s.signal(); return }
            if ($0?.newConversationCreated ?? false) {
                conv = self.add_conversation(client_conversation: c)
            } else {
                conv = self.conv_dict[c.conversationId!.id!]
            }
            s.signal()
        }
        s.wait()
        return conv
    }
    
    public var unreadCount: Int {
        return Array(self.conv_dict.values)
            .filter { !$0.is_archived && $0.unread_events.count > 0 }
            .count
    }
    
    @discardableResult
    internal func add_conversation(
        client_conversation: Conversation,
        client_events: [Event] = []
        ) -> IConversation {
        let conv_id = client_conversation.conversationId!.id!
        let conv = IConversation(
            client: client,
            conversation: client_conversation,
            events: client_events
        )
        conv_dict[conv_id] = conv
        return conv
    }
}

// Receive client updates and fan them out to conversation notifications.
extension ConversationList {
    
    // Receive a ClientStateUpdate and fan out to Conversations
    @objc public func clientDidUpdateState(_ note: Notification) {
        guard let update = (note.userInfo)?[Client.didUpdateStateKey] as? StateUpdate else {
            log.error("Encountered an error! \(note)"); return
        }
        
        if let note = update.conversationNotification {
            log.debug("clientDidUpdateState: conversationNotification")
            _conversationNotification(note)
        } else if let note = update.eventNotification {
            log.debug("clientDidUpdateState: eventNotification")
            _eventNotification(note)
        } else if let note = update.focusNotification {
            log.debug("clientDidUpdateState: focusNotification => \(note)")
            
            let conv = self.conv_dict[note.conversationId!.id!]
            var focus = conv?.focus.filter { $0.sender?.identifier == note.senderId!.gaiaId! }.first
            //focus?.mode = note.type! == FocusType.Focused ? FocusMode.here : .away
            
        } else if let note = update.typingNotification {
            log.debug("clientDidUpdateState: typingNotification")
            _typingNotification(note)
        } else if let note = update.notificationLevelNotification {
            log.debug("clientDidUpdateState: notificationLevelNotification => \(note)")
        } else if let note = update.watermarkNotification {
            log.debug("clientDidUpdateState: watermarkNotification")
            _watermarkNotification(note)
        } else if let note = update.viewModification {
            log.debug("clientDidUpdateState: viewModification => \(note)")
        } else if let note = update.deleteNotification {
            log.debug("clientDidUpdateState: deleteNotification => \(note)")
        }
    }
    
    public func _conversationNotification(_ note: ConversationNotification) {
        let client_conversation = note.conversation!
        let conv_id = client_conversation.conversationId!.id!
        if let conv = conv_dict[conv_id] {
            conv.update_conversation(conversation: client_conversation)
        } else {
            self.add_conversation(client_conversation: client_conversation)
        }
        NotificationCenter.default.post(name: Notification.Conversation.DidUpdateList, object: self)
        //delegate?.conversationList(didUpdate: self)
    }
    
    public func _eventNotification(_ note: EventNotification) {
        let event = note.event!
        
        // Be sure to maintain the event sync_timestamp for sync'ing.
        //sync_timestamp = Date.from(UTC: Double(event.timestamp ?? 0))
        
        if let conv = conv_dict[event.conversationId!.id!] {
            let conv_event = conv.add_event(event: event)
            
            //delegate?.conversationList(self, didReceiveEvent: conv_event)
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
            //delegate?.conversationList(self, didChangeTypingStatus: res, forUser: user)
            conv.handleTypingStatus(status: res.status, forUser: user)
        } else {
            log.warning("Received ClientSetTypingNotification for unknown conversation \(conv_id)")
        }
    }
    
    public func _watermarkNotification(_ note: WatermarkNotification) {
        let conv_id = note.conversationId!.id!
        if let conv = self.conv_dict[conv_id] {
            let res = parseWatermarkNotification(client_watermark_notification: note)
            //self.delegate?.conversationList(self, didReceiveWatermarkNotification: res)
            conv.handleWatermarkNotification(status: res)
        } else {
            log.warning("Received WatermarkNotification for unknown conversation \(conv_id)")
        }
    }
}
