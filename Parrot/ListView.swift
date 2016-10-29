import AppKit

/* TODO: Cell insets (or indents), separator insets/enabled/color/effects. */
/* TODO: Support type-select. */

public protocol ListViewDataSource {
    
    /// Returns the number of items per section. The array count is number of sections
    /// and the integer in each section is the number of items in that section.
    func numberOfItems(in: ListView) -> [UInt]
    
    /// Returns the object for the section and item path given.
    func object(in: ListView, at: ListView.Index) -> Any?
    
    /// Returns the type of NSViewController to use for the list cell.
    func itemClass(in: ListView, at: ListView.Index) -> NSTableCellView.Type
}

/// Generic container type for any view presenting a list of elements.
/// In subclassing, modify the Element and Container aliases.
/// This way, a lot of behavior will be defaulted, unless custom behavior is needed.
@IBDesignable
public class ListView: NSView {
    
    public typealias Index = (section: UInt, item: UInt)
    
	fileprivate var scrollView: NSScrollView! // FIXME: Should be private...
	fileprivate var tableView: NSTableView! // FIXME: Should be private...
    
	/// Provides the global header for all sections in the ListView.
	@IBOutlet public var headerView: NSView?
	
	/// Provides the global footer for all sections in the ListView.
	@IBOutlet public var footerView: NSView?
    
    /// Provides the information about each section and items in the sections.
    /*@IBOutlet*/ public var dataSource: ListViewDataSource?
	
	// Override and patch in the default initializers to our init.
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
        self.tableView.sizeLastColumnToFit()
	}
	
	@IBInspectable // FIXME
	public var updateToBottom: Bool = false
	
	// Allow accessing the insets from the scroll view.
	public var insets: EdgeInsets {
		get { return self.scrollView.contentInsets }
		set { self.scrollView.contentInsets = newValue }
	}
	
    // Forward the layer-backing down to our subviews.
	public override var wantsLayer: Bool {
		didSet {
			self.scrollView.wantsLayer = self.wantsLayer
			self.tableView.wantsLayer = self.wantsLayer
		}
	}
	
	public func update(animated: Bool = true, _ handler: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            switch !self.updateToBottom {
            case true: self.scroll(toRow: 0, animated: animated)
            case false: self.scroll(toRow: self.__rows - 1, animated: animated)
            }
            handler()
        }
	}
	
	public func scroll(toRow row: Int, animated: Bool = true) {
        guard row >= 0 && row <= __rows - 1 else { return }
        NSAnimationContext.animate {
            self.tableView.scrollRowToVisible(row)
        }
	}
	
	public func register(nibName: String, forClass: NSTableCellView.Type) {
        let nib = NSNib(nibNamed: nibName, bundle: nil)
        self.tableView.register(nib, forIdentifier: "\(forClass)")
	}
	
	public var selection: [Int] {
		return self.tableView.selectedRowIndexes.map { $0 }
	}
	
	public var visibleRows: [Int] {
        let r = self.tableView.rows(in: self.tableView.visibleRect)
        return Array(r.location..<r.location+r.length)
	}
    
    public var visibleCells: [NSTableCellView] {
        return self.visibleRows.flatMap { (self.tableView as NSTableView).view(atColumn: 0, row: $0, makeIfNecessary: false) as? NSTableCellView }
    }
	
    //public var dataSourceProvider: (() -> [Any])? = nil
    //public var dataSourceAdjustProvider: ((_ row: Int) -> Any)? = nil
	//public var viewClassProvider: ((_ row: Int) -> NSTableCellView.Type)? = nil
    
	//public var clickedRowProvider: ((_ row: Int) -> Void)? = nil
	//public var selectionProvider: ((_ row: Int) -> Void)? = nil // FIXME?
	//public var rowActionProvider: ((_ row: Int, _ edge: NSTableRowActionEdge) -> [NSTableViewRowAction])? = nil // FIXME?
	//public var menuProvider: ((_ rows: [Int]) -> NSMenu?)? = nil // FIXME?
	//public var pasteboardProvider: ((_ row: Int) -> NSPasteboardItem?)? = nil // FIXME?
	//public var scrollbackProvider: ((_ direction: ScrollDirection) -> Void)? = nil
    
    ///
    ///
    
    fileprivate var prototypes = [String: NSTableCellView]()
    
    fileprivate var __rows: Int {
        return Int(self.dataSource?.numberOfItems(in: self).reduce(0, +) ?? 0)
            //+ (self.headerView != nil ? 1 : 0) + (self.footerView != nil ? 1 : 0)
    }
    
    fileprivate func __fromRow(_ val: UInt) -> ListView.Index {
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
        return sectionForRow(row: curr, counts: self.dataSource?.numberOfItems(in: self) ?? [])
    }
}

/*
// Essential Support
extension ListView  {
    
    @objc(numberOfSectionsInCollectionView:)
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    @objc(collectionView:itemForRepresentedObjectAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cellClass = self.viewClassProvider?(indexPath.item) ?? NSCollectionViewItem.self
        let item = self.tableView.makeItem(withIdentifier: "\(cellClass)", for: indexPath)
        item.representedObject = self.dataSourceAdjustProvider?(indexPath.item) ?? self.dataSource[indexPath.item]
        return item
    }
    
    @objc(collectionView:willDisplayItem:forRepresentedObjectAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.scrollbackProvider?(.top)
        }
        if indexPath.item == self.dataSource.count - 1 {
            self.scrollbackProvider?(.bottom)
        }
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        //let sz = self.sizeClass.calculate(nil)
        //if sz != 0 { return NSSize(width: collectionView.bounds.width.native, height: sz) }
        
        
        let cellClass = self.viewClassProvider?(indexPath.item) ?? NSCollectionViewItem.self
        var proto = self.prototypes["\(cellClass)"]
        if proto == nil {
            let item = cellClass.init()
            item.loadView()
            item.identifier = "\(cellClass)"
            self.prototypes["\(cellClass)"] = item
            proto = item
        }
        
        proto?.view.frame = NSRect(x: 0, y: 0, width: self.bounds.width, height: 20.0)
        proto?.representedObject = self.dataSourceAdjustProvider?(indexPath.item) ?? self.dataSource[indexPath.item]
        proto?.view.layoutSubtreeIfNeeded()
        return NSSize(width: self.bounds.width, height: proto!.view.fittingSize.height)
    }
    
    /*@objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        
    }*/
    
}
*/


// Essential Support
extension ListView: NSTableViewDataSource, NSTableViewDelegate {
	
	@objc(numberOfRowsInTableView:)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return __rows
	}
	
	public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let index = __fromRow(UInt(row))
        let cellClass = self.dataSource?.itemClass(in: self, at: index) ?? NSTableCellView.self
        var proto = self.prototypes["\(cellClass)"]
        if proto == nil {
            let stuff = NSNib(nibNamed: "\(cellClass)", bundle: nil)?.instantiate(self).flatMap { $0 as? NSTableCellView }
            proto = stuff?.first//cellClass.init() // FIXME: doesn't work
            if proto == nil {
                return -1
            }
            proto?.identifier = "\(cellClass)"
            self.prototypes["\(cellClass)"] = proto!
        }
        
        proto?.frame = NSRect(x: 0, y: 0, width: self.bounds.width, height: 20.0)
        proto?.objectValue = self.dataSource?.object(in: self, at: index)
        proto?.layoutSubtreeIfNeeded()
        return proto!.fittingSize.height
	}
	
    /// Whenever the NSTableColumn resizes, we know the parent view resizes, so automatically 
    /// retile the rows. Note: turn off animations while doing this.
	public func tableViewColumnDidResize(_ notification: Notification) {
        NSAnimationContext.disableAnimations {
            self.tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integersIn: 0..<__rows))
        }
	}
	
	public func tableViewDidScroll(_ notification: Notification) {
		guard let o = notification.object as? NSView , o == self.tableView.enclosingScrollView?.contentView else { return }
		if self.visibleRows.contains(0) {
			//self.scrollbackProvider?(.top)
		}
		if self.visibleRows.contains(__rows - 1) {
			//self.scrollbackProvider?(.bottom)
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
		let cellClass = self.dataSource?.itemClass(in: self, at: index) ?? NSTableCellView.self
		var view = self.tableView.make(withIdentifier: "\(cellClass)", owner: self) as? NSTableCellView
		if view == nil {
			log.warning("Cell class \(cellClass) not registered!")
			view = cellClass.init(frame: .zero)
			view!.identifier = cellClass.className()
		}
		
		view!.objectValue = self.dataSource?.object(in: self, at: index)
		//tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integer: row))
		return view
	}
	
    public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let _ = __fromRow(UInt(row))
		//log.info("Unimplemented \(__FUNCTION__)")
		return nil // no default row yet
	}
	
	@objc(tableView:didAddRowView:forRow:)
    public func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        let _ = __fromRow(UInt(row))
		//log.debug("ADD ROW \(row)")
		rowView.canDrawSubviewsIntoLayer = true
		rowView.isEmphasized = false
	}
	
	@objc(tableView:didRemoveRowView:forRow:)
    public func tableView(_ tableView: NSTableView, didRemove rowView: NSTableRowView, forRow row: Int) {
        let _ = __fromRow(UInt(row))
        //log.debug("DEL ROW \(row)")
		//log.info("Unimplemented \(__FUNCTION__)")
	}
	
	@objc(selectionShouldChangeInTableView:)
	public func selectionShouldChange(in tableView: NSTableView) -> Bool {
		return true//self.selectionProvider != nil
	}
	
	public func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
		return proposedSelectionIndexes
	}
	
	public func tableViewSelectionDidChange(_ notification: Notification) {
		//self.selectionProvider?(self.tableView.selectedRow)
	}
}

public class NSExtendedTableView: NSTableView {
    
    // Support for per-row and multi-select menus.
    public override func menu(for event: NSEvent) -> NSMenu? {
        let row = self.row(at: self.convert(event.locationInWindow, from: nil))
        guard row >= 0 && event.type == .rightMouseDown else {
            return super.menu(for: event)
        }
        
        var selected = self.selectedRowIndexes
        if !selected.contains(row) {
            selected = IndexSet(integer: row)
            // Enable this to select the row upon menu-click.
            //self.selectRowIndexes(selected, byExtendingSelection: false)
        }
        
        // As a last resort, if the row was selected alone, ask the view.
        if let view = self.view(atColumn: 0, row: row, makeIfNecessary: false) {
            return view.menu(for: event)
        }
        
        /*if let d = self.delegate as? NSExtendedTableViewDelegate {
            return d.tableView?(self, menuForRows: selected) ?? super.menu(for: event)
        }*/
        return super.menu(for: event)
    }
    
    /*
    public override func mouseDown(with event: NSEvent) {
        let loc = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: loc)
        
        super.mouseDown(with: event)
        if let d = self.delegate as? NSExtendedTableViewDelegate , row != -1 {
            d.tableView?(self, didClickRow: row)
        }
    }*/
}
