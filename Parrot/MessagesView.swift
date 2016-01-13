import Cocoa

/* TODO: Migrate multi-management of views into this. */
/* TODO: Generics would be *so* nice, but IBOutlets don't work then. */

public class MessagesView: NSView, NSTableViewDataSource, NSTableViewDelegate {
	
	private var scrollView: NSScrollView!
	private var tableView: NSTableView!
	
	// Override and patch in the default initializers to our init.
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.commonInit()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.commonInit()
	}
	
	func commonInit() {
		self.dataSource = []
		
		self.scrollView = NSScrollView(frame: self.bounds)
		self.tableView = NSTableView(frame: self.scrollView.bounds)
		
		self.tableView.setDelegate(self)
		self.tableView.setDataSource(self)
		
		let col = NSTableColumn(identifier: "")
		col.resizingMask = .AutoresizingMask
		self.tableView.addTableColumn(col)
		self.tableView.headerView = nil
		
		self.scrollView.drawsBackground = false
		self.scrollView.borderType = .NoBorder
		self.tableView.allowsEmptySelection = true
		self.tableView.selectionHighlightStyle = .SourceList
		self.tableView.floatsGroupRows = true
		self.tableView.columnAutoresizingStyle = .UniformColumnAutoresizingStyle
		
		self.scrollView.documentView = self.tableView
		self.scrollView.hasVerticalScroller = true
		self.addSubview(self.scrollView)
		
		self.scrollView.autoresizingMask = [.ViewHeightSizable, .ViewWidthSizable]
		self.tableView.sizeLastColumnToFit()
	}
	
	// Allow accessing the insets from the scroll view.
	public var insets: NSEdgeInsets {
		get {
			return self.scrollView.contentInsets
		}
		set {
			self.scrollView.contentInsets = newValue
		}
	}
	
	// Forward the layer-backing down to our subviews.
	public override var wantsLayer: Bool {
		didSet {
			self.scrollView.wantsLayer = self.wantsLayer
			self.tableView.wantsLayer = self.wantsLayer
		}
	}
	
	/* TODO: My life is a struggle. Abort animations. :( */
	public var dataSource: [Message]! {
		didSet {
			UI {
				self.tableView.reloadData()
				self.tableView.scrollRowToVisible(self.numberOfRowsInTableView(self.tableView) - 1)
			}
		}
	}
	
	// If you REALLY want animations, use this to append a set of elements.
	public func appendElements(elements: [Message]) {
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
	public func removeElements(elements: [Message]) {
		UI { self.tableView.beginUpdates() }
		elements.forEach {
			if let i = self.dataSource.indexOf($0) {
				self.tableView.removeRowsAtIndexes(NSIndexSet(index: i), withAnimation: [.EffectFade, .SlideUp])
			}
		}
		UI { self.tableView.endUpdates() }
		
		self.dataSource.removeContentsOf(elements)
	}
	
	public var rowActionProvider: ((row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction])? = nil
}

// Essential Support
public extension MessagesView {
	
	public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return self.dataSource.count
	}
	
	public func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return MessageView.heightForContainerWidth(self.dataSource[row].string, width: self.frame.width)
	}
	
	public func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
		return false // Messages can't be grouped!
	}
	
	public func tableView(tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		return self.rowActionProvider?(row: row, edge: edge) ?? []
	}
	
	public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		var view = tableView.makeViewWithIdentifier(MessageView.className(), owner: self) as? MessageView
		if view == nil {
			view = MessageView(frame: NSZeroRect)
			view!.identifier = MessageView.className()
		}
		
		view!.objectValue = Wrapper<Message>(self.dataSource[row])
		return view
	}
	
	public func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
		return nil // no default row yet
	}
	
	public func tableView(tableView: NSTableView, didAddRowView rowView: NSTableRowView, forRow row: Int) {
		// Intentionally Unimplemented
		rowView.emphasized = false
	}
	
	public func tableView(tableView: NSTableView, didRemoveRowView rowView: NSTableRowView, forRow row: Int) {
		// Intentionally Unimplemented
	}
}

// Selection Support
public extension MessagesView {
	
	public func selectionShouldChangeInTableView(tableView: NSTableView) -> Bool {
		Swift.print("Unimplemented \(__FUNCTION__)")
		return false
	}
	
	public func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
		Swift.print("Unimplemented \(__FUNCTION__)")
		return proposedSelectionIndexes
	}
	
	public func tableViewSelectionDidChange(notification: NSNotification) {
		Swift.print("Unimplemented \(__FUNCTION__)")
	}
	
	public func tableViewSelectionIsChanging(notification: NSNotification) {
		Swift.print("Unimplemented \(__FUNCTION__)")
	}
}

// Drag & Drop Support
public extension MessagesView {
	
	public func tableView(tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
		Swift.print("Unimplemented \(__FUNCTION__)")
		return nil
	}
	
	public func tableView(tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAtPoint screenPoint: NSPoint, forRowIndexes rowIndexes: NSIndexSet) {
		Swift.print("Unimplemented \(__FUNCTION__)")
	}
	
	public func tableView(tableView: NSTableView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, operation: NSDragOperation) {
		Swift.print("Unimplemented \(__FUNCTION__)")
	}
	
	public func tableView(tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
		Swift.print("Unimplemented \(__FUNCTION__)")
	}
	
	public func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool {
		Swift.print("Unimplemented \(__FUNCTION__)")
		return false
	}
	
	public func tableView(tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
		Swift.print("Unimplemented \(__FUNCTION__)")
		return .None
	}
	
	public func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
		Swift.print("Unimplemented \(__FUNCTION__)")
		return false
	}
	
	public func tableView(tableView: NSTableView, namesOfPromisedFilesDroppedAtDestination dropDestination: NSURL, forDraggedRowsWithIndexes indexSet: NSIndexSet) -> [String] {
		Swift.print("Unimplemented \(__FUNCTION__)")
		return []
	}
}
