import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Conversation")

// Wrapper around Client for working with a single chat conversation.
public class IConversation: ParrotServiceExtension.Conversation {
    
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    public var client: Client
    public var conversation: Conversation
    
    // The conversation's internal ID.
    private var id: ConversationId {
        return self.conversation.conversation_id!
    }
    
	fileprivate var readStates: [UserReadState] = []
    fileprivate var typingStatuses: [User.ID: TypingType] = [:]
    fileprivate var focuses: [User.ID: Bool] = [:]
    
    public init(client: Client, conversation: Conversation, events: [Event] = []) {
        self.client = client
        self.conversation = conversation
        for event in events {
            self.add(event: event)
        }
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
		
        let old_timestamp = self.timestamp
        self.conversation = conversation
        
		if self.timestamp.toUTC() == 0 {//to_timestamp(date: ) == 0 {
			// FIXME: I think this is supposed to repair the read timestamp...
            self.conversation.self_conversation_state!.self_read_state!.latest_read_timestamp = old_timestamp.toUTC()
        }

        NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: self)
    }
    
    //
    //
    //
    
	private var _cachedEvents: [IEvent]? = nil
    public var events_dict: [IEvent.ID: IEvent] = [:] {
        didSet {
            self._cachedEvents = nil
        }
    }
    public var events: [IEvent] {
        get {
            if _cachedEvents == nil {
                _cachedEvents = events_dict.values.sorted { $0.timestamp < $1.timestamp }
            }
            return _cachedEvents!
        }
    }
    
    //
    //
    //
    
	@discardableResult
    internal func add(event: Event) -> IEvent {
        let wrapped = IEvent.wrap_event(self.client, event: event)
		self.events_dict[wrapped.id] = wrapped
        return wrapped
    }
    
    public var users: [User] {
        return self.conversation.participant_data.map {
            self.client.userList[User.ID(
                chatID: $0.id!.chat_id!,
                gaiaID: $0.id!.gaia_id!
            )]
        }
    }
    
    public var participants: [Person] {
        return self.users.map { $0 as Person }
    }
    
    public var identifier: String {
        return self.conversation.conversation_id!.id!
    }
    
    public var eventStream: [ParrotServiceExtension.Event] {
        return self.events
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
            let req = RenameConversationRequest(conversation_id: self.id, new_name: newValue,
                                                event_request_header: self.eventHeader(.ConversationRename))
            self.client.execute(req) {_,_ in}
        }
    }
    
    public var archived: Bool {
        get {
            return self.conversation.self_conversation_state!.view.contains(.Archived)
        }
        set {
            //last_event_timestamp: <#T##UInt64?#>?
            let req = ModifyConversationViewRequest(conversation_id: self.id, new_view: (newValue ? .Archived : .Inbox))
            self.client.execute(req) {_,_ in}
        }
    }
    
    public var timestamp: Date {
        get {
            //self_read_state!.latest_read_timestamp?
            return Date(UTC: self.conversation.self_conversation_state?.sort_timestamp ?? 0)
        }
        set {
            let req = UpdateWatermarkRequest(conversation_id: self.id, last_read_timestamp: newValue.toUTC())
            self.client.execute(req) {_,_ in}
        }
    }
    
    // List of Events that are unread.
    // Events are sorted oldest to newest.
    // Note that some Hangouts clients don't update the read timestamp for
    // certain event types, such as membership changes, so this method may
    // return more unread events than these clients will show. There's also a
    // delay between sending a message and the user's own message being
    // considered read.
    public var unreadCount: Int {
        return events
            .filter { $0.event.advances_sort_timestamp ?? false }
            .filter { $0.timestamp > self.timestamp }
            .count
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
        let id = (self.client.userList.me as! User).id
        let oldTyping = self.typingStatuses[id], oldFocus = self.focuses[id]
        
        if mode == .typing && self.typingStatuses[id] != .Started {
            self.typingStatuses[id] = .Started
            self.focuses[id] = true
        } else if mode == .enteredText && self.typingStatuses[id] != .Paused {
            self.typingStatuses[id] = .Paused
            self.focuses[id] = true
        } else if mode == .here && self.focuses[id] != true {
            self.typingStatuses[id] = .Stopped
            self.focuses[id] = true
        } else if mode == .away && self.focuses[id] == true {
            self.typingStatuses[id] = .Stopped
            self.focuses[id] = false
        }
        
        // Only update typing or focus IFF it has changed
        if oldTyping != self.typingStatuses[id] {
            let req1 = SetTypingRequest(conversation_id: self.id, type: self.typingStatuses[id]!)
            self.client.execute(req1) {_,_ in}
        }
        //timeout_secs: UInt32?
        if oldFocus != self.focuses[id] {
            let req2 = SetFocusRequest(conversation_id: self.id, type: (self.focuses[id]! ? .Focused : .Unfocused))
            self.client.execute(req2) {_,_ in}
        }
    }
	
	public var muted: Bool {
		get {
            return self.conversation.self_conversation_state?.notification_level ?? .Ring == .Quiet
		}
		set {
            //revert_timeout_secs: 0
            let req = SetConversationLevelRequest(conversation_id: self.id, level: (newValue ? .Quiet : .Ring))
            self.client.execute(req) {_, _ in}
		}
	}
    
    public func send(message: Message) throws {
        switch message.content {
        case .text(let text) where text.characters.count > 0:
            let seg = Segment(type: .Text, text: text)
            let req = SendChatMessageRequest(message_content: MessageContent(segment: [seg]),
                                             event_request_header: self.eventHeader(.RegularChatMessage))
            self.client.execute(req) {_,_ in}
        case .image(let url):
            let photo = try! Data(contentsOf: url), filename = url.lastPathComponent
            self.client.uploadIfNeeded(photo: .new(data: photo, name: filename)) { photoID, userID in
                let req = SendChatMessageRequest(existing_media: ExistingMedia(photo: Photo(photo_id: photoID, user_id: userID)),
                                                 event_request_header: self.eventHeader(.RegularChatMessage))
                self.client.execute(req) {_,_ in}
            }
        /*
        case .image(let photoID, let name):
            let otr = self.conversation.otr_status ?? .OnTheRecord
            let medium = self.getDefaultDeliveryMedium().medium_type!
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
        case .file(let url):
            func inner_sendLink(_ list: [String] = []) throws {
                let res = try DriveAPI.share(on: self.client.channel!, file: url, with: list)
                let seg = Segment(type: .Text, text: res.absoluteString)
                let req = SendChatMessageRequest(message_content: MessageContent(segment: [seg]),
                                                 event_request_header: self.eventHeader(.RegularChatMessage))
                self.client.execute(req) {_,_ in}
            }
            
            //guard let c = (self.conversation as? IConversation)?.client.channel else { return }
            if self.participants.count == 2 { // it's just you and me...
                if let p = (self.participants.filter { !$0.me }).first { // grab your ref
                    let locs = p.locations.filter { $0.contains("@gmail.com") } // grab all your gmails
                    if locs.count > 0 { // is this a 1v1 convo with a Gmail user?
                        try inner_sendLink([locs.first!])
                        return
                    }
                }
            }
            // We're in a GVoice convo, or a group convo, so just send a group link.
            try inner_sendLink()
        case .location(let lat, let long):
            let loc = "https://maps.google.com/maps?q=\(lat),\(long)"
            let img = "https://maps.googleapis.com/maps/api/staticmap?center=\(lat),\(long)&markers=color:red%7C\(lat),\(long)&size=400x400"
            
            let rep = RepresentativeImage(type: [.Thing, .Place, .init(336), .init(338), .init(339)], url: img, image: VoicePhoto(url: img))
            let place = Place(url: loc, name: "Current Location", display_info: PlaceDisplayInfo(description: PlaceDescription(text: "Current Location")), location_info: PlaceLocationInfo(latlng: Coordinates(lat: lat, lng: long)), representative_image: rep)
            
            let req = SendChatMessageRequest(event_request_header: self.eventHeader(.RegularChatMessage), attach_location: LocationSpec(place: place))
            self.client.execute(req) {_,_ in}
        default: throw MessageError.unsupported
        }
    }
    
    public func leave() {
        switch (self.conversation.type!) {
        case .Group:
            //participant_id: self?
            let req = RemoveUserRequest(conversation_id: self.id, event_request_header: self.eventHeader(.RemoveUser))
            self.client.execute(req) {_,_ in}
        case .OneToOne:
            //delete_upper_bound_timestamp: <#T##UInt64?#>?
            let req = DeleteConversationRequest(conversation_id: self.id)
            self.client.execute(req) {_,_ in}
        default: break
        }
    }
    
    // Update the timestamp of the latest event which has been read.
    // By default, the timestamp of the newest event is used.
    // This method will avoid making an API request if it will have no effect.
    // nil = latest event's timestamp
    public func update(readTimestamp: Date?, cb: (() -> Void)? = nil) {
        let ts = readTimestamp ?? self.events.last!.timestamp
        guard ts > self.timestamp else { return }
            
        // Prevent duplicate requests by updating the conversation now.
        self.timestamp = ts
        NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: self)
    }
    
    public func handleEvent(event: IEvent) {
        if let advance = event.event.advances_sort_timestamp,
            let ts = event.event.timestamp, advance {
            log.debug("Advancing timestamp to \(ts) from \(self.timestamp.toUTC())")
            self.timestamp = Date(UTC: ts)
        }
        
        NotificationCenter.default.post(name: Notification.Conversation.DidReceiveEvent, object: self, userInfo: ["event": event])
        /*if let delegate = delegate {
         delegate.conversation(self, didReceiveEvent: event)
         } else {
         let user = self.client.userList[event.userID]
         if !user.me {
         //log.info("Notification \(event) from User \(user)!");
         }
         }*/
    }
    
    // note: a GVoice user is always considered "here"
    public func handleFocus(status: Bool, forUser user: User) {
        let existingFocus = focuses[user.id]
        if existingFocus == nil || existingFocus! != status {
            focuses[user.id] = status
            let fused = FocusMode(typingStatus: typingStatuses[user.id] ?? .Stopped,
                                  focus: focuses[user.id] ?? self.conversation.network_type.contains(.Phone))
            NotificationCenter.default.post(name: Notification.Conversation.DidChangeFocus,
                                            object: self, userInfo: ["user": user, "status": fused])
        }
    }
    
    // note: a GVoice user is always considered "here"
    public func handleTypingStatus(status: TypingType, forUser user: User) {
        let existingTypingStatus = typingStatuses[user.id]
        if existingTypingStatus == nil || existingTypingStatus! != status {
            typingStatuses[user.id] = status
            let fused = FocusMode(typingStatus: typingStatuses[user.id] ?? .Stopped,
                                  focus: focuses[user.id] ?? self.conversation.network_type.contains(.Phone))
            NotificationCenter.default.post(name: Notification.Conversation.DidChangeFocus,
                                            object: self, userInfo: ["user": user, "status": fused])
        }
    }
    
    public func syncEvents(count: Int, before: ParrotServiceExtension.Event?, handler: @escaping ([ParrotServiceExtension.Event]) -> ()) {
        self.getEvents(event_id: before?.identifier, max_events: count) {
            handler($0 as [ParrotServiceExtension.Event])
        }
    }
    
    // Return list of Events ordered newest-first.
    // If event_id is specified, return events preceding this event.
    // This method will make an API request to load historical events if
    // necessary. If the beginning of the conversation is reached, an empty
    // list will be returned.
    public func getEvents(event_id: String? = nil, max_events: Int = 50, cb: (([IEvent]) -> Void)? = nil) {
        
        // If event_id is provided, return the events we have that are
        // older, or request older events if event_id corresponds to the
        // oldest event we have.
        var ts = Date()
        if  let event_id = event_id,
            let conv_event = self.events_dict[event_id] {
            
            if events.first!.id != event_id {
                if let indexOfEvent = self.events.index(where: { $0 == conv_event }) {
                    cb?(Array(self.events[indexOfEvent..<self.events.endIndex]))
                    return
                }
            }
            ts = conv_event.timestamp
        }
        
        let req = GetConversationRequest(conversation_spec: ConversationSpec(conversation_id: self.id),
                                         include_conversation_metadata: true,
                                         include_event: true,
                                         max_events_per_conversation: UInt64(max_events),
                                         event_continuation_token: EventContinuationToken(event_timestamp: ts.toUTC()),
                                         include_presence: true)
        self.client.execute(req) { res, _ in
            guard let res = res else { cb?([]); return }
            let conv_events = res.conversation_state!.event.map { IEvent.wrap_event(self.client, event: $0) }
            self.readStates = res.conversation_state!.conversation!.read_state
            
            for conv_event in conv_events {
                self.events_dict[conv_event.id] = conv_event
            }
            cb?(conv_events)
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateEvents, object: self)
        }
    }
    
    // Return default DeliveryMedium to use for sending messages.
    // Use the first option, or an option that's marked as the current default.
    private func getDefaultDeliveryMedium() -> DeliveryMedium {
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
    private func eventHeader(_ type: EventType) -> EventRequestHeader {
        return EventRequestHeader(conversation_id: self.id,
                                  client_generated_id: RequestHeader.uniqueID(),
                                  expected_otr: self.conversation.otr_status,
                                  delivery_medium: self.getDefaultDeliveryMedium(),
                                  event_type: type)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.personDidUpdate(_:)),
                                               name: Notification.Person.DidUpdate, object: nil)
    }
    
    deinit {
        hangoutsCenter.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
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
        let req = SyncRecentConversationsRequest(end_timestamp: since?.toUTC(),
                                                 max_conversations: UInt64(count),
                                                 max_events_per_conversation: UInt64(1),
                                                 sync_filter: [.Inbox, .Active, .Invited])
        self.client.execute(req) { response, err in
            let conv_states = response!.conversation_state
            if let ts = response?.continuation_end_timestamp {
                //let sync_timestamp = response!.syncTimestamp// use current_server_time?
                self.syncTimestamp = Date(UTC: ts)//.origin
            }
            
            // Initialize the list of conversations from Client's list of ClientConversationStates.
            var ret = [IConversation]()
            for conv_state in conv_states {
                ret.append(self.add_conversation(client_conversation: conv_state.conversation!, client_events: conv_state.event))
            }
            _ = self.client.userList.addPeople(from: ret)
            
            let r: [String: ParrotServiceExtension.Conversation]? = ret.count > 0
                ? ret.mapKeyValues { return ($0.identifier, $0 as ParrotServiceExtension.Conversation) }
                : nil
            handler(r)
        }
    }
    
    /// Retrieve a particular conversation.
    private func getConversation(id: String, _ max_events: Int = 5, handler cb: @escaping (IConversation?, Error?) -> ()) {
        let req = GetConversationRequest(conversation_spec: ConversationSpec(conversation_id: ConversationId(id: id)),
                                         include_conversation_metadata: true,
                                         include_event: true,
                                         max_events_per_conversation: UInt64(max_events),
                                         include_presence: true)
        self.client.execute(req) { res, err in
            guard let res = res else { cb(nil, err); return }
            
            // Initialize the list of conversations from Client's list of ClientConversationStates.
            let conv = self.add_conversation(client_conversation: res.conversation_state!.conversation!,
                                             client_events: res.conversation_state!.event)
            _ = self.client.userList.addPeople(from: [conv])
            
            cb(conv, nil)
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateList, object: self)
        }
    }
    
    public func begin(with: [Person]) -> ParrotServiceExtension.Conversation? {
        let req = CreateConversationRequest(type: with.count > 1 ? .Group : .OneToOne,
                                            client_generated_id: RequestHeader.uniqueID(),
                                            invitee_id: with.map { InviteeID(gaia_id: $0.identifier) })
        let resp = try? self.client.execute(req)
        
        guard let c = resp?.conversation else { return nil }
        if (resp?.new_conversation_created ?? false) || (self.conv_dict[c.conversation_id!.id!] == nil) {
            let added = self.add_conversation(client_conversation: c)
            if resp?.new_conversation_created ?? false { // only post this if the server says it's a new conv
                NotificationCenter.default.post(name: Notification.Conversation.DidCreate, object: added)
            }
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateList, object: self)
            return added
        } else {
            return self.conv_dict[c.conversation_id!.id!]
        }
    }
    
    public var unreadCount: Int {
        return self.conv_dict
            .filter { !$0.value.archived && $0.value.unreadCount > 0 }
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
    
    // If a person changed, any conversations with that person also have changed.
    @objc func personDidUpdate(_ note: Notification) {
        guard let user = note.object as? User else { return }
        for conv in (self.conv_dict.values.filter { $0.users.contains(user) }) {
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: conv)
        }
    }
    
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
            //sync_timestamp = Date(UTC: event.timestamp)
            if let conv = conv_dict[event.conversation_id!.id!] {
                let conv_event = conv.add(event: note.event!)
                conv.handleEvent(event: conv_event)
            } else {
                self.getConversation(id: event.conversation_id!.id!) { conv, err in
                    guard err == nil && conv != nil else {
                        log.info("Received ClientEvent for unknown conversation \(event.conversation_id!.id!): \(String(describing: err))")
                        return
                    }
                    let conv_event = conv!.add(event: note.event!)
                    conv!.handleEvent(event: conv_event)
                }
            }
            
        } else if let note = update.focus_notification {
            if let conv = self.conv_dict[note.conversation_id!.id!] {
                let user = self.client.userList[User.ID(
                    chatID: note.sender_id!.chat_id!,
                    gaiaID: note.sender_id!.gaia_id!
                )]
                conv.handleFocus(status: note.type! == .Focused, forUser: user)
            } else {
                log.info("Received SetFocusNotification for unknown conversation \(note.conversation_id!.id!)")
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
                log.info("Received ClientSetTypingNotification for unknown conversation \(note.conversation_id!.id!)")
            }
            
        } else if let note = update.notification_level_notification {
            log.debug("clientDidUpdateState: notificationLevelNotification => \(note)")
        } else if let note = update.watermark_notification {
            if let conv = self.conv_dict[note.conversation_id!.id!] {
                let res = parseWatermarkNotification(client_watermark_notification: note)
                NotificationCenter.default.post(name: Notification.Conversation.DidReceiveWatermark,
                                                object: conv, userInfo: ["status": res])
            } else {
                log.info("Received WatermarkNotification for unknown conversation \(note.conversation_id!.id!)")
            }
            
        } else if let note = update.view_modification {
            log.debug("clientDidUpdateState: viewModification => \(note)")
        } else if let note = update.delete_notification {
            log.debug("clientDidUpdateState: deleteNotification => \(note)")
        }
    }
}

fileprivate extension FocusMode {
    
    init(typingStatus type: TypingType, focus: Bool) {
        if type == .Started {
            self = .typing
        } else if type == .Paused {
            self = .enteredText
        } else if focus {
            self = .here
        } else {
            self = .away // DNE
        }
    }
    
    var components: (TypingType, Bool) {
        if self == .typing {
            return (.Started, true)
        } else if self == .enteredText {
            return (.Paused, true)
        } else if self == .here {
            return (.Stopped, true)
        } else { // if self == .away
            return (.Stopped, false)
        }
    }
}
