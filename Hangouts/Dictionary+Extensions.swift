import Foundation

extension Dictionary {
	
	func filter(predicate: Element -> Bool) -> Dictionary {
		var filteredDictionary = Dictionary()
		for (key, value) in self {
			if predicate(key, value) {
				filteredDictionary[key] = value
			}
		}
		return filteredDictionary
	}
	
	func queryStringWithEncoding() -> String {
		var parts = [String]()
		for (key, value) in self {
			let keyString: String = "\(key)"
			let valueString: String = "\(value)"
			let query: String = "\(keyString)=\(valueString)"
			parts.append(query)
		}
		return parts.joinWithSeparator("&")
	}
	
	func urlEncodedQueryStringWithEncoding(encoding: NSStringEncoding) -> String {
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

infix operator +| {}
func +| <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
	var map = Dictionary<K,V>()
	for (k, v) in left {
		map[k] = v
	}
	for (k, v) in right {
		map[k] = v
	}
	return map
}