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
infix operator ??= : AssignmentPrecedence
public func ??= <T>(lhs: inout T?,  rhs: @autoclosure () -> T) {
	lhs = lhs ?? rhs()
}

// Because warnings are bad.
public extension Optional {
	@discardableResult
	public func _flatMap<U>(_ f: (Wrapped) throws -> U?) rethrows -> U? {
		return try flatMap(f)
	}
}

public extension Collection {
    public func dictionaryMap<K, V>(transform: (_ element: Self.Iterator.Element) -> [K: V]) -> [K: V] {
        var dictionary = [K: V]()
        self.forEach {
            let dict = transform($0)
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
			return obj as AnyObject
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
            let str = NSString(data: obj, encoding: String.Encoding.utf8.rawValue) as String?
			
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
		while let range = self.range(of: regex, options: .regularExpression) {
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
				self.substring(with: NSRangeToRange(s: self, r: $0.rangeAt(1)))
			}
		}
	}
    
    public func captureGroups(from regex: String) -> [[String]] {
        let _s = (self as NSString)
        let nsregex = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
        let results = nsregex.matches(in: self, options:[], range:NSMakeRange(0, _s.length))
        return results.map {
            var set = [String]()
            for i in 0..<$0.numberOfRanges {
                let r = $0.rangeAt(i)
                set.append(r.location == NSNotFound ? "" : _s.substring(with: r) as String)
            }
            return set
        }
    }
	
	public func find(matching regex: NSRegularExpression) -> [String] {
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

public extension URLSession {
    public func synchronousRequest(_ url: URL, method: String = "GET") -> (Data?, URLResponse?, Error?) {
        var data: Data?, response: URLResponse?, error: Error?
        let semaphore = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        self.dataTask(with: request) {
            data = $0; response = $1; error = $2
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        return (data, response, error)
    }
}

/// from @jack205: https://gist.github.com/jacks205/4a77fb1703632eb9ae79
public extension Date {
    public func relativeString(numeric: Bool = false, seconds: Bool = false) -> String {
        
        let date = self, now = Date()
        let calendar = Calendar.current
        let earliest = (now as NSDate).earlierDate(date) as Date
        let latest = (earliest == now) ? date : now
        let units = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfYear, .month, .year])
        let components = calendar.dateComponents(units, from: earliest, to: latest)
        
        if components.year ?? -1 > 45 {
            return "a while ago"
        } else if (components.year ?? -1 >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year ?? -1 >= 1) {
            return numeric ? "1 year ago" : "last year"
        } else if (components.month ?? -1 >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month ?? -1 >= 1) {
            return numeric ? "1 month ago" : "last month"
        } else if (components.weekOfYear ?? -1 >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear ?? -1 >= 1) {
            return numeric ? "1 week ago" : "last week"
        } else if (components.day ?? -1 >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day ?? -1 >= 1) {
            return numeric ? "1 day ago" : "a day ago"
        } else if (components.hour ?? -1 >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour ?? -1 >= 1){
            return numeric ? "1 hour ago" : "an hour ago"
        } else if (components.minute ?? -1 >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute ?? -1 >= 1) {
            return numeric ? "1 minute ago" : "a minute ago"
        } else if (components.second ?? -1 >= 3 && seconds) {
            return "\(components.second!) seconds ago"
        } else {
            return "just now"
        }
    }
    
    private static var fullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .long
        return formatter
    }()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    public func fullString(_ includeTime: Bool = true) -> String {
        return (includeTime ? Date.fullFormatter : Date.dateFormatter).string(from: self)
    }
    
    public func nearestMinute() -> Date {
        let c = Calendar.current
        var next = c.dateComponents(Set<Calendar.Component>([.minute]), from: self)
        next.minute = (next.minute ?? -1) + 1
        return c.nextDate(after: self, matching: next, matchingPolicy: .strict) ?? self
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

public extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
