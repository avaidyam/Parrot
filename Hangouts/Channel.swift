import Foundation
import Alamofire
import JavaScriptCore

public protocol ChannelDelegate {
    func channelDidConnect(channel: Channel)
    func channelDidDisconnect(channel: Channel)
    func channelDidReconnect(channel: Channel)
    func channel(channel: Channel, didReceiveMessage: NSString)
}

public class Channel : NSObject, NSURLSessionDataDelegate {
    public static let ORIGIN_URL = "https://talkgadget.google.com"
    public let CHANNEL_URL_PREFIX = "https://0.client-channel.google.com/client-channel"

    // Long-polling requests send heartbeats every 15 seconds, so if we miss two in
    // a row, consider the connection dead.
    public let PUSH_TIMEOUT = 30
    public let MAX_READ_BYTES = 1024 * 1024
    public let CONNECT_TIMEOUT = 30

    public var isConnected = false
    public var isSubscribed = false
    public var onConnectCalled = false
    public var pushParser = ChunkParser()

    public var sidParam: String? = nil
    public var gSessionIDParam: String? = nil

    public static let MAX_RETRIES = 5       // maximum number of times to retry after a failure
    public var retries = MAX_RETRIES // number of remaining retries
    public var need_new_sid = true   // whether a new SID is needed

	public let manager: Alamofire.Manager
	public let session: NSURLSession
    public var delegate: ChannelDelegate?

    public init(manager: Alamofire.Manager) {
        self.manager = manager
		self.session = manager.session
    }

    public func getCookieValue(key: String) -> String? {
        if let c = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            if let match = (c.filter {
                ($0 as NSHTTPCookie).name == key &&
                ($0 as NSHTTPCookie).domain == ".google.com"
            }).first {
                return match.value
            }
        }
        return nil
    }
	
	// Listen for messages on the channel.
    public func listen() {
        if self.retries >= 0 {
            // After the first failed retry, back off exponentially longer after
            // each attempt.
            if self.retries + 1 < Channel.MAX_RETRIES {
                let backoff_seconds = UInt64(2 << (Channel.MAX_RETRIES - self.retries))
                print("Backing off for \(backoff_seconds) seconds")
                usleep(useconds_t(backoff_seconds * USEC_PER_SEC))
            }

            // Request a new SID if we don't have one yet, or the previous one
            // became invalid.
            if self.need_new_sid {
                // TODO: error handling
                self.fetchChannelSID()
                return
            }

            // Clear any previous push data, since if there was an error it
            // could contain garbage.
            self.pushParser = ChunkParser()
            self.makeLongPollingRequest()
        } else {
            print("Listen failed due to no retries left.");
        }
    }
	
	// Open a long-polling request and receive push data.
	// This method uses keep-alive to make re-opening the request faster, but
	// the remote server will set the "Connection: close" header once an hour.
    public func makeLongPollingRequest() {
        let queryString = "VER=8&RID=rpc&t=1&CI=0&ctype=hangouts&TYPE=xmlhttp&gsessionid=\(gSessionIDParam!.encodeURL())&SID=\(sidParam!.encodeURL())"
        let url = "\(CHANNEL_URL_PREFIX)/channel/bind?\(queryString)"

        //  TODO: Include timeout
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)

        let sapisid = getCookieValue("SAPISID")!
        for (k, v) in OAuth2.getAuthorizationHeaders(sapisid) {
            request.setValue(v, forHTTPHeaderField: k)
        }

        request.timeoutInterval = 30
		
		// TODO: FIX THIS:
		//.stream { (data: NSData) in self.onPushData(data) }
		/*self.session.request(request) {
			guard let data = $0.data else {
				// Uh stuff dies here... don't use !'s.
				print("Request failed with error: \($0.error!)")
				self.need_new_sid = true
				self.listen()
				return
			}
			
			if ($0.response as? NSHTTPURLResponse)?.statusCode == 200 {
				//self.onPushData(data) // why is this commented again??
				self.makeLongPollingRequest()
			} else {
				print("Received unknown response code")
				print(NSString(data: data, encoding: 4)! as String)
			}
		}*/
		
        manager.request(request)
			.stream { (data: NSData) in self.onPushData(data) }
			.responseData { response in
			if response.result.isFailure { // response.response?.statusCode >= 400
				// Uh stuff dies here... don't use !'s.
                print("Request failed with: \(response.result.error!)")
                self.need_new_sid = true
                self.listen()
            } else if response.response?.statusCode == 200 {
                //self.onPushData(response.result.value!) // why is this commented again??
                self.makeLongPollingRequest()
            } else {
                print("Received unknown response code \(response.response?.statusCode)")
                print(NSString(data: response.result.value!, encoding: 4)! as String)
            }
        }
    }
	
	// Creates a new channel for receiving push data.
	// There's a separate API to get the gsessionid alone that Hangouts for
	// Chrome uses, but if we don't send a gsessionid with this request, it
	// will return a gsessionid as well as the SID.
    public func fetchChannelSID() {
		_ = ["VER": 8, "RID": 81187, "ctype": "hangouts"] // params
        let headers = OAuth2.getAuthorizationHeaders(getCookieValue("SAPISID")!)
        let url = "\(CHANNEL_URL_PREFIX)/channel/bind?VER=8&RID=81187&ctype=hangouts"

        let URLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        URLRequest.HTTPMethod = "POST"
        for (k, v) in headers {
            URLRequest.addValue(v, forHTTPHeaderField: k)
        }

        let data = "count=0".dataUsingEncoding(NSUTF8StringEncoding)!
        isSubscribed = false
		
		self.session.request(URLRequest, type: .UploadData(data)) {
			guard let data = $0.data else {
				print("Request failed with error: \($0.error!)")
				return
			}
			
			let responseValues = Channel.parseSIDResponse(data)
			self.sidParam = responseValues.sid
			self.gSessionIDParam = responseValues.gSessionID
			self.need_new_sid = false
			self.listen()
		}
    }
	
	// Delay subscribing until first byte is received prevent "channel not
	// ready" errors that appear to be caused by a race condition on the
	// server.
    private func onPushData(data: NSData) {
        if !isSubscribed {
            subscribe {
                self.onPushData(data)
            }
            return
        }

        // This method is only called when the long-polling request was
        // successful, so use it to trigger connection events if necessary.
        if !isConnected {
            if onConnectCalled {
                isConnected = true
                delegate?.channelDidReconnect(self)
            } else {
                onConnectCalled = true
                isConnected = true
                delegate?.channelDidConnect(self)
            }
        }

        for submission in pushParser.getSubmissions(data) {
            delegate?.channel(self, didReceiveMessage: submission)
        }
    }

    private var isSubscribing = false
	
	// Subscribes the channel to receive relevant events.
	// Only needs to be called when a new channel (SID/gsessionid) is opened.
    private func subscribe(cb: (() -> Void)?) {
        if isSubscribing { return }
        isSubscribing = true

		let dt = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
		dispatch_after(dt, dispatch_get_main_queue()) {
			let timestamp = Int(NSDate().timeIntervalSince1970 * 1000)
			
			// Hangouts for Chrome splits this over 2 requests, but it's possible to do everything in one.
			let data: Dictionary<String, AnyObject> = [
				"count": "3",
				"ofs": "0",
				"req0_p": "{\"1\":{\"1\":{\"1\":{\"1\":3,\"2\":2}},\"2\":{\"1\":{\"1\":3,\"2\":2},\"2\":\"\",\"3\":\"JS\",\"4\":\"lcsclient\"},\"3\":\(timestamp),\"4\":0,\"5\":\"c1\"},\"2\":{}}",
				"req1_p": "{\"1\":{\"1\":{\"1\":{\"1\":3,\"2\":2}},\"2\":{\"1\":{\"1\":3,\"2\":2},\"2\":\"\",\"3\":\"JS\",\"4\":\"lcsclient\"},\"3\":\(timestamp),\"4\":\(timestamp),\"5\":\"c3\"},\"3\":{\"1\":{\"1\":\"babel\"}}}",
				"req2_p": "{\"1\":{\"1\":{\"1\":{\"1\":3,\"2\":2}},\"2\":{\"1\":{\"1\":3,\"2\":2},\"2\":\"\",\"3\":\"JS\",\"4\":\"lcsclient\"},\"3\":\(timestamp),\"4\":\(timestamp),\"5\":\"c4\"},\"3\":{\"1\":{\"1\":\"hangout_invite\"}}}",
			]
			let postBody = data.encodeURL()
			let queryString = (["VER": 8, "RID": 81188, "ctype": "hangouts", "gsessionid": self.gSessionIDParam!, "SID": self.sidParam!] as Dictionary<String, AnyObject>).encodeURL()
			
			let url = "\(self.CHANNEL_URL_PREFIX)/channel/bind?\(queryString)"
			let request = NSMutableURLRequest(URL: NSURL(string: url)!)
			request.HTTPMethod = "POST"
			request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
			for (k, v) in OAuth2.getAuthorizationHeaders(self.getCookieValue("SAPISID")!) {
				request.setValue(v, forHTTPHeaderField: k)
			}
			
			self.session.request(request) {
				guard let _ = $0.data else {
					print("Request failed with error: \($0.error!)")
					return
				}
				self.isSubscribed = true
				cb?()
			}
		}
	}
	
	//  Parse response format for request for new channel SID.
	//  Example format (after parsing JS):
	//  [   [0,["c","SID_HERE","",8]],
	//      [1,[{"gsid":"GSESSIONID_HERE"}]]]
	private class func parseSIDResponse(res: NSData) -> (sid: String, gSessionID: String) {
		if let firstSubmission = ChunkParser().getSubmissions(res).first {
			let ctx = JSContext() // FIXME: Don't use this.
			let val: JSValue = ctx.evaluateScript(firstSubmission)
			let sid = ((val.toArray()[0] as! NSArray)[1] as! NSArray)[1] as! String
			let gSessionID = (((val.toArray()[1] as! NSArray)[1] as! NSArray)[0] as! NSDictionary)["gsid"]! as! String
			return (sid, gSessionID)
		}
		return ("", "")
	}
}

extension Dictionary {
	
	public func encodeURL() -> String {
		let set = NSCharacterSet(charactersInString: ":/?&=;+!@#$()',*")
		
		var parts = [String]()
		for (key, value) in self {
			let keyString: String = "\(key)".stringByAddingPercentEncodingWithAllowedCharacters(set)!
			let valueString: String = "\(value)".stringByAddingPercentEncodingWithAllowedCharacters(set)!
			let query: String = "\(keyString)=\(valueString)"
			parts.append(query)
		}
		return parts.joinWithSeparator("&")
	}
}
