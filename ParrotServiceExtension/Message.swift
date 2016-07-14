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
	case heartbeat
}

public protocol Message2 {
	
}
