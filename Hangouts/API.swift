import Foundation
import Mocha

// Generate 64-bit random value in a range that is divisible by upper_bound:
// from @martin-r: http://stackoverflow.com/questions/26549830/swift-random-number-for-64-bit-integers
private func random64(_ upper_bound: UInt64) -> UInt64 {
	let range = UInt64.max - UInt64.max % upper_bound
	var rnd: UInt64 = 0
	repeat {
		arc4random_buf(&rnd, MemoryLayout.size(ofValue: rnd))
	} while rnd >= range
	return rnd % upper_bound
}

// Since we can't use nil in JSON arrays due to the parser.
internal let None = NSNull()

/// Client API Operation Support
fileprivate extension Client {
	
	// Use this method for constructing request messages when calling Hangouts APIs.
	fileprivate func getRequestHeader() -> [Any] {
		return [
			[None /* 6 */, None /* 3 */, "parrot", None, None, None],
			[(self.client_id ?? None) as Any, None],
			None,
			"en"
		]
	}
	
	// Use this method for constructing request messages when calling Hangouts APIs.
	fileprivate func generateClientID() -> UInt64 {
		return random64(UInt64(pow(2.0, 32.0)))
	}
}

/// Client API Operations
public extension Client {
	
	// Add user to existing conversation.
	// conversation_id must be a valid conversation ID.
	// chat_id_list is list of users which should be invited to conversation.
    public func addUser(conversation_id: String, chat_id_list: [String], cb: @escaping (AddUserResponse?) -> Void = {_ in}) {
		let each = chat_id_list.map { [$0, None, None, "unknown", None, []] }
		let data = [
			self.getRequestHeader(),
			None,
			each,
			None,
			[
				[conversation_id],
				NSNumber(value: self.generateClientID()),
				2, None, 4
			]
		] as [Any]
		self.channel?.request(endpoint: "conversations/adduser", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Create new conversation.
	// chat_id_list is list of users which should be invited to conversation (except from yourself).
	public func createConversation(chat_id_list: [String], force_group: Bool = false,
	                               cb: @escaping (CreateConversationResponse?) -> Void = {_ in}) {
		let each = chat_id_list.map { [$0, None, None, "unknown", None, []] }
		let data = [
			self.getRequestHeader(),
			(chat_id_list.count == 1 && !force_group) ? 1 : 2,
			NSNumber(value: self.generateClientID()),
			None,
			each
		] as [Any]
		self.channel?.request(endpoint: "conversations/createconversation", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Delete one-to-one conversation.
	// conversation_id must be a valid conversation ID.
	public func deleteConversation(conversation_id: String, cb: @escaping (DeleteConversationResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			
			// Not sure what timestamp should be there, last time I have tried
			// it Hangouts client in GMail sent something like now() - 5 hours
			NSNumber(value: UInt64(Date().toUTC())),
			None,
			[]
		] as [Any]
		self.channel?.request(endpoint: "conversations/deleteconversation", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Send a easteregg to a conversation.
	public func sendEasterEgg(conversation_id: String, easteregg: String, cb: @escaping (EasterEggResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			[easteregg, None, 1],
        ] as [Any]
		self.channel?.request(endpoint: "conversations/easteregg", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Return conversation events.
	// This is mainly used for retrieving conversation scrollback. Events
	// occurring before event_timestamp are returned, in order from oldest to
	// newest.
	public func getConversation(
		conversation_id: String,
		event_timestamp: Date,
		includeMetadata: Bool = true,
		max_events: Int = 50,
		cb: @escaping (GetConversationResponse?) -> Void)
	{
		let data = [
			self.getRequestHeader(),
			[
				[conversation_id],
				[],
				[]
			],  // conversationSpec
			includeMetadata,  // includeConversationMetadata
			true,  // includeEvents
			None,  // ???
			max_events,  // maxEventsPerConversation
			[
				None,  // eventId
				None,  // storageContinuationToken
				NSNumber(value: UInt64(event_timestamp.toUTC()))//to_timestamp(date: event_timestamp),  // eventTimestamp
			] // eventContinuationToken (specifying timestamp is sufficient)
		] as [Any]
		
		self.channel?.request(endpoint: "conversations/getconversation", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Return information about a list of contacts.
	public func getEntitiesByID(chat_id_list: [String], cb: @escaping (GetEntityByIdResponse?) -> Void) {
		guard chat_id_list.count > 0 else { cb(nil); return }
		let data = [
			self.getRequestHeader(),
			None, // ignore lookup_spec for the batch_lookup_spec below
			chat_id_list.map { [$0] },
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] // doesn't work?
		] as [Any]
		self.channel?.request(endpoint: "contacts/getentitybyid", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func getSelfInfo(cb: @escaping ((GetSelfInfoResponse?) -> Void)) {
		let data = [
			self.getRequestHeader()
		] as [Any]
		self.channel?.request(endpoint: "contacts/getselfinfo", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func getSuggestedEntities(max_count: Int, cb: @escaping ((GetSuggestedEntitiesResponse?) -> Void)) {
		let data = [
			self.getRequestHeader(),
			None,
			None,
			max_count
		] as [Any]
		self.channel?.request(endpoint: "contacts/getsuggestedentities", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func queryPresence(chat_ids: [String] = [],
	                          reachable: Bool = true,
	                          available: Bool = true,
	                          mood: Bool = true,
	                          inCall: Bool = true,
	                          device: Bool = true,
	                          lastSeen: Bool = true,
	                          cb: @escaping ((QueryPresenceResponse?) -> Void)) {
		guard chat_ids.count > 0 else {
			print("Cannot query presence for zero chat IDs!")
			return
		}
		
		let data = [
			self.getRequestHeader(),
			chat_ids.map { [$0] },
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] // what are FieldMasks 4, 5, 8, 9?
		] as [Any]
		self.channel?.request(endpoint: "presence/querypresence", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Leave group conversation.
	// conversation_id must be a valid conversation ID.
    public func removeUser(conversation_id: String, cb: @escaping (RemoveUserResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			None,
			None,
			None,
			[
				[conversation_id],
				NSNumber(value: self.generateClientID()),
				2
			],
        ] as [Any]
		self.channel?.request(endpoint: "conversations/removeuser", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Set the name of a conversation.
	public func renameConversation(conversation_id: String, name: String, cb: @escaping (RenameConversationResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			None,
			name,
			None,
			[
				[conversation_id],
				NSNumber(value: self.generateClientID()),
				1
			]
		] as [Any]
		self.channel?.request(endpoint: "conversations/renameconversation", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Search for people.
	public func searchEntities(search_string: String, max_results: Int, cb: @escaping (SearchEntitiesResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[],
			search_string,
			max_results,
        ] as [Any]
		self.channel?.request(endpoint: "conversations/searchentities", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Send a chat message to a conversation.
	// conversation_id must be a valid conversation ID. segments must be a
	// list of message segments to send, in pblite format.
	// otr_status determines whether the message will be saved in the server's
	// chat history. Note that the OTR status of the conversation is
	// irrelevant, clients may send messages with whatever OTR status they
	// like.
	// image_id is an option ID of an image retrieved from
	// Client.upload_image. If provided, the image will be attached to the
	// message.
	public func sendChatMessage(conversation_id: String,
	                            segments: [[Any]],
	                            image_id: String? = nil,
	                            image_user_id: String? = nil,
	                            otr_status: OffTheRecordStatus = .OnTheRecord,
	                            delivery_medium: DeliveryMediumType = .Babel,
	                            cb: @escaping (SendChatMessageResponse?) -> Void = {_ in})
	{
		// Support sending images from other user id's.
		var a: Any
		if image_id != nil {
			if image_user_id != nil {
				a = [[image_id!, false, image_user_id!, true]]
			} else {
				a = [[image_id!, false, None, false]]
			}
		} else {
			a = None
		}
		
		let data = [
			self.getRequestHeader(),
			None,
			None,
			None,
			[], //EventAnnotation
			[ //MessageContent
				segments,
				[]
			],
			a, // it's too long for one line! // ExistingMedia
			[ //EventRequestHeader
				[conversation_id],
				NSNumber(value: self.generateClientID()),
				NSNumber(value: otr_status.rawValue),
				[NSNumber(value: delivery_medium.rawValue), None],
				NSNumber(value: delivery_medium == .Babel ? EventType.RegularChatMessage.rawValue : EventType.Sms.rawValue)
			]
		] as [Any]
		
		self.channel?.request(endpoint: "conversations/sendchatmessage", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func setActiveClient(is_active: Bool, timeout_secs: Int,
	                            cb: @escaping (SetActiveClientResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			is_active, // whether the client is active or not
			"\(self.email!)/" + (self.client_id ?? ""), // full_jid: user@domain/resource
			timeout_secs // timeout in seconds for this client to be active
		] as [Any]
		
		// Set the active client.
		self.channel?.request(endpoint: "clients/setactiveclient", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func setConversationNotificationLevel(conversation_id: String, level: NotificationLevel = .Ring,
	                                             cb: @escaping (SetConversationNotificationLevelResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			level.rawValue
		] as [Any]
		self.channel?.request(endpoint: "conversations/setconversationnotificationlevel", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Set focus (occurs whenever you give focus to a client).
	public func setFocus(conversation_id: String, focused: Bool = true,
	                     cb: @escaping (SetFocusResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			focused ? 1 : 2,
			20
		] as [Any]
		self.channel?.request(endpoint: "conversations/setfocus", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func setPresence(online: Bool, mood: String?,
	                        cb: @escaping (SetPresenceResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[
				720, // timeout_secs timeout in seconds for this presence
				
				//client_presence_state:
				// 40 => DESKTOP_ACTIVE
				// 30 => DESKTOP_IDLE
				// 1 => nil
				(online ? 1 : 40)
			],
			None,
			None,
			[!online], // True if going offline, False if coming online
			[(mood ?? None) as Any] // UTF-8 smiley like 0x1f603
		] as [Any]
		self.channel?.request(endpoint: "presence/setpresence", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Send typing notification.
	public func setTyping(conversation_id: String, typing: TypingType = TypingType.Started,
	                      cb: @escaping (SetTypingResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			NSNumber(value: typing.rawValue)
		] as [Any]
		self.channel?.request(endpoint: "conversations/settyping", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// List all events occurring at or after a timestamp.
	public func syncAllNewEvents(timestamp: Date, cb: @escaping (SyncAllNewEventsResponse?) -> Void) {
		let data = [
			self.getRequestHeader(),
			NSNumber(value: UInt64(timestamp.toUTC())),//to_timestamp(date: timestamp),
			[],
			None,
			[],
			false,
			[], // TODO: [[["UgyJ67sRgIpUbr_mp2R4AaABAQ"], 1496247974047340]]
			1048576 // max_response_size_bytes
		] as [Any]
		self.channel?.request(endpoint: "conversations/syncallnewevents", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
		
		// This method requests protojson rather than json so we have one chat
		// message parser rather than two.
		// timestamp: datetime.datetime instance specifying the time after
		// which to return all events occurring in.
	}
	
	// Return info on recent conversations and their events.
	// If since is nil, get latest.
	public func syncRecentConversations(maxConversations: Int = 25,
	                                    maxEventsPer: Int = 1,
	                                    since: Date? = nil,
	                                    cb: @escaping ((SyncRecentConversationsResponse?) -> Void)) {
		let data = [
			self.getRequestHeader(),
			(since?.toUTC() ?? None) as Any, // if refreshing, provide timestamp?
			maxConversations,
			maxEventsPer,
			[SyncFilter.Inbox.rawValue, 3, 4], // [3, 4] = ??
			None, // ??
			true, // ??
			[] // ??
		] as [Any]
        self.channel?.request(endpoint: "conversations/syncrecentconversations", body: data, use_json: false) { r in
            cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Update the watermark (read timestamp) for a conversation.
	public func updateWatermark(conv_id: String, read_timestamp: Date, cb: @escaping (UpdateWatermarkResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conv_id], // conversation_id
			NSNumber(value: UInt64(read_timestamp.toUTC()))//to_timestamp(date: ), // latest_read_timestamp
		] as [Any]
		self.channel?.request(endpoint: "conversations/updatewatermark", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
}
