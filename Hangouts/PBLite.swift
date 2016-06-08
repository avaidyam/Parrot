import Foundation
import CommonCrypto

/* TODO: Remove dependency on CommonCrypto. */

// PBLiteSerialization wrapper
public class PBLiteSerialization {
	
	private class func _setField(message: inout ProtoMessage, field: ProtoFieldDescriptor, value: Any?, _cast: Bool = false) {
		do {
			let val = !_cast ? value : field.type._cast(value: value)
			try message.set(id: field.id, value: val)
		} catch let error {
			print("Failed to set \(field.id):\(field.name) of \(_typeName(message.dynamicType)) due to \(error)")
			message._unknownFields[field.id] = value // store it anyway
		}
	}
	
	private class func _setField(message: inout ProtoMessage, field: ProtoFieldDescriptor, value: Any?, index: Int, _cast: Bool = false) {
		do {
			let val = !_cast ? value : field.type._cast(value: value)
			try message.set(id: field.id, value: val, at: index)
		} catch let error {
			print("Failed to set \(field.id):\(field.name) of \(_typeName(message.dynamicType)) due to \(error)")
			message._unknownFields[field.id] = value // store it anyway
		}
	}
	
	//Decode optional or required field.
	private class func decodeField(message: inout ProtoMessage, field: ProtoFieldDescriptor, value: Any?) {
		guard value != nil && !(value is NSNull) else { return }
		
		switch field.type {
		case .prototype(let str):
			if let t = _protoMessages[str] {
				if let value = value as? [AnyObject] {
					var q = t.init()
					decode(message: &q, pblite: value)
					_setField(message: &message, field: field, value: q)
				} else {
					print("message \(t) expected [Any] values but got \(value.dynamicType) instead.")
				}
			} else if let e = _protoEnums[str] {
				if let value = value as? Int {
					_setField(message: &message, field: field, value: e.init(value))
				} else {
					print("enum \(e) expected Int but got \(value.dynamicType) instead.")
				}
			} else {
				// nil case
				print("non-prototype field \(field.id):\(field.name) ignored!")
			}
		default:
			_setField(message: &message, field: field, value: value, _cast: true)
		}
	}
	
	private class func decodeRepeatedField(message: inout ProtoMessage, field: ProtoFieldDescriptor, value: Any?) {
		guard field.label == .repeated else { return }
		guard value != nil && !(value is NSNull) else { return }
		
		let val = value! as! [AnyObject]
		for x in val {
			switch field.type {
			case .prototype(let str):
				if let t = _protoMessages[str] {
					if let x = x as? [AnyObject] {
						var q = t.init()
						decode(message: &q, pblite: x)
						_setField(message: &message, field: field, value: q, index: -1)
					} else {
						print("message \(t) expected [Any] values but got \(x.dynamicType) instead.")
					}
				} else if let e = _protoEnums[str] {
					if let x = x as? Int {
						_setField(message: &message, field: field, value: e.init(x), index: -1)
					} else {
						print("enum \(e) expected Int but got \(x.dynamicType) instead.")
					}
				} else {
					// nil case
					print("non-prototype field \(field.id):\(field.name) ignored!")
				}
			default:
				_setField(message: &message, field: field, value: x, index: -1, _cast: true)
			}
		}
	}
	
	public class func decode(message: inout ProtoMessage, pblite pblite2: [AnyObject], ignoreFirstItem: Bool = false) {
		guard pblite2.count > (ignoreFirstItem ? 1 : 0) else { return }
		var pblite = ignoreFirstItem ? Array(pblite2.dropFirst()) : pblite2
		
		// Extract
		var extra_fields = [(Int, Any?)]()
		if let dict = pblite.last as? NSDictionary where pblite.count > 0 {
			extra_fields = dict.map { (Int($0.key as! String)!, $0.value) }
			pblite = Array(pblite.dropLast())
		}
		
		let field_values = ((pblite.enumerated().map { ($0.0 + 1, $0.1) }) + extra_fields)
		for (tag, subdata) in field_values {
			if subdata == nil { continue }
			if let field = message._declaredFields[tag] {
				if field.label == .repeated {
					//print("repeated field \(field) being ignored with subdata.")
					decodeRepeatedField(message: &message, field: field, value: subdata)
				} else {
					decodeField(message: &message, field: field, value: subdata)
				}
			} else {
				//print("Message \(_typeName(message.dynamicType)) contains unknown field \(tag); storing...")
				message._unknownFields[tag] = subdata
			}
		}
	}
	
	public class func parseProtoJSON<T: ProtoMessage>(input: NSData) -> T? {
		let script = (NSString(data: input, encoding: NSUTF8StringEncoding)! as String)
		if let parsedObject = evalArray(string: script) as? [AnyObject] {
			var msg = T.init() as ProtoMessage
			decode(message: &msg, pblite: parsedObject, ignoreFirstItem: true)
			return msg as? T
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
public func evalArray(string: String) -> NSArray? {
	return JSContext().evaluateScript("a = " + string).toArray()
}
/*public func evalDict<T: Hashable>(string: String) -> [T: Any?] {
	return JSContext().evaluateScript("a = " + string).toDictionary()
}*/


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
