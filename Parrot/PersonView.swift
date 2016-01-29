import Cocoa

/* TODO: Fix NSLayoutConstraints that tend to "not work" until resized. */

// Serves as the "model" behind the view. Technically speaking, this is a translation
// layer between the application model and decouples it from the view.
public struct Person: Equatable {
	var photo: NSImage
	var highlight: NSColor
	var indicator: Bool
	
	var primary: String
	var secondary: String
	var tertiary: String
}

// Person: Equatable
public func ==(lhs: Person, rhs: Person) -> Bool {
	return lhs.primary == rhs.primary &&
		lhs.secondary == rhs.secondary &&
		lhs.tertiary == rhs.tertiary
}

// A general person view
public class PersonView : NSTableCellView {
	
	var photoView: NSImageView
	var nameLabel: NSLabel
	var textLabel: NSLabel
	var timeLabel: NSLabel
	var indicator: NSView
	
	public override init(frame: NSRect) {
		self.photoView = NSImageView(true)
		self.photoView.imageScaling = .ScaleProportionallyDown
		
		self.nameLabel = NSLabel(true, false)
		self.nameLabel.textColor = NSColor.labelColor()
		self.nameLabel.lineBreakMode = .ByTruncatingTail
		self.nameLabel.font = NSFont.systemFontOfSize(13.0, weight: NSFontWeightSemibold)
		
		self.textLabel = NSLabel(true, true)
		self.textLabel.textColor = NSColor.secondaryLabelColor()
		self.textLabel.lineBreakMode = .ByWordWrapping
		self.textLabel.font = NSFont.systemFontOfSize(12.0, weight: NSFontWeightRegular)
		
		self.timeLabel = NSLabel(true, false)
		self.timeLabel.textColor = NSColor.tertiaryLabelColor()
		self.timeLabel.lineBreakMode = .ByClipping
		self.timeLabel.font = NSFont.systemFontOfSize(11.0, weight: NSFontWeightRegular)
		
		self.indicator = NSView(true)
		
		// Swift is funny like this.
		super.init(frame: frame)
		self.addSubview(self.photoView)
		self.addSubview(self.nameLabel)
		self.addSubview(self.textLabel)
		self.addSubview(self.timeLabel)
		self.addSubview(self.indicator)
		
		// Setup layout constraints.
		(photoView.leading == self.leading + 4.0)%
		(self.bottom == photoView.bottom + 4.0)%
		(photoView.centerY == self.centerY)%
		(photoView.top == self.top + 4.0)%
		(nameLabel.leading == photoView.trailing + 4.0)%
		(nameLabel.top == self.top + 4.0)%
		(textLabel.top == timeLabel.bottom + 4.0)%
		(textLabel.leading == photoView.trailing + 4.0)%
		(textLabel.top == nameLabel.bottom + 4.0)%
		(self.trailing == textLabel.trailing + 4.0)%
		(self.bottom == textLabel.bottom + 4.0)%
		(self.trailing == timeLabel.trailing + 4.0)%
		(timeLabel.leading == nameLabel.trailing + 4.0)%
		(timeLabel.top == self.top + 4.0)%
		(photoView.width == photoView.height * 1.0 ~ 1000)%
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Upon assignment of the represented object, configure the subview contents.
	public override var objectValue: AnyObject? {
		didSet {
			guard let o = (self.objectValue as? Wrapper<Any>)?.element as? Person else {
				return
			}
			
			self.photoView.image = o.photo
			self.photoView.layer?.borderColor = o.highlight.CGColor
			self.nameLabel.stringValue = o.primary
			self.textLabel.stringValue = o.secondary
			self.timeLabel.stringValue = o.tertiary
			self.indicator.hidden = o.indicator
			
			self.textLabel.font = NSFont.systemFontOfSize(self.textLabel.font!.pointSize,
				weight: o.indicator ? NSFontWeightBold : NSFontWeightRegular)
		}
	}
	
	// Upon selection, make all the text visible, and restore it when unselected.
	// NOTE: If the rowView isn't emphasized, the colors will look odd because of blending.
	public override var backgroundStyle: NSBackgroundStyle {
		didSet {
			if self.backgroundStyle == .Light {
				self.nameLabel.textColor = NSColor.labelColor()
				self.textLabel.textColor = NSColor.secondaryLabelColor()
				self.timeLabel.textColor = NSColor.tertiaryLabelColor()
			} else if self.backgroundStyle == .Dark {
				self.nameLabel.textColor = NSColor.alternateSelectedControlTextColor()
				self.textLabel.textColor = NSColor.alternateSelectedControlTextColor()
				self.timeLabel.textColor = NSColor.alternateSelectedControlTextColor()
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
				self.photoView.draggingComponent("Photo"),
				self.nameLabel.draggingComponent("Name"),
				self.textLabel.draggingComponent("Text"),
				self.timeLabel.draggingComponent("Time"),
			]
		}
	}
	
	// Allows the circle crop to dynamically change.
	public override func layout() {
		super.layout()
		if let layer = self.photoView.layer {
			layer.masksToBounds = true
			layer.borderWidth = 2.0
			layer.cornerRadius = self.photoView.bounds.width / 2.0
		}
	}
}

public class PersonsView: ElementContainerView {
	internal override func createView() -> PersonView {
		var view = self.tableView.makeViewWithIdentifier(PersonView.className(), owner: self) as? PersonView
		if view == nil {
			view = PersonView(frame: NSZeroRect)
			view!.identifier = PersonView.className()
		}
		return view!
	}
}
