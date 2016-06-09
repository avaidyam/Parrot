import Foundation // lots of things here

public final class Client {
	
	// URL for uploading any URL to Photos
	public static let IMAGE_UPLOAD_URL = "http://docs.google.com/upload/photos/resumable"
	
	// NotificationCenter notification and userInfo keys.
	public static let didConnectNotification = "Hangouts.Client.DidConnect"
	public static let didReconnectNotification = "Hangouts.Client.DidReconnect"
	public static let didDisconnectNotification = "Hangouts.Client.DidDisconnect"
	public static let didUpdateStateNotification = "Hangouts.Client.UpdateState"
	public static let didUpdateStateKey = "Hangouts.Client.UpdateState.Key"
	
	// Timeout to send for setactiveclient requests:
	public static let ACTIVE_TIMEOUT_SECS = 120
	
	// Minimum timeout between subsequent setactiveclient requests:
	public static let SETACTIVECLIENT_LIMIT_SECS = 60
	
	public let config: NSURLSessionConfiguration
	public var channel: Channel?
	
	public var email: String?
	public var client_id: String?
	public var last_active_secs: NSNumber? = 0
	public var active_client_state: ActiveClientState?
	
	public init(configuration: NSURLSessionConfiguration) {
		self.config = configuration
    }
	
	private var tokens = [NSObjectProtocol]()
	
	// Establish a connection to the chat server.
    public func connect() {
		self.channel = Channel(configuration: self.config)
		//self.channel?.delegate = self
		self.channel?.listen()
		
		// 
		// A notification-based delegate replacement:
		//
		
		let _c = NSNotificationCenter.default()
		let a = _c.addObserver(forName: Channel.didConnectNotification, object: self.channel, queue: nil) { _ in
			NSNotificationCenter.default().post(name: Client.didConnectNotification, object: self)
		}
		let b = _c.addObserver(forName: Channel.didReconnectNotification, object: self.channel, queue: nil) { _ in
			NSNotificationCenter.default().post(name: Client.didReconnectNotification, object: self)
		}
		let c = _c.addObserver(forName: Channel.didDisconnectNotification, object: self.channel, queue: nil) { _ in
			NSNotificationCenter.default().post(name: Client.didDisconnectNotification, object: self)
		}
		let d = _c.addObserver(forName: Channel.didReceiveMessageNotification, object: self.channel, queue: nil) { note in
			if let val = (note.userInfo as! [String: AnyObject])[Channel.didReceiveMessageKey] as? [AnyObject] {
				self.channel(channel: self.channel!, didReceiveMessage: val)
			} else {
				print("Encountered an error! \(note)")
			}
		}
		self.tokens.append(contentsOf: [a, b, c, d])
    }
	
	/* TODO: Can't disconnect a Channel yet. */
	// Gracefully disconnect from the server.
	public func disconnect() {
		//self.channel?.disconnect()
		
		// Remove all the observers so we aren't receiving calls later on.
		self.tokens.forEach {
			NSNotificationCenter.default().removeObserver($0)
		}
	}
	
	// Use this method for constructing request messages when calling Hangouts APIs.
	private func getRequestHeader() -> [AnyObject] {
		return [
			[None /* 6 */, None /* 3 */, "parrot-0.1", None, None, None],
			[self.client_id ?? None, None],
			None,
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
		
		let is_active = (active_client_state == ActiveClientState.IsActive)
		let time_since_active = (NSDate().timeIntervalSince1970 - last_active_secs!.doubleValue)
		let timed_out = time_since_active > Double(Client.SETACTIVECLIENT_LIMIT_SECS)
		
		if !is_active || timed_out {
			
			// Update these immediately so if the function is called again
			// before the API request finishes, we don't start extra requests.
			active_client_state = ActiveClientState.IsActive
			last_active_secs = NSDate().timeIntervalSince1970
			
			
			// The first time this is called, we need to retrieve the user's email address.
			if self.email == nil {
				self.getSelfInfo {
					self.email = $0!.selfEntity!.properties!.email[0] as String
				}
			}
			
			setActiveClient(is_active: true, timeout_secs: Client.ACTIVE_TIMEOUT_SECS)
        }
	}
	
	// Upload an image that can be later attached to a chat message.
	// The name of the uploaded file may be changed by specifying the filename argument.
	public func uploadImage(data: NSData, filename: String, cb: ((String) -> Void)? = nil) {
		let json = "{\"protocolVersion\":\"0.8\",\"createSessionRequest\":{\"fields\":[{\"external\":{\"name\":\"file\",\"filename\":\"\(filename)\",\"put\":{},\"size\":\(data.length)}}]}}"
		
		self.base_request(path: Client.IMAGE_UPLOAD_URL,
			content_type: "application/x-www-form-urlencoded;charset=UTF-8",
			data: json.data(using: NSUTF8StringEncoding)!) { response in
			
			// Sift through JSON for a response with the upload URL.
				let _data: NSDictionary = try! NSJSONSerialization.jsonObject(with: response.data!,
				options: .allowFragments) as! NSDictionary
			let _a = _data["sessionStatus"] as! NSDictionary
			let _b = _a["externalFieldTransfers"] as! NSArray
			let _c = _b[0] as! NSDictionary
			let _d = _c["putInfo"] as! NSDictionary
			let upload = (_d["url"] as! NSString) as String
			
			self.base_request(path: upload, content_type: "application/octet-stream", data: data) { resp in
				
				// Sift through JSON for a response with the photo ID.
				let _data2: NSDictionary = try! NSJSONSerialization.jsonObject(with: resp.data!,
					options: .allowFragments) as! NSDictionary
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
	
	// Parse channel array and call the appropriate events.
	public func channel(channel: Channel, didReceiveMessage message: [AnyObject]) {
		guard message[0] as? String != "noop" else {
			return
		}
		
		// Wrapper appears to be a Protocol Buffer message, but encoded via
		// field numbers as dictionary keys. Since we don't have a parser
		// for that, parse it ad-hoc here.
		let thr = (message[0] as! [String: String])["p"]!
		let wrapper = try! thr.decodeJSON()
		
		// Once client_id is received, the channel is ready to have services added.
		if let id = wrapper["3"] as? [String: AnyObject] {
			self.client_id = (id["2"] as! String)
			self.addChannelServices()
		}
		if let cbu = wrapper["2"] as? [String: AnyObject] {
			let val2 = cbu["2"]!.data(using: NSUTF8StringEncoding)
			let payload = try! NSJSONSerialization.jsonObject(with: val2!, options: .allowFragments)
			
			// This is a (Client)BatchUpdate containing StateUpdate messages.
			// payload[1] is a list of state updates.
			if payload[0] as? String == "cbu" {
				var b = BatchUpdate() as ProtoMessage
				PBLiteSerialization.decode(message: &b, pblite: payload as! [AnyObject], ignoreFirstItem: true)
				for state_update in (b as! BatchUpdate).stateUpdate {
					self.active_client_state = state_update.stateUpdateHeader!.activeClientState!
					NSNotificationCenter.default().post(
						name: Client.didUpdateStateNotification, object: self,
						userInfo: [Client.didUpdateStateKey: Wrapper(state_update)])
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
		let dat = try! NSJSONSerialization.data(withJSONObject: inner, options: [])
		let str = NSString(data: dat, encoding: NSUTF8StringEncoding) as! String
		
		self.channel?.sendMaps(mapList: [["p": str]])
	}
	
	public func buildUserConversationList(cb: (UserList, ConversationList) -> Void) {
		
		// Retrieve recent conversations so we can preemptively look up their participants.
		self.syncRecentConversations { response in
			let conv_states = response!.conversationState
			
			// syncrecentconversations seems to return a sync_timestamp 4 minutes
			// before the present. To prevent syncallnewevents later breaking
			// requesting events older than what we already have, use
			// current_server_time instead. use:
			//
			// from_timestamp(response!.response_header!.current_server_time)
			let sync_timestamp = response!.syncTimestamp//from_timestamp(microsecond_timestamp: )
			
			var required_user_ids = Set<UserID>()
			for conv_state in conv_states {
				let participants = conv_state.conversation!.participantData
				required_user_ids = required_user_ids.union(Set(participants.map {
					UserID(chatID: $0.id!.chatId!, gaiaID: $0.id!.gaiaId!)
				}))
			}
			
			var required_entities = [Entity]()
			self.getEntitiesByID(chat_id_list: required_user_ids.map { $0.chatID }) { resp in
				required_entities = resp?.entity ?? []
				
				var conv_part_list = Array<ConversationParticipantData>()
				for conv_state in conv_states {
					let participants = conv_state.conversation!.participantData
					conv_part_list.append(contentsOf: participants)
				}
				
				// Let's request our own entity now.
				var self_entity = Entity()
				self.getSelfInfo {
					self_entity = $0!.selfEntity!
					
					let userList = UserList(client: self, selfEntity: self_entity, entities: required_entities, data: conv_part_list)
					let conversationList = ConversationList(client: self, conv_states: conv_states, user_list: userList, sync_timestamp: sync_timestamp)
					cb(userList, conversationList)
				}
			}
		}
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
        base_request(path: "https://clients6.google.com/chat/v1/\(endpoint)",
            content_type: "application/json+protobuf",
            data: try! NSJSONSerialization.data(withJSONObject: body, options: []),
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
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data

        for (k, v) in getAuthorizationHeaders(sapisid_cookie: Channel.getCookieValue(key: "SAPISID")!) {
            request.setValue(v, forHTTPHeaderField: k)
        }
        request.setValue(content_type, forHTTPHeaderField: "Content-Type")
		
		self.channel?.session.request(request: request) {
			guard let _ = $0.data else {
				print("Request failed with error: \($0.error!)")
				return
			}
			cb($0)
		}
    }

    private func verifyResponseOK(responseObject: NSData) {
		let parsedObject = try! NSJSONSerialization.jsonObject(with: responseObject, options: []) as? NSDictionary
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
			to_timestamp(date: NSDate()), /* TODO: This should be in UTC form. */
			None,
			[]
		]
		self.request(endpoint: "conversations/deleteconversation", body: data) { r in
			self.verifyResponseOK(responseObject: r.data!); cb?()
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
		event_timestamp: UInt64,
		max_events: Int = 50,
		cb: (response: GetConversationResponse?) -> Void)
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
			None,  // ???
			max_events,  // maxEventsPerConversation
			[
				None,  // eventId
				None,  // storageContinuationToken
				NSNumber(value: event_timestamp)//to_timestamp(date: event_timestamp),  // eventTimestamp
			] // eventContinuationToken (specifying timestamp is sufficient)
		]
		
		self.request(endpoint: "conversations/getconversation", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Return information about a list of contacts.
	public func getEntitiesByID(chat_id_list: [String], cb: (response: GetEntityByIdResponse?) -> Void) {
		guard chat_id_list.count > 0 else { cb(response: nil); return }
		let data = [
			self.getRequestHeader(),
			None,
			chat_id_list.map { [$0] }
		]
		self.request(endpoint: "contacts/getentitybyid", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func getSelfInfo(cb: ((response: GetSelfInfoResponse?) -> Void)) {
		let data = [
			self.getRequestHeader()
		]
		self.request(endpoint: "contacts/getselfinfo", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	public func getSuggestedEntities(max_count: Int, cb: ((response: GetSuggestedEntitiesResponse?) -> Void)) {
		let data = [
			self.getRequestHeader(),
			None,
			None,
			max_count
		]
		self.request(endpoint: "contacts/getsuggestedentities", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(input: r.data!))
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
		self.request(endpoint: "presence/querypresence", body: data) { r in
			
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
			None,
			None,
			None,
			[
				[conversation_id],
				generateClientID(),
				2
			],
		]
		self.request(endpoint: "conversations/removeuser", body: data) { r in
			self.verifyResponseOK(responseObject: r.data!); cb?()
		}
	}
	
	// Set the name of a conversation.
	public func renameConversation(conversation_id: String, name: String, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			None,
			name,
			None,
			[
				[conversation_id],
				generateClientID(),
				1
			]
		]
		self.request(endpoint: "conversations/renameconversation", body: data) {
			r in self.verifyResponseOK(responseObject: r.data!); cb?()
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
		otr_status: OffTheRecordStatus = .OnTheRecord,
		cb: (() -> Void)? = nil)
	{
		// Support sending images from other user id's.
		var a: NSObject
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
			[ //ChatMessageContent
				segments,
				[]
			],
			a, // it's too long for one line! // ExistingMedia
			[ //EventRequestHeader
				[conversation_id],
				generateClientID(),
				NSNumber(value: otr_status.rawValue),
				[NSNumber(value: DeliveryMediumType.DeliveryMediumGoogleVoice.rawValue), ],
				NSNumber(value: EventType.Sms.rawValue)
			],
			//None,
			//None,
			//None,
			//[]
		]
		
		// sendchatmessage can return 200 but still contain an error
		self.request(endpoint: "conversations/sendchatmessage", body: data) {
			r in self.verifyResponseOK(responseObject: r.data!); cb?()
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
		self.request(endpoint: "clients/setactiveclient", body: data) {
			r in self.verifyResponseOK(responseObject: r.data!); cb?()
		}
	}
	
	public func setConversationNotificationLevel(conversation_id: String, level: NotificationLevel = .Ring, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conversation_id]
		]
		self.request(endpoint: "conversations/setconversationnotificationlevel", body: data) { r in
			self.verifyResponseOK(responseObject: r.data!); cb?()
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
        self.request(endpoint: "conversations/setfocus", body: data) { r in
			self.verifyResponseOK(responseObject: r.data!); cb?()
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
			None,
			None,
			[!online], // True if going offline, False if coming online
			[mood ?? None] // UTF-8 smiley like 0x1f603
		]
		self.request(endpoint: "presence/setpresence", body: data) { r in cb?()}
		// result['response_header']['status']
	}
	
	// Send typing notification.
	public func setTyping(conversation_id: String, typing: TypingType = TypingType.Started, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conversation_id],
			NSNumber(value: typing.rawValue)
		]
		self.request(endpoint: "conversations/settyping", body: data) {
			r in self.verifyResponseOK(responseObject: r.data!); cb?()
		}
	}
	
	// List all events occurring at or after a timestamp.
	public func syncAllNewEvents(timestamp: UInt64, cb: (response: SyncAllNewEventsResponse?) -> Void) {
		let data: NSArray = [
			self.getRequestHeader(),
			NSNumber(value: timestamp),//to_timestamp(date: timestamp),
			[],
			None,
			[],
			false,
			[],
			1048576 // max_response_size_bytes
		]
		self.request(endpoint: "conversations/syncallnewevents", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(input: r.data!))
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
			None,
			maxConversations,
			maxEventsPer,
			[1]
		]
		self.request(endpoint: "conversations/syncrecentconversations", body: data, use_json: false) { r in
			cb(response: PBLiteSerialization.parseProtoJSON(input: r.data!))
		}
	}
	
	// Update the watermark (read timestamp) for a conversation.
	public func updateWatermark(conv_id: String, read_timestamp: UInt64, cb: (() -> Void)? = nil) {
		let data = [
			self.getRequestHeader(),
			[conv_id], // conversation_id
			NSNumber(value: read_timestamp)//to_timestamp(date: ), // latest_read_timestamp
		]
		self.request(endpoint: "conversations/updatewatermark", body: data) { r in
			self.verifyResponseOK(responseObject: r.data!); cb?()
		}
	}
}
