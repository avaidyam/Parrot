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

// support for all the "documents" in Parrot
public final class ParrotWindowController: NSWindowController, NSWindowDelegate {
    
    // FIXME: not required, really...
    private class NSToolbarSplitViewController: NSSplitViewController {
        public override func addChildViewController(_ childViewController: NSViewController) {
            super.addChildViewController(childViewController)
            
            self.toolbarContainer = self.makeToolbarContainer() // FIXME
            self.view.window?.toolbar?.container = self.toolbarContainer // FIXME
        }
    }
    
    private var container = NSToolbarSplitViewController()
    
    public override func loadWindow() {
        self.window = NSWindow(contentViewController: self.container)
        self.window!.delegate = self
        self.contentViewController = self.container
        
        self.window!.styleMask.formUnion([.miniaturizable, .unifiedTitleAndToolbar, .fullSizeContentView])
        self.window!.appearance = InterfaceStyle.current.appearance()
        if let vev = self.window!.titlebar.view as? NSVisualEffectView {
            vev.material = .appearanceBased
            vev.state = .active
            vev.blendingMode = .withinWindow
        }
        self.window!.titleVisibility = .hidden
        self.window!.installToolbar(self.container)
    }
    
    public override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        if self.window == nil { self.loadWindow() } // ugh TODO FIXME nonsense
        PopWindowAnimator.show(self.window!)
    }
    
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        if self.window == nil { self.loadWindow() } // ugh TODO FIXME nonsense
        ZoomWindowAnimator.hide(self.window!)
        return false
    }
    
    
    //
    // NSSplitViewController pass-through:
    //
    
    
    open var splitViewItems: [NSSplitViewItem] {
        get { return self.container.splitViewItems }
        set { self.container.splitViewItems = newValue }
    }
    
    open func addSplitViewItem(_ splitViewItem: NSSplitViewItem) {
        self.container.addSplitViewItem(splitViewItem)
    }
    
    open func insertSplitViewItem(_ splitViewItem: NSSplitViewItem, at index: Int) {
        self.container.insertSplitViewItem(splitViewItem, at: index)
    }
    
    open func removeSplitViewItem(_ splitViewItem: NSSplitViewItem) {
        self.container.removeSplitViewItem(splitViewItem)
    }
    
    open func splitViewItem(for viewController: NSViewController) -> NSSplitViewItem? {
        return self.container.splitViewItem(for: viewController)
    }
}
