import Foundation
import XPCTransport
import class Mocha.Logger


//
// DEPRECATED
//


public enum AuthenticationInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = [[String: String]]
    public typealias Error = Void
    
    public static func package(_ cookies: [HTTPCookie]) -> Response {
        return cookies.map {
            var d = [String: String]()
            for c in ($0.properties ?? [:]) {
                if let str = c.value as? String {
                    d[c.key.rawValue] = str
                } else if let url = c.value as? URL {
                    d[c.key.rawValue] = url.absoluteString
                } else if let date = c.value as? Date {
                    d[c.key.rawValue] = date.description
                }
            }
            return d
        }
    }
    
    public static func unpackage(_ cookies: [[String: String]]) -> [HTTPCookie] {
        return cookies.compactMap {
            let d = $0.map { (HTTPCookiePropertyKey(rawValue: $0.key), $0.value) }
            return HTTPCookie(properties: Dictionary(uniqueKeysWithValues: d))
        }
    }
}


//
// Parrot
//


public enum SendLogInvocation: RemoteMethod {
    public typealias Request = Logger.LogUnit
    public typealias Response = Void
    public typealias Error = Void
}

public enum LogOutInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = Void
    public typealias Error = Void
}


//
// Service
//


public enum ServiceGetNameInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = String
    public typealias Error = Void
}
public enum ServiceGetCapabilitiesInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = Capabilities.RawValue
    public typealias Error = Void
}
public enum ServiceIsConnectedInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = Bool
    public typealias Error = Void
}
public enum ServiceConnectInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = Void
    public typealias Error = Void
}
public enum ServiceDisconnectInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = Void
    public typealias Error = Void
}
public enum ServiceSynchronizeInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = Void
    public typealias Error = Void
}/*
public enum ServiceGetDirectoryInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = String // TODO
    public typealias Error = Void
}
public enum ServiceGetConversationListInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = String // TODO
    public typealias Error = Void
}*/
public enum ServiceSetInteractingIfNeededInvocation: RemoteMethod {
    public typealias Request = Service.IdentifierType
    public typealias Response = Void
    public typealias Error = Void
}


//
// ConversationList
//


public enum ConversationListGetConversationsInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = [Conversation.IdentifierType]
    public typealias Error = Void
}
public enum ConversationListBeginConversationInvocation: RemoteMethod {
    public typealias Request = [Person.IdentifierType]
    public typealias Response = Conversation.IdentifierType?
    public typealias Error = Void
}
public enum ConversationListSyncInvocation: RemoteMethod {
    public typealias Request = Pair<Int, Date?>
    public typealias Response = [Conversation.IdentifierType]
    public typealias Error = Void
}
public enum ConversationListGetSyncTimestampInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = Date?
    public typealias Error = Void
}


//
// Conversation
//


public enum ConversationGetNameInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = String
    public typealias Error = Void
}
public enum ConversationSetNameInvocation: RemoteMethod {
    public typealias Request = Pair<Conversation.IdentifierType, String>
    public typealias Response = Void
    public typealias Error = Void
}
public enum ConversationGetParticipantsInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = [Person]
    public typealias Error = Void
}
public enum ConversationSetParticipantsInvocation: RemoteMethod {
    public typealias Request = Pair<Conversation.IdentifierType, [Person.IdentifierType]>
    public typealias Response = Void
    public typealias Error = Void
}
public enum ConversationGetMutedInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = Bool
    public typealias Error = Void
}
public enum ConversationSetMutedInvocation: RemoteMethod {
    public typealias Request = Pair<Conversation.IdentifierType, Bool>
    public typealias Response = Void
    public typealias Error = Void
}
public enum ConversationGetArchivedInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = Bool
    public typealias Error = Void
}
public enum ConversationSetArchivedInvocation: RemoteMethod {
    public typealias Request = Pair<Conversation.IdentifierType, Bool>
    public typealias Response = Void
    public typealias Error = Void
}/*
public enum ConversationGetFocusListInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = [Person.IdentifierType: FocusMode]
    public typealias Error = Void
}
public enum ConversationSetFocusInvocation: RemoteMethod {
    public typealias Request = Pair<Conversation.IdentifierType, FocusMode>
    public typealias Response = Void
    public typealias Error = Void
}*/
public enum ConversationGetEventStreamInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = [Event.IdentifierType]
    public typealias Error = Void
}
public enum ConversationGetUnreadCountInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = Int
    public typealias Error = Void
}/*
public enum ConversationSendMessageInvocation: RemoteMethod {
    public typealias Request = Pair<Conversation.IdentifierType, Message>
    public typealias Response = Void
    public typealias Error = Void
}*/
public enum ConversationSyncEventsInvocation: RemoteMethod {
    public typealias Request = Triple<Conversation.IdentifierType, Int, Event.IdentifierType>
    public typealias Response = [Event.IdentifierType]
    public typealias Error = Void
}
public enum ConversationLeaveInvocation: RemoteMethod {
    public typealias Request = Conversation.IdentifierType
    public typealias Response = Void
    public typealias Error = Void
}


//
// Directory
//


public enum DirectoryGetMeInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = Person.IdentifierType
    public typealias Error = Void
}
public enum DirectoryGetPeopleInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = [Person.IdentifierType]
    public typealias Error = Void
}
public enum DirectoryGetInvitationsInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = [Person.IdentifierType]
    public typealias Error = Void
}
public enum DirectoryGetBlockedInvocation: RemoteMethod {
    public typealias Request = Void
    public typealias Response = [Person.IdentifierType]
    public typealias Error = Void
}
public enum DirectorySearchInvocation: RemoteMethod {
    public typealias Request = Pair<String, Int>
    public typealias Response = [Person.IdentifierType]
    public typealias Error = Void
}
public enum DirectoryListInvocation: RemoteMethod {
    public typealias Request = Int
    public typealias Response = [Person.IdentifierType]
    public typealias Error = Void
}
public enum DirectoryFindInvocation: RemoteMethod {
    public typealias Request = Pair<Person.IdentifierType, Int>
    public typealias Response = [Person.IdentifierType]
    public typealias Error = Void
}


//
// Person
//


public enum PersonGetNameComponentsInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = [String]
    public typealias Error = Void
}
public enum PersonGetPhotoURLInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = String?
    public typealias Error = Void
}
public enum PersonGetLocationsInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = [String]
    public typealias Error = Void
}
public enum PersonIsMeInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = Bool
    public typealias Error = Void
}
public enum PersonGetBlockedInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = Bool
    public typealias Error = Void
}
public enum PersonSetBlockedInvocation: RemoteMethod {
    public typealias Request = Pair<Person.IdentifierType, Bool>
    public typealias Response = Void
    public typealias Error = Void
}
public enum PersonGetLastSeenInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = Date
    public typealias Error = Void
}/*
public enum PersonGetReachabilityInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = Reachability
    public typealias Error = Void
}*/
public enum PersonGetMoodInvocation: RemoteMethod {
    public typealias Request = Person.IdentifierType
    public typealias Response = String
    public typealias Error = Void
}


//
// Event
//

// TODO

//
// Notification
//

// TODO
