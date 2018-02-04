import struct Foundation.Date
import struct Foundation.URL
import class Foundation.NSAttributedString

// Convenience...
public typealias AttributedString = NSAttributedString

///
public enum MessageError: Error {
    
    /// The message's content type is unsupported by the Service.
    case unsupported
}

// TODO: Add a Service-level query for Content support that can be cached.
public enum Content {
    
    
    public struct Types: RawRepresentable {
        public typealias RawValue = String
        
        public let rawValue: String
        
        public init?(rawValue: String) {
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
    
    /// Service supports plain text in conversations.
	case text(String)
    
    /// Service supports rich text in conversations.
    case richText(AttributedString)
    
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

// TODO: generify to Event, with EventType -- part of eventStream.
public protocol Message: ServiceOriginating {
    var identifier: String { get }
    var sender: Person? { get } // if nil, global event
    var timestamp: Date { get }
    var content: Content { get }
}

public extension Message {
    var text: String {
        guard case .text(let str) = self.content else { return "" }
        return str
    }
}
