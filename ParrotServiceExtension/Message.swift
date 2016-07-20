import Foundation

// Modularize Conversations + ConversationsView
// for widget:
// - main view is conversation view selected
// - press (i) to show conversations list
// - select = show a new conversation

public enum MessageType {
	case text
	case richText
	case image
	case audio
	case video
	case link
	case snippet
	case summary
}

public protocol Message: EventStreamItem {
	var sender: Person { get }
	var text: String { get }
}

public protocol EventStreamItem {
	//var identifier: String { get }
	var timestamp: Date { get }
}

/*
public protocol ConversationListDelegate {
	/*
	conversationNotification(note)
	eventNotification(note)
	focusNotification(note)
	typingNotification(note)
	notificationLevelNotification(note)
	watermarkNotification(note)
	viewModification(note)
	selfPresenceNotification(note)
	deleteNotification(note)
	presenceNotification(note)
	*/
	
	
	func conversationList(_ list: ConversationList, didReceiveEvent event: IEvent)
	func conversationList(_ list: ConversationList, didChangeTypingStatusTo status: TypingType)
	func conversationList(_ list: ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification)
	func conversationList(didUpdate list: ConversationList)
	func conversationList(_ list: ConversationList, didUpdateConversation conversation: IConversation)
}
*/
