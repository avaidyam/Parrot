import Foundation

// Flatmaps an array of type A to that of type B if element exits.
internal func flatMap<A,B>(x: [A], y: A -> B?) -> [B] {
	return x.map { y($0) }.filter { $0 != nil }.map { $0! }
}

internal func findFirst<S : SequenceType> (s: S, condition: (S.Generator.Element) -> Bool) -> S.Generator.Element? {
	for value in s where condition(value) {
		return value
	}
	return nil
}

public extension Mirror {
	
	/// Labels of properties.
	public var labels: [String?] {
		return self.children.map { $0.label }
	}
	
	/// Values of properties.
	public var values: [Any] {
		return self.children.map { $0.value }
	}
	
	/// Types of properties.
	public var types: [Any.Type] {
		return self.children.map { $0.value.dynamicType }
	}
	
	/// Returns a property value for a property name.
	public subscript(key: String) -> Any? {
		let res = findFirst(self.children) { $0.label == key }
		return res.map { $0.value }
	}
	
	/// Returns a value for a property name with a generic type.
	public func getValue<U>(forKey key: String) -> U? {
		let res = findFirst(self.children) { $0.label == key }
		return res.flatMap { $0.value as? U }
	}
}

// Needs to be fixed somehow to not use NSString stuff.
internal extension String {
	internal func encodeURL() -> String {
		return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
	}
	
	// Will return any JSON object, array, number, or string.
	// If there is an error, the error will be presented instead.
	// Allows fragments, and always returns mutable object types.
	internal func decodeJSON() throws -> AnyObject {
		let _str = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding)
		guard let _ = _str else {
			throw NSError(domain: NSStringEncodingErrorKey, code: Int(NSUTF8StringEncoding), userInfo: nil)
		}
		
		let options: NSJSONReadingOptions = [.AllowFragments, .MutableContainers, .MutableLeaves]
		do {
			let obj = try NSJSONSerialization.JSONObjectWithData(_str!, options: options)
			return obj
		} catch {
			throw error
		}
	}
	
	// Will return a String from any Array, Dictionary, Number, or String.
	// If there is an error, the error will be presented instead.
	// Allows fragments and can optionally return a pretty-printed string.
	internal static func encodeJSON(object: AnyObject, pretty: Bool = false) throws -> String {
		let options: NSJSONWritingOptions = pretty ? [.PrettyPrinted] : []
		do {
			let obj = try NSJSONSerialization.dataWithJSONObject(object, options: options)
			let str = NSString(data: obj, encoding: NSUTF8StringEncoding) as? String
			
			guard let _ = str else {
				throw NSError(domain: NSStringEncodingErrorKey, code: Int(NSUTF8StringEncoding), userInfo: nil)
			}
			return str!
		} catch {
			throw error
		}
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

// Provides equality and comparison operators for NSDate
public func <=(lhs: NSDate, rhs: NSDate) -> Bool {
	let res = lhs.compare(rhs)
	return res == .OrderedAscending || res == .OrderedSame
}
public func >=(lhs: NSDate, rhs: NSDate) -> Bool {
	let res = lhs.compare(rhs)
	return res == .OrderedDescending || res == .OrderedSame
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedDescending
}
public func <(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedAscending
}
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedSame
}

// Microseconds
public let MicrosecondsPerSecond = 1000000.0
public func from_timestamp(microsecond_timestamp: NSNumber?) -> NSDate? {
	if microsecond_timestamp == nil {
		return nil
	}
	let date = from_timestamp(microsecond_timestamp!)
	return date
}

// Convert a microsecond timestamp to an NSDate instance.
public func from_timestamp(microsecond_timestamp: NSNumber) -> NSDate {
	return NSDate(timeIntervalSince1970: microsecond_timestamp.doubleValue / MicrosecondsPerSecond)
}

// Convert UTC datetime to microsecond timestamp used by Hangouts.
public func to_timestamp(date: NSDate) -> NSNumber {
	return date.timeIntervalSince1970 * MicrosecondsPerSecond
}
