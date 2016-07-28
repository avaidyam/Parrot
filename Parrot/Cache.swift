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

private var _imgCache = [String: NSImage]()
public func fetchImage(user: Person, conversation: Conversation) -> NSImage {
	
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
public func fetchImage(user: Person) -> NSImage {
	
	let output = _imgCache[user.identifier]
	guard output == nil else { return output! }
	
	var img: NSImage! = nil
	if let d = fetchData(user.identifier, user.photoURL) {
		img = NSImage(data: d)!
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




/*

// Objects conforming to this protocol may be cached.
public protocol Cacheable {
	func encodeForCache() -> NSData
	static func decodeFromCache(_ data: NSData) -> Any?
}

// An in-memory and disk-backed cache with separate limits for both.
public class Cache {
	public typealias CostFunction = (CacheEntry) -> Float64
	
	// Options for controlling the cache.
	public struct Options {
		// The maximum in-memory size of the cache (in bytes).
		// Note that this is based on the encoded size of the objects.
		public var memoryByteLimit: Int
		
		// The maximum disk size of the cache (in bytes).
		public var diskByteLimit: Int
		
		// Used to return a cost for the entry. Lower cost objects will be evicted first.
		// Defaults to time-based cost, where older entries have a lower cost.
		public var costFunction: CostFunction
		
		public init(
			memoryByteLimit: Int = 1024 * 1024,              // 1MB
			diskByteLimit: Int = 1024 * 1024 * 10,           // 10MB
			costFunction: CostFunction = {e in e.ctime}
			) {
			self.memoryByteLimit = memoryByteLimit
			self.diskByteLimit = diskByteLimit
			self.costFunction = costFunction
		}
	}
	
	public struct CacheEntry {
		public let key: String
		public let ctime: TimeInterval
		public let size: Int
		
		public init(key: String, ctime: TimeInterval, size: Int) {
			self.key = key
			self.ctime = ctime
			self.size = size
		}
	}
	
	internal let fileManager = FileManager.default()
	internal let queue = DispatchQueue(label: "com.compass.Cache", attributes: .serial, target: nil)
	internal let root: String
	internal var metadata: [String:CacheEntry] = [:]
	internal let options: Options
	internal var cache: [String:Any] = [:]
	internal var diskSize: Int = 0
	internal var memorySize: Int = 0
	
	public init(name: String, directory: String? = nil, options: Options = Options()) {
		let root: String = directory ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
		
		self.options = options
		self.root = (root as NSString).appendingPathComponent("\(name).cache")
		
		let _ = try? fileManager.createDirectory(self.root, withIntermediateDirectories: true, attributes: nil)
		
		for file in contentsOfDirectoryAtPath(path: self.root) {
			let path = (self.root as NSString).appendingPathComponent(file)
			if let attr = try? fileManager.attributesOfItem(atPath: path) {
				let ctime = attr[NSFileCreationDate] as! NSDate
				let size = attr[NSFileSize] as! NSNumber
				
				self.diskSize += size.integerValue
				
				let key = keyForPath((file as NSString).lastPathComponent)
				metadata[key] = CacheEntry(key: key, ctime: ctime.timeIntervalSince1970, size: size.integerValue)
			}
		}
		
		self.maybePurge()
		NotificationCenter.default().addObserver(forName: Notification.Name("UIApplicationDidReceiveMemoryWarningNotification"),
		                                         object: nil,
		                                         queue: OperationQueue.main(),
		                                         using: {notification in self.onMemoryWarning() })
	}
	
	// All cached keys.
	public var keys: [String] {
		var out: [String] = []
		queue.sync { out = self.metadata.keys.sort({a, b in a < b}) }
		return out
	}
	
	// All in-memory keys.
	public var residentKeys: [String] {
		var out: [String] = []
		queue.sync { out = self.cache.keys.sort({a, b in a < b}) }
		return out
	}
	
	// Check if key is cached.
	public func exists(key: String) -> Bool {
		var ok = false
		queue.sync { ok = self.metadata[key] != nil }
		return ok
	}
	
	// Get an object from the cache.
	public func get<T: Cacheable>(key: String) -> T? {
		var value: T?
		queue.sync {
			if let v = self.cache[key] {
				value = v as? T
			} else if let entry = self.metadata[key], let data = NSData(contentsOfFile: self.pathForKey(key)) {
				value = T.decodeFromCache(data) as? T
				if value != nil {
					self.cache[key] = value!
					self.memorySize += entry.size
				}
			}
		}
		return value
	}
	
	// Set a value in the cache.
	public func set<T: Cacheable>(key: String, value: T) {
		queue.sync {
			let data = value.encodeForCache()
			let path = self.pathForKey(key)
			data.writeToFile(path, atomically: true)
			self.setValueWithPath(key, value: value, path: path, size: data.length)
		}
	}
	
	// Delete a key from the cache.
	public func delete(key: String) {
		queue.sync {
			self.purgeKey(key)
		}
	}
	
	// Delete everything from the cache.
	public func deleteAll() {
		queue.sync {
			self.purgeCache()
			let _ = try? self.fileManager.createDirectory(self.root, withIntermediateDirectories: true, attributes: nil)
		}
	}
	
	// As with deleteAll(), but also remove the cache root itself.
	// The cache is not usable after this call.
	public func invalidate() {
		queue.sync {
			self.purgeCache()
		}
	}
	
	private func setValueWithPath<T>(key: String, value: T, path: String, size: Int) {
		// Update bookkeeping.
		if let entry = self.metadata[key] {
			self.diskSize -= entry.size
			if self.cache[key] != nil {
				self.memorySize -= entry.size
			}
		}
		
		self.cache[key] = value
		let entry = CacheEntry(key: key, ctime: NSDate().timeIntervalSince1970, size: size)
		self.metadata[key] = entry
		
		self.memorySize += entry.size
		self.diskSize += entry.size
		
		self.maybePurge()
	}
	
	private func purgeKey(key: String) {
		if let entry = self.metadata[key] {
			if cache.removeValue(forKey: key) != nil {
				memorySize -= entry.size
			}
			metadata.removeValue(forKey: key)
			let path = self.pathForKey(key)
			let _ = try? fileManager.removeItemAtPath(path)
			diskSize -= entry.size
		}
	}
	
	private func purgeCache() {
		let _ = try? fileManager.removeItem(atPath: self.root)
		self.metadata = [:]
		self.cache = [:]
		self.memorySize = 0
		self.diskSize = 0
	}
	
	private func onMemoryWarning() {
		queue.sync {
			self.cache = [:]
			self.memorySize = 0
		}
	}
	
	// Must be called in the lock queue.
	private func maybePurge() {
		if memorySize <= options.memoryByteLimit && diskSize <= options.diskByteLimit {
			return
		}
		
		let entries = self.metadata.values.sorted({(a, b) in
			self.options.costFunction(a) < self.options.costFunction(b)
		})
		for entry in entries {
			if diskSize > options.diskByteLimit {
				purgeKey(entry.key)
			} else if memorySize > options.memoryByteLimit {
				cache.removeValueForKey(entry.key)
				memorySize -= entry.size
			} else {
				break
			}
		}
	}
	
	private func pathForKey(key: String) -> String {
		let last = key.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(
			NSData.Base64EncodingOptions())
		return (root as NSString).stringByAppendingPathComponent(last)
	}
	
	private func keyForPath(path: String) -> String {
		let data = NSData(base64EncodedString: (path as NSString).lastPathComponent, options: NSData.Base64DecodingOptions())!
		return NSString(data: data as Data, encoding: NSUTF8StringEncoding.rawValue)! as String
	}
	
	private func contentsOfDirectoryAtPath(path: String) -> [String] {
		do {
			return try fileManager.contentsOfDirectory(atPath: path)
		} catch {
			return []
		}
	}
	
}

// A bunch of extensions to common types to make them Cacheable.

extension String: Cacheable {
	public func encodeForCache() -> NSData {
		return self.dataUsingEncoding(NSUTF8StringEncoding)!
	}
	
	public static func decodeFromCache(data: NSData) -> Any? {
		return NSString(data: data, encoding: NSUTF8StringEncoding)
	}
}

extension Int: Cacheable {
	public func encodeForCache() -> NSData {
		var n = self
		return NSData(bytes: &n, length: sizeof(Int))
	}
	
	public static func decodeFromCache(data: NSData) -> Any? {
		return 1
	}
}

extension NSCoder: Cacheable {
	public func encodeForCache() -> NSData {
		let data = NSMutableData()
		let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
		archiver.encodeObject(self)
		archiver.finishEncoding()
		return data
	}
	
	public static func decodeFromCache(data: NSData) -> Any? {
		return NSKeyedUnarchiver(forReadingWithData: data).decodeObject()
	}
}


extension NSData: Cacheable {
	public func encodeForCache() -> NSData {
		return self
	}
	
	public static func decodeFromCache(data: NSData) -> Any? {
		return data
	}
}
*/
