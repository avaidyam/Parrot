import Foundation
import AppKit
import Hangouts
import ParrotServiceExtension

//severity: Logger.Severity(rawValue: Process.arguments["log_level"]) ?? .verbose
internal let log = Logger(subsystem: "com.avaidyam.Parrot.global")
public let defaultUserImage = NSImage(named: "NSUserGuest")!

// Existing Parrot Settings keys.
public final class Parrot {
	public static let InterfaceStyle = "Parrot.InterfaceStyle"
	public static let SystemInterfaceStyle = "Parrot.SystemInterfaceStyle"
	public static let DisableTranslucency = "Parrot.DisableTranslucency"
	
	public static let AutoEmoji = "Parrot.AutoEmoji"
	public static let InvertChatStyle = "Parrot.InvertChatStyle"
	public static let ShowSidebar = "Parrot.ShowSidebar"
	
	public static let VibrateForceTouch = "Parrot.VibrateForceTouch"
	public static let VibrateInterval = "Parrot.VibrateInterval"
	public static let VibrateLength = "Parrot.VibrateLength"
}

private var _imgCache = [String: NSImage]()
public func fetchImage(user: Person, conversation: ParrotServiceExtension.Conversation) -> NSImage {
	
	// FIXME: FORCE-CAST TO HANGOUTS
	func getNetwork(_ conversation: ParrotServiceExtension.Conversation) -> NetworkType {
		let qqqq = conversation as! Hangouts.IConversation
		return NetworkType(rawValue: (qqqq.conversation.networkType)[0].rawValue)!
	}
	
	let output = _imgCache[user.identifier]
	guard output == nil else { return output! }
	
	var img: NSImage! = nil
	if let d = fetchData(user.identifier, user.photoURL) {
		img = NSImage(data: d)!
	} else if getNetwork(conversation) != .GoogleVoice {
		img = imageForString(forString: user.fullName)
	} else {
		img = defaultImageForString(forString: user.fullName)
	}
	
	_imgCache[user.identifier] = img
	return img
}
