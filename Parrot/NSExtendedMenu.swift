import AppKit

public class MenuItem: NSMenuItem {
	private var handler: () -> ()
	
	public init(title: String, keyEquivalent: String = "", handler: @escaping () -> ()) {
		self.handler = handler
		super.init(title: title, action: #selector(action(_:)), keyEquivalent: keyEquivalent)
		self.target = self
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc public func action(_ sender: AnyObject?) {
		self.handler()
	}
}

public extension NSMenu {
	
	@discardableResult
	public func addItem(title: String, keyEquivalent: String = "", handler: @escaping () -> ()) -> NSMenuItem {
		let item = MenuItem(title: title, keyEquivalent: keyEquivalent, handler: handler)
		self.addItem(item)
		return item
	}
}
