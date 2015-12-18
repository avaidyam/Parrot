import Cocoa
import Hangouts

class ImageCache {
    static let sharedInstance = ImageCache()

    //  TODO: This is real dumb. Make this an LRU cache, flush to disk, or something.
    private var cache = Dictionary<UserID, NSImage>()

    func putImage(image: NSImage, forUser user: User) {
        cache[user.id] = image
    }

    func getImage(forUser user: User) -> NSImage? {
        return cache[user.id]
    }

    func fetchImage(forUser user: User?, cb: ((NSImage?) -> Void)?) {
		guard let user = user else {
			cb?(nil)
			return
		}
		
        if let existingCachedImage = getImage(forUser: user) {
            cb?(existingCachedImage)
            return
        }

        if let photo_url = user.photo_url, let url = NSURL(string: photo_url) {
            let request = NSURLRequest(URL: url)
			let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
				if let data = data {
					let image = NSImage(data: data)
					self.cache[user.id] = image
					cb?(image)
				}
			}
			task.resume();
        } else {
            cb?(nil)
        }
    }
}

public extension NSView {
	
	// Snapshots the view as it exists and return an NSImage of it.
	func snapshot() -> NSImage {
		
		// First get the bitmap representation of the view.
		let rep = self.bitmapImageRepForCachingDisplayInRect(self.bounds)!
		self.cacheDisplayInRect(self.bounds, toBitmapImageRep: rep)
		
		// Stuff the representation into an NSImage.
		let snapshot = NSImage(size: rep.size)
		snapshot.addRepresentation(rep)
		return snapshot
	}
	
	// Automatically translate a view into a NSDraggingImageComponent
	func draggingComponent(key: String) -> NSDraggingImageComponent {
		let component = NSDraggingImageComponent(key: key)
		component.contents = self.snapshot()
		component.frame = self.convertRect(self.bounds, fromView: self)
		return component
	}
}
