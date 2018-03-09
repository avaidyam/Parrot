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
// Also use ToolbarContainer responder chain searching to lay out the toolbar.
//

/*
 let s = SplitWindowController()
 s.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: self.conversationsController))
 s.addSplitViewItem(NSSplitViewItem(viewController: self.directoryController))
 s.presentAsWindow()
*/
public class SplitWindowController: NSSplitViewController, WindowPresentable {
    
    //private var toolbarContainer = ToolbarContainer()
    
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .miniaturizable, .unifiedTitleAndToolbar, .fullSizeContentView]
        window.appearance = InterfaceStyle.current.appearance()
        if let vev = window.titlebar.view as? NSVisualEffectView {
            vev.material = .appearanceBased
            vev.state = .active
            vev.blendingMode = .withinWindow
        }
        window.titleVisibility = .hidden
        window.installToolbar(self)
    }
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        guard self.view.window != nil else { return }
        PopWindowAnimator.show(self.view.window!)
    }
    
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        guard self.view.window != nil else { return true }
        ZoomWindowAnimator.hide(self.view.window!)
        return false
    }
    
    public override func addChildViewController(_ childViewController: NSViewController) {
        super.addChildViewController(childViewController)
        self.toolbarContainer = self.makeToolbarContainer() // FIXME
        self.view.window?.toolbar?.container = self.toolbarContainer // FIXME
    }
}
