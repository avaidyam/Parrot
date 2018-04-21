import Foundation
import XPCTransport

public protocol RemoteExtensionComponent {
    var remoteIdentity: UUID { get }
    var remoteOrigin: Any? { get set }
    init()
}

extension RemoteExtensionComponent {
    public init(remoteOrigin: Any?) {
        self.init()
        self.remoteOrigin = remoteOrigin
    }
}

//
//
//

public final class RemoteConversationList: ConversationList, RemoteExtensionComponent {
    
    public var remoteOrigin: Any? = nil
    public let remoteIdentity = UUID()
    
    public init() {
        
    }
    
    public var serviceIdentifier: Service.IdentifierType {
        return ""
    }
    
    public func begin(with arg0: [Person]) -> Conversation? {
        guard let connection = self.remoteOrigin as? XPCConnection else { fatalError() }
        let id = try! connection.sync(ConversationListBeginConversationInvocation.self, with: arg0.map { $0.identifier })
        return nil// RemoteConversation()
    }
    
    public var conversations: [Conversation.IdentifierType : Conversation] {
        return [:]
    }
    
    public func syncConversations(count: Int, since: Date?, handler: @escaping ([Conversation.IdentifierType : Conversation]?) -> ()) {
        
    }
    
    public var syncTimestamp: Date? {
        return nil
    }
}
