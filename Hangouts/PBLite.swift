import Foundation
import CommonCrypto

/* TODO: Remove dependency on CommonCrypto. */

// PBLiteSerialization wrapper
public class PBLiteSerialization {
	
	private class func _setField<T: ProtoMessage>(message: inout T, field: ProtoFieldDescriptor, value: Any?) {
		do {
			try message.set(name: field.name, value: value)
		} catch {
			print("Ignoring field \(field.name)")
		}
	}
	
	//Decode optional or required field.
	private class func decodeField<T: ProtoMessage>(message: inout T, field: ProtoFieldDescriptor, value: Any?) {
		print("got \(field.camelName)")
		switch field.type {
		case .prototype(let str):
			if let t = _protoMessages[str] {
				var q = t.init()
				switch q {
				case var tt as ProtoMessage:
					print("DECODE: \(field.name) = \(t)")
					//decode(message: &tt, pblite: value as! [AnyObject])
					_setField(message: &message, field: field, value: tt)
				default: break;
				}
			} else {
				
			}
			
			/*
			switch t {
			case let tt as ProtoMessage.Type:
				print("DECODE: \(field.name) = \(tt)")
				var m = tt.init()
				print("DECODE: \(field.name) = \(m)")
				//decode(message: &m, pblite: value as! [AnyObject])
				//_setField(message: &message, field: field, value: m)
			case let tt as ProtoEnum.Type:
				// FIXME: Use rawValue init here.
				//let e = tt.init(rawValue: value)
				print("DECODE: \(field.name) = \(value)")
				//_setField(message: &message, field: field, value: e)
			default: print("FAILED \(field.name)")
				break
			}*/
			
			
			/*
			let t = _typeByName(str)! as! ProtoMessage.Type
			if var t = t as? ProtoMessage {
				let m = decode(message: t, pblite: value as! [AnyObject])
				_setField(message: &message, field: field, value: m)
			} else if t is ProtoEnum {
				// FIXME: Use rawValue init here.
				let e = ProtoEnum(rawValue: value)
				_setField(message: &message, field: field, value: e)
			}
			*/
		default: _setField(message: &message, field: field, value: value)
		}
		
		//decode(getattr(message, field.name), value)
		//message.get
		//decode(message: message._protoFields., pblite: [])
		
		/*
		if field.type == .prototype {
			//decode(message: getattr(message, field.nameOfExtension), pblite: value as! [AnyObject])
		} else if field.type == .bytes {
			//setattr(message, field.name, base64.b64decode(value))
		} else {
			print("Ignoring field \(field.name)")
		}*/
	}
	
	private class func decodeRepeatedField<T: ProtoMessage>(message: inout T, field: ProtoFieldDescriptor, value: Any?) {
		
	}
	
	public class func decode<T: ProtoMessage>(message: inout T, pblite pblite2: [AnyObject], ignoreFirstItem: Bool = false) {
		guard pblite2.count > (ignoreFirstItem ? 1 : 0) else { return }
		var pblite = ignoreFirstItem ? Array(pblite2.dropFirst()) : pblite2
		
		// Extract
		var extra_fields = [(Int, Any?)]()
		if pblite.count > 0 && pblite.last is NSDictionary {
			let dict = pblite.last as? [String: Any?]
			extra_fields = dict!.map { (Int($0)!, $1) }
			pblite = Array(pblite.dropLast())
		}
		
		let field_values = ((pblite.enumerated().map { ($0.0 + 1, $0.1) }) + extra_fields)
		for (tag, subdata) in field_values {
			if subdata == nil { continue }
			if let field = message.dynamicType._protoFields[tag] {
				if field.label == .repeated {
					print("repeated field \(field) being ignored with subdata.")
					//decodeRepeatedField(message: &message, field: field, value: subdata as! [Any?])
				} else {
					decodeField(message: &message, field: field, value: subdata)
				}
			} else {
				print("Message \(message) contains unknown field \(tag); storing...")
				message._unknownFields[tag] = subdata
			}
		}
	}
	
	public class func parseProtoJSON<T: ProtoMessage>(input: NSData) -> T? {
		let script = (NSString(data: input, encoding: NSUTF8StringEncoding)! as String)
		if let parsedObject = evalArray(string: script) as? [AnyObject] {
			var msg = T.init()
			decode(message: &msg, pblite: parsedObject, ignoreFirstItem: true)
			return msg
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
