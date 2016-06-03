import Cocoa

public class WindowTransitionAnimator: NSWindowController, NSWindowDelegate, NSViewControllerPresentationAnimator {
	
	public init(size: NSSize = NSSize(width: 480, height: 320)) {
		super.init(window: nil)
		let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
		let style = NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask
		let window = NSWindow(contentRect: rect, styleMask: style, backing: .buffered, defer: false)
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
	
	public func windowWillClose(_ notification: NSNotification) {
		self.contentViewController?.presenting?.dismiss(self.contentViewController!)
	}
	
	public func displayViewController(viewController: NSViewController, fromViewController: NSViewController? = nil) {
		if let from = fromViewController {
			from.present(viewController, animator: self)
		} else {
			self.contentViewController = viewController
			self.window?.bind(NSTitleBinding, to: viewController, withKeyPath: "title", options: nil)
			self.window?.appearance = viewController.view.window?.appearance
			self.showWindow(nil)
		}
	}
	
	public func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
		self.contentViewController = viewController
		self.window?.bind(NSTitleBinding, to: viewController, withKeyPath: "title", options: nil)
		self.window?.appearance = fromViewController.view.window?.appearance
		self.showWindow(nil)
	}
	
	public func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
		let window = self.isWindowLoaded ? self.window : nil
		window?.orderOut(nil)
		window?.unbind(NSTitleBinding)
		self.contentViewController = nil
	}
}
