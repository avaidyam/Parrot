import Foundation
import ParrotServiceExtension

/* TODO: Fix the retry semantics instead of what we have right now. */
/* TODO: Auto-turn a callback into a blocking using semaphores. */

public final class Channel : NSObject {
	
	// The prefix for any BrowserChannel endpoint.
	private static let URLPrefix = "https://0.client-channel.google.com/client-channel"
	
	// Long-polling requests send heartbeats every 15 seconds,
	// so if we miss two in a row, consider the connection dead.
	private static let connectTimeout = 30
	private static let pushTimeout = 30
	private static let maxBytesRead = 1024 * 1024
	private static let maxRetries = 5
	
	// NotificationCenter notification and userInfo keys.
	public static let didConnectNotification = Notification.Name(rawValue: "Hangouts.Channel.DidConnect")
	public static let didDisconnectNotification = Notification.Name(rawValue: "Hangouts.Channel.DidDisconnect")
	public static let didReceiveMessageNotification = Notification.Name(rawValue: "Hangouts.Channel.ReceiveMessage")
	public static let didReceiveMessageKey = Notification.Name(rawValue: "Hangouts.Channel.ReceiveMessage.Key")
	
	// Parse data from the backward channel into chunks.
	// Responses from the backward channel consist of a sequence of chunks which
	// are streamed to the client. Each chunk is prefixed with its length,
	// followed by a newline. The length allows the client to identify when the
	// entire chunk has been received.
	internal class ChunkParser {
		
		internal var buf = NSMutableData()
		
		// Yield submissions generated from received data.
		// Responses from the push endpoint consist of a sequence of submissions.
		// Each submission is prefixed with its length followed by a newline.
		// The buffer may not be decodable as UTF-8 if there's a split multi-byte
		// character at the end. To handle this, do a "best effort" decode of the
		// buffer to decode as much of it as possible.
		// The length is actually the length of the string as reported by
		// JavaScript. JavaScript's string length function returns the number of
		// code units in the string, represented in UTF-16. We can emulate this by
		// encoding everything in UTF-16 and multipling the reported length by 2.
		// Note that when encoding a string in UTF-16, Python will prepend a
		// byte-order character, so we need to remove the first two bytes.
		internal func getChunks(newBytes: Data) -> [String] {
			buf.append(newBytes)
			var submissions = [String]()
			
			while buf.length > 0 {
				if let decoded = bestEffortDecode(data: buf) {
					let bufUTF16 = decoded.data(using: String.Encoding.utf16BigEndian)!
					let decodedUtf16LengthInChars = bufUTF16.count / 2
					
					let lengths = decoded.findAllOccurrences(matching: "([0-9]+)\n", all: true)
					if let length_str = lengths.first { //length_str.endIndex.advancedBy(n: -1)
						let length_str_without_newline = length_str.substring(to: length_str.index(length_str.endIndex, offsetBy: -1))
						if let length = Int(length_str_without_newline) {
							if (decodedUtf16LengthInChars - length_str.utf16.count) < length {
								break
							}
							
							let subData = bufUTF16.subdata(in: NSMakeRange(length_str.utf16.count * 2, length * 2).toRange()!)
							let submission = NSString(data: subData, encoding: String.Encoding.utf16BigEndian.rawValue)! as String
							submissions.append(submission)
							
							let submissionAsUTF8 = submission.data(using: String.Encoding.utf8)!
							
							let removeRange = NSMakeRange(0, (length_str.utf16.count + submissionAsUTF8.count))
							buf.replaceBytes(in: removeRange, withBytes: nil, length: 0)
						} else {
							break
						}
					} else {
						break
					}
				}
			}
			return submissions
		}
		
		// Decode data_bytes into a string using UTF-8.
		// If data_bytes cannot be decoded, pop the last byte until it can be or
		// return an empty string.
		private func bestEffortDecode(data: NSMutableData) -> String? {
			for i in 0 ..< data.length {
				if let s = NSString(data: data.subdata(with: NSMakeRange(0, (data.length - i))), encoding: String.Encoding.utf8.rawValue) {
					return s as String
				}
			}
			return nil
		}
	}
	
	// For use in Client:
	internal var session = URLSession()
	internal var proxy = URLSessionDelegateProxy()
	
    internal var isConnected = false
    internal var onConnectCalled = false
	private var chunkParser: ChunkParser? = nil
    private var sidParam: String? = nil
    private var gSessionIDParam: String? = nil
	private var retries = Channel.maxRetries
    private var needsSID = true
	
	public init(configuration: URLSessionConfiguration) {
		super.init()
		session = URLSession(configuration: configuration,
		                     delegate: self.proxy, delegateQueue: nil)
	}
	
	// Listen for messages on the backwards channel.
	// This method only returns when the connection has been closed due to an error.
	public func listen() {
        log.debug("listen invoked! needs SID? \(self.needsSID)")
        
        // Request a new SID if we don't have one yet, or the previous one became invalid.
        if self.needsSID {
            let s = DispatchSemaphore(value: 0)
            self.fetchChannelSID {
                s.signal()
            }
            _ = s.wait(timeout: .distantFuture)
            self.needsSID = false
        }
        
        log.debug("cleaned chunk parser and starting request...")
        
        // Clear any previous push data, since if there was an error it could contain garbage.
        self.chunkParser = ChunkParser()
        self.longPollRequest()
    }
    
    // Creates a new channel for receiving push data.
    // There's a separate API to get the gsessionid alone that Hangouts for
    // Chrome uses, but if we don't send a gsessionid with this request, it
    // will return a gsessionid as well as the SID.
    private func fetchChannelSID(cb: ((Void) -> Void)? = nil) {
        self.sidParam = nil
        self.gSessionIDParam = nil
        log.debug("sending maps...")
        self.sendMaps {
            let r = Channel.parseSIDResponse(res: $0)
            log.debug("received response \(r)")
            self.sidParam = r.sid
            self.gSessionIDParam = r.gSessionID
            cb?()
        }
    }
	
	// Sends a request to the server containing maps (dicts).
	public func sendMaps(mapList: [[String: AnyObject]]? = nil, cb: ((Data) -> Void)? = nil) {
		var params = [
			"VER":		8,			// channel protocol version
			"RID":		81188,		// request identifier
			"ctype":	"hangouts",	// client type
		]
		if self.gSessionIDParam != nil {
			params["gsessionid"] = self.gSessionIDParam!
		}
		if self.sidParam != nil {
			params["SID"] = self.sidParam!
		}
		
		var data_dict = [
			"count": mapList?.count ?? 0,
			"ofs": 0
        ] as [String: AnyObject]
		
		if let mapList = mapList {
			for (map_num, map_) in mapList.enumerated() {
				for (map_key, map_val) in map_ {
					data_dict["req\(map_num)_\(map_key)"] = map_val
				}
			}
		}
		
		let url = "\(Channel.URLPrefix)/channel/bind?\(params.encodeURL())"
		var request = URLRequest(url: URL(string: url)!)
		request.httpMethod = "POST"
		/* TODO: Clearly, we shouldn't call encodeURL(), but what do we do? */
		request.httpBody = data_dict.encodeURL().data(using: String.Encoding.utf8,
			allowLossyConversion: false)!
		for (k, v) in Channel.getAuthorizationHeaders(Channel.getCookieValue(key: "SAPISID")!) {
			request.setValue(v, forHTTPHeaderField: k)
		}
		
        log.debug("maps about to go out!")
        // If the network is not connected at the time this request is made, 
        // then the internal SPI logs: `[57] Socket not connected` without
        // erroring up here. Therefore, you should always wait until the network 
        // is connected or queue it.
		self.session.request(request: request) {
			guard let data = $0.data else {
				log.error("(maps) Request failed with error: \($0.error!)")
				return
			}
            log.debug("maps succeeded!")
			cb?(data)
		}
	}
	
	// Open a long-polling request and receive push data.
	// This method uses keep-alive to make re-opening the request faster, but
	// the remote server will set the "Connection: close" header once an hour.
	private func longPollRequest() {
		let params: [String: AnyObject] = [
			"VER": 8,  // channel protocol version
			"gsessionid": self.gSessionIDParam ?? "",
			"RID": "rpc",  // request identifier
			"t": 1,  // trial
			"SID": self.sidParam ?? "",  // session ID
			"CI": 0,  // 0 if streaming/chunked requests should be used
			"ctype": "hangouts",  // client type
			"TYPE": "xmlhttp",  // type of request
		]
		
		let url = "\(Channel.URLPrefix)/channel/bind?\(params.encodeURL())"
		var request = URLRequest(url: URL(string: url)!)
		request.timeoutInterval = Double(Channel.connectTimeout)
		for (k, v) in Channel.getAuthorizationHeaders(Channel.getCookieValue(key: "SAPISID")!) {
			request.setValue(v, forHTTPHeaderField: k)
		}
		
        log.debug("request val: \(request)")
        
		self.task = self.session.dataTask(with: request)
		let p = URLSessionDataDelegateProxy()
		p.didReceiveData = { _,_,data in
			self.onPushData(data: data)
		}
		p.didComplete = { [weak self] _,t,error in
			let response = t.response
			let r = response as? HTTPURLResponse
			if r?.statusCode >= 400 {
				log.error("Request failed with: \(error)")
                self?.disconnect()
			} else if r?.statusCode == 200 {
                log.debug("200 OK: restart long-poll")
				self?.longPollRequest()
			} else {
				log.error("Received unknown response code \(r?.statusCode)")
                self?.disconnect()
			}
		}
		self.proxy[self.task!] = p
		self.task?.resume()
	}
    
    private var task: URLSessionDataTask? = nil
    
    public func disconnect() {
        self.task?.cancel()
        self.proxy[self.task!] = nil
        if self.isConnected {
            self.isConnected = false
            NotificationCenter.default().post(name: Channel.didDisconnectNotification, object: self)
        }
        self.needsSID = true
    }
	
	// Delay subscribing until first byte is received prevent "channel not
	// ready" errors that appear to be caused by a race condition on the server.
	private func onPushData(data: Data) {
		for chunk in (self.chunkParser?.getChunks(newBytes: data))! {
			
			// This method is only called when the long-polling request was
			// successful, so use it to trigger connection events if necessary.
			if !self.isConnected {
				if self.onConnectCalled {
					self.isConnected = true
					NotificationCenter.default()
						.post(name: Channel.didConnectNotification, object: self)
				} else {
					self.onConnectCalled = true
					self.isConnected = true
					NotificationCenter.default()
						.post(name: Channel.didConnectNotification, object: self)
				}
			}
			
			if let json = try? chunk.decodeJSON(), let container = json as? [AnyObject] {
				for inner in container {
					//let array_id = inner[0]
					if let array = inner[1] as? [AnyObject] {
						NotificationCenter.default()
							.post(name: Channel.didReceiveMessageNotification, object: self,
								userInfo: [Channel.didReceiveMessageKey: array])
					}
				}
			}
        }
    }
	
	// Send a Protocol Buffer or JSON formatted chat API request.
	// endpoint is the chat API endpoint to use.
	// request_pb: The request body as a Protocol Buffer message.
	// response_pb: The response body as a Protocol Buffer message.
	internal func request(
		endpoint: String,
		body: AnyObject,
		use_json: Bool = true,
		cb: (Result) -> Void
		) {
		base_request(path: "https://clients6.google.com/chat/v1/\(endpoint)",
		             content_type: "application/json+protobuf",
		             data: try! JSONSerialization.data(withJSONObject: body, options: []),
		             use_json: use_json,
		             cb: cb
		)
	}
	
	// Valid formats are: 'json' (JSON), 'protojson' (pblite), and 'proto'
	// (binary Protocol Buffer). 'proto' requires manually setting an extra
	// header 'X-Goog-Encode-Response-If-Executable: base64'.
	internal func base_request(
		path: String,
		content_type: String,
		data: Data,
		use_json: Bool = true,
		cb: (Result) -> Void
		) {
		let params = ["alt": use_json ? "json" : "protojson"]
		let url = URL(string: (path + "?" + "key=AIzaSyAfFJCeph-euFSwtmqFZi0kaKk-cZ5wufM" + "&" + params.encodeURL()))!
		let request = NSMutableURLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = data
		
		for (k, v) in Channel.getAuthorizationHeaders(Channel.getCookieValue(key: "SAPISID")!) {
			request.setValue(v, forHTTPHeaderField: k)
		}
		request.setValue(content_type, forHTTPHeaderField: "Content-Type")
		
		self.session.request(request: request as URLRequest) {
			guard let _ = $0.data else {
				log.error("Request failed with error: \($0.error!)")
				return
			}
			cb($0)
		}
	}
	
	// Get the cookie value of the key given from the NSHTTPCookieStorage.
	internal class func getCookieValue(key: String) -> String? {
		if let c = HTTPCookieStorage.shared().cookies {
			if let match = (c.filter {
				($0 as HTTPCookie).name == key &&
					($0 as HTTPCookie).domain == ".google.com"
				}).first {
					return match.value
			}
		}
		return nil
	}
	
	//  Parse response format for request for new channel SID.
	//  Example format (after parsing JS):
	//  [   [0,["c","SID_HERE","",8]],
	//      [1,[{"gsid":"GSESSIONID_HERE"}]]]
	internal class func parseSIDResponse(res: Data) -> (sid: String, gSessionID: String) {
		if let firstSubmission = Channel.ChunkParser().getChunks(newBytes: res).first {
            log.debug("chunk parsing...")
			let val = PBLiteSerialization.sanitizedDecode(JSON: firstSubmission)!
			let sid = ((val[0] as! NSArray)[1] as! NSArray)[1] as! String
			let gSessionID = (((val[1] as! NSArray)[1] as! NSArray)[0] as! NSDictionary)["gsid"]! as! String
			return (sid, gSessionID)
		}
		return ("", "")
	}
	
	// Return authorization headers for API request. It doesn't seem to matter
	// what the url and time are as long as they are consistent.
	public static func getAuthorizationHeaders(_ sapisid_cookie: String) -> Dictionary<String, String> {
		let ORIGIN_URL = "https://talkgadget.google.com"
		func sha1(_ source: String) -> String {
			let str = Array(source.utf8).map { Int8($0) }
			var store = [Int8](repeating: 0, count: 20)
			SHA1(&store, str, Int32(str.count))
			return store.map { String(format: "%02hhx", $0) }.joined(separator: "")
		}
		
		let time_msec = Int(Date().timeIntervalSince1970 * 1000)
		let auth_string = "\(time_msec) \(sapisid_cookie) \(ORIGIN_URL)"
		let auth_hash = sha1(auth_string)
		let sapisidhash = "SAPISIDHASH \(time_msec)_\(auth_hash)"
		return [
			"Authorization": sapisidhash,
			"X-Origin": ORIGIN_URL,
			"X-Goog-Authuser": "0",
		]
	}
}

