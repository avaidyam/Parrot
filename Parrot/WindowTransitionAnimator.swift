import Cocoa

public class WindowTransitionAnimator: NSWindowController, NSWindowDelegate, NSViewControllerPresentationAnimator {
	
	public init(size: NSSize = NSSize(width: 480, height: 320)) {
		super.init(window: nil)
		let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
		let style: NSWindowStyleMask = [.titled, .closable, .resizable]
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
	
	public func windowWillClose(_ notification: Notification) {
		self.contentViewController?.presenting?.dismiss(self.contentViewController!)
	}
	
	public func displayViewController(_ viewController: NSViewController, fromViewController: NSViewController? = nil) {
		if let from = fromViewController {
			from.presentViewController(viewController, animator: self)
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

public class AntiScrollView: NSScrollView {
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		hideScrollers()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		hideScrollers()
	}
	private func hideScrollers() {
		hasHorizontalScroller = false
		hasVerticalScroller = false
	}
	public override func scrollWheel(_ theEvent: NSEvent) {
		self.nextResponder?.scrollWheel(theEvent)
	}
}

public class PreferencesViewController: NSTabViewController {
	
	lazy var originalSizes = [String: NSSize]()
	
	public override func viewWillAppear() {
		super.viewWillAppear()
		if let w = self.view.window, let t = w.toolbar {
			w.titleVisibility = .hidden
			t.displayMode = .iconOnly
			t.insertItem(withItemIdentifier: NSToolbarFlexibleSpaceItemIdentifier, at: 0)
			t.insertItem(withItemIdentifier: NSToolbarFlexibleSpaceItemIdentifier, at: t.items.count)
			
			let tabViewItem = self.tabView.tabViewItems[0]
			_willSelect(tabViewItem)
			_didSelect(tabViewItem)
		}
	}
	
	public override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
		super.tabView(tabView, willSelect: tabViewItem)
		//_ = tabView.selectedTabViewItem
		_willSelect(tabViewItem!)
	}
	
	public override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
		super.tabView(tabView, didSelect: tabViewItem)
		_didSelect(tabViewItem!)
	}
	
	private func _willSelect(_ tabViewItem: NSTabViewItem) {
		let originalSize = self.originalSizes[tabViewItem.label]
		if (originalSize == nil) {
			self.originalSizes[tabViewItem.label] = (tabViewItem.view?.frame.size)!
		}
	}
	
	private func _didSelect(_ tabViewItem: NSTabViewItem) {
		guard let window = self.view.window else { return }
		
		window.title = tabViewItem.label
		let size = (self.originalSizes[tabViewItem.label])!
		let contentFrame = window.frameRect(forContentRect: NSMakeRect(0.0, 0.0, size.width, size.height))
		var frame = window.frame
		frame.origin.y = frame.origin.y + (frame.size.height - contentFrame.size.height)
		frame.size.height = contentFrame.size.height
		frame.size.width = contentFrame.size.width
		window.setFrame(frame, display: false, animate: true)
	}
}

public class DetailSegue: NSStoryboardSegue {
	public override func perform() {
		guard	let source = self.sourceController as? NSViewController,
				let destination = self.destinationController as? NSViewController,
				let splitView = source.parent as? NSSplitViewController
		else { return }
		
		let splitItem = NSSplitViewItem(viewController: destination)
		
		// Remove the last SplitViewItem before adding the next one.
		if splitView.childViewControllers.count > 1 {
			splitView.removeSplitViewItem(splitView.splitViewItems.last!)
		}
		splitView.addSplitViewItem(splitItem)
	}
}

public func darkModeActive() -> Bool {
	let style = UserDefaults.standard().persistentDomain(forName: UserDefaults.globalDomain)?["AppleInterfaceStyle"]
	return (style != nil) && (style as? NSString != nil) && (style!.caseInsensitiveCompare("dark") == .orderedSame)
}
