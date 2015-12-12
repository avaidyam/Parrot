import Cocoa

/**
Styles windows as panels that are centered on-screen and cannot be moved.

The appearance is set to VibrantDark, and only the close button is visible.
*/
class ParrotPanelController : NSWindowController {
	override func windowDidLoad() {
		super.windowDidLoad()
		self.window?.movable = false
		self.window?.titlebarAppearsTransparent = true
		self.window?.standardWindowButton(.ZoomButton)?.hidden = true
		self.window?.standardWindowButton(.MiniaturizeButton)?.hidden = true
		self.window?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
	}
}
