import AppKit

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

public class ListViewCell: NSTableCellView {
	public var cellValue: Any?
	public required override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	public class func cellHeight(forWidth: CGFloat, cellValue: Any?) -> CGFloat {
		return 0.0
	}
}

/// Generic container type for any view presenting a list of elements.
/// In subclassing, modify the Element and Container aliases.
/// This way, a lot of behavior will be defaulted, unless custom behavior is needed.
@IBDesignable
public class ListView: NSView {
	private var scrollView: NSScrollView!
	internal var tableView: NSExtendedTableView! // FIXME: Should be private...
	
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
		self.tableView = NSExtendedTableView(frame: self.scrollView.bounds)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		let col = NSTableColumn(identifier: "")
		col.resizingMask = .autoresizingMask
		col.isEditable = false
		self.tableView.addTableColumn(col)
		self.tableView.headerView = nil
		self.tableView.menu = NSMenu(title: "")
		
		self.scrollView.drawsBackground = false
		self.scrollView.borderType = .noBorder
		self.tableView.allowsEmptySelection = true
		self.tableView.selectionHighlightStyle = .sourceList
		self.tableView.floatsGroupRows = true
		self.tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
		self.tableView.intercellSpacing = NSSize(width: 0, height: 0)
		
		self.scrollView.documentView = self.tableView
		self.scrollView.hasVerticalScroller = true
		self.addSubview(self.scrollView)
		
		self.scrollView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
		self.tableView.sizeLastColumnToFit()
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
			self.tableView.wantsLayer = self.wantsLayer
		}
	}
	
	@IBInspectable
	public var rowSpacing: NSSize {
		get { return self.tableView.intercellSpacing }
		set { self.tableView.intercellSpacing = newValue }
	}
	
	/* TODO: Monitor actual addition/removal changes. */
	/*public var dataSource: [Wrapper<Any>]! {
		didSet { self.update() }
	}*/
	private var dataSource: [Any] {
		return self.dataSourceProvider?() ?? []
	}
	
	public func update() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
			switch self.updateScrollDirection {
			case .top: self.scroll(toRow: 0)
			case .bottom: self.scroll(toRow: self.dataSource.count - 1)
			}
		}
	}
	
	public func scroll(toRow: Int) {
		self.tableView.scrollRowToVisible(toRow)
	}
	
	public func register(nibName: String, forClass: ListViewCell.Type) {
		let nib = NSNib(nibNamed: nibName, bundle: nil)
		self.tableView.register(nib, forIdentifier: forClass.className())
	}
	
	public var selection: [Int] {
		return self.tableView.selectedRowIndexes.map { $0 }
	}
	
	public var visibleRows: [Int] {
		let r = self.tableView.rows(in: self.tableView.visibleRect)
		return Array(r.location..<r.location+r.length)
	}
	
	public var dataSourceProvider: (() -> [Any])? = nil
	public var viewClassProvider: ((row: Int) -> ListViewCell.Type)? = nil
	public var dynamicHeightProvider: ((row: Int) -> Double)? = nil
	public var clickedRowProvider: ((row: Int) -> Void)? = nil
	public var selectionProvider: ((row: Int) -> Void)? = nil
	public var rowActionProvider: ((row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction])? = nil
	public var menuProvider: ((rows: [Int]) -> NSMenu?)? = nil
	public var pasteboardProvider: ((row: Int) -> NSPasteboardItem?)? = nil
}

// Essential Support
extension ListView: NSExtendedTableViewDelegate {
	
	@objc(numberOfRowsInTableView:)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return self.dataSource.count
	}
	
	public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return CGFloat(self.sizeClass.calculate {
			let cellClass = (self.viewClassProvider?(row: row) ?? ListViewCell.self)
			return cellClass.cellHeight(forWidth: self.bounds.size.height, cellValue: self.dataSource[row]).native
		})
	}
	
	public func tableViewColumnDidResize(_ notification: Notification) {
		NSAnimationContext.beginGrouping()
		NSAnimationContext.current().duration = 0
		let set = IndexSet(integersIn: 0..<self.dataSource.count)
		tableView.noteHeightOfRows(withIndexesChanged: set)
		NSAnimationContext.endGrouping()
	}
	
	public func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
		//log.info("Unimplemented \(__FUNCTION__)")
		return false
	}
	
	public func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		return self.rowActionProvider?(row: row, edge: edge) ?? []
	}
	
	@objc(tableView:viewForTableColumn:row:)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cellClass = self.viewClassProvider?(row: row) ?? ListViewCell.self
		var view = self.tableView.make(withIdentifier: cellClass.className(), owner: self) as? ListViewCell
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
		self.selectionProvider?(row: self.tableView.selectedRow)
	}
	
	public func tableViewSelectionIsChanging(_ notification: Notification) {
		log.info("Unimplemented \(#function)")
	}
	
	public func tableView(_ tableView: NSTableView, menuForRows rows: IndexSet) -> NSMenu? {
		return self.menuProvider?(rows: rows.map { $0 })
	}
	
	public func tableView(_: NSTableView, didClickRow row: Int) {
		self.clickedRowProvider?(row: row)
	}
}

// Drag & Drop Support
extension ListView /*: NSExtendedTableViewDelegate*/ {
	
	public func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
		return self.pasteboardProvider?(row: row)
	}
	
	@objc(tableView:draggingSession:willBeginAtPoint:forRowIndexes:)
	public func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession,
	                      willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
		// BEGIN DRAG
	}
	
	@objc(tableView:draggingSession:endedAtPoint:operation:)
	public func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession,
	                      endedAt screenPoint: NSPoint, operation: NSDragOperation) {
		// END DRAG
	}
	
	public func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
		// Rely on the ListViewCell implementation
	}
	
	public func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int,
	                      proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
		log.info("Unimplemented \(#function)")
		return [.copy]
	}
	
	public func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo,
	                      row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
		log.info("Unimplemented \(#function)")
		return true
	}
}

// Support for per-row and multi-select menus.
@objc public protocol NSExtendedTableViewDelegate: NSTableViewDataSource, NSTableViewDelegate {
	@objc(tableView:menuForRows:)
	func tableView(_: NSTableView, menuForRows: IndexSet) -> NSMenu?
	@objc(tableView:didClickRow:)
	func tableView(_: NSTableView, didClickRow: Int)
}
public class NSExtendedTableView: NSTableView {
	
	// Support for per-row and multi-select menus.
	public override func menu(for event: NSEvent) -> NSMenu? {
		let loc = self.convert(event.locationInWindow, from: nil)
		let row = self.row(at: loc)
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
		//let view = self.view(atColumn: 0, row: row, makeIfNecessary: false)
		
		if let d = self.delegate as? NSExtendedTableViewDelegate {
			return d.tableView(self, menuForRows: selected)
		}
		return super.menu(for: event)
	}
	
	public override func mouseDown(_ event: NSEvent) {
		let loc = self.convert(event.locationInWindow, from: nil)
		let row = self.row(at: loc)
		
		super.mouseDown(event)
		if let d = self.delegate as? NSExtendedTableViewDelegate where row != -1 {
			d.tableView(self, didClickRow: row)
		}
	}
}

public protocol NSTableRowViewProviding {
	var selectionHighlightStyle: NSTableViewSelectionHighlightStyle { get }
	var isEmphasized: Bool { get }
	var isSelected: Bool { get }
	var backgroundColor: NSColor { get }
	
	var isTargetForDropOperation: Bool { get }
	var draggingDestinationFeedbackStyle: NSTableViewDraggingDestinationFeedbackStyle { get }
	var indentationForDropOperation: CGFloat { get }
	
	func drawBackground(in dirtyRect: NSRect)
	func drawSelection(in dirtyRect: NSRect)
	func drawSeparator(in dirtyRect: NSRect)
	func drawDraggingDestinationFeedback(in dirtyRect: NSRect)
}
