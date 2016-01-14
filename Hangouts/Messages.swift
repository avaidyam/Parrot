import Foundation

/****************************************
*										*
*				  ENUMS 				*
*										*
****************************************/

@objc(ActiveClientState)
public class ActiveClientState : Enum {
	public static let NO_ACTIVE_CLIENT: ActiveClientState = 0
	public static let IS_ACTIVE_CLIENT: ActiveClientState = 1
	public static let OTHER_CLIENT_IS_ACTIVE: ActiveClientState = 2
}

@objc(FocusType)
public class FocusType : Enum {
	public static let UNKNOWN: FocusType = 0
	public static let FOCUSED: FocusType = 1
	public static let UNFOCUSED: FocusType = 2
}

@objc(FocusDevice)
public class FocusDevice : Enum {
	public static let UNSPECIFIED: FocusDevice = 0
	public static let DESKTOP: FocusDevice = 20
	public static let MOBILE: FocusDevice = 300
}

@objc(TypingType)
public class TypingType : Enum {
	public static let UNKNOWN: TypingType = 0
	public static let STARTED: TypingType = 1
	public static let PAUSED: TypingType = 2
	public static let STOPPED: TypingType = 3
}

@objc(ClientPresenceStateType)
public class ClientPresenceStateType : Enum {
	public static let UNKNOWN: ClientPresenceStateType = 0
	public static let NONE: ClientPresenceStateType = 1
	public static let DESKTOP_IDLE: ClientPresenceStateType = 30
	public static let DESKTOP_ACTIVE: ClientPresenceStateType = 40
}

@objc(NotificationLevel)
public class NotificationLevel : Enum {
	public static let UNKNOWN: NotificationLevel = 0
	public static let QUIET: NotificationLevel = 10
	public static let RING: NotificationLevel = 30
}

@objc(SegmentType)
public class SegmentType : Enum {
	public static let TEXT: SegmentType = 0
	public static let LINE_BREAK: SegmentType = 1
	public static let LINK: SegmentType = 2
}

@objc(ItemType)
public class ItemType : Enum {
	public static let THING: SegmentType = 0
	public static let PLUS_PHOTO: SegmentType = 249
	public static let PLACE: SegmentType = 335
	public static let PLACE_V2: SegmentType = 340
}

@objc(MediaType)
public class MediaType : Enum {
	public static let UNKNOWN: MediaType = 0
	public static let PHOTO: MediaType = 1
	public static let ANIMATED_PHOTO: MediaType = 4
}

@objc(MembershipChangeType)
public class MembershipChangeType : Enum {
	public static let JOIN: MembershipChangeType = 1
	public static let LEAVE: MembershipChangeType = 2
}

@objc(HangoutEventType)
public class HangoutEventType : Enum {
	public static let UNKNOWN: HangoutEventType = 0
	public static let START: HangoutEventType = 1
	public static let END: HangoutEventType = 2
	public static let JOIN: HangoutEventType = 3
	public static let LEAVE: HangoutEventType = 4
	public static let COMING_SOON: HangoutEventType = 5
	public static let ONGOING: HangoutEventType = 6
}

@objc(OffTheRecordToggle)
public class OffTheRecordToggle : Enum {
	public static let UNKNOWN: OffTheRecordToggle = 0
	public static let ENABLED: OffTheRecordToggle = 1
	public static let DISABLED: OffTheRecordToggle = 2
}

@objc(OffTheRecordStatus)
public class OffTheRecordStatus : Enum {
	public static let UNKNOWN: OffTheRecordStatus = 0
	public static let OFF_THE_RECORD: OffTheRecordStatus = 1
	public static let ON_THE_RECORD: OffTheRecordStatus = 2
}

@objc(SourceType)
public class SourceType : Enum {
	public static let UNKNOWN: SourceType = 0
}

@objc(EventType)
public class EventType : Enum {
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
public class ConversationType : Enum {
	public static let UNKNOWN: ConversationType = 0
	public static let ONE_TO_ONE: ConversationType = 1
	public static let GROUP: ConversationType = 2
}

@objc(ConversationStatus)
public class ConversationStatus : Enum {
	public static let UNKNOWN: ConversationStatus = 0
	public static let INVITED: ConversationStatus = 1
	public static let ACTIVE: ConversationStatus = 2
	public static let LEFT: ConversationStatus = 3
}

@objc(ConversationView)
public class ConversationView : Enum {
	public static let UNKNOWN: ConversationView = 0
	public static let INBOX: ConversationView = 1
	public static let ARCHIVED: ConversationView = 2
}

@objc(DeliveryMediumType)
public class DeliveryMediumType : Enum {
	public static let UNKNOWN: DeliveryMediumType = 0
	public static let BABEL: DeliveryMediumType = 1
	public static let GOOGLE_VOICE: DeliveryMediumType = 2
	public static let LOCAL_SMS: DeliveryMediumType = 3
}

@objc(ParticipantType)
public class ParticipantType : Enum {
	public static let UNKNOWN: ParticipantType = 0
	public static let GAIA: ParticipantType = 2
}

@objc(InvitationStatus)
public class InvitationStatus : Enum {
	public static let UNKNOWN: InvitationStatus = 0
	public static let PENDING: InvitationStatus = 1
	public static let ACCEPTED: InvitationStatus = 2
}

@objc(ForceHistory)
public class ForceHistory : Enum {
	public static let UNKNOWN: ForceHistory = 0
	public static let NO_FORCE_HISTORY: ForceHistory = 1
}

@objc(NetworkType)
public class NetworkType : Enum {
	public static let UNKNOWN: NetworkType = 0
	public static let BABEL: NetworkType = 1
	public static let GVOICE: NetworkType = 2
}

@objc(BlockState)
public class BlockState : Enum {
	public static let UNKNOWN: BlockState = 0
	public static let BLOCK: BlockState = 1
	public static let UNBLOCK: BlockState = 1
}

@objc(ReplyToInviteType)
public class ReplyToInviteType : Enum {
	public static let UNKNOWN: ReplyToInviteType = 0
	public static let ACCEPT: ReplyToInviteType = 1
	public static let DECLINE: ReplyToInviteType = 1
}

@objc(ClientID)
public class ClientID : Enum {
	public static let UNKNOWN: ClientID = 0
	public static let ANDROID: ClientID = 1
	public static let IOS: ClientID = 2
	public static let CHROME: ClientID = 3
	public static let WEB_GPLUS: ClientID = 5
	public static let WEB_GMAIL: ClientID = 6
	public static let ULTRAVIOLET: ClientID = 13
}

@objc(ClientBuildType)
public class ClientBuildType : Enum {
	public static let UNKNOWN: ClientBuildType = 0
	public static let PRODUCTION_WEB: ClientBuildType = 1
	public static let PRODUCTION_APP: ClientBuildType = 3
}

@objc(ResponseStatus)
public class ResponseStatus : Enum {
	public static let UNKNOWN: ResponseStatus = 0
	public static let OK: ResponseStatus = 1
	public static let UNEXPECTED_ERROR: ResponseStatus = 3
	public static let INVALID_REQUEST: ResponseStatus = 4
}

@objc(PastHangoutState)
public class PastHangoutState : Enum {
	public static let UNKNOWN: PastHangoutState = 0
	public static let HAD_PAST_HANGOUT: PastHangoutState = 1
	public static let NO_PAST_HANGOUT: PastHangoutState = 2
}

@objc(PhotoURLStatus)
public class PhotoURLStatus : Enum {
	public static let UNKNOWN: PhotoURLStatus = 0
	public static let PLACEHOLDER: PhotoURLStatus = 1
	public static let USER_PHOTO: PhotoURLStatus = 2
}

@objc(Gender)
public class Gender : Enum {
	public static let UNKNOWN: Gender = 0
	public static let MALE: Gender = 1
	public static let FEMALE: Gender = 2
}

@objc(ProfileType)
public class ProfileType : Enum {
	public static let NONE: ProfileType = 0
	public static let ES_USER: ProfileType = 1
}

@objc(ConfigurationBitType)
public class ConfigurationBitType : Enum {
	public static let UNKNOWN: ConfigurationBitType = 0
	// TODO
}

@objc(RichPresenceType)
public class RichPresenceType : Enum {
	public static let UNKNOWN: RichPresenceType = 0
	public static let IN_CALL_STATE: RichPresenceType = 1
	public static let DEVICE: RichPresenceType = 2
	public static let LAST_SEEN: RichPresenceType = 6
}

@objc(FieldMask)
public class FieldMask : Enum {
	public static let REACHABLE: FieldMask = 1
	public static let AVAILABLE: FieldMask = 2
	public static let DEVICE: FieldMask = 7
}

@objc(DeleteType)
public class DeleteType : Enum {
	public static let UNKNOWN: DeleteType = 0
	public static let UPPER_BOUND: DeleteType = 1
}

@objc(SyncFilter)
public class SyncFilter : Enum  {
	public static let UNKNOWN: SyncFilter = 0;
	public static let INBOX: SyncFilter = 1;
	public static let ARCHIVED: SyncFilter = 2;
}

@objc(SoundState)
public class SoundState : Enum  {
	public static let UNKNOWN: SoundState = 0;
	public static let ON: SoundState = 1;
	public static let OFF: SoundState = 2;
}

@objc(CallerIDSettingsMask)
public class CallerIDSettingsMask : Enum  {
	public static let UNKNOWN: CallerIDSettingsMask = 0;
	public static let PROVIDED: CallerIDSettingsMask = 1;
}

@objc(PhoneVerificationStatus)
public class PhoneVerificationStatus : Enum  {
	public static let UNKNOWN: PhoneVerificationStatus = 0;
	public static let VERIFIED: PhoneVerificationStatus = 1;
}

@objc(PhoneDiscoverabilityStatus)
public class PhoneDiscoverabilityStatus : Enum  {
	public static let UNKNOWN: PhoneDiscoverabilityStatus = 0;
	public static let OPTED_IN_BUT_NOT_DISCOVERABLE: PhoneDiscoverabilityStatus = 2;
}

@objc(PhoneValidationResult)
public class PhoneValidationResult : Enum  {
	public static let IS_POSSIBLE: PhoneValidationResult = 0;
}

/****************************************
 *										*
 *				MESSAGES				*
 *										*
 ****************************************/

@objc(DO_NOT_DISTURB_SETTING)
public class DO_NOT_DISTURB_SETTING : Message {
	public var do_not_disturb: NSNumber?
	public var expiration_timestamp: NSNumber?
	public var version: NSNumber?
}

@objc(NOTIFICATION_SETTINGS)
public class NOTIFICATION_SETTINGS : Message {
	public var dnd_settings: DO_NOT_DISTURB_SETTING?
}

@objc(CONVERSATION_ID)
public class CONVERSATION_ID : Message {
    public var id: NSString?
}

@objc(PARTICIPANT_ID)
public class PARTICIPANT_ID : Message {
    public var gaia_id: NSString?
    public var chat_id: NSString?
}

@objc(SET_TYPING_NOTIFICATION)
public class SET_TYPING_NOTIFICATION : Message {
    public var conversation_id = CONVERSATION_ID()
    public var user_id = PARTICIPANT_ID()
    public var timestamp: NSNumber = 0
    public var status: TypingType = 0
}

@objc(SET_FOCUS_NOTIFICATION)
public class SET_FOCUS_NOTIFICATION : Message {
    public var conversation_id = CONVERSATION_ID()
    public var user_id = PARTICIPANT_ID()
    public var timestamp: NSString = ""
    public var status: FocusType = 0
    public var device: FocusDevice?
}

@objc(CONVERSATION_READ_STATE)
public class CONVERSATION_READ_STATE : Message {
    public var participant_id = PARTICIPANT_ID()
    public var latest_read_timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
}

@objc(CONVERSATION_INTERNAL_STATE)
public class CONVERSATION_INTERNAL_STATE : Message {
    public var field1: AnyObject?
    public var field2: AnyObject?
    public var field3: AnyObject?
    public var field4: AnyObject?
    public var field5: AnyObject?
    public var field6: AnyObject?

    public var self_read_state = CONVERSATION_READ_STATE()

    public var status: ConversationStatus = 0
    public var notification_level: NotificationLevel = 0

    public var view = [ConversationView]()

    public var inviter_id = PARTICIPANT_ID()
    public var invite_timestamp: NSString = ""
    public var sort_timestamp: NSDate?
    public var active_timestamp: NSDate?

    public var field7: AnyObject?
    public var field8: AnyObject?
    public var field9: AnyObject?
    public var field10: AnyObject?
}

@objc(CONVERSATION_PARTICIPANT_DATA)
public class CONVERSATION_PARTICIPANT_DATA : Message {
    public var id = PARTICIPANT_ID()
    public var fallback_name: NSString?
    public var field: AnyObject?
}

@objc(CONVERSATION)
public class CONVERSATION : Message {
	public var conversation_id: CONVERSATION_ID? //FIXME
    public var type = ConversationType()
    public var name: NSString?
    public var self_conversation_state = CONVERSATION_INTERNAL_STATE()
    public var field5: AnyObject?
    public var field6: AnyObject?
    public var field7: AnyObject?
    public var read_state = [CONVERSATION_READ_STATE]()
    public var has_active_hangout: NSNumber = 0
    public var otr_status: OffTheRecordStatus = 0
    public var otr_toggle: AnyObject?
    public var conversation_history_supported: AnyObject?
    public var current_participant = [PARTICIPANT_ID]()
    public var participant_data = [CONVERSATION_PARTICIPANT_DATA]()
    public var field15: AnyObject?
    public var field16: AnyObject?
    public var field17: AnyObject?
    public var network_type = [NetworkType]()
    public var force_history_state: AnyObject?
}

//  Unfortunately, some of PBLite's introspection
//  uses string-based public class lookup, and nested
//  public classes have mangled names. So, we need to use
//  only non-nested public classes here.
@objc(MESSAGE_SEGMENT_FORMATTING)
public class MESSAGE_SEGMENT_FORMATTING : Message {
    public var bold: NSNumber?
    public var italic: NSNumber?
    public var strikethrough: NSNumber?
    public var underline: NSNumber?
}

@objc(MESSAGE_SEGMENT_LINK_DATA)
public class MESSAGE_SEGMENT_LINK_DATA : Message {
    public var link_target: NSString?
}

@objc(MESSAGE_SEGMENT)
public class MESSAGE_SEGMENT : Message {
    public var type: SegmentType = 0
    public var text: NSString?
    public var formatting: MESSAGE_SEGMENT_FORMATTING?
    public var link_data: MESSAGE_SEGMENT_LINK_DATA?
}

@objc(MESSAGE_ATTACHMENT_EMBED_ITEM)
public class MESSAGE_ATTACHMENT_EMBED_ITEM : Message {
    public var type = NSArray()
    public var data = NSDictionary()
}

@objc(MESSAGE_ATTACHMENT)
public class MESSAGE_ATTACHMENT : Message {
	public var embed_item: MESSAGE_ATTACHMENT_EMBED_ITEM?
}

@objc(CHAT_MESSAGE_CONTENT)
public class CHAT_MESSAGE_CONTENT : Message {
    public var segment = [MESSAGE_SEGMENT]()
    public var attachment = [MESSAGE_ATTACHMENT]()
}

@objc(CHAT_MESSAGE)
public class CHAT_MESSAGE : Message {
    public var field1: AnyObject?
    public var annotation: NSArray?
    public var message_content = CHAT_MESSAGE_CONTENT()
}

@objc(CONVERSATION_RENAME)
public class CONVERSATION_RENAME : Message {
    public var new_name: NSString = ""
    public var old_name: NSString = ""
}

@objc(HANGOUT_EVENT)
public class HANGOUT_EVENT : Message {
    public var event_type: HangoutEventType = 0
    public var participant_id = [PARTICIPANT_ID]()
    public var hangout_duration_secs: NSNumber?
    public var transferred_conversation_id: NSString?
    public var refresh_timeout_secs: NSNumber?
    public var is_periodic_refresh: NSNumber?
    public var field1: AnyObject?
}

@objc(OTR_MODIFICATION)
public class OTR_MODIFICATION : Message {
    public var old_otr_status: OffTheRecordStatus = 0
    public var new_otr_status: OffTheRecordStatus = 0
    public var old_otr_toggle: OffTheRecordToggle = 0
    public var new_otr_toggle: OffTheRecordToggle = 0
}

@objc(MEMBERSHIP_CHANGE)
public class MEMBERSHIP_CHANGE : Message {
    public var type: MembershipChangeType = 0
    public var field1 = NSArray()
    public var participant_ids = [PARTICIPANT_ID]()
    public var field2: AnyObject?
}

@objc(EVENT_STATE)
public class EVENT_STATE : Message {
    public var user_id = PARTICIPANT_ID()
    public var client_generated_id: AnyObject?
    public var notification_level: NotificationLevel = 0
}

@objc(EVENT)
public class EVENT : Message {
    public var conversation_id = CONVERSATION_ID()
    public var sender_id = PARTICIPANT_ID()
    public var timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
	public var self_event_state : EVENT_STATE?
	public var field5: AnyObject?
    public var source_type: AnyObject?
	public var chat_message: CHAT_MESSAGE?
    public var field8: AnyObject?
    public var membership_change: MEMBERSHIP_CHANGE?
    public var conversation_rename: CONVERSATION_RENAME?
    public var hangout_event: HANGOUT_EVENT?
	public var event_id: NSString?
	public var expiration_timestamp: AnyObject?
	public var otr_modification: OTR_MODIFICATION?
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

@objc(EVENT_NOTIFICATION)
public class EVENT_NOTIFICATION : Message {
    public var event = EVENT()
}

@objc(WATERMARK_NOTIFICATION)
public class WATERMARK_NOTIFICATION : Message {
    public var participant_id = PARTICIPANT_ID()
    public var conversation_id = CONVERSATION_ID()
    public var latest_read_timestamp: NSNumber = 0
}

@objc(STATE_UPDATE_HEADER)
public class STATE_UPDATE_HEADER : Message {
    public var active_client_state: ActiveClientState = 0
    public var field1: AnyObject?
    public var request_trace_id: NSString = ""
    public var field2: AnyObject?
    public var current_server_time: NSString = ""
    public var field3: AnyObject?
    public var field4: AnyObject?
    public var updating_client_id: AnyObject?
}

// FIXME: How to implement oneof?
@objc(STATE_UPDATE)
public class STATE_UPDATE : Message {
    public var state_update_header = STATE_UPDATE_HEADER()
    public var conversation_notification: AnyObject?
    public var event_notification: EVENT_NOTIFICATION?
    public var focus_notification = SET_FOCUS_NOTIFICATION()
    public var typing_notification: SET_TYPING_NOTIFICATION?
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

@objc(EVENT_CONTINUATION_TOKEN)
public class EVENT_CONTINUATION_TOKEN : Message {
    public var event_id: NSString?
    public var storage_continuation_token: NSString = ""
    public var event_timestamp: NSString = ""
}

@objc(CONVERSATION_STATE)
public class CONVERSATION_STATE : Message {
    public var conversation_id = CONVERSATION_ID()
    public var conversation = CONVERSATION()
    public var event = [EVENT]()
    public var field1: AnyObject?
    public var event_continuation_token: EVENT_CONTINUATION_TOKEN?
    //public var field2: AnyObject?
    //public var field3: AnyObject?
}

@objc(ENTITY_PROPERTIES)
public class ENTITY_PROPERTIES : Message {
    public var type: NSNumber?
    public var display_name: NSString?
    public var first_name: NSString?
    public var photo_url: NSString?
    public var emails = NSArray()
}

@objc(ENTITY)
public class ENTITY : Message {
    public var field1: AnyObject?
    public var field2: AnyObject?
    public var field3: AnyObject?
    public var field4: AnyObject?
    public var field5: AnyObject?
    public var field6: AnyObject?
    public var field7: AnyObject?
    public var field8: AnyObject?
    public var id = PARTICIPANT_ID()

    public var properties = ENTITY_PROPERTIES()
}

@objc(ENTITY_GROUP_ENTITY)
public class ENTITY_GROUP_ENTITY : Message {
    public var entity = ENTITY()
    public var field1: AnyObject?
}

@objc(ENTITY_GROUP)
public class ENTITY_GROUP : Message {
    public var field1: AnyObject?
    public var some_sort_of_id: AnyObject?

    public var entity = [ENTITY_GROUP_ENTITY]()
}

@objc(INITIAL_CLIENT_ENTITIES)
public class INITIAL_CLIENT_ENTITIES : Message {
    public var cgserp: NSString = ""
    public var header: AnyObject?
    public var entities = [ENTITY]()
    public var field1: AnyObject?
    public var group1 = ENTITY_GROUP()
    public var group2 = ENTITY_GROUP()
    public var group3 = ENTITY_GROUP()
    public var group4 = ENTITY_GROUP()
    public var group5 = ENTITY_GROUP()
}

@objc(GET_SELF_INFO_RESPONSE)
public class GET_SELF_INFO_RESPONSE : Message {
    public var cgsirp: NSString = ""
    public var response_header: AnyObject?
    public var self_entity = ENTITY()
}

@objc(RESPONSE_HEADER)
public class RESPONSE_HEADER : Message {
    public var status: NSString = ""
    public var field1: AnyObject?
    public var field2: AnyObject?
    public var request_trace_id: NSString = ""
    public var current_server_time: NSString = ""
}

@objc(SYNC_ALL_NEW_EVENTS_RESPONSE)
public class SYNC_ALL_NEW_EVENTS_RESPONSE : Message {
    public var csanerp: NSString = ""
    public var response_header = RESPONSE_HEADER()
    public var sync_timestamp: NSString = ""
    public var conversation_state = [CONVERSATION_STATE]()
}

@objc(GET_CONVERSATION_RESPONSE)
public class GET_CONVERSATION_RESPONSE : Message {
    public var cgcrp: NSString = ""
    public var response_header = RESPONSE_HEADER()
    public var conversation_state = CONVERSATION_STATE()
}

@objc(GET_ENTITY_BY_ID_RESPONSE)
public class GET_ENTITY_BY_ID_RESPONSE : Message {
    public var cgebirp: NSString = ""
    public var response_header = RESPONSE_HEADER()
    public var entities = [ENTITY]()
}

@objc(DeviceStatus)
public class DeviceStatus : Message {
	public var mobile: NSNumber?
	public var desktop: NSNumber?
	public var tablet: NSNumber?
}

@objc(Presence)
public class Presence : Message {
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
public class PresenceResult : Message {
	public var user_id: PARTICIPANT_ID?
	public var presence: Presence?
}

@objc(ClientIdentifier)
public class ClientIdentifier : Message {
	public var resource: NSString?
	public var header_id: NSString?
}

@objc(ClientPresenceState)
public class ClientPresenceState : Message {
	public var identifier: ClientIdentifier?
	public var state: ClientPresenceStateType?
}

@objc(UserEventState)
public class UserEventState : Message {
	public var user_id: PARTICIPANT_ID?
	public var client_generated_id: NSString?
	public var notification_level: NotificationLevel?
}

// REORDER!
@objc(SyncRecentConversationsResponse)
public class SyncRecentConversationsResponse : Message {
	public var response_header: RESPONSE_HEADER?
	public var sync_timestamp: NSNumber?
	public var conversation_state = [CONVERSATION_STATE]()
}

@objc(ConfigurationBit)
public class ConfigurationBit : Message {
	public var configuration_bit_type: ConfigurationBitType?
	public var value: NSNumber?
}

// REORDER!
@objc(GetSelfInfoResponse)
public class GetSelfInfoResponse : Message {
	public var response_header: RESPONSE_HEADER?
	public var self_entity: ENTITY?
	public var is_known_minor: NSNumber?
	public var field4: AnyObject?
	public var dnd_state: DO_NOT_DISTURB_SETTING?
	public var desktop_off_setting: AnyObject?//DESKTOP_OFF_SETTING?
	public var phone_data: AnyObject?//PHONE_DATA?
	public var configuration_bit = [ConfigurationBit]()
	public var desktop_off_state: AnyObject?//DESKTOP_OFF_STATE?
	public var google_plus_user: NSNumber?
	public var desktop_sound_setting: AnyObject?//DesktopSoundSetting?
	public var rich_presence_state: AnyObject?//RichPresenceState?
	public var field13: AnyObject?
	public var field14: AnyObject?
	public var field15: AnyObject?
	public var field16: AnyObject?
	public var field17: AnyObject?
	public var field18: AnyObject?
	public var default_country: AnyObject?//Country?
}

/* TEMPLATE:
@objc(XYZ)
public class XYZ : Message {
	
}
*/

/*
message Thumbnail {
	optional string url = 1;
	optional string image_url = 4;
	optional uint64 width_px = 10;
	optional uint64 height_px = 11;
}

message PlusPhoto {
	optional Thumbnail thumbnail = 1;
	optional string owner_obfuscated_id = 2;
	optional string album_id = 3;
	optional string photo_id = 4;
	optional string url = 6;
	optional string original_content_url = 10;
	optional MediaType media_type = 13;
	repeated string stream_id = 14;
}

message RepresentativeImage {
	optional string url = 2;
}

message Place {
	optional string url = 1;
	optional string name = 3;
	optional RepresentativeImage representative_image = 185;
}

message EmbedItem {
	repeated ItemType type = 1;
	optional string id = 2;
	optional PlusPhoto plus_photo = 27639957;
	optional Place place = 35825640;
}

message EventAnnotation {
	optional int32 type = 1;
	optional string value = 2;
}

message ChatMessage {
	repeated EventAnnotation annotation = 2;
	optional MessageContent message_content = 3;
}

message MembershipChange {
	optional MembershipChangeType type = 1;
	repeated ParticipantId participant_ids = 3;
}

message ConversationRename {
	optional string new_name = 1;
	optional string old_name = 2;
}

message HangoutEvent {
	optional HangoutEventType event_type = 1;
	repeated ParticipantId participant_id = 2;
}

message OTRModification {
	optional OffTheRecordStatus old_otr_status = 1;
	optional OffTheRecordStatus new_otr_status = 2;
	optional OffTheRecordToggle old_otr_toggle = 3;
	optional OffTheRecordToggle new_otr_toggle = 4;
}

message HashModifier {
	optional string update_id = 1;
	optional uint64 hash_diff = 2;
	optional uint64 version = 4;
}

message Event {
	optional ConversationId conversation_id = 1;
	optional ParticipantId sender_id = 2;
	optional uint64 timestamp = 3;
	optional UserEventState self_event_state = 4;
	optional SourceType source_type = 6;
	optional ChatMessage chat_message = 7;
	optional MembershipChange membership_change = 9;
	optional ConversationRename conversation_rename = 10;
	optional HangoutEvent hangout_event = 11;
	optional string event_id = 12;
	optional uint64 expiration_timestamp = 13;
	optional OTRModification otr_modification = 14;
	optional bool advances_sort_timestamp = 15;
	optional OffTheRecordStatus otr_status = 16;
	optional bool persisted = 17;
	optional DeliveryMedium medium_type = 20;
	optional EventType event_type = 23;
	optional uint64 event_version = 24;
	optional HashModifier hash_modifier = 26;
}

message UserReadState {
	optional ParticipantId participant_id = 1;
	optional uint64 latest_read_timestamp = 2;
}

message DeliveryMedium {
	optional DeliveryMediumType medium_type = 1;
	optional Phone phone = 2;
}

message DeliveryMediumOption {
	optional DeliveryMedium delivery_medium = 1;
	optional bool current_default = 2;
}

message UserConversationState {
	optional string client_generated_id = 2;
	optional UserReadState self_read_state = 7;
	optional ConversationStatus status = 8;
	optional NotificationLevel notification_level = 9;
	repeated ConversationView view = 10;
	optional ParticipantId inviter_id = 11;
	optional uint64 invite_timestamp = 12;
	optional uint64 sort_timestamp = 13;
	optional uint64 active_timestamp = 14;
	repeated DeliveryMediumOption delivery_medium_option = 17;
}

message ConversationParticipantData {
	optional ParticipantId id = 1;
	optional string fallback_name = 2;
	optional InvitationStatus invitation_status = 3;
	optional ParticipantType participant_type = 5;
	optional InvitationStatus new_invitation_status = 6;
}

message Conversation {
	optional ConversationId conversation_id = 1;
	optional ConversationType type = 2;
	optional string name = 3;
	optional UserConversationState self_conversation_state = 4;
	repeated UserReadState read_state = 8;
	optional bool has_active_hangout = 9;
	optional OffTheRecordStatus otr_status = 10;
	optional OffTheRecordToggle otr_toggle = 11;
	optional bool conversation_history_supported = 12;
	repeated ParticipantId current_participant = 13;
	repeated ConversationParticipantData participant_data = 14;
	repeated NetworkType network_type = 18;
	optional ForceHistory force_history_state = 19;
}

message EasterEgg {
	optional string message = 1;
}

message BlockStateChange {
	optional ParticipantId participant_id = 1;
	optional BlockState new_block_state = 2;
}

message Photo {
	optional string photo_id = 1;
	optional bool delete_albumless_source_photo = 2;
	optional string user_id = 3;
	optional bool is_custom_user_id = 4;
}

message ExistingMedia {
	optional Photo photo = 1;
}

message EventRequestHeader {
	optional ConversationId conversation_id = 1;
	optional uint64 client_generated_id = 2;
	optional OffTheRecordStatus expected_otr = 3;
	optional DeliveryMedium delivery_medium = 4;
	optional EventType event_type = 5;
}

message ClientVersion {
	optional ClientId client_id = 1;
	optional ClientBuildType build_type = 2;
	optional string major_version = 3;
	optional uint64 version_timestamp = 4;
	optional string device_os_version = 5;
	optional string device_hardware = 6;
}

message RequestHeader {
	optional ClientVersion client_version = 1;
	optional ClientIdentifier client_identifier = 2;
	optional string language_code = 4;
}

message Entity {
	optional ParticipantId id = 9;
	optional Presence presence = 8;
	optional EntityProperties properties = 10;
	optional ParticipantType entity_type = 13;
	optional PastHangoutState had_past_hangout_state = 16;
}

message EntityProperties {
	optional ProfileType type = 1;
	optional string display_name = 2;
	optional string first_name = 3;
	optional string photo_url = 4;
	repeated string email = 5;
	repeated string phone = 6;
	optional bool in_users_domain = 10;
	optional Gender gender = 11;
	optional PhotoUrlStatus photo_url_status = 12;
	optional string canonical_email = 15;
}

message ConversationState {
	optional ConversationId conversation_id = 1;
	optional Conversation conversation = 2;
	repeated Event event = 3;
	optional EventContinuationToken event_continuation_token = 5;
}

message EventContinuationToken {
	optional string event_id = 1;
	optional bytes storage_continuation_token = 2;
	optional uint64 event_timestamp = 3;
}

message EntityLookupSpec {
	optional string gaia_id = 1;
}

message RichPresenceState {
	repeated RichPresenceEnabledState get_rich_presence_enabled_state = 3;
}

message RichPresenceEnabledState {
	optional RichPresenceType type = 1;
	optional bool enabled = 2;
}

message DesktopOffSetting {
	optional bool desktop_off = 1;
}

message DesktopOffState {
	optional bool desktop_off = 1;
	optional uint64 version = 2;
}

message DndSetting {
	optional bool do_not_disturb = 1;
	optional uint64 timeout_secs = 2;
}

message PresenceStateSetting {
	optional uint64 timeout_secs = 1;
	optional ClientPresenceStateType type = 2;
}

message MoodMessage {
	optional MoodContent mood_content = 1;
}

message MoodContent {
	repeated Segment segment = 1;
}

message MoodSetting {
	optional MoodMessage mood_message = 1;
}

message MoodState {
	optional MoodSetting mood_setting = 4;
}

message DeleteAction {
	optional uint64 delete_action_timestamp = 1;
	optional uint64 delete_upper_bound_timestamp = 2;
	optional DeleteType delete_type = 3;
}

message InviteeID {
	optional string gaia_id = 1;
	optional string fallback_name = 4;
}

message Country {
	optional string region_code = 1;
	optional uint64 country_code = 2;
}

message DesktopSoundSetting {
	optional SoundState desktop_sound_state = 1;
	optional SoundState desktop_ring_sound_state = 2;
}

message PhoneData {
	repeated Phone phone = 1;
	optional CallerIdSettingsMask caller_id_settings_mask = 3;
}

message Phone {
	optional PhoneNumber phone_number = 1;
	optional bool google_voice = 2;
	optional PhoneVerificationStatus verification_status = 3;
	optional bool discoverable = 4;
	optional PhoneDiscoverabilityStatus discoverability_status = 5;
	optional bool primary = 6;
}

enum PhoneValidationResult {
	PHONE_VALIDATION_RESULT_IS_POSSIBLE = 0;
}

message I18nData {
	optional string national_number = 1;
	optional string international_number = 2;
	optional uint64 country_code = 3;
	optional string region_code = 4;
	optional bool is_valid = 5;
	optional PhoneValidationResult validation_result = 6;
}

message PhoneNumber {
	optional string e164 = 1;
	optional I18nData i18n_data = 2;
}

message SuggestedContactGroupHash {
	optional uint64 max_results = 1;
	optional bytes hash = 2;
}

message SuggestedContact {
	optional Entity entity = 1;
	optional InvitationStatus invitation_status = 2;
}

message SuggestedContactGroup {
	optional bool hash_matched = 1;
	optional bytes hash = 2;
	repeated SuggestedContact contact = 3;
}

message StateUpdate {
	optional StateUpdateHeader state_update_header = 1;
	optional Conversation conversation = 13;
	
	// How to implement oneof in Swift?
	oneof state_update {
		EventNotification event_notification = 3;
		SetFocusNotification focus_notification = 4;
		SetTypingNotification typing_notification = 5;
		SetConversationNotificationLevelNotification notification_level_notification = 6;
		ReplyToInviteNotification reply_to_invite_notification = 7;
		WatermarkNotification watermark_notification = 8;
		ConversationViewModification view_modification = 11;
		EasterEggNotification easter_egg_notification = 12;
		SelfPresenceNotification self_presence_notification = 14;
		DeleteActionNotification delete_notification = 15;
		PresenceNotification presence_notification = 16;
		BlockNotification block_notification = 17;
		SetNotificationSettingNotification notification_setting_notification = 19;
		RichPresenceEnabledStateNotification rich_presence_enabled_state_notification = 20;
	}
}

message StateUpdateHeader {
	optional ActiveClientState active_client_state = 1;
	optional string request_trace_id = 3;
	optional NotificationSettings notification_settings = 4;
	optional uint64 current_server_time = 5;
}

message BatchUpdate {
	repeated StateUpdate state_update = 1;
}

message EventNotification {
	optional Event event = 1;
}

message SetFocusNotification {
	optional ConversationId conversation_id = 1;
	optional ParticipantId sender_id = 2;
	optional uint64 timestamp = 3;
	optional FocusType type = 4;
	optional FocusDevice device = 5;
}

message SetTypingNotification {
	optional ConversationId conversation_id = 1;
	optional ParticipantId sender_id = 2;
	optional uint64 timestamp = 3;
	optional TypingType type = 4;
}

message SetConversationNotificationLevelNotification {
	optional ConversationId conversation_id = 1;
	optional NotificationLevel level = 2;
	optional uint64 timestamp = 4;
}

message ReplyToInviteNotification {
	optional ConversationId conversation_id = 1;
	optional ReplyToInviteType type = 2;
}

message ConversationViewModification {
	optional ConversationId conversation_id = 1;
	optional ConversationView old_view = 2;
	optional ConversationView new_view = 3;
}

message EasterEggNotification {
	optional ParticipantId sender_id = 1;
	optional ConversationId conversation_id = 2;
	optional EasterEgg easter_egg = 3;
}

message SelfPresenceNotification {
	optional ClientPresenceState client_presence_state = 1;
	optional DoNotDisturbSetting do_not_disturb_setting = 3;
	optional DesktopOffSetting desktop_off_setting = 4;
	optional DesktopOffState desktop_off_state = 5;
	optional MoodState mood_state = 6;
}

message DeleteActionNotification {
	optional ConversationId conversation_id = 1;
	optional DeleteAction delete_action = 2;
}

message PresenceNotification {
	repeated PresenceResult presence = 1;
}

message BlockNotification {
	repeated BlockStateChange block_state_change = 1;
}

message SetNotificationSettingNotification {
	optional DesktopSoundSetting desktop_sound_setting = 2;
}

message RichPresenceEnabledStateNotification {
	repeated RichPresenceEnabledState rich_presence_enabled_state = 1;
}

message ConversationSpec {
	optional ConversationId conversation_id = 1;
}

message AddUserRequest {
	optional RequestHeader request_header = 1;
	repeated InviteeID invitee_id = 3;
	optional EventRequestHeader event_request_header = 5;
}

message AddUserResponse {
	optional ResponseHeader response_header = 1;
	optional Event created_event = 5;
}

message CreateConversationRequest {
	optional RequestHeader request_header = 1;
	optional ConversationType type = 2;
	optional uint64 client_generated_id = 3;
	optional string name = 4;
	repeated InviteeID invitee_id = 5;
}

message CreateConversationResponse {
	optional ResponseHeader response_header = 1;
	optional Conversation conversation = 2;
	optional bool new_conversation_created = 7;
}

message DeleteConversationRequest {
	optional RequestHeader request_header = 1;
	optional ConversationId conversation_id = 2;
	optional uint64 delete_upper_bound_timestamp = 3;
}

message DeleteConversationResponse {
	optional ResponseHeader response_header = 1;
	optional DeleteAction delete_action = 2;
}

message EasterEggRequest {
	optional RequestHeader request_header = 1;
	optional ConversationId conversation_id = 2;
	optional EasterEgg easter_egg = 3;
}

message EasterEggResponse {
	optional ResponseHeader response_header = 1;
	optional uint64 timestamp = 2;
}

message GetConversationRequest {
	optional RequestHeader request_header = 1;
	optional ConversationSpec conversation_spec = 2;
	optional bool include_event = 4;
	optional uint64 max_events_per_conversation = 6;
	optional EventContinuationToken event_continuation_token = 7;
}

message GetConversationResponse {
	optional ResponseHeader response_header = 1;
	optional ConversationState conversation_state = 2;
}

message GetEntityByIdRequest {
	optional RequestHeader request_header = 1;
	repeated EntityLookupSpec batch_lookup_spec = 3;
}

message GetEntityByIdResponse {
	optional ResponseHeader response_header = 1;
	repeated Entity entity = 2;
}

message GetSuggestedEntitiesRequest {
	optional RequestHeader request_header = 1;
	optional SuggestedContactGroupHash favorites = 8;
	optional SuggestedContactGroupHash contacts_you_hangout_with = 9;
	optional SuggestedContactGroupHash other_contacts_on_hangouts = 10;
	optional SuggestedContactGroupHash other_contacts = 11;
	optional SuggestedContactGroupHash dismissed_contacts = 12;
	optional SuggestedContactGroupHash pinned_favorites = 13;
}

message GetSuggestedEntitiesResponse {
	optional ResponseHeader response_header = 1;
	repeated Entity entity = 2;
	optional SuggestedContactGroup favorites = 4;
	optional SuggestedContactGroup contacts_you_hangout_with = 5;
	optional SuggestedContactGroup other_contacts_on_hangouts = 6;
	optional SuggestedContactGroup other_contacts = 7;
	optional SuggestedContactGroup dismissed_contacts = 8;
	optional SuggestedContactGroup pinned_favorites = 9;
}

message GetSelfInfoRequest {
	optional RequestHeader request_header = 1;
}

message QueryPresenceRequest {
	optional RequestHeader request_header = 1;
	repeated ParticipantId participant_id = 2;
	repeated FieldMask field_mask = 3;
}

message QueryPresenceResponse {
	optional ResponseHeader response_header = 1;
	repeated PresenceResult presence_result = 2;
}

message RemoveUserRequest {
	optional RequestHeader request_header = 1;
	optional EventRequestHeader event_request_header = 5;
}

message RemoveUserResponse {
	optional ResponseHeader response_header = 1;
	optional Event created_event = 4;
}

message RenameConversationRequest {
	optional RequestHeader request_header = 1;
	optional string new_name = 3;
	optional EventRequestHeader event_request_header = 5;
}

message RenameConversationResponse {
	optional ResponseHeader response_header = 1;
	optional Event created_event = 4;
}

message SearchEntitiesRequest {
	optional RequestHeader request_header = 1;
	optional string query = 3;
	optional uint64 max_count = 4;
}

message SearchEntitiesResponse {
	optional ResponseHeader response_header = 1;
	repeated Entity entity = 2;
}

message SendChatMessageRequest {
	optional RequestHeader request_header = 1;
	repeated EventAnnotation annotation = 5;
	optional MessageContent message_content = 6;
	optional ExistingMedia existing_media = 7;
	optional EventRequestHeader event_request_header = 8;
}

message SendChatMessageResponse {
	optional ResponseHeader response_header = 1;
	optional Event created_event = 6;
}

message SetActiveClientRequest {
	optional RequestHeader request_header = 1;
	optional bool is_active = 2;
	optional string full_jid = 3;
	optional uint64 timeout_secs = 4;
}

message SetActiveClientResponse {
	optional ResponseHeader response_header = 1;
}

message SetConversationLevelRequest {
	optional RequestHeader request_header = 1;
}

message SetConversationLevelResponse {
	optional ResponseHeader response_header = 1;
}

message SetConversationNotificationLevelRequest {
	optional RequestHeader request_header = 1;
	optional ConversationId conversation_id = 2;
	optional NotificationLevel level = 3;
}

message SetConversationNotificationLevelResponse {
	optional ResponseHeader response_header = 1;
	optional uint64 timestamp = 2;
}

message SetFocusRequest {
	optional RequestHeader request_header = 1;
	optional ConversationId conversation_id = 2;
	optional FocusType type = 3;
	optional uint32 timeout_secs = 4;
}

message SetFocusResponse {
	optional ResponseHeader response_header = 1;
	optional uint64 timestamp = 2;
}

message SetPresenceRequest {
	optional RequestHeader request_header = 1;
	optional PresenceStateSetting presence_state_setting = 2;
	optional DndSetting dnd_setting = 3;
	optional DesktopOffSetting desktop_off_setting = 5;
	optional MoodSetting mood_setting = 8;
}

message SetPresenceResponse {
	optional ResponseHeader response_header = 1;
}

message SetTypingRequest {
	optional RequestHeader request_header = 1;
	optional ConversationId conversation_id = 2;
	optional TypingType type = 3;
}

message SetTypingResponse {
	optional ResponseHeader response_header = 1;
	optional uint64 timestamp = 2;
}

message SyncAllNewEventsRequest {
	optional RequestHeader request_header = 1;
	optional uint64 last_sync_timestamp = 2;
	optional uint64 max_response_size_bytes = 8;
}

message SyncAllNewEventsResponse {
	optional ResponseHeader response_header = 1;
	optional uint64 sync_timestamp = 2;
	repeated ConversationState conversation_state = 3;
}

message SyncRecentConversationsRequest {
	optional RequestHeader request_header = 1;
	optional uint64 max_conversations = 3;
	optional uint64 max_events_per_conversation = 4;
	repeated SyncFilter sync_filter = 5;
}

message SyncRecentConversationsResponse {
	optional ResponseHeader response_header = 1;
	optional uint64 sync_timestamp = 2;
	repeated ConversationState conversation_state = 3;
}

message UpdateWatermarkRequest {
	optional RequestHeader request_header = 1;
	optional ConversationId conversation_id = 2;
	optional uint64 last_read_timestamp = 3;
}

message UpdateWatermarkResponse {
	optional ResponseHeader response_header = 1;
}
*/
