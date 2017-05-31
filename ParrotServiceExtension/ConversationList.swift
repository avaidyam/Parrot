import Foundation

public protocol ConversationList: class, ServiceOriginating /*: Collection*/ {
    
    /// A list of all conversations mapped by their unique ID.
    /// This list will only contain a certain set of conversations,
    /// locally cached when requested for it. If no conversations are synced,
    /// such as upon first launch, then this dictionary is empty.
    var conversations: [Conversation.IdentifierType: Conversation] { get }
    
    /// Subscripted direct access support for mapping conversations to their
    /// identifiers. If a conversation isn't loaded, it will be transiently
    /// synchronized and returned, but NOT added to the `conversations` set.
    subscript(_ identifier: Conversation.IdentifierType) -> Conversation? { get }
    
    /// Synchronize all remote <--> local conversations, returning the
    /// set of conversations synchronized upon invocation, if any.
    /// If nil is returned, it can be assumed that there are no more conversations
    /// left to cache. The results of this method append the `conversations`
    /// set and are indexed by conversation ID.
    func syncConversations(count: Int, since: Date?, handler: @escaping ([Conversation.IdentifierType: Conversation]?) -> ())
    
    /// The last timestamp for the conversations synchronized; this can be used
    /// to synchronize more conversations.
    var syncTimestamp: Date? { get }
    
    /// Begin a new conversation with the people provided.
    /// Note that this may be a one-on-one conversation if only one exists.
    func begin(with: [Person]) -> Conversation?
    
    // TODO: These should be invoked within the Conversation object.
    //func mute(conversation: Conversation)
    //func block(conversation: Conversation)
    //func archive(conversation: Conversation)
    //func delete(conversation: Conversation)
}

public enum ConversationListNotification {
    case conversation
    case presence
}

/*
public extension ConversationList {
    public var sortedConversations: [Conversation] {
        return self.conversations.values.sorted { $0.timestamp > $1.timestamp }
    }
}
*/
