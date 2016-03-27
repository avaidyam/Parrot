import Cocoa

@objc(ImageDownloaderProtocol)
protocol ImageDownloaderProtocol {
	func downloadImageAtURL(url: NSURL!, withReply: ((NSData!)->Void)!)
	func provideClient(client: (ImageDownloader -> Void))
}

@objc(ImageDownloader)
class ImageDownloader : NSObject, ImageDownloaderProtocol {
	let session: NSURLSession
	
	static let global = ImageDownloader()
	
	override init()  {
		let config = NSURLSessionConfiguration.defaultSessionConfiguration()
		session = NSURLSession(configuration: config)
	}
	
	func downloadImageAtURL(url: NSURL!, withReply: ((NSData!)->Void)!) {
		let task = session.dataTaskWithURL(url) {
			data, response, error in
			if let httpResponse = response as? NSHTTPURLResponse {
				switch (data, httpResponse) {
				case let (d, r) where (200 <= r.statusCode) && (r.statusCode <= 399):
					withReply(d)
				default:
					withReply(nil)
				}
			}
		}
		task.resume()
	}
	
	func provideClient(client: (ImageDownloader -> Void)) {
		client(ImageDownloader.global)
	}
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let connection = NSXPCConnection(serviceName: "com.avaidyam.xpctest")
		connection.remoteObjectInterface = NSXPCInterface(withProtocol: ImageDownloaderProtocol.self)
		connection.resume()
		
		connection.interruptionHandler = {
			print("interrupt")
		}
		
		connection.invalidationHandler = {
			print("invalid")
		}
		
		let downloader = connection.remoteObjectProxyWithErrorHandler {
			print("remote proxy error: \($0)")
		} as? ImageDownloaderProtocol
		
		let url = NSURL(string: "http://i.imgur.com/cVqBxEu.jpg")!
		downloader?.downloadImageAtURL(url) {
			print("Got \($0?.length) bytes.")
		}
		
		downloader?.provideClient {
			print("ImageDownloader \($0)")
			
		}
		
		
		/*
		var session: NSURLSession? = nil
		downloader?.provideClient { session = $0 }
		
		let task = session?.dataTaskWithURL(url) {
			data, response, error in
			if let httpResponse = response as? NSHTTPURLResponse {
				switch (data, httpResponse) {
				case let (d, r) where (200 <= r.statusCode) && (r.statusCode <= 399):
					print("Got \(d?.length) bytes.")
				default:
					break
				}
			}
		}
		task?.resume()*/
	}
}
