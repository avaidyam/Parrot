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
	
	@IBInspectable
	public var placeholderString: String? = nil
	public var placeholderTextAttributes: [String: AnyObject] = [:]
	
	public override var intrinsicContentSize: NSSize {
		self.layoutManager?.ensureLayout(for: self.textContainer!)
		return (self.layoutManager?.usedRect(for: self.textContainer!).size)!
	}
	public override func didChangeText() {
		super.didChangeText()
		self.invalidateIntrinsicContentSize()
	}
	public override func becomeFirstResponder() -> Bool {
		self.needsDisplay = true
		return super.becomeFirstResponder()
	}
	public override func resignFirstResponder() -> Bool {
		self.needsDisplay = true
		return super.resignFirstResponder()
	}
	
	public override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
		guard let s = self.string where s.isEmpty else { return }
		guard let p = self.placeholderString else { return }
		guard self !== self.window?.firstResponder else { return }
		
		let str = AttributedString(string: p, attributes: self.placeholderTextAttributes)
		str.draw(at: .zero)
	}
}

public let materialColors = [
	#colorLiteral(red: 0.9450980425, green: 0.1568627506, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.8941176534, green: 0, blue: 0.3098039329, alpha: 1), #colorLiteral(red: 0.5411764979, green: 0, blue: 0.6392157078, alpha: 1), #colorLiteral(red: 0.3254902065, green: 0.1019607857, blue: 0.6705882549, alpha: 1), #colorLiteral(red: 0.1843137294, green: 0.2117647082, blue: 0.6627451181, alpha: 1), #colorLiteral(red: 0.08235294372, green: 0.4941176474, blue: 0.9568627477, alpha: 1), #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1), #colorLiteral(red: 0, green: 0.6862745285, blue: 0.8000000119, alpha: 1), #colorLiteral(red: 0.003921568859, green: 0.5254902244, blue: 0.4588235319, alpha: 1),
	#colorLiteral(red: 0.2352941185, green: 0.6470588446, blue: 0.2274509817, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.7372549176, blue: 0.1960784346, alpha: 1), #colorLiteral(red: 0.7647058964, green: 0.8549019694, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 1, green: 0.9254902005, blue: 0.08627451211, alpha: 1), #colorLiteral(red: 1, green: 0.7176470757, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5254902244, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2431372553, blue: 0.04705882445, alpha: 1), #colorLiteral(red: 0.400000006, green: 0.2627451122, blue: 0.2156862766, alpha: 1), #colorLiteral(red: 0.3019607961, green: 0.4156862795, blue: 0.4745098054, alpha: 1),
]
public func imageForString(forString source: String, size: NSSize = NSSize(width: 512.0, height: 512.0), colors: [NSColor] = materialColors) -> NSImage {
	return NSImage(size: size, flipped: false) { rect in
		colors[abs(source.hashValue) % colors.count].set()
		NSRectFill(rect)
		
		let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
		textStyle.alignment = .center
		let font = NSFont.systemFont(ofSize: rect.size.width * 0.75)
		let attrs = [
			NSFontAttributeName: font,
			NSForegroundColorAttributeName: NSColor.white(),
			NSParagraphStyleAttributeName: textStyle
		]
		
		var rect2 = rect
		rect2.origin.y = rect.midY - (font.capHeight / 2)
		let str = String(source.characters.first!).uppercased()
		str.draw(with: rect2, attributes: attrs)
		return true
	}
}
public func defaultImageForString(forString source: String, size: NSSize = NSSize(width: 512.0, height: 512.0), colors: [NSColor] = materialColors) -> NSImage {
	return NSImage(size: size, flipped: false) { rect in
		colors[abs(source.hashValue) % colors.count].set()
		NSRectFill(rect)
		var r = rect.insetBy(dx: -size.width * 0.05, dy: -size.height * 0.05)
		r.origin.y -= size.height * 0.1
		NSImage(named: "NSUserGuest")!.draw(in: r) // composite this somehow.
		return true
	}
}

public extension NSFont {
	
	/// Load an NSFont from a provided URL.
	public static func from(_ fontURL: URL, size: CGFloat) -> NSFont? {
		let desc = CTFontManagerCreateFontDescriptorsFromURL(fontURL)
		guard let item = (desc as? NSArray)?[0] else { return nil }
		return CTFontCreateWithFontDescriptor(item as! CTFontDescriptor, size, nil)
	}
}

/// A "typealias" for the traditional NSApplication delegation.
public class ApplicationController: NSObject, NSApplicationDelegate {}

/// Can hold any (including non-object) type as an object type.
public class Wrapper<T> {
	public let element: T
	public init(_ value: T) {
		self.element = value
	}
}
