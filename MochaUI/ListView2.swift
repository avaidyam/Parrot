import AppKit
import Mocha

private let log = Logger(subsystem: "MochaUI.ListView2")

/* TODO: Cell insets (or indents), separator insets/enabled/color/effects. */
/* TODO: Support type-select. */
/* TODO: Support NS/Object/Array/Dictionary/Controller with ListView. */

public protocol ListViewDataDelegate2 {
    
    /// Returns the number of items per section. The array count is number of sections
    /// and the integer in each section is the number of items in that section.
    func numberOfItems(in: ListView2) -> [UInt]
    
    /// Returns the object for the section and item path given.
    func object(in: ListView2, at: ListView2.Index) -> Any?
    
    /// Returns the type of NSViewController to use for the list cell.
    func itemClass(in: ListView2, at: ListView2.Index) -> NSCollectionViewItem.Type
    
    /// Returns the height of the cell at the given index.
    func cellHeight(in: ListView2, at: ListView2.Index) -> Double
}

public protocol ListViewSelectionDelegate2 {
    
    /// The ListView presents the possible selections and allows the delegate to modify
    /// the selection before it happens.
    func proposedSelection(in: ListView2, at: [ListView2.Index], selecting: Bool) -> [ListView2.Index]
    
    /// The user has changed the selection of an item and the delegate will be notified.
    func selectionChanged(in: ListView2, is: [ListView2.Index], selecting: Bool)
}

public protocol ListViewScrollbackDelegate2 {
    
    /// Indicates that the ListView has reached the start or end of its content.
    /// The only possible values for `edge` will be `.maxY` or `.minY`.
    func reachedEdge(in: ListView2, edge: NSRectEdge)
}

/// Generic container type for any view presenting a list of elements.
/// In subclassing, modify the Element and Container aliases.
/// This way, a lot of behavior will be defaulted, unless custom behavior is needed.
@IBDesignable
public class ListView2: NSView {
    
    /// The SelectionType describes the manner in which the ListView may be selected by the user.
    public enum SelectionType {
        
        /// No items may be selected.
        case none
        
        /// One item may be selected at a time.
        case one
        
        /// One item must be selected at all times.
        case exactOne
        
        /// At least one item must be selected at all times.
        case leastOne
        
        /// Multiple items may be selected at a time.
        case any
    }
    
    /// Describes the Direction of content flow in the ListView.
    /// For example, an update can causes the ListView to scroll to the top or bottom.
    public enum FlowDirection {
        
        /// Content flows to the top (earliest content is at the top).
        case top
        
        /// Content flows to the bottom (earliest content is at the bottom).
        case bottom
    }
    
    /// The ListView is indexed by a combination of section and item, to allow grouping.
    public typealias Index = (section: UInt, item: UInt)
    
    /// Provides the information about each section and items in the sections.
    @IBOutlet public var delegate: AnyObject?
    
    /// Describes the Direction of content flow in the ListView.
    public var flowDirection: FlowDirection = .top
    
    /// Determines the selection capabilities of the ListView.
    public var selectionType: SelectionType = .none {
        didSet {
            let s = self.selectionType
            self.collectionView.allowsMultipleSelection = (s == .leastOne || s == .any)
            self.collectionView.allowsEmptySelection = (s == .none || s == .one || s == .any)
            self.collectionView.isSelectable = (s != .none)
        }
    }
    
    /// Sets the ListView's scrolling insets.
    @IBInspectable public var insets: EdgeInsets {
        get { return self.scrollView.contentInsets }
        set { self.scrollView.contentInsets = newValue }
    }
    
    /// Forward the layer-backing down to our subviews.
    public override var wantsLayer: Bool {
        didSet {
            self.scrollView.wantsLayer = self.wantsLayer
            self.collectionView.wantsLayer = self.wantsLayer
        }
    }
    
    public var scrollView: NSScrollView! // FIXME: Should be private...
    public var collectionView: NSCollectionView! // FIXME: Should be private...
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commonInit()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.scrollView = NSScrollView(frame: self.bounds)
        self.scrollView.automaticallyAdjustsContentInsets = false
        self.scrollView.drawsBackground = false
        self.scrollView.borderType = .noBorder
        
        self.collectionView = NSCollectionView(frame: self.scrollView.bounds)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColors = [.clear]
        self.selectionType = .none
        let l = NSCollectionViewListLayout()
        l.heightOfIndexPath = {
            return self.collectionView(self.collectionView, layout: l, sizeForItemAt: $0).height
        }
        self.collectionView.collectionViewLayout = l
        self.collectionView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        self.scrollView.documentView = self.collectionView
        self.scrollView.hasVerticalScroller = true
        self.addSubview(self.scrollView)
        self.scrollView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
        self.scrollView.contentView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListView.tableViewDidScroll(_:)),
                                               name: .NSViewBoundsDidChange,
                                               object: self.scrollView.contentView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override var wantsUpdateLayer: Bool { return true }
    
    public func update(animated: Bool = true, _ handler: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                switch self.flowDirection {
                case .top: self.scroll(toRow: 0, animated: animated)
                case .bottom: self.scroll(toRow: self.__rows - 1, animated: animated)
                }
                handler()
            }
        }
    }
    
    public func scroll(toRow row: Int, animated: Bool = true) {
        guard row >= 0 && row <= __rows - 1 else { return }
        self.collectionView.animator().scrollToItems(at: [IndexPath(item: row, section: 0)],
                                                     scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
    }
    
    public func perform(updates: () -> ()) {
        self.collectionView.performBatchUpdates(updates, completionHandler: nil)
    }
    
    public var selection: [ListView.Index] {
        get { return self.collectionView.selectionIndexPaths.map { $0.toListView() } }
        set { self.collectionView.selectionIndexPaths = Set(self.selection.map { IndexPath.fromListView($0) }) }
    }
    
    fileprivate var __rows: UInt {
        return (self.delegate as? ListViewDataDelegate2)?.numberOfItems(in: self)[0] ?? 0
    }
}

extension ListView2: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        guard let d = self.delegate as? ListViewDataDelegate2 else { return 0 }
        return d.numberOfItems(in: self).count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let d = self.delegate as? ListViewDataDelegate2 else { return 0 }
        return Int(d.numberOfItems(in: self)[section])
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout
        collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard let d = self.delegate as? ListViewDataDelegate2 else { return .zero }
        let idx = indexPath.toListView()
        return NSSize(width: 0, height: d.cellHeight(in: self, at: idx))
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let d = self.delegate as? ListViewDataDelegate2 else { return NSCollectionViewItem() }
        let idx = indexPath.toListView()
        
        let clazz = d.itemClass(in: self, at: idx)
        let item = collectionView.makeItem(withIdentifier: "\(clazz)", for: indexPath)
        item.representedObject = d.object(in: self, at: idx)
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        guard let d = self.delegate as? ListViewSelectionDelegate2, self.selectionType != .none else { return [] }
        return Set(d.proposedSelection(in: self, at: Array(indexPaths).map { $0.toListView() },
                                       selecting: true).map { IndexPath.fromListView($0) })
    }
    
    public func collectionView(_ collectionView: NSCollectionView, shouldDeselectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        guard let d = self.delegate as? ListViewSelectionDelegate2, self.selectionType != .none else { return [] }
        return Set(d.proposedSelection(in: self, at: Array(indexPaths).map { $0.toListView() },
                                       selecting: false).map { IndexPath.fromListView($0) })
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let d = self.delegate as? ListViewSelectionDelegate2, self.selectionType != .none else { return }
        d.selectionChanged(in: self, is: Array(indexPaths).map { $0.toListView() }, selecting: true)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard let d = self.delegate as? ListViewSelectionDelegate2, self.selectionType != .none else { return }
        d.selectionChanged(in: self, is: Array(indexPaths).map { $0.toListView() }, selecting: false)
    }
    
    public func tableViewDidScroll(_ notification: Notification) {
        guard let o = notification.object as? NSView , o == self.scrollView.contentView else { return }
        guard let d1 = self.delegate as? ListViewDataDelegate2 else { return }
        guard let d = self.delegate as? ListViewScrollbackDelegate2 else { return }
        
        let sections = d1.numberOfItems(in: self)
        let visibleRows = self.collectionView.indexPathsForVisibleItems()
        if visibleRows.contains(IndexPath(item: 0, section: 0)) {
            d.reachedEdge(in: self, edge: .maxY)
        }
        /*if visibleRows.contains(IndexPath(item: sections[sections.count - 1] - 1, section: sections.count - 1)) {
            d.reachedEdge(in: self, edge: .minY)
        }*/
    }
}

public extension IndexPath {
    public func toListView() -> ListView2.Index {
        return (section: UInt(self.section), item: UInt(self.item))
    }
    public static func fromListView(_ idx: ListView2.Index) -> IndexPath {
        return IndexPath(item: Int(idx.item), section: Int(idx.section))
    }
}
