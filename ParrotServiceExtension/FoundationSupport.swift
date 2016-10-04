import Foundation

// Finally, matching operations where append*() was applicable, for remove*()
public extension Array where Element : Equatable {
	public mutating func remove(_ item: Element) {
		if let index = self.index(of: item) {
			self.remove(at: index)
		}
	}
}

// Optional Setter
infix operator ??= { associativity right precedence 90 }
public func ??= <T>(lhs: inout T?,  rhs: @autoclosure () -> T) {
	lhs = lhs ?? rhs()
}

// Because warnings are bad.
public extension Optional {
	@discardableResult
	public func _flatMap<U>(_ f: @noescape (Wrapped) throws -> U?) rethrows -> U? {
		return try flatMap(f)
	}
}

public extension Collection {
    public func dictionaryMap<K, V>(transform: (element: Self.Iterator.Element) -> [K: V]) -> [K: V] {
        var dictionary = [K: V]()
        self.forEach {
            let dict = transform(element: $0)
            for (key, value) in dict {
                dictionary[key] = value
            }
        }
        return dictionary
    }
}

// Needs to be fixed somehow to not use NSString stuff.
public extension String {
	
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
	
	public func encodeURL() -> String {
		return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
	}
	
	// Will return any JSON object, array, number, or string.
	// If there is an error, the error will be presented instead.
	// Allows fragments, and always returns mutable object types.
	public func decodeJSON() throws -> AnyObject {
		let _str = (self as NSString).data(using: String.Encoding.utf8.rawValue)
		guard let _ = _str else {
			throw NSError(domain: NSStringEncodingErrorKey, code: Int(String.Encoding.utf8.rawValue), userInfo: nil)
		}
		
		let options: JSONSerialization.ReadingOptions = [.allowFragments, .mutableContainers, .mutableLeaves]
		do {
			let obj = try JSONSerialization.jsonObject(with: _str!, options: options)
			return obj
		} catch {
			throw error
		}
	}
	
	// Will return a String from any Array, Dictionary, Number, or String.
	// If there is an error, the error will be presented instead.
	// Allows fragments and can optionally return a pretty-printed string.
	public static func encodeJSON(object: AnyObject, pretty: Bool = false) throws -> String {
		let options: JSONSerialization.WritingOptions = pretty ? [.prettyPrinted] : []
		do {
			let obj = try JSONSerialization.data(withJSONObject: object, options: options)
			let str = NSString(data: obj, encoding: String.Encoding.utf8.rawValue) as? String
			
			guard let _ = str else {
				throw NSError(domain: NSStringEncodingErrorKey, code: Int(String.Encoding.utf8.rawValue), userInfo: nil)
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
		let nsregex = try! RegularExpression(pattern: regex, options: .caseInsensitive)
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
	
	public func find(matching regex: RegularExpression) -> [String] {
		return regex.matches(in: self, options:[], range:NSMakeRange(0, self.characters.count)).map {
			self.substring(with: NSRangeToRange(s: self, r: $0.range))
		}
	}
}

public extension Dictionary {
	
	// Returns a really weird result like below:
	// "%63%74%79%70%65=%68%61%6E%67%6F%75%74%73&%56%45%52=%38&%52%49%44=%38%31%31%38%38"
	// instead of "ctype=hangouts&VER=8&RID=81188"
	public func encodeURL() -> String {
		let set = CharacterSet(charactersIn: ":/?&=;+!@#$()',*")
		
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

public extension DispatchData {
	public static func from(data: Data) -> DispatchData {
		return data.withUnsafeBytes {
			DispatchData(bytesNoCopy: UnsafeBufferPointer(start: $0, count: data.count))
		}
	}
	public func toData() -> Data {
		return self.withUnsafeBytes { (a: UnsafePointer<UInt8>) in
			Data(buffer: UnsafeBufferPointer(start: a, count: self.count))
		}
	}
}


// Microseconds
// Convert a microsecond timestamp to an Date instance.
// Convert UTC datetime to microsecond timestamp used by Hangouts.
private let MicrosecondsPerSecond: Double = 1000000.0
public extension Date {
	public static func from(UTC: Double) -> Date {
		return Date(timeIntervalSince1970: (UTC / MicrosecondsPerSecond))
	}
	public func toUTC() -> Double {
		return self.timeIntervalSince1970 * MicrosecondsPerSecond
	}
}

public extension DispatchSemaphore {
	public static var mutex: DispatchSemaphore {
		return DispatchSemaphore(value: 0)
	}
}

public extension NotificationCenter {
	
	@nonobjc @discardableResult
	public func addObserver(forName name: NSNotification.Name, object obj: AnyObject? = nil, using block: (Notification) -> Swift.Void) -> NSObjectProtocol {
		return self.addObserver(forName: name, object: obj, queue: nil, using: block)
	}
	
	@nonobjc @discardableResult
	public func addObserver(forName name: String, object obj: AnyObject? = nil, using block: (Notification) -> Swift.Void) -> NSObjectProtocol {
		return self.addObserver(forName: Notification.Name(rawValue: name), object: obj, queue: nil, using: block)
	}
}

/// Can hold any (including non-object) type as an object type.
public class Wrapper<T> {
	public let element: T
	public init(_ value: T) {
		self.element = value
	}
}
