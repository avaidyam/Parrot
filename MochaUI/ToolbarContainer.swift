import AppKit
import Mocha

/* TODO: Support item types: allowed, required, default, customized(user). */
/* TODO: Support isVisible (per toolbar, per item), and otherItemsProxy(nesting). */
/* TODO: NSToolbars with the same UUID() can synchronize elements! */

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
 * things not needed in toolbaritemcontainer:
     - popover items?
     - principal item? (but centering!)
     - color popover -> use the panel as popover
     - sharing -> same?
     - nsscrubber?
     - visibility priority -> use stackview!
 * fixedSpaceSmall, fixedSpaceLarge, flexibleSpace
 * otherItemsProxy: nest touch bars up the responder chain.
 * group bar items by using an instance of the NSStackView loses system support for spacing
 * NSGroupTouchBarItem manages inter-item spacing
 * supports user customization for the individual items
*/

public extension NSWindow {
    
    /// Simplifies the installation of a "modern" toolbar.
    public func installToolbar(_ provider: ToolbarContainerProvider) {
        let t = NSToolbar(identifier: NSToolbar.Identifier(rawValue: UUID().description))
        t.displayMode = .iconOnly
        t.sizeMode = .regular
        t.allowsUserCustomization = false
        t.allowsExtensionItems = false
        t.autosavesConfiguration = false
        t.showsBaselineSeparator = false
        
        t.container = provider.toolbarContainer // should be self.contentViewController
        self.toolbar = t
    }
}

/// The ToolbarContainer simplifies the process of working with a toolbar.
/// Set the item order using identifiers and provide the items array.
/// Note: some items like flexible space, etc. don't need to be provided.
public class ToolbarContainer: NSObject, NSToolbarDelegate {
    
    /// It's important to have the toolbar retain ownership here.
    fileprivate weak var toolbar: NSToolbar? = nil {
        didSet {
            
            // dissociate ourselves from oldValue and remove our items:
            guard oldValue != self.toolbar else { return }
            oldValue?.container = nil
            for (i, _) in oldValue?.items.enumerated().reversed() ?? [] {
                self.toolbar?.removeItem(at: i)
            }
            guard self.toolbar != nil else { return }
            
            // remove all newValue items and add our items:
            for (i, _) in self.toolbar!.items.enumerated().reversed() {
                self.toolbar!.removeItem(at: i)
            }
            for (_, item) in self.itemOrder.enumerated() {
                self.toolbar!.insertItem(withItemIdentifier: item, at: self.toolbar!.items.count)
            }
        }
    }
    deinit {
        //self.toolbar?.container = nil // weak
    }
    
    public weak var delegate: ToolbarContainerDelegate? = nil
    
    public var templateItems = Set<NSToolbarItem>()
    public var itemOrder: [NSToolbarItem.Identifier] = [] {
        willSet {
            guard self.toolbar != nil else { return }
            for (i, _) in self.toolbar!.items.enumerated().reversed() {
                self.toolbar!.removeItem(at: i)
            }
        }
        didSet {
            guard self.toolbar != nil else { return }
            for (_, item) in self.itemOrder.enumerated() {
                self.toolbar!.insertItem(withItemIdentifier: item, at: self.toolbar!.items.count)
            }
        }
    }
    
    public func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var item: NSToolbarItem? = nil
        if let d = self.delegate {
            item = d.toolbarContainer(self, makeItemForIdentifier: itemIdentifier)
        } else {
            item = self.templateItems.filter { $0.itemIdentifier == itemIdentifier }.first
        }
        item?.autovalidates = false
        return item
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

@objc public protocol ToolbarContainerDelegate: NSObjectProtocol {
    
    /// When constructing the items array, this delegate method will be invoked to construct an NSToolbarItem if that item cannot be found in the `templateItems` set.
    func toolbarContainer(_ toolbarContainer: ToolbarContainer, makeItemForIdentifier identifier: NSToolbarItem.Identifier) -> NSToolbarItem?
}
@objc public protocol ToolbarContainerProvider: NSObjectProtocol {
    
    /// The basic method for providing an ToolbarContainer. AppKit will key value observe this property, if for some reason you wish to replace a live ToolbarContainer wholesale.
    /// Note that many subclasses of NSResponder already implement this method and conform to this protocol.
    var toolbarContainer: ToolbarContainer? { get }
}

extension NSViewController: ToolbarContainerProvider {
    
    /// The ToolbarContainer object associated with this view controller. If no ToolbarContainer is explicitly set, NSViewController will send -makeTouchBar to itself to create the default ToolbarContainer for this view controller.
    @objc open dynamic var toolbarContainer: ToolbarContainer? {
        get {
            if self._container == nil, !self._containerCreated {
                self._container = self.makeToolbarContainer()
            }
            return self._container
        }
        set {
            self._container = newValue
            self._containerCreated = false
        }
    }
    
    /// Subclasses should over-ride this method to create and configure the default ToolbarContainer for this view controller.
    @objc open dynamic func makeToolbarContainer() -> ToolbarContainer? {
        return nil
    }
    
    //
    //
    //
    
    fileprivate var _container: ToolbarContainer? {
        get { return NSViewController.containerProp[self] }
        set { NSViewController.containerProp[self] = newValue }
    }
    fileprivate var _containerCreated: Bool {
        get { return NSViewController.containerCreatedProp[self, default: false] }
        set { NSViewController.containerCreatedProp[self] = newValue }
    }
    private static var containerProp = AssociatedProperty<NSViewController, ToolbarContainer>(.strong)
    private static var containerCreatedProp = AssociatedProperty<NSViewController, Bool>(.strong)
}

// TODO: NS*ViewControllers should be delegates that forward items OR implement toolbarContainer.get

extension NSSplitViewController { // TODO: Make this a ToolbarContainerDelegate
    open override func makeToolbarContainer() -> ToolbarContainer? {
        let t = ToolbarContainer()
        let containers = self.splitViewItems.map { $0.viewController.toolbarContainer }
        containers.enumerated().forEach {
            t.templateItems.formUnion($1?.templateItems ?? [])
            t.itemOrder += $1?.itemOrder ?? []
            
            // insert spacing if we're not the last splitViewItem AND we contain toolbar items
            if ($0 != (containers.count - 1)) {
                let id = NSToolbarItem.Identifier(rawValue: "splitViewController_flexibleSpace_\($0)")
                let item = NSToolbarItem.flexibleSpace(with: id)
                item.trackingSplitView = (self.splitView, $0)
                
                t.templateItems.insert(item)
                t.itemOrder.append(id)
            }
        }
        return t
    }
}

extension NSTabViewController {
    open override func makeToolbarContainer() -> ToolbarContainer? {
        return self.tabViewItems[self.selectedTabViewItemIndex].viewController?.toolbarContainer
    }
}

public extension NSToolbarItem {
    private static var setItemIdentifierKey = SelectorKey<NSToolbarItem, String, Void, Void>("_setItemIdentifier:")
    
    /// Forces the item to become centered and permanently topmost on the toolbar.
    ///
    /// Note: typically not needed if using flexible spaces to center an item.
    public var centered: Bool {
        get { return self.value(forKey: "wantsToBeCentered") as? Bool ?? false }
        set { self.setValue(newValue, forKey: "wantsToBeCentered") }
    }
    
    /// Set the toolbar item to track a split view divider with its divider index.
    ///
    /// Notes: The index is *not* the **SUBVIEW** index, but the **DIVIDER** index.
    /// Does nothing if not a flexible space item.
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
    
    /// A custom FlexibleSpace item with a special `id`.
    public static func flexibleSpace(with id: NSToolbarItem.Identifier) -> NSToolbarItem {
        let clz = NSClassFromString("NSToolbarFlexibleSpaceItem") as! NSToolbarItem.Type
        let item = clz.init()
        _ = self.setItemIdentifierKey[item, with: id.rawValue, with: nil]
        return item
    }
    
    public static func windowTitle(window: NSWindow) -> NSToolbarItem {
        let i = NSToolbarItem(itemIdentifier: .windowTitle)
        i.visibilityPriority = .high
        i.centered = true
        let t = NSTextField(labelWithString: window.title)
        t.textColor = .secondaryLabelColor
        i.view = t
        
        // Automatically update this item; it's bound to the window FOREVER!!!
        window.bind(.title, to: t, withKeyPath: "stringValue", options: [
            .nullPlaceholder: "Window",
            .notApplicablePlaceholder: "Window"
        ])
        return i
    }
    
    public static func windowTitle(viewController: NSViewController) -> NSToolbarItem {
        let i = NSToolbarItem(itemIdentifier: .windowTitle)
        i.visibilityPriority = .high
        i.centered = true
        let t = NSTextField(labelWithString: viewController.title ?? "")
        t.textColor = .secondaryLabelColor
        i.view = t
        
        // Automatically update this item; it's bound to the window FOREVER!!!
        viewController.bind(.title, to: t, withKeyPath: "stringValue", options: [
            .nullPlaceholder: "Window",
            .notApplicablePlaceholder: "Window"
        ])
        return i
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

public extension NSToolbar {
    private static var containerProp = AssociatedProperty<NSToolbar, ToolbarContainer>(.weak)
    public var container: ToolbarContainer? {
        get { return NSToolbar.containerProp[self] }
        set {
            NSToolbar.containerProp[self] = newValue
            self.delegate = newValue
            newValue?.toolbar = self
        }
    }
}

public extension NSToolbarItem.Identifier {
    public static let windowTitle = NSToolbarItem.Identifier(rawValue: "NSToolbarItemWindowTitleIdentifier")
}
