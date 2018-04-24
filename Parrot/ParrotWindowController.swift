import MochaUI

/* TODO: In the future, add NSViewController docking (attach/detach) support. */
/* TODO: Support sidebar mode later. */

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
 let s = ParrotWindowController()
 s.addViewController(self.viewController)
 s.showWindow(nil)
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
    private var visualSubscriptions: [NSKeyValueObservation] = []
    
    private lazy var effectView: NSVisualEffectView = {
        let v = NSVisualEffectView().modernize(wantsLayer: true)
        v.material = .appearanceBased
        v.blendingMode = .behindWindow
        v.state = .active
        return v
    }()
    
    public override func loadWindow() {
        self.window = NSWindow(contentViewController: self.container)
        self.window!.delegate = self
        self.window!.contentView = self.effectView
        self.effectView.add(subviews: self.container.view.modernize(wantsLayer: true)) {
            self.effectView.edgeAnchors == self.window!.frameView.edgeAnchors
            self.container.view.edgeAnchors == self.effectView.edgeAnchors
        }
        
        self.window!.styleMask.formUnion([.miniaturizable, .unifiedTitleAndToolbar, .fullSizeContentView])
        self.window!.appearance = InterfaceStyle.current.appearance()
        if let vev = self.window!.titlebar.view as? NSVisualEffectView {
            vev.material = .appearanceBased
            vev.state = .active
            vev.blendingMode = .withinWindow
        }
        self.window!.titleVisibility = .hidden
        self.window!.installToolbar(self.container)
        
        //window.addTitlebarAccessoryViewController(LargeTypeTitleController(title: self.title))
        
        self.visualSubscriptions = [
            Settings.observe(\.effectiveInterfaceStyle, options: [.initial, .new]) { _, change in
                self.window?.crossfade()
                self.window?.appearance = InterfaceStyle.current.appearance()
            },
            Settings.observe(\.vibrancyStyle, options: [.initial, .new]) { _, change in
                self.effectView.state = VibrancyStyle.current.state()
            },
        ]
    }
    
    public override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        if self.window == nil { self.loadWindow() } // ugh TODO FIXME nonsense
        PopWindowAnimator.show(self.window!)
    }
    
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        if self.window == nil { self.loadWindow() } // ugh TODO FIXME nonsense
        ZoomWindowAnimator.hide(self.window!)
        self.visualSubscriptions = []
        return false
    }
    
    /// Re-synchronizes the conversation name and identifier with the window.
    /// Center by default, but load a saved frame if available, and autosave.
    private func syncAutosaveTitle() {
        self.window?.center()
        self.window?.setFrameUsingName(NSWindow.FrameAutosaveName(rawValue: "Conversations"))
        self.window?.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: "Conversations"))
    }
    
    
    //
    // NSSplitViewController pass-through:
    //
    
    
    open var viewControllers: [NSViewController] {
        get { return self.container.splitViewItems.map { $0.viewController } }
        set { self.container.splitViewItems = newValue.map(self.wrap(_:)) }
    }
    
    open func addViewController(_ viewController: NSViewController) {
        self.container.addSplitViewItem(self.wrap(viewController))
    }
    
    open func insertViewController(_ viewController: NSViewController, at index: Int) {
        self.container.insertSplitViewItem(self.wrap(viewController), at: index)
    }
    
    open func removeViewController(_ viewController: NSViewController) {
        guard let splitViewItem = self.container.splitViewItem(for: viewController) else { return }
        self.container.removeSplitViewItem(splitViewItem)
    }
    
    private func wrap(_ viewController: NSViewController) -> NSSplitViewItem {
        let splitViewItem = NSSplitViewItem(viewController: viewController)
        splitViewItem.isSpringLoaded = true
        splitViewItem.collapseBehavior = .preferResizingSiblingsWithFixedSplitView
        return splitViewItem
    }
}
