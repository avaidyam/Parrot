//from hangups import (javascript, parsers, exceptions, http_utils, channel,
//                     event, schemas)

import Foundation
import Alamofire
import JavaScriptCore

let ORIGIN_URL = "https://talkgadget.google.com"
let IMAGE_UPLOAD_URL = "http://docs.google.com/upload/photos/resumable"
let PVT_TOKEN_URL = "https://talkgadget.google.com/talkgadget/_/extension-start"
let CHAT_INIT_URL = "https://talkgadget.google.com/u/0/talkgadget/_/chat"

let CHAT_INIT_REGEX = "(?:<script>AF_initDataCallback\\((.*?)\\);</script>)"

// Timeout to send for setactiveclient requests:
let ACTIVE_TIMEOUT_SECS = 120
// Minimum timeout between subsequent setactiveclient requests:
let SETACTIVECLIENT_LIMIT_SECS = 60

protocol ClientDelegate {
    func clientDidConnect(client: Client, initialData: InitialData)
    func clientDidDisconnect(client: Client)
    func clientDidReconnect(client: Client)
    func clientDidUpdateState(client: Client, update: CLIENT_STATE_UPDATE)
}

func generateClientID() -> Int {
    return Int(arc4random_uniform(4294967295))
}

class Client : ChannelDelegate {
    let manager: Alamofire.Manager
    var delegate: ClientDelegate?

    var CHAT_INIT_PARAMS: Dictionary<String, AnyObject?> = [
        "prop": "aChromeExtension",
        "fid": "gtn-roster-iframe-id",
        "ec": "[\"ci:ec\",true,true,false]",
        "pvt": nil, // Populated later
    ]

    init(manager: Alamofire.Manager) {
        self.manager = manager
    }

    var initial_data: InitialData?
    var channel: Channel?

    var api_key: String?
    var email: String?
    var header_date: String?
    var header_version: String?
    var header_id: String?
    var client_id: String?

    var last_active_secs: NSNumber? = 0
    var active_client_state: ActiveClientState?

    func connect() {
        self.initialize_chat { (id: InitialData?) in
            self.initial_data = id
            //print("Chat initialized. Opening channel...")

            self.channel = Channel(manager: self.manager)
            self.channel?.delegate = self
            self.channel?.listen()
        }
    }

    func initialize_chat(cb: (data: InitialData?) -> Void) {
        //Request push channel creation and initial chat data.
        //
        //Returns instance of InitialData.
        //
        //The response body is a HTML document containing a series of script tags
        //containing JavaScript objects. We need to parse the objects to get at
        //the data.

        // We first need to fetch the 'pvt' token, which is required for the
        // initialization request (otherwise it will return 400).

        let prop = (CHAT_INIT_PARAMS["prop"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let fid = (CHAT_INIT_PARAMS["fid"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let ec = (CHAT_INIT_PARAMS["ec"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let url = "\(PVT_TOKEN_URL)?prop=\(prop)&fid=\(fid)&ec=\(ec)"
        //print("Fetching pvt token: \(url)")
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        manager.request(request).responseData { response in

            let body = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)! as String

            let ctx = JSContext()
            let pvt: AnyObject = ctx.evaluateScript(body).toArray()[1] as! String
            self.CHAT_INIT_PARAMS["pvt"] = pvt

            // Now make the actual initialization request:
            let prop = (self.CHAT_INIT_PARAMS["prop"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
            let fid = (self.CHAT_INIT_PARAMS["fid"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
            let ec = (self.CHAT_INIT_PARAMS["ec"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
            let pvt_enc = (self.CHAT_INIT_PARAMS["pvt"] as! String).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!

            let url = "\(CHAT_INIT_URL)?prop=\(prop)&fid=\(fid)&ec=\(ec)&pvt=\(pvt_enc)"
            //print("Initializing chat: \(url)")
			let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            self.manager.request(request).responseData { response in

                let body = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)! as String
//                print(error?.description)
//                print(response?.description)
//                print("Received chat init response: '\(body)'")

                // Parse the response by using a regex to find all the JS objects, and
                // parsing them. Not everything will be parsable, but we don't care if
                // an object we don't need can't be parsed.

                var data_dict = Dictionary<String, AnyObject?>()
                let regex = Regex(CHAT_INIT_REGEX,
                    options: [NSRegularExpressionOptions.CaseInsensitive, NSRegularExpressionOptions.DotMatchesLineSeparators]
                )
                for data in regex.matches(body) {

                    if data.rangeOfString("data:function") == nil {
                        let dict = JSContext().evaluateScript("a = " + data).toDictionary()!
                        data_dict[dict["key"] as! String] = dict["data"]
                    } else {
                        var cleanedData = data
                        cleanedData = cleanedData.stringByReplacingOccurrencesOfString(
                            "data:function(){return", withString: "data:")
                        cleanedData = cleanedData.stringByReplacingOccurrencesOfString(
                            "}}", withString: "}")
                        if let dict = JSContext().evaluateScript("a = " + cleanedData).toDictionary() {
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

                let self_entity = PBLiteSerialization.parseArray(CLIENT_GET_SELF_INFO_RESPONSE.self, input: (data_dict["ds:20"] as! NSArray)[0] as? NSArray)!.self_entity

                let initial_conv_states_raw = ((data_dict["ds:19"] as! NSArray)[0] as! NSArray)[3] as! NSArray
                let initial_conv_states = (initial_conv_states_raw as! [NSArray]).map {
                    PBLiteSerialization.parseArray(CLIENT_CONVERSATION_STATE.self, input: $0)!
                }
                let initial_conv_parts = initial_conv_states.flatMap { $0.conversation.participant_data }

                var initial_entities = [CLIENT_ENTITY]()
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

    func channelDidConnect(channel: Channel) {
        delegate?.clientDidConnect(self, initialData: initial_data!)
    }

    func channelDidDisconnect(channel: Channel) {
        delegate?.clientDidDisconnect(self)
    }

    func channelDidReconnect(channel: Channel) {
        delegate?.clientDidReconnect(self)
    }

    func channel(channel: Channel, didReceiveMessage message: NSString) {
        let result = parse_submission(message as String)

        if let new_client_id = result.client_id {
            //print("Setting client ID to \(new_client_id)")
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

    //    @asyncio.coroutine
    //    def disconnect(self):
    //        """Gracefully disconnect from the server.
    //
    //        When disconnection is complete, Client.connect will return.
    //        """
    //        self._listen_future.cancel()
    //        self._connector.close()
    
    func setActive() {
        // Set this client as active.
        //    While a client is active, no other clients will raise notifications.
        //    Call this method whenever there is an indication the user is
        //    interacting with this client. This method may be called very
        //    frequently, and it will only make a request when necessary.
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
    
    //    ##########################################################################
    //    # Private methods
    //    ##########################################################################
    

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
        // In case this doesn't work, extract these cookies manually.
        //  required_cookies = ['SAPISID', 'HSID', 'SSID', 'APISID', 'SID']
        let params = [
            "key": self.api_key!,
            "alt": use_json ? "json" : "protojson",
        ]
        let url = NSURL(string: (path + "?" + params.urlEncodedQueryStringWithEncoding(NSUTF8StringEncoding)))!

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = data

        for (k, v) in getAuthorizationHeaders(self.channel!.getCookieValue("SAPISID")!) {
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

    func syncAllNewEvents(timestamp: NSDate, cb: (response: CLIENT_SYNC_ALL_NEW_EVENTS_RESPONSE?) -> Void) {
        //    List all events occurring at or after timestamp.
        //
        //    This method requests protojson rather than json so we have one chat
        //    message parser rather than two.
        //
        //    timestamp: datetime.datetime instance specifying the time after
        //    which to return all events occurring in.

        let data: NSArray = [
            self.getRequestHeader(),

            // last_sync_timestamp
            to_timestamp(timestamp),

            [], NSNull(), [], false, [],

            // max_response_size_bytes
            1048576
        ]
        self.request("conversations/syncallnewevents", body: data, use_json: false) { r in
            cb(response: PBLiteSerialization.parseProtoJSON(r.result.value!))
        }
    }

    func sendChatMessage(conversation_id: String,
        segments: [NSArray],
        image_id: String? = nil,
        otr_status: OffTheRecordStatus = .ON_THE_RECORD,
        cb: (() -> Void)? = nil
    ) {
        //    Send a chat message to a conversation.
        //
        //    conversation_id must be a valid conversation ID. segments must be a
        //    list of message segments to send, in pblite format.
        //
        //    otr_status determines whether the message will be saved in the server's
        //    chat history. Note that the OTR status of the conversation is
        //    irrelevant, clients may send messages with whatever OTR status they
        //    like.
        //
        //    image_id is an option ID of an image retrieved from
        //    Client.upload_image. If provided, the image will be attached to the
        //    message.

        let client_generated_id = generateClientID()
        let body = [
            self.getRequestHeader(),
            NSNull(), NSNull(), NSNull(), [],
            [
                segments, []
            ],
            image_id != nil ? [[image_id!, false]] : NSNull(),
            [
                [conversation_id],
                client_generated_id,
                otr_status.representation,
            ],
            NSNull(), NSNull(), NSNull(), []
        ]
        self.request("conversations/sendchatmessage", body: body) {
            // sendchatmessage can return 200 but still contain an error
            r in self.verifyResponseOK(r.result.value!); cb?()
        }
    }

    //    @asyncio.coroutine
    //    def upload_image(self, image_file, filename=nil):
    //        """Upload an image that can be later attached to a chat message.
    //
    //        image_file is a file-like object containing an image.
    //
    //        The name of the uploaded file may be changed by specifying the filename
    //        argument.
    //
    //        Raises hangups.NetworkError if the request fails.
    //
    //        Returns ID of uploaded image.
    //        """
    //        image_filename = (filename if filename
    //                          else os.path.basename(image_file.name))
    //        image_data = image_file.read()
    //
    //        # Create image and request upload URL
    //        res1 = yield from self._base_request(
    //            IMAGE_UPLOAD_URL,
    //            'application/x-www-form-urlencoded;charset=UTF-8',
    //            json.dumps({
    //                "protocolVersion": "0.8",
    //                "createSessionRequest": {
    //                    "fields": [{
    //                        "external": {
    //                            "name": "file",
    //                            "filename": image_filename,
    //                            "put": {},
    //                            "size": len(image_data),
    //                        }
    //                    }]
    //                }
    //            }))
    //        upload_url = (json.loads(res1.body.decode())['sessionStatus']
    //                      ['externalFieldTransfers'][0]['putInfo']['url'])
    //
    //        # Upload image data and get image ID
    //        res2 = yield from self._base_request(
    //            upload_url, 'application/octet-stream', image_data
    //        )
    //        return (json.loads(res2.body.decode())['sessionStatus']
    //                ['additionalInfo']
    //                ['uploader_service.GoogleRupioAdditionalInfo']
    //                ['completionInfo']['customerSpecificInfo']['photoid'])
    //
    func setActiveClient(is_active: Bool, timeout_secs: Int, cb: (() -> Void)? = nil) {
        let data: Array<AnyObject> = [
            self.getRequestHeader(),
            // is_active: whether the client is active or not
            is_active,
            // full_jid: user@domain/resource
            "\(email!)/" + (client_id ?? ""),
            // timeout_secs: timeout in seconds for this client to be active
            timeout_secs
        ]

        // Set the active client.
        self.request("clients/setactiveclient", body: data, use_json: true) {
            r in self.verifyResponseOK(r.result.value!); cb?()
        }
    }
    
    //    ###########################################################################
    //    # UNUSED raw API request methods (by hangups itself) for reference
    //    ###########################################################################
    //
    func removeuser(conversation_id: String, cb: (() -> Void)? = nil) {
        // Leave group conversation.
        // conversation_id must be a valid conversation ID.
        self.request("conversations/removeuser", body: [
            self.getRequestHeader(),
            NSNull(), NSNull(), NSNull(),
            [[conversation_id], generateClientID(), 2],
        ]) { r in self.verifyResponseOK(r.result.value!); cb?() }
    }

    func deleteConversation(conversation_id: String, cb: (() -> Void)? = nil) {
        // Delete one-to-one conversation.
        // conversation_id must be a valid conversation ID.

        self.request("conversations/deleteconversation", body: [
            self.getRequestHeader(),
            [conversation_id],
            // Not sure what timestamp should be there, last time I have tried
            // it Hangouts client in GMail sent something like now() - 5 hours
            to_timestamp(NSDate()), // TODO: This should be in UTC
            NSNull(), []
        ]) { r in self.verifyResponseOK(r.result.value!); cb?() }
    }

    func setTyping(conversation_id: String, typing: TypingType = TypingType.STARTED, cb: (() -> Void)? = nil) {
        // Send typing notification.
        let data = [
            self.getRequestHeader(),
            [conversation_id],
            typing.representation
        ]
        self.request("conversations/settyping", body: data) {
            r in self.verifyResponseOK(r.result.value!); cb?()
        }
    }

    func updateWatermark(conv_id: String, read_timestamp: NSDate, cb: (() -> Void)? = nil) {
        // Update the watermark (read timestamp) for a conversation.

        self.request("conversations/updatewatermark", body: [
            self.getRequestHeader(),
            // conversation_id
            [conv_id],
            // latest_read_timestamp
            to_timestamp(read_timestamp),
        ]) { r in self.verifyResponseOK(r.result.value!); cb?() }
    }

    //    @asyncio.coroutine
    //    def getselfinfo(self):
    //        """Return information about your account.
    //
    //        Raises hangups.NetworkError if the request fails.
    //        """
    //        self.request('contacts/getselfinfo', [
    //            self.getRequestHeader(),
    //            [], []
    //        ])
    //        return json.loads(res.body.decode())

    func setFocus(conversation_id: String, cb: (() -> Void)? = nil) {
        // Set focus (occurs whenever you give focus to a client).

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
    //
    //    @asyncio.coroutine
    //    def setpresence(self, online, mood=nil):
    //        """Set the presence or mood of this client.
    //
    //        Raises hangups.NetworkError if the request fails.
    //        """
    //        self.request('presence/setpresence', [
    //            self.getRequestHeader(),
    //            [
    //                # timeout_secs timeout in seconds for this presence
    //                720,
    //                # client_presence_state:
    //                # 40 => DESKTOP_ACTIVE
    //                # 30 => DESKTOP_IDLE
    //                # 1 => nil
    //                1 if online else 40,
    //            ],
    //            nil,
    //            nil,
    //            # True if going offline, False if coming online
    //            [not online],
    //            # UTF-8 smiley like 0x1f603
    //            [mood],
    //        ])
    //        res = json.loads(res.body.decode())
    //        res_status = res['response_header']['status']
    //        if res_status != 'OK':
    //            raise exceptions.NetworkError('Unexpected status: {}'
    //                                          .format(res_status))
    //
    //    @asyncio.coroutine
    //    def querypresence(self, chat_id):
    //        """Check someone's presence status.
    //
    //        Raises hangups.NetworkError if the request fails.
    //        """
    //        self.request('presence/querypresence', [
    //            self.getRequestHeader(),
    //            [
    //                [chat_id]
    //            ],
    //            [1, 2, 5, 7, 8]
    //        ])
    //        return json.loads(res.body.decode())

    func getEntitiesByID(chat_id_list: [String], cb: (CLIENT_GET_ENTITY_BY_ID_RESPONSE) -> Void) {
        // Return information about a list of contacts.

        let data = [self.getRequestHeader(), NSNull(), chat_id_list.map { [$0] }]
        self.request("contacts/getentitybyid", body: data, use_json: false) { r in
			let obj: CLIENT_GET_ENTITY_BY_ID_RESPONSE? = PBLiteSerialization.parseProtoJSON(r.result.value!)
			cb(obj!)
        }
    }

    func getConversation(
        conversation_id: String,
        event_timestamp: NSDate,
        max_events: Int = 50,
        cb: (CLIENT_GET_CONVERSATION_RESPONSE) -> Void
    ) {
        //    Return conversation events.
        //
        //    This is mainly used for retrieving conversation scrollback. Events
        //    occurring before event_timestamp are returned, in order from oldest to
        //    newest.

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
        ], use_json: false) {
            r in
            //  TODO: Undo the sins done here
            let result = JSContext().evaluateScript("a = " + (NSString(data: r.result.value!, encoding: NSUTF8StringEncoding)! as String)).toArray()
            cb(PBLiteSerialization.parseArray(CLIENT_GET_CONVERSATION_RESPONSE.self, input: result)!)
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

    func setChatName(conversation_id: String, name: String, cb: (() -> Void)? = nil) {
        // Set the name of a conversation.
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
    //
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
    //
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

typealias InitialData = (
    conversation_states: [CLIENT_CONVERSATION_STATE],
    self_entity: CLIENT_ENTITY,
    entities: [CLIENT_ENTITY],
    conversation_participants: [CLIENT_CONVERSATION_PARTICIPANT_DATA],
    sync_timestamp: NSDate?
)