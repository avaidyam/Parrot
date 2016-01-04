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

    func fetchImage(forUser user: User?, cb: ((NSImage?) -> Void)? = nil) -> NSImage? {
		guard let user = user else {
			cb?(nil)
			return nil
		}
		
        if let existingCachedImage = getImage(forUser: user) {
            cb?(existingCachedImage)
            return existingCachedImage
        }

        if let photo_url = user.photo_url, let url = NSURL(string: photo_url) {
            let request = NSURLRequest(URL: url)
			let semaphore = dispatch_semaphore_create(0)
			let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
				if let data = data {
					let image = NSImage(data: data)
					self.cache[user.id] = image
					cb?(image)
					dispatch_semaphore_signal(semaphore)
				}
			}
			task.resume()
			if cb == nil {
				dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
				return getImage(forUser: user)
			} else {
				return nil
			}
        } else {
            cb?(nil)
			return nil
        }
    }
}


