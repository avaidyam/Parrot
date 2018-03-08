import Foundation.NSNotification

/// TODO: (NOTE) When mutating an element of a collection (i.e. Conversation, or Person)
///       whose containing collection is batching the mutations, send individual
///       notifications about an element mutation *AND* a single batched notification.

public extension Notification {
    public struct Service { private init() {}
        public static let DidConnect = Notification.Name(rawValue: "Parrot.Service.DidConnect")
        public static let DidDisconnect = Notification.Name(rawValue: "Parrot.Service.DidDisconnect")
        public static let DidSynchronize = Notification.Name(rawValue: "Parrot.Service.DidSynchronize")
    }
    
    public struct Conversation { private init() {}
        public static let DidCreate = Notification.Name(rawValue: "Parrot.Conversation.DidCreate")
        public static let DidDelete = Notification.Name(rawValue: "Parrot.Conversation.DidDelete")
        public static let DidChangeArchive = Notification.Name(rawValue: "Parrot.Conversation.DidChangeArchive")
        
        public static let DidJoin = Notification.Name(rawValue: "Parrot.Conversation.DidJoin")
        public static let DidLeave = Notification.Name(rawValue: "Parrot.Conversation.DidLeave")
        
        public static let DidUpdate = Notification.Name(rawValue: "Parrot.Conversation.DidUpdate")
        public static let DidChangeMute = Notification.Name(rawValue: "Parrot.Conversation.DidChangeMute")
        
        public static let DidChangeFocus = Notification.Name(rawValue: "Parrot.Conversation.DidChangeFocus")
        public static let DidReceiveWatermark = Notification.Name(rawValue: "Parrot.Conversation.DidReceiveWatermark")
        
        public static let DidReceiveEvent = Notification.Name(rawValue: "Parrot.Conversation.DidReceiveEvent")
        public static let DidUpdateEvents = Notification.Name(rawValue: "Parrot.Conversation.DidUpdateEvents")
        
        public static let DidUpdateList = Notification.Name(rawValue: "Parrot.Conversation.DidUpdateList")
    }
    
    public struct Person { private init() {}
        public static let DidUpdate = Notification.Name(rawValue: "Parrot.Person.DidUpdate")
        public static let DidChangePresence = Notification.Name(rawValue: "Parrot.Person.DidChangePresence")
    }
}
