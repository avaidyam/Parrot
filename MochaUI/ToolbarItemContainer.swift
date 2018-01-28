import AppKit
import Mocha

/* TODO: Support item types: allowed, required, default, customized(user). */
/* TODO: Support isVisible (per toolbar, per item), and otherItemsProxy(nesting). */

public extension NSWindow {
    
    /// Simplifies the installation of a "modern" toolbar.
    @discardableResult
    public func installToolbar() -> ToolbarItemContainer {
        let t = NSToolbar(identifier: NSToolbar.Identifier(rawValue: UUID().description))
        let h = ToolbarItemContainer()
        h.toolbar = t
        t.delegate = h
        
        t.displayMode = .iconOnly
        t.sizeMode = .regular
        t.allowsUserCustomization = false
        t.allowsExtensionItems = false
        t.autosavesConfiguration = false
        
        self.toolbar = t
        return h
    }
}

/// The ToolbarItemContainer simplifies the process of working with a toolbar.
/// Set the item order using identifiers and provide the items array.
/// Note: some items like flexible space, etc. don't need to be provided.
public class ToolbarItemContainer: NSObject, NSToolbarDelegate {
    
    /// It's important to have the toolbar retain ownership here.
    fileprivate weak var toolbar: NSToolbar? = nil {
        didSet {
            oldValue?._container = nil
            self.toolbar?._container = self
        }
    }
    deinit {
        self.toolbar?._container = nil
    }
    
    public var templateItems = Set<NSToolbarItem>()
    public var itemOrder: [NSToolbarItem.Identifier] = [] {
        willSet {
            guard self.toolbar != nil else { return }
            for (i, _) in self.toolbar!.items.enumerated().reversed() {
                self.toolbar?.removeItem(at: i)
            }
        }
        didSet {
            guard self.toolbar != nil else { return }
            for (i, item) in self.itemOrder.enumerated() {
                self.toolbar?.insertItem(withItemIdentifier: item, at: i)
            }
        }
    }
    
    public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let t = self.templateItems.filter { $0.itemIdentifier == itemIdentifier }.first ?? NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: ""))
        return t
    }
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.itemOrder
    }
    public func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.itemOrder
    }
}

public extension NSToolbarItem {
    
    /// Forces the item to become centered and permanently topmost on the toolbar.
    /// Note: typically not needed if using flexible spaces to center an item.
    public var centered: Bool {
        get { return self.value(forKey: "wantsToBeCentered") as? Bool ?? false }
        set { self.setValue(newValue, forKey: "wantsToBeCentered") }
    }
    
    /// Set the toolbar item to track a split view divider with its divider index.
    /// Note: the index is NOT the subview index, but the DIVIDER index.
    /// Note: does nothing if not a flexible space item.
    public var trackingSplitView: (NSSplitView?, Int) {
        get {
            guard self.className == "NSToolbarFlexibleSpaceItem" else { return (nil, -1) }
            return (self._trackedSplitView, self._trackedSplitViewDividerIndex)
        }
        set {
            guard self.className == "NSToolbarFlexibleSpaceItem" else { return }
            self._trackedSplitView = newValue.0;
            self._trackedSplitViewDividerIndex = newValue.1
        }
    }
    
    //
    //
    //
    
    private var _trackedSplitViewDividerIndex: Int {
        get { return self.value(forKey: "trackedSplitViewDividerIndex") as? Int ?? -1 }
        set { self.setValue(newValue, forKey: "trackedSplitViewDividerIndex") }
    }
    
    private var _trackedSplitView: NSSplitView? {
        get { return self.value(forKey: "trackedSplitView") as? NSSplitView }
        set { self.setValue(newValue, forKey: "trackedSplitView") }
    }
}

fileprivate extension NSToolbar {
    private static var containerProp = AssociatedProperty<NSToolbar, ToolbarItemContainer>(.strong)
    fileprivate var _container: ToolbarItemContainer? {
        get { return NSToolbar.containerProp[self] }
        set { NSToolbar.containerProp[self] = newValue }
    }
}

public extension NSToolbarItem.Identifier {
    public static let none = NSToolbarItem.Identifier(rawValue: "")
}

//
//
//

// The below is an attempt at making NSToolbar behave similarly to NSTouchBar.
// That is, a window will ask its contentViewController to provide a set of toolbar
// items; if none are given or it doesn't support this method, the window, its
// window controller, or its window delegate will be consulted.
//
// TODO: Support nested "toolbar containers" (otherItemsProxy).
// TODO: Support optional item/bar visibility (per toolbar and item)
// TODO: Support allowed, required, default, and user item modes.
// TODO: Support NSToolbarItem types/classes (like NS*TouchBarItem).

/*
public protocol ToolbarContainerProvider {
    var toolbarContainer: ToolbarItemContainer { get }
    // note: use lazy if needed
}

class CustomWindow: NSWindow, ToolbarContainerProvider {
    lazy var toolbarContainer: ToolbarItemContainer = {
        let h = ToolbarItemContainer()
        
        let i = NSToolbarItem(itemIdentifier: "NSToolbarItemWindowTitleIdentifier")
        i.visibilityPriority = NSToolbarItemVisibilityPriorityHigh
        let t = NSTextField(labelWithString: self.title)
        t.textColor = NSColor.secondaryLabelColor
        i.view = t
        
        h.templateItems.insert(i)
        h.itemOrder = [NSToolbarFlexibleSpaceItemIdentifier, "NSToolbarItemWindowTitleIdentifier", NSToolbarFlexibleSpaceItemIdentifier]
        return h
    }()
}

public extension NSWindow {
    public func coalescedToolbarContainer() -> ToolbarItemContainer? {
        if let c = self.contentViewController as? ToolbarContainerProvider {
            return c.toolbarContainer
        }
        return (self as? ToolbarContainerProvider)?.toolbarContainer
    }
}

extension NSSplitViewController: ToolbarContainerProvider {
    public var toolbarContainer: ToolbarItemContainer {
        let t = ToolbarItemContainer()
        let containers = self.splitViewItems
            .map { $0.viewController }
            .flatMap { $0 as? ToolbarContainerProvider }
            .map { $0.toolbarContainer }
        containers.enumerated().forEach {
            for item in $1.templateItems {
                t.templateItems.insert(item)
            }
            for order in $1.itemOrder {
                t.itemOrder.append(order)
            }
            if $0 != (containers.count - 1) {
                t.itemOrder.append(NSToolbarFlexibleSpaceItemIdentifier)
            }
        }
        return t
    }
}

extension NSTabViewController: ToolbarContainerProvider {
    public var toolbarContainer: ToolbarItemContainer {
        let sub = self.tabViewItems[self.selectedTabViewItemIndex] as? ToolbarContainerProvider
        return sub?.toolbarContainer ?? ToolbarItemContainer()
    }
}
*/
