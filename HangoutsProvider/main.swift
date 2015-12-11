import Foundation

let listener = NSXPCListener.serviceListener()
listener.delegate = HangoutsProvider();
listener.resume()