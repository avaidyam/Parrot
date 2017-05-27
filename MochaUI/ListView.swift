import AppKit
import Mocha

private let log = Logger(subsystem: "MochaUI.ListView")

/* TODO: Cell insets (or indents), separator insets/enabled/color/effects. */
/* TODO: Support type-select. */

public protocol ListViewDataDelegate {
    
    /// Returns the number of items per section. The array count is number of sections
    /// and the integer in each section is the number of items in that section.
    func numberOfItems(in: ListView) -> [UInt]
    
    /// Returns the object for the section and item path given.
    func object(in: ListView, at: ListView.Index) -> Any?
    
    /// Returns the type of NSViewController to use for the list cell.
    func itemClass(in: ListView, at: ListView.Index) -> NSView.Type
    
    /// Returns the height of the cell at the given index.
    func cellHeight(in: ListView, at: ListView.Index) -> Double
}

public protocol ListViewSelectionDelegate {
    
    /// The ListView presents the possible selections and allows the delegate to modify
    /// the selection before it happens.
    func proposedSelection(in: ListView, at: [ListView.Index]) -> [ListView.Index]
    
    /// The user has changed the selection of an item and the delegate will be notified.
    func selectionChanged(in: ListView, is: [ListView.Index])
}

public protocol ListViewScrollbackDelegate {
    
    /// Indicates that the ListView has reached the start or end of its content.
    /// The only possible values for `edge` will be `.maxY` or `.minY`.
    func reachedEdge(in: ListView, edge: NSRectEdge)
}

/// Generic container type for any view presenting a list of elements.
/// In subclassing, modify the Element and Container aliases.
/// This way, a lot of behavior will be defaulted, unless custom behavior is needed.
@IBDesignable
public class ListView: NSView {
    
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
    
	/// Provides the global header for all sections in the ListView.
	@IBOutlet public var headerView: NSView?
	
	/// Provides the global footer for all sections in the ListView.
	@IBOutlet public var footerView: NSView?
    
    /// Provides the information about each section and items in the sections.
    @IBOutlet public var delegate: AnyObject?
    
    /// Describes the Direction of content flow in the ListView.
    public var flowDirection: FlowDirection = .top
    
    /// Determines the selection capabilities of the ListView.
    public var selectionType: SelectionType = .none {
        didSet {
            let s = self.selectionType
            self.tableView.allowsMultipleSelection = (s == .leastOne || s == .any)
            self.tableView.allowsEmptySelection = (s == .none || s == .one || s == .any)
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
            self.tableView.wantsLayer = self.wantsLayer
        }
    }
    
    fileprivate var scrollView: NSScrollView! // FIXME: Should be private...
    public var tableView: NSTableView! // FIXME: Should be private...
	
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
        
        self.tableView = NSExtendedTableView(frame: self.scrollView.bounds)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let col = NSTableColumn(identifier: "")
        col.resizingMask = .autoresizingMask
        col.isEditable = false
        self.tableView.addTableColumn(col)
        self.tableView.headerView = nil
        self.tableView.menu = NSMenu(title: "")
        
        self.tableView.backgroundColor = NSColor.clear
        self.tableView.allowsEmptySelection = true
        self.tableView.allowsMultipleSelection = true
        self.tableView.selectionHighlightStyle = .sourceList
        self.tableView.floatsGroupRows = true
        self.tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        self.tableView.intercellSpacing = NSSize(width: 0, height: 0)
        self.tableView.layerContentsRedrawPolicy = .onSetNeedsDisplay
		
		self.scrollView.documentView = self.tableView
		self.scrollView.hasVerticalScroller = true
		self.addSubview(self.scrollView)
		self.scrollView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
		self.scrollView.translatesAutoresizingMaskIntoConstraints = true
        self.scrollView.contentView.postsBoundsChangedNotifications = true
        self.tableView.sizeLastColumnToFit()
        
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
            self.tableView.reloadData()
            switch self.flowDirection {
            case .top: self.scroll(toRow: 0, animated: animated)
            case .bottom: self.scroll(toRow: self.__rows - 1, animated: animated)
            }
            handler()
        }
	}
    
    public func perform(updates: () -> ()) {
        self.tableView.beginUpdates()
        updates()
        self.tableView.endUpdates()
    }
    
    public func insert(at indexes: [ListView.Index], animation: NSTableViewAnimationOptions = [.effectFade, .slideUp]) {
        DispatchQueue.main.async {
            self.tableView.insertRows(at: self.__fromRows(indexes), withAnimation: animation)
        }
    }
    
    public func remove(at indexes: [ListView.Index], animation: NSTableViewAnimationOptions = [.effectFade, .slideDown]) {
        DispatchQueue.main.async {
            self.tableView.removeRows(at: self.__fromRows(indexes), withAnimation: animation)
        }
    }
    
    public func move(from origin: [ListView.Index], to dest: [ListView.Index]) {
        assert(origin.count == dest.count, "Move operation origin and destination must have same number of indexes!")
        DispatchQueue.main.async {
            for (idx, origin2) in origin.enumerated() {
                let dest2 = dest[idx]
                log.debug("moving from \(origin2) to \(dest2)")
                log.debug("TRNASLATE: \(Int(self.__toRow(origin2))) to \(Int(self.__toRow(dest2)))")
                self.tableView.moveRow(at: Int(self.__toRow(origin2)), to: Int(self.__toRow(dest2)))
            }
        }
    }
    
    //hide, unhide, hiddenrows
	
	public func scroll(toRow row: Int, animated: Bool = true) {
        guard row >= 0 && row <= __rows - 1 else { return }
        NSAnimationContext.animate {
            self.tableView.scrollRowToVisible(row)
        }
	}
	
	public func register(nib: NSNib, forClass: NSView.Type) {
        self.tableView.register(nib, forIdentifier: "\(forClass)")
	}
	
	public var visibleIndexes: [ListView.Index] {
        let r = self.tableView.rows(in: self.tableView.visibleRect)
        return Array(r.location..<r.location+r.length).map { __fromRow(UInt($0)) }
	}
    
    public var visibleCells: [NSView] {
        return self.tableView.selectedRowIndexes.flatMap {
            (self.tableView as NSTableView).view(atColumn: 0, row: $0, makeIfNecessary: false)
        }
    }
    
    public var selection: [ListView.Index] {
        get { return self.tableView.selectedRowIndexes.map { __fromRow(UInt($0)) } }
        set { self.tableView.selectRowIndexes(__fromRows(newValue), byExtendingSelection: false) }
    }
    
    fileprivate var prototypes = [String: NSView]()
}

fileprivate extension ListView {
    
    fileprivate var __rows: Int {
        guard let d = self.delegate as? ListViewDataDelegate else { return 0 }
        return Int(d.numberOfItems(in: self).reduce(0, +))
        //+ (self.headerView != nil ? 1 : 0) + (self.footerView != nil ? 1 : 0)
    }
    
    fileprivate func __fromRow(_ val: UInt) -> ListView.Index {
        guard let d = self.delegate as? ListViewDataDelegate else { return (section: 0, item: 0) }
        func sectionForRow(row: UInt, counts: [UInt]) -> ListView.Index {
            var c = counts[0]
            for section in 0..<counts.count {
                if (section > 0) {
                    c = c + counts[section]
                }
                if (row >= c - counts[section]) && row < c {
                    return (section: UInt(section), item: row - (c - counts[section]))
                }
            }
            return (section: 0, item: 0)
        }
        
        let curr = val //- ((self.headerView != nil ? 1 : 0) + (self.footerView != nil ? 1 : 0))
        return sectionForRow(row: curr, counts: d.numberOfItems(in: self))
    }
    
    fileprivate func __fromRows(_ ret: [ListView.Index]) -> IndexSet {
        var set = IndexSet()
        ret.map { __toRow($0) }.forEach { set.insert(Int($0)) }
        return set
    }
    
    fileprivate func __toRow(_ val: ListView.Index) -> UInt {
        guard let d = self.delegate as? ListViewDataDelegate else { return 0 }
        let counts = d.numberOfItems(in: self)
        let running = (0..<val.section).map { counts[Int($0)] }.reduce(0, +) + val.item
        let curr = running //- ((self.headerView != nil ? 1 : 0) + (self.footerView != nil ? 1 : 0))
        return curr
    }
}

/// Delegate selection support.
/*fileprivate extension ListView {
    fileprivate var dataDelegate: ListViewDataDelegate? {
        return self.delegate as? ListViewDataDelegate
    }
    fileprivate var selectionDelegate: ListViewSelectionDelegate? {
        return self.delegate as? ListViewSelectionDelegate
    }
    fileprivate var scrollbackDelegate: ListViewScrollbackDelegate? {
        return self.delegate as? ListViewScrollbackDelegate
    }
}*/

// Essential Support
extension ListView: NSTableViewDataSource, NSTableViewDelegate {
	
	@objc(numberOfRowsInTableView:)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return __rows
	}
	
	public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let index = __fromRow(UInt(row))
        guard let d = self.delegate as? ListViewDataDelegate else { return 0.0 }
        return CGFloat(d.cellHeight(in: self, at: index))
	}
	
    /// Whenever the NSTableColumn resizes, we know the parent view resizes, so automatically 
    /// retile the rows. Note: turn off animations while doing this.
	public func tableViewColumnDidResize(_ notification: Notification) {
        NSAnimationContext.disableAnimations {
            self.tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integersIn: 0..<__rows))
        }
	}
	
	public func tableViewDidScroll(_ notification: Notification) {
        guard let o = notification.object as? NSView , o == self.scrollView.contentView else { return }
        guard let d = self.delegate as? ListViewScrollbackDelegate else { return }
        
        // FIXME: Don't do visible row calculation; just simple math. This doesn't work right now.
        /*
        let current = self.scrollView.visibleRect
        let content = self.tableView.bounds.height - 16
        if current.minY > content {
            log.debug("triggered path A")
        }
        if current.maxY < 16 {
            log.debug("triggered path B")
        }
        */
        
        let visibleRows = self.tableView.rows(in: self.tableView.visibleRect).toRange()!
		if visibleRows.contains(0) {
            d.reachedEdge(in: self, edge: .maxY)
		}
        if visibleRows.contains(__rows - 1) {
            d.reachedEdge(in: self, edge: .minY)
        }
	}
	
    public func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        let _ = __fromRow(UInt(row))
		//log.info("Unimplemented \(__FUNCTION__)")
		return false
	}
	
	public func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		return []//self.rowActionProvider?(row, edge) ?? []
	}
	
	@objc(tableView:viewForTableColumn:row:)
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let index = __fromRow(UInt(row))
        guard let d = self.delegate as? ListViewDataDelegate else { return nil }
        
		let cellClass = d.itemClass(in: self, at: index)
		var view = self.tableView.make(withIdentifier: "\(cellClass)", owner: self)
		if view == nil {
			//log.warning("Cell class \(cellClass) not registered!")
			view = cellClass.init(frame: .zero)
			view!.identifier = cellClass.className()
		}
		
		(view as? NSTableCellView)?.objectValue = d.object(in: self, at: index)
		return view
	}
	
    public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        //let _ = __fromRow(UInt(row))
		return NSExtendedTableRowView(frame: .zero) // FIXME
	}
	
    /*
	@objc(tableView:didAddRowView:forRow:)
    public func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        //let _ = __fromRow(UInt(row))
	}
	
	@objc(tableView:didRemoveRowView:forRow:)
    public func tableView(_ tableView: NSTableView, didRemove rowView: NSTableRowView, forRow row: Int) {
        //let _ = __fromRow(UInt(row))
        //log.debug("DEL ROW \(row)")
		//log.info("Unimplemented \(__FUNCTION__)")
	}
    */
	
	@objc(selectionShouldChangeInTableView:)
    public func selectionShouldChange(in tableView: NSTableView) -> Bool {
        guard let _ = self.delegate as? ListViewSelectionDelegate, self.selectionType != .none else { return false }
		return true
	}
	
    public func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        guard let d = self.delegate as? ListViewSelectionDelegate else { return IndexSet() }
        let proposed = proposedSelectionIndexes.map { __fromRow(UInt($0)) }
        let ret = d.proposedSelection(in: self, at: proposed)
        return __fromRows(ret)
	}
	
    public func tableViewSelectionDidChange(_ notification: Notification) {
        guard let d = self.delegate as? ListViewSelectionDelegate, self.selectionType != .none else { return }
        d.selectionChanged(in: self, is: self.selection)
	}
}

public protocol NSTableViewCellProtocol {
    var objectValue: Any? { get set }
    var draggingImageComponents: [NSDraggingImageComponent] { get }
    var isSelected: Bool { get set }
}

/// Support for disabling emphasis to allow vibrancy.
public class NSExtendedTableRowView: NSTableRowView {
    public override var isEmphasized: Bool {
        get { return false }
        set { }
    }
    public override var isSelected: Bool {
        didSet {
            guard self.subviews.count > 0 else { return }
            if var cell = self.view(atColumn: 0) as? NSTableViewCellProtocol {
                cell.isSelected = self.isSelected
            }
        }
    }
}

/// Support for per-row and multi-select menus.
public class NSExtendedTableView: NSTableView {
    public override var wantsUpdateLayer: Bool { return true }
    
    public var expandSelectionOnMenuClick = false
    public override func menu(for event: NSEvent) -> NSMenu? {
        let row = self.row(at: self.convert(event.locationInWindow, from: nil))
        guard row >= 0 && event.type == .rightMouseDown else {
            return super.menu(for: event)
        }
        
        let selected = self.selectedRowIndexes
        if !selected.contains(row) && expandSelectionOnMenuClick {
            self.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
        }
        
        // As a last resort, if the row was selected alone, ask the view.
        if let view = self.view(atColumn: 0, row: row, makeIfNecessary: false) {
            return view.menu(for: event)
        }
        return super.menu(for: event)
    }
}
