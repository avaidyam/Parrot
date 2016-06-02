import Foundation

public class NSURLSessionTaskDelegateProxy: NSObject, NSURLSessionTaskDelegate {
	
	// Closure forms corresponding to each of the delegate methods.
	public var willPerformHTTPRedirection: ((NSURLSession, NSURLSessionTask, NSHTTPURLResponse, NSURLRequest) -> NSURLRequest?)?
	public var didReceiveChallenge: ((NSURLSession, NSURLSessionTask, NSURLAuthenticationChallenge) -> (NSURLSessionAuthChallengeDisposition, NSURLCredential?))?
	public var needNewBodyStream: ((NSURLSession, NSURLSessionTask) -> NSInputStream?)?
	public var didSendBodyData: ((NSURLSession, NSURLSessionTask, Int64, Int64, Int64) -> Void)?
	public var didComplete: ((NSURLSession, NSURLSessionTask, NSError?) -> Void)?
	
	// Proxying delegate methods follow:
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
		willPerformHTTPRedirection response: NSHTTPURLResponse,
		newRequest request: NSURLRequest,
		completionHandler: ((NSURLRequest?) -> Void))
	{
		var redirectRequest: NSURLRequest? = request
		if let willPerformHTTPRedirection = willPerformHTTPRedirection {
			redirectRequest = willPerformHTTPRedirection(session, task, response, request)
		}
		completionHandler(redirectRequest)
	}
	
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
		didReceive challenge: NSURLAuthenticationChallenge,
		completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void))
	{
		if let didReceiveChallenge = didReceiveChallenge {
			let (a, c) = didReceiveChallenge(session, task, challenge)
			completionHandler(a, c)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
		needNewBodyStream completionHandler: ((NSInputStream?) -> Void))
	{
		if let needNewBodyStream = needNewBodyStream {
			completionHandler(needNewBodyStream(session, task))
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
		didSendBodyData bytesSent: Int64,
		totalBytesSent: Int64,
		totalBytesExpectedToSend: Int64)
	{
		if let didSendBodyData = didSendBodyData {
			didSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
		didCompleteWithError error: NSError?)
	{
		if let didComplete = didComplete {
			didComplete(session, task, error)
		}
	}
}

public class NSURLSessionDataDelegateProxy: NSURLSessionTaskDelegateProxy, NSURLSessionDataDelegate {
	
	// Closure forms corresponding to each of the delegate methods.
	public var didReceiveResponse: ((NSURLSession, NSURLSessionDataTask, NSURLResponse) -> NSURLSessionResponseDisposition)?
	public var didBecomeDownloadTask: ((NSURLSession, NSURLSessionDataTask, NSURLSessionDownloadTask) -> Void)?
	public var didReceiveData: ((NSURLSession, NSURLSessionDataTask, NSData) -> Void)?
	public var willCacheResponse: ((NSURLSession, NSURLSessionDataTask, NSCachedURLResponse) -> NSCachedURLResponse?)?
	
	// Proxying delegate methods follow:
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		didReceive response: NSURLResponse,
		completionHandler: ((NSURLSessionResponseDisposition) -> Void))
	{
		var disposition: NSURLSessionResponseDisposition = .allow
		if let didReceiveResponse = didReceiveResponse {
			disposition = didReceiveResponse(session, dataTask, response)
		}
		completionHandler(disposition)
	}
	
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		didBecome downloadTask: NSURLSessionDownloadTask)
	{
		if let didBecomeDownloadTask = didBecomeDownloadTask {
			didBecomeDownloadTask(session, dataTask, downloadTask)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		didReceive data: NSData)
	{
		if let didReceiveData = didReceiveData {
			didReceiveData(session, dataTask, data)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		willCacheResponse proposedResponse: NSCachedURLResponse,
		completionHandler: ((NSCachedURLResponse?) -> Void))
	{
		if let willCacheResponse = willCacheResponse {
			completionHandler(willCacheResponse(session, dataTask, proposedResponse))
		} else {
			completionHandler(proposedResponse)
		}
	}
}

public class NSURLSessionDownloadDelegateProxy: NSURLSessionDataDelegateProxy, NSURLSessionDownloadDelegate {
	
	// Closure forms corresponding to each of the delegate methods.
	public var didFinishDownloadingToURL: ((NSURLSession, NSURLSessionDownloadTask, NSURL) -> Void)?
	public var didWriteData: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
	public var didResumeAtOffset: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64) -> Void)?
	
	// Proxying delegate methods follow:
	public func urlSession(
		_ session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didFinishDownloadingTo location: NSURL)
	{
		if let didFinishDownloadingToURL = didFinishDownloadingToURL {
			didFinishDownloadingToURL(session, downloadTask, location)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64)
	{
		if let didWriteData = didWriteData {
			didWriteData(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didResumeAtOffset fileOffset: Int64,
		expectedTotalBytes: Int64)
	{
		if let didResumeAtOffset = didResumeAtOffset {
			didResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
		}
	}
}

// Straight from Alamofire.
public final class NSURLSessionDelegateProxy: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate {
	
	// Internal management for subdelegates.
	private var subdelegates: [Int: NSURLSessionTaskDelegateProxy] = [:]
	private let subdelegateQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
	
	// Allows setting and getting subdelegates for handling a session's delegate call.
	subscript(task: NSURLSessionTask) -> NSURLSessionTaskDelegateProxy? {
		get {
			var subdelegate: NSURLSessionTaskDelegateProxy?
			dispatch_sync(subdelegateQueue!) { subdelegate = self.subdelegates[task.taskIdentifier] }
			return subdelegate
		}
		set {
			dispatch_barrier_async(subdelegateQueue!) { self.subdelegates[task.taskIdentifier] = newValue }
		}
	}
	
	// Closure forms corresponding to each of the delegate methods.
	// Note that this takes priority over a provided subdelegate.
	public var sessionDidBecomeInvalidWithError: ((NSURLSession, NSError?) -> Void)?
	public var sessionDidReceiveChallenge: ((NSURLSession, NSURLAuthenticationChallenge) -> (NSURLSessionAuthChallengeDisposition, NSURLCredential?))?
	public var sessionDidFinishEventsForBackgroundURLSession: ((NSURLSession) -> Void)?
	public var taskWillPerformHTTPRedirection: ((NSURLSession, NSURLSessionTask, NSHTTPURLResponse, NSURLRequest) -> NSURLRequest?)?
	public var taskDidReceiveChallenge: ((NSURLSession, NSURLSessionTask, NSURLAuthenticationChallenge) -> (NSURLSessionAuthChallengeDisposition, NSURLCredential?))?
	public var taskNeedNewBodyStream: ((NSURLSession, NSURLSessionTask) -> NSInputStream?)?
	public var taskDidSendBodyData: ((NSURLSession, NSURLSessionTask, Int64, Int64, Int64) -> Void)?
	public var taskDidComplete: ((NSURLSession, NSURLSessionTask, NSError?) -> Void)?
	public var dataTaskDidReceiveResponse: ((NSURLSession, NSURLSessionDataTask, NSURLResponse) -> NSURLSessionResponseDisposition)?
	public var dataTaskDidBecomeDownloadTask: ((NSURLSession, NSURLSessionDataTask, NSURLSessionDownloadTask) -> Void)?
	public var dataTaskDidReceiveData: ((NSURLSession, NSURLSessionDataTask, NSData) -> Void)?
	public var dataTaskWillCacheResponse: ((NSURLSession, NSURLSessionDataTask, NSCachedURLResponse) -> NSCachedURLResponse?)?
	public var downloadTaskDidFinishDownloadingToURL: ((NSURLSession, NSURLSessionDownloadTask, NSURL) -> Void)?
	public var downloadTaskDidWriteData: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
	public var downloadTaskDidResumeAtOffset: ((NSURLSession, NSURLSessionDownloadTask, Int64, Int64) -> Void)?
	
	//
	// Proxying delegate methods follow:
	//
	
	public func urlSession(_ session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
		sessionDidBecomeInvalidWithError?(session, error)
	}
	
	public func urlSession(
		_ session: NSURLSession,
		didReceive challenge: NSURLAuthenticationChallenge,
		completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void))
	{
		var disposition: NSURLSessionAuthChallengeDisposition = .performDefaultHandling
		var credential: NSURLCredential?
		
		if let sessionDidReceiveChallenge = sessionDidReceiveChallenge {
			(disposition, credential) = sessionDidReceiveChallenge(session, challenge)
		}
		completionHandler(disposition, credential)
	}
	
	public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
		sessionDidFinishEventsForBackgroundURLSession?(session)
	}
	
	// FIXME
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
		willPerformHTTPRedirection response: NSHTTPURLResponse,
		newRequest request: NSURLRequest,
		completionHandler: ((NSURLRequest?) -> Void))
	{
		var redirectRequest: NSURLRequest? = request
		
		if let taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection {
			redirectRequest = taskWillPerformHTTPRedirection(session, task, response, request)
		}
		
		completionHandler(redirectRequest)
	}
	
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
		didReceive challenge: NSURLAuthenticationChallenge,
		completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void))
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
		_ session: NSURLSession,
		task: NSURLSessionTask,
		needNewBodyStream completionHandler: ((NSInputStream?) -> Void))
	{
		if let taskNeedNewBodyStream = taskNeedNewBodyStream {
			completionHandler(taskNeedNewBodyStream(session, task))
		} else if let delegate = self[task] {
			delegate.urlSession(session, task: task, needNewBodyStream: completionHandler)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		task: NSURLSessionTask,
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
		_ session: NSURLSession,
		task: NSURLSessionTask,
		didCompleteWithError error: NSError?)
	{
		if let taskDidComplete = taskDidComplete {
			taskDidComplete(session, task, error)
		} else if let delegate = self[task] {
			delegate.urlSession(session, task: task, didCompleteWithError: error)
		}
		
		self[task] = nil
	}
	
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		didReceive response: NSURLResponse,
		completionHandler: ((NSURLSessionResponseDisposition) -> Void))
	{
		var disposition: NSURLSessionResponseDisposition = .allow
		
		if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
			disposition = dataTaskDidReceiveResponse(session, dataTask, response)
		}
		
		completionHandler(disposition)
	}
	
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		didBecome downloadTask: NSURLSessionDownloadTask)
	{
		if let dataTaskDidBecomeDownloadTask = dataTaskDidBecomeDownloadTask {
			dataTaskDidBecomeDownloadTask(session, dataTask, downloadTask)
		}/* else {
			self[downloadTask] = NSURLSessionDownloadDelegateProxy(task: downloadTask)
		}*/
	}
	
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		didReceive data: NSData)
	{
		if let dataTaskDidReceiveData = dataTaskDidReceiveData {
			dataTaskDidReceiveData(session, dataTask, data)
		} else if let delegate = self[dataTask] as? NSURLSessionDataDelegateProxy {
			delegate.urlSession(session, dataTask: dataTask, didReceive: data)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		dataTask: NSURLSessionDataTask,
		willCacheResponse proposedResponse: NSCachedURLResponse,
		completionHandler: ((NSCachedURLResponse?) -> Void))
	{
		if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
			completionHandler(dataTaskWillCacheResponse(session, dataTask, proposedResponse))
		} else if let delegate = self[dataTask] as? NSURLSessionDataDelegateProxy {
			delegate.urlSession(session, dataTask: dataTask,
			                    willCacheResponse: proposedResponse,
			                    completionHandler: completionHandler)
		} else {
			completionHandler(proposedResponse)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didFinishDownloadingTo location: NSURL)
	{
		if let downloadTaskDidFinishDownloadingToURL = downloadTaskDidFinishDownloadingToURL {
			downloadTaskDidFinishDownloadingToURL(session, downloadTask, location)
		} else if let delegate = self[downloadTask] as? NSURLSessionDownloadDelegateProxy {
			delegate.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didWriteData bytesWritten: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64)
	{
		if let downloadTaskDidWriteData = downloadTaskDidWriteData {
			downloadTaskDidWriteData(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
		} else if let delegate = self[downloadTask] as? NSURLSessionDownloadDelegateProxy {
			delegate.urlSession(session,
				downloadTask: downloadTask,
				didWriteData: bytesWritten,
				totalBytesWritten: totalBytesWritten,
				totalBytesExpectedToWrite: totalBytesExpectedToWrite
			)
		}
	}
	
	public func urlSession(
		_ session: NSURLSession,
		downloadTask: NSURLSessionDownloadTask,
		didResumeAtOffset fileOffset: Int64,
		expectedTotalBytes: Int64)
	{
		if let downloadTaskDidResumeAtOffset = downloadTaskDidResumeAtOffset {
			downloadTaskDidResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
		} else if let delegate = self[downloadTask] as? NSURLSessionDownloadDelegateProxy {
			delegate.urlSession(session,
				downloadTask: downloadTask,
				didResumeAtOffset: fileOffset,
				expectedTotalBytes: expectedTotalBytes
			)
		}
	}
	
	public override func responds(to selector: Selector!) -> Bool {
		switch selector {
		case #selector(NSURLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)):
			return sessionDidBecomeInvalidWithError != nil
		case #selector(NSURLSessionDelegate.urlSession(_:didReceive:completionHandler:)):
			return sessionDidReceiveChallenge != nil
		//case #selector(NSURLSessionDelegate.URLSessionDidFinishEventsForBackgroundURLSession(_:)):
		//	return sessionDidFinishEventsForBackgroundURLSession != nil
		case #selector(NSURLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)):
			return taskWillPerformHTTPRedirection != nil
		case #selector(NSURLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)):
			return dataTaskDidReceiveResponse != nil
		default:
			return self.dynamicType.instancesRespond(to: selector)
		}
	}
}