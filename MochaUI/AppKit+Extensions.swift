import AppKit
import Mocha

/* TODO: Localization support for NSDateFormatter stuff. */
/* TODO: Add NSView._semanticContext: Int, NSView._viewController: NSViewController. */

public typealias Block = @convention(block) () -> ()

public extension NSView {
    
    /// Corresponds to `CALayer.backgroundColor`.
    @nonobjc public var fillColor: NSColor {
        get { return NSView.backgroundColorKey[self, default: .clear] }
        set { NSView.backgroundColorKey[self] = newValue }
    }
    
    /// Corresponds to `CALayer.cornerRadius`.
    @nonobjc public var cornerRadius: CGFloat {
        get { return NSView.cornerRadiusKey[self, default: 0.0] }
        set { NSView.cornerRadiusKey[self] = newValue }
    }
    
    /// Corresponds to `CALayer.masksToBounds`.
    @nonobjc public var clipsToBounds: Bool {
        get { return NSView.clipsToBoundsKey[self, default: false] }
        set { NSView.clipsToBoundsKey[self] = newValue }
    }
    
    /// Corresponds to `CALayer.mask` with a `CAShapeLayer` whose path is this value.
    @nonobjc public var clipPath: NSBezierPath? {
        get { return NSView.clipPathKey[self, default: nil] }
        set { NSView.clipPathKey[self] = newValue }
    }
    
    /// Forces NSView to return `nil` from every `hitTest(_:)`, making it "invisible"
    /// to events.
    @nonobjc public var ignoreHitTest: Bool {
        get { return NSView.ignoreHitTestKey[self, default: false] }
        set { NSView.ignoreHitTestKey[self] = newValue }
    }
    
    /// Forces `wantsUpdateLayer` to be `true`, and invokes the block handler during
    /// the `updateLayer` pass; `drawRect(_:)` will not be called.
    @nonobjc public var updateLayerHandler: Block? {
        get { return NSView.updateLayerHandlerKey[self, default: nil] }
        set { NSView.updateLayerHandlerKey[self] = newValue }
    }
    
    /// Sets the view's `isFlipped` value without overriding the class.
    @nonobjc func set(flipped newValue: Bool) {
        NSView.flippedKey[self] = newValue
    }
    
    /// Sets the view's `isOpaque` value without overriding the class.
    @nonobjc func set(opaque newValue: Bool) {
        NSView.opaqueKey[self] = newValue
    }
    
    /// Sets the view's `allowsVibrancy` value without overriding the class.
    @nonobjc func set(allowsVibrancy newValue: Bool) {
        NSView.allowsVibrancyKey[self] = newValue
    }
    
    private static var flippedKey = KeyValueProperty<NSView, Bool>("flipped")
    private static var opaqueKey = KeyValueProperty<NSView, Bool>("opaque")
    private static var backgroundColorKey = KeyValueProperty<NSView, NSColor>("backgroundColor")
    private static var cornerRadiusKey = KeyValueProperty<NSView, CGFloat>("cornerRadius")
    private static var clipsToBoundsKey = KeyValueProperty<NSView, Bool>("clipsToBounds")
    private static var clipPathKey = KeyValueProperty<NSView, NSBezierPath?>("clipPath")
    private static var ignoreHitTestKey = KeyValueProperty<NSView, Bool>("ignoreHitTest")
    private static var allowsVibrancyKey = KeyValueProperty<NSView, Bool>("allowsVibrancy")
    private static var updateLayerHandlerKey = KeyValueProperty<NSView, Block?>("updateLayerHandler")
}

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
    public func add(subviews: NSView...) {
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
        let v = NSView(frame: self.frame)
        v.wantsLayer = true
        //v.acceptsFirstMouse == false?
        v.ignoreHitTest = true
        v.layer?.contents = self.snapshot()
        
        if let s = self.superview {
            s.addSubview(v, positioned: .above, relativeTo: self)
        } else {
            self.addSubview(v, positioned: .above, relativeTo: nil)
        }
        handler(v)
    }
}

public class NSScrollableSlider: NSSlider {
    public override func scrollWheel(with event: NSEvent) {
        if event.momentumPhase != .changed && abs(event.deltaY) > 1.0 {
            self.doubleValue += Double(event.deltaY) / 100 * (self.maxValue - self.minValue)
            self.sendAction(self.action, to: self.target)
        }
    }
}

public extension NSAlert {
    
    /// Convenience to initialize a canned NSAlert.
    public convenience init(style: NSAlert.Style = .warning, message: String = "",
                            information: String = "", buttons: [String] = [],
                            suppressionIdentifier: String = "") {
        self.init()
        self.alertStyle = style
        self.messageText = message
        self.informativeText = information
        for b in buttons {
            self.addButton(withTitle: b)
        }
        
        // Enable alert suppression via unique ID.
        if suppressionIdentifier != "" {
            self.showsSuppressionButton = true
            let key = "alert.suppression.\(suppressionIdentifier)"
            
            self.suppressionButton?.boolValue = UserDefaults.standard.bool(forKey: key)
            self.suppressionButton?.performedAction = {
                UserDefaults.standard.set(self.suppressionButton?.boolValue ?? false, forKey: key)
            }
        }
        self.layout()
    }
    
    public func beginModal(completionHandler handler: ((NSApplication.ModalResponse) -> Void)? = nil) {
        let val = self.runModal()
        handler?(val)
    }
    
    public func beginPopover(for view: NSView, on preferredEdge: NSRectEdge,
                             completionHandler handler: ((NSApplication.ModalResponse) -> Void)? = nil)
    {
        // Copy the appearance to match the popover to the view's window.
        let popover = NSPopover()
        popover.appearance = view.window?.appearance
        
        // For a popover, when no buttons are manually added, the alert adds an unmanaged one.
        if self.buttons.count == 0 {
            self.addButton(withTitle: "OK") // TODO: LOCALIZE
            self.buttons[0].keyEquivalent = "\r"
        }
        
        // Reset the button's bezel style to match a popover and hijack its click action.
        for (idx, button) in self.buttons.enumerated() {
            button.bezelStyle = .texturedRounded
            button.performedAction = { [popover, handler] in
                
                // Close the popover and complete the handler with the clicked index.
                popover.close()
                handler?(NSApplication.ModalResponse(rawValue: 1000 + idx))
            }
        }
        
        // Signal the layout pass and mount the popover on the view.
        self.layout()
        popover.contentView = self.window.contentView!
        popover.show(relativeTo: view.bounds, of: view, preferredEdge: preferredEdge)
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

public extension NSImage {
    
    /// Produce Data from this NSImage with the contained FileType image information.
    public func data(for type: NSBitmapImageRep.FileType) -> Data? {
        guard   let tiff = self.tiffRepresentation,
                let rep = NSBitmapImageRep(data: tiff),
                let dat = rep.representation(using: type, properties: [:])
        else { return nil }
        return dat
    }
}

public func runSelectionPanel(for window: NSWindow, fileTypes: [String]?,
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
        get { return NSCollectionView.selectionTypeProp[self, default: .none] }
        set(s) { NSCollectionView.selectionTypeProp[self] = s
            
            self.allowsMultipleSelection = (s == .leastOne || s == .any)
            self.allowsEmptySelection = (s == .none || s == .one || s == .any)
            self.isSelectable = (s != .none)
        }
    }
    
    private static var selectionTypeProp = AssociatedProperty<NSCollectionView, NSCollectionView.SelectionType>(.strong)
}

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

public extension NSControl {
    
    /// Mutually exclusive with target/action/handlers.
    @discardableResult
    public func setupForBindings() -> Self {
        self.target = self
        self.action = #selector(self.bindingTrampoline(_:))
        return self
    }
    
    /// Allows triggering of all KVO bindings.
    public func triggerBindings() {
        self.bindingTrampoline(self)
    }
    
    @objc private func bindingTrampoline(_ sender: NSControl!) {
        let keys = ["objectValue", "attributedStringValue", "stringValue", "doubleValue",
                    "floatValue", "integerValue", "intValue", "boolValue"]
        for key in keys {
            sender.willChangeValue(forKey: key)
            sender.cell?.willChangeValue(forKey: key)
        }
        for key in keys {
            sender.cell?.didChangeValue(forKey: key)
            sender.didChangeValue(forKey: key)
        }
    }
    
    @objc public dynamic var boolValue: Bool {
        get { return self.integerValue != 0 }
        set { self.integerValue = newValue ? 1 : 0 }
    }
    
    @IBAction public func takeBoolValueFrom(_ sender: Any?) {
        guard let sender = sender as? NSControl else { return }
        self.boolValue = sender.boolValue
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

// Take a screenshot using the system function and provide it as an image.
public func screenshot(interactive: Bool = false) throws -> NSImage {
    let task = Process()
    task.launchPath = "/usr/sbin/screencapture"
    task.arguments = [interactive ? "-ci" : "-cm"]
    task.launch()
    
    var img: NSImage? = nil
    let s = DispatchSemaphore(value: 0)
    task.terminationHandler = { _ in
        guard let pb = NSPasteboard.general.pasteboardItems?.first, pb.types.contains(.png) else {
            s.signal(); return
        }
        guard let data = pb.data(forType: .png), let image = NSImage(data: data) else {
            s.signal(); return
        }
        img = image
        NSPasteboard.general.clearContents()
        s.signal()
    }
    s.wait()
    
    guard img != nil else { throw CocoaError(.fileNoSuchFile) }
    return img!
}

// Trigger the Preview MarkupUI for the given image.
public func markup(for image: NSImage, in view: NSView) throws -> NSImage {
    class MarkupDelegate: NSObject, NSSharingServiceDelegate {
        private let view: NSView
        private let handler: (NSImage?) -> ()
        init(view: NSView, handler: @escaping (NSImage?) -> ()) {
            self.view = view
            self.handler = handler
        }
        
        func sharingService(_ sharingService: NSSharingService, sourceFrameOnScreenForShareItem item: Any) -> NSRect {
            return self.view.window!.frame.insetBy(dx: 0, dy: 16).offsetBy(dx: 0, dy: -16)
        }
        
        func sharingService(_ sharingService: NSSharingService, sourceWindowForShareItems items: [Any], sharingContentScope: UnsafeMutablePointer<NSSharingService.SharingContentScope>) -> NSWindow? {
            return self.view.window!
        }
        
        func sharingService(_ sharingService: NSSharingService, didShareItems items: [Any]) {
            let itp = items[0] as! NSItemProvider
            itp.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, _) in
                self.handler(NSImage(contentsOf: url as! URL))
            }
        }
    }
    
    var img: NSImage? = nil
    let s = DispatchSemaphore(value: 0)
    
    // Allocate the MarkupUI service.
    var service_ = NSSharingService(named: NSSharingService.Name(rawValue: "com.apple.MarkupUI.Markup"))
    if service_ == nil {
        service_ = NSSharingService(named: NSSharingService.Name(rawValue: "com.apple.Preview.Markup"))
    }
    guard let service = service_ else { throw CocoaError(.fileNoSuchFile) }
    
    // Perform the UI action.
    let markup = MarkupDelegate(view: view) {
        img = $0; s.signal()
    }
    service.delegate = markup
    DispatchQueue.main.async {
        service.perform(withItems: [image])
    }
    
    s.wait()
    guard img != nil else { throw CocoaError(.fileNoSuchFile) }
    return img!
}

