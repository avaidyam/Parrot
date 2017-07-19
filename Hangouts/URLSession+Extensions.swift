import Foundation

// Quick clone of Alamofire's Result class.
// Note: instead of isSuccess/isFailure, try: guard let _ = result.data else {}
public enum Result {
	case Success(Data, URLResponse?)
	case Failure(Error, URLResponse?)
	
	public var data: Data? {
		switch self {
		case .Success(let (data, _)):
			return data
		case .Failure:
			return nil
		}
	}
	
	public var error: Error? {
		switch self {
		case .Success:
			return nil
		case .Failure(let (error, _)):
			return error
		}
	}
	
	public var response: URLResponse? {
		switch self {
		case .Success(let (_, response)):
			return response
		case .Failure(let (_, response)):
			return response
		}
	}
}

// For creating tasks off the main thread but still one-by-one.
private var q = DispatchQueue(label: "Foundation.URLSession.Extensions", attributes: .concurrent, target: nil)

public extension URLSession {
	
	/* TODO: Many different session task types are not supported yet. */
	public enum RequestType {
		case Data, UploadData(Foundation.Data), UploadFile(URL)
		//case Stream(NSInputStream), Download, DownloadResume(Data)
	}
	
	// MUCH simpler utilities for working with data requests.
	// Essentially acts as a "one-size-fits-all" factory method.
	// By default the request type will be data, and the task is auto-started.
	@discardableResult
	public func request(request: URLRequest, type: RequestType = .Data,
						start: Bool = true, handler: @escaping (Result) -> Void) -> URLSessionTask
	{
        var task: URLSessionTask? = nil
        let cb: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            q.async {
                if let error = error {
                    handler(Result.Failure(error, response))
                } else {
                    handler(Result.Success(data!, response))
                }
            }
        }
        
        /* TODO: Transparently use a dispatch queue for each session here! */
		q.sync {
			switch type {
			case .Data:
				task = self.dataTask(with: request, completionHandler: cb)
			case .UploadData(let data):
				task = self.uploadTask(with: request, from: data, completionHandler: cb)
			case .UploadFile(let url):
				task = self.uploadTask(with: request, fromFile: url, completionHandler: cb)
			//case .UploadStream(let stream):
			//	task = self.uploadTaskWithRequest(request, withStream: stream, completionHandler: cb)
			//case .Download:
			//	task = self.downloadTaskWithRequest(request, completionHandler: cb)
			//case .DownloadResume(let data):
			//	task = self.downloadTaskWithResumeData(data, completionHandler: cb)
			}
			
			if start {
				task!.resume()
			}
		}
		return task!
	}
}

//
// For constructing URL escaped/encoded strings:
//

public func escape(string: String) -> String {
	let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
	let subDelimitersToEncode = "!$&'()*+,;="
	
	var allowedCharacterSet = NSMutableCharacterSet.urlQueryAllowed // FIXME!
	allowedCharacterSet.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
	
	return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
}

public func queryComponents(key: String, _ value: Any) -> [(String, String)] {
	var components: [(String, String)] = []
	
	if let dictionary = value as? [String: Any] {
		for (nestedKey, value) in dictionary {
			components += queryComponents(key: "\(key)[\(nestedKey)]", value)
		}
	} else if let array = value as? [Any] {
		for value in array {
			components += queryComponents(key: "\(key)[]", value)
		}
	} else {
		components.append((escape(string: key), escape(string: "\(value)")))
	}
	
	return components
}

public func query(parameters: [String: Any]) -> String {
	var components: [(String, String)] = []
	
    for key in parameters.keys.sorted(by: <) {
		let value = parameters[key]!
		components += queryComponents(key: key, value)
	}
	
	return (components.map { "\($0.0)=\($0.1)" } as [String]).joined(separator: "&")
}

// default headers straight from Alamofire
public let _defaultHTTPHeaders: [String: String] = {
	// Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
	let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
	
	// Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
    let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { (arg) in
        let (index, languageCode) = arg
        let quality = 1.0 - (Double(index) * 0.1)
		return "\(languageCode);q=\(quality)"
	}.joined(separator: ", ")
	
	// User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
	let userAgent: String = {
		if let info = Bundle.main.infoDictionary {
			let executable: Any = info[kCFBundleExecutableKey as String] ?? "Unknown"
			let bundle: Any = info[kCFBundleIdentifierKey as String] ?? "Unknown"
			let version: Any = info[kCFBundleVersionKey as String] ?? "Unknown"
			let os: Any = ProcessInfo.processInfo.operatingSystemVersionString //?? "Unknown"
			
			var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
			let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
			
         if CFStringTransform(mutableUserAgent, nil, transform, false) {
                return mutableUserAgent as String
            }
        }
        
        return "Hangouts"
    }()
    
    return [
        "Accept-Encoding": acceptEncoding,
        "Accept-Language": acceptLanguage,
        "User-Agent": userAgent
    ]
}()

extension String {
    
    // Will return any JSON object, array, number, or string.
    // If there is an error, the error will be presented instead.
    // Allows fragments, and always returns mutable object types.
    func decodeJSON() throws -> AnyObject {
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
    
}
