import Foundation

/* TODO: Update parsers to match hangups. */
/* TODO: Include markdown and URL formatting, along with HTML. */

public typealias TypingStatusMessage = (conv_id: String, user_id: UserID, timestamp: NSDate, status: TypingType)
public typealias WatermarkNotification = (conv_id: String, user_id: UserID, read_timestamp: NSDate)

// Yield ClientStateUpdate instances from a channel submission.
// For each submission payload, yield its messages
internal func parse_submission(submission: String) -> (client_id: String?, updates: [STATE_UPDATE]) {
    let result = _get_submission_payloads(submission)
    let parsed_submissions = result.updates.flatMap {
		_parse_payload($0)
	}
    return (client_id: result.client_id, updates: parsed_submissions)
}

// Yield a submission's payloads.
// Most submissions only contain one payload, but if the long-polling
// connection was closed while something happened, there can be multiple
// payloads.
internal func _get_submission_payloads(submission: String) -> (client_id: String?, updates: [[AnyObject]]) {
    let result = evalArray(submission) as! NSArray
    let nullResult: (client_id: String?, updates: [[AnyObject]]) = (nil, [])
    let r: [(client_id: String?, updates: [[AnyObject]])] = result.map { sub in
        if (((sub as! NSArray)[1] as! NSArray)[0] as? String) != "noop" {
            let script = ((sub[1] as! NSArray)[0] as! NSDictionary)["p"] as! String
            let wrapper = evalDict(script)!
            if let wrapper3 = wrapper["3"] as? NSDictionary {
                if let wrapper32 = wrapper3["2"] as? String {
                    return (client_id: wrapper32, updates: [])
                }
            }
            if let wrapper2 = wrapper["2"] as? NSDictionary {
                if let wrapper22 = wrapper2["2"] as? String {
                    let updates = evalArray(wrapper22) as! NSArray
                    return (client_id: nil, updates: [updates as [AnyObject]])
                }
            }
        }
        return (nil, [])
    }
    return r.reduce(nullResult) {
		(($1.client_id != nil ? $1.client_id : $0.client_id), $0.updates + $1.updates)
	}
}

internal func flatMap<A,B>(x: [A], y: A -> B?) -> [B] {
    return x.map { y($0) }.filter { $0 != nil }.map { $0! }
}
// Yield a list of ClientStateUpdates.

internal func _parse_payload(payload: [AnyObject]) -> [STATE_UPDATE] {
    if payload[0] as? String == "cbu" {
		
		// payload[1] is a list of state updates.
        return flatMap(payload[1] as! [NSArray]) {
			PBLiteSerialization.parseArray(STATE_UPDATE.self, input: $0)
		}
    } else {
        print("Ignoring payload with header: \(payload[0])")
        return []
    }
}
// Return TypingStatusMessage from ClientSetTypingNotification.
// The same status may be sent multiple times consecutively, and when a
// message is sent the typing status will not change to stopped.
internal func parse_typing_status_message(p: SET_TYPING_NOTIFICATION) -> TypingStatusMessage {
    return TypingStatusMessage(
        conv_id: p.conversation_id.id as! String,
        user_id: UserID(chatID: p.user_id.chat_id as! String, gaiaID: p.user_id.gaia_id as! String),
        timestamp: from_timestamp(p.timestamp)!,
        status: p.status
    )
}

// Return WatermarkNotification from ClientWatermarkNotification.
internal func parse_watermark_notification(client_watermark_notification: WATERMARK_NOTIFICATION) -> WatermarkNotification {
    return WatermarkNotification(
        conv_id: client_watermark_notification.conversation_id.id as! String,
        user_id: UserID(
            chatID: client_watermark_notification.participant_id.chat_id as! String,
            gaiaID: client_watermark_notification.participant_id.gaia_id as! String
        ),
        read_timestamp: from_timestamp(client_watermark_notification.latest_read_timestamp)!
    )
}


internal func getCookieValue(key: String) -> String? {
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

//  Parse response format for request for new channel SID.
//  Example format (after parsing JS):
//  [   [0,["c","SID_HERE","",8]],
//      [1,[{"gsid":"GSESSIONID_HERE"}]]]
internal func parseSIDResponse(res: NSData) -> (sid: String, gSessionID: String) {
	if let firstSubmission = Channel.ChunkParser().getChunks(res).first {
		let val = evalArray(firstSubmission)!
		let sid = ((val[0] as! NSArray)[1] as! NSArray)[1] as! String
		let gSessionID = (((val[1] as! NSArray)[1] as! NSArray)[0] as! NSDictionary)["gsid"]! as! String
		return (sid, gSessionID)
	}
	return ("", "")
}

// Needs to be fixed somehow to not use NSString stuff.
internal extension String {
	internal func encodeURL() -> String {
		return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
	}
}

internal extension Dictionary {
	
	// Returns a really weird result like below:
	// "%63%74%79%70%65=%68%61%6E%67%6F%75%74%73&%56%45%52=%38&%52%49%44=%38%31%31%38%38"
	// instead of "ctype=hangouts&VER=8&RID=81188"
	internal func encodeURL() -> String {
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

internal let None = NSNull()
