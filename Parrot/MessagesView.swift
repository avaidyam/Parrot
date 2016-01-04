import Cocoa

/* TODO: Migrate multi-management of views into this. */

class MessagesView: NSView, NSTableViewDataSource, NSTableViewDelegate {
	
}

// Essential Support
extension MessagesView {
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return 0
	}
	
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 1.0
	}
	
	func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
		return false
	}
	
	func tableView(tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		return []
	}
	
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		return nil
	}
	
	func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
		return nil
	}
	
	func tableView(tableView: NSTableView, didAddRowView rowView: NSTableRowView, forRow row: Int) {
		
	}
	
	func tableView(tableView: NSTableView, didRemoveRowView rowView: NSTableRowView, forRow row: Int) {
		
	}
}

// Selection Support
extension MessagesView {
	
	func selectionShouldChangeInTableView(tableView: NSTableView) -> Bool {
		return false
	}
	
	func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
		return proposedSelectionIndexes
	}
	
	func tableViewSelectionDidChange(notification: NSNotification) {
		
	}
	
	func tableViewSelectionIsChanging(notification: NSNotification) {
		
	}
}

// Drag & Drop Support
extension MessagesView {
	
	func tableView(tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
		return nil
	}
	
	func tableView(tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAtPoint screenPoint: NSPoint, forRowIndexes rowIndexes: NSIndexSet) {
		
	}
	
	func tableView(tableView: NSTableView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, operation: NSDragOperation) {
		
	}
	
	func tableView(tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
		
	}
	
	func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool {
		return false
	}
	
	func tableView(tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
		return .None
	}
	
	func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
		return false
	}
	
	func tableView(tableView: NSTableView, namesOfPromisedFilesDroppedAtDestination dropDestination: NSURL, forDraggedRowsWithIndexes indexSet: NSIndexSet) -> [String] {
		return []
	}
}