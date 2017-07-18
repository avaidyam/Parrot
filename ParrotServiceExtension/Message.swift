import Foundation

// Convenience...
public typealias AttributedString = NSAttributedString

///
public enum MessageError: Error {
    
    /// The message's content type is unsupported by the Service.
    case unsupported
}

// TODO: Add a Service-level query for Content support that can be cached.
public enum Content {
    
    /// Service supports plain text in conversations.
	case text(String) //= "com.avaidyam.Parrot.MessageType.text"
    
    /// Service supports rich text in conversations.
    case richText(AttributedString) //= "com.avaidyam.Parrot.MessageType.richText"
    
    /// Service supports sending photos in conversations.
	case image(Data, String) //= "com.avaidyam.Parrot.MessageType.image"
    
    /// Service supports sending audio in conversations.
    case audio(Data, String) //= "com.avaidyam.Parrot.MessageType.audio"
    
    /// Service supports sending videos in conversations.
    case video(Data, String) //= "com.avaidyam.Parrot.MessageType.video"
    
    /// Service supports uploading files to conversations.
    case file(Data, String) //= "com.avaidyam.Parrot.MessageType.file"
    
    /// Service supports posting text messages above a character limit.
	case snippet(String) //= "com.avaidyam.Parrot.MessageType.snippet"
    
    /// Service supports sending stickers in conversations. (Just use Image for now)
    //case sticker(String) //= "com.avaidyam.Parrot.MessageType.sticker"
    
    /// Service supports sending reactions to messages.
	case reaction(Character, String) //= "com.avaidyam.Parrot.MessageType.reaction"
    
    /// Service supports sending locations by lat-long coordinates.
    case location(Double, Double) //= "com.avaidyam.Parrot.MessageType.location"
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
