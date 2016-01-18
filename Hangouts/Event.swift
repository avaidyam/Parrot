
// An event which becomes part of the permanent record of a conversation.
// Acts as a base class for the events defined below.
public class Event : Hashable, Equatable {
    private let event: EVENT
	
    public init(client_event: EVENT) {
        event = client_event
    }
	
	// A timestamp of when the event occurred.
    public lazy var timestamp: NSDate = {
        return self.event.timestamp
    }()
	
	// A UserID indicating who created the event.
    public lazy var user_id: UserID = {
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
		let raw_attachments = self.event.chat_message?.message_content.attachment ?? [MESSAGE_ATTACHMENT]()
		var attachments = [String]()
		for attachment in raw_attachments {
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
    public var new_name: String {
        return self.event.conversation_rename!.new_name as String
    }
	
	// The conversation's old name, or "" if no previous name.
    public var old_name: String {
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
    public var participant_ids: [UserID] {
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
	public let type: SegmentType
	public let text: String
	public let is_bold: Bool
	public let is_italic: Bool
	public let is_strikethrough: Bool
	public let is_underline: Bool
	public let link_target: String?
	
	// A segment of a chat message.
	// Create a new chat message segment.
	public init(text: String,
		segment_type: SegmentType?=nil,
		is_bold: Bool=false,
		is_italic: Bool=false,
		is_strikethrough: Bool=false,
		is_underline: Bool=false,
		link_target: String?=nil
		) {
			if let type = segment_type {
				self.type = type
			} else if link_target != nil {
				self.type = SegmentType.LINK
			} else {
				self.type = SegmentType.TEXT
			}
			
			self.text = text
			self.is_bold = is_bold
			self.is_italic = is_italic
			self.is_strikethrough = is_strikethrough
			self.is_underline = is_underline
			self.link_target = link_target
	}
	
	/* TODO: Refactor to match hangups and Protobuf docs. */
	
	// Create a chat message segment from a parsed MESSAGE_SEGMENT.
	// The formatting options are optional.
	public init(segment: MESSAGE_SEGMENT) {
		text = segment.text as String? ?? "" // weird bug here?
		type = segment.type
		is_bold = segment.formatting?.bold?.boolValue ?? false
		is_italic = segment.formatting?.italic?.boolValue ?? false
		is_strikethrough = segment.formatting?.strikethrough?.boolValue ?? false
		is_underline = segment.formatting?.underline?.boolValue ?? false
		link_target = (segment.link_data?.link_target as String?) ?? nil
	}
	
	// Serialize the segment to pblite.
	public func serialize() -> [AnyObject] {
		return [
			self.type.representation,
			self.text,
			[
				self.is_bold ? 1 : 0,
				self.is_italic ? 1 : 0,
				self.is_strikethrough ? 1 : 0,
				self.is_underline ? 1 : 0,
			],
			[self.link_target ?? None]
		]
	}
}
