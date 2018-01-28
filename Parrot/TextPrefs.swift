import MochaUI

public extension Preferences.Controllers {
    public class Text: NSViewController, PreferencePane {
        public var image: NSImage? = NSImage(named: .colorPanel)
        public override var title: String? {
            set{} get { return "Text" }
        }
        
        public override func loadView() {
            self.view = NSView()
            self.view.widthAnchor == 400.0
            self.view.heightAnchor == 400.0
        }
    }
}
