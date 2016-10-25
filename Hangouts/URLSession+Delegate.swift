import Foundation

public class URLSessionTaskDelegateProxy: NSObject, URLSessionTaskDelegate {
	
	// Closure forms corresponding to each of the delegate methods.
	public var willPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?
	public var didReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?
	public var needNewBodyStream: ((URLSession, URLSessionTask) -> InputStream?)?
	public var didSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?
	public var didComplete: ((URLSession, URLSessionTask, Error?) -> Void)?
	
	// Proxying delegate methods follow:
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		willPerformHTTPRedirection response: HTTPURLResponse,
		newRequest request: URLRequest,
		completionHandler: @escaping ((URLRequest?) -> Void))
	{
		var redirectRequest: URLRequest? = request
		if let willPerformHTTPRedirection = willPerformHTTPRedirection {
			redirectRequest = willPerformHTTPRedirection(session, task, response, request)
		}
		completionHandler(redirectRequest)
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void))
	{
		if let didReceiveChallenge = didReceiveChallenge {
			let (a, c) = didReceiveChallenge(session, task, challenge)
			completionHandler(a, c)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		needNewBodyStream completionHandler: @escaping ((InputStream?) -> Void))
	{
		if let needNewBodyStream = needNewBodyStream {
			completionHandler(needNewBodyStream(session, task))
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didSendBodyData bytesSent: Int64,
		totalBytesSent: Int64,
		totalBytesExpectedToSend: Int64)
	{
		if let didSendBodyData = didSendBodyData {
			didSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didCompleteWithError error: Error?)
	{
		if let didComplete = didComplete {
			didComplete(session, task, error)
		}
	}
}

public class URLSessionDataDelegateProxy: URLSessionTaskDelegateProxy, URLSessionDataDelegate {
	
	// Closure forms corresponding to each of the delegate methods.
	public var didReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?
	public var didBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
	public var didReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
	public var willCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?
	
	// Proxying delegate methods follow:
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		didReceive response: URLResponse,
		completionHandler: @escaping ((URLSession.ResponseDisposition) -> Void))
	{
		var disposition: URLSession.ResponseDisposition = .allow
		if let didReceiveResponse = didReceiveResponse {
			disposition = didReceiveResponse(session, dataTask, response)
		}
		completionHandler(disposition)
	}
	
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		didBecome downloadTask: URLSessionDownloadTask)
	{
		if let didBecomeDownloadTask = didBecomeDownloadTask {
			didBecomeDownloadTask(session, dataTask, downloadTask)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		didReceive data: Data)
	{
		if let didReceiveData = didReceiveData {
			didReceiveData(session, dataTask, data)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		willCacheResponse proposedResponse: CachedURLResponse,
		completionHandler: @escaping ((CachedURLResponse?) -> Void))
	{
		if let willCacheResponse = willCacheResponse {
			completionHandler(willCacheResponse(session, dataTask, proposedResponse))
		} else {
			completionHandler(proposedResponse)
		}
	}
}

public class URLSessionDownloadDelegateProxy: URLSessionDataDelegateProxy, URLSessionDownloadDelegate {
	
	// Closure forms corresponding to each of the delegate methods.
	public var didFinishDownloadingToURL: ((URLSession, URLSessionDownloadTask, URL) -> Void)?
	public var didWriteData: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
	public var didResumeAtOffset: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?
	
	// Proxying delegate methods follow:
	public func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didFinishDownloadingTo location: URL)
	{
		if let didFinishDownloadingToURL = didFinishDownloadingToURL {
			didFinishDownloadingToURL(session, downloadTask, location)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64)
	{
		if let didWriteData = didWriteData {
			didWriteData(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didResumeAtOffset fileOffset: Int64,
		expectedTotalBytes: Int64)
	{
		if let didResumeAtOffset = didResumeAtOffset {
			didResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
		}
	}
}

// Straight from Alamofire.
public final class URLSessionDelegateProxy: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
	
	// Internal management for subdelegates.
	private var subdelegates: [Int: URLSessionTaskDelegateProxy] = [:]
	private let subdelegateQueue = DispatchQueue(label: "", attributes: .concurrent, target: nil)
	
	// Allows setting and getting subdelegates for handling a session's delegate call.
	public subscript(task: URLSessionTask) -> URLSessionTaskDelegateProxy? {
		get {
			var subdelegate: URLSessionTaskDelegateProxy?
			subdelegateQueue.sync { subdelegate = self.subdelegates[task.taskIdentifier] }
			return subdelegate
		}
		set {
			subdelegateQueue.async(group: nil, qos: .default, flags: .barrier) { self.subdelegates[task.taskIdentifier] = newValue }
		}
	}
	
	// Closure forms corresponding to each of the delegate methods.
	// Note that this takes priority over a provided subdelegate.
	public var sessionDidBecomeInvalidWithError: ((URLSession, Error?) -> Void)?
	public var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?
	public var sessionDidFinishEventsForBackgroundURLSession: ((URLSession) -> Void)?
	public var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?
	public var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?
	public var taskNeedNewBodyStream: ((URLSession, URLSessionTask) -> InputStream?)?
	public var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?
	public var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?
	public var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?
	public var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
	public var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
	public var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?
	public var downloadTaskDidFinishDownloadingToURL: ((URLSession, URLSessionDownloadTask, URL) -> Void)?
	public var downloadTaskDidWriteData: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
	public var downloadTaskDidResumeAtOffset: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?
	
	//
	// Proxying delegate methods follow:
	//
	
	public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
		sessionDidBecomeInvalidWithError?(session, error)
	}
	
	public func urlSession(
		_ session: URLSession,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void))
	{
		var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
		var credential: URLCredential?
		
		if let sessionDidReceiveChallenge = sessionDidReceiveChallenge {
			(disposition, credential) = sessionDidReceiveChallenge(session, challenge)
		} else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
			_ = challenge.protectionSpace.host
			
			disposition = .useCredential // FIXME
			/*if let
				serverTrustPolicy = session.serverTrustPolicyManager?.serverTrustPolicyForHost(host),
				serverTrust = challenge.protectionSpace.serverTrust
			{
				if serverTrustPolicy.evaluateServerTrust(serverTrust, isValidForHost: host) {
					disposition = .UseCredential
					credential = NSURLCredential(forTrust: serverTrust)
				} else {
					disposition = .CancelAuthenticationChallenge
				}
			}*/
		}
		
		completionHandler(disposition, credential)
	}
	
	// FIXME
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		willPerformHTTPRedirection response: HTTPURLResponse,
		newRequest request: URLRequest,
		completionHandler: @escaping ((URLRequest?) -> Void))
	{
		var redirectRequest: URLRequest? = request
		
		if let taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection {
			redirectRequest = taskWillPerformHTTPRedirection(session, task, response, request)
		}
		
		completionHandler(redirectRequest)
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void))
	{
		if let taskDidReceiveChallenge = taskDidReceiveChallenge {
			let (a, c) = taskDidReceiveChallenge(session, task, challenge)
			completionHandler(a, c)
		} else if let delegate = self[task] {
			delegate.urlSession(
				session,
				task: task,
				didReceive: challenge,
				completionHandler: completionHandler
			)
		} else {
			urlSession(session, didReceive: challenge, completionHandler: completionHandler)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		needNewBodyStream completionHandler: @escaping ((InputStream?) -> Void))
	{
		if let taskNeedNewBodyStream = taskNeedNewBodyStream {
			completionHandler(taskNeedNewBodyStream(session, task))
		} else if let delegate = self[task] {
			delegate.urlSession(session, task: task, needNewBodyStream: completionHandler)
		}
	}
	
	// FIXME
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didSendBodyData bytesSent: Int64,
		totalBytesSent: Int64,
		totalBytesExpectedToSend: Int64)
	{
		if let taskDidSendBodyData = taskDidSendBodyData {
			taskDidSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
		} /*else if let delegate = self[task] as? Request.UploadTaskDelegate {
			delegate.URLSession(
				session,
				task: task,
				didSendBodyData: bytesSent,
				totalBytesSent: totalBytesSent,
				totalBytesExpectedToSend: totalBytesExpectedToSend
			)
		}*/
	}
	
	public func urlSession(
		_ session: URLSession,
		task: URLSessionTask,
		didCompleteWithError error: Error?)
	{
		if let taskDidComplete = taskDidComplete {
			taskDidComplete(session, task, error)
		} else if let delegate = self[task] {
			delegate.urlSession(session, task: task, didCompleteWithError: error)
		}
		
		self[task] = nil
	}
	
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		didReceive response: URLResponse,
		completionHandler: @escaping ((URLSession.ResponseDisposition) -> Void))
	{
		var disposition: URLSession.ResponseDisposition = .allow
		
		if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
			disposition = dataTaskDidReceiveResponse(session, dataTask, response)
		}
		
		completionHandler(disposition)
	}
	
	// FIXME
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		didBecome downloadTask: URLSessionDownloadTask)
	{
		if let dataTaskDidBecomeDownloadTask = dataTaskDidBecomeDownloadTask {
			dataTaskDidBecomeDownloadTask(session, dataTask, downloadTask)
		}/* else {
			self[downloadTask] = URLSessionDownloadDelegateProxy(task: downloadTask)
		}*/
	}
	
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		didReceive data: Data)
	{
		if let dataTaskDidReceiveData = dataTaskDidReceiveData {
			dataTaskDidReceiveData(session, dataTask, data)
		} else if let delegate = self[dataTask] as? URLSessionDataDelegateProxy {
			delegate.urlSession(session, dataTask: dataTask, didReceive: data)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		dataTask: URLSessionDataTask,
		willCacheResponse proposedResponse: CachedURLResponse,
		completionHandler: @escaping ((CachedURLResponse?) -> Void))
	{
		if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
			completionHandler(dataTaskWillCacheResponse(session, dataTask, proposedResponse))
		} else if let delegate = self[dataTask] as? URLSessionDataDelegateProxy {
			delegate.urlSession(session, dataTask: dataTask,
			                    willCacheResponse: proposedResponse,
			                    completionHandler: completionHandler)
		} else {
			completionHandler(proposedResponse)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didFinishDownloadingTo location: URL)
	{
		if let downloadTaskDidFinishDownloadingToURL = downloadTaskDidFinishDownloadingToURL {
			downloadTaskDidFinishDownloadingToURL(session, downloadTask, location)
		} else if let delegate = self[downloadTask] as? URLSessionDownloadDelegateProxy {
			delegate.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64)
	{
		if let downloadTaskDidWriteData = downloadTaskDidWriteData {
			downloadTaskDidWriteData(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
		} else if let delegate = self[downloadTask] as? URLSessionDownloadDelegateProxy {
			delegate.urlSession(session,
				downloadTask: downloadTask,
				didWriteData: bytesWritten,
				totalBytesWritten: totalBytesWritten,
				totalBytesExpectedToWrite: totalBytesExpectedToWrite
			)
		}
	}
	
	public func urlSession(
		_ session: URLSession,
		downloadTask: URLSessionDownloadTask,
		didResumeAtOffset fileOffset: Int64,
		expectedTotalBytes: Int64)
	{
		if let downloadTaskDidResumeAtOffset = downloadTaskDidResumeAtOffset {
			downloadTaskDidResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
		} else if let delegate = self[downloadTask] as? URLSessionDownloadDelegateProxy {
			delegate.urlSession(session,
				downloadTask: downloadTask,
				didResumeAtOffset: fileOffset,
				expectedTotalBytes: expectedTotalBytes
			)
		}
	}
	
	public override func responds(to selector: Selector!) -> Bool {
		switch selector! {
		case #selector(URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)):
			return sessionDidBecomeInvalidWithError != nil
		case #selector(URLSessionDelegate.urlSession(_:didReceive:completionHandler:)):
			return sessionDidReceiveChallenge != nil
		case #selector(URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)):
			return taskWillPerformHTTPRedirection != nil
		case #selector(URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)):
			return dataTaskDidReceiveResponse != nil
		default:
			return type(of: self).instancesRespond(to: selector)
		}
	}
}
