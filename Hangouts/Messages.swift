import Foundation

/* TODO: Support `oneof` and nested `Message` types. */
/* TODO: Step away from using NS* types with Swift reflection. */
/* TODO: Convert to Swift `enum` and `struct` types. */

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

@objc(CONVERSATION_ID)
public class CONVERSATION_ID : Message {
    public var id: NSString = ""
}

@objc(USER_ID)
public class USER_ID : Message {
    public var gaia_id: NSString = ""
    public var chat_id: NSString = ""
}

@objc(CLIENT_SET_TYPING_NOTIFICATION)
public class CLIENT_SET_TYPING_NOTIFICATION : Message {
    public var conversation_id = CONVERSATION_ID()
    public var user_id = USER_ID()
    public var timestamp: NSNumber = 0
    public var status: TypingType = 0
}

@objc(CLIENT_SET_FOCUS_NOTIFICATION)
public class CLIENT_SET_FOCUS_NOTIFICATION : Message {
    public var conversation_id = CONVERSATION_ID()
    public var user_id = USER_ID()
    public var timestamp: NSString = ""
    public var status: FocusType = 0
    public var device: FocusDevice?
}

@objc(CLIENT_CONVERSATION_READ_STATE)
public class CLIENT_CONVERSATION_READ_STATE : Message {
    public var participant_id = USER_ID()
    public var latest_read_timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
}

@objc(CLIENT_CONVERSATION_INTERNAL_STATE)
public class CLIENT_CONVERSATION_INTERNAL_STATE : Message {
    public var field1: AnyObject? = nil
    public var field2: AnyObject? = nil
    public var field3: AnyObject? = nil
    public var field4: AnyObject? = nil
    public var field5: AnyObject? = nil
    public var field6: AnyObject? = nil

    public var self_read_state = CLIENT_CONVERSATION_READ_STATE()

    public var status: ConversationStatus = 0
    public var notification_level: NotificationLevel = 0

    public var view = [ConversationView]()

    public var inviter_id = USER_ID()
    public var invite_timestamp: NSString = ""
    public var sort_timestamp: NSDate?
    public var active_timestamp: NSDate?

    public var field7: AnyObject? = nil
    public var field8: AnyObject? = nil
    public var field9: AnyObject? = nil
    public var field10: AnyObject? = nil
}

@objc(CLIENT_CONVERSATION_PARTICIPANT_DATA)
public class CLIENT_CONVERSATION_PARTICIPANT_DATA : Message {
    public var id = USER_ID()
    public var fallback_name: NSString?
    public var field: AnyObject? = nil
}

@objc(CLIENT_CONVERSATION)
public class CLIENT_CONVERSATION : Message {
	public var conversation_id: CONVERSATION_ID? = nil //FIXME
    public var type = ConversationType()
    public var name: NSString?
    public var self_conversation_state = CLIENT_CONVERSATION_INTERNAL_STATE()
    public var field5: AnyObject? = nil
    public var field6: AnyObject? = nil
    public var field7: AnyObject? = nil
    public var read_state = [CLIENT_CONVERSATION_READ_STATE]()
    public var has_active_hangout: NSNumber = 0
    public var otr_status: OffTheRecordStatus = 0
    public var otr_toggle: AnyObject? = nil
    public var conversation_history_supported: AnyObject? = nil
    public var current_participant = [USER_ID]()
    public var participant_data = [CLIENT_CONVERSATION_PARTICIPANT_DATA]()
    public var field15: AnyObject? = nil
    public var field16: AnyObject? = nil
    public var field17: AnyObject? = nil
    public var network_type: AnyObject? = nil
    public var force_history_state: AnyObject? = nil
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

    public var formatting: MESSAGE_SEGMENT_FORMATTING? = MESSAGE_SEGMENT_FORMATTING()

    public var link_data: MESSAGE_SEGMENT_LINK_DATA? = MESSAGE_SEGMENT_LINK_DATA()
}

@objc(MESSAGE_ATTACHMENT_EMBED_ITEM)
public class MESSAGE_ATTACHMENT_EMBED_ITEM : Message {
    public var type = NSArray()
    public var data = NSDictionary()
}

@objc(MESSAGE_ATTACHMENT)
public class MESSAGE_ATTACHMENT : Message {
    public var embed_item = MESSAGE_ATTACHMENT_EMBED_ITEM()
}

@objc(CLIENT_CHAT_MESSAGE_CONTENT)
public class CLIENT_CHAT_MESSAGE_CONTENT : Message {
    public var segment: [MESSAGE_SEGMENT]?
    public var attachment: [MESSAGE_ATTACHMENT]?
}

@objc(CLIENT_CHAT_MESSAGE)
public class CLIENT_CHAT_MESSAGE : Message {
    public var field1: AnyObject? = nil
    public var annotation: NSArray?
    public var message_content = CLIENT_CHAT_MESSAGE_CONTENT()
}

@objc(CLIENT_CONVERSATION_RENAME)
public class CLIENT_CONVERSATION_RENAME : Message {
    public var new_name: NSString = ""
    public var old_name: NSString = ""
}

@objc(CLIENT_HANGOUT_EVENT)
public class CLIENT_HANGOUT_EVENT : Message {
    public var event_type: HangoutEventType = 0
    public var participant_id = [USER_ID]()
    public var hangout_duration_secs: NSNumber?
    public var transferred_conversation_id: NSString?
    public var refresh_timeout_secs: NSNumber?
    public var is_periodic_refresh: NSNumber?
    public var field1: AnyObject? = nil
}

@objc(CLIENT_OTR_MODIFICATION)
public class CLIENT_OTR_MODIFICATION : Message {
    public var old_otr_status: OffTheRecordStatus = 0
    public var new_otr_status: OffTheRecordStatus = 0
    public var old_otr_toggle: OffTheRecordToggle = 0
    public var new_otr_toggle: OffTheRecordToggle = 0
}

@objc(CLIENT_MEMBERSHIP_CHANGE)
public class CLIENT_MEMBERSHIP_CHANGE : Message {
    public var type: MembershipChangeType = 0
    public var field1 = NSArray()
    public var participant_ids = [USER_ID]()
    public var field2: AnyObject? = nil
}

@objc(CLIENT_EVENT_STATE)
public class CLIENT_EVENT_STATE : Message {
    public var user_id = USER_ID()
    public var client_generated_id: AnyObject? = nil
    public var notification_level: NotificationLevel = 0
}

@objc(CLIENT_EVENT)
public class CLIENT_EVENT : Message {
    public var conversation_id = CONVERSATION_ID()
    public var sender_id = USER_ID()
    public var timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
	public var self_event_state : CLIENT_EVENT_STATE?
	public var field5: AnyObject? = nil
    public var source_type: AnyObject? = nil
	public var chat_message: CLIENT_CHAT_MESSAGE? = nil
    public var field8: AnyObject? = nil
    public var membership_change: CLIENT_MEMBERSHIP_CHANGE?
    public var conversation_rename: CLIENT_CONVERSATION_RENAME?
    public var hangout_event: CLIENT_HANGOUT_EVENT?
	public var event_id: NSString?
	public var expiration_timestamp: AnyObject? = nil
	public var otr_modification: CLIENT_OTR_MODIFICATION?
	public var advances_sort_timestamp: NSDate?
	public var otr_status: OffTheRecordStatus = 0
	public var persisted: AnyObject? = nil
	public var field18: AnyObject? = nil
	public var field19: AnyObject? = nil
    public var medium_type: AnyObject? = nil
	public var field21: AnyObject? = nil
	public var field22: AnyObject? = nil
	public var event_type: AnyObject? = nil
	public var event_version: AnyObject? = nil
	public var field25: AnyObject? = nil
	public var hash_modifier: AnyObject? = nil
}

@objc(CLIENT_EVENT_NOTIFICATION)
public class CLIENT_EVENT_NOTIFICATION : Message {
    public var event = CLIENT_EVENT()
}

@objc(CLIENT_WATERMARK_NOTIFICATION)
public class CLIENT_WATERMARK_NOTIFICATION : Message {
    public var participant_id = USER_ID()
    public var conversation_id = CONVERSATION_ID()
    public var latest_read_timestamp: NSNumber = 0
}

@objc(CLIENT_STATE_UPDATE_HEADER)
public class CLIENT_STATE_UPDATE_HEADER : Message {
    public var active_client_state: ActiveClientState = 0
    public var field1: AnyObject? = nil
    public var request_trace_id: NSString = ""
    public var field2: AnyObject? = nil
    public var current_server_time: NSString = ""
    public var field3: AnyObject? = nil
    public var field4: AnyObject? = nil
    public var updating_client_id: AnyObject? = nil
}

@objc(CLIENT_STATE_UPDATE)
public class CLIENT_STATE_UPDATE : Message {
    public var state_update_header = CLIENT_STATE_UPDATE_HEADER()
    public var conversation_notification: AnyObject? = nil
    public var event_notification: CLIENT_EVENT_NOTIFICATION?
    public var focus_notification = CLIENT_SET_FOCUS_NOTIFICATION()
    public var typing_notification: CLIENT_SET_TYPING_NOTIFICATION?
    public var notification_level_notification: AnyObject? = nil
    public var reply_to_invite_notification: AnyObject? = nil
    public var watermark_notification: CLIENT_WATERMARK_NOTIFICATION?
    public var field1: AnyObject? = nil
    public var settings_notification: AnyObject? = nil
    public var view_modification: AnyObject? = nil
    public var easter_egg_notification: AnyObject? = nil
    public var client_conversation: CLIENT_CONVERSATION?
    public var self_presence_notification: AnyObject? = nil
    public var delete_notification: AnyObject? = nil
    public var presence_notification: AnyObject? = nil
    public var block_notification: AnyObject? = nil
    public var invitation_watermark_notification: AnyObject? = nil
}

@objc(CLIENT_EVENT_CONTINUATION_TOKEN)
public class CLIENT_EVENT_CONTINUATION_TOKEN : Message {
    public var event_id: NSString?
    public var storage_continuation_token: NSString = ""
    public var event_timestamp: NSString = ""
}

@objc(CLIENT_CONVERSATION_STATE)
public class CLIENT_CONVERSATION_STATE : Message {
    public var conversation_id = CONVERSATION_ID()
    public var conversation = CLIENT_CONVERSATION()
    public var event = [CLIENT_EVENT]()
    public var field1: AnyObject? = nil
    public var event_continuation_token: CLIENT_EVENT_CONTINUATION_TOKEN?
    //public var field2: AnyObject? = nil
    //public var field3: AnyObject? = nil
}

@objc(CLIENT_ENTITY_PROPERTIES)
public class CLIENT_ENTITY_PROPERTIES : Message {
    public var type: NSNumber?
    public var display_name: NSString?
    public var first_name: NSString?
    public var photo_url: NSString?
    public var emails = NSArray()
}

@objc(CLIENT_ENTITY)
public class CLIENT_ENTITY : Message {
    public var field1: AnyObject? = nil
    public var field2: AnyObject? = nil
    public var field3: AnyObject? = nil
    public var field4: AnyObject? = nil
    public var field5: AnyObject? = nil
    public var field6: AnyObject? = nil
    public var field7: AnyObject? = nil
    public var field8: AnyObject? = nil
    public var id = USER_ID()

    public var properties = CLIENT_ENTITY_PROPERTIES()
}

@objc(ENTITY_GROUP_ENTITY)
public class ENTITY_GROUP_ENTITY : Message {
    public var entity = CLIENT_ENTITY()
    public var field1: AnyObject? = nil
}

@objc(ENTITY_GROUP)
public class ENTITY_GROUP : Message {
    public var field1: AnyObject? = nil
    public var some_sort_of_id: AnyObject? = nil

    public var entity = [ENTITY_GROUP_ENTITY]()
}

@objc(INITIAL_CLIENT_ENTITIES)
public class INITIAL_CLIENT_ENTITIES : Message {
    public var cgserp: NSString = ""
    public var header: AnyObject? = nil
    public var entities = [CLIENT_ENTITY]()
    public var field1: AnyObject? = nil
    public var group1 = ENTITY_GROUP()
    public var group2 = ENTITY_GROUP()
    public var group3 = ENTITY_GROUP()
    public var group4 = ENTITY_GROUP()
    public var group5 = ENTITY_GROUP()
}

@objc(CLIENT_GET_SELF_INFO_RESPONSE)
public class CLIENT_GET_SELF_INFO_RESPONSE : Message {
    public var cgsirp: NSString = ""
    public var response_header: AnyObject? = nil
    public var self_entity = CLIENT_ENTITY()
}

@objc(CLIENT_RESPONSE_HEADER)
public class CLIENT_RESPONSE_HEADER : Message {
    public var status: NSString = ""
    public var field1: AnyObject? = nil
    public var field2: AnyObject? = nil
    public var request_trace_id: NSString = ""
    public var current_server_time: NSString = ""
}

@objc(CLIENT_SYNC_ALL_NEW_EVENTS_RESPONSE)
public class CLIENT_SYNC_ALL_NEW_EVENTS_RESPONSE : Message {
    public var csanerp: NSString = ""
    public var response_header = CLIENT_RESPONSE_HEADER()
    public var sync_timestamp: NSString = ""
    public var conversation_state = [CLIENT_CONVERSATION_STATE]()
}

@objc(CLIENT_GET_CONVERSATION_RESPONSE)
public class CLIENT_GET_CONVERSATION_RESPONSE : Message {
    public var cgcrp: NSString = ""
    public var response_header = CLIENT_RESPONSE_HEADER()
    public var conversation_state = CLIENT_CONVERSATION_STATE()
}

@objc(CLIENT_GET_ENTITY_BY_ID_RESPONSE)
public class CLIENT_GET_ENTITY_BY_ID_RESPONSE : Message {
    public var cgebirp: NSString = ""
    public var response_header = CLIENT_RESPONSE_HEADER()
    public var entities = [CLIENT_ENTITY]()
}
