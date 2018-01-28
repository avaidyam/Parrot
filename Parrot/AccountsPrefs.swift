import MochaUI

public extension Preferences.Controllers {
    public class Accounts: NSViewController, PreferencePane {
        public var image: NSImage? = NSImage(named: .userGroup)
        public override var title: String? {
            set{} get { return "Accounts" }
        }
        
        public override func loadView() {
            self.view = NSView()
            self.view.widthAnchor == 400.0
            self.view.heightAnchor == 400.0
        }
    }
}
