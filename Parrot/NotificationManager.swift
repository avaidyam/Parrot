import Cocoa
import Hangouts

typealias ItemID = String
typealias GroupID = String

class NotificationManager: NSObject, NSUserNotificationCenterDelegate {
    static let sharedInstance = NotificationManager()
	
    private let nc = NSUserNotificationCenter.defaultUserNotificationCenter()
    private var notes = Dictionary<GroupID, [ItemID]>()

    override init() {
        super.init()
        nc.delegate = self
    }
	
	// Overrides notification identifier
	func sendNotificationFor(group: (GroupID, ItemID), notification: NSUserNotification) {
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

    func clearNotificationsFor(group: GroupID) {
        for notificationID in (notes[group] ?? []) {
            let notification = NSUserNotification()
            notification.identifier = notificationID
            nc.removeDeliveredNotification(notification)
        }
        notes.removeValueForKey(group)
	}
	
	class func updateAppBadge(messages: Int) {
		NSApp.dockTile.badgeLabel = messages > 0 ? "\(messages)" : ""
	}

    func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
		
    }
	
	func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
		
	}

    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
}