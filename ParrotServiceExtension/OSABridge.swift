import Foundation

/// The OSA bridges PSE into the ObjC runtime/Foundation for scripting bridges.
public enum OSA {
    
    @objc (PSEParrot) @objcMembers
    public class BridgedParrot: NSObject {
        // TODO
        
        @objc public func sendLog(_ string: String) {
            
        }
        
        @objc public func logOut() {
            
        }
    }
    
    @objc(PSEService) @objcMembers
    public class BridgedService: NSObject {//}, Service { // TODO
        @objc public static var identifier: Service.IdentifierType = ""
        @objc public static var name: String = ""
        /*@objc*/ public static var capabilities: Capabilities = Capabilities(rawValue: 0)
        @objc public var connected: Bool = false
        @objc public var directory: BridgedDirectory = BridgedDirectory()
        @objc public var conversations: BridgedConversationList = BridgedConversationList()
        
        @objc public func connect() {
            
        }
        
        @objc public func disconnect() {
            
        }
        
        @objc public func synchronize() {
            
        }
        
        @objc public func setInteractingIfNeeded() {
            
        }
    }
    
    @objc(PSEConversationList) @objcMembers
    public class BridgedConversationList: NSObject {//}, ConversationList { // TODO
        @objc public var serviceIdentifier: Service.IdentifierType = ""
        @objc public var conversations: [Conversation.IdentifierType : BridgedConversation] = [:]
        @objc public var syncTimestamp: Date? = nil
        
        @objc public func begin(with: [BridgedPerson]) -> BridgedConversation? {
            return nil
        }
        
        @objc public func syncConversations(count: Int, since: Date?, handler: @escaping ([Conversation.IdentifierType : BridgedConversation]?) -> ()) {
            handler(nil)
        }
    }
    
    @objc(PSEConversation) @objcMembers
    public class BridgedConversation: NSObject {//}, Conversation { // TODO
        @objc public var serviceIdentifier: Service.IdentifierType = ""
        @objc public var identifier: Conversation.IdentifierType = ""
        @objc public var name: String = ""
        @objc public var participants: [BridgedPerson] = []
        /*@objc*/ public var focus: [Person.IdentifierType : FocusMode] = [:]
        /*@objc*/ public var eventStream: [Event] = []
        @objc public var unreadCount: Int = 0
        @objc public var muted: Bool = false
        @objc public var archived: Bool = false
        
        /*@objc*/ public func focus(mode: FocusMode) {
            
        }
        
        /*@objc*/ public func send(message: Message) throws {
            
        }
        
        @objc public func leave() {
            
        }
        
        /*@objc*/ public func syncEvents(count: Int, before: Event?, handler: @escaping ([Event]) -> ()) {
            handler([])
        }
    }
    
    @objc(PSEDirectory) @objcMembers
    public class BridgedDirectory: NSObject {//}, Directory { // TODO
        @objc public var serviceIdentifier: Service.IdentifierType = ""
        @objc public var me: BridgedPerson = BridgedPerson()
        @objc public var people: [Person.IdentifierType : BridgedPerson] = [:]
        @objc public var invitations: [Person.IdentifierType : BridgedPerson] = [:]
        @objc public var blocked: [Person.IdentifierType : BridgedPerson] = [:]
        
        @objc public func search(by: String, limit: Int) -> [BridgedPerson] {
            return []
        }
        
        @objc public func list(_ limit: Int) -> [BridgedPerson] {
            return []
        }
    }
    
    @objc(PSEPerson) @objcMembers
    public class BridgedPerson: NSObject {//}, Person { // TODO
        @objc public var serviceIdentifier: Service.IdentifierType = ""
        @objc public var identifier: Person.IdentifierType = ""
        @objc public var nameComponents: [String] = []
        @objc public var photoURL: String? = nil
        @objc public var locations: [String] = []
        @objc public var me: Bool = false
        @objc public var blocked: Bool = false
        @objc public var lastSeen: Date = Date()
        /*@objc*/ public var reachability: Reachability = .unavailable
        @objc public var mood: String = ""
        
        @objc public var fullName: String {
            return ""//(self as Person).fullName // TODO
        }
        @objc public var firstName: String {
            return ""//(self as Person).firstName // TODO
        }
    }
    
    @objc(PSEEvent) @objcMembers
    public class BridgedEvent: NSObject {//}, Event { // TODO
        // TODO
    }
    
    @objc(PSENotification) @objcMembers
    public class BridgedNotification: NSObject {//}, Notification { // TODO
        // TODO
    }
    
    // TODO: Event sub-types, i.e. Message
}
