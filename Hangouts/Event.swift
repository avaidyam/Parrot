
/* TODO: Refactor ChatMessageSegment to match hangups and Protobuf docs. */
/* TODO: Include Markdown, HTML, and URL formatting parsers. */

// An event which becomes part of the permanent record of a conversation.
// Acts as a base class for the events defined below.
public class Event : Hashable, Equatable {
    private let event: EVENT
	
    public init(event: EVENT) {
        self.event = event
    }
	
	// A timestamp of when the event occurred.
    public lazy var timestamp: NSDate = {
        return self.event.timestamp
    }()
	
	// A UserID indicating who created the event.
    public lazy var userID: UserID = {
        return UserID(
            chatID: self.event.sender_id.chat_id as! String,
            gaiaID: self.event.sender_id.gaia_id as! String
        )
    }()
	
	// The ID of the conversation the event belongs to.
    public lazy var conversation_id: String = {
        return (self.event.conversation_id.id! as String)
    }()
	
	// The ID of the Event.
    public lazy var id: Conversation.EventID = {
        return self.event.event_id! as Conversation.EventID
    }()
	
	// Event: Hashable
	public var hashValue: Int {
		return self.event.hashValue
	}
}

// Event: Equatable
public func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.event == rhs.event
}

// An event containing a chat message.
public class ChatMessageEvent : Event {
	
	// A textual representation of the message.
    public lazy var text: String = {
        var lines = [""]
        for segment in self.segments {
            switch (segment.type) {
            case SegmentType.TEXT, SegmentType.LINK:
                let replacement = lines.last! + segment.text
                lines.removeLast()
                lines.append(replacement)
            case SegmentType.LINE_BREAK:
                lines.append("")
            default:
                print("Ignoring unknown chat message segment type: \(segment.type.representation)")
            }
        }
		
        lines += self.attachments
        return lines.joinWithSeparator("\n")
    }()
	
	// List of ChatMessageSegments in the message.
    public lazy var segments: [ChatMessageSegment] = {
        if let list = self.event.chat_message?.message_content.segment {
            return list.map { ChatMessageSegment(segment: $0) }
        }
		return []
    }()
	
	// Attachments in the message.
    public var attachments: [String] {
		let raws = self.event.chat_message?.message_content.attachment ?? [MESSAGE_ATTACHMENT]()
		var attachments = [String]()
		
		for attachment in raws {
			if attachment.embed_item!.type == [249] { // PLUS_PHOTO
				
				// Try to parse an image message. Image messages contain no
				// message segments, and thus have no automatic textual fallback.
				if let data = attachment.embed_item!.data["27639957"] as? [AnyObject],
					zeroth = data[0] as? [AnyObject],
					third = zeroth[3] as? String {
						attachments.append(third)
				}
			} else if attachment.embed_item!.type == [438] { // VOICE_PHOTO
				
				// Try to parse an image message. Image messages contain no
				// message segments, and thus have no automatic textual fallback.
				if let data = attachment.embed_item!.data["62101782"] as? [AnyObject],
					zeroth = data[0] as? [AnyObject],
					third = zeroth[3] as? String {
						attachments.append(third)
				}
			} else if attachment.embed_item!.type == [340, 335, 0] {
				// Google Maps URL that's already in the text.
			} else {
				print("Ignoring unknown chat message attachment: \(attachment)")
			}
		}
		return attachments
    }
}

// An event that renames a conversation.
public class RenameEvent : Event {
	
	// The conversation's new name, or "" if the name was cleared.
    public var newName: String {
        return self.event.conversation_rename!.new_name as String
    }
	
	// The conversation's old name, or "" if no previous name.
    public var oldName: String {
        return self.event.conversation_rename!.old_name as String
    }
}

// An event that adds or removes a conversation participant.
public class MembershipChangeEvent : Event {
	
	// The membership change type (join, leave).
    public var type: MembershipChangeType {
        return self.event.membership_change!.type
    }
	
	// Return the UserIDs involved in the membership change.
	// Multiple users may be added to a conversation at the same time.
    public var participantIDs: [UserID] {
		return self.event.membership_change!.participant_ids.map {
			UserID(chatID: $0.chat_id as! String, gaiaID: $0.gaia_id as! String)
		}
    }
}

// An event in a Hangouts voice/video call.
public class HangoutEvent : Event {
	
	// The Hangouts event (start, end, join, leave, etc).
	public var type: HangoutEventType {
		return self.event.hangout_event!.event_type
	}
}

//
// ChatMessageSegment
//

public class ChatMessageSegment {
	
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
			self.type = SegmentType.LINK
		} else {
			self.type = SegmentType.TEXT
		}
		
		self.text = text
		self.bold = bold
		self.italic = italic
		self.strikethrough = strikethrough
		self.underline = underline
		self.linkTarget = linkTarget
	}
	
	// Create a chat message segment from a parsed MESSAGE_SEGMENT.
	// The formatting options are optional.
	public init(segment: MESSAGE_SEGMENT) {
		self.text = segment.text as String? ?? ""
		self.type = segment.type
		self.bold = segment.formatting?.bold?.boolValue ?? false
		self.italic = segment.formatting?.italic?.boolValue ?? false
		self.strikethrough = segment.formatting?.strikethrough?.boolValue ?? false
		self.underline = segment.formatting?.underline?.boolValue ?? false
		self.linkTarget = (segment.link_data?.link_target as String?) ?? nil
	}
	
	// Serialize the segment to pblite.
	public func serialize() -> [AnyObject] {
		return [
			self.type.representation,
			self.text,
			[
				self.bold ? 1 : 0,
				self.italic ? 1 : 0,
				self.strikethrough ? 1 : 0,
				self.underline ? 1 : 0,
			],
			[self.linkTarget ?? None]
		]
	}
}

//
// TypingStatusMessage & WatermarkNotification
//

// Definition of the public TypingStatusMessage.
public typealias TypingStatusMessage = (convID: String, userID: UserID, timestamp: NSDate, status: TypingType)

// Definition of the public WatermarkNotification.
public typealias WatermarkNotification = (convID: String, userID: UserID, readTimestamp: NSDate)

// Return TypingStatusMessage from ClientSetTypingNotification.
// The same status may be sent multiple times consecutively, and when a
// message is sent the typing status will not change to stopped.
internal func parseTypingStatusMessage(p: SET_TYPING_NOTIFICATION) -> TypingStatusMessage {
	return TypingStatusMessage(
		convID: p.conversation_id!.id as! String,
		userID: UserID(chatID: p.sender_id!.chat_id as! String, gaiaID: p.sender_id!.gaia_id as! String),
		timestamp: from_timestamp(p.timestamp)!,
		status: p.type!
	)
}

// Return WatermarkNotification from ClientWatermarkNotification.
internal func parseWatermarkNotification(client_watermark_notification: WATERMARK_NOTIFICATION) -> WatermarkNotification {
	return WatermarkNotification(
		convID: client_watermark_notification.conversation_id.id as! String,
		userID: UserID(
			chatID: client_watermark_notification.participant_id.chat_id as! String,
			gaiaID: client_watermark_notification.participant_id.gaia_id as! String
		),
		readTimestamp: from_timestamp(client_watermark_notification.latest_read_timestamp)!
	)
}
