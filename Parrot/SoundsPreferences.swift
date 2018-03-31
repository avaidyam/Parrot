import MochaUI

public extension Preferences.Controllers {
    public class Sounds: PreferencePaneViewController {
        
        public override func loadView() {
            self.view = NSView()
            self.view.widthAnchor == 400.0
            self.view.heightAnchor == 400.0
            self.title = "Sounds"
            self.image = NSImage(named: .inboxPref)
        }
    }
}
