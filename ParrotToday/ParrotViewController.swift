import Cocoa
import NotificationCenter

class ParrotViewController: NSViewController {
	@IBOutlet internal var editView: NSView?
	
	// We're jumpstarted into the setup function here.
	func setup() {
		print("Initialization stuff goes here.")
	}
}

// All the "housekeeping" parts of the view controller are moved here.
extension ParrotViewController: NCWidgetProviding {
	
	// Sets up the content size and adds the edit view to the controller.
	override func loadView() {
		super.loadView()
		self.preferredContentSize = CGSizeMake(320, 480)
		if let editView = self.editView {
			var f = self.view.bounds
			f.origin.y = f.size.height
			editView.frame = f
			self.view.addSubview(editView)
		}
		self.setup()
	}
	
	override var nibName: String? {
		return self.className
	}
	
	func widgetMarginInsetsForProposedMarginInsets(defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
		return NSEdgeInsetsZero
	}
	
	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
		completionHandler(.NewData)
	}
	
	var widgetAllowsEditing: Bool {
		return true
	}
	
	// Handles animating the edit view in and out with the edit button.
	func widgetDidBeginEditing() {
		var f = self.view.bounds
		f.origin.y = 0
		self.editView?.animator().frame = f
	}
	func widgetDidEndEditing() {
		var f = self.view.bounds
		f.origin.y = f.size.height
		self.editView?.animator().frame = f
	}
}
