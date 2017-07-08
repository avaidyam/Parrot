import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Event")

/* TODO: Refactor ChatMessageSegment to match hangups and Protobuf docs. */
/* TODO: Include Markdown, HTML, and URL formatting parsers. */

// An event which becomes part of the permanent record of a conversation.
// Acts as a base class for the events defined below.
public class IEvent: ServiceOriginating, Hashable, Equatable {
    public let event: Event
	internal unowned let client: Client
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
	
    public init(_ client: Client, event: Event) {
        self.client = client
        self.event = event
    }
	
	// A timestamp of when the event occurred.
    public lazy var timestamp: Date = {
		return Date.from(UTC: Double(self.event.timestamp ?? 0))
    }()
	
	// A User.ID indicating who created the event.
    public lazy var userID: User.ID = {
        return User.ID(
            chatID: self.event.sender_id!.chat_id!,
            gaiaID: self.event.sender_id!.gaia_id!
        )
    }()
	
	// The ID of the conversation the event belongs to.
    public lazy var conversation_id: String = {
        return (self.event.conversation_id!.id! as String)
    }()
	
	// The ID of the Event.
    public lazy var id: IConversation.EventID = {
        return self.event.event_id! as IConversation.EventID
    }()
	
	// Event: Hashable
	public var hashValue: Int {
		return self.event.hashValue
	}
}

// Event: Equatable
public func ==(lhs: IEvent, rhs: IEvent) -> Bool {
    return lhs.event == rhs.event
}

// An event containing a chat message.
public class IChatMessageEvent: IEvent, Message {
    
    public var contentType: ContentType {
        return .text
    }
    
    public var identifier: String {
        return self.event.event_id ?? ""
    }
	
	// A textual representation of the message.
    public lazy var text: String = {
        var lines = [""]
        for segment in self.segments {
            switch (segment.type) {
            case SegmentType.Text, SegmentType.Link:
                let replacement = lines.last! + segment.text
                lines.removeLast()
                lines.append(replacement)
            case SegmentType.LineBreak:
                lines.append("")
            default:
                log.warning("Ignoring unknown chat message segment type: \(segment.type)")
            }
        }
		
        lines += self.attachments
		return lines.filter { $0 != "" }.joined(separator: "\n")
    }()
	
	// List of ChatMessageSegments in the message.
    public lazy var segments: [IChatMessageSegment] = {
        if let list = self.event.chat_message!.message_content?.segment {
            return list.map { IChatMessageSegment(segment: $0) }
        }
		return []
    }()
	
	// Attachments in the message.
    public var attachments: [String] {
		let raws = self.event.chat_message?.message_content?.attachment ?? [Attachment]()
		var attachments = [String]()
		
		for attachment in raws {
			if attachment.embed_item!.type.contains(.PlusPhoto) { // PLUS_PHOTO
				if let data = attachment.embed_item?.plus_photo?.url {
                    attachments.append(data)
				}
			} else if attachment.embed_item!.type.contains(.VoicePhoto) { // VOICE_PHOTO
                if let data = attachment.embed_item?.voice_photo?.url {
                    attachments.append(data)
                }
			} else if attachment.embed_item!.type == [.Place, .PlaceV2, .Thing] { // FIXME this is bad swift
				// Google Maps URL that's already in the text.
			} else {
				//log.info("Ignoring unknown chat message attachment: \(attachment)")
			}
		}
		return attachments
    }
	
	public var sender: Person? {
		let orig = User(self.client, userID: self.userID)
		return self.client.directory.people[self.userID.gaiaID] ?? orig
	}
}

// An event that renames a conversation.
public class IRenameEvent : IEvent {
	
	// The conversation's new name, or "" if the name was cleared.
    public var newName: String {
        return self.event.conversation_rename!.new_name!
    }
	
	// The conversation's old name, or "" if no previous name.
    public var oldName: String {
        return self.event.conversation_rename!.old_name!
    }
}

// An event that adds or removes a conversation participant.
public class IMembershipChangeEvent : IEvent {
	
	// The membership change type (join, leave).
    public var type: MembershipChangeType {
        return self.event.membership_change!.type!
    }
	
	// Return the User.IDs involved in the membership change.
	// Multiple users may be added to a conversation at the same time.
    public var participantIDs: [User.ID] {
		return self.event.membership_change!.participant_ids.map {
			User.ID(chatID: $0.chat_id! , gaiaID: $0.gaia_id!)
		}
    }
}

// An event in a Hangouts voice/video call.
public class IHangoutEvent : IEvent {
	
	// The Hangouts event (start, end, join, leave, etc).
	public var type: HangoutEventType {
		return self.event.hangout_event!.event_type!
	}
}

//
// ChatMessageSegment
//

public class IChatMessageSegment {
	
	// Primary: type and text (always applicable).
	public let type: SegmentType
	public let text: String
	
	// Secondary: text and link attributes (optional).
	public let bold: Bool
	public let italic: Bool
	public let strikethrough: Bool
	public let underline: Bool
	public let linkTarget: String?
	
	// A segment of a chat message.
	// Create a new chat message segment.
	public init(text: String, segmentType: SegmentType? = nil,
		bold: Bool = false, italic: Bool = false, strikethrough: Bool = false,
		underline: Bool = false, linkTarget: String? = nil)
	{
		if let type = segmentType {
			self.type = type
		} else if linkTarget != nil {
			self.type = SegmentType.Link
		} else {
			self.type = SegmentType.Text
		}
		
		self.text = text
		self.bold = bold
		self.italic = italic
		self.strikethrough = strikethrough
		self.underline = underline
		self.linkTarget = linkTarget
	}
	
	// Create a chat message segment from a parsed MessageSegment.
	// The formatting options are optional.
	public init(segment: Segment) {
		self.text = segment.text ?? ""
		self.type = segment.type
		self.bold = segment.formatting?.bold ?? false
		self.italic = segment.formatting?.italic ?? false
		self.strikethrough = segment.formatting?.strikethrough ?? false
		self.underline = segment.formatting?.underline ?? false
		self.linkTarget = segment.link_data?.link_target ?? nil
	}
	
	// Serialize the segment to pblite.
	public func serialize() -> [Any] {
		return [
			0,//self.type.representation,
			self.text,
			[
				self.bold ? 1 : 0,
				self.italic ? 1 : 0,
				self.strikethrough ? 1 : 0,
				self.underline ? 1 : 0,
			],
			[(self.linkTarget ?? None) as Any]
		]
	}
}

//
// TypingStatusMessage & WatermarkNotification
//

// Definition of the public TypingStatusMessage.
public typealias ITypingStatusMessage = (convID: String, userID: User.ID, timestamp: Date, status: TypingType)

// Definition of the public WatermarkNotification.
public typealias IWatermarkNotification = (convID: String, userID: User.ID, readTimestamp: Date)

// Return TypingStatusMessage from ClientSetTypingNotification.
// The same status may be sent multiple times consecutively, and when a
// message is sent the typing status will not change to stopped.
internal func parseTypingStatusMessage(p: SetTypingNotification) -> ITypingStatusMessage {
	return ITypingStatusMessage(
		convID: p.conversation_id!.id! ,
		userID: User.ID(chatID: p.sender_id!.chat_id!, gaiaID: p.sender_id!.gaia_id!),
		timestamp: Date.from(UTC: Double(p.timestamp ?? 0)),
		status: p.type!
	)
}

// Return WatermarkNotification from ClientWatermarkNotification.
internal func parseWatermarkNotification(client_watermark_notification: WatermarkNotification) -> IWatermarkNotification {
	return IWatermarkNotification(
		convID: client_watermark_notification.conversation_id!.id!,
		userID: User.ID(
			chatID: client_watermark_notification.sender_id!.chat_id!,
			gaiaID: client_watermark_notification.sender_id!.gaia_id!
		),
		readTimestamp: Date.from(UTC: Double(client_watermark_notification.latest_read_timestamp ?? 0))
	)
}
