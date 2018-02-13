import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Client")
internal let hangoutsCenter = NotificationCenter()


/*
 UNIMPLEMENTED PROTOBUF:
 
 * For `UpdateFavoriteContact`:
 ```
 //LOCATION: contacts/updatefavoritecontact
 //REQUEST: [[[44,3,"chat_frontend_20170704.12_p0",1499200377],["lcsw_hangouts_09AD1933","A7FBD6D5E46F7388"],null,"en"],[[[["110325279767392021429"]],true]],""]
 //RESPONSE: ["cufcrp",[4,null,""],1,[[["110325279767392021429","110325279767392021429"]],[["116593784082165979236","116593784082165979236"]],[["114754752003084982184","114754752003084982184"]]],"CAAQ4Ma8w5+C1QI\u003d"]
 //REQUEST: [[[44,3,"chat_frontend_20170704.12_p0",1499200377],["lcsw_hangouts_09AD1933","A7FBD6D5E46F7388"],null,"en"],[[[["110325279767392021429"]],true]],"CAAQ4Ma8w5+C1QI="]
 //RESPONSE: ["cufcrp",[1,null,""],null,[],"CAAQkoTr16KC1QI\u003d"]
 ```
 
 * For `DismissSuggestedContacts`:
 ```
 //LOCATION: contacts/dismisssuggestedcontacts
 //REQUEST: [[[44,3,"chat_frontend_20170704.12_p0",1499200377],["lcsw_hangouts_DB3E7684","5D774512E46F7388"],null,"en"],[["114754752003084982184"]]]
 //RESPONSE: ["cdscrp",[1,null,"","-2446617729322783353",1499812078776000],[["114754752003084982184","114754752003084982184"]]]
 ```
 
 */

public final class Client: Service {
	
	// NotificationCenter notification and userInfo keys.
	internal static let didConnectNotification = Notification.Name(rawValue: "Hangouts.Client.DidConnect")
	internal static let didDisconnectNotification = Notification.Name(rawValue: "Hangouts.Client.DidDisconnect")
	internal static let didUpdateStateNotification = Notification.Name(rawValue: "Hangouts.Client.UpdateState")
	internal static let didUpdateStateKey = "Hangouts.Client.UpdateState.Key"
	
	// Timeout to send for setactiveclient requests:
	public static let ACTIVE_TIMEOUT_SECS: UInt64 = 60 * 5 // 5 minutes
	// Minimum timeout between subsequent setactiveclient requests:
	public static let SETACTIVECLIENT_LIMIT_SECS: UInt64 = 60 // 1 minute
    public var last_active_secs: NSNumber? = 0
    public var active_client_state: ActiveClientState?
	
	public var channel: Channel?
    
    /// The internal operation queue to use.
    // TODO: opQueue should be serial!
    internal var opQueue = DispatchQueue(label: "Hangouts.Client", qos: .userInitiated, attributes: .concurrent)
	
	public var email: String?
	public var client_id: String?
    
    /// The last logged time that we received a BatchUpdate from the server.
    private var lastUpdate: UInt64 = 0
	
	public private(set) var conversationList: ConversationList!
	public private(set) var userList: UserList!
	
	public init(configuration: URLSessionConfiguration) {
        self.channel = Channel(configuration: configuration)
        self.userList = UserList(client: self)
        self.conversationList = ConversationList(client: self)
        
        //
        // A notification-based delegate replacement:
        //
        
        let _c = hangoutsCenter
        let a = _c.addObserver(forName: Channel.didConnectNotification, object: self.channel, queue: nil) { _ in
            NotificationCenter.default.post(name: Notification.Service.DidConnect, object: self)
            self.synchronize()
        }
        let b = _c.addObserver(forName: Channel.didDisconnectNotification, object: self.channel, queue: nil) { _ in
            NotificationCenter.default.post(name: Notification.Service.DidDisconnect, object: self)
        }
        let c = _c.addObserver(forName: Channel.didReceiveMessageNotification, object: self.channel, queue: nil) { note in
            if let val = (note.userInfo)?[Channel.didReceiveMessageKey] as? [Any] {
                self.channel(channel: self.channel!, didReceiveMessage: val)
            } else {
                log.error("Encountered an error! \(note)")
            }
        }
        self.tokens.append(contentsOf: [a, b, c])
    }
    
    deinit {
        
        // Remove all the observers so we aren't receiving calls later on.
        self.tokens.forEach {
            hangoutsCenter.removeObserver($0)
        }
    }
	
	private var tokens = [NSObjectProtocol]()
	
	public static var identifier: String {
		return "com.google.hangouts"
	}
	
	public static var name: String {
		return "Hangouts"
	}
    
    public static var capabilities: Capabilities {
        return Capabilities(rawValue: 0) // placeholder!
    }
	
	// Establish a connection to the chat server.
    public func connect() {
        self.channel?.listen()
    }
	
	///
	public var directory: Directory {
		return self.userList // FIXME: DEATH OVER HERE!
	}
	
	///
	public var conversations: ParrotServiceExtension.ConversationList {
		return self.conversationList
	}
	
	/* TODO: Can't disconnect a Channel yet. */
	// Gracefully disconnect from the server.
	public func disconnect() {
		self.channel?.disconnect()
	}
	
    public var connected: Bool {
        return self.channel?.isConnected ?? false
    }
    public func synchronize() {
        guard self.lastUpdate > 0 else { return }
        let req = SyncAllNewEventsRequest(last_sync_timestamp: self.lastUpdate,
                                          max_response_size_bytes: 1048576)
        self.execute(req) { res, _ in
            for conv_state in res!.conversation_state {
                if let conv = self.conversationList.conv_dict[conv_state.conversation_id!.id!] {
                    conv.update_conversation(conversation: conv_state.conversation!)
                    for event in conv_state.event {
                        guard event.timestamp! > self.lastUpdate else { continue }
                        
                        if let conv = self.conversationList.conv_dict[event.conversation_id!.id!] {
                            let conv_event = conv.add(event: event)
                            
                            //self.conversationList.delegate?.conversationList(self.conversationList, didReceiveEvent: conv_event)
                            conv.handleEvent(event: conv_event)
                        } else {
                            log.info("Received ClientEvent for unknown conversation \(event.conversation_id!.id!)")
                        }
                    }
                } else {
                    self.conversationList.add_conversation(client_conversation: conv_state.conversation!, client_events: conv_state.event)
                }
            }
            
            // Update the sync timestamp otherwise if we lose connectivity again, we re-sync everything.
            self.lastUpdate = res!.sync_timestamp!
            NotificationCenter.default.post(name: Notification.Service.DidSynchronize, object: self)
        }
	}
	
	// Set this client as active.
	// While a client is active, no other clients will raise notifications.
	// Call this method whenever there is an indication the user is
	// interacting with this client. This method may be called very
	// frequently, and it will only make a request when necessary.
	public func setInteractingIfNeeded() {
		
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
			last_active_secs = Date().timeIntervalSince1970 as NSNumber?
            
			// The first time this is called, we need to retrieve the user's email address.
			if self.email == nil {
                if self.userList.me.locations.count > 0 {
                    self.email = self.userList.me.locations[0]
                } else {
                    let res = try? self.execute(GetSelfInfoRequest())
                    self.email = res!.self_entity!.properties!.email[0] as String
                }
			}
            
            let req = SetActiveClientRequest(is_active: true,
                                             full_jid: "\(self.email!)/" + (self.client_id ?? ""),
                                             timeout_secs: Client.ACTIVE_TIMEOUT_SECS)
            self.execute(req) {_,_ in}
        }
	}
    
    // Parse channel array and call the appropriate events.
    public func channel(channel: Channel, didReceiveMessage message: [Any]) {
        
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
        func addChannelServices(services: [String] = ["babel", "babel_presence_last_seen"]) {
            let mapped = services.map { ["3": ["1": ["1": $0]]] }.map {
                let dat = try! JSONSerialization.data(withJSONObject: $0, options: [])
                return NSString(data: dat, encoding: String.Encoding.utf8.rawValue)! as String
                }.map { ["p": $0] }
            self.channel?.sendMaps(mapped)
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
        if let id = wrapper["3"] as? [String: Any] {
            self.client_id = (id["2"] as! String)
            addChannelServices()
        }
        if let cbu = wrapper["2"] as? [String: Any] {
            let val2 = (cbu["2"]! as! String).data(using: String.Encoding.utf8)
            var payload = try! JSONSerialization.jsonObject(with: val2!, options: .allowFragments) as! [AnyObject]
            
            // This is a (Client)BatchUpdate containing StateUpdate messages.
            // payload[1] is a list of state updates.
            if payload[0] as? String == "cbu" {
                payload.remove(at: 0) // since we're using a decode(...) variant
                let b: BatchUpdate = try! PBLiteDecoder().decode(payload)
                for state_update in b.state_update {
                    self.active_client_state = state_update.state_update_header!.active_client_state!
                    self.lastUpdate = state_update.state_update_header!.current_server_time!
                    
                    hangoutsCenter.post(
                        name: Client.didUpdateStateNotification, object: self,
                        userInfo: [Client.didUpdateStateKey: state_update])
                }
            } else {
                log.info("Ignoring message: \(payload[0])")
            }
        }
    }
    
    /// Asynchronously execute the API transaction with the service endpoint.
    /// - `request`: The request to send the service endpoint.
    /// - `handler`: The response from executing the operation, or any error that occurred.
    internal func execute<T: ServiceRequest>(_ request: T, handler: @escaping (T.Response?, Error?) -> ()) {
        self.opQueue.async {
            do {
                var request = request // shadow
                request.request_header = RequestHeader.header(for: self.client_id)
                let input: Any = try PBLiteEncoder().encode(request)
                
                let endpoint = type(of: request).location
                log.debug("REQUEST: \(endpoint)")
                let data = try JSONSerialization.data(withJSONObject: input, options: [])
                self.channel?.base_request(path: "https://clients6.google.com/chat/v1/\(endpoint)",
                content_type: "application/json+protobuf", data: data, use_json: false) { r in
                    guard let response = r.data else {
                        return handler(nil, r.error ?? ServiceError.unknown)
                    }
                    
                    do {
                        let output: T.Response = try PBLiteDecoder().decode(data: response)!
                        if output.response_header!.status! == .Ok {
                            handler(output, nil)
                        } else {
                            handler(nil, ServiceError.server(output.response_header!.status!,
                                                             output.response_header!.error_description!))
                        }
                    } catch(let error) {
                        handler(nil, error)
                    }
                }
            } catch(let error) {
                handler(nil, error)
            }
        }
    }
    
    /// Synchronously execute the API transaction with the service endpoint.
    /// - `request`: The request to send the service endpoint.
    /// - `handler`: The response from executing the operation, or any error that occurred.
    internal func execute<T: ServiceRequest>(_ request: T) throws -> T.Response {
        return try self.opQueue.sync {
            var request = request // shadow
            request.request_header = RequestHeader.header(for: self.client_id)
            let input: Any = try PBLiteEncoder().encode(request)
            
            let endpoint = type(of: request).location
            log.debug("REQUEST: \(endpoint)")
            let data = try JSONSerialization.data(withJSONObject: input, options: [])
            
            var result: Result? = nil
            let sem = DispatchSemaphore(value: 0)
            self.channel?.base_request(path: "https://clients6.google.com/chat/v1/\(endpoint)",
            content_type: "application/json+protobuf", data: data, use_json: false) { r in
                result = r
                sem.signal()
            }
            sem.wait()
            
            guard let response = result?.data else {
                throw result?.error ?? ServiceError.unknown
            }
            
            let output: T.Response = try PBLiteDecoder().decode(data: response)!
            if output.response_header!.status! != .Ok {
                throw ServiceError.server(output.response_header!.status!,
                                                 output.response_header!.error_description!)
            }
            
            return output
        }
    }
}

public extension RequestHeader {
    public static func header(for clientID: String? = "") -> RequestHeader {
        return RequestHeader(client_version: ClientVersion(major_version: "parrot"),
                             client_identifier: ClientIdentifier(resource: clientID),
                             language_code: "en")
    }
    public static func uniqueID() -> UInt64 {
        return random64(UInt64(pow(2.0, 32.0)))
    }
}
