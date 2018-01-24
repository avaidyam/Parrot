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
        let bg = materialColors[abs(user.fullName.hashValue) % materialColors.count]
        img = NSImage(monogramOfSize: NSSize(width: 64.0, height: 64.0),
                      string: user.fullName, backgroundColor: bg)
	} else {
        let bg = materialColors[abs(user.fullName.hashValue) % materialColors.count]
		img = NSImage(monogramOfSize: NSSize(width: 64.0, height: 64.0),
                      string: user.fullName, backgroundColor: bg, overlay: NSImage(named: .user))
	}
	
	_imgCache[user.identifier] = img
	return img
}

public extension Person {
    var image: NSImage {
        return fetchImage(user: self, monogram: true)
    }
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

fileprivate let materialIndex = [
    "Red": #colorLiteral(red: 0.9450980425, green: 0.1568627506, blue: 0.1294117719, alpha: 1), "Pink": #colorLiteral(red: 0.8941176534, green: 0, blue: 0.3098039329, alpha: 1), "Purple": #colorLiteral(red: 0.5411764979, green: 0, blue: 0.6392157078, alpha: 1), "Deep Purple": #colorLiteral(red: 0.3254902065, green: 0.1019607857, blue: 0.6705882549, alpha: 1), "Indigo": #colorLiteral(red: 0.1843137294, green: 0.2117647082, blue: 0.6627451181, alpha: 1), "Blue": #colorLiteral(red: 0.08235294372, green: 0.4941176474, blue: 0.9568627477, alpha: 1), "Light Blue": #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1), "Cyan": #colorLiteral(red: 0, green: 0.6862745285, blue: 0.8000000119, alpha: 1), "Teal": #colorLiteral(red: 0.003921568859, green: 0.5254902244, blue: 0.4588235319, alpha: 1),
    "Green": #colorLiteral(red: 0.2352941185, green: 0.6470588446, blue: 0.2274509817, alpha: 1), "Light Green": #colorLiteral(red: 0.4745098054, green: 0.7372549176, blue: 0.1960784346, alpha: 1), "Lime": #colorLiteral(red: 0.7647058964, green: 0.8549019694, blue: 0.1019607857, alpha: 1), "Yellow": #colorLiteral(red: 1, green: 0.9254902005, blue: 0.08627451211, alpha: 1), "Amber": #colorLiteral(red: 1, green: 0.7176470757, blue: 0, alpha: 1), "Orange": #colorLiteral(red: 1, green: 0.5254902244, blue: 0, alpha: 1), "Deep Orange": #colorLiteral(red: 1, green: 0.2431372553, blue: 0.04705882445, alpha: 1), "Brown": #colorLiteral(red: 0.400000006, green: 0.2627451122, blue: 0.2156862766, alpha: 1), "Blue Gray": #colorLiteral(red: 0.3019607961, green: 0.4156862795, blue: 0.4745098054, alpha: 1), "Gray": #colorLiteral(red: 0.4599502683, green: 0.4599616528, blue: 0.4599555135, alpha: 1),
]
public let materialColors = Array(materialIndex.values)

public let materialColorList: NSColorList = {
    let l = NSColorList(name: NSColorList.Name(rawValue: "Material Design"))
    for (i, e) in materialIndex.enumerated() {
        l.insertColor(e.value, key: NSColor.Name(rawValue: "Material " + e.key), at: i)
    }
    return l
}()
