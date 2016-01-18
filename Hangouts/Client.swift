import Foundation
import Alamofire

public let IMAGE_UPLOAD_URL = "http://docs.google.com/upload/photos/resumable"

public let ClientStateUpdatedNotification = "ClientStateUpdated"
public let ClientStateUpdatedNewStateKey = "ClientStateNewState"

// Timeout to send for setactiveclient requests:
public let ACTIVE_TIMEOUT_SECS = 120

// Minimum timeout between subsequent setactiveclient requests:
public let SETACTIVECLIENT_LIMIT_SECS = 60

public protocol ClientDelegate {
    func clientDidConnect(client: Client)
    func clientDidDisconnect(client: Client)
    func clientDidReconnect(client: Client)
    func clientDidUpdateState(client: Client, update: STATE_UPDATE)
}

var session: NSURLSession? = nil

public class Client : ChannelDelegate {
	
	public let config: NSURLSessionConfiguration
	public var delegate: ClientDelegate?
	public var channel: Channel?
	
	public var email: String?
	public var client_id: String?
	public var last_active_secs: NSNumber? = 0
	public var active_client_state: ActiveClientState?
	
	public init(configuration: NSURLSessionConfiguration) {
		self.config = configuration
    }
	
	// Establish a connection to the chat server.
    public func connect() {
		self.channel = Channel(configuration: self.config)
		self.channel?.delegate = self
		self.channel?.listen()
    }
	
	/* TODO: Can't disconnect a Channel yet. */
	// Gracefully disconnect from the server.
	public func disconnect() {
		//self.channel?.disconnect()
	}
	
	// Use this method for constructing request messages when calling Hangouts APIs.
	private func getRequestHeader() -> NSArray {
		return [
			[NSNull() /* 6 */, NSNull() /* 3 */, "parrot-0.1", NSNull(), NSNull(), NSNull()],
			[self.client_id ?? NSNull(), NSNull()],
			NSNull(),
			"en"
		]
	}
	
	// Use this method for constructing request messages when calling Hangouts APIs.
	public func generateClientID() -> Int {
		return Int(arc4random_uniform(2^32))
	}
	
	// Set this client as active.
	// While a client is active, no other clients will raise notifications.
	// Call this method whenever there is an indication the user is
	// interacting with this client. This method may be called very
	// frequently, and it will only make a request when necessary.
	public func setActive() {
		
		// If the client_id hasn't been received yet, we can't set the active client.
		guard self.client_id != nil else {
			print("Cannot set active client until client_id is received")
			return
		}
		
		let is_active = (active_client_state == ActiveClientState.IS_ACTIVE_CLIENT)
		let time_since_active = (NSDate().timeIntervalSince1970 - last_active_secs!.doubleValue)
		let timed_out = time_since_active > Double(SETACTIVECLIENT_LIMIT_SECS)
		
		if !is_active || timed_out {
			
			// Update these immediately so if the function is called again
			// before the API request finishes, we don't start extra requests.
			active_client_state = ActiveClientState.IS_ACTIVE_CLIENT
			last_active_secs = NSDate().timeIntervalSince1970
			
			
			// The first time this is called, we need to retrieve the user's email address.
			if self.email == nil {
				self.getSelfInfo {
					self.email = $0!.self_entity!.properties.emails[0] as? String
				}
			}
			
			setActiveClient(true, timeout_secs: ACTIVE_TIMEOUT_SECS)
        }
	}
	
	// Upload an image that can be later attached to a chat message.
	// The name of the uploaded file may be changed by specifying the filename argument.
	public func uploadImage(data: NSData, filename: String, cb: ((String) -> Void)? = nil) {
		let json = "{\"protocolVersion\":\"0.8\",\"createSessionRequest\":{\"fields\":[{\"external\":{\"name\":\"file\",\"filename\":\"\(filename)\",\"put\":{},\"size\":\(data.length)}}]}}"
		
		self.base_request(IMAGE_UPLOAD_URL,
			content_type: "application/x-www-form-urlencoded;charset=UTF-8",
			data: json.dataUsingEncoding(NSUTF8StringEncoding)!) { response in
			
			// Sift through JSON for a response with the upload URL.
			let _data: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(response.data!,
				options: .AllowFragments) as! NSDictionary
			let _a = _data["sessionStatus"] as! NSDictionary
			let _b = _a["externalFieldTransfers"] as! NSArray
			let _c = _b[0] as! NSDictionary
			let _d = _c["putInfo"] as! NSDictionary
			let upload = (_d["url"] as! NSString) as String
			
			self.base_request(upload, content_type: "application/octet-stream", data: data) { resp in
				
				// Sift through JSON for a response with the photo ID.
				let _data2: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(resp.data!,
					options: .AllowFragments) as! NSDictionary
				let _a2 = _data2["sessionStatus"] as! NSDictionary
				let _b2 = _a2["additionalInfo"] as! NSDictionary
				let _c2 = _b2["uploader_service.GoogleRupioAdditionalInfo"] as! NSDictionary
				let _d2 = _c2["completionInfo"] as! NSDictionary
				let _e2 = _d2["customerSpecificInfo"] as! NSDictionary
				let photoid = (_e2["photoid"] as! NSString) as String
				
				cb?(photoid)
			}
		}
	}
	
	// MARK - ChannelDelegate
	
	public func channelDidConnect(channel: Channel) {
		delegate?.clientDidConnect(self)
	}
	
	public func channelDidDisconnect(channel: Channel) {
		delegate?.clientDidDisconnect(self)
	}
	
	public func channelDidReconnect(channel: Channel) {
		delegate?.clientDidReconnect(self)
	}
	
	// Parse channel array and call the appropriate events.
	public func channel(channel: Channel, didReceiveMessage message: [AnyObject]) {
		guard message[0] as? String != "noop" else {
			return
		}
		
		// Wrapper appears to be a Protocol Buffer message, but encoded via
		// field numbers as dictionary keys. Since we don't have a parser
		// for that, parse it ad-hoc here.
		let thr = (message[0] as! [String: String])["p"]!
		let val = thr.dataUsingEncoding(NSUTF8StringEncoding)
		let wrapper = try! NSJSONSerialization.JSONObjectWithData(val!, options: .AllowFragments)
		
		// Once client_id is received, the channel is ready to have services added.
		if let id = wrapper["3"] as? [String: AnyObject] {
			self.client_id = (id["2"] as! String)
			self.addChannelServices()
		}
		if let cbu = wrapper["2"] as? [String: AnyObject] {
			let val2 = cbu["2"]!.dataUsingEncoding(NSUTF8StringEncoding)
			let payload = try! NSJSONSerialization.JSONObjectWithData(val2!, options: .AllowFragments)
			
			// This is a (Client)BatchUpdate containing StateUpdate messages.
			// payload[1] is a list of state updates.
			if payload[0] as? String == "cbu" {
				let result = flatMap(payload[1] as! [NSArray]) {
					PBLiteSerialization.parseArray(STATE_UPDATE.self, input: $0)
				}
				
				for state_update in result {
					self.active_client_state = state_update.state_update_header.active_client_state
					NSNotificationCenter.defaultCenter().postNotificationName(
						ClientStateUpdatedNotification, object: self,
						userInfo: [ClientStateUpdatedNewStateKey: state_update])
					delegate?.clientDidUpdateState(self, update: state_update)
				}
			} else {
				print("Ignoring message: \(payload[0])")
			}
		}
	}
	
	// Add services to the channel.
	//
	// The services we add to the channel determine what kind of data we will
	// receive on it. The "babel" service includes what we need for Hangouts.
	// If this fails for some reason, hangups will never receive any events.
	// This needs to be re-called whenever we open a new channel (when there's
	// a new SID and client_id.
	//
	// Based on what Hangouts for Chrome does over 2 requests, this is
	// trimmed down to 1 request that includes the bare minimum to make
	// things work.
	private func addChannelServices() {
		let inner = ["3": ["1": ["1": "babel"]]]
		let dat = try! NSJSONSerialization.dataWithJSONObject(inner, options: [])
		let str = NSString(data: dat, encoding: NSUTF8StringEncoding) as! String
		
		self.channel?.sendMaps([["p": str]])
	}
	
	// MARK - Request Factories
	
	/* TODO: Refactor request() and base_request(). */

	// Send a Protocol Buffer or JSON formatted chat API request.
	// endpoint is the chat API endpoint to use.
	// request_pb: The request body as a Protocol Buffer message.
	// response_pb: The response body as a Protocol Buffer message.
    private func request(
        endpoint: String,
        body: AnyObject,
        use_json: Bool = true,
        cb: (Result) -> Void
    ) {
        base_request("https://clients6.google.com/chat/v1/\(endpoint)",
            content_type: "application/json+protobuf",
            data: try! NSJSONSerialization.dataWithJSONObject(body, options: []),
            use_json: use_json,
            cb: cb
        )
    }
	
	// Valid formats are: 'json' (JSON), 'protojson' (pblite), and 'proto'
	// (binary Protocol Buffer). 'proto' requires manually setting an extra
	// header 'X-Goog-Encode-Response-If-Executable: base64'.
    private func base_request(
        path: String,
        content_type: String,
        data: NSData,
        use_json: Bool = true,
        cb: (Result) -> Void
    ) {
        let params = ["alt": use_json ? "json" : "protojson"]
        let url = NSURL(string: (path + "?" + params.encodeURL()))!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = data

        for (k, v) in getAuthorizationHeaders(getCookieValue("SAPISID")!) {
            request.setValue(v, forHTTPHeaderField: k)
        }
        request.setValue(content_type, forHTTPHeaderField: "Content-Type")
		
		self.channel?.session.request(request) {
			guard let _ = $0.data else {
				print("Request failed with error: \($0.error!)")
				return
			}
			cb($0)
		}
    }

    private func verifyResponseOK(responseObject: NSData) {
        let parsedObject = try! NSJSONSerialization.JSONObjectWithData(responseObject, options: []) as? NSDictionary
        let status = ((parsedObject?["response_header"] as? NSDictionary) ?? NSDictionary())["status"] as? String
        if status != "OK" {
            print("Unexpected status response: \(parsedObject!)")
        }
    }
	
	// MARK - Client Requests
	/* TODO: Implement the last four requests and refactor them to use Request messages. */
	/* TODO: Refactor everything into just protojson. */
	
	//    @asyncio.coroutine
	//    def adduser(self, conversation_id, chat_id_list):
	//        """Add user to existing conversation.
	//
	//        conversation_id must be a valid conversation ID.
	//        chat_id_list is list of users which should be invited to conversation.
	//
	//        Raises hangups.NetworkError if the request fails.
	//        """
	//        client_generated_id = random.randint(0, 2**32)
	//        body = [
	//            self.getRequestHeader(),
	//            nil,
	//            [[str(chat_id), nil, nil, "unknown", nil, []]
	//             for chat_id in chat_id_list],
	//            nil,
	//            [
	//                [conversation_id], client_generated_id, 2, nil, 4
	//            ]
	//        ]
	//
	//        self.request('conversations/adduser', body)
	//        # can return 200 but still contain an error
	//        res = json.loads(res.body.decode())
	//        res_status = res['response_header']['status']
	//        if res_status != 'OK':
	//            raise exceptions.NetworkError('Unexpected status: {}'
	//                                          .format(res_status))
	//        return res
	
	//    @asyncio.coroutine
	//    def createconversation(self, chat_id_list, force_group=False):
	//        """Create new conversation.
	//
	//        conversation_id must be a valid conversation ID.
	//        chat_id_list is list of users which should be invited to conversation
	//        (except from yourself).
	//
	//        New conversation ID is returned as res['conversation']['id']['id']
	//
	//        Raises hangups.NetworkError if the request fails.
	//        """
	//        client_generated_id = random.randint(0, 2**32)
	//        body = [
	//            self.getRequestHeader(),
	//            1 if len(chat_id_list) == 1 and not force_group else 2,
	//            client_generated_id,
	//            nil,
	//            [[str(chat_id), nil, nil, "unknown", nil, []]
	//             for chat_id in chat_id_list]
	//        ]
	//
	//        self.request('conversations/createconversation',
	//                                       body)
	//        # can return 200 but still contain an error
	//        res = json.loads(res.body.decode())
	//        res_status = res['response_header']['status']
	//        if res_status != 'OK':
	//            raise exceptions.NetworkError('Unexpected status: {}'
	//                                          .format(res_status))
	//        return res
	
	// Delete one-to-one conversation.
	// conversation_id must be a valid conversation ID.
	public func deleteConversation(conversation_id: String, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			
			// Not sure what timestamp should be there, last time I have tried
			// it Hangouts client in GMail sent something like now() - 5 hours
			to_timestamp(NSDate()), /* TODO: This should be in UTC form. */
			NSNull(),
			[]
		]
		self.request("conversations/deleteconversation", body: data) { r in
			self.verifyResponseOK(r.data!); cb?()
		}
	}
	
	//    @asyncio.coroutine
	//    def sendeasteregg(self, conversation_id, easteregg):
	//        """Send a easteregg to a conversation.
	//
	//        easteregg may not be empty.
	//
	//        Raises hangups.NetworkError if the request fails.
	//        """
	//        body = [
	//            self.getRequestHeader(),
	//            [conversation_id],
	//            [easteregg, nil, 1]
	//        ]
	//        self.request('conversations/easteregg', body)
	//        res = json.loads(res.body.decode())
	//        res_status = res['response_header']['status']
	//        if res_status != 'OK':
	//            logger.warning('easteregg returned status {}'
	//                           .format(res_status))
	//            raise exceptions.NetworkError()
	
	// Return conversation events.
	// This is mainly used for retrieving conversation scrollback. Events
	// occurring before event_timestamp are returned, in order from oldest to
	// newest.
	public func getConversation(
		conversation_id: String,
		event_timestamp: NSDate,
		max_events: Int = 50,
		cb: (GET_CONVERSATION_RESPONSE) -> Void)
	{
		let data = [
			self.getRequestHeader(),
			[
				[conversation_id],
				[],
				[]
			],  // conversationSpec
			false,  // includeConversationMetadata
			true,  // includeEvents
			NSNull(),  // ???
			max_events,  // maxEventsPerConversation
			[
				NSNull(),  // eventId
				NSNull(),  // storageContinuationToken
				to_timestamp(event_timestamp),  // eventTimestamp
			] // eventContinuationToken (specifying timestamp is sufficient)
		]
		
		self.request("conversations/getconversation", body: data, use_json: false) { r in
			let str = (NSString(data: r.data!, encoding: NSUTF8StringEncoding)! as String)
			let result = evalArray(str) as! NSArray
			cb(PBLiteSerialization.parseArray(GET_CONVERSATION_RESPONSE.self, input: result)!)
		}
	}
	
	// Return information about a list of contacts.
	public func getEntitiesByID(chat_id_list: [String], cb: (GET_ENTITY_BY_ID_RESPONSE?) -> Void) {
		let data = [
			self.getRequestHeader(),
			NSNull(),
			chat_id_list.map { [$0] }
		]
		self.request("contacts/getentitybyid", body: data, use_json: false) { r in
			cb(PBLiteSerialization.parseProtoJSON(r.data!))
		}
	}
	
	public func getSelfInfo(cb: ((response: GetSelfInfoResponse?) -> Void)) {
		let data = [
			self.getRequestHeader()
		]
		self.request("contacts/getselfinfo", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(r.data!))
		}
	}
	
	public func queryPresence(chat_ids: [String] = [], cb: (() -> Void)? = nil) {
		guard chat_ids.count > 0 else {
			print("Cannot query presence for zero chat IDs!")
			return
		}
		
		let data = [
			self.getRequestHeader(),
			[chat_ids],
			[1, 2, 5, 7, 8] // what are FieldMasks 5 and 8?
		]
		self.request("presence/querypresence", body: data) { r in
			
			/* TODO: Does not return data, only calls the callback. */
			// cb(response: PBLiteSerialization.parseProtoJSON(r.data!)) //PresenceResult
			cb?()
		}
	}
	
	// Leave group conversation.
	// conversation_id must be a valid conversation ID.
	public func removeUser(conversation_id: String, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			NSNull(),
			NSNull(),
			NSNull(),
			[
				[conversation_id],
				generateClientID(),
				2
			],
		]
		self.request("conversations/removeuser", body: data) { r in
			self.verifyResponseOK(r.data!); cb?()
		}
	}
	
	// Set the name of a conversation.
	public func renameConversation(conversation_id: String, name: String, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			NSNull(),
			name,
			NSNull(),
			[
				[conversation_id],
				generateClientID(),
				1
			]
		]
		self.request("conversations/renameconversation", body: data) {
			r in self.verifyResponseOK(r.data!); cb?()
		}
	}
	
	//    @asyncio.coroutine
	//    def searchentities(self, search_string, max_results):
	//        """Search for people.
	//
	//        Raises hangups.NetworkError if the request fails.
	//        """
	//        self.request('contacts/searchentities', [
	//            self.getRequestHeader(),
	//            [],
	//            search_string,
	//            max_results
	//        ])
	//        return json.loads(res.body.decode())
	
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
		segments: [NSArray],
		image_id: String? = nil,
		image_user_id: String? = nil,
		otr_status: OffTheRecordStatus = .ON_THE_RECORD,
		cb: (() -> Void)? = nil
	) {
			
			// Support sending images from other user id's.
			var a: NSObject
			if image_id != nil {
				if image_user_id != nil {
					a = [[image_id!, false, image_user_id!, true]]
				} else {
					a = [[image_id!, false, NSNull(), false]]
				}
			} else {
				a = NSNull()
			}
			
			let client_generated_id = generateClientID()
			let data = [
				self.getRequestHeader(),
				NSNull(),
				NSNull(),
				NSNull(),
				[],
				[
					segments,
					[]
				],
				a, // it's too long for one line!
				[
					[conversation_id],
					client_generated_id,
					otr_status.representation,
				],
				NSNull(),
				NSNull(),
				NSNull(),
				[]
			]
			
			// sendchatmessage can return 200 but still contain an error
			self.request("conversations/sendchatmessage", body: data) {
				r in self.verifyResponseOK(r.data!); cb?()
			}
	}
	
	public func setActiveClient(is_active: Bool, timeout_secs: Int, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			is_active, // whether the client is active or not
			"\(self.email!)/" + (self.client_id ?? ""), // full_jid: user@domain/resource
			timeout_secs // timeout in seconds for this client to be active
		]
		
		// Set the active client.
		self.request("clients/setactiveclient", body: data, use_json: true) {
			r in self.verifyResponseOK(r.data!); cb?()
		}
	}
	
	public func setConversationNotificationLevel(conversation_id: String, level: NotificationLevel = .RING, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conversation_id]
		]
		self.request("conversations/setconversationnotificationlevel", body: data){ r in
			self.verifyResponseOK(r.data!); cb?()
		}
	}
	
	// Set focus (occurs whenever you give focus to a client).
    public func setFocus(conversation_id: String, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			1,
			20
		]
        self.request("conversations/setfocus", body: data) { r in
			self.verifyResponseOK(r.data!); cb?()
		}
    }
	
	
	/* TODO: Does not return data, only calls the callback. */
	public func setPresence(online: Bool, mood: String?, cb: (() -> Void)? = nil) {
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
			NSNull(),
			NSNull(),
			[!online], // True if going offline, False if coming online
			[mood ?? NSNull()] // UTF-8 smiley like 0x1f603
		]
		self.request("presence/setpresence", body: data) { r in cb?()}
		// result['response_header']['status']
	}
	
	// Send typing notification.
	public func setTyping(conversation_id: String, typing: TypingType = TypingType.STARTED, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			typing.representation
		]
		self.request("conversations/settyping", body: data) {
			r in self.verifyResponseOK(r.data!); cb?()
		}
	}
	
	// List all events occurring at or after a timestamp.
	public func syncAllNewEvents(timestamp: NSDate, cb: (response: SYNC_ALL_NEW_EVENTS_RESPONSE?) -> Void) {
		let data: NSArray = [
			self.getRequestHeader(),
			to_timestamp(timestamp),
			[],
			NSNull(),
			[],
			false,
			[],
			1048576 // max_response_size_bytes
		]
		self.request("conversations/syncallnewevents", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(r.data!))
		}
		
		// This method requests protojson rather than json so we have one chat
		// message parser rather than two.
		// timestamp: datetime.datetime instance specifying the time after
		// which to return all events occurring in.
	}
	
	// Return info on recent conversations and their events.
	public func syncRecentConversations(maxConversations: Int = 100, maxEventsPer: Int = 1,
		cb: ((response: SyncRecentConversationsResponse?) -> Void)) {
		let data = [
			self.getRequestHeader(),
			NSNull(),
			maxConversations,
			maxEventsPer,
			[1]
		]
		self.request("conversations/syncrecentconversations", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(r.data!))
		}
	}
	
	// Update the watermark (read timestamp) for a conversation.
	public func updateWatermark(conv_id: String, read_timestamp: NSDate, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conv_id], // conversation_id
			to_timestamp(read_timestamp), // latest_read_timestamp
		]
		self.request("conversations/updatewatermark", body: data) { r in
			self.verifyResponseOK(r.data!); cb?()
		}
	}
}
