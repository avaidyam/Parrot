import Foundation
import CommonCrypto

/* TODO: Remove dependency on CommonCrypto. */

// PBLiteSerialization wrapper

public class PBLiteSerialization {
	
	/* TODO: Use Swift reflection to unwrap AnyObject?. */
	public class func _unwrapOptionalType(any: Any) -> Any.Type? {
		let dynamicTypeName = "\(Mirror(reflecting: any).subjectType)"
		if dynamicTypeName.contains("Optional<") {
			var containedTypeName = dynamicTypeName.replacingOccurrences(of: "Optional<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: ">", with: "")
			return NSClassFromString(containedTypeName)
		}
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap [AnyObject]?. */
	public class func _unwrapOptionalArrayType(any: Any) -> Any.Type? {
		let dynamicTypeName = "\(Mirror(reflecting: any).subjectType)"
		
		if dynamicTypeName.contains("Swift.Array") {
			print("Encountered Swift.Array -> \(dynamicTypeName)!")
		}
		
		if dynamicTypeName.contains("Optional<Array") {
			var containedTypeName = dynamicTypeName.replacingOccurrences(of: "Optional<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: "Swift.Array<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: "Array<", with: "")
			containedTypeName = containedTypeName.replacingOccurrences(of: ">", with: "")
			return NSClassFromString(containedTypeName)
		}
		return nil
	}
	
	/* TODO: Use Swift reflection to unwrap. */
	public class func valueWithTypeCoercion(property: Any, value: AnyObject?) -> AnyObject? {
		if property is NSDate || _unwrapOptionalType(any: property) is NSDate.Type {
			if let number = value as? NSNumber {
				let timestampAsDate = from_timestamp(microsecond_timestamp: number)
				return timestampAsDate
			}
		}
		return value
	}
	
	public class func parseProtoJSON<T: Message>(input: NSData) -> T? {
		let script = (NSString(data: input, encoding: NSUTF8StringEncoding)! as String)
		if let parsedObject = evalArray(string: script) as? NSArray {
			return parseArray(type: T.self, input: parsedObject)
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
		for i in 0..<min(arr.count, children.count) {
			let propertyName = children[i].label!
			let property = children[i].value
			
			//  Unwrapping an optional sub-struct
			if let type = _unwrapOptionalType(any: property) as? Message.Type {
				let val: (AnyObject?) = parseArray(type: type, input: arr[i] as? NSArray)
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let message = property as? Message {
				let val: (AnyObject?) = parseArray(type: message.dynamicType, input: arr[i] as? NSArray)
				instance.setValue(val, forKey: propertyName)
				
				//  Unwrapping an optional enum
			} else if let type = _unwrapOptionalType(any: property) as? Enum.Type {
				var val: AnyObject?
				/* TODO: Support NSNull literal conversion. */
				if arr[i] as? NSNumber == nil {
					val = type.init(value: 0)
				} else {
					val = type.init(value: (arr[i] as! NSNumber))
				}
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
					if let elementType = _unwrapOptionalArrayType(any: property) {
						let elementMessageType = elementType as! T.Type
						let val = (arr[i] as! NSArray).map {
							parseArray(type: elementMessageType, input: $0 as? NSArray)
						}.filter { $0 != nil }.map { $0! }
						print(val)
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayMessageType(arr: property) {
						let val = (arr[i] as! NSArray).map {
							parseArray(type: elementType, input: $0 as? NSArray)
						}.filter { $0 != nil }.map { $0! }
						print(val)
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayEnumType(arr: property) {
						let val = (arr[i] as! NSArray).map {
							elementType.init(value: ($0 as! NSNumber))
						}
						instance.setValue(val, forKey:propertyName)
					} else {
						instance.setValue(valueWithTypeCoercion(property: property, value: arr[i]), forKey:propertyName)
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
			if let type = _unwrapOptionalType(any: property) as? Message.Type {
				let val: (AnyObject?) = parseDictionary(type: type, obj: value as! NSDictionary)
				instance.setValue(val, forKey: propertyName)
				
				//  Using a non-optional sub-struct
			} else if let message = property as? Message {
				let val: (AnyObject?) = parseDictionary(type: message.dynamicType, obj: value as! NSDictionary)
				instance.setValue(val, forKey: propertyName)
				
				//  Unwrapping an optional enum
			} else if let type = _unwrapOptionalType(any: property) as? Enum.Type {
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
					if let elementType = getArrayMessageType(arr: property) {
						let val = (value as! NSArray).map {
							parseDictionary(type: elementType, obj: $0 as! NSDictionary)!
						}
						instance.setValue(val, forKey:propertyName)
					} else if let elementType = getArrayEnumType(arr: property) {
						let val = (value as! NSArray).map {
							elementType.init(value: ($0 as! NSNumber))
						}
						instance.setValue(val, forKey:propertyName)
					} else {
						instance.setValue(valueWithTypeCoercion(property: property, value: value), forKey: propertyName)
					}
				}
			}
		}
		return instance
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
