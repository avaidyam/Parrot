import Foundation
import HangoutsCore
import ParrotServiceExtension
import class Mocha.Logger

private let log = Logger(subsystem: "Hangouts.Conversation")

// Wrapper around Client for working with a single chat conversation.
public class IConversation: ParrotServiceExtension.Conversation {
    
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    public var client: Client
    public var conversation: ClientConversation
    
    // The conversation's internal ID.
    private var id: ClientConversationId {
        return self.conversation.id!
    }
    
	fileprivate var readStates: [ClientUserReadState] = []
    fileprivate var typingStatuses: [User.ID: ClientTypingType] = [:]
    fileprivate var focuses: [User.ID: Bool] = [:]
    
    public init(client: Client, conversation: ClientConversation, events: [ClientEvent] = []) {
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
    public func updateConversation(conversation: ClientConversation) {
        
		
		/* TODO: Enable this. */
		/*
		let newState = conversation.selfConversationState
		if newState.deliveryMediumOption.count == 0 {
			let oldState = self.conversation.selfConversationState
			newState.deliveryMediumOption.appendContentsOf(oldState.deliveryMediumOption)
		}
		*/
		
        let oldTimestamp = self.timestamp
        self.conversation = conversation
        
		if self.timestamp.toUTC() == 0 {//toTimestamp(date: ) == 0 {
			// FIXME: I think this is supposed to repair the read timestamp...
            self.conversation.selfConversationState!.selfReadState!.latestReadTimestamp = oldTimestamp.toUTC()
        }

        NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: self)
    }
    
    //
    //
    //
    
	private var _cachedEvents: [IEvent]? = nil
    public var eventsDict: [IEvent.ID: IEvent] = [:] {
        didSet {
            self._cachedEvents = nil
        }
    }
    public var events: [IEvent] {
        get {
            if _cachedEvents == nil {
                _cachedEvents = eventsDict.values.sorted { $0.timestamp < $1.timestamp }
            }
            return _cachedEvents!
        }
    }
    
    //
    //
    //
    
	@discardableResult
    internal func add(event: ClientEvent) -> IEvent {
        let wrapped = IEvent.wrapEvent(self.client, event: event)
		self.eventsDict[wrapped.id] = wrapped
        return wrapped
    }
    
    public var users: [User] {
        return self.conversation.participantDataArray.map {
            self.client.userList[User.ID(
                chatID: $0.id!.chatId!,
                gaiaID: $0.id!.gaiaId!
            )]
        }
    }
    
    public var participants: [Person] {
        return self.users.map { $0 as Person }
    }
    
    public var identifier: String {
        return self.conversation.id!.id!
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
            let req = ClientRenameConversationRequest(deprecated2: self.id.id, newName: newValue,
                                                eventRequestHeader: self.eventHeader(.renameConversation))
            self.client.execute(req) {_,_ in}
        }
    }
    
    public var archived: Bool {
        get {
            return self.conversation.selfConversationState!.viewArray.contains(.archivedView)
        }
        set {
            //lastEventTimestamp: <#T##UInt64?#>?
            let req = ClientModifyConversationViewRequest(conversationId: self.id, newView: (newValue ? .archivedView : .inboxView))
            self.client.execute(req) {_,_ in}
        }
    }
    
    public var timestamp: Date {
        get {
            //selfReadState!.latestReadTimestamp?
            return Date(UTC: self.conversation.selfConversationState?.sortTimestamp ?? 0)
        }
        set {
            let req = ClientUpdateWatermarkRequest(conversationId: self.id, latestReadTimestamp: newValue.toUTC())
            self.client.execute(req) {_,_ in}
        }
    }
    
    public func __delete(_ event: IChatMessageEvent, _ handler: @escaping (ClientDeleteConversationResponse?, Error?) -> ()) {
        let req = ClientDeleteConversationRequest(conversationId: self.id, deleteType: .perEventDelete, deleteEventIdArray: [event.id])
        self.client.execute(req, handler: handler)
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
            .filter { $0.event.advancesSortTimestamp ?? false }
            .filter { $0.timestamp > self.timestamp }
            .count
    }
    
    public var focus: [Person.IdentifierType: FocusMode] {
        var dict = [String: FocusMode]()
        for u in self.users {
            if let type = self.typingStatuses[u.id], type == .start {
                dict[u.identifier] = .typing
            } else if let type = self.typingStatuses[u.id], type == .pause {
                dict[u.identifier] = .enteredText
            } else if let fcs = self.focuses[u.id] {
                dict[u.identifier] = fcs ? .here : .away
            } else {
                let gv = self.conversation.networkTypeArray.contains(.phone)
                dict[u.identifier] = gv ? .here : .away // DNE case
            }
        }
        return dict
    }
    
    // FIXME: ugh...
    public func focus(mode: FocusMode) {
        let id = (self.client.userList.me as! User).id
        let oldTyping = self.typingStatuses[id], oldFocus = self.focuses[id]
        
        if mode == .typing && self.typingStatuses[id] != .start {
            self.typingStatuses[id] = .start
            self.focuses[id] = true
        } else if mode == .enteredText && self.typingStatuses[id] != .pause {
            self.typingStatuses[id] = .pause
            self.focuses[id] = true
        } else if mode == .here && self.focuses[id] != true {
            self.typingStatuses[id] = .clear
            self.focuses[id] = true
        } else if mode == .away && self.focuses[id] == true {
            self.typingStatuses[id] = .clear
            self.focuses[id] = false
        }
        
        // Only update typing or focus IFF it has changed
        if oldTyping != self.typingStatuses[id] {
            let req1 = ClientSetTypingRequest(conversationId: self.id, type: self.typingStatuses[id]!)
            self.client.execute(req1) {_,_ in}
        }
        //timeoutSecs: UInt32?
        if oldFocus != self.focuses[id] {
            let req2 = ClientSetFocusRequest(conversationId: self.id, type: (self.focuses[id]! ? .focus : .unfocus))
            self.client.execute(req2) {_,_ in}
        }
    }
	
	public var muted: Bool {
		get {
            return self.conversation.selfConversationState?.notificationLevel ?? .ding == .off
		}
		set {
            //revertTimeoutSecs: 0
            let req = ClientSetConversationNotificationLevelRequest(conversationId: self.id, level: (newValue ? .off : .ding))
            self.client.execute(req) {_, _ in}
		}
	}
    
    public func send(message: Message) throws {
        NotificationCenter.default.post(name: Notification.Conversation.WillSendEvent, object: self, userInfo: ["event": message])
        
        switch message.content {
        case .text(let text) where text.count > 0:
            let seg = SocialSegment(type: .text, text: text)
            let req = ClientSendChatMessageRequest(messageContent: ClientMessageContent(segmentArray: [seg]),
                                             eventRequestHeader: self.eventHeader(.regularChatMessage))
            self.client.execute(req) {_,_ in}
        case .image(let url):
            let photo = try! Data(contentsOf: url), filename = url.lastPathComponent
            self.client.uploadIfNeeded(photo: .new(data: photo, name: filename)) { photoID, userID in
                let req = ClientSendChatMessageRequest(existingMedia: ClientExistingMedia(photo: ClientExistingMedia_Photo(photoId: photoID, ownerGaiaId: userID)),
                                                 eventRequestHeader: self.eventHeader(.regularChatMessage))
                self.client.execute(req) {_,_ in}
            }
        /*
        case .image(let photoID, let name):
            let otr = self.conversation.otrStatus ?? .onTheRecord
            let medium = self.getDefaultDeliveryMedium().mediumType!
            let s = DispatchSemaphore(value: 0)
            self.client.opQueue.async {
                self.client.uploadIfNeeded(photo: .existing(id: photoID, name: name)) { photoID, userID in
                    self.client.sendChatMessage(conversationId: self.id,
                                                segments: [],
                                                imageId: photoID,
                                                imageUserId: userID,
                                                otrStatus: otr,
                                                deliveryMedium: medium) { _ in s.signal() }
                }
            }
            s.wait()
        */
        case .file(let url):
            func inner_sendLink(_ list: [String] = []) throws {
                let res = try DriveAPI.share(on: self.client.channel!, file: url, with: list)
                let seg = SocialSegment(type: .text, text: res.absoluteString)
                let req = ClientSendChatMessageRequest(messageContent: ClientMessageContent(segmentArray: [seg]),
                                                 eventRequestHeader: self.eventHeader(.regularChatMessage))
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
            
            let rep = EMEmbedClientItem_EMImageObjectV2_Holder(typeArray: [.thing, .place, .init(336), .init(338), .init(339)], id_p: img, imageObjectV2: EMImageObjectV2(URL: img))
            let place = EMPlaceV2(URL: loc, name: "Current Location", address: EMEmbedClientItem_EMPostalAddressV2_Holder(postalAddressV2: EMPostalAddressV2(streetAddress: "Current Location")), geo: EMEmbedClientItem_EMGeoCoordinatesV2_Holder(geoCoordinatesV2: EMGeoCoordinatesV2(latitude: lat, longitude: long)), representativeImage: rep)
            
            let req = ClientSendChatMessageRequest(eventRequestHeader: self.eventHeader(.regularChatMessage), attachLocation: ClientLocationSpec(place: place))
            self.client.execute(req) {_,_ in}
        default: throw MessageError.unsupported
        }
    }
    
    public func leave() {
        switch (self.conversation.type!) {
        case .group:
            //participantId: self?
            let req = ClientRemoveUserRequest(deprecated2: self.id.id, eventRequestHeader: self.eventHeader(.removeUser))
            self.client.execute(req) {_,_ in}
        case .stickyOneToOne:
            //deleteUpperBoundTimestamp: <#T##UInt64?#>?
            let req = ClientDeleteConversationRequest(conversationId: self.id)
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
        if let advance = event.event.advancesSortTimestamp,
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
            let fused = FocusMode(typingStatus: typingStatuses[user.id] ?? .clear,
                                  focus: focuses[user.id] ?? self.conversation.networkTypeArray.contains(.phone))
            NotificationCenter.default.post(name: Notification.Conversation.DidChangeFocus,
                                            object: self, userInfo: ["user": user, "status": fused])
        }
    }
    
    // note: a GVoice user is always considered "here"
    public func handleTypingStatus(status: ClientTypingType, forUser user: User) {
        let existingTypingStatus = typingStatuses[user.id]
        if existingTypingStatus == nil || existingTypingStatus! != status {
            typingStatuses[user.id] = status
            let fused = FocusMode(typingStatus: typingStatuses[user.id] ?? .clear,
                                  focus: focuses[user.id] ?? self.conversation.networkTypeArray.contains(.phone))
            NotificationCenter.default.post(name: Notification.Conversation.DidChangeFocus,
                                            object: self, userInfo: ["user": user, "status": fused])
        }
    }
    
    public func syncEvents(count: Int, before: ParrotServiceExtension.Event?, handler: @escaping ([ParrotServiceExtension.Event]) -> ()) {
        self.getEvents(eventId: before?.identifier, maxEvents: count) {
            handler($0 as [ParrotServiceExtension.Event])
        }
    }
    
    // Return list of Events ordered newest-first.
    // If eventId is specified, return events preceding this event.
    // This method will make an API request to load historical events if
    // necessary. If the beginning of the conversation is reached, an empty
    // list will be returned.
    public func getEvents(eventId: String? = nil, maxEvents: Int = 50, cb: (([IEvent]) -> Void)? = nil) {
        
        // If eventId is provided, return the events we have that are
        // older, or request older events if eventId corresponds to the
        // oldest event we have.
        var ts = Date()
        if  let eventId = eventId,
            let convEvent = self.eventsDict[eventId] {
            
            if events.first!.id != eventId {
                if let indexOfEvent = self.events.index(where: { $0 == convEvent }) {
                    cb?(Array(self.events[indexOfEvent..<self.events.endIndex]))
                    return
                }
            }
            ts = convEvent.timestamp
        }
        
        let req = ClientGetConversationRequest(conversationSpec: ClientConversationSpec(conversationId: self.id),
                                         includeConversationMetadata: true,
                                         includeEvents: true,
                                         maxEventsPerConversation: Int32(maxEvents),
                                         eventContinuationToken: ClientEventContinuationToken(eventTimestamp: ts.toUTC()),
                                         deprecated8: true)
        self.client.execute(req) { res, _ in
            guard let res = res else { cb?([]); return }
            let convEvents = res.conversationState!.eventArray.map { IEvent.wrapEvent(self.client, event: $0) }
            self.readStates = res.conversationState!.conversation!.readStateArray
            
            for convEvent in convEvents {
                self.eventsDict[convEvent.id] = convEvent
            }
            cb?(convEvents)
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateEvents, object: self)
        }
    }
    
    // Return default DeliveryMedium to use for sending messages.
    // Use the first option, or an option that's marked as the current default.
    private func getDefaultDeliveryMedium() -> ClientDeliveryMedium {
        let mediumOptions = self.conversation.selfConversationState?.deliveryMediumOptionArray
        
        var defaultMedium: ClientDeliveryMedium = ClientDeliveryMedium()
        defaultMedium.mediumType = .babelMedium
        if let r = mediumOptions?[0].deliveryMedium {
            defaultMedium = r
        }
        for mediumOption in mediumOptions! {
            if let m = mediumOption.currentDefault, m {
                defaultMedium = mediumOption.deliveryMedium!; break
            }
        }
        return defaultMedium
    }
    private func eventHeader(_ type: ClientEventType) -> ClientEventRequestHeader {
        return ClientEventRequestHeader(conversationId: self.id,
                                  clientGeneratedId: ClientRequestHeader.uniqueID(),
                                  expectedOtr: self.conversation.otrStatus,
                                  deliveryMedium: self.getDefaultDeliveryMedium(),
                                  eventType: type)
    }
}

// Wrapper around Client that maintains a list of Conversations
public class ConversationList: ParrotServiceExtension.ConversationList {
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    fileprivate unowned let client: Client
    internal var convDict = [String: IConversation]() /* TODO: Should be fileprivate! */
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
        for (key, conv) in self.convDict {
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
        let req = ClientSyncRecentConversationsRequest(endTimestamp: since != nil ? Int64(since!.toUTC()) : nil,
                                                 maxConversations: Int32(count),
                                                 maxEventsPerConversation: Int32(1),
                                                 syncFilterArray: [.inboxSyncFilter, .activeSyncFilter, .invitedSyncFilter])
        self.client.execute(req) { response, err in
            let convStates = response!.conversationStateArray
            if let ts = response?.continuationEndTimestamp {
                //let syncTimestamp = response!.syncTimestamp// use currentServerTime?
                self.syncTimestamp = Date(UTC: ts)//.origin
            }
            
            // Initialize the list of conversations from Client's list of ClientConversationStates.
            var ret = [IConversation]()
            for convState in convStates {
                ret.append(self.addConversation(clientConversation: convState.conversation!, clientEvents: convState.eventArray))
            }
            _ = self.client.userList.addPeople(from: ret)
            
            let r: [String: ParrotServiceExtension.Conversation]? = ret.count > 0
                ? ret.mapKeyValues { return ($0.identifier, $0 as ParrotServiceExtension.Conversation) }
                : nil
            handler(r)
        }
    }
    
    /// Retrieve a particular conversation.
    private func getConversation(id: String, _ maxEvents: Int = 5, handler cb: @escaping (IConversation?, Error?) -> ()) {
        let req = ClientGetConversationRequest(conversationSpec: ClientConversationSpec(conversationId: ClientConversationId(id: id)),
                                         includeConversationMetadata: true,
                                         includeEvents: true,
                                         maxEventsPerConversation: Int32(maxEvents),
                                         deprecated8: true)
        self.client.execute(req) { res, err in
            guard let res = res else { cb(nil, err); return }
            
            // Initialize the list of conversations from Client's list of ClientConversationStates.
            let conv = self.addConversation(clientConversation: res.conversationState!.conversation!,
                                             clientEvents: res.conversationState!.eventArray)
            _ = self.client.userList.addPeople(from: [conv])
            
            cb(conv, nil)
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateList, object: self)
        }
    }
    
    public func begin(with: [Person]) -> ParrotServiceExtension.Conversation? {
        let req = ClientCreateConversationRequest(type: with.count > 1 ? .group : .stickyOneToOne,
                                            clientGeneratedId: ClientRequestHeader.uniqueID(),
                                            inviteeIdArray: with.map { ClientInviteeId(gaiaId: $0.identifier) })
        let resp = try? self.client.execute(req)
        
        guard let c = resp?.conversation else { return nil }
        if (resp?.newConversationCreated ?? false) || (self.convDict[c.id!.id!] == nil) {
            let added = self.addConversation(clientConversation: c)
            if resp?.newConversationCreated ?? false { // only post this if the server says it's a new conv
                NotificationCenter.default.post(name: Notification.Conversation.DidCreate, object: added)
            }
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateList, object: self)
            return added
        } else {
            return self.convDict[c.id!.id!]
        }
    }
    
    public var unreadCount: Int {
        return self.convDict
            .filter { !$0.value.archived && $0.value.unreadCount > 0 }
            .count
    }
    
    @discardableResult
    internal func addConversation(
        clientConversation: ClientConversation,
        clientEvents: [ClientEvent] = []
        ) -> IConversation {
        let convId = clientConversation.id!.id!
        let conv = IConversation(
            client: client,
            conversation: clientConversation,
            events: clientEvents
        )
        convDict[convId] = conv
        return conv
    }
}

// Receive client updates and fan them out to conversation notifications.
extension ConversationList {
    
    // If a person changed, any conversations with that person also have changed.
    @objc func personDidUpdate(_ note: Notification) {
        guard let user = note.object as? User else { return }
        for conv in (self.convDict.values.filter { $0.users.contains(user) }) {
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdate, object: conv)
        }
    }
    
    // Receive a ClientStateUpdate and fan out to Conversations
    @objc public func clientDidUpdateState(_ note: Notification) {
        guard let update = (note.userInfo)?[Client.didUpdateStateKey] as? ClientStateUpdate else {
            log.error("Encountered an error! \(note)"); return
        }
        
        if let note = update.conversationNotification {
            let clientConversation = note.conversation!
            if let conv = convDict[clientConversation.id!.id!] {
                conv.updateConversation(conversation: clientConversation)
            } else {
                self.addConversation(clientConversation: clientConversation)
            }
            NotificationCenter.default.post(name: Notification.Conversation.DidUpdateList, object: self)
            
        } else if let note = update.eventNotification {
            let event = note.event!
            // Be sure to maintain the event sync_timestamp for sync'ing.
            //sync_timestamp = Date(UTC: event.timestamp)
            if let conv = convDict[event.conversationId!.id!] {
                let convEvent = conv.add(event: note.event!)
                conv.handleEvent(event: convEvent)
            } else {
                self.getConversation(id: event.conversationId!.id!) { conv, err in
                    guard err == nil && conv != nil else {
                        log.info("Received ClientEvent for unknown conversation \(event.conversationId!.id!): \(String(describing: err))")
                        return
                    }
                    let convEvent = conv!.add(event: note.event!)
                    conv!.handleEvent(event: convEvent)
                }
            }
            
        } else if let note = update.focusNotification {
            if let conv = self.convDict[note.conversationId!.id!] {
                let user = self.client.userList[User.ID(
                    chatID: note.senderId!.chatId!,
                    gaiaID: note.senderId!.gaiaId!
                )]
                conv.handleFocus(status: note.type! == .focus, forUser: user)
            } else {
                log.info("Received SetFocusNotification for unknown conversation \(note.conversationId!.id!)")
            }
            
        } else if let note = update.typingNotification {
            if let conv = convDict[note.conversationId!.id!] {
                let res = parseTypingStatusMessage(p: note)
                let user = self.client.userList[User.ID(
                    chatID: note.senderId!.chatId!,
                    gaiaID: note.senderId!.gaiaId!
                )]
                conv.handleTypingStatus(status: res.status, forUser: user)
            } else {
                log.info("Received ClientSetTypingNotification for unknown conversation \(note.conversationId!.id!)")
            }
            
        } else if let note = update.notificationLevelNotification {
            log.debug("clientDidUpdateState: notificationLevelNotification => \(note)")
        } else if let note = update.watermarkNotification {
            if let conv = self.convDict[note.conversationId!.id!] {
                let res = parseWatermarkNotification(clientWatermarkNotification: note)
                NotificationCenter.default.post(name: Notification.Conversation.DidReceiveWatermark,
                                                object: conv, userInfo: ["status": res])
            } else {
                log.info("Received WatermarkNotification for unknown conversation \(note.conversationId!.id!)")
            }
            
        } else if let note = update.viewModification {
            log.debug("clientDidUpdateState: viewModification => \(note)")
        } else if let note = update.deleteNotification {
            log.debug("clientDidUpdateState: deleteNotification => \(note)")
        }
    }
}

fileprivate extension FocusMode {
    
    init(typingStatus type: ClientTypingType, focus: Bool) {
        if type == .start {
            self = .typing
        } else if type == .pause {
            self = .enteredText
        } else if focus {
            self = .here
        } else {
            self = .away // DNE
        }
    }
    
    var components: (ClientTypingType, Bool) {
        if self == .typing {
            return (.start, true)
        } else if self == .enteredText {
            return (.pause, true)
        } else if self == .here {
            return (.clear, true)
        } else { // if self == .away
            return (.clear, false)
        }
    }
}
