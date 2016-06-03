import Cocoa

// Extensions to easily create labels and views without a frame.
public typealias NSLabel = NSTextField

public extension NSView {
	public convenience init(_ layerBacked: Bool) {
		self.init(frame: NSZeroRect)
		self.wantsLayer = layerBacked
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}

public extension NSTextField {
	public convenience init(_ layerBacked: Bool, _ singleLine: Bool) {
		self.init(layerBacked)
		self.isBezeled = false
		self.isBordered = false
		self.isEditable = false
		self.isSelectable = false
		self.drawsBackground = false
		self.usesSingleLineMode = singleLine
		self.allowsEditingTextAttributes = false
	}
}
