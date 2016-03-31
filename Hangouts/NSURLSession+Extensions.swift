import Foundation

// Quick clone of Alamofire's Result class.
// Note: instead of isSuccess/isFailure, try: guard let _ = result.data else {}
public enum Result {
	case Success(NSData, NSURLResponse)
	case Failure(NSError, NSURLResponse)
	
	public var data: NSData? {
		switch self {
		case .Success(let (data, _)):
			return data
		case .Failure:
			return nil
		}
	}
	
	public var error: NSError? {
		switch self {
		case .Success:
			return nil
		case .Failure(let (error, _)):
			return error
		}
	}
	
	public var response: NSURLResponse? {
		switch self {
		case .Success(let (_, response)):
			return response
		case .Failure(let (_, response)):
			return response
		}
	}
}

// For creating tasks off the main thread but still one-by-one.
private var q = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)

public extension NSURLSession {
	
	/* TODO: Many different session task types are not supported yet. */
	public enum RequestType {
		case Data, UploadData(NSData), UploadFile(NSURL)
		//case Stream(NSInputStream), Download, DownloadResume(NSData)
	}
	
	// MUCH simpler utilities for working with data requests.
	// Essentially acts as a "one-size-fits-all" factory method.
	// By default the request type will be data, and the task is auto-started.
	public func request(request: NSURLRequest, type: RequestType = .Data,
						start: Bool = true, handler: Result -> Void) -> NSURLSessionTask
	{
		var task: NSURLSessionTask? = nil
		dispatch_sync(q) {
			let cb: (NSData?, NSURLResponse?, NSError?) -> Void = { data, response, error in
				if let error = error {
					handler(Result.Failure(error, response!))
				} else {
					handler(Result.Success(data!, response!))
				}
			}
			
			/* TODO: Transparently use a dispatch queue for each session here! */
			switch type {
			case .Data:
				task = self.dataTaskWithRequest(request, completionHandler: cb)
			case .UploadData(let data):
				task = self.uploadTaskWithRequest(request, fromData: data, completionHandler: cb)
			case .UploadFile(let url):
				task = self.uploadTaskWithRequest(request, fromFile: url, completionHandler: cb)
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
	
	let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
	allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
	
	return string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
}

public func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
	var components: [(String, String)] = []
	
	if let dictionary = value as? [String: AnyObject] {
		for (nestedKey, value) in dictionary {
			components += queryComponents("\(key)[\(nestedKey)]", value)
		}
	} else if let array = value as? [AnyObject] {
		for value in array {
			components += queryComponents("\(key)[]", value)
		}
	} else {
		components.append((escape(key), escape("\(value)")))
	}
	
	return components
}

public func query(parameters: [String: AnyObject]) -> String {
	var components: [(String, String)] = []
	
	for key in parameters.keys.sort(<) {
		let value = parameters[key]!
		components += queryComponents(key, value)
	}
	
	return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
}

// default headers straight from Alamofire
public let _defaultHTTPHeaders: [String: String] = {
	// Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
	let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
	
	// Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
	let acceptLanguage = NSLocale.preferredLanguages().prefix(6).enumerate().map { index, languageCode in
		let quality = 1.0 - (Double(index) * 0.1)
		return "\(languageCode);q=\(quality)"
	}.joinWithSeparator(", ")
	
	// User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
	let userAgent: String = {
		if let info = NSBundle.mainBundle().infoDictionary {
			let executable: AnyObject = info[kCFBundleExecutableKey as String] ?? "Unknown"
			let bundle: AnyObject = info[kCFBundleIdentifierKey as String] ?? "Unknown"
			let version: AnyObject = info[kCFBundleVersionKey as String] ?? "Unknown"
			let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
			
			var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
			let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
			
			if CFStringTransform(mutableUserAgent, UnsafeMutablePointer<CFRange>(nil), transform, false) {
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
