import Foundation
import AppKit
import Mocha

/*
 func show(_ vc: UIViewController, sender: Any?)
 
 You use this method to decouple the need to display a view controller from the process of actually presenting that view controller onscreen. Using this method, a view controller does not need to know whether it is embedded inside a navigation controller or split-view controller. It calls the same method for both. The UISplitViewController and UINavigationController classes override this method and handle the presentation according to their design. For example, a navigation controller overrides this method and uses it to push vc onto its navigation stack.
 The default implementation of this method calls the targetViewController(forAction:sender:) method to locate an object in the view controller hierarchy that overrides this method. It then calls the method on that target object, which displays the view controller in an appropriate way. If the targetViewController(forAction:sender:) method returns nil, this method uses the window’s root view controller to present vc modally.
 You can override this method in custom view controllers to display vc yourself. Use this method to display vc in a primary context. For example, a container view controller might use this method to replace its primary child. Your implementation should adapt its behavior for both regular and compact environments.
 
 --
 
 func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController?
 
 This method returns the current view controller if that view controller overrides the method indicated by the action parameter. If the current view controller does not override that method, UIKit walks up the view hierarchy and returns the first view controller that does override it. If no view controller handles the action, this method returns nil.
 A view controller can selectively respond to an action by returning an appropriate value from its canPerformAction(_:withSender:) method.
 */

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
        if includingSelf /*&& (self is type)*/ { //fixme
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
    
    /// Accessor for the CALayer backing the NSView.
    public var layer: CALayer {
        if self.view.layer == nil && self.view.wantsLayer == false {
            self.view.wantsLayer = true
        }
        return self.view.layer!
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

public extension NSViewController {
    private static var presentationAnimatorProp = KeyValueProperty<NSViewController, NSViewControllerPresentationAnimator>("presentationAnimator")
    private static var rootAnimatorProp = AssociatedProperty<NSViewController, WindowTransitionAnimator>(.strong)
    
    @nonobjc public fileprivate(set) var presentationAnimator: NSViewControllerPresentationAnimator? {
        get { return NSViewController.presentationAnimatorProp[self] }
        set { NSViewController.presentationAnimatorProp[self] = newValue }
    }
    
    @nonobjc fileprivate var _rootAnimator: WindowTransitionAnimator? {
        get { return NSViewController.rootAnimatorProp[self] }
        set { NSViewController.rootAnimatorProp[self] = newValue }
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
                                               name: NSWindow.willCloseNotification, object: self.window)
        
        self.window?.contentViewController = viewController
        self.window?.bind(.title, to: viewController, withKeyPath: "title", options: nil)
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
        self.window?.unbind(.title)
        
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
    
    @objc public func windowWillClose(_ notification: Notification) {
        guard let c = self.window?.contentViewController else { return }
        if let p = c.presenting {
            p.dismiss(c)
        } else {
            self.undisplay(viewController: self.window!.contentViewController!)
        }
    }
}
