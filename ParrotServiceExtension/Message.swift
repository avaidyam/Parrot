import Foundation

// Convenience...
public typealias AttributedString = NSAttributedString

public struct Media: Codable, Hashable, Equatable {
    public let data: Data
    public let filename: String
    
    public init(data: Data, filename: String) {
        self.data = data
        self.filename = filename
    }
}

public extension Media {
    public var hashValue: Int {
        return self.data.hashValue
    }
    public static func ==(_ lhs: Media, _ rhs: Media) -> Bool {
        return lhs.data == rhs.data
    }
}

public enum Content {
	case text(String) //= "com.avaidyam.Parrot.MessageType.text" // String
    case richText(AttributedString) //= "com.avaidyam.Parrot.MessageType.richText" // AttributedString
	case image(Data, String) //= "com.avaidyam.Parrot.MessageType.image" // Media
	case audio(Data, String) //= "com.avaidyam.Parrot.MessageType.audio" // Media
	case video(Data, String) //= "com.avaidyam.Parrot.MessageType.video" // Media
	case link(String) //= "com.avaidyam.Parrot.MessageType.link" // String
	case snippet(String) //= "com.avaidyam.Parrot.MessageType.snippet" // String
	case summary(String) //= "com.avaidyam.Parrot.MessageType.summary" // ???
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
