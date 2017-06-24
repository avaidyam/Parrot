import AppKit
import protocol ParrotServiceExtension.Person
import protocol ParrotServiceExtension.Conversation

/* TODO: Turn this into a lightweight disk+memory LRU cache. */

private var _cache = Dictionary<String, Data>()

// Note that this is general purpose! It needs a unique ID and a resource URL string.
public func fetchData(_ id: String?, _ resource: String?, handler: ((Data?) -> Void)? = nil) -> Data? {
	
	// Case 1: No unique ID -> bail.
	guard let id = id else {
		handler?(nil)
		return nil
	}
	
	// Case 2: We've already fetched it -> return image.
	if let img = _cache[id] {
		handler?(img)
		return img
	}
	
	// Case 3: No resource URL -> bail.
	guard let photo_url = resource, let url = URL(string: photo_url) else {
		handler?(nil)
		return nil
	}
	
	// Case 4: We can request the resource -> return image.
	let semaphore = DispatchSemaphore(value: 0)
	URLSession.shared.request(request: URLRequest(url: url)) {
		if let data = $0.data {
			_cache[id] = data
			handler?(data)
		}
		semaphore.signal()
	}
	
	// Onlt wait on the semaphore if we don't have a handler.
	if handler == nil {
		_ = semaphore.wait(timeout: 3.seconds.later)
		return _cache[id]
	} else {
		return nil
	}
}

private var _imgCache = [String: NSImage]()
public func fetchImage(user: Person, monogram: Bool = false) -> NSImage {
	
	let output = _imgCache[user.identifier]
	guard output == nil else { return output! }
	
	// 1. If we can find or cache the photo URL, return that.
	// 2. If no photo URL can be used, and the name exists, create a monogram image.
	// 3. If a monogram is not possible, use the default image mask.
	
	var img: NSImage! = nil
	if let d = fetchData(user.identifier, user.photoURL) {
		img = NSImage(data: d)!
	} else if let _ = user.fullName.rangeOfCharacter(from: .letters, options: []) {
		img = imageForString(forString: user.fullName)
	} else {
		img = defaultImageForString(forString: user.fullName)
	}
	
	_imgCache[user.identifier] = img
	return img
}

private var _linkCache = [String: LinkPreviewType]()
public func _getLinkCached(_ key: String) throws -> LinkPreviewType {
	if let val = _linkCache[key] {
		return val
	} else {
		do {
			let val = try LinkPreviewParser.parse(key)
			_linkCache[key] = val
			log.info("parsed link => \(val)")
			return val
		} catch { throw error }
	}
}
