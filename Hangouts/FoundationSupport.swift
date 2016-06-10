import Foundation

// Needs to be fixed somehow to not use NSString stuff.
internal extension String {
	internal func encodeURL() -> String {
		return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed())!
	}
	
	// Will return any JSON object, array, number, or string.
	// If there is an error, the error will be presented instead.
	// Allows fragments, and always returns mutable object types.
	internal func decodeJSON() throws -> AnyObject {
		let _str = (self as NSString).data(using: NSUTF8StringEncoding)
		guard let _ = _str else {
			throw NSError(domain: NSStringEncodingErrorKey, code: Int(NSUTF8StringEncoding), userInfo: nil)
		}
		
		let options: NSJSONReadingOptions = [.allowFragments, .mutableContainers, .mutableLeaves]
		do {
			let obj = try NSJSONSerialization.jsonObject(with: _str!, options: options)
			return obj
		} catch {
			throw error
		}
	}
	
	// Will return a String from any Array, Dictionary, Number, or String.
	// If there is an error, the error will be presented instead.
	// Allows fragments and can optionally return a pretty-printed string.
	internal static func encodeJSON(object: AnyObject, pretty: Bool = false) throws -> String {
		let options: NSJSONWritingOptions = pretty ? [.prettyPrinted] : []
		do {
			let obj = try NSJSONSerialization.data(withJSONObject: object, options: options)
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

public extension String {
	public func substring(between start: String, and to: String) -> String? {
		return (range(of: start)?.upperBound).flatMap { startIdx in
			(range(of: to, range: startIdx..<endIndex)?.lowerBound).map { endIdx in
				substring(with: startIdx..<endIdx)
			}
		}
	}
	
	public mutating func replaceAllOccurrences(matching regex: String, with: String) {
		while let range = self.range(of: regex, options: .regularExpressionSearch) {
			self = self.replacingCharacters(in: range, with: with)
		}
	}
	
	public func findAllOccurrences(matching regex: String, all: Bool = false) -> [String] {
		let nsregex = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
		let results = nsregex.matches(in: self, options:[],
		                              range:NSMakeRange(0, self.characters.count))
		
		if all {
			return results.map {
				self.substring(with: NSRangeToRange(s: self, r: $0.range))
			}
		} else {
			return results.map {
				self.substring(with: NSRangeToRange(s: self, r: $0.range(at: 1)))
			}
		}
	}
}

internal extension Dictionary {
	
	// Returns a really weird result like below:
	// "%63%74%79%70%65=%68%61%6E%67%6F%75%74%73&%56%45%52=%38&%52%49%44=%38%31%31%38%38"
	// instead of "ctype=hangouts&VER=8&RID=81188"
	internal func encodeURL() -> String {
		let set = NSCharacterSet(charactersIn: ":/?&=;+!@#$()',*")
		
		var parts = [String]()
		for (key, value) in self {
			var keyString: String = "\(key)"
			var valueString: String = "\(value)"
			keyString = keyString.addingPercentEncoding(withAllowedCharacters: set)!
			valueString = valueString.addingPercentEncoding(withAllowedCharacters: set)!
			let query: String = "\(keyString)=\(valueString)"
			parts.append(query)
		}
		return parts.joined(separator: "&")
	}
}

// Since we can't use nil in JSON arrays due to the parser.
internal let None = NSNull()

// Provides equality and comparison operators for NSDate
public func <=(lhs: NSDate, rhs: NSDate) -> Bool {
	let res = lhs.compare(rhs)
	return res == .orderedAscending || res == .orderedSame
}
public func >=(lhs: NSDate, rhs: NSDate) -> Bool {
	let res = lhs.compare(rhs)
	return res == .orderedDescending || res == .orderedSame
}
public func >(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .orderedDescending
}
public func <(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .orderedAscending
}
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .orderedSame
}

// Microseconds
// Convert a microsecond timestamp to an NSDate instance.
// Convert UTC datetime to microsecond timestamp used by Hangouts.
private let MicrosecondsPerSecond: Double = 1000000.0
public extension NSDate {
	public static func from(UTC: Double) -> NSDate {
		return NSDate(timeIntervalSince1970: (UTC / MicrosecondsPerSecond))
	}
	public func toUTC() -> Double {
		return self.timeIntervalSince1970 * MicrosecondsPerSecond
	}
}

// Converts an NSRange to a Range for String indices.
// FIXME: Weird Range/Index mess happened here.
internal func NSRangeToRange(s: String, r: NSRange) -> Range<String.Index> {
	let a  = (s as NSString).substring(to: r.location)
	let b  = (s as NSString).substring(with: r)
	let n1 = a.distance(from: a.startIndex, to: a.endIndex)
	let n2 = b.distance(from: b.startIndex, to: b.endIndex)
	let i1 = s.index(s.startIndex, offsetBy: n1)
	let i2 = s.index(i1, offsetBy: n2)
	return Range<String.Index>(uncheckedBounds: (lower: i1, upper: i2))
}

/*public typealias Regex = NSRegularExpression
public extension NSRegularExpression {
	
	// Easier/more convenient initializer.
	public convenience init(_ pattern: String, options: NSRegularExpressionOptions = .caseInsensitive) {
		try! self.init(pattern: pattern, options: options)
	}
	
	// Match the given input string, and optionally find ALL matches.
	public func match(input: String, all: Bool = false) -> [String] {
		let results = self.matches(in: input, options:[],
		                           range:NSMakeRange(0, input.characters.count))
		
		if all {
			return results.map {
				input.substring(with: NSRangeToRange(s: input, r: $0.range))
			}
		} else {
			return results.map {
				input.substring(with: NSRangeToRange(s: input, r: $0.range(at: 1)))
			}
		}
	}
}*/

class Wrapper<T> {
	var wrapped: T
	init(_ value: T) {
		self.wrapped = value
	}
}
