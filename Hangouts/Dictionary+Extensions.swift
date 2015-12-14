import Foundation

public extension Dictionary {
	
	public func filter(predicate: Element -> Bool) -> Dictionary {
		var filteredDictionary = Dictionary()
		for (key, value) in self {
			if predicate(key, value) {
				filteredDictionary[key] = value
			}
		}
		return filteredDictionary
	}
	
	public func queryStringWithEncoding() -> String {
		var parts = [String]()
		for (key, value) in self {
			let keyString: String = "\(key)"
			let valueString: String = "\(value)"
			let query: String = "\(keyString)=\(valueString)"
			parts.append(query)
		}
		return parts.joinWithSeparator("&")
	}
	
	private static func _urlEncodedStringWithEncoding(str: String, encoding: NSStringEncoding) -> String {
		let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFStringRef
		let charactersToLeaveUnescaped = "[]." as CFStringRef
		let str = str as NSString
		let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
			str as CFString, charactersToLeaveUnescaped, charactersToBeEscaped,
			CFStringConvertNSStringEncodingToEncoding(encoding)) as NSString
		return result as String
	}
	
	public func urlEncodedQueryStringWithEncoding(encoding: NSStringEncoding) -> String {
		var parts = [String]()
		for (key, value) in self {
			let keyString: String = Dictionary._urlEncodedStringWithEncoding("\(key)", encoding: encoding)
			let valueString: String = Dictionary._urlEncodedStringWithEncoding("\(value)", encoding: encoding)
			let query: String = "\(keyString)=\(valueString)"
			parts.append(query)
		}
		return parts.joinWithSeparator("&")
	}
}

