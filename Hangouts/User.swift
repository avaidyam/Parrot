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
    // Handles fullName or firstName being nil by creating an approximate
    // firstName from the fullName, or setting both to DEFAULT_NAME.
    //
    // Ignores firstName value.
    public init(_ client: Client, userID: User.ID, fullName: String? = nil, photoURL: String? = nil,
                locations: [String] = [], me: Bool = false) {
        self.client = client
        self.id = userID
        self.nameComponents = (fullName ?? User.DEFAULT_NAME).split{$0 == " "}.map(String.init)
        self.photoURL = photoURL
        self.locations = locations
        self.me = me
    }
    
    // Parse and initialize a User from an Entity.
    // Note: If selfUser is nil, assume this is the self user.
    internal convenience init(_ client: Client, entity: ClientEntity, selfUser: User.ID?) {
        
        // Parse User ID and self status.
        let userID = User.ID(chatID: entity.id!.chatId!,
                             gaiaID: entity.id!.gaiaId!)
        let isSelf = (selfUser != nil ? (selfUser == userID) : true)
        
        // If the entity has no provided properties, bail here.
        guard let props = entity.properties else {
            self.init(client, userID: userID, fullName: "", photoURL: "", locations: [], me: isSelf)
            return
        }
        
        // Parse possible phone numbers. Just use I18N and reformat it if needed.
        let phoneI18N: String? = props.phoneNumberArray.first?.phoneNumber?.i18NData?.internationalNumber
        
        // Parse the user photo.
        let photo: String? = props.photoURL != nil ? "https:" + props.photoURL! : nil
        
        // Parse possible locations.
        var locations: [String] = []
        locations += props.emailArray
        locations += props.phoneArray
        if let c = props.canonicalEmail {
            locations.append(c)
        }
        if let p = phoneI18N {
            locations.append(p)
        }
        
        var visibleName = props.displayName // default
        if let type = entity.entityType, type == .offNetworkPhone {
            locations.append(User.GVoiceLocation) // tag the contact
            visibleName = props.displayName != nil ? props.displayName : phoneI18N
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
            if let name = (names.filter { $0.metadata?.containerType == "CONTACT" }.compactMap { $0.displayName }).first {
                fullName = name
            } else if let name = (names.filter { $0.metadata?.containerType == "PROFILE" }.compactMap { $0.displayName }).first {
                fullName = name
            }
        }
        if let photos = person.photo {
            let values = photos.filter { !($0.isMonogram ?? false) }.compactMap { $0.url }
            if let photo = values.first {
                photoURL = photo
            }
        }
        if let phones = person.phone {
            locations += phones.compactMap { $0.value }
        }
        if let emails = person.email {
            locations += emails.compactMap { $0.value }
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
    
    internal func addPeople(from conversations: [ClientConversation]) -> [Person] {
        // Prepare a set of all conversation participant data first to batch the query.
        var required = Set<ClientConversationParticipantData>()
        conversations.forEach { conv in conv.participantDataArray.forEach { required.insert($0) } }
        
        // Required step: get the base User objects prepared.
        let specs = required.compactMap { ClientEntityLookupSpec(gaiaId: $0.id!.gaiaId!) }
        let req = ClientGetEntityByIdRequest(batchLookupSpecArray: specs)
        let response = try? self.client.execute(req)
        
        let entities = response?.entityResultArray.flatMap { $0.entityArray } ?? []
        self.cache(presencesFor: entities.filter { $0.entityType != .offNetworkPhone }.map { $0.id! })
        self.cache(namesFor: entities.compactMap {
            $0.properties?.phoneNumberArray.first?.phoneNumber?.i18NData?.internationalNumber
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
        let res = try! client.execute(ClientGetSelfInfoRequest())
        let selfUser = User(client, entity: res.selfEntity!, selfUser: nil)
        return selfUser
    }
    
    ///
    public func search(by: String, limit: Int) -> [Person] {
        let req = ClientSearchEntitiesRequest(query: by, maxCount: Int32(limit))
        let vals = try? self.client.execute(req)
        return vals?.entityArray.map {
            if let id = $0.id?.gaiaId, let u = self.users[User.ID(chatID: id, gaiaID: id)] {
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
            .compactMap {
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
            let update = userInfo[Client.didUpdateStateKey] as? ClientStateUpdate
            else { return }
        
        // Cache all un-cached people from conversation deltas.
        if  let conversation = update.clientConversation {
            _ = self.addPeople(from: [conversation])
        }
        
        if let note = update.selfPresenceNotification {
            let user = (self.me as! User)
            /*
            if let state = note.richPresenceState?.statusMessage {
                user.lastSeen = state == .desktopActive ? Date() : Date(timeIntervalSince1970: 0)
            }
            if let mood = note.moodState?.moodSetting?.moodMessage?.moodContent {
                user.mood = mood.toText()
            }
            */
            user.reachability = .desktop
            
            NotificationCenter.default.post(name: Notification.Person.DidChangePresence, object: user, userInfo: nil)
        } else if let note = update.presenceNotification {
            for presence in note.presenceArray {
                guard   let id1 = presence.userId?.chatId, let id2 = presence.userId?.gaiaId,
                    let user = self.users[User.ID(chatID: id1, gaiaID: id2)],
                    let pres = presence.presence
                    else { continue }
                
                if let usec = pres.lastSeen?.lastSeenTimestampUsec {
                    user.lastSeen = Date(UTC: usec)
                }
                //if ??? {
                    user.reachability = pres.toReachability()
                //}
                /*if let mood = pres.status.first?.moodContent {
                    user.mood = mood.toText()
                }*/
                
                NotificationCenter.default.post(name: Notification.Person.DidChangePresence, object: user, userInfo: nil)
            }
        }
    }
    
    // Optional: Once we have all the entities, get their presence data.
    private func cache(presencesFor queries: [ClientParticipantId]) {
        log.debug("Note: batch queryPresence does not work yet!")
        for q in queries {
            let req = ClientQueryPresenceRequest(participantIdArray: [q],
                                           fieldMaskArray: [.reachability, .availability, .mood, .location, .inCall, .deviceStatus, .lastSeen])
            self.client.execute(req) { req, err in
                for pres2 in req!.presenceResultArray {
                    guard   let id1 = pres2.userId?.chatId, let id2 = pres2.userId?.gaiaId,
                        let user = self.users[User.ID(chatID: id1, gaiaID: id2)],
                        let pres = pres2.presence
                        else { continue }
                    
                    if let usec = pres.lastSeen?.lastSeenTimestampUsec {
                        user.lastSeen = Date(UTC: usec)
                    }
                    //if ??? {
                        user.reachability = pres.toReachability()
                    //}
                    
                    /*if let mood = pres.moodMessage.first?.moodContent {
                        user.mood = mood.toText()
                    }*/
                    
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
                    .compactMap({ self.users[User.ID(chatID: $0, gaiaID: $0)] })
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
                        let values = names.filter { $0.metadata?.containerType == "CONTACT" }.compactMap { $0.displayName }
                        if let name = values.first {
                            primary.nameComponents = name.components(separatedBy: " ")
                        }
                    }
                    
                    if let photos = other.photo {
                        let values = photos.filter { !($0.isMonogram ?? false) }.compactMap { $0.url }
                        if let photo = values.first {
                            primary.photoURL = photo
                        }
                    }
                    
                    if let phones = other.phone {
                        primary.locations += phones.compactMap { $0.value }
                    }
                    
                    if let emails = other.email {
                        primary.locations += emails.compactMap { $0.value }
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

fileprivate extension ClientMessageContent {
    func toText() -> String {
        var lines = ""
        for segment in self.segmentArray {
            //if segment.type == nil { continue }
            switch (segment.type) {
            case SocialSegmentType_SegmentTypeEnum.text, SocialSegmentType_SegmentTypeEnum.link:
                lines += segment.text!
            case SocialSegmentType_SegmentTypeEnum.lineBreak:
                lines += "\n"
            default:
                log.info("Ignoring unknown chat message segment type: \(String(describing: segment.type))")
            }
        }
        return lines
    }
}

// TODO: doesn't account for available vs reachable
// Note: available=true shows a green dot, reachable=true does not...?
fileprivate extension ClientPresence {
    func toReachability() -> Reachability {
        let available = self.available ?? false
        let reachable = self.reachable ?? false
        let mobile = self.deviceStatus?.mobile ?? false
        let desktop = self.deviceStatus?.desktop ?? false
        let tablet = self.deviceStatus?.tablet ?? false
        
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
