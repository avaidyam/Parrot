import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Users")

/// A chat user.
public class User: Person, Hashable, Equatable {
    private unowned let client: Client
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    public static let DEFAULT_NAME = "Unknown"
    public static let GVoiceLocation = "OffNetworkPhone"
    
    /// A chat user identifier.
    public struct ID: Hashable, Equatable {
        public let chatID: String
        public let gaiaID: String
    }
    
    public let id: User.ID
    public var identifier: String {
        return id.gaiaID
    }
    public internal(set) var nameComponents: [String] = []
    public internal(set) var photoURL: String? = nil
    public internal(set) var locations: [String] = []
    public private(set) var me: Bool
    public var blocked: Bool = false
    
    public internal(set) var lastSeen: Date = Date(timeIntervalSince1970: 0)
    public internal(set) var reachability: Reachability = .unavailable
    public internal(set) var mood: String = ""
    
    // Initialize a User directly.
    // Handles full_name or first_name being nil by creating an approximate
    // first_name from the full_name, or setting both to DEFAULT_NAME.
    //
    // Ignores firstName value.
    public init(_ client: Client, userID: User.ID, fullName: String? = nil, photoURL: String? = nil,
                locations: [String] = [], me: Bool = false) {
        self.client = client
        self.id = userID
        self.nameComponents = (fullName ?? User.DEFAULT_NAME).characters.split{$0 == " "}.map(String.init)
        self.photoURL = photoURL
        self.locations = locations
        self.me = me
    }
    
    // Parse and initialize a User from an Entity.
    // Note: If selfUser is nil, assume this is the self user.
    internal convenience init(_ client: Client, entity: Entity, selfUser: User.ID?) {
        
        // Parse User ID and self status.
        let userID = User.ID(chatID: entity.id!.chat_id!,
                             gaiaID: entity.id!.gaia_id!)
        let isSelf = (selfUser != nil ? (selfUser == userID) : true)
        
        // If the entity has no provided properties, bail here.
        guard let props = entity.properties else {
            self.init(client, userID: userID, fullName: "", photoURL: "", locations: [], me: isSelf)
            return
        }
        
        // Parse possible phone numbers. Just use I18N and reformat it if needed.
        let phoneI18N: String? = props.phones.first?.phone_number?.i18n_data?.international_number
        
        // Parse the user photo.
        let photo: String? = props.photo_url != nil ? "https:" + props.photo_url! : nil
        
        // Parse possible locations.
        var locations: [String] = []
        locations += props.email
        locations += props.phone
        if let c = props.canonical_email {
            locations.append(c)
        }
        if let p = phoneI18N {
            locations.append(p)
        }
        
        var visibleName = props.display_name // default
        if let type = entity.entity_type, type == .OffNetworkPhone {
            locations.append(User.GVoiceLocation) // tag the contact
            visibleName = props.display_name != nil ? props.display_name : phoneI18N
        }
        
        // Initialize the user.
        self.init(client, userID: userID,
                  fullName: visibleName,
                  photoURL: photo, locations: locations, me: isSelf
        )
    }
    
    // Initialize from a PeopleAPI.Person
    // Note: If selfUser is nil, assume this is the self user.
    internal convenience init(_ client: Client, person: PeopleAPIData.Person, selfUser: User.ID?) {
        
        // Parse User ID and self status.
        let userID = User.ID(chatID: person.personId!,
                             gaiaID: person.personId!)
        let isSelf = (selfUser != nil ? (selfUser == userID) : true)
        var fullName: String? = nil, photoURL: String? = nil, locations: [String] = []
        
        if let names = person.name { //CONTACT > PROFILE?
            if let name = (names.filter { $0.metadata?.containerType == "CONTACT" }.flatMap { $0.displayName }).first {
                fullName = name
            } else if let name = (names.filter { $0.metadata?.containerType == "PROFILE" }.flatMap { $0.displayName }).first {
                fullName = name
            }
        }
        if let photos = person.photo {
            let values = photos.filter { !($0.isMonogram ?? false) }.flatMap { $0.url }
            if let photo = values.first {
                photoURL = photo
            }
        }
        if let phones = person.phone {
            locations += phones.flatMap { $0.value }
        }
        if let emails = person.email {
            locations += emails.flatMap { $0.value }
        }
        if let type = person.extendedData?.hangoutsExtendedData?.userType, type != "GAIA" {
            locations.append(User.GVoiceLocation) // tag the contact
        }
        
        // Initialize the user.
        self.init(client, userID: userID,
                  fullName: fullName,
                  photoURL: photoURL, locations: locations, me: isSelf
        )
    }
}

// Collection of User instances.
public class UserList: Directory {
    
    internal var users: [User.ID: User]
    private unowned let client: Client
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    public private(set) var me: Person
    public var people: [String: Person] {
        var dict = [String: Person]()
        for (key, value) in self.users {
            dict[key.gaiaID] = value
        }
        return dict
    }
    public var invitations: [String: Person] {
        return [:]
    }
    public var blocked: [String: Person] {
        return [:]
    }
    
    // Initialize the list of Users.
    public init(client: Client, users: [User] = []) {
        self.client = client
        
        var usersDict = Dictionary<User.ID, User>()
        users.forEach { usersDict[$0.id] = $0 }
        self.users = usersDict
        
        let me = UserList.getSelfInfo(self.client)
        self.users[me.id] = me
        self.me = me
        
        hangoutsCenter.addObserver(self, selector: #selector(UserList._updatedState(_:)),
                                   name: Client.didUpdateStateNotification, object: client)
    }
    
    deinit {
        hangoutsCenter.removeObserver(self)
    }
    
    public subscript(_ identifier: String) -> Person {
        return self[User.ID(chatID: identifier, gaiaID: identifier)]
    }
    
    // Return a User by their User.ID.
    // Logs and returns a placeholder User if not found.
    internal subscript(userID: User.ID) -> User {
        if let user = self.users[userID] {
            return user
        } else {
            //log.info("UserList returning unknown User for User.ID \(userID)")
            return User(self.client, userID: userID)
        }
    }
    
    // Convenience for the latter method.
    internal func addPeople(from conversations: [IConversation]) -> [Person] {
        return self.addPeople(from: conversations.map { $0.conversation })
    }
    
    internal func addPeople(from conversations: [Conversation]) -> [Person] {
        // Prepare a set of all conversation participant data first to batch the query.
        var required = Set<ConversationParticipantData>()
        conversations.forEach { conv in conv.participant_data.forEach { required.insert($0) } }
        
        // Required step: get the base User objects prepared.
        let specs = required.flatMap { EntityLookupSpec(gaia_id: $0.id!.gaia_id!) }
        let req = GetEntityByIdRequest(batch_lookup_spec: specs)
        let response = try? self.client.execute(req)
        
        let entities = response?.entity_result.flatMap { $0.entity } ?? []
        self.cache(presencesFor: entities.filter { $0.entity_type != .OffNetworkPhone }.map { $0.id! })
        self.cache(namesFor: entities.flatMap {
            $0.properties?.phones.first?.phone_number?.i18n_data?.international_number
        })
        return entities.filter { $0.id != nil }.map { entity in
            let user = User(self.client, entity: entity, selfUser: (self.me as! User).id)
            if self.users[user.id] == nil {
                self.users[user.id] = user
            }
            return user as Person
        }
    }
    
    internal static func getSelfInfo(_ client: Client) -> User {
        let res = try! client.execute(GetSelfInfoRequest())
        let selfUser = User(client, entity: res.self_entity!, selfUser: nil)
        return selfUser
    }
    
    ///
    public func search(by: String, limit: Int) -> [Person] {
        let req = SearchEntitiesRequest(query: by, max_count: UInt64(limit))
        let vals = try? self.client.execute(req)
        return vals?.entity.map {
            if let id = $0.id?.gaia_id, let u = self.users[User.ID(chatID: id, gaiaID: id)] {
                return u
            } else {
                let u = User(self.client, entity: $0, selfUser: (self.me as! User).id)
                self.users[u.id] = u
                return u
            }
        } ?? []
    }
    
    /*
     favorites:    favorites + pinned_favorites
     frequents:    contacts_you_hangout_with
     others:       other_contacts + other_contacts_on_hangouts
     --:           dismissed_contacts
     */
    ///
    public func list(_ limit: Int) -> [Person] { // rename as "suggestions", throws?
        
        // Get the response or the error.
        let s = DispatchSemaphore(value: 0)
        var vals: (PeopleAPIData.SuggestionsResponse?, Error?) = (nil, nil)
        PeopleAPI.suggestions(on: self.client.channel!) {
            vals = ($0, $1); s.signal()
        }
        s.wait()
        
        //
        guard let res = vals.0, let people = res.people else { return [] }
        return people.filter { $0.extendedData?.hangoutsExtendedData?.userInterest ?? false }
            .flatMap {
                if let id = $0.personId, let u = self.users[User.ID(chatID: id, gaiaID: id)] {
                    return u
                } else {
                    let u = User(self.client, person: $0, selfUser: (self.me as! User).id)
                    self.users[u.id] = u
                    return u
                }
            }
    }
    
    /// Note: all notification objects are expected to be deltas.
    @objc internal func _updatedState(_ notification: Notification) {
        guard   let userInfo = notification.userInfo,
            let update = userInfo[Client.didUpdateStateKey] as? StateUpdate
            else { return }
        
        // Cache all un-cached people from conversation deltas.
        if  let conversation = update.conversation {
            _ = self.addPeople(from: [conversation])
        }
        
        if let note = update.self_presence_notification {
            let user = (self.me as! User)
            if let state = note.client_presence_state?.state {
                user.lastSeen = state == .DesktopActive ? Date() : Date(timeIntervalSince1970: 0)
            }
            if let mood = note.mood_state?.mood_setting?.mood_message?.mood_content {
                user.mood = mood.toText()
            }
            user.reachability = .desktop
            
            NotificationCenter.default.post(name: Notification.Person.DidChangePresence, object: user, userInfo: nil)
        } else if let note = update.presence_notification {
            for presence in note.presence {
                guard   let id1 = presence.user_id?.chat_id, let id2 = presence.user_id?.gaia_id,
                    let user = self.users[User.ID(chatID: id1, gaiaID: id2)],
                    let pres = presence.presence
                    else { continue }
                
                if let usec = pres.last_seen?.last_seen_timestamp {
                    user.lastSeen = Date(UTC: usec)
                }
                //if ??? {
                    user.reachability = pres.toReachability()
                //}
                if let mood = pres.mood_message.first?.mood_content {
                    user.mood = mood.toText()
                }
                
                NotificationCenter.default.post(name: Notification.Person.DidChangePresence, object: user, userInfo: nil)
            }
        }
    }
    
    // Optional: Once we have all the entities, get their presence data.
    private func cache(presencesFor queries: [ParticipantId]) {
        log.debug("Note: batch queryPresence does not work yet!")
        for q in queries {
            let req = QueryPresenceRequest(participant_id: [q],
                                           field_mask: [.Reachable, .Available, .Mood, .Location, .InCall, .Device, .LastSeen])
            self.client.execute(req) { req, err in
                for pres2 in req!.presence_result {
                    guard   let id1 = pres2.user_id?.chat_id, let id2 = pres2.user_id?.gaia_id,
                        let user = self.users[User.ID(chatID: id1, gaiaID: id2)],
                        let pres = pres2.presence
                        else { continue }
                    
                    if let usec = pres.last_seen?.last_seen_timestamp {
                        user.lastSeen = Date(UTC: usec)
                    }
                    //if ??? {
                        user.reachability = pres.toReachability()
                    //}
                    
                    if let mood = pres.mood_message.first?.mood_content {
                        user.mood = mood.toText()
                    }
                    
                    NotificationCenter.default.post(name: Notification.Person.DidChangePresence, object: user, userInfo: nil)
                }
            }
        }
    }
    
    // Now for all GVoice ID's, grab their real names:
    private func cache(namesFor phones: [String]) {
        PeopleAPI.lookup(on: self.client.channel!, phones: phones) { res, err in
            guard let results = res, let matches = results.matches, let people = results.people else {
                log.debug("Encountered a GVoice lookup error: \(String(describing: err))"); return
            }

            // Locate the primary OffNetworkPhone User for each match.
            for match in matches {
                guard var ids = match.personId, ids.count >= 2 else { continue }
                guard let primary = ids
                    .flatMap({ self.users[User.ID(chatID: $0, gaiaID: $0)] })
                    .filter({ $0.locations.contains(User.GVoiceLocation) })
                    .first
                else { continue }
                ids.remove(primary.id.gaiaID)
                
                // Now merge the information from the other contact(s).
                for other_ in ids {
                    guard let other = people[other_] else { continue }
                    
                    // Confirm that this is either a Contact or a GAIA type.
                    // Contact types do not have "extendedData", and GAIA types display their type as such.
                    guard let u = other.extendedData?.hangoutsExtendedData?.userType, u == "GAIA" else { continue }
                    
                    if let names = other.name { //(PROFILE vs CONTACT?)
                        let values = names.filter { $0.metadata?.containerType == "CONTACT" }.flatMap { $0.displayName }
                        if let name = values.first {
                            primary.nameComponents = name.components(separatedBy: " ")
                        }
                    }
                    
                    if let photos = other.photo {
                        let values = photos.filter { !($0.isMonogram ?? false) }.flatMap { $0.url }
                        if let photo = values.first {
                            primary.photoURL = photo
                        }
                    }
                    
                    if let phones = other.phone {
                        primary.locations += phones.flatMap { $0.value }
                    }
                    
                    if let emails = other.email {
                        primary.locations += emails.flatMap { $0.value }
                    }
                }
                
                // Remove duplicate locations and signal the update.
                primary.locations = Array(Set(primary.locations))
                NotificationCenter.default.post(name: Notification.Person.DidUpdate, object: primary, userInfo: nil)
            }
        }
    }
    
    // public func suggestions() { ... }
    // public func list() { ... }
    // public func lookup() { ... }
    // public func autocomplete() { ... }
}


// EXTENSIONS:


/// User.ID: Hashable
public extension User.ID {
    public var hashValue: Int {
        return chatID.hashValue &+ gaiaID.hashValue
    }
    public static func ==(lhs: User.ID, rhs: User.ID) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/// User: Hashable
public extension User {
    public var hashValue: Int {
        return self.id.hashValue
    }
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

fileprivate extension MoodContent {
    func toText() -> String {
        var lines = ""
        for segment in self.segment {
            if segment.type == nil { continue }
            switch (segment.type) {
            case SegmentType.Text, SegmentType.Link:
                lines += segment.text!
            case SegmentType.LineBreak:
                lines += "\n"
            default:
                log.info("Ignoring unknown chat message segment type: \(segment.type)")
            }
        }
        return lines
    }
}

// TODO: doesn't account for available vs reachable
// Note: available=true shows a green dot, reachable=true does not...?
fileprivate extension Presence {
    func toReachability() -> Reachability {
        let available = self.available ?? false
        let reachable = self.reachable ?? false
        let mobile = self.device_status?.mobile ?? false
        let desktop = self.device_status?.desktop ?? false
        let tablet = self.device_status?.tablet ?? false
        
        if mobile {
            return .phone
        } else if tablet {
            return .tablet
        } else if desktop {
            return .desktop
        } else if available || reachable {
            return .desktop
        }
        return .unavailable
    }
}

/*
 GetEntityByIdResult is extremely confusing: it seems to return two similar but distinct result sets, only one of which will ever contain PARTICIPANT_TYPE_GOOGLE_VOICE entities.
 
 the .entity result set appears to only return PARTICIPANT_TYPE_GAIA entities, even if lookup is by phone number (e.g. if I'm in your Google Contacts and you lookup my phone number, it will return the gaia ID corresponding to my gmail address)
 the .entity_results field will return PARTICIPANT_TYPE_GOOGLE_VOICE entities when lookup is by .phone, with create_offnetwork_gaia=True
 both the .entity and .entity_results field will return blank entities if you lookup using a
 non-GMail address address, even if create_offnetwork_gaia=True
 
 the entity results contain all the data on a particular contact that exists in the user's Google Contacts — the official Hangouts apps definitely use these to show contacts, and they give a slightly different view than apps that use the native Google Contacts API.
 the entity_results contain whatever gaia ID is needed to create a new contract (whether by Google Voice or by "normal" chat) … although they still don't return anything for non-Google email addresses, so there must be yet another invite mechanism used in that case (the off-network invite request)
 
 let req = GetEntityByIdRequest(batch_lookup_spec: [EntityLookupSpec(phone: "+1XXXXXXXXXX", create_offnetwork_gaia: true)])
 self.client.execute(req) { a, b in print(a?.entity_result[0].entity) }
 */
