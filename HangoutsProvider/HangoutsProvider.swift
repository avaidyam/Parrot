import Foundation

/* TODO: Export Hangouts.framework as a wrapper service here. */

class HangoutsProvider : NSObject, NSXPCListenerDelegate {
	func listener(listener: NSXPCListener, connection: NSXPCConnection) -> Bool {
		connection.exportedInterface = NSXPCInterface(withProtocol: NSCoding.self)
		let exportedObject = NSNull()
		
		connection.exportedObject = exportedObject
		connection.resume()
		return true
	}
}
