import Cocoa

/* TODO: concludeDragOperation, wantsPeriodicDraggingUpdates, updateDraggingItemsForDrag. */
/* TODO: what if spring-loading a child window and deciding not to continue, and then un-spring? */
/* TODO: what if the acceptedTypes = [._fileURL] already? just short-circuit the verification? */

@objc public protocol DroppableViewDelegate {
    @objc optional func dragging(state: DroppableView.DragState, for: NSDraggingInfo) -> NSDragOperation
    @objc optional func dragging(phase: DroppableView.OperationPhase, for: NSDraggingInfo) -> Bool
    
    @objc optional func springLoading(state: DroppableView.DragState, for: NSDraggingInfo) -> NSSpringLoadingOptions
    @objc optional func springLoading(phase: DroppableView.SpringLoadingPhase, for: NSDraggingInfo)
}

public class DroppableView: NSView, NSSpringLoadingDestination /*NSDraggingDestination*/ {
    
    @objc public enum DragState: Int {
        case entered, updated, exited
    }
    
    @objc public enum OperationPhase: Int {
        case preparing, performing
    }
    
    @objc public enum SpringLoadingPhase: Int {
        case activated, deactivated
    }
    
    //
    //
    //
    
    private lazy var baseLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        layer.cornerRadius = 4.0
        layer.opacity = 0.0
        return layer
    }()
    
    private lazy var ringLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        layer.borderWidth = 4.0
        layer.cornerRadius = 4.0
        layer.opacity = 0.0
        return layer
    }()
    
    private lazy var blinkAnim: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.autoreverses = true
        animation.repeatCount = 3
        return animation
    }()
    
    private lazy var flashAnim: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 0.33
        animation.duration = 0.05
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.autoreverses = true
        animation.repeatCount = 2
        return animation
    }()
    
    // Conformance is split into DroppableView{Dragging, Operation}Delegate. Only one delegate may be provided though.
    public var delegate: DroppableViewDelegate? = nil
    
    /// Also accepts fileURLs whose UTI conforms to these types.
    public var acceptedTypes: [NSPasteboard.PasteboardType] = [] {
        didSet {
            self.unregisterDraggedTypes()
            self.registerForDraggedTypes(self.acceptedTypes + [._fileURL])
            // register for the raw kUTTypes AND manually process fileURL types.
        }
    }
    
    public var operation: NSDragOperation = .copy
    
    public var allowsSpringLoading: Bool = false
    
    public var tintColor: NSColor = NSColor.selectedMenuItemColor {
        didSet {
            self.needsDisplay = true
        }
    }
    
    public var hapticResponse: Bool = true
    
    public var sound: NSSound? = nil
    
    private var currentDragState: DragState = .exited {
        didSet {
            self.needsDisplay = true
        }
    }
    
    private var springLoadingState: DragState = .exited {
        didSet {
            self.needsDisplay = true
        }
    }
    
    public var isEnabled: Bool = true
    
    public var isHighlighted: Bool {
        return !(self.currentDragState == .exited && self.springLoadingState == .exited)
    }
    
    //
    //
    //
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup() {
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.layer!.addSublayer(self.baseLayer)
        self.layer!.addSublayer(self.ringLayer)
    }
    
    //
    //
    //
    
    public override var allowsVibrancy: Bool { return true }
    public override var wantsUpdateLayer: Bool { return true }
    public override func updateLayer() {
        self.baseLayer.backgroundColor = self.tintColor.cgColor
        self.baseLayer.opacity = self.springLoadingState == .exited ? 0 : 0.33
        self.ringLayer.borderColor = self.tintColor.cgColor
        self.ringLayer.opacity = self.currentDragState == .exited ? 0 : 1
    }
    
    private func blink() {
        self.ringLayer.opacity = 0.0
        self.ringLayer.add(self.blinkAnim, forKey: "opacity")
        self.currentDragState = .exited
        self.needsDisplay = false // otherwise animation fails to run
        
        self.sound?.play()
    }
    
    private func flash() {
        self.baseLayer.opacity = 0.0
        self.baseLayer.add(self.flashAnim, forKey: "opacity")
        self.springLoadingState = .exited
        self.needsDisplay = false // otherwise animation fails to run
    }
    
    //
    //
    //
    
    public override var acceptsFirstResponder: Bool {
        return false
    }
    public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return false
    }
    public override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    //
    //
    //
    
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let valid = self.isValid(sender)
        self.currentDragState = valid ? .entered : .exited
        if valid && self.hapticResponse {
            NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .drawCompleted)
        }
        return self.delegate?.dragging?(state: .entered, for: sender) ?? (valid ? self.operation : [])
    }
    
    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        let valid = self.isValid(sender)
        self.currentDragState = valid ? .updated : .exited
        return self.delegate?.dragging?(state: .updated, for: sender) ?? (valid ? self.operation : [])
    }
    
    public override func draggingExited(_ sender: NSDraggingInfo?) {
        if self.hapticResponse && sender != nil && self.isValid(sender!) {
            NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .drawCompleted)
        }
        self.currentDragState = .exited
        _ = self.delegate?.dragging?(state: .exited, for: sender!) // FIXME!
    }
    
    public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let accepted = self.delegate?.dragging?(phase: .preparing, for: sender) {
            if accepted {
                self.currentDragState = .exited
            }
            return accepted
        } else {
            self.currentDragState = .exited
            return false
        }
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let accepted = self.delegate?.dragging?(phase: .performing, for: sender) {
            if accepted {
                self.blink()
                if self.hapticResponse {
                    NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)
                }
            } else {
                self.currentDragState = .exited
            }
            return accepted
        } else {
            self.currentDragState = .exited
            return false
        }
    }
    
    public func springLoadingEntered(_ draggingInfo: NSDraggingInfo) -> NSSpringLoadingOptions {
        return self.delegate?.springLoading?(state: .entered, for: draggingInfo) ?? (self.allowsSpringLoading ? .enabled : .disabled)
    }
    
    public func springLoadingUpdated(_ draggingInfo: NSDraggingInfo) -> NSSpringLoadingOptions {
        return self.delegate?.springLoading?(state: .updated, for: draggingInfo) ?? (self.allowsSpringLoading ? .enabled : .disabled)
    }
    
    public func springLoadingExited(_ draggingInfo: NSDraggingInfo) {
        _ = self.delegate?.springLoading?(state: .exited, for: draggingInfo)
    }
    
    public func springLoadingActivated(_ activated: Bool, draggingInfo: NSDraggingInfo) {
        self.flash()
        self.delegate?.springLoading?(phase: activated ? .activated : .deactivated, for: draggingInfo)
    }
    
    public func springLoadingHighlightChanged(_ draggingInfo: NSDraggingInfo) {
        self.springLoadingState = draggingInfo.springLoadingHighlight == .none ? .exited : .entered
    }
    
    public override func draggingEnded(_ draggingInfo: NSDraggingInfo) {
        self.currentDragState = .exited
        self.springLoadingState = .exited
    }
    
    /// Performs a series of conformation validity checks on each pasteboard item.
    /// This is necessary to allow both a "direct" UTI such as `public.image`
    /// in addition to a file with an "indirect" UTI type (as above) which would normally
    /// have the UTI of `public.file-url`. This does not allow for `public.url` types.
    private func isValid(_ info: NSDraggingInfo) -> Bool {
        for item in info.draggingPasteboard().pasteboardItems ?? [] {
            if let _ = item.availableType(from: self.acceptedTypes) {
                continue // a raw type is available, so don't process file-inferred types
            } else if let _ = item.availableType(from: [._fileURL]) {
                if  let plist = item.propertyList(forType: ._fileURL),
                    let url = NSURL(pasteboardPropertyList: plist, ofType: ._fileURL),
                    let fileURL = url.filePathURL,
                    let type = (try? fileURL.resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier {
                    // we have an inference file type now instead of the public.file-url UTI...
                    
                    for possible in self.acceptedTypes where !UTTypeConformsTo(type as CFString, possible.rawValue as CFString) {
                        return false // the file-inferred types did not match a real UTI type
                    }
                } else {
                    return false // we couldn't extract the url filetype somehow
                }
            } else {
                return false // no raw or file-inferred types were found
            }
        }
        return true // every item conformed directly or through inferrence
    }
}

// The union of all types the pasteboard items collectively hold. Use this instead of
// NSPasteboard's `types` accessor for a UTI-only world.
public extension Array where Element == NSPasteboardItem {
    public var allTypes: [NSPasteboard.PasteboardType] {
        return self.flatMap { $0.types }
    }
}

// Some backward compatible extensions since macOS 10.13 did some weird things.
public extension NSPasteboard.PasteboardType {
    public static func of(_ uti: CFString) -> NSPasteboard.PasteboardType {
        return NSPasteboard.PasteboardType(uti as String)
    }
    public static let _URL: NSPasteboard.PasteboardType = {
        if #available(macOS 10.13, *) {
            return NSPasteboard.PasteboardType.URL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeURL as String)
        }
    }()
    public static let _fileURL: NSPasteboard.PasteboardType = {
        if #available(macOS 10.13, *) {
            return NSPasteboard.PasteboardType.fileURL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
        }
    }()
}
