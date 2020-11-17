import Cocoa
import Mocha
import MochaUI

/* TODO: In the future, add NSViewController docking (attach/detach) support. */

// Idea:
//
// Each window's contentViewController will be a SplitWindowController (SWC).
// the SWC will have one master pane (Conversations), and multiple detail panes.
// A detach button will pop a detail pane out into its own window (with an SWC).
// An attach button will pull in a detail pane from one SWC to another.
//
// If no detail panes are left, optionally close the window (master pane can decide).
// The master pane cannot be removed. (I guess?)
// Also use ToolbarItemContainer responder chain searching to lay out the toolbar.
//

/*
 let s = SplitWindowController()
 s.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: self.conversationsController))
 s.addSplitViewItem(NSSplitViewItem(viewController: self.directoryController))
 s.presentAsWindow()
*/
public class SplitWindowController: NSSplitViewController, WindowPresentable {
    
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .unifiedTitleAndToolbar, .fullSizeContentView]
        window.appearance = ParrotAppearance.interfaceStyle().appearance()
        window.enableRealTitlebarVibrancy(.withinWindow)
        window.titleVisibility = .hidden
        _ = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
    }
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        PopWindowAnimator.show(self.view.window!)
    }
    
    public func windowShouldClose(_ sender: Any) -> Bool {
        guard self.view.window != nil else { return true }
        ZoomWindowAnimator.hide(self.view.window!)
        return false
    }
}
