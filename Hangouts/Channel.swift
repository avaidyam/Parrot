import Foundation
import Alamofire
import JavaScriptCore

protocol ChannelDelegate {
    func channelDidConnect(channel: Channel)
    func channelDidDisconnect(channel: Channel)
    func channelDidReconnect(channel: Channel)
    func channel(channel: Channel, didReceiveMessage: NSString)
}

class Channel : NSObject {
    static let ORIGIN_URL = "https://talkgadget.google.com"
    let CHANNEL_URL_PREFIX = "https://0.client-channel.google.com/client-channel"

    // Long-polling requests send heartbeats every 15 seconds, so if we miss two in
    // a row, consider the connection dead.
    let PUSH_TIMEOUT = 30
    let MAX_READ_BYTES = 1024 * 1024

    let CONNECT_TIMEOUT = 30

    static let LEN_REGEX = "([0-9]+)\n"

    var isConnected = false
    var isSubscribed = false
    var onConnectCalled = false
    var pushParser = PushDataParser()

    var sidParam: String? = nil
    var gSessionIDParam: String? = nil

    static let MAX_RETRIES = 5       // maximum number of times to retry after a failure
    var retries = MAX_RETRIES // number of remaining retries
    var need_new_sid = true   // whether a new SID is needed

    let manager: Alamofire.Manager
    var delegate: ChannelDelegate?

    init(manager: Alamofire.Manager) {
        self.manager = manager
    }

    func getCookieValue(key: String) -> String? {
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
    func listen() {
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
            self.pushParser = PushDataParser()
            self.makeLongPollingRequest()
        } else {
            print("Listen failed due to no retries left.");
        }
    }
	
	// Open a long-polling request and receive push data.
	// This method uses keep-alive to make re-opening the request faster, but
	// the remote server will set the "Connection: close" header once an hour.
    func makeLongPollingRequest() {
        let queryString = "VER=8&RID=rpc&t=1&CI=0&ctype=hangouts&TYPE=xmlhttp&gsessionid=\(gSessionIDParam!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&SID=\(sidParam!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)"
        let url = "\(CHANNEL_URL_PREFIX)/channel/bind?\(queryString)"

        //  TODO: Include timeout
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)

        let sapisid = getCookieValue("SAPISID")!
        for (k, v) in getAuthorizationHeaders(sapisid) {
            request.setValue(v, forHTTPHeaderField: k)
        }

        request.timeoutInterval = 30
        manager.request(request).stream { (data: NSData) in self.onPushData(data) }.responseData { response in
            if response.response?.statusCode >= 400 {
                print("Request failed with: \(NSString(data: response.result.value!, encoding: 4))")
                self.need_new_sid = true
                self.listen()
            } else if response.response?.statusCode == 200 {
                //self.onPushData(response.result.value!)
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
    func fetchChannelSID() {
		_ = ["VER": 8, "RID": 81187, "ctype": "hangouts"] // params
        let headers = getAuthorizationHeaders(getCookieValue("SAPISID")!)
        let url = "\(CHANNEL_URL_PREFIX)/channel/bind?VER=8&RID=81187&ctype=hangouts"

        let URLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        URLRequest.HTTPMethod = "POST"
        for (k, v) in headers {
            URLRequest.addValue(v, forHTTPHeaderField: k)
        }

        let data = "count=0".dataUsingEncoding(NSUTF8StringEncoding)!
        isSubscribed = false
        manager.upload(URLRequest, data: data).responseData { response in
            if response.result.isFailure {
                print("Request failed: \(response.result.error!)")
            } else {
                let responseValues = parseSIDResponse(response.result.value!)
                self.sidParam = responseValues.sid
                self.gSessionIDParam = responseValues.gSessionID
                self.need_new_sid = false
                self.listen()
            }
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

        delay(1) {
            let timestamp = Int(NSDate().timeIntervalSince1970 * 1000)

            // Hangouts for Chrome splits this over 2 requests, but it's possible to do everything in one.
            let data: Dictionary<String, AnyObject> = [
                "count": "3",
                "ofs": "0",
                "req0_p": "{\"1\":{\"1\":{\"1\":{\"1\":3,\"2\":2}},\"2\":{\"1\":{\"1\":3,\"2\":2},\"2\":\"\",\"3\":\"JS\",\"4\":\"lcsclient\"},\"3\":\(timestamp),\"4\":0,\"5\":\"c1\"},\"2\":{}}",
                "req1_p": "{\"1\":{\"1\":{\"1\":{\"1\":3,\"2\":2}},\"2\":{\"1\":{\"1\":3,\"2\":2},\"2\":\"\",\"3\":\"JS\",\"4\":\"lcsclient\"},\"3\":\(timestamp),\"4\":\(timestamp),\"5\":\"c3\"},\"3\":{\"1\":{\"1\":\"babel\"}}}",
                "req2_p": "{\"1\":{\"1\":{\"1\":{\"1\":3,\"2\":2}},\"2\":{\"1\":{\"1\":3,\"2\":2},\"2\":\"\",\"3\":\"JS\",\"4\":\"lcsclient\"},\"3\":\(timestamp),\"4\":\(timestamp),\"5\":\"c4\"},\"3\":{\"1\":{\"1\":\"hangout_invite\"}}}",
            ]
            let postBody = data.urlEncodedQueryStringWithEncoding(NSUTF8StringEncoding)
            let queryString = (["VER": 8, "RID": 81188, "ctype": "hangouts", "gsessionid": self.gSessionIDParam!, "SID": self.sidParam!] as Dictionary<String, AnyObject>).urlEncodedQueryStringWithEncoding(NSUTF8StringEncoding)

            let url = "\(self.CHANNEL_URL_PREFIX)/channel/bind?\(queryString)"
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            for (k, v) in getAuthorizationHeaders(self.getCookieValue("SAPISID")!) {
                request.setValue(v, forHTTPHeaderField: k)
            }

            self.manager.request(request).responseData { response in
                self.isSubscribed = true
                cb?()
            }
        }
    }
}

//  Parse response format for request for new channel SID.
//  Example format (after parsing JS):
//  [   [0,["c","SID_HERE","",8]],
//      [1,[{"gsid":"GSESSIONID_HERE"}]]]
func parseSIDResponse(res: NSData) -> (sid: String, gSessionID: String) {
    if let firstSubmission = PushDataParser().getSubmissions(res).first {
        let ctx = JSContext()
        let val: JSValue = ctx.evaluateScript(firstSubmission)
        let sid = ((val.toArray()[0] as! NSArray)[1] as! NSArray)[1] as! String
        let gSessionID = (((val.toArray()[1] as! NSArray)[1] as! NSArray)[0] as! NSDictionary)["gsid"]! as! String
        return (sid, gSessionID)
    }
    return ("", "")
}

// Return authorization headers for API request.
// It doesn't seem to matter what the url and time are as long as they are
// consistent.
func getAuthorizationHeaders(sapisid_cookie: String) -> Dictionary<String, String> {
    let time_msec = Int(NSDate().timeIntervalSince1970 * 1000)

    let auth_string = "\(time_msec) \(sapisid_cookie) \(Channel.ORIGIN_URL)"
    let auth_hash = auth_string.SHA1()
    let sapisidhash = "SAPISIDHASH \(time_msec)_\(auth_hash)"
    return [
        "Authorization": sapisidhash,
        "X-Origin": Channel.ORIGIN_URL,
        "X-Goog-Authuser": "0",
    ]
}

// Decode data_bytes into a string using UTF-8.
// If data_bytes cannot be decoded, pop the last byte until it can be or
// return an empty string.
func bestEffortDecode(data: NSData) -> String? {
    for var i = 0; i < data.length; i++ {
        if let s = NSString(data: data.subdataWithRange(NSMakeRange(0, data.length - i)), encoding: NSUTF8StringEncoding) {
            return s as String
        }
    }
    return nil
}

// Parse data from the long-polling endpoint.
class PushDataParser {
	
    var buf = NSMutableData()
	
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
    func getSubmissions(newBytes: NSData) -> [String] {
        buf.appendData(newBytes)
        var submissions = [String]()

        while buf.length > 0 {
            if let decoded = bestEffortDecode(buf) {
                let bufUTF16 = decoded.dataUsingEncoding(NSUTF16BigEndianStringEncoding)!
                let decodedUtf16LengthInChars = bufUTF16.length / 2

                let lengths = Regex(Channel.LEN_REGEX).findall(decoded)
                if let length_str = lengths.first {
                    let length_str_without_newline = length_str.substringToIndex(length_str.endIndex.advancedBy(-1))
                    if let length = Int(length_str_without_newline) {
                        if decodedUtf16LengthInChars - length_str.characters.count < length {
                          break
                        }

                        let subData = bufUTF16.subdataWithRange(NSMakeRange(length_str.characters.count * 2, length * 2))
                        let submission = NSString(data: subData, encoding: NSUTF16BigEndianStringEncoding)! as String
                        submissions.append(submission)

                        let submissionAsUTF8 = submission.dataUsingEncoding(NSUTF8StringEncoding)!

                        let removeRange = NSMakeRange(0, length_str.characters.count + submissionAsUTF8.length)
                        buf.replaceBytesInRange(removeRange, withBytes: nil, length: 0)
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
}

