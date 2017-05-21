import Foundation
import AppKit
import Mocha

/* TODO: Support utility AND modal AND normal windows? */ // NSApp.runModalForWindow(), NSApp.stopModal(), [.utilityWindow]

/// Supported objects can allow customization of their behavior within windows using this protocol.
public protocol WindowPresentable {

    /// As the NSWindow is being prepared, a WindowPresentable may customize it as well.
    func prepare(window: NSWindow)
}

public extension NSViewController {
    
    public func presentViewControllerAsWindow(_ viewController: NSViewController) {
        self.presentViewController(viewController, animator: WindowTransitionAnimator())
    }
    
    // For root controllers. The window delegate is set to the VC if it conforms to NSWindowDelegate.
    public func presentAsWindow() {
        WindowTransitionAnimator().display(viewController: self)
    }
    
    // For root controllers. Use only if presentAsWindow() was used.
    public func dismissFromWindow() {
        self._rootAnimator?.undisplay()
    }
    
    // drawer?
    
    // panel?
    
}

public class WindowTransitionAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    private var window: NSWindow?
    deinit {
        assert(self.window == nil, "WindowTransitionAnimator.animateDismissal(...) was not invoked!")
    }
    
    // for ROOT NSViewController only
    public func display(viewController: NSViewController) {
        viewController.view.layoutSubtreeIfNeeded()
        let p = viewController.view.fittingSize
        
        self.window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: p.width, height: p.height),
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
    
    public func undisplay() {
        NotificationCenter.default.removeObserver(self)
        self.window?.orderOut(nil)
        self.window?.unbind(NSTitleBinding)
        
        self.window = nil
        self.window?.contentViewController?._rootAnimator = nil
    }
    
    public func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        assert(self.window != nil, "WindowTransitionAnimator.animatePresentation(...) was invoked already!")
        self.display(viewController: viewController)
    }
    
    public func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        assert(self.window == nil, "WindowTransitionAnimator.animateDismissal(...) invoked before WindowTransitionAnimator.animatePresentation(...)!")
        self.undisplay()
    }
    
    public func windowWillClose(_ notification: Notification) {
        guard let c = self.window?.contentViewController else { return }
        if let p = c.presenting {
            p.dismiss(c)
        } else {
            self.undisplay()
        }
    }
}

fileprivate extension NSViewController {
    fileprivate var _rootAnimator: WindowTransitionAnimator? {
        get { return objc_getAssociatedObject(self, &NSViewController_anim_key) as? WindowTransitionAnimator }
        set { objc_setAssociatedObject(self, &NSViewController_anim_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
private var NSViewController_anim_key: UnsafeRawPointer? = nil
