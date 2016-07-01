import Foundation

let listener = NSXPCListener.service()
listener.delegate = ParrotProvider()
listener.resume()
