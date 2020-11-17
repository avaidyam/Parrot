import AppKit
<<<<<<< Updated upstream
import Mocha

/// Note: ideally, either present this controller as a window or wrap it within a
/// window controller.
public class PreferencesViewController: NSTabViewController {
    
    public override func loadView() {
        super.loadView()
        self.transitionOptions = [.allowUserInteraction, .crossfade]
        self.view.setContentHuggingPriority(.required, for: .vertical)
        self.view.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    public override func viewWillAppear() {
        
        // Reset the toolbar because if you migrate the VC to a new window, its toolbar
        // stays with the old one; this causes the toolbar to be rebuilt.
        self.tabStyle = .segmentedControlOnTop
        self.tabStyle = .toolbar
        self.view.window?.center()
    }
    
    public override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        DispatchQueue.main.async {
            guard   let window = self.view.window,
                    let tab = tabViewItem,
                    let view = tab.view
            else { return }
            
            // Get the fittingSize of the new tab.
            view.needsLayout = true
            view.layoutSubtreeIfNeeded()
            let size = view.fittingSize
            
            // Set the window frame and title.
            let normalized = self.normalizedFrame(for: window, from: size)
            window.animator().setFrame(normalized, display: true)
            window.title = tab.label
        }
    }
    
    public override func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let a = super.toolbarAllowedItemIdentifiers(toolbar)
        return [.flexibleSpace] + a// + [.flexibleSpace]
    }
    
    public override func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let a = super.toolbarDefaultItemIdentifiers(toolbar)
        return [.flexibleSpace] + a + [.flexibleSpace]
    }
    
    public override func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return super.toolbarSelectableItemIdentifiers(toolbar)
    }
    
    /// Returns a width-centered adjusted window frame.
    private func normalizedFrame(for window: NSWindow, from size: NSSize) -> NSRect {
        let rect = NSRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        let contentFrame = window.frameRect(forContentRect: rect)
        
=======

public class PreferencesViewController: NSTabViewController {
    private var _sizes = [String : NSSize]()
    
    public override func viewWillAppear() {
        self.view.window?.center()
    }
    
    public override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, willSelect: tabViewItem)
        self._sizes[tabViewItem!.label] = tabViewItem!.view!.frame.size
    }
    
    public override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        DispatchQueue.main.async {
            if let window = self.view.window {
                let size = (self._sizes[tabViewItem!.label])!
                window.setFrame(self.normalizedFrame(for: window, from: size),
                                display: false, animate: true)
            }
        }
    }
    
    public override func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        let a = super.toolbarAllowedItemIdentifiers(toolbar)
        return [NSToolbarFlexibleSpaceItemIdentifier] + a + [NSToolbarFlexibleSpaceItemIdentifier]
    }
    
    public override func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        let a = super.toolbarDefaultItemIdentifiers(toolbar)
        return [NSToolbarFlexibleSpaceItemIdentifier] + a + [NSToolbarFlexibleSpaceItemIdentifier]
    }
    
    public override func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return super.toolbarSelectableItemIdentifiers(toolbar).filter { $0 != NSToolbarFlexibleSpaceItemIdentifier }
    }
    
    private func normalizedFrame(for window: NSWindow, from size: NSSize) -> NSRect {
        let contentFrame = window.frameRect(forContentRect: NSMakeRect(0.0, 0.0, size.width, size.height))
>>>>>>> Stashed changes
        var frame = window.frame
        frame.origin.y = frame.origin.y + (frame.size.height - contentFrame.size.height)
        frame.size.height = contentFrame.size.height
        frame.size.width = contentFrame.size.width
        return frame
    }
<<<<<<< Updated upstream
    
    /// Use this to append preference panes.
    public func add<T: PreferencePaneViewController>(pane p: T) {
        _ = p.view // trigger loadView()
        
        let tab = NSTabViewItem(viewController: p)
        tab.image = p.image
        tab.initialFirstResponder = p.initialFirstResponder
        self.addTabViewItem(tab)
    }
    
    public override func cancelOperation(_ sender: Any?) {
        self.dismiss(nil)
    }
}

/// Must subclass this:
///
open class PreferencePaneViewController: NSViewController {
    
    ///
    open var image: NSImage? = nil
    
    ///
    open weak var initialFirstResponder: NSView? = nil
=======
>>>>>>> Stashed changes
}
