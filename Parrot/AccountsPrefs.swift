import MochaUI

public extension Preferences.Controllers {
    public class Accounts: PreferencePaneViewController {

        public override func loadView() {
            self.view = NSView()
            self.view.widthAnchor == 400.0
            self.view.heightAnchor == 400.0
            self.title = "Accounts"
            self.image = NSImage(named: .userGroup)
        }
    }
}
