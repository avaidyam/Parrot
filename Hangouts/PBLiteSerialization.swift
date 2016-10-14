import Foundation
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.PBLite")

// PBLiteSerialization wrapper
public class PBLiteSerialization {
	
	private class func _setField(message: inout ProtoMessage, field: ProtoFieldDescriptor, value: Any?, _cast: Bool = false) {
		do {
			let val = !_cast ? value : field.type._cast(value: value)
			try message.set(id: field.id, value: val)
		} catch let error {
			log.error("Failed to set \(field.id):\(field.name) of \(_typeName(type(of: message))) due to \(error)")
			message._unknownFields[field.id] = value // store it anyway
		}
	}
	
	private class func _setField(message: inout ProtoMessage, field: ProtoFieldDescriptor, value: Any?, index: Int, _cast: Bool = false) {
		do {
			let val = !_cast ? value : field.type._cast(value: value)
			try message.set(id: field.id, value: val, at: index)
		} catch let error {
			log.error("Failed to set \(field.id):\(field.name) of \(_typeName(type(of: message))) due to \(error)")
			message._unknownFields[field.id] = value // store it anyway
		}
	}
	
	//Decode optional or required field.
	private class func decodeField(message: inout ProtoMessage, field: ProtoFieldDescriptor, value: Any?) {
		guard value != nil && !(value is NSNull) else { return }
		
		switch field.type {
		case .prototype(let str):
			if let t = _protoMessages[str] {
				if let value = value as? [Any] {
					var q = t.init()
					decode(message: &q, pblite: value)
					_setField(message: &message, field: field, value: q)
				} else {
					log.warning("message \(t) expected [Any] values but got \(type(of: value)) instead.")
				}
			} else if let e = _protoEnums[str] {
				if let value = value as? Int {
					_setField(message: &message, field: field, value: e.init(value))
				} else {
					log.warning("enum \(e) expected Int but got \(type(of: value)) instead.")
				}
			} else {
				// nil case
				log.warning("non-prototype field \(field.id):\(field.name) ignored!")
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
						log.warning("message \(t) expected [Any] values but got \(type(of: x)) instead.")
					}
				} else if let e = _protoEnums[str] {
					if let x = x as? Int {
						_setField(message: &message, field: field, value: e.init(x), index: -1)
					} else {
						log.warning("enum \(e) expected Int but got \(type(of: x)) instead.")
					}
				} else {
					// nil case
					log.warning("non-prototype field \(field.id):\(field.name) ignored!")
				}
			default:
				_setField(message: &message, field: field, value: x, index: -1, _cast: true)
			}
		}
	}
	
	public class func decode(message: inout ProtoMessage, pblite pblite2: [Any], ignoreFirstItem: Bool = false) {
		guard pblite2.count > (ignoreFirstItem ? 1 : 0) else { return }
		var pblite = ignoreFirstItem ? Array(pblite2.dropFirst()) : pblite2
		
		// Extract
		var extra_fields = [(Int, Any?)]()
		if let dict = pblite.last as? NSDictionary, pblite.count > 0 {
			extra_fields = dict.map { (Int($0.key as! String)!, $0.value) }
			pblite = Array(pblite.dropLast())
		}
		
		let field_values = ((pblite.enumerated().map { ($0.0 + 1, $0.1) }) + extra_fields)
		for (tag, subdata) in field_values {
			if subdata == nil || subdata is NSNull { continue }
			if let field = message._declaredFields[tag] {
				if field.label == .repeated {
					decodeRepeatedField(message: &message, field: field, value: subdata)
				} else {
					decodeField(message: &message, field: field, value: subdata)
				}
			} else {
				message._unknownFields[tag] = subdata
			}
		}
	}
	
	public class func _parse<T: ProtoMessage>(_ class: T.Type, input: [Any]) -> T? {
		var msg = T.init() as ProtoMessage
		decode(message: &msg, pblite: input, ignoreFirstItem: false)
		return msg as? T
	}
	
	public class func parseProtoJSON<T: ProtoMessage>(input: Data) -> T? {
		let script = (NSString(data: input, encoding: String.Encoding.utf8.rawValue)! as String)
		if let parsedObject = sanitizedDecode(JSON: script) as? [Any] {
			var msg = T.init() as ProtoMessage
			decode(message: &msg, pblite: parsedObject, ignoreFirstItem: true)
			return msg as? T
		}
		return nil
	}
	
	// Precompile the regex so we don't fiddle around with slow loading times.
	private static let reg = try! NSRegularExpression(pattern: "(?<=,|\\[)(\\s)*(?=,)", options: [])
	
	/// Sanitize and decode JSON from a server PBLite response.
	/// Note: This assumes the output will always be an array.
	public class func sanitizedDecode(JSON string: String) -> NSArray? {
		let st = reg.stringByReplacingMatches(in: string, options: [],
			range: NSMakeRange(0, string.utf16.count), withTemplate: "$1null")
		return try! st.decodeJSON() as? NSArray
	}
}
