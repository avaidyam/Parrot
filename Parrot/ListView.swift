import AppKit

/* TODO: Cell insets (or indents), separator insets/enabled/color/effects. */
/* TODO: Support type-select. */

/// Provides default size classes for displayed elements of a list.
/// Any of the provided classes have an associated size.
/// However, .Dynamic implies that the size class will be computed
/// at runtime based on the runtime size of the list elements.
public enum SizeClass {
	case xSmall// = 16.0
	case small// = 32.0
	case medium// = 48.0
	case large// = 64.0
	case xLarge// = 96.0
	case custom(Double)
	case dynamic
	
	var size: Double {
		switch self {
		case .xSmall: return 16.0
		case .small: return 32.0
		case .medium: return 48.0
		case .large: return 64.0
		case .xLarge: return 96.0
		case .custom(let value): return value
		case .dynamic: return 0.0
		}
	}
	
	func calculate(_ dynamic: (() -> Double)?) -> Double {
		switch self {
		case .dynamic where dynamic != nil: return dynamic!()
		default: return self.size
		}
	}
}

/// Provides selection capabilities for selectable elements of a list.
/// .None implies no user selection capability.
/// .One implies single element user selection capability.
/// .Any implies multiple element user selection capability.
public enum SelectionCapability {
	case none
	case one
	case any
}

/// Determines the scroll direction of the ListView upon update.
/// Currently, only top and bottom are supported.
public enum ScrollDirection {
	case top
	case bottom
	//case index(Int)
}

// FIXME: ListViewDelegate

public class ListViewCell: NSCollectionViewItem {
	public class func cellHeight(forWidth: CGFloat, cellValue: Any?) -> CGFloat {
		return 20.0
	}
}

/// Generic container type for any view presenting a list of elements.
/// In subclassing, modify the Element and Container aliases.
/// This way, a lot of behavior will be defaulted, unless custom behavior is needed.
@IBDesignable
public class ListView: NSView, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource {
	
	// TODO: Work in Progress here...
	public struct Section {
		let count: Int
	}
	
	internal var scrollView: NSScrollView! // FIXME: Should be private...
	internal var collectionView: NSCollectionView! // FIXME: Should be private...
    
	/// Provides the global header for all sections in the ListView.
	@IBOutlet public var headerView: NSView?
	
	/// Provides the global footer for all sections in the ListView.
	@IBOutlet public var footerView: NSView?
	
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
        self.collectionView = NSCollectionView(frame: self.scrollView.bounds)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let l = NSCollectionViewFlowLayout()
        l.minimumInteritemSpacing = 0
        l.minimumLineSpacing = 0
        l.scrollDirection = .vertical
        l.sectionInset = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        l.itemSize = CGSize(width: 200, height: 80)
        
        self.collectionView.collectionViewLayout = l
		
		self.scrollView.drawsBackground = false
        self.scrollView.borderType = .noBorder
        self.collectionView.allowsEmptySelection = true
        self.collectionView.isSelectable = true
        self.collectionView.backgroundColors = []
        self.collectionView.maxItemSize = NSSize(width: 0, height: 0)
		
		self.scrollView.documentView = self.collectionView
		self.scrollView.hasVerticalScroller = true
		self.addSubview(self.scrollView)
		
		self.scrollView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
		self.scrollView.translatesAutoresizingMaskIntoConstraints = true
		
		
		NotificationCenter.default.addObserver(self, selector: #selector(ListView.collectionViewDidScroll(_:)),
		                                         name: .NSViewBoundsDidChange,
		                                         object: self.scrollView.contentView)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	@IBInspectable // FIXME
	public var sizeClass: SizeClass = .large
	@IBInspectable // FIXME
	public var selectionCapability: SelectionCapability = .none
	@IBInspectable // FIXME
	public var updateScrollDirection: ScrollDirection = .bottom
	
	// Allow accessing the insets from the scroll view.
	@IBInspectable // FIXME
	public var insets: EdgeInsets {
		get { return self.scrollView.contentInsets }
		set { self.scrollView.contentInsets = newValue }
	}
	
	// Forward the layer-backing down to our subviews.
	public override var wantsLayer: Bool {
		didSet {
			self.scrollView.wantsLayer = self.wantsLayer
			self.collectionView.wantsLayer = self.wantsLayer
		}
	}
	
	/* TODO: Monitor actual addition/removal changes. */
	/*public var dataSource: [Wrapper<Any>]! {
		didSet { self.update() }
	}*/
	fileprivate var dataSource: [Any] {
		return self.dataSourceProvider?() ?? []
	}
	
	public func update(animated: Bool = true, _ handler: @escaping () -> () = {}) {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
			switch self.updateScrollDirection {
			case .top: self.scroll(toRow: 0, animated: animated)
			case .bottom: self.scroll(toRow: self.dataSource.count - 1, animated: animated)
			}
			handler()
		}
	}
	
	public func scroll(toRow row: Int, animated: Bool = true) {
        DispatchQueue.main.async {
            log.debug("might scroll to \(row) and has \(self.collectionView.numberOfItems(inSection: 0))")
			guard let clip = self.collectionView.superview as? NSClipView , animated else {
				//self.collectionView.scrollToItems(at: Set([IndexPath(item: row, section: 0)]), scrollPosition: .top); 
                return
			}
			
			let rowRect = self.collectionView.frameForItem(at: row)
			var origin = rowRect.origin
			origin.y = (origin.y - (clip.frame.height * 0.5)) + (rowRect.height * 0.5)
			
			self.scrollView?.flashScrollers()
			clip.animator().setBoundsOrigin(origin)
		}
	}
	
	public func register(nibName: String, forClass: ListViewCell.Type) {
		let nib = NSNib(nibNamed: nibName, bundle: nil)
		self.collectionView.register(nib, forItemWithIdentifier: forClass.className())
	}
	
	public var selection: [Int] {
		return self.collectionView.selectionIndexPaths.map { $0.item }
	}
	
	public var visibleRows: [Int] {
        return self.collectionView.indexPathsForVisibleItems().map { $0.item }
	}
	
	public var dataSourceProvider: (() -> [Any])? = nil
	public var viewClassProvider: ((_ row: Int) -> ListViewCell.Type)? = nil
	public var dynamicHeightProvider: ((_ row: Int) -> Double)? = nil
	public var clickedRowProvider: ((_ row: Int) -> Void)? = nil
	public var selectionProvider: ((_ row: Int) -> Void)? = nil
	public var rowActionProvider: ((_ row: Int, _ edge: NSTableRowActionEdge) -> [NSTableViewRowAction])? = nil
	public var menuProvider: ((_ rows: [Int]) -> NSMenu?)? = nil
	public var pasteboardProvider: ((_ row: Int) -> NSPasteboardItem?)? = nil
	public var scrollbackProvider: ((_ direction: ScrollDirection) -> Void)? = nil
}

// Essential Support
extension ListView  {
    
    @objc(numberOfSectionsInCollectionView:)
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count //+ (self.headerView != nil ? 1 : 0) + (self.footerView != nil ? 1 : 0)
    }
    
    @objc(collectionView:itemForRepresentedObjectAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        log.debug("TEST \(#function)")
        let cellClass = self.viewClassProvider?(indexPath.item) ?? ListViewCell.self
        var item = self.collectionView.makeItem(withIdentifier: cellClass.className(), for: indexPath) as? ListViewCell
        if item == nil {
            log.warning("Cell class \(cellClass) not registered!")
            item = cellClass.init()
            item!.identifier = cellClass.className()
        }
        log.debug("MADE CLASS \(item))")
        //item.representedObject = self.dataSource[indexPath.item]
        log.debug("PROVIDED VALUE \(indexPath) => \(self.dataSource[indexPath.item])")
        return item!
    }
    
    public func collectionViewDidScroll(_ notification: Notification) {
        guard let o = notification.object as? NSView , o == self.scrollView.contentView else { return }
        if self.visibleRows.contains(0) {
            self.scrollbackProvider?(.top)
        }
        if self.visibleRows.contains(self.dataSource.count - 1) {
            self.scrollbackProvider?(.bottom)
        }
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let cellClass = (self.viewClassProvider?(indexPath.item) ?? ListViewCell.self)
        let h = cellClass.cellHeight(forWidth: self.bounds.size.width, cellValue: self.dataSource[indexPath.item])
        log.debug("height: \(h) width: \(self.bounds.width)")
        return NSSize(width: self.bounds.width, height: h)
    }
    
    /*@objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        
    }*/
    
}

// Sizing Support
/*extension ListView {
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> EdgeInsets
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize
}*/

// Drag & Drop Support
/*extension ListView {
    
    @objc(collectionView:canDragItemsAtIndexPaths:withEvent:)
    public func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
        
    }
    
    @objc(collectionView:writeItemsAtIndexPaths:toPasteboard:)
    public func collectionView(_ collectionView: NSCollectionView, writeItemsAt indexPaths: Set<IndexPath>, to pasteboard: NSPasteboard) -> Bool {
        
    }

    @objc(collectionView:namesOfPromisedFilesDroppedAtDestination:forDraggedItemsAtIndexPaths:)
    public func collectionView(_ collectionView: NSCollectionView, namesOfPromisedFilesDroppedAtDestination dropURL: URL, forDraggedItemsAt indexPaths: Set<IndexPath>) -> [String] {
        
    }
    
    @objc(collectionView:draggingImageForItemsAtIndexPaths:withEvent:offset:)
    public func collectionView(_ collectionView: NSCollectionView, draggingImageForItemsAt indexPaths: Set<IndexPath>, with event: NSEvent, offset dragImageOffset: NSPointPointer) -> NSImage {
        
    }

    public func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation {
        return [.copy]
    }

    public func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionViewDropOperation) -> Bool {
        return true
    }

    @objc(collectionView:pasteboardWriterForItemAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        return self.pasteboardProvider?(row)
    }

    @objc(collectionView:draggingSession:willBeginAtPoint:forItemsAtIndexPaths:)
    public func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        
    }

    @objc(collectionView:draggingSession:endedAtPoint:dragOperation:)
    public func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        
    }

    public func collectionView(_ collectionView: NSCollectionView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
        
    }
    
}

// Selection & Transition Support
extension ListView {

    @objc(collectionView:shouldChangeItemsAtIndexPaths:toHighlightState:)
    public func collectionView(_ collectionView: NSCollectionView, shouldChangeItemsAt indexPaths: Set<IndexPath>, to highlightState: NSCollectionViewItemHighlightState) -> Set<IndexPath> {
        
    }
    
    @objc(collectionView:didChangeItemsAtIndexPaths:toHighlightState:)
    public func collectionView(_ collectionView: NSCollectionView, didChangeItemsAt indexPaths: Set<IndexPath>, to highlightState: NSCollectionViewItemHighlightState) {
        
    }
    
    @objc(collectionView:shouldSelectItemsAtIndexPaths:)
    public func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        
    }
    
    @objc(collectionView:shouldDeselectItemsAtIndexPaths:)
    public func collectionView(_ collectionView: NSCollectionView, shouldDeselectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        
    }
    
    @objc(collectionView:didSelectItemsAtIndexPaths:)
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
    }
    
    @objc(collectionView:didDeselectItemsAtIndexPaths:)
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        
    }
    
    @objc(collectionView:willDisplayItem:forRepresentedObjectAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        
    }
    
    @objc(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, willDisplaySupplementaryView view: NSView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
    }
    
    @objc(collectionView:didEndDisplayingItem:forRepresentedObjectAtIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, didEndDisplaying item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        
    }
    
    @objc(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)
    public func collectionView(_ collectionView: NSCollectionView, didEndDisplayingSupplementaryView view: NSView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: NSCollectionView, transitionLayoutForOldLayout fromLayout: NSCollectionViewLayout, newLayout toLayout: NSCollectionViewLayout) -> NSCollectionViewTransitionLayout {
        
    }
}*/

/*
// Essential Support
extension ListView: NSExtendedTableViewDelegate {
	
	@objc(numberOfRowsInTableView:)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return self.dataSource.count //+ (self.headerView != nil ? 1 : 0) + (self.footerView != nil ? 1 : 0)
	}
	
	public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return CGFloat(self.sizeClass.calculate {
			let cellClass = (self.viewClassProvider?(row) ?? ListViewCell.self)
			return cellClass.cellHeight(forWidth: self.bounds.size.width, cellValue: self.dataSource[row]).native
		})
	}
	
	public func tableViewColumnDidResize(_ notification: Notification) {
		NSAnimationContext.beginGrouping()
		NSAnimationContext.current().duration = 0
		let set = IndexSet(integersIn: 0..<self.dataSource.count)
		tableView.noteHeightOfRows(withIndexesChanged: set)
		NSAnimationContext.endGrouping()
	}
	
	public func tableViewDidScroll(_ notification: Notification) {
		guard let o = notification.object as? NSView , o == self.scrollView.contentView else { return }
		if self.visibleRows.contains(0) {
			self.scrollbackProvider?(.top)
		}
		if self.visibleRows.contains(self.dataSource.count - 1) {
			self.scrollbackProvider?(.bottom)
		}
	}
	
	public func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
		//log.info("Unimplemented \(__FUNCTION__)")
		return false
	}
	
	public func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		return self.rowActionProvider?(row, edge) ?? []
	}
	
	@objc(tableView:viewForTableColumn:row:)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cellClass = self.viewClassProvider?(row) ?? ListViewCell.self
		var view = self.collectionView.make(withIdentifier: cellClass.className(), owner: self) as? ListViewCell
		if view == nil {
			log.warning("Cell class \(cellClass) not registered!")
			view = cellClass.init(frame: .zero)
			view!.identifier = cellClass.className()
		}
		
		view!.cellValue = self.dataSource[row]
		//tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integer: row))
		return view
	}
	
	public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
		//log.info("Unimplemented \(__FUNCTION__)")
		return nil // no default row yet
	}
	
	@objc(tableView:didAddRowView:forRow:)
	public func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
		//log.info("Unimplemented \(__FUNCTION__)")
		rowView.canDrawSubviewsIntoLayer = true
		rowView.isEmphasized = false
	}
	
	@objc(tableView:didRemoveRowView:forRow:)
	public func tableView(_ tableView: NSTableView, didRemove rowView: NSTableRowView, forRow row: Int) {
		//log.info("Unimplemented \(__FUNCTION__)")
	}
}

// Selection Support
extension ListView /*: NSExtendedTableViewDelegate*/ {
	
	@objc(selectionShouldChangeInTableView:)
	public func selectionShouldChange(in tableView: NSTableView) -> Bool {
		return self.selectionProvider != nil
	}
	
	public func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
		log.info("Unimplemented \(#function)")
		return proposedSelectionIndexes
	}
	
	public func tableViewSelectionDidChange(_ notification: Notification) {
		self.selectionProvider?(self.collectionView.selectedRow)
	}
	
	public func tableViewSelectionIsChanging(_ notification: Notification) {
		log.info("Unimplemented \(#function)")
	}
	
	public func tableView(_ tableView: NSTableView, menuForRows rows: IndexSet) -> NSMenu? {
		return self.menuProvider?(rows.map { $0 })
	}
	
	public func tableView(_: NSTableView, didClickRow row: Int) {
		self.clickedRowProvider?(row)
	}
}

*/
