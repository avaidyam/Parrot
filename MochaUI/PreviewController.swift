import AppKit
import Mocha
import Quartz

/* TODO: NSPopover.title/addTitlebar(animated: ...)? */
/* TODO: Use NSPressGestureRecognizer if no haptic support. */
/* TODO: Maybe support tear-off popover-windows? */

//let preview = PreviewController(for: self.view, with: .file(URL(fileURLWithPath: pathToFile), nil))
//preview.delegate = self // not required

/// Provides content for a `PreviewController` dynamically.
public protocol PreviewControllerDelegate: class {
    
    /// Return the content for the previewing controller, depending on where
    /// the user began the previewing within the `parentView`. If `nil` is
    /// returned from this method, previewing is disabled.
    func previewController(_: PreviewController, contentAtPoint: CGPoint) -> PreviewController.ContentType?
}

/// The `PreviewController` handles user interactions with previewing indications.
/// The functionality is similar to dictionary or Safari link force touch lookup.
public class PreviewController: NSObject, NSPopoverDelegate, NSGestureRecognizerDelegate {
    
    /// Describes the content to be previewed by the controller for a given interaction.
    public enum ContentType {
        
        ///
        case view(NSViewController)
        
        /// The content is a `file://` URL, optionally with a preview size.
        /// If no size is specified (`nil`), `PreviewController.defaultSize` is used.
        case file(URL, CGSize?)
    }
    
    /// If no size is provided for a `ContentType.file(_, _)`, this value is used.
    public static var defaultSize = CGSize(width: 512, height: 512)
    
    /// Create a `QLPreviewView`-containing `NSViewController` to support files.
    private static func previewer(for item: QLPreviewItem, size: CGSize?) -> NSViewController {
        let vc = NSViewController()
        let rect = NSRect(origin: .zero, size: size ?? PreviewController.defaultSize)
        let ql = QLPreviewView(frame: rect, style: .normal)!
        ql.previewItem = item
        vc.view = ql
        return vc
    }
    
    /// If the `delegate` is not set, the `content` set will be used for previewing,
    /// applicable to the whole `bounds` of the `parentView`.
    ///
    /// If both `delegate` and `content` are `nil`, previewing is disabled.
    public var content: ContentType? = nil
    
    /// Provides content for previewing controller dynamically.
    ///
    /// If both `delegate` and `content` are `nil`, previewing is disabled.
    public weak var delegate: PreviewControllerDelegate? = nil
    
    /// The view that should be registered for previewing; this is not the view
    /// that is contained within the preview itself.
    public weak var parentView: NSView? = nil {
        willSet {
            self.parentView?.removeGestureRecognizer(self.gesture)
        }
        didSet {
            self.parentView?.addGestureRecognizer(self.gesture)
        }
    }
    
    /// Whether the user is currently interacting the preview; that is, the user
    /// is engaged in a force touch interaction to display the preview.
    public private(set) var interacting: Bool = false
    
    /// Whether the preview is visible; setting this property manually bypasses
    /// the user interaction to display the preview regardless.
    ///
    /// When setting `isVisible = true`, the `delegate` is not consulted. Use
    /// `content` to specify the preview content.
    ///
    /// Setting `isVisible` while the user is currently interacting is a no-op.
    public var isVisible: Bool {
        get { return self.popover.isShown }
        set {
            switch newValue {
            case false:
                guard self.popover.isShown, !self.interacting else { return }
                self.popover.performClose(nil)
            case true:
                guard !self.popover.isShown, !self.interacting else { return }
                guard let view = self.parentView else {
                    fatalError("PreviewController.parentView was not set, isVisible=true failed.")
                }
                guard let content = self.content else { return }
                
                // Set the contentView here to maintain only a short-term reference.
                switch content {
                case .view(let vc):
                    self.popover.contentViewController = vc
                case .file(let url, let size):
                    self.popover.contentViewController = PreviewController.previewer(for: url as NSURL, size: size)
                }
                self.popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
            }
        }
    }
    
    /// The popover used to contain and animate the preview content.
    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .semitransient
        popover.delegate = self
        //popover.positioningOptions = .keepTopStable
        return popover
    }()
    
    /// The gesture recognizer used to handle user interaction for previewing.
    private lazy var gesture: PressureGestureRecognizer = {
        let gesture = PressureGestureRecognizer(target: self, action: #selector(self.gesture(_:)))
        gesture.delegate = self
        //gesture.behavior = .primaryAccelerator
        return gesture
    }()
    
    /// Create a `PreviewController` with a provided `parentView` and `content`.
    public init(for view: NSView? = nil, with content: ContentType? = nil) {
        super.init()
        self.commonInit(view, content) // rebound to call property observers
    }
    private func commonInit(_ view: NSView? = nil, _ content: ContentType? = nil) {
        self.parentView = view
        self.content = content
    }
    
    @objc private func gesture(_ sender: PressureGestureRecognizer) {
        switch sender.state {
        case .possible: break // ignore
        case .began:
            guard !self.popover.isShown, !self.interacting else { return }
            
            // Begin interaction animation:
            self.interacting = true
            let point = sender.location(in: self.parentView)
            self.popover._private._beginPredeepAnimationAgainstPoint(point, inView: self.parentView)
        case .changed:
            guard self.popover.isShown, self.interacting else { return }
            
            // Update interaction animation, unless stage 2 (deep press):
            guard sender.stage != 2 else { fallthrough }
            self.popover._private._doPredeepAnimation(withProgress: Double(sender.stage == 2 ? 1.0 : sender.pressure))
        case .ended:
            guard self.popover.isShown, self.interacting else { return }
            
            // Complete interaction animation, only if stage 2 (deep press):
            guard sender.stage == 2 else { fallthrough }
            self.interacting = false
            self.popover._private._completeDeepAnimation()
        case .failed, .cancelled:
            guard self.popover.isShown, self.interacting else { return }
            
            // Cancel interaction animation:
            self.interacting = false
            self.popover._private._cancelPredeepAnimation()
        }
    }
    
    public func popoverDidClose(_ notification: Notification) {
        self.interacting = false
        
        // Clear the contentView here to maintain only a short-term reference.
        self.popover.contentViewController = nil
    }
    
    public func gestureRecognizerShouldBegin(_ sender: NSGestureRecognizer) -> Bool {
        
        /// If there exists a `delegate`, request its dynamic content.
        /// Otherwise, possibly use the static `content` property.
        func effectiveContent(_ point: CGPoint) -> ContentType? {
            guard let delegate = self.delegate else {
                return self.content
            }
            return delegate.previewController(self, contentAtPoint: point)
        }
        
        // Because `self.popover.behavior = .semitransient`, if the preview is
        // currently visible, allow the click to passthrough to the `parentView`.
        // This allows the "second click" to be the actual commit action.
        guard !self.popover.isShown else { return false }
        let content = effectiveContent(sender.location(in: self.parentView))
        guard content != nil else { return false }
        
        // Set the contentView here to maintain only a short-term reference.
        switch content! {
        case .view(let vc):
            self.popover.contentViewController = vc
        case .file(let url, let size):
            self.popover.contentViewController = PreviewController.previewer(for: url as NSURL, size: size)
        }
        return true
    }
    
    // TODO:
    /*
    public func gestureRecognizer(_ sender: NSGestureRecognizer, shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
        if sender is NSPressGestureRecognizer {
            return !event.associatedEventsMask.contains(.pressure)
        } else if sender is PressureGestureRecognizer {
            return event.associatedEventsMask.contains(.pressure)
        }
        return false
    }
    */
}
