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
		let component = NSDraggingImageComponent(key: key)
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

// from @nilium: https://github.com/nilium/SwiftSchemer/blob/master/SwiftSchemer/NSView%2BReplacement.swift
public extension NSView {
    
    /// Replaces the receiver with `view` in its superview. If
    /// `preservingConstraints` is true, any constraints referencing the
    /// receiver in its superview will be rewritten to reference `view`.
    public func replaceInSuperview(with view: NSView, preservingConstraints: Bool = true) {
        assert(superview != nil, "Cannot replace self without a superview!")
        if preservingConstraints {
            superview!.replaceSubviewsPreservingConstraints([self: view])
        } else {
            superview!.replaceSubview(self, with: view)
        }
    }
    
    /// Replaces subviews in the receiver while preserving their constraints.
    /// Accepts a dictionary of [NSView: NSView] objects, where the key is the
    /// view to be replaced and its value the replacement.
    func replaceSubviewsPreservingConstraints(_ replacements: [NSView: NSView]) {
        if replacements.isEmpty {
            return
        }
        let currentConstraints = constraints as [NSLayoutConstraint]
        var removedConstraints = [NSLayoutConstraint]()
        var newConstraints     = [NSLayoutConstraint]()
        
        for current in currentConstraints {
            var firstItem: AnyObject?  = current.firstItem
            var secondItem: AnyObject? = current.secondItem
            
            if let firstView = firstItem as? NSView {
                if let replacement = replacements[firstView] {
                    firstItem = replacement
                    replacement.frame = firstView.frame
                }
            }
            if let secondView = secondItem as? NSView {
                if let replacement = replacements[secondView] {
                    secondItem = replacement
                    replacement.frame = secondView.frame
                }
            }
            if firstItem === current.firstItem && secondItem === current.secondItem {
                continue
            }
            
            let updated = NSLayoutConstraint(
                item: firstItem!,
                attribute: current.firstAttribute,
                relatedBy: current.relation,
                toItem: secondItem!,
                attribute: current.secondAttribute,
                multiplier: current.multiplier,
                constant: current.constant
            )
            
            updated.shouldBeArchived = current.shouldBeArchived
            updated.identifier = current.identifier
            updated.priority = current.priority
            
            removedConstraints.append(current)
            newConstraints.append(updated)
        }
        if !removedConstraints.isEmpty {
            removeConstraints(removedConstraints)
        }
        for (subview, replacement) in replacements {
            replaceSubview(subview, with: replacement)
        }
        if !newConstraints.isEmpty {
            addConstraints(newConstraints)
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

public extension NSAppearance {
    public static let aqua = NSAppearance(named: NSAppearanceNameAqua)!
    public static let light = NSAppearance(named: NSAppearanceNameVibrantLight)!
    public static let dark = NSAppearance(named: NSAppearanceNameVibrantDark)!
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
        return nil
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
    public convenience init(style: NSAlertStyle = .warning, message: String = "",
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
		let desc = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL)
		guard let item = (desc as? NSArray)?[0] else { return nil }
		return CTFontCreateWithFontDescriptor(item as! CTFontDescriptor, size, nil)
	}
}

/// A "typealias" for the traditional NSApplication delegation.
open class NSApplicationController: NSObject, NSApplicationDelegate {}

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

public extension NSHapticFeedbackManager {
    public static func vibrate(length: Int = 1000, interval: Int = 10) {
        let hp = NSHapticFeedbackManager.defaultPerformer()
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
	p.resolvesAliases = false
	p.allowedFileTypes = fileTypes
	p.prompt = "Select"
	p.beginSheetModal(for: window) { r in
		guard r == NSFileHandlingPanelOKButton else { return }
		handler(p.urls)
	}
}
