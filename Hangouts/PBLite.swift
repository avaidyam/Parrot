import Foundation
import CommonCrypto

/* TODO: Remove dependency on CommonCrypto. */

// PBLiteSerialization wrapper

public class PBLiteSerialization {
	
	class func decodeField<T: AbstractMessage>(message: T.Type, field: Field, value: AnyObject) {
		
	}
	
	class func decodeRepeatedField<T: AbstractMessage>(message: T.Type, field: Field, value: [AnyObject]) {
		
	}
	
	public class func decode<T: AbstractMessage>(message: T.Type, pblite pblite2: [AnyObject], ignoreFirstItem: Bool = false) -> T? {
		guard pblite2.count > (ignoreFirstItem ? 1 : 0) else { return nil }
		_ = ignoreFirstItem ? Array(pblite2.dropFirst()) : pblite2
		
		print(pblite2)
		return nil
	}
	
	public class func parseProtoJSON<T: AbstractMessage>(input: NSData) -> T? {
		let script = (NSString(data: input, encoding: NSUTF8StringEncoding)! as String)
		if let parsedObject = evalArray(string: script) as? NSArray {
			return decode(message: T.self, pblite: parsedObject as [AnyObject], ignoreFirstItem: false)
		}
		return nil
	}
}

//
// BIG CRUTCH: Should be replaced later.
//

import JavaScriptCore
@available(iOS, deprecated: 1.0, message: "Avoid JSContext!")
@available(OSX, deprecated: 1.0, message: "Avoid JSContext!")
public func evalArray(string: String) -> AnyObject? {
	return JSContext().evaluateScript("a = " + string).toArray()
}
public func evalDict(string: String) -> AnyObject? {
	return JSContext().evaluateScript("a = " + string).toDictionary()
}


//
// SHOEHORNED HERE
//


public let ORIGIN_URL = "https://talkgadget.google.com"
// Return authorization headers for API request. It doesn't seem to matter
// what the url and time are as long as they are consistent.
public func getAuthorizationHeaders(sapisid_cookie: String) -> Dictionary<String, String> {
	let time_msec = Int(NSDate().timeIntervalSince1970 * 1000)
	let auth_string = "\(time_msec) \(sapisid_cookie) \(ORIGIN_URL)"
	let auth_hash = auth_string.SHA1()
	let sapisidhash = "SAPISIDHASH \(time_msec)_\(auth_hash)"
	return [
		"Authorization": sapisidhash,
		"X-Origin": ORIGIN_URL,
		"X-Goog-Authuser": "0",
	]
}

/* String Crypto extensions */
public extension String {
	public func SHA1() -> String {
		let data = self.data(using: NSUTF8StringEncoding)!
		var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
		CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
		let hexBytes = digest.map {
			String(format: "%02hhx", $0)
		}
		return hexBytes.joined(separator: "")
	}
}
