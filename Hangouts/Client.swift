import Foundation
import ParrotServiceExtension

internal let log = Logger(subsystem: "com.avaidyam.Hangouts.global")

public final class Client: Service {
	
	// URL for uploading any URL to Photos
	public static let IMAGE_UPLOAD_URL = "https://docs.google.com/upload/photos/resumable"
	
	// NotificationCenter notification and userInfo keys.
	public static let didConnectNotification = Notification.Name(rawValue: "Hangouts.Client.DidConnect")
	public static let didReconnectNotification = Notification.Name(rawValue: "Hangouts.Client.DidReconnect")
	public static let didDisconnectNotification = Notification.Name(rawValue: "Hangouts.Client.DidDisconnect")
	public static let didUpdateStateNotification = Notification.Name(rawValue: "Hangouts.Client.UpdateState")
	public static let didUpdateStateKey = Notification.Name(rawValue: "Hangouts.Client.UpdateState.Key")
	
	// Timeout to send for setactiveclient requests:
	public static let ACTIVE_TIMEOUT_SECS = 120
	
	// Minimum timeout between subsequent setactiveclient requests:
	public static let SETACTIVECLIENT_LIMIT_SECS = 60
	
	public let config: URLSessionConfiguration
	public var channel: Channel?
	
	public var email: String?
	public var client_id: String?
	public var last_active_secs: NSNumber? = 0
	public var active_client_state: ActiveClientState?
	
	public private(set) var conversationList: ConversationList!
	public private(set) var userList: UserList!
	
	public init(configuration: URLSessionConfiguration) {
		self.config = configuration
    }
	
	private var tokens = [NSObjectProtocol]()
	
	public static var identifier: String {
		return "com.google.hangouts"
	}
	
	public static var name: String {
		return "Hangouts"
	}
	
	// Establish a connection to the chat server.
    public func connect(_ onConnect: (ErrorProtocol?) -> ()) {
		self.channel = Channel(configuration: self.config)
		//self.channel?.delegate = self
		self.channel?.listen()
		
		// 
		// A notification-based delegate replacement:
		//
		
		let _c = NotificationCenter.default()
		let a = _c.addObserver(forName: Channel.didConnectNotification, object: self.channel, queue: nil) { _ in
			NotificationCenter.default().post(name: Client.didConnectNotification, object: self)
		}
		let b = _c.addObserver(forName: Channel.didReconnectNotification, object: self.channel, queue: nil) { _ in
			NotificationCenter.default().post(name: Client.didReconnectNotification, object: self)
		}
		let c = _c.addObserver(forName: Channel.didDisconnectNotification, object: self.channel, queue: nil) { _ in
			NotificationCenter.default().post(name: Client.didDisconnectNotification, object: self)
		}
		let d = _c.addObserver(forName: Channel.didReceiveMessageNotification, object: self.channel, queue: nil) { note in
			if let val = (note.userInfo)?[Channel.didReceiveMessageKey.rawValue] as? [AnyObject] {
				self.channel(channel: self.channel!, didReceiveMessage: val)
			} else {
				log.error("Encountered an error! \(note)")
			}
		}
		self.tokens.append(contentsOf: [a, b, c, d])
    }
	
	///
	public var directory: Directory {
		return self.userList
	}
	
	///
	public var conversations: ParrotServiceExtension.ConversationList {
		return self.conversationList
	}
	
	/* TODO: Can't disconnect a Channel yet. */
	// Gracefully disconnect from the server.
	public func disconnect(_ onDisconnect: (ErrorProtocol?) -> ()) {
		//self.channel?.disconnect()
		
		// Remove all the observers so we aren't receiving calls later on.
		self.tokens.forEach {
			NotificationCenter.default().removeObserver($0)
		}
	}
	
	public var connected: Bool = true
	public func synchronize(_ onSynchronize: (ErrorProtocol?) -> ()) {
		
	}
	
	// Set this client as active.
	// While a client is active, no other clients will raise notifications.
	// Call this method whenever there is an indication the user is
	// interacting with this client. This method may be called very
	// frequently, and it will only make a request when necessary.
	public func setActive() {
		
		// If the client_id hasn't been received yet, we can't set the active client.
		guard self.client_id != nil else {
			log.error("Cannot set active client until client_id is received")
			return
		}
		
		let is_active = (active_client_state == ActiveClientState.IsActive)
		let time_since_active = (Date().timeIntervalSince1970 - last_active_secs!.doubleValue)
		let timed_out = time_since_active > Double(Client.SETACTIVECLIENT_LIMIT_SECS)
		
		if !is_active || timed_out {
			
			// Update these immediately so if the function is called again
			// before the API request finishes, we don't start extra requests.
			active_client_state = ActiveClientState.IsActive
			last_active_secs = Date().timeIntervalSince1970
			
			
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
	public func uploadImage(data: Data, filename: String, cb: ((String) -> Void)? = nil) {
		let json = "{\"protocolVersion\":\"0.8\",\"createSessionRequest\":{\"fields\":[{\"external\":{\"name\":\"file\",\"filename\":\"\(filename)\",\"put\":{},\"size\":\(data.count)}}]}}"
		
		self.channel?.base_request(path: Client.IMAGE_UPLOAD_URL,
			content_type: "application/x-www-form-urlencoded;charset=UTF-8",
			data: json.data(using: String.Encoding.utf8)!) { response in
			
			// Sift through JSON for a response with the upload URL.
				let _data: NSDictionary = try! JSONSerialization.jsonObject(with: response.data!,
				options: .allowFragments) as! NSDictionary
			let _a = _data["sessionStatus"] as! NSDictionary
			let _b = _a["externalFieldTransfers"] as! NSArray
			let _c = _b[0] as! NSDictionary
			let _d = _c["putInfo"] as! NSDictionary
			let upload = (_d["url"] as! NSString) as String
			
			self.channel?.base_request(path: upload, content_type: "application/octet-stream", data: data) { resp in
				
				// Sift through JSON for a response with the photo ID.
				let _data2: NSDictionary = try! JSONSerialization.jsonObject(with: resp.data!,
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
		func addChannelServices() {
			let inner = ["3": ["1": ["1": "babel"]]]
			let dat = try! JSONSerialization.data(withJSONObject: inner, options: [])
			let str = NSString(data: dat, encoding: String.Encoding.utf8.rawValue) as! String
			
			self.channel?.sendMaps(mapList: [["p": str]])
		}
		
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
			addChannelServices()
		}
		if let cbu = wrapper["2"] as? [String: AnyObject] {
			let val2 = (cbu["2"]! as! String).data(using: String.Encoding.utf8)
			let payload = try! JSONSerialization.jsonObject(with: val2!, options: .allowFragments)
			
			// This is a (Client)BatchUpdate containing StateUpdate messages.
			// payload[1] is a list of state updates.
			if payload[0] as? String == "cbu" {
				var b = BatchUpdate() as ProtoMessage
				PBLiteSerialization.decode(message: &b, pblite: payload as! [AnyObject], ignoreFirstItem: true)
				for state_update in (b as! BatchUpdate).stateUpdate {
					self.active_client_state = state_update.stateUpdateHeader!.activeClientState!
					NotificationCenter.default().post(
						name: Client.didUpdateStateNotification, object: self,
						userInfo: [Client.didUpdateStateKey: Wrapper(state_update)])
				}
			} else {
				log.warning("Ignoring message: \(payload[0])")
			}
		}
	}
	
	public func buildUserConversationList(_ completionHandler: () -> Void = {}) {
		
		// Retrieve recent conversations so we can preemptively look up their participants.
		self.syncRecentConversations { response in
			let conv_states = response!.conversationState
			let sync_timestamp = response!.syncTimestamp// use current_server_time?
			
			var required_user_ids = Set<User.ID>()
			for conv_state in conv_states {
				let participants = conv_state.conversation!.participantData
				required_user_ids = required_user_ids.union(Set(participants.map {
					User.ID(chatID: $0.id!.chatId!, gaiaID: $0.id!.gaiaId!)
				}))
			}
			
			var required_entities = [Entity]()
			self.getEntitiesByID(chat_id_list: required_user_ids.map { $0.chatID }) { resp in
				required_entities = resp?.entityResult.flatMap { $0.entity } ?? []
				
				// Let's request our own entity now.
				self.getSelfInfo {
					let selfUser = User(entity: $0!.selfEntity!, selfUser: nil)
					var users = [selfUser]
					
					// Add each entity as a new User.
					for entity in required_entities {
						let user = User(entity: entity, selfUser: selfUser.id)
						users.append(user)
					}
					
					let userList = UserList(client: self, me: selfUser, users: users)
					let conversationList = ConversationList(client: self, conv_states: conv_states, user_list: userList, sync_timestamp: sync_timestamp)
					self.conversationList = conversationList
					self.userList = userList
					completionHandler()
				}
			}
		}
	}
}
