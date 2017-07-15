import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Conversation")

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
    
	fileprivate var readStates: [UserReadState] = []
    fileprivate var typingStatuses = Dictionary<User.ID, TypingType>()
    fileprivate var focuses = Dictionary<User.ID, Bool>()

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
            //self.conversation.self_conversation_state.selfReadState.latestReadTimestamp = notif.readTimestamp
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
            self.conversation.self_conversation_state!.self_read_state!.latest_read_timestamp = UInt64(old_timestamp.toUTC())
        }

        NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: self)
        //delegate?.conversationDidUpdate(conversation: self)
    }
	
	// Wrap ClientEvent in Event subclass.
    private class func wrap_event(_ client: Client, event: Event) -> IEvent {
        if event.chat_message != nil {
            return IChatMessageEvent(client, event: event)
        } else if event.conversation_rename != nil {
            return IRenameEvent(client, event: event)
        } else if event.membership_change != nil {
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
		let medium_options = self.conversation.self_conversation_state?.delivery_medium_option
		
		var default_medium: DeliveryMedium = DeliveryMedium()
		default_medium.medium_type = .Babel
		if let r = medium_options?[0].delivery_medium {
			default_medium = r
		}
		for medium_option in medium_options! {
			if let m = medium_option.current_default, m {
				default_medium = medium_option.delivery_medium!; break
			}
		}
		return default_medium
	}
	
	public func getEventRequestHeader() -> EventRequestHeader {
		let otr_status: OffTheRecordStatus = (self.is_off_the_record ? .OffTheRecord : .OnTheRecord)
		var e = EventRequestHeader()
		e.conversation_id = self.conversation.conversation_id
		//e.clientGeneratedId = UInt64(self.client.generateClientID())
		e.expected_otr = otr_status
		e.delivery_medium = getDefaultDeliveryMedium()
		return e
	}
    
    public var focus: [Person.IdentifierType: FocusMode] {
        var dict = [String: FocusMode]()
        for u in self.users {
            if let type = self.typingStatuses[u.id], type == .Started {
                dict[u.identifier] = .typing
            } else if let type = self.typingStatuses[u.id], type == .Paused {
                dict[u.identifier] = .enteredText
            } else if let fcs = self.focuses[u.id] {
                dict[u.identifier] = fcs ? .here : .away
            } else {
                let gv = self.conversation.network_type.contains(.Phone)
                dict[u.identifier] = gv ? .here : .away // DNE case
            }
        }
        return dict
    }
    
    // FIXME: ugh...
    public func focus(mode: FocusMode) {
        let id = (self.user_list.me as! User).id
        
        if mode == .typing && self.typingStatuses[id] != .Started {
            self.client.setFocus(conversation_id: self.id, focused: true)
            self.client.setTyping(conversation_id: self.id, typing: .Started)
            self.typingStatuses[id] = .Started
            self.focuses[id] = true
            
        } else if mode == .enteredText && self.typingStatuses[id] != .Paused {
            self.client.setFocus(conversation_id: self.id, focused: true)
            self.client.setTyping(conversation_id: self.id, typing: .Paused)
            self.typingStatuses[id] = .Paused
            self.focuses[id] = true
            
        } else if mode == .here && self.focuses[id] != true {
            self.client.setFocus(conversation_id: self.id, focused: true)
            self.client.setTyping(conversation_id: self.id, typing: .Stopped)
            self.typingStatuses[id] = .Stopped
            self.focuses[id] = true
            
        } else if mode == .away && self.focuses[id] == true {
            self.client.setFocus(conversation_id: self.id, focused: false)
            self.client.setTyping(conversation_id: self.id, typing: .Stopped)
            self.typingStatuses[id] = .Stopped
            self.focuses[id] = false
        }
    }
	
	public var muted: Bool {
		get {
            log.debug("NOT IMPLEMENTED: Conversation.muted.get!")
			return false
			//return self.setConversationNotificationLevel(level: , cb: nil)
		}
		set {
			self.setConversationNotificationLevel(level: (newValue ? .Quiet : .Ring), cb: nil)
		}
	}
    
    // TODO: opQueue should be serial!
    public func send(message: Message) throws {
        let otr: OffTheRecordStatus = (self.is_off_the_record ? .OffTheRecord : .OnTheRecord)
        let medium = self.getDefaultDeliveryMedium().medium_type!
        
        switch message.content {
        case .text(let text) where text.characters.count > 0:
            let s = DispatchSemaphore(value: 0)
            self.client.opQueue.async {
                self.client.sendChatMessage(conversation_id: self.id,
                                            segments: [IChatMessageSegment(text: text)].map { $0.serialize() },
                                            image_id: nil,
                                            otr_status: otr,
                                            delivery_medium: medium) { _ in s.signal() }
            }
            s.wait()
        case .image(let photo, let name):
            let s = DispatchSemaphore(value: 0)
            self.client.opQueue.async {
                self.client.uploadIfNeeded(photo: .new(data: photo, name: name)) { photoID, userID in
                    self.client.sendChatMessage(conversation_id: self.id,
                                                segments: [],
                                                image_id: photoID,
                                                image_user_id: userID,
                                                otr_status: otr,
                                                delivery_medium: medium) { _ in s.signal() }
                }
            }
            s.wait()
        /*
        case .image(let photoID, let name):
            let s = DispatchSemaphore(value: 0)
            self.client.opQueue.async {
                self.client.uploadIfNeeded(photo: .existing(id: photoID, name: name)) { photoID, userID in
                    self.client.sendChatMessage(conversation_id: self.id,
                                                segments: [],
                                                image_id: photoID,
                                                image_user_id: userID,
                                                otr_status: otr,
                                                delivery_medium: medium) { _ in s.signal() }
                }
            }
            s.wait()
        */
        //case .location(lat, long):
            //TODO
        default: throw MessageError.unsupported
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
        let req = SetTypingRequest(conversation_id: ConversationId(id: id), type: typing)
        self.client.execute(SetTyping.self, with: req) { _, _ in cb?() }
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
                
                var req = UpdateWatermarkRequest()
                var _id = ConversationId()
                _id.id = id
                req.conversation_id = _id
                req.last_read_timestamp = UInt64(new_read_timestamp.toUTC())
                client.execute(UpdateWatermark.self, with: req) {_,_ in cb?()}
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
            NotificationCenter.default.post(name: Notification.Conversation.DidChangeTypingStatus,
                                            object: self, userInfo: ["user": user, "status": status])
        }
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
        if    let event_id = event_id,
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
            if res!.response_header!.status == ResponseStatus.InvalidRequest {
                log.error("Invalid request! \(String(describing: res!.response_header))")
                return
            }
            let conv_events = res!.conversation_state!.event.map { IConversation.wrap_event(self.client, event: $0) }
            self.readStates = res!.conversation_state!.conversation!.read_state
            
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
            return self.conversation.conversation_id!.id!
        }
    }
    
    public var identifier: String {
        return self.id
    }
    
    public var messages: [Message] {
        return self._messages.map { $0 as Message }
    }
    
    public var users: [User] {
        get {
            return conversation.participant_data.map {
                self.user_list[User.ID(
                    chatID: $0.id!.chat_id!,
                    gaiaID: $0.id!.gaia_id!
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
            self.client.renameConversation(conversation_id: self.id, name: newValue)
        }
    }
    
    public var timestamp: Date {
        get {
            return Date.from(UTC: Double(conversation.self_conversation_state?.sort_timestamp ?? 0))
            //.origin
        }
    }
    
    // datetime timestamp of the last read Event.
    public var latest_read_timestamp: Date {
        get {
            return Date.from(UTC: Double(conversation.self_conversation_state?.self_read_state?.latest_read_timestamp ?? 0))
        }
        set(newLatestReadTimestamp) {
            // FIXME: Oops.
            //conversation.self_conversation_state.selfReadState.latestReadTimestamp = newLatestReadTimestamp
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
            return self.conversation.self_conversation_state!.view.contains(ConversationView.Archived)
        }
    }
    
    // True if notification level for this conversation is quiet.
    public var is_quiet: Bool {
        get {
            return self.conversation.self_conversation_state!.notification_level == NotificationLevel.Quiet
        }
    }
    
    // True if conversation is off the record (history is disabled).
    public var is_off_the_record: Bool {
        get {
            return self.conversation.otr_status == OffTheRecordStatus.OffTheRecord
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
        let req = SyncRecentConversationsRequest(end_timestamp: (since != nil ? UInt64(since!.toUTC()) : nil),
                                                 max_conversations: UInt64(count),
                                                 max_events_per_conversation: UInt64(1),
                                                 sync_filter: [.Inbox, .Active, .Invited])
        self.client.execute(SyncRecentConversations.self, with: req) { response, err in
            let conv_states = response!.conversation_state
            if let ts = response?.continuation_end_timestamp {
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
    
    public func begin(with: Person...) -> ParrotServiceExtension.Conversation? {
        let req = CreateConversationRequest(type: with.count > 1 ? .Group : .OneToOne,
                                            client_generated_id: RequestHeader.uniqueID(),
                                            invitee_id: with.map { InviteeID(gaia_id: $0.identifier) })
        let resp = try? self.client.execute(CreateConversation.self, with: req)
        
        guard let c = resp?.conversation else { return nil }
        if (resp?.new_conversation_created ?? false) {
            return self.add_conversation(client_conversation: c)
        } else {
            return self.conv_dict[c.conversation_id!.id!]
        }
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
        let conv_id = client_conversation.conversation_id!.id!
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
        
        if let note = update.conversation_notification {
            let client_conversation = note.conversation!
            if let conv = conv_dict[client_conversation.conversation_id!.id!] {
                conv.update_conversation(conversation: client_conversation)
            } else {
                self.add_conversation(client_conversation: client_conversation)
            }
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateList, object: self)
            
        } else if let note = update.event_notification {
            let event = note.event!
            // Be sure to maintain the event sync_timestamp for sync'ing.
            //sync_timestamp = Date.from(UTC: Double(event.timestamp ?? 0))
            if let conv = conv_dict[event.conversation_id!.id!] {
                let conv_event = conv.add_event(event: note.event!)
                conv.handleEvent(event: conv_event)
            } else {
                log.warning("Received ClientEvent for unknown conversation \(event.conversation_id!.id!)")
            }
            
        } else if let note = update.focus_notification {
            if let conv = self.conv_dict[note.conversation_id!.id!] {
                let userid = User.ID(chatID: note.sender_id!.chat_id!, gaiaID: note.sender_id!.gaia_id!)
                conv.focuses[userid] = note.type! == .Focused
                NotificationCenter.default.post(name: Notification.Conversation.DidChangeFocus, object: conv)
            } else {
                log.warning("Received SetFocusNotification for unknown conversation \(note.conversation_id!.id!)")
            }
            
        } else if let note = update.typing_notification {
            if let conv = conv_dict[note.conversation_id!.id!] {
                let res = parseTypingStatusMessage(p: note)
                let user = self.client.userList[User.ID(
                    chatID: note.sender_id!.chat_id!,
                    gaiaID: note.sender_id!.gaia_id!
                )]
                conv.handleTypingStatus(status: res.status, forUser: user)
            } else {
                log.warning("Received ClientSetTypingNotification for unknown conversation \(note.conversation_id!.id!)")
            }
            
        } else if let note = update.notification_level_notification {
            log.debug("clientDidUpdateState: notificationLevelNotification => \(note)")
        } else if let note = update.watermark_notification {
            if let conv = self.conv_dict[note.conversation_id!.id!] {
                let res = parseWatermarkNotification(client_watermark_notification: note)
                NotificationCenter.default.post(name: Notification.Conversation.DidReceiveWatermark,
                                                object: conv, userInfo: ["status": res])
            } else {
                log.warning("Received WatermarkNotification for unknown conversation \(note.conversation_id!.id!)")
            }
            
        } else if let note = update.view_modification {
            log.debug("clientDidUpdateState: viewModification => \(note)")
        } else if let note = update.delete_notification {
            log.debug("clientDidUpdateState: deleteNotification => \(note)")
        }
    }
}

