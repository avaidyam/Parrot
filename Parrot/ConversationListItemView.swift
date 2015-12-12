import Cocoa
import Hangouts

class ConversationListItemView : NSTableCellView {
    @IBOutlet weak var avatarView: NSImageView!
    @IBOutlet weak var nameView: NSTextField!
    @IBOutlet weak var lastMessageView: NSTextField!
    @IBOutlet weak var timeView: NSTextField!

    func configureWithConversation(conversation: Conversation) {
        avatarView.wantsLayer = true

        avatarView.layer?.borderWidth = 0.0
        avatarView.layer?.cornerRadius = avatarView.frame.width / 2.0
        avatarView.layer?.masksToBounds = true

        let usersButNotMe = conversation.users.filter { !$0.isSelf }
        if let user = usersButNotMe.first {
            //  TODO: This is racey, fast scrolling can result in misplaced images
            ImageCache.sharedInstance.fetchImage(forUser: user) {
                self.avatarView.image = $0 ?? NSImage(named: "NSUserGuest")
            }
        } else {
            avatarView.image = NSImage(named: "NSUserGuest")
        }

        nameView.stringValue = conversation.name

        lastMessageView.stringValue = conversation.messages.last?.text ?? ""
        if conversation.hasUnreadEvents {
            lastMessageView.font = NSFont.boldSystemFontOfSize(lastMessageView.font!.pointSize)
        } else {
            lastMessageView.font = NSFont.systemFontOfSize(lastMessageView.font!.pointSize)
        }

        timeView.stringValue = conversation.messages.last?.timestamp.shortFormat() ?? "?"
    }
}