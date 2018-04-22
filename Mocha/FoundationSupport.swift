@_exported import Foundation

/* TODO: Switch all uses of URL temp to TemporaryFile. */

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
}

public extension String {
	public func substring(between start: String, and to: String) -> String? {
		return (range(of: start)?.upperBound).flatMap { startIdx in
			(range(of: to, range: startIdx..<endIndex)?.lowerBound).map { endIdx in
                String(self[startIdx..<endIdx])
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
                let r = $0.range(at: i)
                set.append(r.location == NSNotFound ? "" : _s.substring(with: r) as String)
            }
            return set
        }
    }
	
	public func find(matching regex: NSRegularExpression) -> [String] {
		return regex.matches(in: self, options:[], range: NSMakeRange(0, self.count)).map {
			String(self[NSRangeToRange(s: self, r: $0.range)])
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

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}

public extension URL {
    
    ///
    public init(temporaryFileWithExtension ext: String) {
        self = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(ext)
    }
}

/// Manages a `TemporaryFile` for the lifetime of this object tracked by a `URL`.
/// Note: files made in `NSTemporaryDirectory()` are already automatically cleared
/// after three days (but persist across login/reboot until then).
public final class TemporaryFile {
    
    /// The `URL` this `TemporaryFile` exists at.
    public let contentURL: URL
    
    /// Create a `TemporaryFile` with a provided extension.
    public init(extension ext: String) {
        self.contentURL = URL(temporaryFileWithExtension: ext)
    }
    
    /// Upon de-init, remove the temporary file item.
    deinit {
        DispatchQueue.global(qos: .background).async { [url = self.contentURL] in
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    /// Allows capturing the context that includes the `TemporaryFile`.
    public func mark() {
        // no-op
    }
}

