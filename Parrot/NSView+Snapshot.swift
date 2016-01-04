import Cocoa

public extension NSView {
	
	// Snapshots the view as it exists and return an NSImage of it.
	func snapshot() -> NSImage {
		
		// First get the bitmap representation of the view.
		let rep = self.bitmapImageRepForCachingDisplayInRect(self.bounds)!
		self.cacheDisplayInRect(self.bounds, toBitmapImageRep: rep)
		
		// Stuff the representation into an NSImage.
		let snapshot = NSImage(size: rep.size)
		snapshot.addRepresentation(rep)
		return snapshot
	}
	
	// Automatically translate a view into a NSDraggingImageComponent
	func draggingComponent(key: String) -> NSDraggingImageComponent {
		let component = NSDraggingImageComponent(key: key)
		component.contents = self.snapshot()
		component.frame = self.convertRect(self.bounds, fromView: self)
		return component
	}
}

// Can hold any non-object type as an object type.
public class Wrapper<T> {
	let element: T
	init(_ element: T) {
		self.element = element
	}
}
