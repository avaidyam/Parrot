import Cocoa

public class WindowTransitionAnimator: NSWindowController, NSWindowDelegate, NSViewControllerPresentationAnimator {
	
	public init(size: NSSize = NSSize(width: 480, height: 320)) {
		super.init(window: nil)
		let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
		let style = NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask
		let window = NSWindow(contentRect: rect, styleMask: style, backing: .Buffered, `defer`: false)
		self.window = window
		
		self.window?.delegate = self
		self.window?.center()
	}
	
	public required init(coder: NSCoder) {
		fatalError("not implemented")
	}
	
	deinit {
		self.window?.unbind(NSTitleBinding)
		self.window?.delegate = nil
		assert(self.contentViewController == nil, "Animator was not invoked!")
	}
	
	public func windowWillClose(notification: NSNotification) {
		self.contentViewController?.presentingViewController?.dismissViewController(self.contentViewController!)
	}
	
	public func displayViewController(viewController: NSViewController, fromViewController: NSViewController? = nil) {
		if let from = fromViewController {
			from.presentViewController(viewController, animator: self)
		} else {
			self.contentViewController = viewController
			self.window?.bind(NSTitleBinding, toObject: viewController, withKeyPath: "title", options: nil)
			self.window?.appearance = viewController.view.window?.appearance
			self.showWindow(nil)
		}
	}
	
	public func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
		self.contentViewController = viewController
		self.window?.bind(NSTitleBinding, toObject: viewController, withKeyPath: "title", options: nil)
		self.window?.appearance = fromViewController.view.window?.appearance
		self.showWindow(nil)
	}
	
	public func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
		let window = self.windowLoaded ? self.window : nil
		window?.orderOut(nil)
		window?.unbind(NSTitleBinding)
		self.contentViewController = nil
	}
}
