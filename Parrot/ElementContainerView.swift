import Cocoa

/* TODO: Rewrite to use associatedtype Element and Container as protocol-style. */

/// Provides default size classes for displayed elements of a list.
/// Any of the provided classes have an associated size.
/// However, .Dynamic implies that the size class will be computed
/// at runtime based on the runtime size of the list elements.
public enum SizeClass {
	case XSmall// = 16.0
	case Small// = 32.0
	case Medium// = 48.0
	case Large// = 64.0
	case XLarge// = 96.0
	case Custom(Double)
	case Dynamic
	
	var size: Double {
		switch self {
		case .XSmall: return 16.0
		case .Small: return 32.0
		case .Medium: return 48.0
		case .Large: return 64.0
		case .XLarge: return 96.0
		case .Custom(let value): return value
		case .Dynamic: return 0.0
		}
	}
	
	func calculate(_ dynamic: (() -> Double)?) -> Double {
		switch self {
		case .Dynamic where dynamic != nil: return dynamic!()
		default: return self.size
		}
	}
}

/// Provides selection capabilities for selectable elements of a list.
/// .None implies no user selection capability.
/// .One implies single element user selection capability.
/// .Any implies multiple element user selection capability.
public enum SelectionCapability {
	case None
	case One
	case Any
}

/// Generic container type for any view presenting a list of elements.
/// In subclassing, modify the Element and Container aliases.
/// This way, a lot of behavior will be defaulted, unless custom behavior is needed.
public class ElementContainerView: NSView, NSTableViewDataSource, NSTableViewDelegate, NSTableViewContextMenuDelegate {
	internal var scrollView: NSScrollView!
	internal var tableView: NSTableView!
	
	// Override and patch in the default initializers to our init.
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.commonInit()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.commonInit()
	}
	
	internal func commonInit() {
		self.dataSource = []
		
		self.scrollView = NSScrollView(frame: self.bounds)
		self.tableView = NSTableView(frame: self.scrollView.bounds)
		
		self.tableView.setDelegate(self)
		self.tableView.setDataSource(self)
		
		let col = NSTableColumn(identifier: "")
		col.resizingMask = .autoresizingMask
		self.tableView.addTableColumn(col)
		self.tableView.headerView = nil
		self.tableView.menu = NSMenu(title: "")
		
		self.scrollView.drawsBackground = false
		self.scrollView.borderType = .noBorder
		self.tableView.allowsEmptySelection = true
		self.tableView.selectionHighlightStyle = .sourceList
		self.tableView.floatsGroupRows = true
		self.tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
		
		self.scrollView.documentView = self.tableView
		self.scrollView.hasVerticalScroller = true
		self.addSubview(self.scrollView)
		
		self.scrollView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
		self.tableView.sizeLastColumnToFit()
	}
	
	internal func createView() -> NSTableCellView {
		var view = tableView.make(withIdentifier: NSTableCellView.className(), owner: self) as? NSTableCellView
		if view == nil {
			view = NSTableCellView(frame: NSZeroRect)
			view!.identifier = NSTableCellView.className()
		}
		return view!
	}
	
	public var sizeClass: SizeClass = .Large
	public var selectionCapability: SelectionCapability = .None
	public var updateScrollsToBottom = true
	
	// Allow accessing the insets from the scroll view.
	public var insets: NSEdgeInsets {
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
	
	/* TODO: Monitor actual addition/removal changes. */
	public var dataSource: [Wrapper<Any>]! {
		didSet { UI {
			self.tableView.reloadData()
			let row = self.updateScrollsToBottom ? self.numberOfRows(in: self.tableView) - 1 : 0
			self.tableView.scrollRowToVisible(row)
		}}
	}
	
	/*
	// If you REALLY want animations, use this to append a set of elements.
	public func appendElements(elements: [Element]) {
		self.dataSource.appendContentsOf(elements)
		
		UI { self.tableView.beginUpdates() }
		elements.forEach {
			let idx = NSIndexSet(index: self.dataSource.indexOf($0)!)
			self.tableView.insertRowsAtIndexes(idx, withAnimation: [.EffectFade, .SlideUp])
		}
		UI { self.tableView.endUpdates() }
	}
	
	// If you REALLY want animations, use this to remove a set of elements.
	// Note: this is arbitrary removal, not sequential removal, like appendElements().
	public func removeElements(elements: [Element]) {
		UI { self.tableView.beginUpdates() }
		elements.forEach {
			if let i = self.dataSource.indexOf($0) {
				self.tableView.removeRowsAtIndexes(NSIndexSet(index: i), withAnimation: [.EffectFade, .SlideUp])
			}
		}
		UI { self.tableView.endUpdates() }
		
		self.dataSource.removeContentsOf(elements)
	}*/
	
	public var selection: [Int] {
		return self.tableView.selectedRowIndexes.map { $0 }
	}
	
	public var dynamicHeightProvider: ((row: Int) -> Double)? = nil
	public var selectionProvider: ((row: Int) -> Void)? = nil
	public var rowActionProvider: ((row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction])? = nil
	public var menuProvider: ((row: Int) -> NSMenu?)? = nil
}

// Essential Support
public extension ElementContainerView {
	
	@objc(numberOfRowsInTableView:)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return self.dataSource.count
	}
	
	/* TODO: Support size classes. */
	public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return CGFloat(self.sizeClass.calculate {
			self.dynamicHeightProvider?(row: row) ?? 0
		})
	}
	
	public func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
		//Swift.print("Unimplemented \(__FUNCTION__)")
		return false
	}
	
	public func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		return self.rowActionProvider?(row: row, edge: edge) ?? []
	}
	
	@objc(tableView:viewForTableColumn:row:)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let view = createView()
		view.objectValue = self.dataSource[row]
		return view
	}
	
	public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
		//Swift.print("Unimplemented \(__FUNCTION__)")
		return nil // no default row yet
	}
	
	@objc(tableView:didAddRowView:forRow:)
	public func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
		//Swift.print("Unimplemented \(__FUNCTION__)")
		rowView.isEmphasized = false
	}
	
	@objc(tableView:didRemoveRowView:forRow:)
	public func tableView(_ tableView: NSTableView, didRemove rowView: NSTableRowView, forRow row: Int) {
		//Swift.print("Unimplemented \(__FUNCTION__)")
	}
}

// Selection Support
public extension ElementContainerView {
	
	@objc(selectionShouldChangeInTableView:)
	public func selectionShouldChange(in tableView: NSTableView) -> Bool {
		return self.selectionProvider != nil
	}
	
	public func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
		Swift.print("Unimplemented \(#function)")
		return proposedSelectionIndexes
	}
	
	public func tableViewSelectionDidChange(_ notification: NSNotification) {
		self.selectionProvider?(row: self.tableView.selectedRow)
	}
	
	public func tableViewSelectionIsChanging(_ notification: NSNotification) {
		Swift.print("Unimplemented \(#function)")
	}
	
	public func tableView(_ tableView: NSTableView, menuForRows rows: NSIndexSet) -> NSMenu? {
		let i = rows.map { $0 }
		Swift.print("menu opened! \(i)")
		let menu = NSMenu(title: "Items")
		menu.addItem(withTitle: "Got \(i)", action: nil, keyEquivalent: "")
		return menu
	}
}

// Drag & Drop Support
public extension ElementContainerView {
	
	public func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
		Swift.print("Unimplemented \(#function)")
		return nil
	}
	
	@objc(tableView:draggingSession:willBeginAtPoint:forRowIndexes:)
	public func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: NSIndexSet) {
		Swift.print("Unimplemented \(#function)")
	}
	
	@objc(tableView:draggingSession:endedAtPoint:operation:)
	public func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
		Swift.print("Unimplemented \(#function)")
	}
	
	public func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
		Swift.print("Unimplemented \(#function)")
	}
	
	public func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
		Swift.print("Unimplemented \(#function)")
		return []
	}
	
	public func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
		Swift.print("Unimplemented \(#function)")
		return false
	}
	
	@objc(tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes:)
	public func tableView(_ tableView: NSTableView, namesOfPromisedFilesDroppedAtDestination dropDestination: NSURL, forDraggedRowsWith indexSet: NSIndexSet) -> [String] {
		Swift.print("Unimplemented \(#function)")
		return []
	}
}

// Support for per-row and multi-select menus.
@objc public protocol NSTableViewContextMenuDelegate {
	@objc(tableView:menuForRows:)
	func tableView(_: NSTableView, menuForRows: NSIndexSet) -> NSMenu?
}
public extension NSTableView {
	
	// Support for per-row and multi-select menus.
	public override func menu(for event: NSEvent) -> NSMenu? {
		let loc = self.convert(event.locationInWindow, from: nil)
		let row = self.row(at: loc)
		guard row >= 0 && event.type == .rightMouseDown else {
			return super.menu(for: event)
		}
		
		var selected = self.selectedRowIndexes
		if !selected.contains(row) {
			selected = NSIndexSet(index: row)
			self.selectRowIndexes(selected, byExtendingSelection: false)
		}
		
		if let d = self.delegate() as? NSTableViewContextMenuDelegate {
			return d.tableView(self, menuForRows: selected)
		}
		return super.menu(for: event)
	}
}
