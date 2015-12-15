import Foundation
import Alamofire
import JavaScriptCore

public let ORIGIN_URL = "https://talkgadget.google.com"
public let IMAGE_UPLOAD_URL = "http://docs.google.com/upload/photos/resumable"
public let PVT_TOKEN_URL = "https://talkgadget.google.com/talkgadget/_/extension-start"
public let CHAT_INIT_URL = "https://talkgadget.google.com/u/0/talkgadget/_/chat"
public let CHAT_INIT_REGEX = "(?:<script>AF_initDataCallback\\((.*?)\\);</script>)"

// Timeout to send for setactiveclient requests:
public let ACTIVE_TIMEOUT_SECS = 120

// Minimum timeout between subsequent setactiveclient requests:
public let SETACTIVECLIENT_LIMIT_SECS = 60

public typealias InitialData = (
	conversation_states: [CONVERSATION_STATE],
	self_entity: ENTITY,
	entities: [ENTITY],
	conversation_participants: [CONVERSATION_PARTICIPANT_DATA],
	sync_timestamp: NSDate?
)

public protocol ClientDelegate {
    func clientDidConnect(client: Client, initialData: InitialData)
    func clientDidDisconnect(client: Client)
    func clientDidReconnect(client: Client)
    func clientDidUpdateState(client: Client, update: STATE_UPDATE)
}

public func generateClientID() -> Int {
    return Int(arc4random_uniform(4294967295))
}

// cleaner code pls.
extension String {
	func encodeURL() -> String {
		return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
	}
}

public class Client : ChannelDelegate {
	public let manager: Alamofire.Manager
    public var delegate: ClientDelegate?

    public var CHAT_INIT_PARAMS: Dictionary<String, AnyObject?> = [
        "prop": "aChromeExtension",
        "fid": "gtn-roster-iframe-id",
        "ec": "[\"ci:ec\",true,true,false]",
        "pvt": nil, // Populated later
    ]

    public init(manager: Alamofire.Manager) {
        self.manager = manager
    }

    public var initial_data: InitialData?
    public var channel: Channel?

    public var api_key: String?
    public var email: String?
    public var header_date: String?
    public var header_version: String?
    public var header_id: String?
    public var client_id: String?

    public var last_active_secs: NSNumber? = 0
    public var active_client_state: ActiveClientState?

    public func connect() {
        self.initialize_chat { (id: InitialData?) in
            self.initial_data = id
            self.channel = Channel(manager: self.manager)
            self.channel?.delegate = self
            self.channel?.listen()
        }
    }
	
	// Request push channel creation and initial chat data.
	// Returns instance of InitialData.
	// The response body is a HTML document containing a series of script tags
	// containing JavaScript objects. We need to parse the objects to get at
	// the data.
	// We first need to fetch the 'pvt' token, which is required for the
	// initialization request (otherwise it will return 400).
    public func initialize_chat(cb: (data: InitialData?) -> Void) {
        let prop = (CHAT_INIT_PARAMS["prop"] as! String).encodeURL()
        let fid = (CHAT_INIT_PARAMS["fid"] as! String).encodeURL()
        let ec = (CHAT_INIT_PARAMS["ec"] as! String).encodeURL()
        let url = "\(PVT_TOKEN_URL)?prop=\(prop)&fid=\(fid)&ec=\(ec)"
		
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        manager.request(request).responseData { response in
            let body = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)! as String
            let ctx = JSContext() // FIXME: Don't use this.
            let pvt: AnyObject = ctx.evaluateScript(body).toArray()[1] as! String
            self.CHAT_INIT_PARAMS["pvt"] = pvt

            // Now make the actual initialization request:
            let prop = (self.CHAT_INIT_PARAMS["prop"] as! String).encodeURL()
            let fid = (self.CHAT_INIT_PARAMS["fid"] as! String).encodeURL()
            let ec = (self.CHAT_INIT_PARAMS["ec"] as! String).encodeURL()
            let pvt_enc = (self.CHAT_INIT_PARAMS["pvt"] as! String).encodeURL()
            let url = "\(CHAT_INIT_URL)?prop=\(prop)&fid=\(fid)&ec=\(ec)&pvt=\(pvt_enc)"
			
			let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            self.manager.request(request).responseData { response in
                let body = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)! as String

                // Parse the response by using a regex to find all the JS objects, and
                // parsing them. Not everything will be parsable, but we don't care if
                // an object we don't need can't be parsed.
                var data_dict = Dictionary<String, AnyObject?>()
                let regex = Regex(CHAT_INIT_REGEX,
                    options: [NSRegularExpressionOptions.CaseInsensitive, NSRegularExpressionOptions.DotMatchesLineSeparators]
                )
                for data in regex.matches(body) {
                    if data.rangeOfString("data:function") == nil {
                        let dict = JSContext().evaluateScript("a = " + data).toDictionary()! // FIXME: Don't use this.
                        data_dict[dict["key"] as! String] = dict["data"]
                    } else {
                        var cleanedData = data
                        cleanedData = cleanedData.stringByReplacingOccurrencesOfString(
                            "data:function(){return", withString: "data:")
                        cleanedData = cleanedData.stringByReplacingOccurrencesOfString(
                            "}}", withString: "}")
                        if let dict = JSContext().evaluateScript("a = " + cleanedData).toDictionary() { // FIXME: Don't use this.
                            data_dict[dict["key"] as! String] = dict["data"]
                        } else {
                            print("Could not parse!")
                        }
                    }
                }
                self.api_key = ((data_dict["ds:7"] as! NSArray)[0] as! NSArray)[2] as? String
                self.email = ((data_dict["ds:33"] as! NSArray)[0] as! NSArray)[2] as? String
                self.header_date = ((data_dict["ds:2"] as! NSArray)[0] as! NSArray)[4] as? String
                self.header_version = ((data_dict["ds:2"] as! NSArray)[0] as! NSArray)[6] as? String
                self.header_id = ((data_dict["ds:4"] as! NSArray)[0] as! NSArray)[7] as? String

                let self_entity = PBLiteSerialization.parseArray(GET_SELF_INFO_RESPONSE.self, input: (data_dict["ds:20"] as! NSArray)[0] as? NSArray)!.self_entity

                let initial_conv_states_raw = ((data_dict["ds:19"] as! NSArray)[0] as! NSArray)[3] as! NSArray
                let initial_conv_states = (initial_conv_states_raw as! [NSArray]).map {
                    PBLiteSerialization.parseArray(CONVERSATION_STATE.self, input: $0)!
                }
                let initial_conv_parts = initial_conv_states.flatMap { $0.conversation.participant_data }

                var initial_entities = [ENTITY]()
                var sync_timestamp: NSNumber? = nil

                if let ds21 = data_dict["ds:21"] as? NSArray {
                    sync_timestamp = ((ds21[0] as! NSArray)[1] as! NSArray)[4] as? NSNumber

                    let entities = PBLiteSerialization.parseArray(INITIAL_CLIENT_ENTITIES.self, input: ds21[0] as? NSArray)!
                    initial_entities = (entities.entities) + [
                        entities.group1.entity,
                        entities.group2.entity,
                        entities.group3.entity,
                        entities.group4.entity,
                        entities.group5.entity,
                    ].flatMap { $0 }.map { $0.entity }
                }

                cb(data: InitialData(
                    initial_conv_states,
                    self_entity,
                    initial_entities,
                    initial_conv_parts,
                    from_timestamp(sync_timestamp)
                ))
            }
        }
    }

    private func getRequestHeader() -> NSArray {
        return [
            [6, 3, self.header_version!, self.header_date!],
            [self.client_id ?? NSNull(), self.header_id!],
            NSNull(),
            "en"
        ]
    }

    public func channelDidConnect(channel: Channel) {
        delegate?.clientDidConnect(self, initialData: initial_data!)
    }

    public func channelDidDisconnect(channel: Channel) {
        delegate?.clientDidDisconnect(self)
    }

    public func channelDidReconnect(channel: Channel) {
        delegate?.clientDidReconnect(self)
    }

    public func channel(channel: Channel, didReceiveMessage message: NSString) {
        let result = parse_submission(message as String)

        if let new_client_id = result.client_id {
            self.client_id = new_client_id
        }

        for state_update in result.updates {
            self.active_client_state = (
                state_update.state_update_header.active_client_state
            )
            NSNotificationCenter.defaultCenter().postNotificationName(
                ClientStateUpdatedNotification,
                object: self,
                userInfo: [ClientStateUpdatedNewStateKey: state_update]
            )
            delegate?.clientDidUpdateState(self, update: state_update)
        }
    }
	
	// Gracefully disconnect.
	// TODO: Fix this!
	public func disconnect() {
		//self.listen_future.cancel()
		//self.connector.close()
	}
	
	// Set this client as active.
	// While a client is active, no other clients will raise notifications.
	// Call this method whenever there is an indication the user is
	// interacting with this client. This method may be called very
	// frequently, and it will only make a request when necessary.
    public func setActive() {
        let isActive = (active_client_state == ActiveClientState.IS_ACTIVE_CLIENT)
        let time_since_active = (NSDate().timeIntervalSince1970 - last_active_secs!.doubleValue)
        let timed_out = time_since_active > Double(SETACTIVECLIENT_LIMIT_SECS)
        if !isActive || timed_out {
			
            // Update these immediately so if the function is called again
            // before the API request finishes, we don't start extra requests.
            active_client_state = ActiveClientState.IS_ACTIVE_CLIENT
            last_active_secs = NSDate().timeIntervalSince1970
            setActiveClient(true, timeout_secs: ACTIVE_TIMEOUT_SECS)
        }
    }

    private func request(
        endpoint: String,
        body: AnyObject,
        use_json: Bool = true,
        cb: (Response<NSData, NSError>) -> Void
    ) {
        let url = "https://clients6.google.com/chat/v1/\(endpoint)"
		let body_json = try! NSJSONSerialization.dataWithJSONObject(body, options: [])
		
        base_request(url,
            content_type: "application/json+protobuf",
            data: body_json,
            use_json: use_json,
            cb: cb
        )
    }

    private func base_request(
        path: String,
        content_type: String,
        data: NSData,
        use_json: Bool = true,
        cb: (Response<NSData, NSError>) -> Void
    ) {
        let params = [
            "key": self.api_key!,
            "alt": use_json ? "json" : "protojson",
        ]
        let url = NSURL(string: (path + "?" + params.encodeURL()))!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = data

        for (k, v) in OAuth2.getAuthorizationHeaders(self.channel!.getCookieValue("SAPISID")!) {
            request.setValue(v, forHTTPHeaderField: k)
        }
        request.setValue(content_type, forHTTPHeaderField: "Content-Type")
        manager.request(request).responseData(cb)
    }

    private func verifyResponseOK(responseObject: NSData) {
        let parsedObject = try! NSJSONSerialization.JSONObjectWithData(responseObject, options: []) as? NSDictionary
        let status = ((parsedObject?["response_header"] as? NSDictionary) ?? NSDictionary())["status"] as? String
        if status != "OK" {
            print("Unexpected status response: \(parsedObject!)")
        }
    }
	
	// List all events occurring at or after timestamp.
	// This method requests protojson rather than json so we have one chat
	// message parser rather than two.
	// timestamp: datetime.datetime instance specifying the time after
	// which to return all events occurring in.
    public func syncAllNewEvents(timestamp: NSDate, cb: (response: SYNC_ALL_NEW_EVENTS_RESPONSE?) -> Void) {
        let data: NSArray = [
            self.getRequestHeader(),
			to_timestamp(timestamp),
            [], NSNull(), [], false, [],
            1048576 // max_response_size_bytes
        ]
        self.request("conversations/syncallnewevents", body: data, use_json: false) { r in
            cb(response: PBLiteSerialization.parseProtoJSON(r.result.value!))
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
        let body = [
            self.getRequestHeader(),
            NSNull(), NSNull(), NSNull(), [],
            [
                segments, []
            ],
            a, // it's too long for one line!
            [
                [conversation_id],
                client_generated_id,
                otr_status.representation,
            ],
            NSNull(), NSNull(), NSNull(), []
		]
		
		// sendchatmessage can return 200 but still contain an error
        self.request("conversations/sendchatmessage", body: body) {
            r in self.verifyResponseOK(r.result.value!); cb?()
        }
    }
	
	public func uploadImage(imageFile: String, filename: String? = nil, cb: (() -> Void)? = nil) {
		let a = NSData(contentsOfFile: imageFile)
		let json = "{\"protocolVersion\":\"0.8\",\"createSessionRequest\":{\"fields\":[{\"external\":{\"name\":\"file\",\"filename\":\"\(imageFile)\",\"put\":{},\"size\":\(a!.length)}}]}}"
		
		let _ = base_request(IMAGE_UPLOAD_URL,
			content_type: "application/x-www-form-urlencoded;charset=UTF-8",
			data: json.dataUsingEncoding(NSUTF8StringEncoding)!) { response in
				
				// got response
				let data: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(response.data!,
					options: [.AllowFragments]) as! NSDictionary
				
				let _a = data["sessionStatus"] as! NSDictionary
				let _b = _a["externalFieldTransfers"] as! NSArray
				let _c = _b[0] as! NSDictionary
				let _d = _c["putInfo"] as! NSDictionary
				let upload = _d["url"] as! NSString
				
				let _ = self.base_request(upload as String, content_type: "application/octet-stream",
					data: a!, cb: { resp in
						// got stuff here
						let data2: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(response.data!,
							options: [.AllowFragments]) as! NSDictionary
						cb?()
						print("RESPONSE: \(data2)")
						// now get (json.loads(res1.body.decode())['sessionStatus']
						//                      ['externalFieldTransfers'][0]['putInfo']['url'])
						// and then get
						//        return (json.loads(res2.body.decode())['sessionStatus']
						//                ['additionalInfo']
						//                ['uploader_service.GoogleRupioAdditionalInfo']
						//                ['completionInfo']['customerSpecificInfo']['photoid'])
				})
		}
	}
	
    public func setActiveClient(is_active: Bool, timeout_secs: Int, cb: (() -> Void)? = nil) {
        let data: Array<AnyObject> = [
            self.getRequestHeader(),
            is_active, // whether the client is active or not
            "\(email!)/" + (client_id ?? ""), // full_jid: user@domain/resource
            timeout_secs // timeout in seconds for this client to be active
        ]

        // Set the active client.
        self.request("clients/setactiveclient", body: data, use_json: true) {
            r in self.verifyResponseOK(r.result.value!); cb?()
        }
    }
	
	// Leave group conversation.
	// conversation_id must be a valid conversation ID.
    public func removeuser(conversation_id: String, cb: (() -> Void)? = nil) {
        self.request("conversations/removeuser", body: [
            self.getRequestHeader(),
            NSNull(), NSNull(), NSNull(),
            [[conversation_id], generateClientID(), 2],
        ]) { r in self.verifyResponseOK(r.result.value!); cb?() }
    }
	
	// Delete one-to-one conversation.
	// conversation_id must be a valid conversation ID.
    public func deleteConversation(conversation_id: String, cb: (() -> Void)? = nil) {
        self.request("conversations/deleteconversation", body: [
            self.getRequestHeader(),
            [conversation_id],
			
            // Not sure what timestamp should be there, last time I have tried
            // it Hangouts client in GMail sent something like now() - 5 hours
            to_timestamp(NSDate()), // TODO: This should be in UTC
            NSNull(), []
        ]) { r in self.verifyResponseOK(r.result.value!); cb?() }
    }
	
	// Send typing notification.
    public func setTyping(conversation_id: String, typing: TypingType = TypingType.STARTED, cb: (() -> Void)? = nil) {
        let data = [
            self.getRequestHeader(),
            [conversation_id],
            typing.representation
        ]
        self.request("conversations/settyping", body: data) {
            r in self.verifyResponseOK(r.result.value!); cb?()
        }
    }
	
	// Update the watermark (read timestamp) for a conversation.
    public func updateWatermark(conv_id: String, read_timestamp: NSDate, cb: (() -> Void)? = nil) {
        self.request("conversations/updatewatermark", body: [
            self.getRequestHeader(),
            [conv_id], // conversation_id
            to_timestamp(read_timestamp), // latest_read_timestamp
        ]) { r in self.verifyResponseOK(r.result.value!); cb?() }
    }
	
	// FIXME: Doesn't return actual data, only calls cb.
	public func getSelfInfo(cb: (() -> Void)? = nil) {
		self.request("contacts/getselfinfo", body: [
			self.getRequestHeader(),
			[], []
		]) { r in cb?()}
	}
	
	// Set focus (occurs whenever you give focus to a client).
    public func setFocus(conversation_id: String, cb: (() -> Void)? = nil) {
        self.request("conversations/setfocus", body: [
            self.getRequestHeader(),
            [conversation_id],
            1,
            20
        ]){ r in self.verifyResponseOK(r.result.value!); cb?() }
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
	
	
	// FIXME: Doesn't return actual data, only calls cb.
	/*public func setPresence(online: Bool, mood: String?, cb: (() -> Void)? = nil) {
		self.request("contacts/getselfinfo", body: [
			self.getRequestHeader(),
			[
				// timeout_secs timeout in seconds for this presence
				720,
				//client_presence_state:
				// 40 => DESKTOP_ACTIVE
				// 30 => DESKTOP_IDLE
				// 1 => nil
				(online ? 1 : 40),
			],
			nil,
			nil,
			// True if going offline, False if coming online
			[!online],
			// UTF-8 smiley like 0x1f603
			[(mood ?? NSNull())]
		]) { r in cb?()} // result['response_header']['status']
	}*/
	
	// FIXME: Doesn't return actual data, only calls cb.
	public func queryPresence(chat_id: String, cb: (() -> Void)? = nil) {
		self.request("contacts/getselfinfo", body: [
			self.getRequestHeader(),
			[
				[chat_id]
			],
			[1, 2, 5, 7, 8]
		]) { r in cb?()}
	}
	
	// Return information about a list of contacts.
    public func getEntitiesByID(chat_id_list: [String], cb: (GET_ENTITY_BY_ID_RESPONSE) -> Void) {
        let data = [self.getRequestHeader(), NSNull(), chat_id_list.map { [$0] }]
        self.request("contacts/getentitybyid", body: data, use_json: false) { r in
			let obj: GET_ENTITY_BY_ID_RESPONSE? = PBLiteSerialization.parseProtoJSON(r.result.value!)
			cb(obj!)
        }
    }
	
	// Return conversation events.
	// This is mainly used for retrieving conversation scrollback. Events
	// occurring before event_timestamp are returned, in order from oldest to
	// newest.
    public func getConversation(
        conversation_id: String,
        event_timestamp: NSDate,
        max_events: Int = 50,
        cb: (GET_CONVERSATION_RESPONSE) -> Void
    ) {

        self.request("conversations/getconversation", body: [
            self.getRequestHeader(),
            [[conversation_id], [], []],  // conversationSpec
            false,  // includeConversationMetadata
            true,  // includeEvents
            NSNull(),  // ???
            max_events,  // maxEventsPerConversation
			
            // eventContinuationToken (specifying timestamp is sufficient)
            [
                NSNull(),  // eventId
                NSNull(),  // storageContinuationToken
                to_timestamp(event_timestamp),  // eventTimestamp
            ]
        ], use_json: false) { r in
            let result = JSContext().evaluateScript("a = " + (NSString(data: r.result.value!,
				encoding: NSUTF8StringEncoding)! as String)).toArray() // FIXME: Don't use this.
            cb(PBLiteSerialization.parseArray(GET_CONVERSATION_RESPONSE.self, input: result)!)
        }
    }

    //    @asyncio.coroutine
    //    def syncrecentconversations(self):
    //        """List the contents of recent conversations, including messages.
    //
    //        Similar to syncallnewevents, but appears to return a limited number of
    //        conversations (20) rather than all conversations in a given date range.
    //
    //        Raises hangups.NetworkError if the request fails.
    //        """
    //        self.request('conversations/syncrecentconversations',
    //                                       [self.getRequestHeader()])
    //        return json.loads(res.body.decode())
	
	// Set the name of a conversation.
    public func setChatName(conversation_id: String, name: String, cb: (() -> Void)? = nil) {
        let client_generated_id = generateClientID()
        let data = [
            self.getRequestHeader(),
            NSNull(),
            name,
            NSNull(),
            [[conversation_id], client_generated_id, 1]
        ]
        self.request("conversations/renameconversation", body: data) {
            r in self.verifyResponseOK(r.result.value!); cb?()
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
}
