import MochaUI

public extension Preferences.Controllers {
    public class Shortcuts: PreferencePaneViewController {
        
        public override func loadView() {
            self.view = NSView()
            self.view.widthAnchor == 400.0
            self.view.heightAnchor == 400.0
            self.title = "Shortcuts"
            self.image = NSImage(named: .colorPanel)
        }
    }
}
