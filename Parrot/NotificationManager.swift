import Cocoa

/* TODO: Switch to a Disk LRU Cache instead of Dictionary. */
/* TODO: NotificationManager - Complete support for NSUserNotificationAuxiliary. */
/* TODO: Support pattern-based haptic feedback. */

/// Provide a key below in the userInfo of an NSUserNotification when used with the
/// NotificationManager, regardless of the value, and that feature will be enabled.
public enum NotificationOptions: String {
	case presentEvenIfFront
	case lockscreenOnly // unsupported
	case ignoreDoNotDisturb // unsupported
	case useContentImage // unsupported
}

public let NSUserNotificationCenterDidDeliverNotification = NSNotification.Name("NSUserNotificationCenter.DidDeliverNotification")
public let NSUserNotificationCenterDidActivateNotification = NSNotification.Name("NSUserNotificationCenter.DidActivateNotification")

public extension NSHapticFeedbackManager {
	public static func vibrate(length: Int = 1000, interval: Int = 10) {
		let hp = NSHapticFeedbackManager.defaultPerformer()
		for _ in 1...(length/interval) {
			hp.perform(.generic, performanceTime: .now)
			usleep(UInt32(interval * 1000))
		}
	}
}

extension NSUserNotificationCenter: NSUserNotificationCenterDelegate {
	public func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
		NotificationCenter.default().post(name: NSUserNotificationCenterDidDeliverNotification, object: notification)
	}
	
	public func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
		NotificationCenter.default().post(name: NSUserNotificationCenterDidActivateNotification, object: notification)
	}
	
	public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
		return notification.userInfo?[NotificationOptions.presentEvenIfFront.rawValue] != nil
	}
	
	public class func updateDockBadge(_ count: Int) {
		NSApp.dockTile.badgeLabel = count > 0 ? "\(count)" : ""
	}
}

public class NotificationManager: NSObject, NSUserNotificationCenterDelegate {
	static let sharedInstance = NotificationManager()
	private var _notes = Dictionary<String, [String]>()

    public override init() {
        super.init()
        NSUserNotificationCenter.default().delegate = NSUserNotificationCenter.default()
    }
	
	// Overrides notification identifier
	public func sendNotificationFor(_ group: (group: String, item: String), notification: NSUserNotification) {
        let conversationID = group.0
        let notificationID = group.1
        notification.identifier = notificationID
		
        var notificationIDs = _notes[conversationID]
        if notificationIDs != nil {
            notificationIDs!.append(notificationID)
            _notes[conversationID] = notificationIDs
        } else {
            _notes[conversationID] = [notificationID]
        }
        NSUserNotificationCenter.default().deliver(notification)
		
		let vibrate = UserDefaults.standard()[Parrot.VibrateForceTouch] as? Bool ?? false
		let interval = UserDefaults.standard()[Parrot.VibrateInterval] as? Int ?? 10
		let length = UserDefaults.standard()[Parrot.VibrateLength] as? Int ?? 1000
		if vibrate { NSHapticFeedbackManager.vibrate(length: length, interval: interval) }
    }

    public func clearNotificationsFor(_ group: String) {
        for notificationID in (_notes[group] ?? []) {
            let notification = NSUserNotification()
            notification.identifier = notificationID
            NSUserNotificationCenter.default().removeDeliveredNotification(notification)
        }
        _notes.removeValue(forKey: group)
	}
}

private var _cache = Dictionary<String, Data>()
public let defaultUserImage = NSImage(named: "NSUserGuest")!

// Note that this is general purpose! It needs a unique ID and a resource URL string.
public func fetchData(_ id: String?, _ resource: String?, handler: ((Data?) -> Void)? = nil) -> Data? {
	
	// Case 1: No unique ID -> bail.
	guard let id = id else {
		handler?(nil)
		return nil
	}
	
	// Case 2: We've already fetched it -> return image.
	if let img = _cache[id] {
		handler?(img)
		return img
	}
	
	// Case 3: No resource URL -> bail.
	guard let photo_url = resource, let url = URL(string: photo_url) else {
		handler?(nil)
		return nil
	}
	
	// Case 4: We can request the resource -> return image.
	let semaphore = DispatchSemaphore(value: 0)
	URLSession.shared().request(request: URLRequest(url: url)) {
		if let data = $0.data {
			_cache[id] = data
			handler?(data)
			semaphore.signal()
		}
	}
	
	// Onlt wait on the semaphore if we don't have a handler.
	if handler == nil {
		_ = semaphore.wait()
		return _cache[id]
	} else {
		return nil
	}
}
