import Foundation

/* TODO: Export Hangouts.framework as a wrapper service here. */

class HangoutsProvider : NSObject, NSXPCListenerDelegate {
	func listener(listener: NSXPCListener, connection: NSXPCConnection) -> Bool {
		connection.exportedInterface = NSXPCInterface(with: NSCoding.self)
		let exportedObject = NSNull()
		
		connection.exportedObject = exportedObject
		connection.resume()
		return true
	}
}
