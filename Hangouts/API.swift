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

public extension RequestHeader {
    public static func header(for clientID: String? = "") -> RequestHeader {
        return RequestHeader(client_version: ClientVersion(major_version: "parrot"),
                             client_identifier: ClientIdentifier(resource: clientID),
                             language_code: "en")
    }
}

public extension EventRequestHeader {
    public mutating func withID() -> EventRequestHeader {
        self.client_generated_id = random64(UInt64(pow(2.0, 32.0)))
        return self
    }
}

extension AddUserRequest: ServiceRequest {}
extension AddUserResponse: ServiceResponse {}
public enum AddUser: ServiceEndpoint {
    typealias Request = AddUserRequest
    typealias Response = AddUserResponse
    static let location: String = "conversations/adduser"
}

extension CreateConversationRequest: ServiceRequest {}
extension CreateConversationResponse: ServiceResponse {}
public enum CreateConversation: ServiceEndpoint {
    typealias Request = CreateConversationRequest
    typealias Response = CreateConversationResponse
    static let location: String = "conversations/createconversation"
}

extension DeleteConversationRequest: ServiceRequest {}
extension DeleteConversationResponse: ServiceResponse {}
public enum DeleteConversation: ServiceEndpoint {
    typealias Request = DeleteConversationRequest
    typealias Response = DeleteConversationResponse
    static let location: String = "conversations/deleteconversation"
}

extension EasterEggRequest: ServiceRequest {}
extension EasterEggResponse: ServiceResponse {}
public enum SendEasterEgg: ServiceEndpoint {
    typealias Request = EasterEggRequest
    typealias Response = EasterEggResponse
    static let location: String = "conversations/easteregg"
}

extension GetConversationRequest: ServiceRequest {}
extension GetConversationResponse: ServiceResponse {}
public enum GetConversation: ServiceEndpoint {
    typealias Request = GetConversationRequest
    typealias Response = GetConversationResponse
    static let location: String = "conversations/getconversation"
}

extension GetEntityByIdRequest: ServiceRequest {}
extension GetEntityByIdResponse: ServiceResponse {}
public enum GetEntityById: ServiceEndpoint {
    typealias Request = GetEntityByIdRequest
    typealias Response = GetEntityByIdResponse
    static let location: String = "contacts/getentitybyid"
}

extension GetSuggestedEntitiesRequest: ServiceRequest {}
extension GetSuggestedEntitiesResponse: ServiceResponse {}
public enum GetSuggestedEntities: ServiceEndpoint {
    typealias Request = GetSuggestedEntitiesRequest
    typealias Response = GetSuggestedEntitiesResponse
    static let location: String = "contacts/getsuggestedentities"
}

extension QueryPresenceRequest: ServiceRequest {}
extension QueryPresenceResponse: ServiceResponse {}
public enum QueryPresence: ServiceEndpoint {
    typealias Request = QueryPresenceRequest
    typealias Response = QueryPresenceResponse
    static let location: String = "presence/querypresence"
}

extension RemoveUserRequest: ServiceRequest {}
extension RemoveUserResponse: ServiceResponse {}
public enum RemoveUser: ServiceEndpoint {
    typealias Request = RemoveUserRequest
    typealias Response = RemoveUserResponse
    static let location: String = "conversations/removeuser"
}

extension RenameConversationRequest: ServiceRequest {}
extension RenameConversationResponse: ServiceResponse {}
public enum RenameConversation: ServiceEndpoint {
    typealias Request = RenameConversationRequest
    typealias Response = RenameConversationResponse
    static let location: String = "conversations/renameconversation"
}

extension SearchEntitiesRequest: ServiceRequest {}
extension SearchEntitiesResponse: ServiceResponse {}
public enum SearchEntities: ServiceEndpoint {
    typealias Request = SearchEntitiesRequest
    typealias Response = SearchEntitiesResponse
    static let location: String = "conversations/searchentities"
}

extension SendChatMessageRequest: ServiceRequest {}
extension SendChatMessageResponse: ServiceResponse {}
public enum SendChatMessage: ServiceEndpoint {
    typealias Request = SendChatMessageRequest
    typealias Response = SendChatMessageResponse
    static let location: String = "conversations/sendchatmessage"
}

extension SetActiveClientRequest: ServiceRequest {}
extension SetActiveClientResponse: ServiceResponse {}
public enum SetActiveClient: ServiceEndpoint {
    typealias Request = SetActiveClientRequest
    typealias Response = SetActiveClientResponse
    static let location: String = "clients/setactiveclient"
}

extension SetConversationNotificationLevelRequest: ServiceRequest {}
extension SetConversationNotificationLevelResponse: ServiceResponse {}
public enum SetConversationNotificationLevel: ServiceEndpoint {
    typealias Request = SetConversationNotificationLevelRequest
    typealias Response = SetConversationNotificationLevelResponse
    static let location: String = "conversations/setconversationnotificationlevel"
}

extension SetFocusRequest: ServiceRequest {}
extension SetFocusResponse: ServiceResponse {}
public enum SetFocus: ServiceEndpoint {
    typealias Request = SetFocusRequest
    typealias Response = SetFocusResponse
    static let location: String = "conversations/setfocus"
}

extension GetSelfInfoRequest: ServiceRequest {}
extension GetSelfInfoResponse: ServiceResponse {}
public enum GetSelfInfo: ServiceEndpoint {
    typealias Request = GetSelfInfoRequest
    typealias Response = GetSelfInfoResponse
    static let location: String = "contacts/getselfinfo"
}

extension SetPresenceRequest: ServiceRequest {}
extension SetPresenceResponse: ServiceResponse {}
public enum SetPresence: ServiceEndpoint {
    typealias Request = SetPresenceRequest
    typealias Response = SetPresenceResponse
    static let location: String = "presence/setpresence"
}

extension SetTypingRequest: ServiceRequest {}
extension SetTypingResponse: ServiceResponse {}
public enum SetTyping: ServiceEndpoint {
    typealias Request = SetTypingRequest
    typealias Response = SetTypingResponse
    static let location: String = "conversations/settyping"
}

extension SyncAllNewEventsRequest: ServiceRequest {}
extension SyncAllNewEventsResponse: ServiceResponse {}
public enum SyncAllNewEvents: ServiceEndpoint {
    typealias Request = SyncAllNewEventsRequest
    typealias Response = SyncAllNewEventsResponse
    static let location: String = "conversations/syncallnewevents"
}

extension SyncRecentConversationsRequest: ServiceRequest {}
extension SyncRecentConversationsResponse: ServiceResponse {}
public enum SyncRecentConversations: ServiceEndpoint {
    typealias Request = SyncRecentConversationsRequest
    typealias Response = SyncRecentConversationsResponse
    static let location: String = "conversations/syncrecentconversations"
}

extension UpdateWatermarkRequest: ServiceRequest {}
extension UpdateWatermarkResponse: ServiceResponse {}
public enum UpdateWatermark: ServiceEndpoint {
    typealias Request = UpdateWatermarkRequest
    typealias Response = UpdateWatermarkResponse
    static let location: String = "conversations/updatewatermark"
}









//
// LEGACY
//









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
	
	// Create new conversation.
	// chat_id_list is list of users which should be invited to conversation (except from yourself).
    @available(*, deprecated)
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
            cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Delete one-to-one conversation.
	// conversation_id must be a valid conversation ID.
    @available(*, deprecated)
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
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Return conversation events.
	// This is mainly used for retrieving conversation scrollback. Events
	// occurring before event_timestamp are returned, in order from oldest to
	// newest.
    @available(*, deprecated)
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
				None,  // event_id
				None,  // storageContinuationToken
				NSNumber(value: UInt64(event_timestamp.toUTC()))//to_timestamp(date: event_timestamp),  // eventTimestamp
			] // eventContinuationToken (specifying timestamp is sufficient)
		] as [Any]
		
		self.channel?.request(endpoint: "conversations/getconversation", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Return information about a list of contacts.
    @available(*, deprecated)
	public func getEntitiesByID(chat_id_list: [String], cb: @escaping (GetEntityByIdResponse?) -> Void) {
		guard chat_id_list.count > 0 else { cb(nil); return }
		let data = [
			self.getRequestHeader(),
			None, // ignore lookup_spec for the batch_lookup_spec below
			chat_id_list.map { [$0] },
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] // doesn't work?
		] as [Any]
		self.channel?.request(endpoint: "contacts/getentitybyid", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
    
    @available(*, deprecated)
	public func getSuggestedEntities(max_count: Int, cb: @escaping ((GetSuggestedEntitiesResponse?) -> Void)) {
		let data = [
			self.getRequestHeader(),
			None,
			None,
			max_count
		] as [Any]
		self.channel?.request(endpoint: "contacts/getsuggestedentities", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
    
    @available(*, deprecated)
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
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Leave group conversation.
	// conversation_id must be a valid conversation ID.
    @available(*, deprecated)
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
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Set the name of a conversation.
    @available(*, deprecated)
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
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Search for people.
    @available(*, deprecated)
	public func searchEntities(search_string: String, max_results: Int, cb: @escaping (SearchEntitiesResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[],
			search_string,
			max_results,
        ] as [Any]
		self.channel?.request(endpoint: "conversations/searchentities", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
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
    @available(*, deprecated)
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
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
    
    @available(*, deprecated)
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
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
    
    @available(*, deprecated)
	public func setConversationNotificationLevel(conversation_id: String, level: NotificationLevel = .Ring,
	                                             cb: @escaping (SetConversationNotificationLevelResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			level.rawValue
		] as [Any]
		self.channel?.request(endpoint: "conversations/setconversationnotificationlevel", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Set focus (occurs whenever you give focus to a client).
    @available(*, deprecated)
	public func setFocus(conversation_id: String, focused: Bool = true,
	                     cb: @escaping (SetFocusResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			focused ? 1 : 2,
			20
		] as [Any]
		self.channel?.request(endpoint: "conversations/setfocus", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
    
    @available(*, deprecated)
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
				(online ? 40 : 30)
			],
			None,
			None,
			[!online], // True if going offline, False if coming online
			[(mood ?? None) as Any] // UTF-8 smiley like 0x1f603
		] as [Any]
		self.channel?.request(endpoint: "presence/setpresence", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
	
	// Send typing notification.
    @available(*, deprecated)
	public func setTyping(conversation_id: String, typing: TypingType = TypingType.Started,
	                      cb: @escaping (SetTypingResponse?) -> Void = {_ in}) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			NSNumber(value: typing.rawValue)
		] as [Any]
		self.channel?.request(endpoint: "conversations/settyping", body: data, use_json: false) { r in
			cb(try! PBLiteDecoder().decode(data: r.data!))
		}
	}
}
