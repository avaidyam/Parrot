import AppKit

/*

#define MAX_RESULTS 10

#define HIGHLIGHT_STROKE_COLOR [NSColor selectedMenuItemColor]
#define HIGHLIGHT_FILL_COLOR [NSColor selectedMenuItemColor]
#define HIGHLIGHT_RADIUS 0.0
#define INTERCELL_SPACING NSMakeSize(20.0, 3.0)

#define WORD_BOUNDARY_CHARS [[NSCharacterSet alphanumericCharacterSet] invertedSet]

#define POPOVER_WIDTH 250.0
#define POPOVER_PADDING 0.0

//#define POPOVER_APPEARANCE NSAppearanceNameVibrantDark
#define POPOVER_APPEARANCE NSAppearanceNameVibrantLight

#define POPOVER_FONT [NSFont fontWithName:@"Menlo" size:12.0]
// The font for the characters that have already been typed
#define POPOVER_BOLDFONT [NSFont fontWithName:@"Menlo-Bold" size:13.0]
#define POPOVER_TEXTCOLOR [NSColor blackColor]

*/

private class AutocompleteListView: ListView {
	private class InternalRowView: NSTableRowView {
		private override func drawSelection(in dirtyRect: NSRect) {
			guard self.selectionHighlightStyle != .none else { return }
			
			let selection = NSInsetRect(self.bounds, 0.5, 0.5)
			NSColor.selectedMenuItemColor().setStroke()
			NSColor.selectedMenuItemColor().setFill()
			let bezier = NSBezierPath(roundedRect: selection, xRadius: 0, yRadius: 0)
			bezier.fill()
			bezier.stroke()
		}
		private override var interiorBackgroundStyle: NSBackgroundStyle {
			return self.isSelected ? .dark : .light
		}
	}
	
	var createViewProvider: (() -> NSTableCellView)? = nil
	
	private override func createView() -> NSTableCellView {
		var view = tableView.make(withIdentifier: NSTableCellView.className(), owner: self) as? NSTableCellView
		if let p = self.createViewProvider where view == nil {
			view = p()
			view!.identifier = NSTableCellView.className()
		}
		return view!
	}
	
	private override func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
		return InternalRowView()
	}
}

public class AdvancedTextView: NSTextView {
	
	private lazy var list: AutocompleteListView = {
		let c = AutocompleteListView()
		c.createViewProvider = {
			let cell = NSTableCellView(frame: .zero)
			let text = NSTextField(frame: .zero)
			text.isBezeled = false
			text.drawsBackground = false
			text.isEditable = false
			text.isSelectable = false
			cell.addSubview(text)
			cell.textField = text
			return cell
		}
		return c
	}()
	
	private lazy var popover: NSPopover = {
		let vc = NSViewController()
		vc.view = self.list
		
		let p = NSPopover()
		p.appearance = self.appearance
		p.animates = false
		p.contentViewController = vc
		return p
	}()
	
	public override func keyDown(_ event: NSEvent) {
		//let row = self.list.tableView.selectedRow
		var shouldComplete = true
		switch event.keyCode {
		case 51: // Delete
			self.popover.close()
			shouldComplete = false
			break;
		case 53: // Esc
			if self.popover.isShown {
				self.popover.close()
			}
			return // Skip default behavior
		case 125: // Down
			if (self.popover.isShown) {
				//[self.list.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row+1] byExtendingSelection:NO];
				//[self.list.tableView scrollRowToVisible:self.autocompleteTableView.selectedRow];
				return; // Skip default behavior
			}
			break;
		case 126: // Up
			if (self.popover.isShown) {
				//[self.list.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row-1] byExtendingSelection:NO];
				//[self.list.tableView scrollRowToVisible:self.autocompleteTableView.selectedRow];
				return // Skip default behavior
			}
			break;
		case 36: // Return
			if (self.popover.isShown) {
				//self.insert(self)
				return // Skip default behavior
			}
		case 48: // Tab
			if (self.popover.isShown) {
				//self.insert(self)
				return // Skip default behavior
			}
		case 49: // Space
			if (self.popover.isShown) {
				self.popover.close()
			}
			break
		default: break
		}
		
		super.keyDown(event)
		if (shouldComplete) {
			self.complete(self)
		}
	}
	
	public override func complete(_ sender: AnyObject?) {
		//
	}
	
}
