import Foundation 

// Flatmaps an array of type A to that of type B if element exits.
internal func flatMap<A,B>(x: [A], y: A -> B?) -> [B] {
	return x.map { y($0) }.filter { $0 != nil }.map { $0! }
}

// Needs to be fixed somehow to not use NSString stuff.
internal extension String {
	internal func encodeURL() -> String {
		return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
	}
}

internal extension Dictionary {
	
	// Returns a really weird result like below:
	// "%63%74%79%70%65=%68%61%6E%67%6F%75%74%73&%56%45%52=%38&%52%49%44=%38%31%31%38%38"
	// instead of "ctype=hangouts&VER=8&RID=81188"
	internal func encodeURL() -> String {
		let set = NSCharacterSet(charactersInString: ":/?&=;+!@#$()',*")
		
		var parts = [String]()
		for (key, value) in self {
			let keyString: String = "\(key)".stringByAddingPercentEncodingWithAllowedCharacters(set)!
			let valueString: String = "\(value)".stringByAddingPercentEncodingWithAllowedCharacters(set)!
			let query: String = "\(keyString)=\(valueString)"
			parts.append(query)
		}
		return parts.joinWithSeparator("&")
	}
}

// Since we can't use nil in JSON arrays due to the parser.
internal let None = NSNull()
