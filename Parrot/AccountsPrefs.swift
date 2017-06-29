import Foundation
import AppKit
import MochaUI

public extension Preferences.Controllers {
    public class Accounts: NSViewController {
        public var image: NSImage? = NSImage(named: .userGroup)
        public override var title: String? {
            set{} get { return "Accounts" }
        }
        
        public override func loadView() {
            self.view = NSView()
            self.view.width == 400.0
            self.view.height == 400.0
        }
    }
}
