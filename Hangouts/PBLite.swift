import Foundation
import CommonCrypto

/* TODO: Remove dependency on CommonCrypto. */

// PBLiteSerialization wrapper

public class PBLiteSerialization {
	
	//D ecode optional or required field.
	class func decodeField<T: ProtoMessage>(message: T.Type, field: ProtoFieldDescriptor, value: AnyObject?) {
		switch field.type {
		case .prototype(let str): break;
			//decode(getattr(message, field.name), value)
			//message.get
			//decode(message: message._protoFields., pblite: [])
		case .bytes: print("Ignoring field \(field.name)")
		default: print("Ignoring field \(field.name)")
		}
		
		/*
		if field.type == .prototype {
			//decode(message: getattr(message, field.nameOfExtension), pblite: value as! [AnyObject])
		} else if field.type == .bytes {
			//setattr(message, field.name, base64.b64decode(value))
		} else {
			print("Ignoring field \(field.name)")
		}*/
	}
	
	class func decodeRepeatedField<T: ProtoMessage>(message: T.Type, field: ProtoFieldDescriptor, value: [AnyObject?]) {
		
	}
	
	public class func decode<T: ProtoMessage>(message: T.Type, pblite pblite2: [AnyObject?], ignoreFirstItem: Bool = false) -> T? {
		guard pblite2.count > (ignoreFirstItem ? 1 : 0) else { return nil }
		var pblite = ignoreFirstItem ? Array(pblite2.dropFirst()) : pblite2
		
		var extra_fields = [:]
		if pblite.count > 0 && pblite.last is NSDictionary {
			var dict = pblite.last as? [String: AnyObject?]
			// dict.map { (Int($0), $1) }
			pblite = Array(pblite.dropLast())
		}
		
		//var msg = message.init()
		let process = message._protoFields.filter { $0.value.type.prototyped }
		
		
		//let fields_values = pblite + extra_fields
		let fields_values = pblite
		for (idx, value) in fields_values.enumerated() {
			if value == nil { continue }
			
			do {
				
				//try
			} catch {
				
			}
		}
		
		
		//FieldMask
		
		//print(pblite2)
		return nil
	}
	
	public class func parseProtoJSON<T: ProtoMessage>(input: NSData) -> T? {
		let script = (NSString(data: input, encoding: NSUTF8StringEncoding)! as String)
		print(script)
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
