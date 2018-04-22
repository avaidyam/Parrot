import Foundation
import HangoutsCore
import ParrotServiceExtension
import class Mocha.Logger

private let log = Logger(subsystem: "Hangouts.Event")

/* TODO: Refactor ChatMessageSegment to match hangups and Protobuf docs. */
/* TODO: Include Markdown, HTML, and URL formatting parsers. */

/*
 ConversationNotification
 EventNotification
 SetFocusNotification
 SetTypingNotification
 SetConversationNotificationLevelNotification
 ReplyToInviteNotification
 WatermarkNotification
 ConversationViewModification
 SelfPresenceNotification
 DeleteActionNotification
 PresenceNotification
 BlockNotification
 SetNotificationSettingNotification
 RichPresenceEnabledStateNotification
*/

// An event which becomes part of the permanent record of a conversation.
// Acts as a base class for the events defined below.
public class IEvent: ParrotServiceExtension.Event, Hashable, Equatable {
    public typealias ID = String
    
    public let event: ClientEvent
	internal unowned let client: Client
    public var serviceIdentifier: String {
        return type(of: self.client).identifier
    }
    
    // Wrap ClientEvent in Event subclass.
    internal class func wrapEvent(_ client: Client, event: ClientEvent) -> IEvent {
        if event.chatMessage != nil {
            return IChatMessageEvent(client, event: event)
        } else if event.conversationRename != nil {
            return IRenameEvent(client, event: event)
        } else if event.membershipChange != nil {
            return IMembershipChangeEvent(client, event: event)
        } else if event.hangoutEvent != nil {
            return IHangoutEvent(client, event: event)
        } else {
            return IEvent(client, event: event)
        }
    }
	
    public init(_ client: Client, event: ClientEvent) {
        self.client = client
        self.event = event
    }
	
	// A timestamp of when the event occurred.
    public var timestamp: Date {
		return Date(UTC: self.event.timestamp ?? 0)
    }
	
	// A User.ID indicating who created the event.
    public var userID: User.ID {
        return User.ID(
            chatID: self.event.senderId!.chatId!,
            gaiaID: self.event.senderId!.gaiaId!
        )
    }
	
	// The ID of the conversation the event belongs to.
    public lazy var conversationId: String = {
        return (self.event.conversationId!.id! as String)
    }()
	
	// The ID of the Event.
    public lazy var id: IEvent.ID = {
        return self.event.eventId! as IEvent.ID
    }()
    public var identifier: String {
        return self.id
    }
	
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
    
    // CACHE IT!
    public var content: Content {
        let raws = self.event.chatMessage?.messageContent?.attachmentArray ?? []
        if let attachment = raws[safe: 0] {
            if attachment.embedItem!.typeArray.contains(.plusPhotoV2) {
                if let url = attachment.embedItem?.plusPhotoV2?.URL {
                    return .image(URL(string: url)!)
                }
            } else if attachment.embedItem!.typeArray.contains(.plusAudioV2) {
                if let url = attachment.embedItem?.plusAudioV2?.URL {
                    return .image(URL(string: url)!)
                }
            } else if attachment.embedItem!.typeArray.contains(.placeV2) {
                let coords = attachment.embedItem?.placeV2?.geo?.geoCoordinatesV2
                return .location(coords?.latitude ?? 0, coords?.longitude ?? 0)
            }
        }
        return .text(self.text)
    }
	
	// A textual representation of the message.
    public lazy var text: String = {
        var lines = [""]
        for segment in self.segments {
            switch (segment.type) {
            case SocialSegmentType_SegmentTypeEnum.text, SocialSegmentType_SegmentTypeEnum.link:
                let replacement = lines.last! + segment.text
                lines.removeLast()
                lines.append(replacement)
            case SocialSegmentType_SegmentTypeEnum.lineBreak:
                lines.append("")
            default:
                log.info("Ignoring unknown chat message segment type: \(segment.type)")
            }
        }
		
        lines += self.attachments
		return lines.filter { $0 != "" }.joined(separator: "\n")
    }()
	
	// List of ChatMessageSegments in the message.
    public lazy var segments: [IChatMessageSegment] = {
        if let list = self.event.chatMessage!.messageContent?.segmentArray {
            return list.map { IChatMessageSegment(segment: $0) }
        }
		return []
    }()
	
	// Attachments in the message.
    public var attachments: [String] {
		let raws = self.event.chatMessage?.messageContent?.attachmentArray ?? [Attachment]()
		var attachments = [String]()
		
		for attachment in raws {
			if attachment.embedItem!.typeArray.contains(.plusPhotoV2) { // PLUS_PHOTO
				if let data = attachment.embedItem?.plusPhotoV2?.URL {
                    attachments.append(data)
				}
			} else if attachment.embedItem!.typeArray.contains(.plusAudioV2) { // VOICE_PHOTO
                if let data = attachment.embedItem?.plusAudioV2?.URL {
                    attachments.append(data)
                }
			} else if attachment.embedItem!.typeArray == [.place, .placeV2, .thing] { // FIXME this is bad swift
				// Google Maps URL that's already in the text.
			} else {
				//log.info("Ignoring unknown chat message attachment: \(attachment)")
			}
		}
		return attachments
    }
	
	public var sender: Person {
		let orig = User(self.client, userID: self.userID)
		return self.client.directory.people[self.userID.gaiaID] ?? orig
	}
}

// An event that renames a conversation.
public class IRenameEvent : IEvent, ParrotServiceExtension.ConversationRenamed {
	
    public var sender: Person {
        let orig = User(self.client, userID: self.userID)
        return self.client.directory.people[self.userID.gaiaID] ?? orig
    }
    
	// The conversation's new name, or "" if the name was cleared.
    public var newValue: String {
        return self.event.conversationRename!.newName!
    }
	
	// The conversation's old name, or "" if no previous name.
    public var oldValue: String {
        return self.event.conversationRename!.oldName!
    }
}

// An event that adds or removes a conversation participant.
public class IMembershipChangeEvent : IEvent, ParrotServiceExtension.MembershipChanged {
	
	// The membership change type (join, leave).
    public var type: ClientMembershipChangeType {
        return self.event.membershipChange!.type!
    }
	
	// Return the User.IDs involved in the membership change.
	// Multiple users may be added to a conversation at the same time.
    public var participantIDs: [User.ID] {
		return self.event.membershipChange!.participantIdArray.map {
			User.ID(chatID: $0.chatId! , gaiaID: $0.gaiaId!)
		}
    }
    
    public var participants: [Person] {
        return self.participantIDs.map {
            self.client.userList.users[$0] ?? User(self.client, userID: $0)
        }
    }
    
    public var joined: Bool {
        return self.type == .join
    }
    
    public var moderator: Person? {
        let orig = User(self.client, userID: self.userID)
        return self.client.directory.people[self.userID.gaiaID] ?? orig
    }
}

// An event in a Hangouts voice/video call.
public class IHangoutEvent: IEvent, ParrotServiceExtension.VideoCall {
	/*
     public var transferredConversationId: ConversationId? = nil
     public var refreshTimeoutSecs: UInt64? = nil
     public var isPeridoicRefresh: Bool? = nil
    */
    
    public var participantIDs: [User.ID] {
        return self.event.hangoutEvent!.participantIdArray.map {
            User.ID(chatID: $0.chatId! , gaiaID: $0.gaiaId!)
        }
    }
    
    public var participants: [Person] {
        return self.participantIDs.map {
            self.client.userList.users[$0] ?? User(self.client, userID: $0)
        }
    }
    
    public var duration: TimeInterval {
        return TimeInterval(self.event.hangoutEvent!.hangoutDurationSecs ?? 0)
    }
    
    public var video: Bool {
        return self.event.hangoutEvent!.mediaType! == .audioVideo
    }
    
    public var state: VideoCallSubevent {
        switch self.event.hangoutEvent!.eventType! {
        case .startHangout: return .start
        case .endHangout: return .end
        case .joinHangout: return .join
        case .leaveHangout: return .leave
        case .hangoutComingSoon: return .comingSoon
        case .ongoingHangout: return .ongoing
        default: return .comingSoon
        }
    }
}

//
// ChatMessageSegment
//

public class IChatMessageSegment {
	
	// Primary: type and text (always applicable).
	public let type: SocialSegmentType_SegmentTypeEnum
	public let text: String
	
	// Secondary: text and link attributes (optional).
	public let bold: Bool
	public let italic: Bool
	public let strikethrough: Bool
	public let underline: Bool
	public let linkTarget: String?
	
	// A segment of a chat message.
	// Create a new chat message segment.
	public init(text: String, segmentType: SocialSegmentType_SegmentTypeEnum? = nil,
		bold: Bool = false, italic: Bool = false, strikethrough: Bool = false,
		underline: Bool = false, linkTarget: String? = nil)
	{
		if let type = segmentType {
			self.type = type
		} else if linkTarget != nil {
			self.type = SocialSegmentType_SegmentTypeEnum.link
		} else {
			self.type = SocialSegmentType_SegmentTypeEnum.text
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
	public init(segment: SocialSegment) {
		self.text = segment.text ?? ""
		self.type = segment.type!
		self.bold = segment.formatting?.bold ?? false
		self.italic = segment.formatting?.italics ?? false
		self.strikethrough = segment.formatting?.strikethrough ?? false
		self.underline = segment.formatting?.underline ?? false
		self.linkTarget = segment.linkData?.linkTarget ?? nil
	}
}

//
// TypingStatusMessage & WatermarkNotification
//

// Definition of the public TypingStatusMessage.
public typealias ITypingStatusMessage = (convID: String, userID: User.ID, timestamp: Date, status: ClientTypingType)

// Definition of the public WatermarkNotification.
public typealias IWatermarkNotification = (convID: String, userID: User.ID, readTimestamp: Date)

// Return TypingStatusMessage from ClientSetTypingNotification.
// The same status may be sent multiple times consecutively, and when a
// message is sent the typing status will not change to stopped.
internal func parseTypingStatusMessage(p: ClientSetTypingNotification) -> ITypingStatusMessage {
	return ITypingStatusMessage(
		convID: p.conversationId!.id!,
		userID: User.ID(chatID: p.senderId!.chatId!, gaiaID: p.senderId!.gaiaId!),
		timestamp: Date(UTC: p.timestamp ?? 0),
		status: p.type!
	)
}

// Return WatermarkNotification from ClientWatermarkNotification.
internal func parseWatermarkNotification(clientWatermarkNotification: ClientWatermarkNotification) -> IWatermarkNotification {
	return IWatermarkNotification(
		convID: clientWatermarkNotification.conversationId!.id!,
		userID: User.ID(
			chatID: clientWatermarkNotification.participantId!.chatId!,
			gaiaID: clientWatermarkNotification.participantId!.gaiaId!
		),
		readTimestamp: Date(UTC: clientWatermarkNotification.latestReadTimestamp ?? 0)
	)
}
