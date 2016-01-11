import Cocoa

/* TODO: Migrate multi-management of views into this. */

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
		
		self.scrollView.drawsBackground = false
		self.scrollView.borderType = .NoBorder
		self.tableView.allowsEmptySelection = true
		self.tableView.selectionHighlightStyle = .SourceList
		self.tableView.floatsGroupRows = true
		self.tableView.columnAutoresizingStyle = .UniformColumnAutoresizingStyle
		
		self.scrollView.documentView = self.tableView
		self.scrollView.hasVerticalScroller = true
		self.addSubview(self.scrollView)
		
		self.tableView.sizeLastColumnToFit()
	}
	
	public var dataSource: [Message]! {
		willSet {
			Swift.print("setting!")
		}
		didSet {
			/* TODO: Monitor actual addition/removal changes. */
			Dispatch.main().add {
				self.tableView.reloadData()
			}
		}
	}
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
		return false
	}
	
	public func tableView(tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		return []
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
		return nil
	}
	
	public func tableView(tableView: NSTableView, didAddRowView rowView: NSTableRowView, forRow row: Int) {
		
	}
	
	public func tableView(tableView: NSTableView, didRemoveRowView rowView: NSTableRowView, forRow row: Int) {
		
	}
}

// Selection Support
public extension MessagesView {
	
	public func selectionShouldChangeInTableView(tableView: NSTableView) -> Bool {
		return false
	}
	
	public func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
		return proposedSelectionIndexes
	}
	
	public func tableViewSelectionDidChange(notification: NSNotification) {
		
	}
	
	public func tableViewSelectionIsChanging(notification: NSNotification) {
		
	}
}

// Drag & Drop Support
public extension MessagesView {
	
	public func tableView(tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
		return nil
	}
	
	public func tableView(tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAtPoint screenPoint: NSPoint, forRowIndexes rowIndexes: NSIndexSet) {
		
	}
	
	public func tableView(tableView: NSTableView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, operation: NSDragOperation) {
		
	}
	
	public func tableView(tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
		
	}
	
	public func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool {
		return false
	}
	
	public func tableView(tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
		return .None
	}
	
	public func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
		return false
	}
	
	public func tableView(tableView: NSTableView, namesOfPromisedFilesDroppedAtDestination dropDestination: NSURL, forDraggedRowsWithIndexes indexSet: NSIndexSet) -> [String] {
		return []
	}
}