import Foundation
import AppKit
import Mocha

/* TODO: Support utility, modal, normal windows, AND drawer/panel? */
// NSApp.runModalForWindow(), NSApp.stopModal(), [.utilityWindow]
/* TODO: Deprecate the _rootAnimator property and use presentionAnimator. */

/// Supported objects can allow customization of their behavior within windows using this protocol.
@objc public protocol WindowPresentable: NSWindowDelegate {
    
    /// Provide a type for the NSWindow to be created.
    @objc optional func windowClass() -> NSWindow.Type
    
    /// As the NSWindow is being prepared, a WindowPresentable may customize it as well.
    func prepare(window: NSWindow)
}

public extension NSViewController {
    
    public func presentViewControllerAsWindow(_ viewController: NSViewController) {
        self.presentViewController(viewController, animator: WindowTransitionAnimator())
    }
    
    // For root controllers. The window delegate is set to the VC if it conforms to NSWindowDelegate.
    public func presentAsWindow() {
        (self._rootAnimator ?? WindowTransitionAnimator()).display(viewController: self)
    }
    
    // For root controllers. Use only if presentAsWindow() was used.
    public func dismissFromWindow() {
        self._rootAnimator?.undisplay(viewController: self)
    }
}

public extension NSViewController {
    
    /// Traverses the ViewController hierarchy and returns the closest ancestor ViewController
    /// that matches the `type` provided. If `includingSelf`, then the receiver can be returned.
    public func ancestor<T: NSViewController>(ofType type: T.Type, includingSelf: Bool = true) -> T? {
        if includingSelf && type(of: self) == type {
            return self as? T
        } else if let p = self.parent {
            return p.ancestor(ofType: type, includingSelf: true)
        }
        return nil
    }
    
    public var splitViewController: NSSplitViewController? {
        return self.ancestor(ofType: NSSplitViewController.self)
    }
    
    public var tabViewController: NSTabViewController? {
        return self.ancestor(ofType: NSTabViewController.self)
    }
}

public extension NSViewController {
    @nonobjc
    public func beginAppearanceTransition(_ appearing: Bool) {
        self.perform(Selector(("beginAppearanceTransition:")), with: appearing)
    }
    
    @nonobjc
    public func endAppearanceTransition() {
        self.perform(Selector(("endAppearanceTransition")))
    }
    
    @nonobjc
    public func willMove(toParent parent: NSViewController) {
        self.perform(Selector(("willMoveToParentViewController:")), with: parent)
    }
    
    @nonobjc
    public func didMove(toParent parent: NSViewController) {
        self.perform(Selector(("didMoveToParentViewController:")), with: parent)
    }
}

public class WindowTransitionAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    private var window: NSWindow?
    deinit {
        assert(self.window == nil, "WindowTransitionAnimator.animateDismissal(...) was not invoked!")
    }
    
    // for ROOT NSViewController only
    public func display(viewController: NSViewController) {
        guard viewController._rootAnimator == nil else {
            assert(viewController._rootAnimator == self, "the view controller has a different WindowTransitionAnimator already!")
            self.window?.makeKeyAndOrderFront(nil)
            return
        }
        
        viewController.view.layoutSubtreeIfNeeded()
        let p = viewController.view.fittingSize
        
        let clazz = (viewController as? WindowPresentable)?.windowClass?() ?? NSWindow.self
        self.window = clazz.init(contentRect: NSRect(x: 0, y: 0, width: p.width, height: p.height),
                                 styleMask: [.titled, .closable, .resizable], backing: .buffered, defer: false)
        self.window?.isReleasedWhenClosed = false
        self.window?.contentView?.superview?.wantsLayer = true // always root-layer-backed
        NotificationCenter.default.addObserver(self, selector: #selector(NSWindowDelegate.windowWillClose(_:)),
                                               name: .NSWindowWillClose, object: self.window)
        
        self.window?.contentViewController = viewController
        self.window?.bind(NSTitleBinding, to: viewController, withKeyPath: "title", options: nil)
        self.window?.appearance = viewController.view.window?.appearance
        self.window?.delegate = viewController as? NSWindowDelegate
        self.window?.center()
        
        if let vc = viewController as? WindowPresentable, let w = self.window {
            vc.prepare(window: w)
        }
        viewController._rootAnimator = self
        self.window?.makeKeyAndOrderFront(nil)
    }
    
    public func undisplay(viewController: NSViewController) {
        NotificationCenter.default.removeObserver(self)
        self.window?.orderOut(nil)
        self.window?.unbind(NSTitleBinding)
        
        self.window = nil
        viewController._rootAnimator = nil
    }
    
    public func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        assert(self.window == nil, "WindowTransitionAnimator.animatePresentation(...) was invoked already!")
        self.display(viewController: viewController)
    }
    
    public func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        assert(self.window != nil, "WindowTransitionAnimator.animateDismissal(...) invoked before WindowTransitionAnimator.animatePresentation(...)!")
        self.undisplay(viewController: viewController)
    }
    
    public func windowWillClose(_ notification: Notification) {
        guard let c = self.window?.contentViewController else { return }
        if let p = c.presenting {
            p.dismiss(c)
        } else {
            self.undisplay(viewController: self.window!.contentViewController!)
        }
    }
}

private var __presentationAnimatorProp = KeyValueProperty<NSViewController, NSViewControllerPresentationAnimator>("presentationAnimator")
public extension NSViewController {
    @nonobjc
    public var presentionAnimator: NSViewControllerPresentationAnimator? {
        get { return __presentationAnimatorProp.get(self) }
        set { __presentationAnimatorProp.set(self, value: newValue) }
    }
}

fileprivate extension NSViewController {
    fileprivate var _rootAnimator: WindowTransitionAnimator? {
        get { return objc_getAssociatedObject(self, &NSViewController_anim_key) as? WindowTransitionAnimator }
        set { objc_setAssociatedObject(self, &NSViewController_anim_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
private var NSViewController_anim_key: UnsafeRawPointer? = nil
