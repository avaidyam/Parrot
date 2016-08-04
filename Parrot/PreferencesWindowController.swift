import AppKit

public class PreferencesViewController: NSTabViewController {
	
	lazy var originalSizes = [String: NSSize]()
	
	public override func viewWillAppear() {
		super.viewWillAppear()
		if let w = self.view.window, let t = w.toolbar {
			w.appearance = ParrotAppearance.current()
			w.titleVisibility = .hidden
			
			//w.standardWindowButton(.miniaturizeButton)?.isHidden = true
			//w.standardWindowButton(.zoomButton)?.isHidden = true
			
			// Fix titlebar blending.
			let r = w.standardWindowButton(.closeButton)?.superview as? NSVisualEffectView
			r?.material = .appearanceBased
			r?.blendingMode = .behindWindow
			
			// If the toolbar has an NSSegmentedControl "Tabs", tie it to our NSTabView.
			for i in t.items {
				if i.label == "Tabs" && i.view as? NSSegmentedControl != nil {
					let seg = i.view! as! NSSegmentedControl
					seg.action = #selector(NSTabView.takeSelectedTabViewItemFromSender(_:))
					seg.target = self.tabView
					seg.selectedSegment = 0
				}
			}
			
			let tabViewItem = self.tabView.tabViewItems[0]
			_willSelect(tabViewItem)
			_didSelect(tabViewItem)

			ParrotAppearance.registerAppearanceListener(observer: self) { appearance in
				w.appearance = appearance
				self.tabView.appearance = appearance
			}
			
			ParrotAppearance.registerVibrancyStyleListener(observer: self) { vibrancy in
				//TODO
			}
		}
	}
	
	public override func viewDidDisappear() {
		ParrotAppearance.unregisterAppearanceListener(observer: self)
		ParrotAppearance.unregisterVibrancyStyleListener(observer: self)
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
