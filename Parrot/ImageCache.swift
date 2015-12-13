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

    func fetchImage(forUser user: User, cb: ((NSImage?) -> Void)?) {
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
