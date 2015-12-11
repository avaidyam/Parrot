import Foundation
import JavaScriptCore

func parse_submission(submission: String) -> (client_id: String?, updates: [CLIENT_STATE_UPDATE]) {
    // Yield ClientStateUpdate instances from a channel submission.
    // For each submission payload, yield its messages
    let result = _get_submission_payloads(submission)
    let parsed_submissions = result.updates.flatMap { _parse_payload($0) }
    return (client_id: result.client_id, updates: parsed_submissions)
}


func _get_submission_payloads(submission: String) -> (client_id: String?, updates: [[AnyObject]]) {
    // Yield a submission's payloads.
    // Most submissions only contain one payload, but if the long-polling
    // connection was closed while something happened, there can be multiple
    // payloads.
    let result = JSContext().evaluateScript("a = " + submission)
    let nullResult: (client_id: String?, updates: [[AnyObject]]) = (nil, [])
    let r: [(client_id: String?, updates: [[AnyObject]])] = result.toArray().map { sub in
        if (((sub as! NSArray)[1] as! NSArray)[0] as? String) != "noop" {
            let script = ((sub[1] as! NSArray)[0] as! NSDictionary)["p"] as! String
            let wrapper = JSContext().evaluateScript("a = " + script).toDictionary()
            if let wrapper3 = wrapper["3"] as? NSDictionary {
                if let wrapper32 = wrapper3["2"] as? String {
                    return (client_id: wrapper32, updates: [])
                }
            }
            if let wrapper2 = wrapper["2"] as? NSDictionary {
                if let wrapper22 = wrapper2["2"] as? String {
                    let updates = JSContext().evaluateScript("a = " + wrapper22).toArray()
                    return (client_id: nil, updates: [updates as [AnyObject]])
                }
            }
        }
        return (nil, [])
    }
    return r.reduce(nullResult) { (($1.client_id != nil ? $1.client_id : $0.client_id), $0.updates + $1.updates)  }
}

func flatMap<A,B>(x: [A], y: A -> B?) -> [B] {
    return x.map { y($0) }.filter { $0 != nil }.map { $0! }
}

func _parse_payload(payload: [AnyObject]) -> [CLIENT_STATE_UPDATE] {
    // Yield a list of ClientStateUpdates.
    if payload[0] as? String == "cbu" {
        // payload[1] is a list of state updates.
        return flatMap(payload[1] as! [NSArray]) {
			PBLiteSerialization.parseArray(CLIENT_STATE_UPDATE.self, input: $0)
		}
    } else {
        print("Ignoring payload with header: \(payload[0])")
        return []
    }
}

//##############################################################################
//# Message parsing utils
//##############################################################################


let MicrosecondsPerSecond = 1000000.0
func from_timestamp(microsecond_timestamp: NSNumber?) -> NSDate? {
    if microsecond_timestamp == nil {
        return nil
    }
    let date = from_timestamp(microsecond_timestamp!)
    return date
}

func from_timestamp(microsecond_timestamp: NSNumber) -> NSDate {
    // Convert a microsecond timestamp to an NSDate instance.
    return NSDate(timeIntervalSince1970: microsecond_timestamp.doubleValue / MicrosecondsPerSecond)
}

func to_timestamp(date: NSDate) -> NSNumber {
    // Convert UTC datetime to microsecond timestamp used by Hangouts.
    return date.timeIntervalSince1970 * MicrosecondsPerSecond
}
//
//
//##############################################################################
//# Message types and parsers
//##############################################################################
//
//
typealias TypingStatusMessage = (conv_id: String, user_id: UserID, timestamp: NSDate, status: TypingType)


func parse_typing_status_message(p: CLIENT_SET_TYPING_NOTIFICATION) -> TypingStatusMessage {
    //    Return TypingStatusMessage from ClientSetTypingNotification.
    //    The same status may be sent multiple times consecutively, and when a
    //    message is sent the typing status will not change to stopped.
    return TypingStatusMessage(
        conv_id: p.conversation_id.id as String,
        user_id: UserID(chat_id: p.user_id.chat_id as String, gaia_id: p.user_id.gaia_id as String),
        timestamp: from_timestamp(p.timestamp)!,
        status: p.status
    )
}


typealias WatermarkNotification = (conv_id: String, user_id: UserID, read_timestamp: NSDate)


func parse_watermark_notification(client_watermark_notification: CLIENT_WATERMARK_NOTIFICATION) -> WatermarkNotification {
    // Return WatermarkNotification from ClientWatermarkNotification.
    return WatermarkNotification(
        conv_id: client_watermark_notification.conversation_id.id as String,
        user_id: UserID(
            chat_id: client_watermark_notification.participant_id.chat_id as String,
            gaia_id: client_watermark_notification.participant_id.gaia_id as String
        ),
        read_timestamp: from_timestamp(client_watermark_notification.latest_read_timestamp)!
    )
}