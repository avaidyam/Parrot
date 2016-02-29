import Foundation

/****************************************
*										*
*				  ENUMS 				*
*										*
****************************************/

@objc(ActiveClientState)
public class ActiveClientState: Enum {
	public static let NO_ACTIVE_CLIENT: ActiveClientState = 0
	public static let IS_ACTIVE_CLIENT: ActiveClientState = 1
	public static let OTHER_CLIENT_IS_ACTIVE: ActiveClientState = 2
}

@objc(FocusType)
public class FocusType: Enum {
	public static let UNKNOWN: FocusType = 0
	public static let FOCUSED: FocusType = 1
	public static let UNFOCUSED: FocusType = 2
}

@objc(FocusDevice)
public class FocusDevice: Enum {
	public static let UNSPECIFIED: FocusDevice = 0
	public static let DESKTOP: FocusDevice = 20
	public static let MOBILE: FocusDevice = 300
}

@objc(TypingType)
public class TypingType: Enum {
	public static let UNKNOWN: TypingType = 0
	public static let STARTED: TypingType = 1
	public static let PAUSED: TypingType = 2
	public static let STOPPED: TypingType = 3
}

@objc(ClientPresenceStateType)
public class ClientPresenceStateType: Enum {
	public static let UNKNOWN: ClientPresenceStateType = 0
	public static let NONE: ClientPresenceStateType = 1
	public static let DESKTOP_IDLE: ClientPresenceStateType = 30
	public static let DESKTOP_ACTIVE: ClientPresenceStateType = 40
}

@objc(NotificationLevel)
public class NotificationLevel: Enum {
	public static let UNKNOWN: NotificationLevel = 0
	public static let QUIET: NotificationLevel = 10
	public static let RING: NotificationLevel = 30
}

@objc(SegmentType)
public class SegmentType: Enum {
	public static let TEXT: SegmentType = 0
	public static let LINE_BREAK: SegmentType = 1
	public static let LINK: SegmentType = 2
}

@objc(ItemType)
public class ItemType: Enum {
	public static let THING: SegmentType = 0
	public static let PLUS_PHOTO: SegmentType = 249
	public static let PLACE: SegmentType = 335
	public static let PLACE_V2: SegmentType = 340
}

@objc(MediaType)
public class MediaType: Enum {
	public static let UNKNOWN: MediaType = 0
	public static let PHOTO: MediaType = 1
	public static let ANIMATED_PHOTO: MediaType = 4
}

@objc(MembershipChangeType)
public class MembershipChangeType: Enum {
	public static let JOIN: MembershipChangeType = 1
	public static let LEAVE: MembershipChangeType = 2
}

@objc(HangoutEventType)
public class HangoutEventType: Enum {
	public static let UNKNOWN: HangoutEventType = 0
	public static let START: HangoutEventType = 1
	public static let END: HangoutEventType = 2
	public static let JOIN: HangoutEventType = 3
	public static let LEAVE: HangoutEventType = 4
	public static let COMING_SOON: HangoutEventType = 5
	public static let ONGOING: HangoutEventType = 6
}

@objc(OffTheRecordToggle)
public class OffTheRecordToggle: Enum {
	public static let UNKNOWN: OffTheRecordToggle = 0
	public static let ENABLED: OffTheRecordToggle = 1
	public static let DISABLED: OffTheRecordToggle = 2
}

@objc(OffTheRecordStatus)
public class OffTheRecordStatus: Enum {
	public static let UNKNOWN: OffTheRecordStatus = 0
	public static let OFF_THE_RECORD: OffTheRecordStatus = 1
	public static let ON_THE_RECORD: OffTheRecordStatus = 2
}

@objc(SourceType)
public class SourceType: Enum {
	public static let UNKNOWN: SourceType = 0
}

@objc(EventType)
public class EventType: Enum {
	public static let UNKNOWN: SourceType = 0
	public static let REGULAR_CHAT_MESSAGE: SourceType = 1
	public static let SMS: SourceType = 2
	public static let VOICEMAIL: SourceType = 3
	public static let ADD_USER: SourceType = 4
	public static let REMOVE_USER: SourceType = 5
	public static let CONVERSATION_RENAME: SourceType = 6
	public static let HANGOUT: SourceType = 7
	public static let PHONE_CALL: SourceType = 8
	public static let OTR_MODIFICATION: SourceType = 9
	public static let PLAN_MUTATION: SourceType = 10
	public static let MMS: SourceType = 11
	public static let DEPRECATED_12: SourceType = 12
}

@objc(ConversationType)
public class ConversationType: Enum {
	public static let UNKNOWN: ConversationType = 0
	public static let ONE_TO_ONE: ConversationType = 1
	public static let GROUP: ConversationType = 2
}

@objc(ConversationStatus)
public class ConversationStatus: Enum {
	public static let UNKNOWN: ConversationStatus = 0
	public static let INVITED: ConversationStatus = 1
	public static let ACTIVE: ConversationStatus = 2
	public static let LEFT: ConversationStatus = 3
}

@objc(ConversationView)
public class ConversationView: Enum {
	public static let UNKNOWN: ConversationView = 0
	public static let INBOX: ConversationView = 1
	public static let ARCHIVED: ConversationView = 2
}

@objc(DeliveryMediumType)
public class DeliveryMediumType: Enum {
	public static let UNKNOWN: DeliveryMediumType = 0
	public static let BABEL: DeliveryMediumType = 1
	public static let GOOGLE_VOICE: DeliveryMediumType = 2
	public static let LOCAL_SMS: DeliveryMediumType = 3
}

@objc(ParticipantType)
public class ParticipantType: Enum {
	public static let UNKNOWN: ParticipantType = 0
	public static let GAIA: ParticipantType = 2
}

@objc(InvitationStatus)
public class InvitationStatus: Enum {
	public static let UNKNOWN: InvitationStatus = 0
	public static let PENDING: InvitationStatus = 1
	public static let ACCEPTED: InvitationStatus = 2
}

@objc(ForceHistory)
public class ForceHistory: Enum {
	public static let UNKNOWN: ForceHistory = 0
	public static let NO_FORCE_HISTORY: ForceHistory = 1
}

@objc(NetworkType)
public class NetworkType: Enum {
	public static let UNKNOWN: NetworkType = 0
	public static let BABEL: NetworkType = 1
	public static let GVOICE: NetworkType = 2
}

@objc(BlockState)
public class BlockState: Enum {
	public static let UNKNOWN: BlockState = 0
	public static let BLOCK: BlockState = 1
	public static let UNBLOCK: BlockState = 1
}

@objc(ReplyToInviteType)
public class ReplyToInviteType: Enum {
	public static let UNKNOWN: ReplyToInviteType = 0
	public static let ACCEPT: ReplyToInviteType = 1
	public static let DECLINE: ReplyToInviteType = 1
}

@objc(ClientID)
public class ClientID: Enum {
	public static let UNKNOWN: ClientID = 0
	public static let ANDROID: ClientID = 1
	public static let IOS: ClientID = 2
	public static let CHROME: ClientID = 3
	public static let WEB_GPLUS: ClientID = 5
	public static let WEB_GMAIL: ClientID = 6
	public static let ULTRAVIOLET: ClientID = 13
}
public typealias ClientId = ClientID

@objc(ClientBuildType)
public class ClientBuildType: Enum {
	public static let UNKNOWN: ClientBuildType = 0
	public static let PRODUCTION_WEB: ClientBuildType = 1
	public static let PRODUCTION_APP: ClientBuildType = 3
}

@objc(ResponseStatus)
public class ResponseStatus: Enum {
	public static let UNKNOWN: ResponseStatus = 0
	public static let OK: ResponseStatus = 1
	public static let UNEXPECTED_ERROR: ResponseStatus = 3
	public static let INVALID_REQUEST: ResponseStatus = 4
}

@objc(PastHangoutState)
public class PastHangoutState: Enum {
	public static let UNKNOWN: PastHangoutState = 0
	public static let HAD_PAST_HANGOUT: PastHangoutState = 1
	public static let NO_PAST_HANGOUT: PastHangoutState = 2
}

@objc(PhotoURLStatus)
public class PhotoURLStatus: Enum {
	public static let UNKNOWN: PhotoURLStatus = 0
	public static let PLACEHOLDER: PhotoURLStatus = 1
	public static let USER_PHOTO: PhotoURLStatus = 2
}
public typealias PhotoUrlStatus = PhotoURLStatus

@objc(Gender)
public class Gender: Enum {
	public static let UNKNOWN: Gender = 0
	public static let MALE: Gender = 1
	public static let FEMALE: Gender = 2
}

@objc(ProfileType)
public class ProfileType: Enum {
	public static let NONE: ProfileType = 0
	public static let ES_USER: ProfileType = 1
}

@objc(ConfigurationBitType)
public class ConfigurationBitType: Enum {
	public static let UNKNOWN: ConfigurationBitType = 0
	// TODO, 0 -> 36 bits
}

@objc(RichPresenceType)
public class RichPresenceType: Enum {
	public static let UNKNOWN: RichPresenceType = 0
	public static let IN_CALL_STATE: RichPresenceType = 1
	public static let DEVICE: RichPresenceType = 2
	public static let LAST_SEEN: RichPresenceType = 6
}

@objc(FieldMask)
public class FieldMask: Enum {
	public static let REACHABLE: FieldMask = 1
	public static let AVAILABLE: FieldMask = 2
	public static let DEVICE: FieldMask = 7
}

@objc(DeleteType)
public class DeleteType: Enum {
	public static let UNKNOWN: DeleteType = 0
	public static let UPPER_BOUND: DeleteType = 1
}

@objc(SyncFilter)
public class SyncFilter: Enum  {
	public static let UNKNOWN: SyncFilter = 0;
	public static let INBOX: SyncFilter = 1;
	public static let ARCHIVED: SyncFilter = 2;
}

@objc(SoundState)
public class SoundState: Enum  {
	public static let UNKNOWN: SoundState = 0;
	public static let ON: SoundState = 1;
	public static let OFF: SoundState = 2;
}

@objc(CallerIDSettingsMask)
public class CallerIDSettingsMask: Enum  {
	public static let UNKNOWN: CallerIDSettingsMask = 0;
	public static let PROVIDED: CallerIDSettingsMask = 1;
}
public typealias CallerIdSettingsMask = CallerIDSettingsMask

@objc(PhoneVerificationStatus)
public class PhoneVerificationStatus: Enum  {
	public static let UNKNOWN: PhoneVerificationStatus = 0;
	public static let VERIFIED: PhoneVerificationStatus = 1;
}

@objc(PhoneDiscoverabilityStatus)
public class PhoneDiscoverabilityStatus: Enum  {
	public static let UNKNOWN: PhoneDiscoverabilityStatus = 0;
	public static let OPTED_IN_BUT_NOT_DISCOVERABLE: PhoneDiscoverabilityStatus = 2;
}

@objc(PhoneValidationResult)
public class PhoneValidationResult: Enum  {
	public static let IS_POSSIBLE: PhoneValidationResult = 0;
}

/****************************************
 *										*
 *				MESSAGES				*
 *										*
 ****************************************/

@objc(DoNotDisturbSetting)
public class DoNotDisturbSetting: Message {
	public var do_not_disturb: NSNumber?
	public var expiration_timestamp: NSNumber?
	public var version: NSNumber?
}

@objc(NotificationSettings)
public class NotificationSettings: Message {
	public var dnd_settings: DoNotDisturbSetting?
}

@objc(ConversationId)
public class ConversationId: Message {
    public var id: NSString?
}

@objc(ParticipantId)
public class ParticipantId: Message {
    public var gaia_id: NSString?
    public var chat_id: NSString?
}

@objc(ConversationReadState)
public class ConversationReadState: Message {
    public var participant_id = ParticipantId()
    public var latest_read_timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
}

@objc(ConversationInternalState)
public class ConversationInternalState: Message {
    public var field1: AnyObject?
    public var field2: AnyObject?
    public var field3: AnyObject?
    public var field4: AnyObject?
    public var field5: AnyObject?
    public var field6: AnyObject?

    public var self_read_state = ConversationReadState()

    public var status: ConversationStatus = 0
    public var notification_level: NotificationLevel = 0
	
	/* TODO: getArrayMessageType() doesn't support enum array types yet. */
    public var view = [ConversationView]()

    public var inviter_id = ParticipantId()
    public var invite_timestamp: NSString = ""
    public var sort_timestamp: NSDate?
    public var active_timestamp: NSDate?

    public var field7: AnyObject?
    public var field8: AnyObject?
    public var field9: AnyObject?
    public var field10: AnyObject?
}

@objc(CONVERSATION)
public class CONVERSATION: Message {
	public var conversation_id: ConversationId? //FIXME
    public var type = ConversationType()
    public var name: NSString?
    public var self_conversation_state = ConversationInternalState()
    public var field5: AnyObject?
    public var field6: AnyObject?
    public var field7: AnyObject?
    public var read_state = [ConversationReadState]()
    public var has_active_hangout: NSNumber = 0
    public var otr_status: OffTheRecordStatus = 0
    public var otr_toggle: AnyObject?
    public var conversation_history_supported: AnyObject?
    public var current_participant = [ParticipantId]()
    public var participant_data = [ConversationParticipantData]()
    public var field15: AnyObject?
    public var field16: AnyObject?
    public var field17: AnyObject?
	/* TODO: getArrayMessageType() doesn't support enum array types yet. */
    public var network_type = [AnyObject]() //[NetworkType]()
	public var force_history_state: AnyObject?
	public var field20: AnyObject?
	public var field21: AnyObject?
}
//public typealias Conversation = CONVERSATION

//  Unfortunately, some of PBLite's introspection
//  uses string-based public class lookup, and nested
//  public classes have mangled names. So, we need to use
//  only non-nested public classes here.
@objc(MessageSegmentFormatting)
public class MessageSegmentFormatting: Message {
    public var bold: NSNumber?
    public var italic: NSNumber?
    public var strikethrough: NSNumber?
    public var underline: NSNumber?
}

@objc(MessageSegmentLinkData)
public class MessageSegmentLinkData: Message {
    public var link_target: NSString?
}

@objc(MessageSegment)
public class MessageSegment: Message {
    public var type: SegmentType = 0
    public var text: NSString?
    public var formatting: MessageSegmentFormatting?
    public var link_data: MessageSegmentLinkData?
}

@objc(MessageAttachmentEmbedItem)
public class MessageAttachmentEmbedItem: Message {
    public var type = NSArray()
    public var data = NSDictionary()
}

@objc(MessageAttachment)
public class MessageAttachment: Message {
	public var embed_item: MessageAttachmentEmbedItem?
}

@objc(ChatMessageContent)
public class ChatMessageContent: Message {
    public var segment = [MessageSegment]()
    public var attachment = [MessageAttachment]()
}

@objc(ChatMessage)
public class ChatMessage: Message {
    public var field1: AnyObject?
    public var annotation = [EventAnnotation]()
    public var message_content = ChatMessageContent()
}

@objc(ConversationRename)
public class ConversationRename: Message {
    public var new_name: NSString = ""
    public var old_name: NSString = ""
}

@objc(HANGOUT_EVENT)
public class HANGOUT_EVENT: Message {
    public var event_type: HangoutEventType = 0
    public var participant_id = [ParticipantId]()
    public var hangout_duration_secs: NSNumber?
    public var transferred_conversation_id: NSString?
    public var refresh_timeout_secs: NSNumber?
    public var is_periodic_refresh: NSNumber?
    public var field1: AnyObject?
}
//public typealias HangoutEvent = HANGOUT_EVENT

@objc(OTRModification)
public class OTRModification: Message {
    public var old_otr_status: OffTheRecordStatus?
    public var new_otr_status: OffTheRecordStatus?
    public var old_otr_toggle: OffTheRecordToggle?
    public var new_otr_toggle: OffTheRecordToggle?
}

@objc(MembershipChange)
public class MembershipChange: Message {
    public var type: MembershipChangeType = 0
    public var field1 = NSArray()
    public var participant_ids = [ParticipantId]()
    public var field2: AnyObject?
}

@objc(EventState)
public class EventState: Message {
    public var user_id = ParticipantId()
    public var client_generated_id: AnyObject?
    public var notification_level: NotificationLevel = 0
}

@objc(EVENT)
public class EVENT: Message {
    public var conversation_id = ConversationId()
    public var sender_id = ParticipantId()
    public var timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
	public var self_event_state : EventState?
	public var field5: AnyObject?
    public var source_type: AnyObject?
	public var chat_message: ChatMessage?
    public var field8: AnyObject?
    public var membership_change: MembershipChange?
    public var conversation_rename: ConversationRename?
    public var hangout_event: HANGOUT_EVENT?
	public var event_id: NSString?
	public var expiration_timestamp: AnyObject?
	public var otr_modification: OTRModification?
	public var advances_sort_timestamp: NSDate?
	public var otr_status: OffTheRecordStatus = 0
	public var persisted: AnyObject?
	public var field18: AnyObject?
	public var field19: AnyObject?
    public var medium_type: AnyObject?
	public var field21: AnyObject?
	public var field22: AnyObject?
	public var event_type: AnyObject?
	public var event_version: AnyObject?
	public var field25: AnyObject?
	public var hash_modifier: AnyObject?
}
//public typealias Event = EVENT

@objc(WATERMARK_NOTIFICATION)
public class WATERMARK_NOTIFICATION: Message {
    public var participant_id = ParticipantId()
    public var conversation_id = ConversationId()
    public var latest_read_timestamp: NSNumber = 0
}
//public typealias WatermarkNotification = WATERMARK_NOTIFICATION

/* TODO: Implement Oneof support here, but how? */
@objc(StateUpdate)
public class StateUpdate: Message {
    public var state_update_header = StateUpdateHeader()
    public var conversation_notification: AnyObject?
    public var event_notification: EventNotification?
	public var focus_notification: SetFocusNotification?
    public var typing_notification: SetTypingNotification?
    public var notification_level_notification: AnyObject?
    public var reply_to_invite_notification: AnyObject?
    public var watermark_notification: WATERMARK_NOTIFICATION?
    public var field1: AnyObject?
    public var settings_notification: AnyObject?
    public var view_modification: AnyObject?
    public var easter_egg_notification: AnyObject?
    public var client_conversation: CONVERSATION?
    public var self_presence_notification: AnyObject?
    public var delete_notification: AnyObject?
    public var presence_notification: AnyObject?
    public var block_notification: AnyObject?
    public var invitation_watermark_notification: AnyObject?
}

@objc(EventContinuationToken)
public class EventContinuationToken: Message {
    public var event_id: NSString?
    public var storage_continuation_token: NSString? //bytes
    public var event_timestamp: NSNumber?
}

@objc(ConversationState)
public class ConversationState: Message {
	public var conversation_id: ConversationId?
	public var conversation: CONVERSATION?
    public var event = [EVENT]()
    public var field4: AnyObject?
    public var event_continuation_token: EventContinuationToken?
}

@objc(EntityGroupEntity)
public class EntityGroupEntity: Message {
    public var entity = Entity()
    public var field1: AnyObject?
}

@objc(EntityGroup)
public class EntityGroup: Message {
    public var field1: AnyObject?
    public var some_sort_of_id: AnyObject?
    public var entity = [EntityGroupEntity]()
}

@objc(InitialClientEntitiesResponse)
public class InitialClientEntitiesResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
    public var response_header: ResponseHeader?
    public var entities = [Entity]()
    public var field1: AnyObject?
    public var group1 = EntityGroup()
    public var group2 = EntityGroup()
    public var group3 = EntityGroup()
    public var group4 = EntityGroup()
    public var group5 = EntityGroup()
}

@objc(ResponseHeader)
public class ResponseHeader: Message {
    public var status: ResponseStatus?
    public var field1: AnyObject?
    public var field2: AnyObject?
    public var request_trace_id: NSString = ""
    public var current_server_time: NSString = ""
}

@objc(SyncAllNewEventsResponse)
public class SyncAllNewEventsResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader? // ResponseHeader()
    public var sync_timestamp: NSNumber? // NSString = ""
    public var conversation_state = [ConversationState]()
}

@objc(GetConversationResponse)
public class GetConversationResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
    public var response_header = ResponseHeader()
    public var conversation_state = ConversationState()
}

@objc(GetEntityByIdResponse)
public class GetEntityByIdResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
    public var response_header = ResponseHeader()
    public var entities = [Entity]()
}

@objc(DeviceStatus)
public class DeviceStatus: Message {
	public var mobile: NSNumber?
	public var desktop: NSNumber?
	public var tablet: NSNumber?
}

@objc(Presence)
public class Presence: Message {
	public var reachable: NSNumber?
	public var available: NSNumber?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var field5: AnyObject?
	public var device_status: DeviceStatus?
	public var field7: AnyObject?
	public var field8: AnyObject?
	public var mood_setting: AnyObject? //MoodSetting?
}

@objc(PresenceResult)
public class PresenceResult: Message {
	public var user_id: ParticipantId?
	public var presence: Presence?
}

@objc(ClientIdentifier)
public class ClientIdentifier: Message {
	public var resource: NSString?
	public var header_id: NSString?
}

@objc(ClientPresenceState)
public class ClientPresenceState: Message {
	public var identifier: ClientIdentifier?
	public var state: ClientPresenceStateType?
}

@objc(UserEventState)
public class UserEventState: Message {
	public var user_id: ParticipantId?
	public var client_generated_id: NSString?
	public var notification_level: NotificationLevel?
}

@objc(SyncRecentConversationsResponse)
public class SyncRecentConversationsResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the 
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var sync_timestamp: NSNumber?
	public var conversation_state = [ConversationState]()
}

@objc(ConfigurationBit)
public class ConfigurationBit: Message {
	public var configuration_bit_type: ConfigurationBitType?
	public var value: NSNumber?
}

@objc(GetSelfInfoResponse)
public class GetSelfInfoResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var self_entity: Entity?
	public var is_known_minor: NSNumber?
	public var client_presence: AnyObject? //??
	public var dnd_state: DoNotDisturbSetting?
	public var desktop_off_setting: AnyObject?//DESKTOP_OFF_SETTING?
	public var phone_data: AnyObject?//PHONE_DATA?
	public var configuration_bit = [AnyObject]() //[ConfigurationBit]?
	public var desktop_off_state: AnyObject?//DESKTOP_OFF_STATE?
	public var google_plus_user: NSNumber?
	public var desktop_sound_setting: AnyObject?//DesktopSoundSetting?
	public var rich_presence_state: AnyObject?//RichPresenceState?
	public var babel_user: AnyObject? //??
	public var desktop_availability_sharing_enabled: AnyObject? //??
	public var google_plus_mobile_user: AnyObject? //?? bool
	public var field16: AnyObject?
	public var field17: AnyObject?
	public var field18: AnyObject?
	public var default_country: AnyObject?//Country?
	public var field20: AnyObject?
	public var field21: AnyObject?
	public var field22: AnyObject?
}

@objc(Thumbnail)
public class Thumbnail: Message {
	public var url: NSString?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var image_url: NSString?
	public var field5: AnyObject?
	public var field6: AnyObject?
	public var field7: AnyObject?
	public var field8: AnyObject?
	public var field9: AnyObject?
	public var width_px: NSNumber?
	public var height_px: NSNumber?
}

@objc(PlusPhoto)
public class PlusPhoto: Message {
	public var thumbnail: Thumbnail?
	public var owner_obfuscated_id: NSString?
	public var album_id: NSString?
	public var photo_id: NSString?
	public var field5: AnyObject?
	public var url: NSString?
	public var field7: AnyObject?
	public var field8: AnyObject?
	public var field9: AnyObject?
	public var original_content_url: NSString?
	public var field11: AnyObject?
	public var field12: AnyObject?
	public var media_type: MediaType?
	public var stream_id = [NSString]()
}

@objc(RepresentativeImage)
public class RepresentativeImage: Message {
	public var url: NSString?
}

@objc(Place)
public class Place: Message {
	public var url: NSString?
	public var field2: AnyObject?
	public var name: NSString?
	public var representative_image: RepresentativeImage?
}

@objc(EmbedItem)
public class EmbedItem: Message {
	public var type = [ItemType]()
	public var id: NSString?
	public var plus_photo: PlusPhoto?
	public var place: Place?
}

@objc(EventAnnotation)
public class EventAnnotation: Message {
	public var type: NSNumber?
	public var value: NSString?
}

@objc(HashModifier)
public class HashModifier: Message {
	public var update_id: NSString?
	public var hash_diff: NSNumber?
	public var field3: AnyObject?
	public var version: NSNumber?
}

@objc(UserReadState)
public class UserReadState: Message {
	public var participant_id: ParticipantId?
	public var latest_read_timestamp: NSNumber?
}

@objc(DeliveryMedium)
public class DeliveryMedium: Message {
	public var medium_type: DeliveryMediumType?
	public var phone: Phone?
}

@objc(DeliveryMediumOption)
public class DeliveryMediumOption: Message {
	public var delivery_medium: DeliveryMedium?
	public var current_default: NSNumber?
}

@objc(UserConversationState)
public class UserConversationState: Message {
	public var client_generated_id: NSString?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var field5: AnyObject?
	public var field6: AnyObject?
	public var self_read_state: UserReadState?
	public var status: ConversationStatus?
	public var notification_level: NotificationLevel?
	public var view = [ConversationView]()
	public var inviter_id: ParticipantId?
	public var invite_timestamp: NSNumber?
	public var sort_timestamp: NSNumber?
	public var active_timestamp: NSNumber?
	public var field15: AnyObject?
	public var field16: AnyObject?
	public var delivery_medium_option = [DeliveryMediumOption]()
}

@objc(ConversationParticipantData)
public class ConversationParticipantData: Message {
	public var id: ParticipantId?
	public var fallback_name: NSString?
	public var invitation_status: InvitationStatus?
	public var field4: AnyObject?
	public var participant_type: ParticipantType?
	public var new_invitation_status: InvitationStatus?
}

@objc(EasterEgg)
public class EasterEgg: Message {
	public var message: NSString?
}

@objc(BlockStateChange)
public class BlockStateChange: Message {
	public var participant_id: ParticipantId?
	public var new_block_state: BlockState?
}

@objc(Photo)
public class Photo: Message {
	public var photo_id: NSString?
	public var delete_albumless_source_photo: NSNumber?
	public var user_id: NSString?
	public var is_custom_user_id: NSNumber?
}

@objc(ExistingMedia)
public class ExistingMedia: Message {
	public var photo: Photo?
}

@objc(EventRequestHeader)
public class EventRequestHeader: Message {
	public var conversation_id: ConversationId?
	public var client_generated_id: NSNumber?
	public var expected_otr: OffTheRecordStatus?
	public var delivery_medium: DeliveryMedium?
	public var event_type: EventType?
}

@objc(ClientVersion)
public class ClientVersion: Message {
	public var client_id: ClientId?
	public var build_type: ClientBuildType?
	public var major_version: NSString?
	public var version_timestamp: NSNumber?
	public var device_os_version: NSString?
	public var device_hardware: NSString?
}

@objc(RequestHeader)
public class RequestHeader: Message {
	public var client_version: ClientVersion?
	public var client_identifier: ClientIdentifier?
	public var field3: AnyObject?
	public var language_code: NSString?
}

@objc(Entity)
public class Entity: Message {
	public var field1: AnyObject?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var field5: AnyObject?
	public var field6: AnyObject?
	public var field7: AnyObject?
	public var presence: Presence?
	public var id: ParticipantId?
	public var properties: EntityProperties?
	public var field11: AnyObject?
	public var field12: AnyObject?
	public var entity_type: ParticipantType?
	public var field14: AnyObject?
	public var field15: AnyObject?
	public var had_past_hangout_state: PastHangoutState?
}

@objc(EntityProperties)
public class EntityProperties: Message {
	public var type: ProfileType?
	public var display_name: NSString?
	public var first_name: NSString?
	public var photo_url: NSString?
	public var email = [NSString]()
	public var phone = [NSString]()
	public var field7: AnyObject?
	public var field8: AnyObject?
	public var field9: AnyObject?
	public var in_users_domain: NSNumber?
	public var gender: Gender?
	public var photo_url_status: PhotoUrlStatus?
	public var field13: AnyObject?
	public var field14: AnyObject?
	public var canonical_email: NSString?
}

@objc(EntityLookupSpec)
public class EntityLookupSpec: Message {
	public var gaia_id: NSString?
}

@objc(RichPresenceState)
public class RichPresenceState: Message {
	public var field2: AnyObject?
	public var get_rich_presence_enabled_state = [RichPresenceEnabledState]()
}

@objc(RichPresenceEnabledState)
public class RichPresenceEnabledState: Message {
	public var type: RichPresenceType?
	public var enabled: NSNumber?
}

@objc(DesktopOffSetting)
public class DesktopOffSetting: Message {
	public var desktop_off: NSNumber?
}

@objc(DesktopOffState)
public class DesktopOffState: Message {
	public var desktop_off: NSNumber?
	public var version: NSNumber?
}

@objc(DndSetting)
public class DndSetting: Message {
	public var do_not_disturb: NSNumber?
	public var timeout_secs: NSNumber?
}

@objc(PresenceStateSetting)
public class PresenceStateSetting: Message {
	public var timeout_secs: NSNumber?
	public var type: ClientPresenceStateType?
}

@objc(MoodMessage)
public class MoodMessage: Message {
	public var mood_content: MoodContent?
}

@objc(MoodContent)
public class MoodContent: Message {
	public var segment = [MessageSegment]()
}

@objc(MoodSetting)
public class MoodSetting: Message {
	public var mood_message: MoodMessage?
}

@objc(MoodState)
public class MoodState: Message {
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var mood_setting: MoodSetting?
}

@objc(DeleteAction)
public class DeleteAction: Message {
	public var delete_action_timestamp: NSNumber?
	public var delete_upper_bound_timestamp: NSNumber?
	public var delete_type: DeleteType?
}

@objc(InviteeID)
public class InviteeID: Message {
	public var gaia_id: NSString?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var fallback_name: NSString?
}

@objc(Country)
public class Country: Message {
	public var region_code: NSString?
	public var country_code: NSNumber?
}

@objc(DesktopSoundSetting)
public class DesktopSoundSetting: Message {
	public var desktop_sound_state: SoundState?
	public var desktop_ring_sound_state: SoundState?
}

@objc(PhoneData)
public class PhoneData: Message {
	public var phone = [Phone]()
	public var field2: AnyObject?
	public var caller_id_settings_mask: CallerIdSettingsMask?
}

@objc(Phone)
public class Phone: Message {
	public var phone_number: PhoneNumber?
	public var google_voice: NSNumber?
	public var verification_status: PhoneVerificationStatus?
	public var discoverable: NSNumber?
	public var discoverability_status: PhoneDiscoverabilityStatus?
	public var primary: NSNumber?
}

@objc(I18nData)
public class I18nData: Message {
	public var national_number: NSString?
	public var international_number: NSString?
	public var country_code: NSNumber?
	public var region_code: NSString?
	public var is_valid: NSNumber?
	public var validation_result: PhoneValidationResult?
}

@objc(PhoneNumber)
public class PhoneNumber: Message {
	public var e164: NSString?
	public var i18n_data: I18nData?
}

@objc(SuggestedContactGroupHash)
public class SuggestedContactGroupHash: Message {
	public var max_results: NSNumber?
	public var hash_: NSString? // title: hash
}

@objc(SuggestedContact)
public class SuggestedContact: Message {
	public var entity: Entity?
	public var invitation_status: InvitationStatus?
}

@objc(SuggestedContactGroup)
public class SuggestedContactGroup: Message {
	public var hash_matched: NSNumber?
	public var hash_: NSString? // title: hash
	public var contact = [SuggestedContact]()
}

@objc(StateUpdateHeader)
public class StateUpdateHeader: Message {
	public var active_client_state: ActiveClientState?
	public var field2: AnyObject?
	public var request_trace_id: NSString?
	public var notification_settings: NotificationSettings?
	public var current_server_time: NSNumber?
	public var field6: AnyObject?
	public var field7: AnyObject?
	public var updating_client_id: AnyObject?
}

@objc(BatchUpdate)
public class BatchUpdate: Message {
	public var state_update = [StateUpdate]()
}

@objc(EventNotification)
public class EventNotification: Message {
	public var event: EVENT?
}

@objc(SetFocusNotification)
public class SetFocusNotification: Message {
	public var conversation_id: ConversationId?
	public var sender_id: ParticipantId?
	public var timestamp: NSNumber?
	public var type: FocusType?
	public var device: FocusDevice?
}

@objc(SetTypingNotification)
public class SetTypingNotification: Message {
	public var conversation_id: ConversationId?
	public var sender_id: ParticipantId?
	public var timestamp: NSNumber?
	public var type: TypingType?
}

@objc(SetConversationNotificationLevelNotification)
public class SetConversationNotificationLevelNotification: Message {
	public var conversation_id: ConversationId?
	public var level: NotificationLevel?
	public var field3: AnyObject?
	public var timestamp: NSNumber?
}

@objc(ReplyToInviteNotification)
public class ReplyToInviteNotification: Message {
	public var conversation_id: ConversationId?
	public var type: ReplyToInviteType?
}

@objc(ConversationViewModification)
public class ConversationViewModification: Message {
	public var conversation_id: ConversationId?
	public var old_view: ConversationView?
	public var new_view: ConversationView?
}

@objc(EasterEggNotification)
public class EasterEggNotification: Message {
	public var sender_id: ParticipantId?
	public var conversation_id: ConversationId?
	public var easter_egg: EasterEgg?
}

@objc(SelfPresenceNotification)
public class SelfPresenceNotification: Message {
	public var client_presence_state: ClientPresenceState?
	public var field2: AnyObject?
	public var do_not_disturb_setting: DoNotDisturbSetting?
	public var desktop_off_setting: DesktopOffSetting?
	public var desktop_off_state: DesktopOffState?
	public var mood_state: MoodState?
}

@objc(DeleteActionNotification)
public class DeleteActionNotification: Message {
	public var conversation_id: ConversationId?
	public var delete_action: DeleteAction?
}

@objc(PresenceNotification)
public class PresenceNotification: Message {
	public var presence = [PresenceResult]()
}

@objc(BlockNotification)
public class BlockNotification: Message {
	public var block_state_change = [BlockStateChange]()
}

@objc(SetNotificationSettingNotification)
public class SetNotificationSettingNotification: Message {
	public var desktop_sound_setting: DesktopSoundSetting?
}

@objc(RichPresenceEnabledStateNotification)
public class RichPresenceEnabledStateNotification: Message {
	public var rich_presence_enabled_state = [RichPresenceEnabledState]()
}

@objc(ConversationSpec)
public class ConversationSpec: Message {
	public var conversation_id: ConversationId?
}

@objc(AddUserRequest)
public class AddUserRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var invitee_id = [InviteeID]()
	public var field4: AnyObject?
	public var event_request_header: EventRequestHeader?
}

@objc(AddUserResponse)
public class AddUserResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var created_event: EVENT?
}

@objc(CreateConversationRequest)
public class CreateConversationRequest: Message {
	public var request_header: RequestHeader?
	public var type: ConversationType?
	public var client_generated_id: NSNumber?
	public var name: NSString?
	public var invitee_id = [InviteeID]()
}

@objc(CreateConversationResponse)
public class CreateConversationResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var conversation: Conversation?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var field5: AnyObject?
	public var field6: AnyObject?
	public var new_conversation_created: NSNumber?
}

@objc(DeleteConversationRequest)
public class DeleteConversationRequest: Message {
	public var request_header: RequestHeader?
	public var conversation_id: ConversationId?
	public var delete_upper_bound_timestamp: NSNumber?
}

@objc(DeleteConversationResponse)
public class DeleteConversationResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var delete_action: DeleteAction?
}

@objc(EasterEggRequest)
public class EasterEggRequest: Message {
	public var request_header: RequestHeader?
	public var conversation_id: ConversationId?
	public var easter_egg: EasterEgg?
}

@objc(EasterEggResponse)
public class EasterEggResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var timestamp: NSNumber?
}

@objc(GetConversationRequest)
public class GetConversationRequest: Message {
	public var request_header: RequestHeader?
	public var conversation_spec: ConversationSpec?
	public var field3: AnyObject?
	public var include_event: NSNumber?
	public var field5: AnyObject?
	public var max_events_per_conversation: NSNumber?
	public var event_continuation_token: EventContinuationToken?
}

@objc(GetEntityByIdRequest)
public class GetEntityByIdRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var batch_lookup_spec = [EntityLookupSpec]()
}

@objc(GetSuggestedEntitiesRequest)
public class GetSuggestedEntitiesRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var field5: AnyObject?
	public var field6: AnyObject?
	public var field7: AnyObject?
	public var favorites: SuggestedContactGroupHash?
	public var contacts_you_hangout_with: SuggestedContactGroupHash?
	public var other_contacts_on_hangouts: SuggestedContactGroupHash?
	public var other_contacts: SuggestedContactGroupHash?
	public var dismissed_contacts: SuggestedContactGroupHash?
	public var pinned_favorites: SuggestedContactGroupHash?
}

@objc(GetSuggestedEntitiesResponse)
public class GetSuggestedEntitiesResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var entity = [Entity]()
	public var field3: AnyObject?
	public var favorites: SuggestedContactGroup?
	public var contacts_you_hangout_with: SuggestedContactGroup?
	public var other_contacts_on_hangouts: SuggestedContactGroup?
	public var other_contacts: SuggestedContactGroup?
	public var dismissed_contacts: SuggestedContactGroup?
	public var pinned_favorites: SuggestedContactGroup?
}

@objc(GetSelfInfoRequest)
public class GetSelfInfoRequest: Message {
	public var request_header: RequestHeader?
}

@objc(QueryPresenceRequest)
public class QueryPresenceRequest: Message {
	public var request_header: RequestHeader?
	public var participant_id = [ParticipantId]()
	public var field_mask = [FieldMask]()
}

@objc(QueryPresenceResponse)
public class QueryPresenceResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var presence_result = [PresenceResult]()
}

@objc(RemoveUserRequest)
public class RemoveUserRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var event_request_header: EventRequestHeader?
}

@objc(RemoveUserResponse)
public class RemoveUserResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var created_event: EVENT?
}

@objc(RenameConversationRequest)
public class RenameConversationRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var new_name: NSString?
	public var field4: AnyObject?
	public var event_request_header: EventRequestHeader?
}

@objc(RenameConversationResponse)
public class RenameConversationResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var created_event: EVENT?
}

@objc(SearchEntitiesRequest)
public class SearchEntitiesRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var query: NSString?
	public var max_count: NSNumber?
}

@objc(SearchEntitiesResponse)
public class SearchEntitiesResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var entity = [Entity]()
}

@objc(SendChatMessageRequest)
public class SendChatMessageRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var annotation = [EventAnnotation]()
	public var message_content: ChatMessageContent?
	public var existing_media: ExistingMedia?
	public var event_request_header: EventRequestHeader?
}

@objc(SendChatMessageResponse)
public class SendChatMessageResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var field2: AnyObject?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var field5: AnyObject?
	public var created_event: EVENT?
}

@objc(SetActiveClientRequest)
public class SetActiveClientRequest: Message {
	public var request_header: RequestHeader?
	public var is_active: NSNumber?
	public var full_jid: NSString?
	public var timeout_secs: NSNumber?
}

@objc(SetActiveClientResponse)
public class SetActiveClientResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
}

@objc(SetConversationLevelRequest)
public class SetConversationLevelRequest: Message {
	public var request_header: RequestHeader?
}

@objc(SetConversationLevelResponse)
public class SetConversationLevelResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
}

@objc(SetConversationNotificationLevelRequest)
public class SetConversationNotificationLevelRequest: Message {
	public var request_header: RequestHeader?
	public var conversation_id: ConversationId?
	public var level: NotificationLevel?
}

@objc(SetConversationNotificationLevelResponse)
public class SetConversationNotificationLevelResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var timestamp: NSNumber?
}

@objc(SetFocusRequest)
public class SetFocusRequest: Message {
	public var request_header: RequestHeader?
	public var conversation_id: ConversationId?
	public var type: FocusType?
	public var timeout_secs: NSNumber?
}

@objc(SetFocusResponse)
public class SetFocusResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var timestamp: NSNumber?
}

@objc(SetPresenceRequest)
public class SetPresenceRequest: Message {
	public var request_header: RequestHeader?
	public var presence_state_setting: PresenceStateSetting?
	public var dnd_setting: DndSetting?
	public var field4: AnyObject?
	public var desktop_off_setting: DesktopOffSetting?
	public var field6: AnyObject?
	public var field7: AnyObject?
	public var mood_setting: MoodSetting?
}

@objc(SetPresenceResponse)
public class SetPresenceResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
}

@objc(SetTypingRequest)
public class SetTypingRequest: Message {
	public var request_header: RequestHeader?
	public var conversation_id: ConversationId?
	public var type: TypingType?
}

@objc(SetTypingResponse)
public class SetTypingResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
	public var timestamp: NSNumber?
}

@objc(SyncAllNewEventsRequest)
public class SyncAllNewEventsRequest: Message {
	public var request_header: RequestHeader?
	public var last_sync_timestamp: NSNumber?
	public var field3: AnyObject?
	public var field4: AnyObject?
	public var field5: AnyObject?
	public var field6: AnyObject?
	public var field7: AnyObject?
	public var max_response_size_bytes: NSNumber?
}

@objc(SyncRecentConversationsRequest)
public class SyncRecentConversationsRequest: Message {
	public var request_header: RequestHeader?
	public var field2: AnyObject?
	public var max_conversations: NSNumber?
	public var max_events_per_conversation: NSNumber?
	public var sync_filter = [SyncFilter]()
}

@objc(UpdateWatermarkRequest)
public class UpdateWatermarkRequest: Message {
	public var request_header: RequestHeader?
	public var conversation_id: ConversationId?
	public var last_read_timestamp: NSNumber?
}

@objc(UpdateWatermarkResponse)
public class UpdateWatermarkResponse: Message {
	
	// The first element of the outer list must often be ignored
	// because it contains an abbreviation of the name of the
	// protobuf message (eg. cscmrp for ClientSendChatMessageResponseP)
	// that's not part of the protobuf.
	public var field0: AnyObject?
	
	public var response_header: ResponseHeader?
}
