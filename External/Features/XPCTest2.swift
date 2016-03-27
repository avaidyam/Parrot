import Cocoa

// enableAutomaticTermination

@objc(ImageDownloaderProtocol)
protocol ImageDownloaderProtocol {
	func downloadImageAtURL(url: NSURL!, withReply: ((NSData!)->Void)!)
	func provideClient(client: (ImageDownloader -> Void))
}

//sudo memory_pressure -S -l warn
//sudo memory_pressure -S -l critical

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

class Provider : NSObject, NSXPCListenerDelegate {
	func listener(listener: NSXPCListener, shouldAcceptNewConnection connection: NSXPCConnection) -> Bool {
		connection.exportedInterface = NSXPCInterface(withProtocol: ImageDownloaderProtocol.self)
		let exportedObject = ImageDownloader()
		connection.exportedObject = exportedObject
		connection.resume()
		return true
	}
}

let delegate = Provider()
let listener = NSXPCListener.serviceListener()
listener.delegate = delegate
listener.resume()