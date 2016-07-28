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
	
	let output = _imgCache[user.identifier]
	guard output == nil else { return output! }
	
	// 1. If we can find or cache the photo URL, return that.
	// 2. If no photo URL can be used, and the name exists, create a monogram image.
	// 3. If a monogram is not possible, use the default image mask.
	
	var img: NSImage! = nil
	if let d = fetchData(user.identifier, user.photoURL) {
		img = NSImage(data: d)!
	} else if let _ = user.fullName.rangeOfCharacter(from: .letters, options: []) {
		img = imageForString(forString: user.fullName)
	} else {
		img = defaultImageForString(forString: user.fullName)
	}
	
	_imgCache[user.identifier] = img
	return img
}
public func fetchImage(user: Person) -> NSImage {
	
	let output = _imgCache[user.identifier]
	guard output == nil else { return output! }
	
	var img: NSImage! = nil
	if let d = fetchData(user.identifier, user.photoURL) {
		img = NSImage(data: d)!
	} else {
		img = defaultImageForString(forString: user.fullName)
	}
	
	_imgCache[user.identifier] = img
	return img
}

private var _linkCache = [String: LinkPreviewType]()
public func _getLinkCached(_ key: String) throws -> LinkPreviewType {
	if let val = _linkCache[key] {
		return val
	} else {
		do {
			let val = try LinkPreviewParser.parse(key)
			_linkCache[key] = val
			log.info("parsed link => \(val)")
			return val
		} catch { throw error }
	}
}
