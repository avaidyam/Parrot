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
	
	public func urlEncodedQueryStringWithEncoding(encoding: NSStringEncoding) -> String {
		var parts = [String]()
		for (key, value) in self {
			let keyString: String = "\(key)".urlEncodedStringWithEncoding(encoding)
			let valueString: String = "\(value)".urlEncodedStringWithEncoding(encoding)
			let query: String = "\(keyString)=\(valueString)"
			parts.append(query)
		}
		return parts.joinWithSeparator("&")
	}
}

