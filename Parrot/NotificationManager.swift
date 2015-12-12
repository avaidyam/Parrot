import Cocoa
import Hangouts

class NotificationManager: NSObject, NSUserNotificationCenterDelegate {
    static let sharedInstance = NotificationManager()
    private let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()

    typealias ConversationID = String
    typealias NotificationID = String
    private var groupedNotifications = Dictionary<ConversationID, [NotificationID]>()

    override init() {
        super.init()
        notificationCenter.delegate = self
    }

    func sendNotificationFor(event: ConversationEvent, fromUser user: User) {
        let conversationID = event.event.conversation_id.id as ConversationID
        let notificationID = event.id as NotificationID

        let notification = NSUserNotification()
        notification.title = user.full_name
        notification.informativeText = event.event.chat_message?.message_content.segment?.first?.text as? String
        notification.deliveryDate = NSDate()
        notification.soundName = "notification.wav"
        notification.contentImage = ImageCache.sharedInstance.getImage(forUser: user)
        notification.identifier = notificationID

        var notificationIDs = groupedNotifications[conversationID]
        if notificationIDs != nil {
            notificationIDs!.append(notificationID)
            groupedNotifications[conversationID] = notificationIDs
        } else {
            groupedNotifications[conversationID] = [notificationID]
        }

        notificationCenter.deliverNotification(notification)
    }

    func clearNotificationsFor(conversation: Conversation) {
        let conversationID = conversation.id as ConversationID

        for notificationID in (groupedNotifications[conversationID] ?? []) {
            let notification = NSUserNotification()
            notification.identifier = notificationID
            notificationCenter.removeDeliveredNotification(notification)
        }

        groupedNotifications.removeValueForKey(conversationID)
    }

    // MARK: NSUserNotificationCenterDelegate

    func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
    }

    func userNotificationCenter(
        center: NSUserNotificationCenter,
        shouldPresentNotification notification: NSUserNotification
    ) -> Bool {
        return true
    }
}