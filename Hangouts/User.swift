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
    
    /// A chat user identifier.
    public struct ID: Hashable, Equatable {
        public let chatID: String
        public let gaiaID: String
    }
    
    public let id: User.ID
    public var identifier: String {
        return id.gaiaID
    }
    public let nameComponents: [String]
    public let photoURL: String?
    public let locations: [String]
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
    public convenience init(_ client: Client, entity: Entity, selfUser: User.ID?) {
        
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
        
        // Initialize the user.
        self.init(client, userID: userID,
                  fullName: phoneI18N ?? props.display_name,
                  photoURL: photo, locations: locations, me: isSelf
        )
    }
}

// Collection of User instances.
public class UserList: Directory {
    
    fileprivate var users: [User.ID: User]
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
            //log.warning("UserList returning unknown User for User.ID \(userID)")
            return User(self.client, userID: userID)
        }
    }
    
    // Convenience for the latter method.
    internal func addPeople(from conversations: [IConversation]) -> [Person] {
        return self.addPeople(from: conversations.map { $0.conversation })
    }
    
    internal func addPeople(from conversations: [Conversation]) -> [Person] {
        var ret = [Person]()
        let s = DispatchSemaphore(value: 0)
        
        // Prepare a set of all conversation participant data first to batch the query.
        var required = Set<ConversationParticipantData>()
        conversations.forEach { conv in conv.participant_data.forEach { required.insert($0) } }
        
        // Required step: get the base User objects prepared.
        self.client.opQueue.sync {
            self.client.getEntitiesByID(chat_id_list: required.flatMap { $0.id?.chat_id }) { response in
                let entities = response?.entity_result.flatMap { $0.entity } ?? []
                for entity in entities {
                    guard entity.id != nil else { continue } // if no id, we can't use it!
                    let user = User(self.client, entity: entity, selfUser: (self.me as! User).id)
                    if self.users[user.id] == nil {
                        self.users[user.id] = user
                    }
                    ret.append(user as Person)
                }
                self.cache(presencesFor: entities.map { $0.id! })
                s.signal()
            }
            s.wait()
        }
        return ret
    }
    
    internal static func getSelfInfo(_ client: Client) -> User {
        let res = try! client.execute(GetSelfInfo.self, with: GetSelfInfoRequest())
        let selfUser = User(client, entity: res.self_entity!, selfUser: nil)
        return selfUser
    }
    
    ///
    public func search(by: String, limit: Int) -> [Person] {
        let req = SearchEntitiesRequest(query: by, max_count: UInt64(limit))
        let vals = try? self.client.execute(SearchEntities.self, with: req)
        return vals?.entity.map { User(self.client, entity: $0, selfUser: (self.me as! User).id) } ?? []
    }
    
    ///
    public func list(_ limit: Int) -> [Person] {
        /*
         favorites:    favorites + pinned_favorites
         frequents:    contacts_you_hangout_with
         others:       other_contacts + other_contacts_on_hangouts
         --:           dismissed_contacts
        */
        let req = GetSuggestedEntitiesRequest(max_count: UInt64(limit))
        var vals: GetSuggestedEntitiesResponse? = nil
        do {
            vals = try self.client.execute(GetSuggestedEntities.self, with: req)
        } catch(let error) {
            print("\n\n", error, "\n\n")
        }
        return vals?.entity.map { User(self.client, entity: $0, selfUser: (self.me as! User).id) } ?? []
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
                    user.lastSeen = Date.from(UTC: Double(usec))
                }
                //if ??? {
                    user.reachability = pres.toReachability()
                //}
                if let mood = pres.mood_setting?.mood_message?.mood_content {
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
            self.client.execute(QueryPresence.self, with: req) { req, _ in
                for pres2 in req!.presence_result {
                    guard   let id1 = pres2.user_id?.chat_id, let id2 = pres2.user_id?.gaia_id,
                        let user = self.users[User.ID(chatID: id1, gaiaID: id2)],
                        let pres = pres2.presence
                        else { continue }
                    
                    if let usec = pres.last_seen?.last_seen_timestamp {
                        user.lastSeen = Date.from(UTC: Double(usec))
                    }
                    //if ??? {
                        user.reachability = pres.toReachability()
                    //}
                    if let mood = pres.mood_setting?.mood_message?.mood_content {
                        user.mood = mood.toText()
                    }
                    
                    NotificationCenter.default.post(name: Notification.Person.DidChangePresence, object: user, userInfo: nil)
                }
            }
        }
    }
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
                log.warning("Ignoring unknown chat message segment type: \(segment.type)")
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

