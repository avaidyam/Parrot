import Foundation

extension String {
	func substring(between start: String, and to: String) -> String? {
		return (rangeOfString(start)?.endIndex).flatMap { startIdx in
			(rangeOfString(to, range: startIdx..<endIndex)?.startIndex).map { endIdx in
				substringWithRange(startIdx..<endIdx)
			}
		}
	}
}

/// The representation of a Protobuf Field.
public struct ProtoField {
	
	let modifier: String
	let type: String
	let name: String
	let position: UInt
	
	var swiftType: String {
		get {
			return ProtoField.swiftType(self.type)
		}
	}
	
	/// Converts a `ProtoField` to a `String` representation.
	public func toSwift() -> String {
		
		// Sanitize and convert the field name and type first.
		let name = self.name ?? "_"
		let type = ProtoField.swiftType(self.type)
		
		// Select proper output view based on the field modifier.
		switch self.modifier {
		case "optional":
			return "public var \(name): \(type)? = nil"
		case "required":
			return "public var \(name) = \(type)()"
		case "repeated":
			return "public var \(name) = [\(type)]()"
		default: // fallthrough to optional
			return "public var \(name): \(type)? = nil"
		}
	}
	
	/// Converts a `ProtoField` to a `String` setter-only representation.
	public func setterCase() -> String {
		
		// Sanitize and convert the field name and type first.
		let name = self.name ?? "_"
		let type = ProtoField.swiftType(self.type)
		
		return "case \"\(self.name)\": self.\(name) = (value as? \(type))!"
	}
	
	/// Converts a `String` to a `ProtoField` representation.
	public static func fromString(str: String) -> ProtoField {
		let a = str
			.characters.split { $0 == " " }
			.map { String($0) }
			.filter { $0 != "=" }
		
		return ProtoField(modifier: a[0], type: a[1],
						  name: a[2], position: UInt(a[3])!)
	}
	
	/// Converts the Protobuf type to a native Swift type.
	public static func swiftType(type: String) -> String {
		switch type {
		case "string": return "String"
		case "bytes": return "String" // Data
		case "double": return "Double"
		case "float": return "Float"
		case "int32", "sint32", "sfixed32": return "Int32"
		case "int64", "sint64", "sfixed64": return "Int64"
		case "uint32", "fixed32": return "UInt32"
		case "uint64", "fixed64": return "UInt64"
		case "bool": return "Bool"
		default: return "AnyObject"
		}
	}
}

/// The representation of a Protobuf Message.
/// TODO: Support inner Messages, Enums, and Oneofs.
public struct ProtoMessage {
	
	var name: String
	let fields: [ProtoField]
	
	/// Disable to generate a class.
	public static var generateStruct = true
	
	public func generateFunctions() -> String {
		let a = ProtoMessage.generateStruct ? "mutating " : ""
		
		let top = "\tpublic \(a)func set(key: String, value: Any?) {\n\t\tswitch(key) {"
		let mid = "\t\t" + fields.map { $0.setterCase() }.reduce("") { $0 + "\n\t\t" + $1 }
		let bot = "\n\t\tdefault: break\n\t\t}\n\t}\n"
		
		return top + mid + bot
	}
	
	/// Converts a `ProtoMessage` to a `String` representation.
	public func toSwift() -> String {
		let a = ProtoMessage.generateStruct ? "struct" : "class"
		
		let decl = self.fields.map { $0.toSwift() }.reduce("") { $0 + "\n\t" + $1 }
		let funcs = self.generateFunctions()
		return "public \(a) \(self.name): Message {\(decl)\n\n\(funcs)\n}"
	}
	
	/// Converts a `String` to a `ProtoMessage` representation.
	public static func fromString(str: String) -> ProtoMessage {
		let name = str.substring(between: "message ", and: " {")!
		var fields = [ProtoField]()
		
		var scanned: UInt = 1
		str.substring(between: "{", and: "}")!
			.componentsSeparatedByString(";")
			.map {
				$0.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
			}.filter {
				!$0.isEmpty
			}.forEach { a in
				let p = ProtoField.fromString(a)
				fields.append(p)
				
				for r in (scanned..<p.position).dropFirst() {
					let f = ProtoField(modifier: "optional", type: "", name: "field\(r)", position: r)
					fields.append(f)
				}
				scanned = p.position
		}
		return ProtoMessage(name: name, fields: fields)
	}
	
	public mutating func set<T>(key: String, value: T) {
		switch(key) {
		case "name" where self.name.dynamicType is T.Type:
			if let value = value as? String { self.name = value }
		case "name" where !(self.name.dynamicType is T.Type):
			print("is not!")
		default: break
		}
	}
	
}

let str = "message HashModifier {\n\trequired string update_id = 1;\n\toptional uint64 hash_diff = 2;\n\toptional uint64 version = 4;\n}"
let str2 = "message Thumbnail {\n\toptional string url = 1;\n\toptional string image_url = 4;\n\toptional uint64 width_px = 10;\n\toptional uint64 height_px = 11;\n}\n\nmessage PlusPhoto {\n\toptional Thumbnail thumbnail = 1;\n\toptional string owner_obfuscated_id = 2;\n\toptional string album_id = 3;\n\toptional string photo_id = 4;\n\toptional string url = 6;\n\toptional string original_content_url = 10;\n\toptional MediaType media_type = 13;\n\trepeated string stream_id = 14;\n}\n\nmessage RepresentativeImage {\n\toptional string url = 2;\n}\n\nmessage Place {\n\toptional string url = 1;\n\toptional string name = 3;\n\toptional RepresentativeImage representative_image = 185;\n}\n\nmessage EmbedItem {\n\trepeated ItemType type = 1;\n\toptional string id = 2;\n\toptional PlusPhoto plus_photo = 3;\n\toptional Place place = 4;\n}\n\nmessage EventAnnotation {\n\toptional int32 type = 1;\n\toptional string value = 2;\n}\n\nmessage ChatMessage {\n\trepeated EventAnnotation annotation = 2;\n\toptional MessageContent message_content = 3;\n}\n\nmessage MembershipChange {\n\toptional MembershipChangeType type = 1;\n\trepeated ParticipantId participant_ids = 3;\n}\n\nmessage ConversationRename {\n\toptional string new_name = 1;\n\toptional string old_name = 2;\n}\n\nmessage HangoutEvent {\n\toptional HangoutEventType event_type = 1;\n\trepeated ParticipantId participant_id = 2;\n}\n\nmessage OTRModification {\n\toptional OffTheRecordStatus old_otr_status = 1;\n\toptional OffTheRecordStatus new_otr_status = 2;\n\toptional OffTheRecordToggle old_otr_toggle = 3;\n\toptional OffTheRecordToggle new_otr_toggle = 4;\n}\n\nmessage HashModifier {\n\toptional string update_id = 1;\n\toptional uint64 hash_diff = 2;\n\toptional uint64 version = 4;\n}\n\nmessage Event {\n\toptional ConversationId conversation_id = 1;\n\toptional ParticipantId sender_id = 2;\n\toptional uint64 timestamp = 3;\n\toptional UserEventState self_event_state = 4;\n\toptional SourceType source_type = 6;\n\toptional ChatMessage chat_message = 7;\n\toptional MembershipChange membership_change = 9;\n\toptional ConversationRename conversation_rename = 10;\n\toptional HangoutEvent hangout_event = 11;\n\toptional string event_id = 12;\n\toptional uint64 expiration_timestamp = 13;\n\toptional OTRModification otr_modification = 14;\n\toptional bool advances_sort_timestamp = 15;\n\toptional OffTheRecordStatus otr_status = 16;\n\toptional bool persisted = 17;\n\toptional DeliveryMedium medium_type = 20;\n\toptional EventType event_type = 23;\n\toptional uint64 event_version = 24;\n\toptional HashModifier hash_modifier = 26;\n}\n\nmessage UserReadState {\n\toptional ParticipantId participant_id = 1;\n\toptional uint64 latest_read_timestamp = 2;\n}\n\nmessage DeliveryMedium {\n\toptional DeliveryMediumType medium_type = 1;\n\toptional Phone phone = 2;\n}\n\nmessage DeliveryMediumOption {\n\toptional DeliveryMedium delivery_medium = 1;\n\toptional bool current_default = 2;\n}\n\nmessage UserConversationState {\n\toptional string client_generated_id = 2;\n\toptional UserReadState self_read_state = 7;\n\toptional ConversationStatus status = 8;\n\toptional NotificationLevel notification_level = 9;\n\trepeated ConversationView view = 10;\n\toptional ParticipantId inviter_id = 11;\n\toptional uint64 invite_timestamp = 12;\n\toptional uint64 sort_timestamp = 13;\n\toptional uint64 active_timestamp = 14;\n\trepeated DeliveryMediumOption delivery_medium_option = 17;\n}\n\nmessage ConversationParticipantData {\n\toptional ParticipantId id = 1;\n\toptional string fallback_name = 2;\n\toptional InvitationStatus invitation_status = 3;\n\toptional ParticipantType participant_type = 5;\n\toptional InvitationStatus new_invitation_status = 6;\n}\n\nmessage Conversation {\n\toptional ConversationId conversation_id = 1;\n\toptional ConversationType type = 2;\n\toptional string name = 3;\n\toptional UserConversationState self_conversation_state = 4;\n\trepeated UserReadState read_state = 8;\n\toptional bool has_active_hangout = 9;\n\toptional OffTheRecordStatus otr_status = 10;\n\toptional OffTheRecordToggle otr_toggle = 11;\n\toptional bool conversation_history_supported = 12;\n\trepeated ParticipantId current_participant = 13;\n\trepeated ConversationParticipantData participant_data = 14;\n\trepeated NetworkType network_type = 18;\n\toptional ForceHistory force_history_state = 19;\n}\n\nmessage EasterEgg {\n\toptional string message = 1;\n}\n\nmessage BlockStateChange {\n\toptional ParticipantId participant_id = 1;\n\toptional BlockState new_block_state = 2;\n}\n\nmessage Photo {\n\toptional string photo_id = 1;\n\toptional bool delete_albumless_source_photo = 2;\n\toptional string user_id = 3;\n\toptional bool is_custom_user_id = 4;\n}\n\nmessage ExistingMedia {\n\toptional Photo photo = 1;\n}\n\nmessage EventRequestHeader {\n\toptional ConversationId conversation_id = 1;\n\toptional uint64 client_generated_id = 2;\n\toptional OffTheRecordStatus expected_otr = 3;\n\toptional DeliveryMedium delivery_medium = 4;\n\toptional EventType event_type = 5;\n}\n\nmessage ClientVersion {\n\toptional ClientId client_id = 1;\n\toptional ClientBuildType build_type = 2;\n\toptional string major_version = 3;\n\toptional uint64 version_timestamp = 4;\n\toptional string device_os_version = 5;\n\toptional string device_hardware = 6;\n}\n\nmessage RequestHeader {\n\toptional ClientVersion client_version = 1;\n\toptional ClientIdentifier client_identifier = 2;\n\toptional string language_code = 4;\n}\n\nmessage Entity {\n\toptional Presence presence = 8;\n\toptional ParticipantId id = 9;\n\toptional EntityProperties properties = 10;\n\toptional ParticipantType entity_type = 13;\n\toptional PastHangoutState had_past_hangout_state = 16;\n}\n\nmessage EntityProperties {\n\toptional ProfileType type = 1;\n\toptional string display_name = 2;\n\toptional string first_name = 3;\n\toptional string photo_url = 4;\n\trepeated string email = 5;\n\trepeated string phone = 6;\n\toptional bool in_users_domain = 10;\n\toptional Gender gender = 11;\n\toptional PhotoUrlStatus photo_url_status = 12;\n\toptional string canonical_email = 15;\n}\n\nmessage ConversationState {\n\toptional ConversationId conversation_id = 1;\n\toptional Conversation conversation = 2;\n\trepeated Event event = 3;\n\toptional EventContinuationToken event_continuation_token = 5;\n}\n\nmessage EventContinuationToken {\n\toptional string event_id = 1;\n\toptional bytes storage_continuation_token = 2;\n\toptional uint64 event_timestamp = 3;\n}\n\nmessage EntityLookupSpec {\n\toptional string gaia_id = 1;\n}\n\nmessage RichPresenceState {\n\trepeated RichPresenceEnabledState get_rich_presence_enabled_state = 3;\n}\n\nmessage RichPresenceEnabledState {\n\toptional RichPresenceType type = 1;\n\toptional bool enabled = 2;\n}\n\nmessage DesktopOffSetting {\n\toptional bool desktop_off = 1;\n}\n\nmessage DesktopOffState {\n\toptional bool desktop_off = 1;\n\toptional uint64 version = 2;\n}\n\nmessage DndSetting {\n\toptional bool do_not_disturb = 1;\n\toptional uint64 timeout_secs = 2;\n}\n\nmessage PresenceStateSetting {\n\toptional uint64 timeout_secs = 1;\n\toptional ClientPresenceStateType type = 2;\n}\n\nmessage MoodMessage {\n\toptional MoodContent mood_content = 1;\n}\n\nmessage MoodContent {\n\trepeated Segment segment = 1;\n}\n\nmessage MoodSetting {\n\toptional MoodMessage mood_message = 1;\n}\n\nmessage MoodState {\n\toptional MoodSetting mood_setting = 4;\n}\n\nmessage DeleteAction {\n\toptional uint64 delete_action_timestamp = 1;\n\toptional uint64 delete_upper_bound_timestamp = 2;\n\toptional DeleteType delete_type = 3;\n}\n\nmessage InviteeID {\n\toptional string gaia_id = 1;\n\toptional string fallback_name = 4;\n}\n\nmessage Country {\n\toptional string region_code = 1;\n\toptional uint64 country_code = 2;\n}\n\nmessage DesktopSoundSetting {\n\toptional SoundState desktop_sound_state = 1;\n\toptional SoundState desktop_ring_sound_state = 2;\n}\n\nmessage PhoneData {\n\trepeated Phone phone = 1;\n\toptional CallerIdSettingsMask caller_id_settings_mask = 3;\n}\n\nmessage Phone {\n\toptional PhoneNumber phone_number = 1;\n\toptional bool google_voice = 2;\n\toptional PhoneVerificationStatus verification_status = 3;\n\toptional bool discoverable = 4;\n\toptional PhoneDiscoverabilityStatus discoverability_status = 5;\n\toptional bool primary = 6;\n}\n\nmessage I18nData {\n\toptional string national_number = 1;\n\toptional string international_number = 2;\n\toptional uint64 country_code = 3;\n\toptional string region_code = 4;\n\toptional bool is_valid = 5;\n\toptional PhoneValidationResult validation_result = 6;\n}\n\nmessage PhoneNumber {\n\toptional string e164 = 1;\n\toptional I18nData i18n_data = 2;\n}\n\nmessage SuggestedContactGroupHash {\n\toptional uint64 max_results = 1;\n\toptional bytes hash = 2;\n}\n\nmessage SuggestedContact {\n\toptional Entity entity = 1;\n\toptional InvitationStatus invitation_status = 2;\n}\n\nmessage SuggestedContactGroup {\n\toptional bool hash_matched = 1;\n\toptional bytes hash = 2;\n\trepeated SuggestedContact contact = 3;\n}\n\nmessage StateUpdateHeader {\n\toptional ActiveClientState active_client_state = 1;\n\toptional string request_trace_id = 3;\n\toptional NotificationSettings notification_settings = 4;\n\toptional uint64 current_server_time = 5;\n}\n\nmessage BatchUpdate {\n\trepeated StateUpdate state_update = 1;\n}\n\nmessage EventNotification {\n\toptional Event event = 1;\n}\n\nmessage SetFocusNotification {\n\toptional ConversationId conversation_id = 1;\n\toptional ParticipantId sender_id = 2;\n\toptional uint64 timestamp = 3;\n\toptional FocusType type = 4;\n\toptional FocusDevice device = 5;\n}\n\nmessage SetTypingNotification {\n\toptional ConversationId conversation_id = 1;\n\toptional ParticipantId sender_id = 2;\n\toptional uint64 timestamp = 3;\n\toptional TypingType type = 4;\n}\n\nmessage SetConversationNotificationLevelNotification {\n\toptional ConversationId conversation_id = 1;\n\toptional NotificationLevel level = 2;\n\toptional uint64 timestamp = 4;\n}\n\nmessage ReplyToInviteNotification {\n\toptional ConversationId conversation_id = 1;\n\toptional ReplyToInviteType type = 2;\n}\n\nmessage ConversationViewModification {\n\toptional ConversationId conversation_id = 1;\n\toptional ConversationView old_view = 2;\n\toptional ConversationView new_view = 3;\n}\n\nmessage EasterEggNotification {\n\toptional ParticipantId sender_id = 1;\n\toptional ConversationId conversation_id = 2;\n\toptional EasterEgg easter_egg = 3;\n}\n\nmessage SelfPresenceNotification {\n\toptional ClientPresenceState client_presence_state = 1;\n\toptional DoNotDisturbSetting do_not_disturb_setting = 3;\n\toptional DesktopOffSetting desktop_off_setting = 4;\n\toptional DesktopOffState desktop_off_state = 5;\n\toptional MoodState mood_state = 6;\n}\n\nmessage DeleteActionNotification {\n\toptional ConversationId conversation_id = 1;\n\toptional DeleteAction delete_action = 2;\n}\n\nmessage PresenceNotification {\n\trepeated PresenceResult presence = 1;\n}\n\nmessage BlockNotification {\n\trepeated BlockStateChange block_state_change = 1;\n}\n\nmessage SetNotificationSettingNotification {\n\toptional DesktopSoundSetting desktop_sound_setting = 2;\n}\n\nmessage RichPresenceEnabledStateNotification {\n\trepeated RichPresenceEnabledState rich_presence_enabled_state = 1;\n}\n\nmessage ConversationSpec {\n\toptional ConversationId conversation_id = 1;\n}\n\nmessage AddUserRequest {\n\toptional RequestHeader request_header = 1;\n\trepeated InviteeID invitee_id = 3;\n\toptional EventRequestHeader event_request_header = 5;\n}\n\nmessage AddUserResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional Event created_event = 5;\n}\n\nmessage CreateConversationRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationType type = 2;\n\toptional uint64 client_generated_id = 3;\n\toptional string name = 4;\n\trepeated InviteeID invitee_id = 5;\n}\n\nmessage CreateConversationResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional Conversation conversation = 2;\n\toptional bool new_conversation_created = 7;\n}\n\nmessage DeleteConversationRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationId conversation_id = 2;\n\toptional uint64 delete_upper_bound_timestamp = 3;\n}\n\nmessage DeleteConversationResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional DeleteAction delete_action = 2;\n}\n\nmessage EasterEggRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationId conversation_id = 2;\n\toptional EasterEgg easter_egg = 3;\n}\n\nmessage EasterEggResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional uint64 timestamp = 2;\n}\n\nmessage GetConversationRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationSpec conversation_spec = 2;\n\toptional bool include_event = 4;\n\toptional uint64 max_events_per_conversation = 6;\n\toptional EventContinuationToken event_continuation_token = 7;\n}\n\nmessage GetConversationResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional ConversationState conversation_state = 2;\n}\n\nmessage GetEntityByIdRequest {\n\toptional RequestHeader request_header = 1;\n\trepeated EntityLookupSpec batch_lookup_spec = 3;\n}\n\nmessage GetEntityByIdResponse {\n\toptional ResponseHeader response_header = 1;\n\trepeated Entity entity = 2;\n}\n\nmessage GetSuggestedEntitiesRequest {\n\toptional RequestHeader request_header = 1;\n\toptional SuggestedContactGroupHash favorites = 8;\n\toptional SuggestedContactGroupHash contacts_you_hangout_with = 9;\n\toptional SuggestedContactGroupHash other_contacts_on_hangouts = 10;\n\toptional SuggestedContactGroupHash other_contacts = 11;\n\toptional SuggestedContactGroupHash dismissed_contacts = 12;\n\toptional SuggestedContactGroupHash pinned_favorites = 13;\n}\n\nmessage GetSuggestedEntitiesResponse {\n\toptional ResponseHeader response_header = 1;\n\trepeated Entity entity = 2;\n\toptional SuggestedContactGroup favorites = 4;\n\toptional SuggestedContactGroup contacts_you_hangout_with = 5;\n\toptional SuggestedContactGroup other_contacts_on_hangouts = 6;\n\toptional SuggestedContactGroup other_contacts = 7;\n\toptional SuggestedContactGroup dismissed_contacts = 8;\n\toptional SuggestedContactGroup pinned_favorites = 9;\n}\n\nmessage GetSelfInfoRequest {\n\toptional RequestHeader request_header = 1;\n}\n\nmessage QueryPresenceRequest {\n\toptional RequestHeader request_header = 1;\n\trepeated ParticipantId participant_id = 2;\n\trepeated FieldMask field_mask = 3;\n}\n\nmessage QueryPresenceResponse {\n\toptional ResponseHeader response_header = 1;\n\trepeated PresenceResult presence_result = 2;\n}\n\nmessage RemoveUserRequest {\n\toptional RequestHeader request_header = 1;\n\toptional EventRequestHeader event_request_header = 5;\n}\n\nmessage RemoveUserResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional Event created_event = 4;\n}\n\nmessage RenameConversationRequest {\n\toptional RequestHeader request_header = 1;\n\toptional string new_name = 3;\n\toptional EventRequestHeader event_request_header = 5;\n}\n\nmessage RenameConversationResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional Event created_event = 4;\n}\n\nmessage SearchEntitiesRequest {\n\toptional RequestHeader request_header = 1;\n\toptional string query = 3;\n\toptional uint64 max_count = 4;\n}\n\nmessage SearchEntitiesResponse {\n\toptional ResponseHeader response_header = 1;\n\trepeated Entity entity = 2;\n}\n\nmessage SendChatMessageRequest {\n\toptional RequestHeader request_header = 1;\n\trepeated EventAnnotation annotation = 5;\n\toptional MessageContent message_content = 6;\n\toptional ExistingMedia existing_media = 7;\n\toptional EventRequestHeader event_request_header = 8;\n}\n\nmessage SendChatMessageResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional Event created_event = 6;\n}\n\nmessage SetActiveClientRequest {\n\toptional RequestHeader request_header = 1;\n\toptional bool is_active = 2;\n\toptional string full_jid = 3;\n\toptional uint64 timeout_secs = 4;\n}\n\nmessage SetActiveClientResponse {\n\toptional ResponseHeader response_header = 1;\n}\n\nmessage SetConversationLevelRequest {\n\toptional RequestHeader request_header = 1;\n}\n\nmessage SetConversationLevelResponse {\n\toptional ResponseHeader response_header = 1;\n}\n\nmessage SetConversationNotificationLevelRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationId conversation_id = 2;\n\toptional NotificationLevel level = 3;\n}\n\nmessage SetConversationNotificationLevelResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional uint64 timestamp = 2;\n}\n\nmessage SetFocusRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationId conversation_id = 2;\n\toptional FocusType type = 3;\n\toptional uint32 timeout_secs = 4;\n}\n\nmessage SetFocusResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional uint64 timestamp = 2;\n}\n\nmessage SetPresenceRequest {\n\toptional RequestHeader request_header = 1;\n\toptional PresenceStateSetting presence_state_setting = 2;\n\toptional DndSetting dnd_setting = 3;\n\toptional DesktopOffSetting desktop_off_setting = 5;\n\toptional MoodSetting mood_setting = 8;\n}\n\nmessage SetPresenceResponse {\n\toptional ResponseHeader response_header = 1;\n}\n\nmessage SetTypingRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationId conversation_id = 2;\n\toptional TypingType type = 3;\n}\n\nmessage SetTypingResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional uint64 timestamp = 2;\n}\n\nmessage SyncAllNewEventsRequest {\n\toptional RequestHeader request_header = 1;\n\toptional uint64 last_sync_timestamp = 2;\n\toptional uint64 max_response_size_bytes = 8;\n}\n\nmessage SyncAllNewEventsResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional uint64 sync_timestamp = 2;\n\trepeated ConversationState conversation_state = 3;\n}\n\nmessage SyncRecentConversationsRequest {\n\toptional RequestHeader request_header = 1;\n\toptional uint64 max_conversations = 3;\n\toptional uint64 max_events_per_conversation = 4;\n\trepeated SyncFilter sync_filter = 5;\n}\n\nmessage SyncRecentConversationsResponse {\n\toptional ResponseHeader response_header = 1;\n\toptional uint64 sync_timestamp = 2;\n\trepeated ConversationState conversation_state = 3;\n}\n\nmessage UpdateWatermarkRequest {\n\toptional RequestHeader request_header = 1;\n\toptional ConversationId conversation_id = 2;\n\toptional uint64 last_read_timestamp = 3;\n}\n\nmessage UpdateWatermarkResponse {\n\toptional ResponseHeader response_header = 1;\n}"

print(ProtoMessage.fromString(str).toSwift())
print("\n\n\n\n\n")

var a = ProtoMessage.fromString(str)
a.set("name", value: 42)

/*let all = str2.componentsSeparatedByString("}\n")
	.map { $0 + "}\n" }
	.map { ProtoMessage.fromString($0).toSwift() }
	.reduce("") { $0 + "\n\n" + $1 }
print(all)*/
