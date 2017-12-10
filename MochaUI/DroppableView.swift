import Cocoa

/* TODO: DroppableView.types should take UTI types that filter pasteboard items. */

public protocol DroppableViewDraggingDelegate {
    func dragging(state: DroppableView.DragState, for: NSDraggingInfo) -> NSDragOperation
}

public protocol DroppableViewOperationDelegate {
    func dragging(state: DroppableView.OperationState, for: NSDraggingInfo) -> Bool
}

public class DroppableView: NSView {
    
    public enum DragState {
        case entered, updated, exited
    }
    
    public enum OperationState {
        case preparing, performing
    }
    
    //
    //
    //
    
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
    
    public var delegate: AnyObject? = nil
    
    public var extensions: [String] = [] {
        didSet {
            var types: [String] = []
            for ext in self.extensions {
                types.append("NSTypedFilenamesPboardType:\(ext)")
            }
            // FIXME: Doing nothing with the `types` //._URL too?
            self.registerForDraggedTypes([._fileURL])
        }
    }
    
    public var defaultOperation: NSDragOperation = .copy
    
    public var tintColor: NSColor = NSColor.selectedMenuItemColor {
        didSet {
            self.needsDisplay = true
        }
    }
    
    private var currentDragState: DragState = .exited {
        didSet {
            self.needsDisplay = true
        }
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
        self.layer!.addSublayer(self.ringLayer)
    }
    
    //
    //
    //
    
    public override var allowsVibrancy: Bool { return true }
    public override var wantsUpdateLayer: Bool { return true }
    public override func updateLayer() {
        self.ringLayer.borderColor = self.tintColor.cgColor
        self.ringLayer.opacity = self.currentDragState == .exited ? 0 : 1
    }
    
    private func blink() {
        self.ringLayer.opacity = 0.0
        self.ringLayer.add(self.blinkAnim, forKey: "opacity")
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
        self.currentDragState = .entered
        guard let d = self.delegate as? DroppableViewDraggingDelegate else {
            return self.hasValidFiles(sender) ? self.defaultOperation : []
        }
        print("\n\n\(#function)\n\n")
        return d.dragging(state: .entered, for: sender)
    }
    
    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.currentDragState = .updated
        guard let d = self.delegate as? DroppableViewDraggingDelegate else {
            return self.hasValidFiles(sender) ? self.defaultOperation : []
        }
        print("\n\n\(#function)\n\n")
        return d.dragging(state: .updated, for: sender)
    }
    
    public override func draggingExited(_ sender: NSDraggingInfo?) {
        self.currentDragState = .exited
        guard let d = self.delegate as? DroppableViewDraggingDelegate else { return }
        _ = d.dragging(state: .exited, for: sender!)
        print("\n\n\(#function)\n\n")
    }
    
    public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        self.currentDragState = .entered
        guard let d = self.delegate as? DroppableViewOperationDelegate else { return true }
        return d.dragging(state: .preparing, for: sender)
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        self.blink()
        self.currentDragState = .exited
        self.needsDisplay = false // otherwise animation fails to run
        guard let d = self.delegate as? DroppableViewOperationDelegate else { return true }
        return d.dragging(state: .performing, for: sender)
    }
    
    //
    //
    //
    
    // TODO: if dragging an image that isn't on-disk, this crashes.
    public class func fileUrls(from info: NSDraggingInfo) -> [URL]? {
        let pboard = info.draggingPasteboard()
        guard pboard.types!.contains(._fileURL) else { return nil }
        
        let urls = pboard.readObjects(forClasses: [NSURL.self], options: nil) as? [NSURL]
        var realUrls = [URL]()
        for url in urls! where url.filePathURL != nil {
            realUrls.append(url.filePathURL!) // use filePathURL to avoid file:// file id's
        }
        return realUrls
    }
    
    private func hasValidFiles(_ info: NSDraggingInfo) -> Bool {
        guard let urls = DroppableView.fileUrls(from: info) else { return false }
        return urls.filter { !self.extensions.contains($0.pathExtension) }.count == 0
            && urls.count > 0 // so we need at least 1 url, and all url extensions must be ok
    }
}

// Some backward compatible extensions since macOS 10.13 did some weird things.
public extension NSPasteboard.PasteboardType {
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
