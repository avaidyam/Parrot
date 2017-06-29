import AppKit
import Mocha

/* TODO: Localization support for NSDateFormatter stuff. */

public extension NSView {
	
	/// Snapshots the view as it exists and return an NSImage of it.
	public func snapshot() -> NSImage {
		
		// First get the bitmap representation of the view.
		let rep = self.bitmapImageRepForCachingDisplay(in: self.bounds)!
		self.cacheDisplay(in: self.bounds, to: rep)
		
		// Stuff the representation into an NSImage.
		let snapshot = NSImage(size: rep.size)
		snapshot.addRepresentation(rep)
		return snapshot
	}
	
	/// Automatically translate a view into a NSDraggingImageComponent
	public func draggingComponent(_ key: String) -> NSDraggingImageComponent {
        let component = NSDraggingImageComponent(key: NSDraggingItem.ImageComponentKey(rawValue: key))
		component.contents = self.snapshot()
		component.frame = self.convert(self.bounds, from: self)
		return component
	}
    
    /// Add multiple subviews at a time to an NSView.
    public func add(subviews: [NSView]) {
        for s in subviews {
            self.addSubview(s)
        }
    }
}

@objc fileprivate protocol _NSWindowPrivate {
    func _setTransformForAnimation(_: CGAffineTransform, anchorPoint: CGPoint)
}

public extension NSWindow {
    public func scale(to scale: Double = 1.0, by anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        let p = anchorPoint
        assert((p.x >= 0.0 && p.x <= 1.0) && (p.y >= 0.0 && p.y <= 1.0),
               "Anchor point coordinates must be between 0 and 1!")
        let q = CGPoint(x: p.x * self.frame.size.width,
                        y: p.y * self.frame.size.height)
        
        // Apply the transformation by transparently using CGSSetWindowTransformAtPlacement()
        let a = CGAffineTransform(scaleX: CGFloat(1.0 / scale), y: CGFloat(1.0 / scale))
        unsafeBitCast(self, to: _NSWindowPrivate.self)
            ._setTransformForAnimation(a, anchorPoint: q)
    }
}

// TODO: Switch for actually using NSUIAnimator or the animator() proxy.
public extension NSAnimationContext {
    
    @discardableResult
    public static func animate(duration: TimeInterval = 1.0, timingFunction: CAMediaTimingFunction? = nil, _ animations: () -> ()) -> NSAnimationContext {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.allowsImplicitAnimation = true
        NSAnimationContext.current.duration = duration
        NSAnimationContext.current.timingFunction = timingFunction
        animations()
        NSAnimationContext.endGrouping()
        return NSAnimationContext.current
    }
    
    public static func disableAnimations(_ animations: () -> ()) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0
        animations()
        NSAnimationContext.endGrouping()
    }
    
    public func onCompletion(_ handler: @escaping () -> ()) {
        self.completionHandler = handler
    }
}

public extension NSWindow {
    
    // Animate the change in appearance.
    public func animateAppearance(_ appearance: NSAppearance) {
        guard let view = self.contentView?.superview else {
            self.appearance = appearance; return
        }
        view.superlay { v in
            self.appearance = appearance
            v.animator().alphaValue = 0.0
            v.animator().removeFromSuperview()
        }
    }
}

public extension NSView {
    
    //
    public func animateAppearance(_ appearance: NSAppearance) {
        self.superlay { v in
            self.appearance = appearance
            v.animator().alphaValue = 0.0
            v.animator().removeFromSuperview()
        }
    }
    
    // Internal "super-overlay" view used to fade appearance animations.
    fileprivate func superlay(_ handler: (NSView) -> () = {v in}) {
        let v = NSDeadView(frame: self.frame)
        v.wantsLayer = true
        v.layer?.contents = self.snapshot()
        
        if let s = self.superview {
            s.addSubview(v, positioned: .above, relativeTo: self)
        } else {
            self.addSubview(v, positioned: .above, relativeTo: nil)
        }
        handler(v)
    }
}

// Doesn't respond to any mouse events.
fileprivate class NSDeadView: NSView {
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return false
    }
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil //ignoresHitTest property
    }
}

public extension NSView {
	
	/* TODO: Finish this stuff here. */
    public var occlusionState: NSWindow.OcclusionState {
		let selfRect = self.window!.frame
		let windows = CGWindowListCopyWindowInfo(.optionOnScreenAboveWindow, CGWindowID(self.window!.windowNumber))!
		for dict in (windows as [AnyObject]) {
			guard let window = dict as? NSDictionary else { return .visible }
			guard let detail = window[kCGWindowBounds as String] as? NSDictionary else { return .visible }
			let rect = NSRect(x: detail["X"] as? Int ?? 0, y: detail["Y"] as? Int ?? 0,
			                  width: detail["Width"] as? Int ?? 0, height: detail["Height"] as? Int ?? 0)
			//guard rect.contains(selfRect) else { continue }
			let intersected = self.window!.convertFromScreen(rect.intersection(selfRect))
			Swift.print("intersect => \(intersected)")
			
			//log.info("alpha: \(window[kCGWindowAlpha as String])")
		}
		return .visible
	}
}

public extension NSAlert {
    
    /// Convenience to initialize a canned NSAlert.
    /// TODO: Add help and info buttons to the button array as attributes.
    // .style(.informational), .button("hi"), .help, .suppress, etc.
    public convenience init(style: NSAlert.Style = .warning, message: String = "",
                            information: String = "", buttons: [String] = [],
                            showSuppression: Bool = false) {
        self.init()
        self.alertStyle = style
        self.messageText = message
        self.informativeText = information
        for b in buttons {
            self.addButton(withTitle: b)
        }
        self.showsSuppressionButton = showSuppression
        self.layout()
    }
    
}

public extension Date {
	public static let origin = Date(timeIntervalSince1970: 0)
}

public extension NSFont {
	
	/// Load an NSFont from a provided URL.
	public static func from(_ fontURL: URL, size: CGFloat) -> NSFont? {
		let desc = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL) as NSArray?
        guard let item = desc?[0] else { return nil }
		return CTFontCreateWithFontDescriptor(item as! CTFontDescriptor, size, nil)
	}
}

/// Register for AppleEvents that follow our URL scheme as a compatibility
/// layer for macOS 10.13 methods.
///
/// Note: this only applies to CFBundleURLTypes, and not CFBundleDocumentTypes
/// on compatibility platforms. -application:openFiles: and -application:openFile:
/// will still be invoked for documents.
///
/// A "typealias" for the traditional NSApplication delegation.
open class NSApplicationController: NSObject, NSApplicationDelegate {
    public override init() {
        super.init()
        if floor(NSAppKitVersion.current.rawValue) <= NSAppKitVersion.macOS10_12.rawValue {
            let ae = NSAppleEventManager.shared()
            ae.setEventHandler(self, andSelector: #selector(self.handleURL(event:withReply:)),
                               forEventClass: UInt32(kInternetEventClass),
                               andEventID: UInt32(kAEGetURL)
            )
        }
    }
    @objc private func handleURL(event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        guard   let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            let url = URL(string: urlString) else { return }
        let sel = Selector(("application:" + "openURLs:")) // since DNE on < macOS 13
        if self.responds(to: sel) {
            self.perform(sel, with: NSApp, with: [url])
        }
    }
}

public extension NSHapticFeedbackManager {
    public static func vibrate(length: Int = 1000, interval: Int = 10) {
        let hp = NSHapticFeedbackManager.defaultPerformer
        for _ in 1...(length/interval) {
            hp.perform(.generic, performanceTime: .now)
            usleep(UInt32(interval * 1000))
        }
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
	p.resolvesAliases = true
	p.allowedFileTypes = fileTypes
	p.prompt = "Select"
	p.beginSheetModal(for: window) { r in
		guard r.rawValue == NSFileHandlingPanelOKButton else { return }
		handler(p.urls)
	}
}

public extension NSCollectionView {
    
    /// The SelectionType describes the manner in which the ListView may be selected by the user.
    public enum SelectionType {
        
        /// No items may be selected.
        case none
        
        /// One item may be selected at a time.
        case one
        
        /// One item must be selected at all times.
        case exactOne
        
        /// At least one item must be selected at all times.
        case leastOne
        
        /// Multiple items may be selected at a time.
        case any
    }
    
    public func indexPathForLastItem() -> IndexPath {
        let sec = max(0, self.numberOfSections - 1)
        let it = max(0, self.numberOfItems(inSection: sec) - 1)
        return IndexPath(item: it, section: sec)
    }
    
    /// Determines the selection capabilities of the ListView.
    public var selectionType: SelectionType {
        get { return _selectionTypeProp.get(self) ?? .none }
        set(s) { _selectionTypeProp.set(self, value: s)
            
            self.allowsMultipleSelection = (s == .leastOne || s == .any)
            self.allowsEmptySelection = (s == .none || s == .one || s == .any)
            self.isSelectable = (s != .none)
        }
    }
}
private var _selectionTypeProp = AssociatedProperty<NSCollectionView, NSCollectionView.SelectionType>(.strong)

public extension NSScrollView {
    
    @nonobjc
    public convenience init(for contentView: NSView? = nil) {
        self.init(frame: .zero)
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.drawsBackground = false
        self.backgroundColor = .clear
        self.borderType = .noBorder
        self.documentView = contentView
        self.hasVerticalScroller = true
    }
}

public extension NSWindow {
    public var frameView: NSView {
        return self.value(forKey: "_borderView") as! NSView
    }
    public var titlebar: NSViewController {
        return self.value(forKey: "titlebarViewController") as! NSViewController
    }
}

//
//
//

@discardableResult
public func benchmark<T>(_ only60FPS: Bool = true, _ title: String = #function, _ handler: () throws -> (T)) rethrows -> T {
    let t = CACurrentMediaTime()
    let x = try handler()
    
    let ms = (CACurrentMediaTime() - t)
    if (!only60FPS) || (only60FPS && ms > (1/60)) {
        print("Operation \(title) took \(ms * 1000)ms!")
    }
    return x
}

@discardableResult
public func UI<T>(_ handler: @escaping () throws -> (T)) rethrows -> T {
    if DispatchQueue.current == .main {
        return try handler()
    } else {
        return try DispatchQueue.main.sync(execute: handler)
    }
}
