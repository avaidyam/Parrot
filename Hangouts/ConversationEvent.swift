import Foundation

public struct UserID : Hashable {
    public let chat_id: String
    public let gaia_id: String

    public var hashValue: Int {
        get {
            return chat_id.hashValue &+ gaia_id.hashValue
        }
    }
}

public func ==(lhs: UserID, rhs: UserID) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

// An event which becomes part of the permanent record of a conversation.
// This corresponds to ClientEvent in the API.
// This is the base class for such events.
public class ConversationEvent : Equatable {
    public let event: CLIENT_EVENT

    public init(client_event: CLIENT_EVENT) {
        event = client_event
    }
	
	// A timestamp of when the event occurred.
    public lazy var timestamp: NSDate = {
        return self.event.timestamp
    }()
	
	// A UserID indicating who created the event.
    public lazy var user_id: UserID = {
        return UserID(
            chat_id: self.event.sender_id.chat_id as String,
            gaia_id: self.event.sender_id.gaia_id as String
        )
    }()
	
	// The ID of the conversation the event belongs to.
    public lazy var conversation_id: NSString = {
        return self.event.conversation_id.id
    }()
	
	// The ID of the ConversationEvent.
    public lazy var id: Conversation.EventID = {
        return self.event.event_id! as Conversation.EventID
    }()
}

public func ==(lhs: ConversationEvent, rhs: ConversationEvent) -> Bool {
    return lhs.event == rhs.event
}

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
	
	// Create a chat message segment from a parsed MESSAGE_SEGMENT.
	// The formatting options are optional.
    public init(segment: MESSAGE_SEGMENT) {
        text = segment.text! as String
        type = segment.type
        is_bold = segment.formatting?.bold?.boolValue ?? false
        is_italic = segment.formatting?.italic?.boolValue ?? false
        is_strikethrough = segment.formatting?.strikethrough?.boolValue ?? false
        is_underline = segment.formatting?.underline?.boolValue ?? false
        link_target = (segment.link_data?.link_target as String?) ?? nil
    }
	
	// Serialize the segment to pblite.
    public func serialize() -> NSArray {
        return [self.type.representation, self.text, [
            self.is_bold ? 1 : 0,
            self.is_italic ? 1 : 0,
            self.is_strikethrough ? 1 : 0,
            self.is_underline ? 1 : 0,
            ], [self.link_target ?? NSNull()]]
    }
}

// An event containing a chat message.
// Corresponds to ClientChatMessage in the API.
public class ChatMessageEvent : ConversationEvent {
	
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
        } else {
            return []
        }
    }()
	
	// Attachments in the message.
    public var attachments: [String] {
        get {
            let raw_attachments = self.event.chat_message?.message_content.attachment ?? [MESSAGE_ATTACHMENT]()
            var attachments = [String]()
            for attachment in raw_attachments {
                if attachment.embed_item.type == [249] { // PLUS_PHOTO
					
                    // Try to parse an image message. Image messages contain no
                    // message segments, and thus have no automatic textual
                    // fallback.
                    if let data = attachment.embed_item.data["27639957"] as? NSArray,
                        zeroth = data[0] as? NSArray,
                        third = zeroth[3] as? String {
                            attachments.append(third)
                    }
				} else if attachment.embed_item.type == [438] { // VOICE_PHOTO
					
					// Try to parse an image message. Image messages contain no
					// message segments, and thus have no automatic textual
					// fallback.
					if let data = attachment.embed_item.data["62101782"] as? NSArray,
						zeroth = data[0] as? NSArray,
						third = zeroth[3] as? String {
							attachments.append(third)
					}
				} else if attachment.embed_item.type == [340, 335, 0] {
                    // Google Maps URL that's already in the text.
                } else {
                    print("Ignoring unknown chat message attachment: \(attachment)")
                }
            }
            return attachments
        }
    }
}

// An event that renames a conversation.
// Corresponds to ClientConversationRename in the API.
public class RenameEvent : ConversationEvent {
	
	// The conversation's new name.
	// An empty string if the conversation's name was cleared.
    public var new_name: String {
        get {
            return self.event.conversation_rename!.new_name as String
        }
    }
	
	// The conversation's old name.
	// An empty string if the conversation had no previous name.
    public var old_name: String {
        get {
            return self.event.conversation_rename!.old_name as String
        }
    }
}

// An event that adds or removes a conversation participant.
// Corresponds to ClientMembershipChange in the API.
public class MembershipChangeEvent : ConversationEvent {
	
	// The membership change type (MembershipChangeType).
    public var type: MembershipChangeType {
        get {
            return self.event.membership_change!.type
        }
    }
	
	// Return the UserIDs involved in the membership change.
	// Multiple users may be added to a conversation at the same time.
    public var participant_ids: [UserID] {
        get {
            return self.event.membership_change!.participant_ids.map {
                UserID(chat_id: $0.chat_id as String, gaia_id: $0.gaia_id as String)
            }
        }
    }
}