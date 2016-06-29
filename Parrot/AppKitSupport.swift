import AppKit

/* TODO: Localization support. */

public extension NSView {
	
	// Snapshots the view as it exists and return an NSImage of it.
	func snapshot() -> NSImage {
		
		// First get the bitmap representation of the view.
		let rep = self.bitmapImageRepForCachingDisplay(in: self.bounds)!
		self.cacheDisplay(in: self.bounds, to: rep)
		
		// Stuff the representation into an NSImage.
		let snapshot = NSImage(size: rep.size)
		snapshot.addRepresentation(rep)
		return snapshot
	}
	
	// Automatically translate a view into a NSDraggingImageComponent
	func draggingComponent(_ key: String) -> NSDraggingImageComponent {
		let component = NSDraggingImageComponent(key: key)
		component.contents = self.snapshot()
		component.frame = self.convert(self.bounds, from: self)
		return component
	}
}

public extension NSNib {
	public func instantiate(_ owner: AnyObject?) -> [AnyObject] {
		var stuff: NSArray = []
		if self.instantiate(withOwner: nil, topLevelObjects: &stuff) {
			return stuff as [AnyObject]
		}
		return []
	}
}

public extension Timer {
	
	/// Trigger a notification every minute, starting from the next minute.
	public class func scheduledWallclock(_ target: AnyObject, selector: Selector) -> Timer {
		let units: Calendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
		var comps = Calendar.current().components(units, from: Date())
		comps.minute = (comps.minute ?? 0) + 1; comps.second = 0
		let date = Calendar.current().date(from: comps)!
		let timer = Timer(fireAt: date, interval: 60, target: target,
		                  selector: selector, userInfo: nil, repeats: true)
		timer.tolerance = 2 /* We can delay the wallclock at most 2sec. */
		RunLoop.main().add(timer, forMode: RunLoopMode.defaultRunLoopMode)
		return timer
	}
}

/// from @jack205: https://gist.github.com/jacks205/4a77fb1703632eb9ae79
public extension Date {
	public func relativeString(numeric: Bool = false, seconds: Bool = false) -> String {
		
		let date = self, now = Date()
		let calendar = Calendar.current()
		let earliest = (now as NSDate).earlierDate(date) as Date
		let latest = (earliest == now) ? date : now
		let units: Calendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
		let components = calendar.components(units, from: earliest, to: latest, options: Calendar.Options())
		
		if (components.year >= 2) {
			return "\(components.year!) years ago"
		} else if (components.year >= 1) {
			return numeric ? "1 year ago" : "last year"
		} else if (components.month >= 2) {
			return "\(components.month!) months ago"
		} else if (components.month >= 1) {
			return numeric ? "1 month ago" : "last month"
		} else if (components.weekOfYear >= 2) {
			return "\(components.weekOfYear!) weeks ago"
		} else if (components.weekOfYear >= 1) {
			return numeric ? "1 week ago" : "last week"
		} else if (components.day >= 2) {
			return "\(components.day!) days ago"
		} else if (components.day >= 1) {
			return numeric ? "1 day ago" : "a day ago"
		} else if (components.hour >= 2) {
			return "\(components.hour!) hours ago"
		} else if (components.hour >= 1){
			return numeric ? "1 hour ago" : "an hour ago"
		} else if (components.minute >= 2) {
			return "\(components.minute!) minutes ago"
		} else if (components.minute >= 1) {
			return numeric ? "1 minute ago" : "a minute ago"
		} else if (components.second >= 3 && seconds) {
			return "\(components.second!) seconds ago"
		} else {
			return "just now"
		}
	}
	
	public func fullString() -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .fullStyle
		formatter.timeStyle = .longStyle
		return formatter.string(from: self)
	}
}

@IBDesignable
public class NSAutoLayoutTextView: NSTextView {
	public override var intrinsicContentSize: NSSize {
		self.layoutManager?.ensureLayout(for: self.textContainer!)
		return (self.layoutManager?.usedRect(for: self.textContainer!).size)!
	}
	public override func didChangeText() {
		super.didChangeText()
		self.invalidateIntrinsicContentSize()
	}
}

/// Completely dysfunctional with UserDefaults for some insane reason.
public final class KVOTrampoline: NSObject {
	private let refObject: NSObject
	private let refAction: (Void) -> Void
	private var refCounts = [String: UInt]()
	
	public required init(observeOn object: NSObject, perform handler: (Void) -> Void) {
		self.refObject = object
		self.refAction = handler
	}
	
	public func observe(keyPath: String) {
		if (self.refCounts[keyPath] ?? 0) == 0 {
			self.refObject.addObserver(self, forKeyPath: keyPath, options: [.initial, .new], context: nil)
		}
		self.refCounts[keyPath] = (self.refCounts[keyPath] ?? 0) + 1
	}
	
	public func release(keyPath: String) {
		self.refCounts[keyPath] = (self.refCounts[keyPath] ?? 0) - 1
		if (self.refCounts[keyPath] ?? 0) == 0 {
			self.refObject.removeObserver(self, forKeyPath: keyPath)
		}
	}
	
	public override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?,
	                                  change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
		guard let o = object where o === self.refObject else { return }
		guard let k = keyPath where self.refCounts.keys.contains(k) else { return }
		self.refAction()
	}
}

/// Can hold any (including non-object) type as an object type.
public class Wrapper<T> {
	public let element: T
	public init(_ value: T) {
		self.element = value
	}
}
