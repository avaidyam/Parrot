import Cocoa

private var _cache = Dictionary<String, NSImage>()

public class NotificationManager: NSObject, NSUserNotificationCenterDelegate {
    static let sharedInstance = NotificationManager()
	
    private let nc = NSUserNotificationCenter.defaultUserNotificationCenter()
    private var notes = Dictionary<String, [String]>()

    public override init() {
        super.init()
        nc.delegate = self
    }
	
	// Overrides notification identifier
	public func sendNotificationFor(group: (group: String, item: String), notification: NSUserNotification) {
        let conversationID = group.0
        let notificationID = group.1
        notification.identifier = notificationID

        var notificationIDs = notes[conversationID]
        if notificationIDs != nil {
            notificationIDs!.append(notificationID)
            notes[conversationID] = notificationIDs
        } else {
            notes[conversationID] = [notificationID]
        }
        nc.deliverNotification(notification)
    }

    public func clearNotificationsFor(group: String) {
        for notificationID in (notes[group] ?? []) {
            let notification = NSUserNotification()
            notification.identifier = notificationID
            nc.removeDeliveredNotification(notification)
        }
        notes.removeValueForKey(group)
	}
	
	// Handle NSApp dock badge.
	
	public class func updateAppBadge(messages: Int) {
		NSApp.dockTile.badgeLabel = messages > 0 ? "\(messages)" : ""
	}
	
	// Handle NSUserNotificationCenter delivery.
	
    public func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
		
    }
	
	public func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
		
	}

    public func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
}

// Single use function for getting a user's photo:
// Note that this is general purpose! It needs a unique ID and a resource URL string.
public func fetchImage(user: String?, _ resource: String?, handler: ((NSImage?) -> Void)? = nil) -> NSImage? {
	
	// Case 1: No unique ID -> bail.
	guard let user = user else {
		handler?(nil)
		return nil
	}
	
	// Case 2: We've already fetched it -> return image.
	if let img = _cache[user] {
		handler?(img)
		return img
	}
	
	// Case 3: No resource URL -> bail.
	guard let photo_url = resource, let url = NSURL(string: photo_url) else {
		handler?(nil)
		return nil
	}
	
	// Case 4: We can request the resource -> return image.
	let semaphore = Semaphore(count: 0)
	NSURLSession.sharedSession().request(NSURLRequest(URL: url)) {
		if let data = $0.data {
			let image = NSImage(data: data)
			_cache[user] = image
			handler?(image)
			semaphore.signal()
		}
	}
	
	// Onlt wait on the semaphore if we don't have a handler.
	if handler == nil {
		semaphore.wait()
		return _cache[user]
	} else {
		return nil
	}
}
