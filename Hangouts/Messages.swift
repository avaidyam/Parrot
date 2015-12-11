import Foundation

/* TODO: Support `oneof` and nested `Message` types. */
/* TODO: Step away from using NS* types with Swift reflection. */
/* TODO: Convert to Swift `Enum` types. */

/****************************************
*										*
*				  ENUMS 				*
*										*
****************************************/

@objc(ActiveClientState)
class ActiveClientState : Enum {
	static let NO_ACTIVE_CLIENT: ActiveClientState = 0
	static let IS_ACTIVE_CLIENT: ActiveClientState = 1
	static let OTHER_CLIENT_IS_ACTIVE: ActiveClientState = 2
}

@objc(FocusType)
class FocusType : Enum {
	static let UNKNOWN: FocusType = 0
	static let FOCUSED: FocusType = 1
	static let UNFOCUSED: FocusType = 2
}

@objc(FocusDevice)
class FocusDevice : Enum {
	static let UNSPECIFIED: FocusDevice = 0
	static let DESKTOP: FocusDevice = 20
	static let MOBILE: FocusDevice = 300
}

@objc(TypingType)
class TypingType : Enum {
	static let UNKNOWN: TypingType = 0
	static let STARTED: TypingType = 1
	static let PAUSED: TypingType = 2
	static let STOPPED: TypingType = 3
}

@objc(ClientPresenceStateType)
class ClientPresenceStateType : Enum {
	static let UNKNOWN: ClientPresenceStateType = 0
	static let NONE: ClientPresenceStateType = 1
	static let DESKTOP_IDLE: ClientPresenceStateType = 30
	static let DESKTOP_ACTIVE: ClientPresenceStateType = 40
}

@objc(NotificationLevel)
class NotificationLevel : Enum {
	static let UNKNOWN: NotificationLevel = 0
	static let QUIET: NotificationLevel = 10
	static let RING: NotificationLevel = 30
}

@objc(SegmentType)
class SegmentType : Enum {
	static let TEXT: SegmentType = 0
	static let LINE_BREAK: SegmentType = 1
	static let LINK: SegmentType = 2
}

@objc(ItemType)
class ItemType : Enum {
	static let THING: SegmentType = 0
	static let PLUS_PHOTO: SegmentType = 249
	static let PLACE: SegmentType = 335
	static let PLACE_V2: SegmentType = 340
}

@objc(MediaType)
class MediaType : Enum {
	static let UNKNOWN: MediaType = 0
	static let PHOTO: MediaType = 1
}

@objc(MembershipChangeType)
class MembershipChangeType : Enum {
	static let JOIN: MembershipChangeType = 1
	static let LEAVE: MembershipChangeType = 2
}

@objc(HangoutEventType)
class HangoutEventType : Enum {
	static let UNKNOWN: HangoutEventType = 0
	static let START: HangoutEventType = 1
	static let END: HangoutEventType = 2
	static let JOIN: HangoutEventType = 3
	static let LEAVE: HangoutEventType = 4
	static let COMING_SOON: HangoutEventType = 5
	static let ONGOING: HangoutEventType = 6
}

@objc(OffTheRecordToggle)
class OffTheRecordToggle : Enum {
	static let UNKNOWN: OffTheRecordToggle = 0
	static let ENABLED: OffTheRecordToggle = 1
	static let DISABLED: OffTheRecordToggle = 2
}

@objc(OffTheRecordStatus)
class OffTheRecordStatus : Enum {
	static let UNKNOWN: OffTheRecordStatus = 0
	static let OFF_THE_RECORD: OffTheRecordStatus = 1
	static let ON_THE_RECORD: OffTheRecordStatus = 2
}

@objc(SourceType)
class SourceType : Enum {
	static let UNKNOWN: SourceType = 0
}

@objc(EventType)
class EventType : Enum {
	static let UNKNOWN: SourceType = 0
	static let REGULAR_CHAT_MESSAGE: SourceType = 1
	static let SMS: SourceType = 2
	static let VOICEMAIL: SourceType = 3
	static let ADD_USER: SourceType = 4
	static let REMOVE_USER: SourceType = 5
	static let CONVERSATION_RENAME: SourceType = 6
	static let HANGOUT: SourceType = 7
	static let PHONE_CALL: SourceType = 8
	static let OTR_MODIFICATION: SourceType = 9
	static let PLAN_MUTATION: SourceType = 10
	static let MMS: SourceType = 11
	static let DEPRECATED_12: SourceType = 12
}

@objc(ConversationType)
class ConversationType : Enum {
	static let UNKNOWN: ConversationType = 0
	static let ONE_TO_ONE: ConversationType = 1
	static let GROUP: ConversationType = 2
}

@objc(ConversationStatus)
class ConversationStatus : Enum {
	static let UNKNOWN: ConversationStatus = 0
	static let INVITED: ConversationStatus = 1
	static let ACTIVE: ConversationStatus = 2
	static let LEFT: ConversationStatus = 3
}

@objc(ConversationView)
class ConversationView : Enum {
	static let UNKNOWN: ConversationView = 0
	static let INBOX: ConversationView = 1
	static let ARCHIVED: ConversationView = 2
}

@objc(DeliveryMediumType)
class DeliveryMediumType : Enum {
	static let UNKNOWN: DeliveryMediumType = 0
	static let BABEL: DeliveryMediumType = 1
	static let GOOGLE_VOICE: DeliveryMediumType = 2
	static let LOCAL_SMS: DeliveryMediumType = 3
}

@objc(ParticipantType)
class ParticipantType : Enum {
	static let UNKNOWN: ParticipantType = 0
	static let GAIA: ParticipantType = 2
}

@objc(InvitationStatus)
class InvitationStatus : Enum {
	static let UNKNOWN: InvitationStatus = 0
	static let PENDING: InvitationStatus = 1
	static let ACCEPTED: InvitationStatus = 2
}

@objc(ForceHistory)
class ForceHistory : Enum {
	static let UNKNOWN: ForceHistory = 0
	static let NO: ForceHistory = 1
}

@objc(NetworkType)
class NetworkType : Enum {
	static let UNKNOWN: NetworkType = 0
	static let BABEL: NetworkType = 1
}

@objc(BlockState)
class BlockState : Enum {
	static let UNKNOWN: BlockState = 0
	static let BLOCK: BlockState = 1
	static let UNBLOCK: BlockState = 1
}

@objc(ReplyToInviteType)
class ReplyToInviteType : Enum {
	static let UNKNOWN: ReplyToInviteType = 0
	static let ACCEPT: ReplyToInviteType = 1
	static let DECLINE: ReplyToInviteType = 1
}

@objc(ClientID)
class ClientID : Enum {
	static let UNKNOWN: ClientID = 0
	static let ANDROID: ClientID = 1
	static let IOS: ClientID = 2
	static let CHROME: ClientID = 3
	static let WEB_GPLUS: ClientID = 5
	static let WEB_GMAIL: ClientID = 6
	static let ULTRAVIOLET: ClientID = 13
}

@objc(ClientBuildType)
class ClientBuildType : Enum {
	static let UNKNOWN: ClientBuildType = 0
	static let PRODUCTION_WEB: ClientBuildType = 1
	static let PRODUCTION_APP: ClientBuildType = 3
}

@objc(ResponseStatus)
class ResponseStatus : Enum {
	static let UNKNOWN: ResponseStatus = 0
	static let OK: ResponseStatus = 1
	static let UNEXPECTED_ERROR: ResponseStatus = 3
	static let INVALID_REQUEST: ResponseStatus = 4
}

@objc(PastHangoutState)
class PastHangoutState : Enum {
	static let UNKNOWN: PastHangoutState = 0
	static let HAD_PAST_HANGOUT: PastHangoutState = 1
	static let NO_PAST_HANGOUT: PastHangoutState = 2
}

@objc(PhotoURLStatus)
class PhotoURLStatus : Enum {
	static let UNKNOWN: PhotoURLStatus = 0
	static let PLACEHOLDER: PhotoURLStatus = 1
	static let USER_PHOTO: PhotoURLStatus = 2
}

@objc(Gender)
class Gender : Enum {
	static let UNKNOWN: Gender = 0
	static let MALE: Gender = 1
	static let FEMALE: Gender = 2
}

@objc(ProfileType)
class ProfileType : Enum {
	static let NONE: ProfileType = 0
	static let ES_USER: ProfileType = 1
}

@objc(ConfigurationBitType)
class ConfigurationBitType : Enum {
	static let UNKNOWN: ConfigurationBitType = 0
	// TODO
}

@objc(RichPresenceType)
class RichPresenceType : Enum {
	static let UNKNOWN: RichPresenceType = 0
	static let IN_CALL_STATE: RichPresenceType = 1
	static let DEVICE: RichPresenceType = 2
	static let LAST_SEEN: RichPresenceType = 6
}

@objc(FieldMask)
class FieldMask : Enum {
	static let REACHABLE: FieldMask = 1
	static let AVAILABLE: FieldMask = 2
	static let DEVICE: FieldMask = 7
}

@objc(DeleteType)
class DeleteType : Enum {
	static let UNKNOWN: DeleteType = 0
	static let UPPER_BOUND: DeleteType = 1
}

@objc(SyncFilter)
class SyncFilter : Enum  {
	static let UNKNOWN: SyncFilter = 0;
	static let INBOX: SyncFilter = 1;
	static let ARCHIVED: SyncFilter = 2;
}

@objc(SoundState)
class SoundState : Enum  {
	static let UNKNOWN: SoundState = 0;
	static let ON: SoundState = 1;
	static let OFF: SoundState = 2;
}

@objc(CallerIDSettingsMask)
class CallerIDSettingsMask : Enum  {
	static let UNKNOWN: CallerIDSettingsMask = 0;
	static let PROVIDED: CallerIDSettingsMask = 1;
}

@objc(PhoneVerificationStatus)
class PhoneVerificationStatus : Enum  {
	static let UNKNOWN: PhoneVerificationStatus = 0;
	static let VERIFIED: PhoneVerificationStatus = 1;
}

@objc(PhoneDiscoverabilityStatus)
class PhoneDiscoverabilityStatus : Enum  {
	static let UNKNOWN: PhoneDiscoverabilityStatus = 0;
	static let OPTED_IN_BUT_NOT_DISCOVERABLE: PhoneDiscoverabilityStatus = 2;
}

@objc(PhoneValidationResult)
class PhoneValidationResult : Enum  {
	static let IS_POSSIBLE: PhoneValidationResult = 0;
}

/****************************************
 *										*
 *				MESSAGES				*
 *										*
 ****************************************/

@objc(CONVERSATION_ID)
class CONVERSATION_ID : Message {
    var id: NSString = ""
}

@objc(USER_ID)
class USER_ID : Message {
    var gaia_id: NSString = ""
    var chat_id: NSString = ""
}

@objc(CLIENT_SET_TYPING_NOTIFICATION)
class CLIENT_SET_TYPING_NOTIFICATION : Message {
    var conversation_id = CONVERSATION_ID()
    var user_id = USER_ID()
    var timestamp: NSNumber = 0
    var status: TypingType = 0
}

@objc(CLIENT_SET_FOCUS_NOTIFICATION)
class CLIENT_SET_FOCUS_NOTIFICATION : Message {
    var conversation_id = CONVERSATION_ID()
    var user_id = USER_ID()
    var timestamp: NSString = ""
    var status: FocusType = 0
    var device: FocusDevice?
}

@objc(CLIENT_CONVERSATION_READ_STATE)
class CLIENT_CONVERSATION_READ_STATE : Message {
    var participant_id = USER_ID()
    var latest_read_timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
}

@objc(CLIENT_CONVERSATION_INTERNAL_STATE)
class CLIENT_CONVERSATION_INTERNAL_STATE : Message {
    var field1: AnyObject? = nil
    var field2: AnyObject? = nil
    var field3: AnyObject? = nil
    var field4: AnyObject? = nil
    var field5: AnyObject? = nil
    var field6: AnyObject? = nil

    var self_read_state = CLIENT_CONVERSATION_READ_STATE()

    var status: ConversationStatus = 0
    var notification_level: NotificationLevel = 0

    var view = [ConversationView]()

    var inviter_id = USER_ID()
    var invite_timestamp: NSString = ""
    var sort_timestamp: NSDate?
    var active_timestamp: NSDate?

    var field7: AnyObject? = nil
    var field8: AnyObject? = nil
    var field9: AnyObject? = nil
    var field10: AnyObject? = nil
}

@objc(CLIENT_CONVERSATION_PARTICIPANT_DATA)
class CLIENT_CONVERSATION_PARTICIPANT_DATA : Message {
    var id = USER_ID()
    var fallback_name: NSString?
    var field: AnyObject? = nil
}

@objc(CLIENT_CONVERSATION)
class CLIENT_CONVERSATION : Message {
	var conversation_id: CONVERSATION_ID? = nil //FIXME
    var type = ConversationType()
    var name: NSString?
    var self_conversation_state = CLIENT_CONVERSATION_INTERNAL_STATE()
    var field5: AnyObject? = nil
    var field6: AnyObject? = nil
    var field7: AnyObject? = nil
    var read_state = [CLIENT_CONVERSATION_READ_STATE]()
    var has_active_hangout: NSNumber = 0
    var otr_status: OffTheRecordStatus = 0
    var otr_toggle: AnyObject? = nil
    var conversation_history_supported: AnyObject? = nil
    var current_participant = [USER_ID]()
    var participant_data = [CLIENT_CONVERSATION_PARTICIPANT_DATA]()
    var field15: AnyObject? = nil
    var field16: AnyObject? = nil
    var field17: AnyObject? = nil
    var network_type: AnyObject? = nil
    var force_history_state: AnyObject? = nil
}

//  Unfortunately, some of PBLite's introspection
//  uses string-based class lookup, and nested
//  classes have mangled names. So, we need to use
//  only non-nested classes here.
@objc(MESSAGE_SEGMENT_FORMATTING)
class MESSAGE_SEGMENT_FORMATTING : Message {
    var bold: NSNumber?
    var italic: NSNumber?
    var strikethrough: NSNumber?
    var underline: NSNumber?
}

@objc(MESSAGE_SEGMENT_LINK_DATA)
class MESSAGE_SEGMENT_LINK_DATA : Message {
    var link_target: NSString?
}

@objc(MESSAGE_SEGMENT)
class MESSAGE_SEGMENT : Message {
    var type: SegmentType = 0
    var text: NSString?

    var formatting: MESSAGE_SEGMENT_FORMATTING? = MESSAGE_SEGMENT_FORMATTING()

    var link_data: MESSAGE_SEGMENT_LINK_DATA? = MESSAGE_SEGMENT_LINK_DATA()
}

@objc(MESSAGE_ATTACHMENT_EMBED_ITEM)
class MESSAGE_ATTACHMENT_EMBED_ITEM : Message {
    var type = NSArray()
    var data = NSDictionary()
}

@objc(MESSAGE_ATTACHMENT)
class MESSAGE_ATTACHMENT : Message {
    var embed_item = MESSAGE_ATTACHMENT_EMBED_ITEM()
}

@objc(CLIENT_CHAT_MESSAGE_CONTENT)
class CLIENT_CHAT_MESSAGE_CONTENT : Message {
    var segment: [MESSAGE_SEGMENT]?
    var attachment: [MESSAGE_ATTACHMENT]?
}

@objc(CLIENT_CHAT_MESSAGE)
class CLIENT_CHAT_MESSAGE : Message {
    var field1: AnyObject? = nil
    var annotation: NSArray?
    var message_content = CLIENT_CHAT_MESSAGE_CONTENT()
}

@objc(CLIENT_CONVERSATION_RENAME)
class CLIENT_CONVERSATION_RENAME : Message {
    var new_name: NSString = ""
    var old_name: NSString = ""
}

@objc(CLIENT_HANGOUT_EVENT)
class CLIENT_HANGOUT_EVENT : Message {
    var event_type: HangoutEventType = 0
    var participant_id = [USER_ID]()
    var hangout_duration_secs: NSNumber?
    var transferred_conversation_id: NSString?
    var refresh_timeout_secs: NSNumber?
    var is_periodic_refresh: NSNumber?
    var field1: AnyObject? = nil
}

@objc(CLIENT_OTR_MODIFICATION)
class CLIENT_OTR_MODIFICATION : Message {
    var old_otr_status: OffTheRecordStatus = 0
    var new_otr_status: OffTheRecordStatus = 0
    var old_otr_toggle: OffTheRecordToggle = 0
    var new_otr_toggle: OffTheRecordToggle = 0
}

@objc(CLIENT_MEMBERSHIP_CHANGE)
class CLIENT_MEMBERSHIP_CHANGE : Message {
    var type: MembershipChangeType = 0
    var field1 = NSArray()
    var participant_ids = [USER_ID]()
    var field2: AnyObject? = nil
}

@objc(CLIENT_EVENT_STATE)
class CLIENT_EVENT_STATE : Message {
    var user_id = USER_ID()
    var client_generated_id: AnyObject? = nil
    var notification_level: NotificationLevel = 0
}

@objc(CLIENT_EVENT)
class CLIENT_EVENT : Message {
    var conversation_id = CONVERSATION_ID()
    var sender_id = USER_ID()
    var timestamp: NSDate = NSDate(timeIntervalSince1970: 0)
	var self_event_state : CLIENT_EVENT_STATE?
	var field5: AnyObject? = nil
    var source_type: AnyObject? = nil
	var chat_message: CLIENT_CHAT_MESSAGE? = nil
    var field8: AnyObject? = nil
    var membership_change: CLIENT_MEMBERSHIP_CHANGE?
    var conversation_rename: CLIENT_CONVERSATION_RENAME?
    var hangout_event: CLIENT_HANGOUT_EVENT?
	var event_id: NSString?
	var expiration_timestamp: AnyObject? = nil
	var otr_modification: CLIENT_OTR_MODIFICATION?
	var advances_sort_timestamp: NSDate?
	var otr_status: OffTheRecordStatus = 0
	var persisted: AnyObject? = nil
	var field18: AnyObject? = nil
	var field19: AnyObject? = nil
    var medium_type: AnyObject? = nil
	var field21: AnyObject? = nil
	var field22: AnyObject? = nil
	var event_type: AnyObject? = nil
	var event_version: AnyObject? = nil
	var field25: AnyObject? = nil
	var hash_modifier: AnyObject? = nil
}

@objc(CLIENT_EVENT_NOTIFICATION)
class CLIENT_EVENT_NOTIFICATION : Message {
    var event = CLIENT_EVENT()
}

@objc(CLIENT_WATERMARK_NOTIFICATION)
class CLIENT_WATERMARK_NOTIFICATION : Message {
    var participant_id = USER_ID()
    var conversation_id = CONVERSATION_ID()
    var latest_read_timestamp: NSNumber = 0
}

@objc(CLIENT_STATE_UPDATE_HEADER)
class CLIENT_STATE_UPDATE_HEADER : Message {
    var active_client_state: ActiveClientState = 0
    var field1: AnyObject? = nil
    var request_trace_id: NSString = ""
    var field2: AnyObject? = nil
    var current_server_time: NSString = ""
    var field3: AnyObject? = nil
    var field4: AnyObject? = nil
    var updating_client_id: AnyObject? = nil
}

@objc(CLIENT_STATE_UPDATE)
class CLIENT_STATE_UPDATE : Message {
    var state_update_header = CLIENT_STATE_UPDATE_HEADER()
    var conversation_notification: AnyObject? = nil
    var event_notification: CLIENT_EVENT_NOTIFICATION?
    var focus_notification = CLIENT_SET_FOCUS_NOTIFICATION()
    var typing_notification: CLIENT_SET_TYPING_NOTIFICATION?
    var notification_level_notification: AnyObject? = nil
    var reply_to_invite_notification: AnyObject? = nil
    var watermark_notification: CLIENT_WATERMARK_NOTIFICATION?
    var field1: AnyObject? = nil
    var settings_notification: AnyObject? = nil
    var view_modification: AnyObject? = nil
    var easter_egg_notification: AnyObject? = nil
    var client_conversation: CLIENT_CONVERSATION?
    var self_presence_notification: AnyObject? = nil
    var delete_notification: AnyObject? = nil
    var presence_notification: AnyObject? = nil
    var block_notification: AnyObject? = nil
    var invitation_watermark_notification: AnyObject? = nil
}

@objc(CLIENT_EVENT_CONTINUATION_TOKEN)
class CLIENT_EVENT_CONTINUATION_TOKEN : Message {
    var event_id: NSString?
    var storage_continuation_token: NSString = ""
    var event_timestamp: NSString = ""
}

@objc(CLIENT_CONVERSATION_STATE)
class CLIENT_CONVERSATION_STATE : Message {
    var conversation_id = CONVERSATION_ID()
    var conversation = CLIENT_CONVERSATION()
    var event = [CLIENT_EVENT]()
    var field1: AnyObject? = nil
    var event_continuation_token: CLIENT_EVENT_CONTINUATION_TOKEN?
    //var field2: AnyObject? = nil
    //var field3: AnyObject? = nil
}

@objc(CLIENT_ENTITY_PROPERTIES)
class CLIENT_ENTITY_PROPERTIES : Message {
    var type: NSNumber?
    var display_name: NSString?
    var first_name: NSString?
    var photo_url: NSString?
    var emails = NSArray()
}

@objc(CLIENT_ENTITY)
class CLIENT_ENTITY : Message {
    var field1: AnyObject? = nil
    var field2: AnyObject? = nil
    var field3: AnyObject? = nil
    var field4: AnyObject? = nil
    var field5: AnyObject? = nil
    var field6: AnyObject? = nil
    var field7: AnyObject? = nil
    var field8: AnyObject? = nil
    var id = USER_ID()

    var properties = CLIENT_ENTITY_PROPERTIES()
}

@objc(ENTITY_GROUP_ENTITY)
class ENTITY_GROUP_ENTITY : Message {
    var entity = CLIENT_ENTITY()
    var field1: AnyObject? = nil
}

@objc(ENTITY_GROUP)
class ENTITY_GROUP : Message {
    var field1: AnyObject? = nil
    var some_sort_of_id: AnyObject? = nil

    var entity = [ENTITY_GROUP_ENTITY]()
}

@objc(INITIAL_CLIENT_ENTITIES)
class INITIAL_CLIENT_ENTITIES : Message {
    var cgserp: NSString = ""
    var header: AnyObject? = nil
    var entities = [CLIENT_ENTITY]()
    var field1: AnyObject? = nil
    var group1 = ENTITY_GROUP()
    var group2 = ENTITY_GROUP()
    var group3 = ENTITY_GROUP()
    var group4 = ENTITY_GROUP()
    var group5 = ENTITY_GROUP()
}

@objc(CLIENT_GET_SELF_INFO_RESPONSE)
class CLIENT_GET_SELF_INFO_RESPONSE : Message {
    var cgsirp: NSString = ""
    var response_header: AnyObject? = nil
    var self_entity = CLIENT_ENTITY()
}

@objc(CLIENT_RESPONSE_HEADER)
class CLIENT_RESPONSE_HEADER : Message {
    var status: NSString = ""
    var field1: AnyObject? = nil
    var field2: AnyObject? = nil
    var request_trace_id: NSString = ""
    var current_server_time: NSString = ""
}

@objc(CLIENT_SYNC_ALL_NEW_EVENTS_RESPONSE)
class CLIENT_SYNC_ALL_NEW_EVENTS_RESPONSE : Message {
    var csanerp: NSString = ""
    var response_header = CLIENT_RESPONSE_HEADER()
    var sync_timestamp: NSString = ""
    var conversation_state = [CLIENT_CONVERSATION_STATE]()
}

@objc(CLIENT_GET_CONVERSATION_RESPONSE)
class CLIENT_GET_CONVERSATION_RESPONSE : Message {
    var cgcrp: NSString = ""
    var response_header = CLIENT_RESPONSE_HEADER()
    var conversation_state = CLIENT_CONVERSATION_STATE()
}

@objc(CLIENT_GET_ENTITY_BY_ID_RESPONSE)
class CLIENT_GET_ENTITY_BY_ID_RESPONSE : Message {
    var cgebirp: NSString = ""
    var response_header = CLIENT_RESPONSE_HEADER()
    var entities = [CLIENT_ENTITY]()
}
