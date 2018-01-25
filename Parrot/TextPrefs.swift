import Foundation
import AppKit
import MochaUI

public extension Preferences.Controllers {
    public class Text: NSViewController, PreferencePane {
        public var image: NSImage? = NSImage(named: .colorPanel)
        public override var title: String? {
            set{} get { return "Text" }
        }
        
        public override func loadView() {
            self.view = NSView()
            self.view.width == 400.0
            self.view.height == 400.0
        }
    }
}
