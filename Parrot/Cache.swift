import Foundation

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
	URLSession.shared().request(request: URLRequest(url: url)) {
		if let data = $0.data {
			_cache[id] = data
			handler?(data)
		}
		semaphore.signal()
	}
	
	// Onlt wait on the semaphore if we don't have a handler.
	if handler == nil {
		_ = semaphore.wait()
		return _cache[id]
	} else {
		return nil
	}
}
