import Foundation

public extension Notification {
    public struct Service { private init() {}
        public static let DidConnect = NSNotification.Name(rawValue: "Parrot.Service.DidConnect")
        public static let DidDisconnect = NSNotification.Name(rawValue: "Parrot.Service.DidDisconnect")
        public static let DidSynchronize = NSNotification.Name(rawValue: "Parrot.Service.DidSynchronize")
    }
    
    public struct Conversation { private init() {}
        public static let DidCreate = NSNotification.Name(rawValue: "Parrot.Conversation.DidCreate")
        public static let DidDelete = NSNotification.Name(rawValue: "Parrot.Conversation.DidDelete")
        public static let DidChangeArchive = NSNotification.Name(rawValue: "Parrot.Conversation.DidChangeArchive")
        
        public static let DidJoin = NSNotification.Name(rawValue: "Parrot.Conversation.DidJoin")
        public static let DidLeave = NSNotification.Name(rawValue: "Parrot.Conversation.DidLeave")
        
        public static let DidUpdate = NSNotification.Name(rawValue: "Parrot.Conversation.DidUpdate")
        public static let DidChangeMute = NSNotification.Name(rawValue: "Parrot.Conversation.DidChangeMute")
        
        public static let DidChangeFocus = NSNotification.Name(rawValue: "Parrot.Conversation.DidChangeFocus")
        public static let DidChangeTypingStatus = NSNotification.Name(rawValue: "Parrot.Conversation.DidChangeTypingStatus")
        public static let DidReceiveWatermark = NSNotification.Name(rawValue: "Parrot.Conversation.DidReceiveWatermark")
        
        public static let DidReceiveEvent = NSNotification.Name(rawValue: "Parrot.Conversation.DidReceiveEvent")
        public static let DidUpdateEvents = NSNotification.Name(rawValue: "Parrot.Conversation.DidUpdateEvents")
        
        public static let DidUpdateList = NSNotification.Name(rawValue: "Parrot.Conversation.DidUpdateList")
    }
    
    public struct Person { private init() {}
        public static let DidUpdate = NSNotification.Name(rawValue: "Parrot.Person.DidUpdate")
        public static let DidChangePresence = NSNotification.Name(rawValue: "Parrot.Person.DidChangePresence")
    }
}
