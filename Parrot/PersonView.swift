import Cocoa

/* TODO: Design completely in code, replacing IB usage. */

// Serves as the "model" behind the view. Technically speaking, this is a translation
// layer between the application model and decouples it from the view.
public struct Person {
	var photo: NSImage
	var highlight: NSColor
	var indicator: Bool
	
	var primary: String
	var secondary: String
	var tertiary: String
}

// A general person view
public class PersonView : NSTableCellView {
	
	// Wired up in Interface Builder.
	@IBOutlet weak var photoView: NSImageView?
	@IBOutlet weak var nameLabel: NSTextField?
    @IBOutlet weak var textLabel: NSTextField?
	@IBOutlet weak var timeLabel: NSTextField?
	@IBOutlet weak var indicator: NSView?
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: AnyObject? {
		didSet {
			guard let o = (self.objectValue as? Wrapper<Person>)?.element else {
				return
			}
			
			self.photoView?.image = o.photo
			self.photoView?.layer?.borderColor = o.highlight.CGColor
			self.nameLabel?.stringValue = o.primary
			self.textLabel?.stringValue = o.secondary
			self.timeLabel?.stringValue = o.tertiary
			self.indicator?.hidden = o.indicator
			
			self.textLabel?.font = NSFont.systemFontOfSize(self.textLabel!.font!.pointSize,
				weight: o.indicator ? NSFontWeightBold : NSFontWeightRegular)
		}
	}
	
	// Upon selection, make all the text visible, and restore it when unselected.
	public override var backgroundStyle: NSBackgroundStyle {
		didSet {
			if self.backgroundStyle == .Light {
				self.nameLabel?.textColor = NSColor.labelColor()
				self.textLabel?.textColor = NSColor.secondaryLabelColor()
				self.timeLabel?.textColor = NSColor.tertiaryLabelColor()
			} else if self.backgroundStyle == .Dark {
				self.nameLabel?.textColor = NSColor.alternateSelectedControlTextColor()
				self.textLabel?.textColor = NSColor.alternateSelectedControlTextColor()
				self.timeLabel?.textColor = NSColor.alternateSelectedControlTextColor()
			}
		}
	}
	
	// Dynamically adjust subviews based on the indicated row size.
	// Technically should be unimplemented, as AutoLayout does this for free.
	public override var rowSizeStyle: NSTableViewRowSizeStyle {
		didSet {
			// FIXME: What do we do here?
		}
	}
	
	// Return an array of all dragging components corresponding to our subviews.
	public override var draggingImageComponents: [NSDraggingImageComponent] {
		get {
			return [
				self.photoView!.draggingComponent("Photo"),
				self.nameLabel!.draggingComponent("Name"),
				self.textLabel!.draggingComponent("Text"),
				self.timeLabel!.draggingComponent("Time"),
			]
		}
	}
	
	// Allows the circle crop to dynamically change.
	public override func layout() {
		super.layout()
		if let layer = self.photoView?.layer {
			layer.masksToBounds = true
			layer.borderWidth = 2.0
			layer.cornerRadius = self.photoView!.bounds.width / 2.0
		}
	}
}
