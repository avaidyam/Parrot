import Foundation
import CommonCrypto

/* TODO: Remove dependency on CommonCrypto. */
/* TODO: Revamp PBLite parser with a real Protobuf class set. */

// PBLite Enum Type

public class Enum : NSObject, IntegerLiteralConvertible {
	public let representation: NSNumber
	required public init(value: NSNumber) {
		self.representation = value
	}
	
	convenience override init() {
		self.init(value: -1)
	}
	
	required public init(integerLiteral value: IntegerLiteralType) {
		self.representation = value
	}
	
	override public var description: String {
		return "enum \(self.dynamicType.description()) --> \(self.representation)"
	}
}

public func ==(lhs: Enum, rhs: Enum) -> Bool {
	return lhs.representation == rhs.representation
}

public func !=(lhs: Enum, rhs: Enum) -> Bool {
	return !(lhs == rhs)
}

public func ~=(pattern: Enum, predicate: Enum) -> Bool {
	return pattern == predicate
}

// PBLite Message Type

public class Message : NSObject {
	required override public init() { }
	public class func isOptional() -> Bool { return false }
	
	func serialize(input: AnyObject?) -> AnyObject? {
		return nil
	}
	
	override public var description: String {
		let mirror = Mirror(reflecting: self)
		var string = "message \(self.dynamicType.description()) {\n"
		for thing in mirror.children {
			string += "\t\(thing.label!) = \(thing.value);\n"
		}
		return string + "}\n"
	}
}

// PBLiteSerialization wrapper

public class PBLiteSerialization {
	
	/* TODO: Use Swift reflection to unwrap AnyObject?. */
	public class func _unwrapOptionalType(any: Any) -> Any.Type? {
		let dynamicTypeName = "\(Mirror(reflecting: any).subjectType)"
		if dynamicTypeName.containsString("Optional<") {
			var containedTypeName = dynamicTypeName.stringByReplacingOccurrencesOfString("Optional<", withString: "")
			containedTypeName = containedTypeName.stringByReplacingOccurrencesOfString(">", withString: "")
			return NSClassFromString(containedTypeName)
		}
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap [AnyObject]?. */
	public class func _unwrapOptionalArrayType(any: Any) -> Any.Type? {
		let dynamicTypeName = "\(Mirror(reflecting: any).subjectType)"
		
		if dynamicTypeName.containsString("Swift.Array") {
			print("Encountered Swift.Array -> \(dynamicTypeName)!")
		}
		
		if dynamicTypeName.containsString("Optional<Array") {
			var containedTypeName = dynamicTypeName.stringByReplacingOccurrencesOfString("Optional<", withString: "")
			containedTypeName = containedTypeName.stringByReplacingOccurrencesOfString("Swift.Array<", withString: "")
			containedTypeName = containedTypeName.stringByReplacingOccurrencesOfString("Array<", withString: "")
			containedTypeName = containedTypeName.stringByReplacingOccurrencesOfString(">", withString: "")
			return NSClassFromString(containedTypeName)
		}
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap [AnyObject]. */
	public class func getArrayMessageType(arr: Any) -> Message.Type? {
		//let mirror = Mirror(reflecting: arr)
		//return mirror.types[0] as! Message.Type
		if arr is [CONVERSATION_ID] { return CONVERSATION_ID.self }
		if arr is [CONVERSATION_STATE] { return CONVERSATION_STATE.self }
		if arr is [PARTICIPANT_ID] { return PARTICIPANT_ID.self }
		if arr is [EVENT] { return EVENT.self }
		if arr is [ENTITY] { return ENTITY.self }
		if arr is [MESSAGE_SEGMENT] { return MESSAGE_SEGMENT.self }
		if arr is [MESSAGE_ATTACHMENT] { return MESSAGE_ATTACHMENT.self }
		if arr is [CONVERSATION_PARTICIPANT_DATA] { return CONVERSATION_PARTICIPANT_DATA.self }
		if arr is [CONVERSATION_READ_STATE] { return CONVERSATION_READ_STATE.self }
		if arr is [ENTITY_GROUP_ENTITY] { return ENTITY_GROUP_ENTITY.self }
		if arr is [PARTICIPANT_ID] { return PARTICIPANT_ID.self }
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap [AnyObject]. */
	public class func getArrayEnumType(arr: Any) -> Enum.Type? {
		if arr is [ConversationView] { return ConversationView.self }
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap. */
	public class func valueWithTypeCoercion(property: Any, value: AnyObject?) -> AnyObject? {
		if property is NSDate || _unwrapOptionalType(property) is NSDate.Type {
			if let number = value as? NSNumber {
				let timestampAsDate = from_timestamp(number)
				return timestampAsDate
			}
		}
		return value
	}
	
	public class func parseProtoJSON<T: Message>(input: NSData) -> T? {
		let script = (NSString(data: input, encoding: NSUTF8StringEncoding)! as String)
		if let parsedObject = evalArray(script) as? NSArray {
			return parseArray(T.self, input: parsedObject)
		}
		return nil
	}
	
	// Parsing
	
	public class func parseArray<T: Message>(type: T.Type, input: NSArray?) -> T? {
		guard let arr = input else {
			return nil // expected array
		}
		
		let instance = type.init()
		let reflection = Mirror(reflecting: instance)
		let children = Array(reflection.children)
		for var i = 0; i < min(arr.count, children.count); i++ {
			let propertyName = children[i].label!
			let property = children[i].value
			
			//  Unwrapping an optional sub-struct
			if let type = _unwrapOptionalType(property) as? Message.Type {
				let val: (AnyObject?) = parseArray(type, input: arr[i] as? NSArray)
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let message = property as? Message {
				let val: (AnyObject?) = parseArray(message.dynamicType, input: arr[i] as? NSArray)
				instance.setValue(val, forKey: propertyName)
				
				//  Unwrapping an optional enum
			} else if let type = _unwrapOptionalType(property) as? Enum.Type {
				let val: (AnyObject?) = type.init(value: (arr[i] as! NSNumber))
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let enumv = property as? Enum {
				var val: AnyObject?
				/* TODO: Support NSNull literal conversion. */
				if arr[i] as? NSNumber == nil {
					val = enumv.dynamicType.init(value: 0)
				} else {
					val = enumv.dynamicType.init(value: (arr[i] as! NSNumber))
				}
				instance.setValue(val, forKey: propertyName)
				
				// Default
			} else {
				if arr[i] is NSNull {
					instance.setValue(nil, forKey: propertyName)
				} else {
					if let elementType = _unwrapOptionalArrayType(property) {
						let elementMessageType = elementType as! T.Type
						let val = (arr[i] as! NSArray).map {
							parseArray(elementMessageType, input: $0 as? NSArray)!
						}
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayMessageType(property) {
						let val = (arr[i] as! NSArray).map {
							parseArray(elementType, input: $0 as? NSArray)!
						}
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayEnumType(property) {
						let val = (arr[i] as! NSArray).map {
							elementType.init(value: ($0 as! NSNumber))
						}
						instance.setValue(val, forKey:propertyName)
					} else {
						instance.setValue(valueWithTypeCoercion(property, value: arr[i]), forKey:propertyName)
					}
				}
			}
		}
		return instance
	}
	
	public class func parseDictionary<T: Message>(type: T.Type, obj: NSDictionary) -> T? {
		let instance = type.init()
		let reflection = Mirror(reflecting: instance)
		for child in reflection.children {
			let propertyName = child.label!
			let property = child.value
			
			let value: AnyObject? = obj[propertyName]
			
			//  Unwrapping an optional sub-struct
			if let type = _unwrapOptionalType(property) as? Message.Type {
				let val: (AnyObject?) = parseDictionary(type, obj: value as! NSDictionary)
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let message = property as? Message {
				let val: (AnyObject?) = parseDictionary(message.dynamicType, obj: value as! NSDictionary)
				instance.setValue(val, forKey: propertyName)
				
				//  Unwrapping an optional enum
			} else if let type = _unwrapOptionalType(property) as? Enum.Type {
				let val: (AnyObject?) = type.init(value: (value as! NSNumber))
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let enumv = property as? Enum {
				let val: (AnyObject?) = enumv.dynamicType.init(value: (value as! NSNumber))
				instance.setValue(val, forKey: propertyName)
				
				// Default
			} else {
				if value is NSNull || value == nil {
					instance.setValue(nil, forKey: propertyName)
				} else {
					if let elementType = getArrayMessageType(property) {
						let val = (value as! NSArray).map {
							parseDictionary(elementType, obj: $0 as! NSDictionary)!
						}
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayEnumType(property) {
						let val = (value as! NSArray).map {
							elementType.init(value: ($0 as! NSNumber))
						}
						instance.setValue(val, forKey:propertyName)
					} else {
						instance.setValue(valueWithTypeCoercion(property, value: value), forKey: propertyName)
					}
				}
			}
		}
		return instance
	}
}

//
// TRANSLATION CODE
//

extension String {
	func substring(between start: String, and to: String) -> String? {
		return (rangeOfString(start)?.endIndex).flatMap { startIdx in
			(rangeOfString(to, range: startIdx..<endIndex)?.startIndex).map { endIdx in
				substringWithRange(startIdx..<endIdx)
			}
		}
	}
}

// @unused: Only used in compiling proto files to Swift!
func _translateProtoToSwift(str: String) -> String {
	let title = str.substring(between: "message ", and: " {")!
	var scanned = 1
	let b = str.substring(between: "{", and: "}")?
		.componentsSeparatedByString(";")
		.map {
			$0.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
		}.filter {
			!$0.isEmpty
		}.map {
			$0.componentsSeparatedByString(" ").filter { $0 != "=" }
		}.map { a -> String in
			var modifier = a[0], type = a[1], name = a[2], id = Int(a[3])!
			
			switch type {
			case "string", "bytes": type = "NSString"
			case "double", "float", "int32", "int64", "uint32",
				 "uint64", "sint32", "sint64", "fixed32", "fixed64",
				 "sfixed32", "sfixed64", "bool": type = "NSNumber"
			default: break
			}
			
			var filler = ""
			for r in (scanned..<id).dropFirst() {
				filler += "public var field\(r): AnyObject?\n\t"
			}
			scanned = Int(a[3])!
			
			switch modifier {
			case "optional":
				return filler + "public var \(name): \(type)?"
			case "required":
				return filler + "public var \(name) = \(type)()"
			case "repeated":
				return filler + "public var \(name) = [\(type)]()"
			default: return ""
			}
		}
	let body = b!.reduce("") { $0 + "\n\t" + $1 }
	
	let TEMPLATE = "@objc(%NAME%)\npublic class %NAME%: Message {%BODY%\n}"
	let tmp = TEMPLATE.stringByReplacingOccurrencesOfString("%NAME%", withString: title)
	return tmp.stringByReplacingOccurrencesOfString("%BODY%", withString: body)
}
func _translateAllProtoToSwift(str: String) -> String {
	return str.componentsSeparatedByString("}\n").map { $0 + "}\n" }
		.map(_translateProtoToSwift).reduce("") { $0 + "\n\n" + $1 }
}



//
// BIG CRUTCH: Should be replaced later.
//

import JavaScriptCore
@available(iOS, deprecated=1.0, message="Avoid JSContext!")
@available(OSX, deprecated=1.0, message="Avoid JSContext!")
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
		let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
		var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
		CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
		let hexBytes = digest.map {
			String(format: "%02hhx", $0)
		}
		return hexBytes.joinWithSeparator("")
	}
}
