import AppKit
import Mocha
import ImageIO

/*
let url = URL(string: "...")!
self.incremental = CGIncrementalImage(url: url)
//self.incremental?.imageHeaderOnly = true
self.incremental?.handler = { img, _, _ in
    self.imageView.image = img
}
self.incremental?.start()
*/
public class CGIncrementalImage: NSObject, URLSessionDataDelegate {
    private static let queue = DispatchQueue(label: "com.apple.CGImageSource.Incremental")
    
    /// The `URL` for this image. Note that it should be a remote location.
    public let url: URL
    
    /// If `imageHeaderOnly` is true, the operation completes before it is finished;
    /// only the NSImage header-related information (such as size) are available.
    /// The image provided is either incomplete and/or garbage.
    public var imageHeaderOnly: Bool = false
    
    /// Set `thumbnailSize` to a positive nonzero value to receive thumbnail updates.
    public var thumbnailSize: CGFloat = 0.0
    
    /// The internal session - cannot be supplied externally (but configuration can).
    private var session: URLSession?
    
    /// The currently executing `URLSessionDataTask` for the object's set `URL`.
    private var task: URLSessionDataTask?
    
    /// The accumulating `CGImageSource` for the image.
    private var source: CGImageSource? = nil
    
    /// The accumulating `Data` for the image.
    private var data: Data? = nil
    
    /// The `handler` receives any and all updates about the image's loading process.
    public var handler: ((NSImage?, NSImage?, Bool) -> ())? = nil
    
    /// The queue that the `handler` is invoked on.
    public var imageQueue: DispatchQueue = .main
    
    /// Whether the image is still loading.
    public var loading: Bool {
        return self.task?.state == .running
    }
    
    /// Create a new `CGIncrementalImage` with a provided `url` and `configuration`.
    /// If a `handler` is provided, the `CGIncrementalImage` is automatically `start()`ed.
    public init(url: URL, _ configuration: URLSessionConfiguration = .default, handler: ((NSImage?, NSImage?, Bool) -> ())? = nil) {
        self.url = url
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        if let handler = handler {
            self.handler = handler
            self.start()
        }
    }
    
    deinit {
        self.session?.invalidateAndCancel()
    }
    
    /// Resume loading the image.
    public func start() {
        guard self.handler != nil else { return } // must have a handler first!
        guard self.task?.state != .running || self.task?.state != .completed else { return }
        self.task?.cancel()
        self.task = self.session?.dataTask(with: self.url)
        self.task?.resume()
    }
    
    /// Cancel loading the image.
    public func cancel() {
        guard self.task!.state != .canceling else { return }
        self.task?.cancel()
    }
    
    /// Determine the initial `ContentLength` and create the backing `Data`/`CGImageSource`.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                           didReceive response: URLResponse,
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        var contentLength = Int(response.expectedContentLength)
        if contentLength < 0 {
            contentLength = 5 * 1024 * 1024
        }
        self.data = Data(capacity: contentLength)
        self.source = CGImageSourceCreateIncremental(nil)
        completionHandler(.allow)
    }
    
    /// Append incoming data to the internal buffer and refresh the image output.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard self.data != nil, let source = self.source else { return }
        self.data!.append(data as Data)
        if self.imageHeaderOnly {
            self.task?.cancel() //suspend()
        }
        
        CGIncrementalImage.queue.async {
            let finished = CGImageSourceGetStatusAtIndex(source, 0) == .statusComplete
            CGImageSourceUpdateData(source, self.data! as CFData, finished)
            
            let d = [
                kCGImageSourceShouldCache: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                kCGImageSourceThumbnailMaxPixelSize: self.thumbnailSize
            ] as CFDictionary
            
            var image: NSImage? = nil
            if let img = CGImageSourceCreateImageAtIndex(source, 0, d) {
                image = NSImage(cgImage: img, size: NSSize(width: img.width, height: img.height))
            }
            
            var thumbnail: NSImage? = nil
            if self.thumbnailSize > 0.0, let thumb = CGImageSourceCreateThumbnailAtIndex(source, 0, d) {
                thumbnail = NSImage(cgImage: thumb, size: NSSize(width: thumb.width, height: thumb.height))
            }
            
            self.imageQueue.async {
                self.handler?(image, thumbnail, finished)
            }
        }
    }
    
    /// Convenience to just retrieve the headers synchronously (blocking) of an image URL.
    public static func retrieve(headersOf url: URL, on queue: DispatchQueue = .global(qos: .utility)) -> NSImage? {
        var header: NSImage? = nil
        let s = DispatchSemaphore(value: 0)
        let inc = CGIncrementalImage(url: url)
        inc.imageHeaderOnly = true
        inc.imageQueue = queue
        inc.handler = { image, _, _ in
            header = image; s.signal()
        }
        inc.start()
        s.wait()
        return header
    }
}
