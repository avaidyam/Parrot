import Foundation

let listener = NSXPCListener.service()
listener.delegate = HangoutsProvider();
listener.resume()