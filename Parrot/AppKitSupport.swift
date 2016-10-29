import AppKit

/* TODO: Localization support for NSDateFormatter stuff. */

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

public extension CAAnimation {
	
	/// A bunch of layer animations to get the "scale in" effect for NSViews.
	public static func scaleIn(forFrame frame: CGRect, amount: Double = 1.5,
	                           duration: TimeInterval = NSAnimationContext.current().duration) -> CAAnimation {
		let anchorPoint = NSValue(point: CGPoint(x: 0.5, y: 0.5))
		let position = NSValue(point: CGPoint(x: frame.midX, y: frame.midY))
		
		let scale = CABasicAnimation(keyPath: "transform.scale")
		scale.fromValue = amount
		let pos = CABasicAnimation(keyPath: "position")
		pos.fromValue = position
		pos.toValue = position
		let anchor = CABasicAnimation(keyPath: "anchorPoint")
		anchor.fromValue = anchorPoint
		anchor.toValue = anchorPoint
		
		let group = CAAnimationGroup()
		group.duration = duration
		group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		group.animations = [scale, pos, anchor]
		return group
	}
}

/*
public extension NSPopover {
	public dynamic var anchorEdge: NSRectEdge
}
*/

// TODO: Switch for actually using NSUIAnimator or the animator() proxy.
public extension NSAnimationContext {
    
    @discardableResult
    public static func animate(duration: TimeInterval = 1.0, timingFunction: CAMediaTimingFunction? = nil, _ animations: () -> ()) -> NSAnimationContext {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().allowsImplicitAnimation = true
        NSAnimationContext.current().duration = duration
        NSAnimationContext.current().timingFunction = timingFunction
        animations()
        NSAnimationContext.endGrouping()
        return NSAnimationContext.current()
    }
    
    public static func disableAnimations(_ animations: () -> ()) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 0
        animations()
        NSAnimationContext.endGrouping()
    }
    
    public func onCompletion(_ handler: @escaping () -> ()) {
        self.completionHandler = handler
    }
}

public extension NSNib {
	public func instantiate(_ owner: Any?) -> [AnyObject] {
		var stuff: NSArray = []
		if self.instantiate(withOwner: nil, topLevelObjects: &stuff) {
			return stuff as [AnyObject]
		}
		return []
	}
}

extension NSWindowController: NSWindowDelegate, NSDrawerDelegate, NSPopoverDelegate {
	public func showWindow() {
		DispatchQueue.main.async {
			self.showWindow(nil)
		}
	}
}

extension NSCollectionView {
    public func performUpdate() {
        self.performBatchUpdates({}, completionHandler: nil)
    }
}

/// from @jack205: https://gist.github.com/jacks205/4a77fb1703632eb9ae79
public extension Date {
	public func relativeString(numeric: Bool = false, seconds: Bool = false) -> String {
		
		let date = self, now = Date()
		let calendar = Calendar.current
		let earliest = (now as NSDate).earlierDate(date) as Date
		let latest = (earliest == now) ? date : now
		let units = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfYear, .month, .year])
		let components = calendar.dateComponents(units, from: earliest, to: latest)
		
		if components.year ?? -1 > 45 {
			return "a while ago"
		} else if (components.year ?? -1 >= 2) {
			return "\(components.year!) years ago"
		} else if (components.year ?? -1 >= 1) {
			return numeric ? "1 year ago" : "last year"
		} else if (components.month ?? -1 >= 2) {
			return "\(components.month!) months ago"
		} else if (components.month ?? -1 >= 1) {
			return numeric ? "1 month ago" : "last month"
		} else if (components.weekOfYear ?? -1 >= 2) {
			return "\(components.weekOfYear!) weeks ago"
		} else if (components.weekOfYear ?? -1 >= 1) {
			return numeric ? "1 week ago" : "last week"
		} else if (components.day ?? -1 >= 2) {
			return "\(components.day!) days ago"
		} else if (components.day ?? -1 >= 1) {
			return numeric ? "1 day ago" : "a day ago"
		} else if (components.hour ?? -1 >= 2) {
			return "\(components.hour!) hours ago"
		} else if (components.hour ?? -1 >= 1){
			return numeric ? "1 hour ago" : "an hour ago"
		} else if (components.minute ?? -1 >= 2) {
			return "\(components.minute!) minutes ago"
		} else if (components.minute ?? -1 >= 1) {
			return numeric ? "1 minute ago" : "a minute ago"
		} else if (components.second ?? -1 >= 3 && seconds) {
			return "\(components.second!) seconds ago"
		} else {
			return "just now"
		}
	}
	
	private static var formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .full
		formatter.timeStyle = .long
		return formatter
	}()
	
	public func fullString() -> String {
		return Date.formatter.string(from: self)
	}
	
	public func nearestMinute() -> Date {
		let c = Calendar.current
		var next = c.dateComponents(Set<Calendar.Component>([.minute]), from: self)
        next.minute = (next.minute ?? -1) + 1
		return c.nextDate(after: self, matching: next, matchingPolicy: .strict) ?? self
	}
}

public extension NSWindowOcclusionState {
	public static let invisible = NSWindowOcclusionState(rawValue: 0)
}

public extension NSView {
	
	/* TODO: Finish this stuff here. */
	public var occlusionState: NSWindowOcclusionState {
		let selfRect = self.window!.frame
		let windows = CGWindowListCopyWindowInfo(.optionOnScreenAboveWindow, CGWindowID(self.window!.windowNumber))!
		for dict in (windows as [AnyObject]) {
			guard let window = dict as? NSDictionary else { return .visible }
			guard let detail = window[kCGWindowBounds as String] as? NSDictionary else { return .visible }
			let rect = NSRect(x: detail["X"] as? Int ?? 0, y: detail["Y"] as? Int ?? 0,
			                  width: detail["Width"] as? Int ?? 0, height: detail["Height"] as? Int ?? 0)
			//guard rect.contains(selfRect) else { continue }
			let intersected = self.window!.convertFromScreen(rect.intersection(selfRect))
			log.info("intersect => \(intersected)")
			
			//log.info("alpha: \(window[kCGWindowAlpha as String])")
		}
		return .visible
	}
}

public extension Date {
	public static let origin = Date(timeIntervalSince1970: 0)
}

public extension NSFont {
	
	/// Load an NSFont from a provided URL.
	public static func from(_ fontURL: URL, size: CGFloat) -> NSFont? {
		let desc = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL)
		guard let item = (desc as? NSArray)?[0] else { return nil }
		return CTFontCreateWithFontDescriptor(item as! CTFontDescriptor, size, nil)
	}
}

/// A "typealias" for the traditional NSApplication delegation.
public class NSApplicationController: NSObject, NSApplicationDelegate {}

/// Can hold any (including non-object) type as an object type.
public class Wrapper<T> {
	public let element: T
	public init(_ value: T) {
		self.element = value
	}
}

public class MenuItem: NSMenuItem {
    private var handler: () -> ()
    
    public init(title: String, keyEquivalent: String = "", handler: @escaping () -> ()) {
        self.handler = handler
        super.init(title: title, action: #selector(action(_:)), keyEquivalent: keyEquivalent)
        self.target = self
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func action(_ sender: AnyObject?) {
        self.handler()
    }
}

public extension NSMenu {
    
    @discardableResult
    public func addItem(title: String, keyEquivalent: String = "", handler: @escaping () -> ()) -> NSMenuItem {
        let item = MenuItem(title: title, keyEquivalent: keyEquivalent, handler: handler)
        self.addItem(item)
        return item
    }
}

public func runSelectionPanel(for window: NSWindow, fileTypes: [String],
                              multiple: Bool = false, _ handler: @escaping ([URL]) -> () = {_ in}) {
	let p = NSOpenPanel()
	p.allowsMultipleSelection = multiple
	p.canChooseDirectories = false
	p.canChooseFiles = true
	p.canCreateDirectories = false
	p.canDownloadUbiquitousContents = true
	p.canResolveUbiquitousConflicts = false
	p.resolvesAliases = false
	p.allowedFileTypes = fileTypes
	p.prompt = "Select"
	p.beginSheetModal(for: window) { r in
		guard r == NSFileHandlingPanelOKButton else { return }
		handler(p.urls)
	}
}
