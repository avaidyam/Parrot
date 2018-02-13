import struct Foundation.Date
import struct Foundation.URL
import class Foundation.NSAttributedString

/* TODO: message reactions, pinned/starred, edit. */

///
public enum MessageError: Error {
    
    /// The message's content type is unsupported by the Service.
    case unsupported
}

/// Describes a message content by its uniform type identifier (UTI).
public struct ContentUTI: RawRepresentable {
    public typealias RawValue = String
    public let rawValue: ContentUTI.RawValue
    public init?(rawValue: ContentUTI.RawValue) {
        self.rawValue = rawValue
    }
    
    public static let text = "public.plain-text"
    public static let richText = "public.rtf"
    public static let image = "public.image"
    public static let audio = "public.audio"
    public static let video = "public.movie"
    public static let file = "public.file-url"
    public static let snippet = "com.apple.webarchive"
    //public static let sticker = "com.avaidyam.Parrot.MessageType.sticker"
    //public static let reaction = "com.avaidyam.Parrot.MessageType.reaction"
    public static let location = "public.vlocation"
    //public.vcard
    //public.to-do-item
    //public.calendar-event
}

// TODO: Add a Service-level query for Content support that can be cached.
public enum Content {
    
    /// Service supports plain text in conversations.
	case text(String)
    
    /// Service supports rich text in conversations.
    case richText(NSAttributedString)
    
    /// Service supports sending photos in conversations.
	case image(URL)
    
    /// Service supports sending audio in conversations.
    case audio(URL)
    
    /// Service supports sending videos in conversations.
    case video(URL)
    
    /// Service supports uploading files to conversations.
    case file(URL)
    
    /// Service supports posting text messages above a character limit.
	case snippet(String)
    
    /// Service supports sending stickers in conversations. (Just use Image for now)
    //case sticker(String)
    
    /// Service supports sending reactions to messages.
	//case reaction(Character, String)
    
    /// Service supports sending locations by lat-long coordinates.
    case location(Double, Double)
}

/// An event comprises the `Conversation`'s `eventStream`: it is not to be used
/// directly, unless none of the below sub-protocols better fit.
public protocol Event: ServiceOriginating {
    var identifier: String { get }
    var timestamp: Date { get }
}

/// A message was sent in the conversation by `sender` containing `content`.
public protocol Message: Event {
    var sender: Person { get }
    var content: Content { get }
}

/// A voicemail was left since no one picked up the call.
public protocol Voicemail: Event {
     // TODO
}

/// A voice call occurred between multiple participants.
public protocol VoiceCall: Event {
    // TODO
}

/// A video call occurred between multiple participants.
public protocol VideoCall: Event {
    // TODO
}

/// People (`participants`) have joined or left the conversation.
/// This action may have been taken by `moderator`, if not nil.
public protocol MembershipChanged: Event {
    var participants: [Person] { get }
    var joined: Bool { get } // left, if false
    var moderator: Person? { get }
}

/// The conversation was renamed by `sender` from `oldValue` to `newValue`.
public protocol ConversationRenamed: Event {
    var sender: Person { get }
    var oldValue: String { get }
    var newValue: String { get }
}

public extension Message {
    var text: String? {
        guard case .text(let str) = self.content else { return nil }
        return str
    }
}
