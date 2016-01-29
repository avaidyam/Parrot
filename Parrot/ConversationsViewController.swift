import Cocoa
import Hangouts

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: Use the NSSplitViewController magic to allow docking windows! */

// Existing Parrot Settings keys.
public class Parrot {
	public static let AutoEmoji = "Parrot.AutoEmoji"
	public static let DarkAppearance = "Parrot.DarkAppearance"
	public static let InvertChatStyle = "Parrot.InvertChatStyle"
	public static let ShowSidebar = "Parrot.ShowSidebar"
}

class ConversationsViewController:  NSViewController, ConversationListDelegate {
	
	@IBOutlet var personsView: PersonsView!
	
	override func loadView() {
		super.loadView()
		
		/* TODO: VERY BAD! */
		_REMOVE.append {
			self.userList = $0
			self.conversationList = $1
			
			UI {
				self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
				//self.tableView.reloadData()
				//self.tableView.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
				//self.tableView.scrollRowToVisible(0)
			}
		}
		
		Notifications.subscribe(NSUserDefaultsDidChangeNotification) { note in
			
			// Handle appearance colors.
			let dark = Settings()[Parrot.DarkAppearance] as? Bool ?? false
			let appearance = (dark ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
			self.view.window?.appearance = NSAppearance(named: appearance)
			
			// Handle collapsed sidebar as best we can...
			let split = self.parentViewController as? NSSplitViewController
			let old = !((split?.splitViewItems[0].collapsed)!)
			let new = Settings()[Parrot.ShowSidebar] as? Bool ?? false
			if old != new {
				split?.toggleSidebar(nil)
			}
		}
		
		NotificationManager.updateAppBadge(conversationList?.unreadEventCount ?? 0)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.personsView.insets = NSEdgeInsets(top: -48.0, left: 0, bottom: 0, right: 0)
		self.personsView.selectionProvider = { row in
			self.selectConversation(row >= 0 ? self.conversationList?.conversations[row] : nil)
		}
		
		self.personsView.rowActionProvider = { row, edge in
			var actions: [NSTableViewRowAction] = []
			if edge == .Leading { // Swipe Right Actions
				actions = [
					NSTableViewRowAction(style: .Regular, title: "Mute", handler: { action, select in
						print("Mute row:\(select)")
					}),
					NSTableViewRowAction(style: .Destructive, title: "Block", handler: { action, select in
						print("Block row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = NSColor.materialBlueColor()
				actions[1].backgroundColor = NSColor.materialAmberColor()
			} else if edge == .Trailing { // Swipe Left Actions
				actions = [
					NSTableViewRowAction(style: .Destructive, title: "Delete", handler: { action, select in
						print("Delete row:\(select)")
					}),
					NSTableViewRowAction(style: .Regular, title: "Archive", handler: { action, select in
						print("Archive row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = NSColor.materialAmberColor()
				actions[1].backgroundColor = NSColor.materialRedColor()
			}
			return actions
		}
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		/* TODO: Should not be set here! Use a special window. */
		self.view.window?.titleVisibility = .Hidden;
		self.view.window?.titlebarAppearsTransparent = true;
		
		let dark = Settings()[Parrot.DarkAppearance] as? Bool ?? false
		let appearance = (dark ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
		self.view.window?.appearance = NSAppearance(named: appearance)
		
		// Handle collapsed sidebar.
		let split = (self.parentViewController as? NSSplitViewController)?.splitViewItems[0]
		split?.collapsed = !(Settings()[Parrot.ShowSidebar] as? Bool ?? false)
		
		let scroll = self.view.subviews[0] as? NSScrollView
		scroll!.scrollerInsets = NSEdgeInsets(top: -48.0, left: 0, bottom: 0, right: 0)
	}
	
	var userList: UserList? // FIXME
    var conversationList: ConversationList? {
        didSet {
            conversationList?.delegate = self
			UI {
				self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			}
        }
    }
	
	func _getPerson(conversation: Conversation) -> Person {
		
		// Propogate info for data filling
		let a = conversation.messages.last?.userID
		let b = conversation.users.filter { $0.isSelf }.first?.id
		let c = conversation.users.filter { !$0.isSelf }.first
		let network_ = conversation.conversation.network_type as NSArray
		let d = NetworkType(value: network_[0] as! NSNumber)
		
		// Patch for Google Voice contacts to show their numbers.
		// FIXME: Sometimes [1] is actually you, fix that.
		var title = conversation.name
		if title == "Unknown" {
			if let a = conversation.conversation.participant_data[1].fallback_name {
				title = a as String
			}
		}
		
		// Load all the field values from the conversation.
		var img: NSImage = defaultUserImage
		if let d = fetchData(c?.id.gaiaID, c?.photoURL) {
			img = NSImage(data: d)!
		}
		
		let ring = d == NetworkType.GVOICE ? NSColor.materialBlueColor() : NSColor.materialGreenColor()
		let ind = conversation.hasUnreadEvents
		let name = title
		let sub = (a != b ? "" : "You: ") + (conversation.messages.last?.text ?? "")
		let time = conversation.messages.last?.timestamp.relativeString() ?? ""
		
		return Person(photo: img, highlight: ring, indicator: ind, primary: name, secondary: sub, tertiary: time)
	}
	
	func _getAllPersons() -> [Person]? {
		return self.conversationList?.conversations.map { _getPerson($0) }
	}
	
    func conversationList(list: ConversationList, didReceiveEvent event: Event) {

    }

    func conversationList(list: ConversationList, didChangeTypingStatusTo status: TypingType) {
		
    }

    func conversationList(list: ConversationList, didReceiveWatermarkNotification status: WatermarkNotification) {
		
    }
	
	/* TODO: Just update the row that is updated. */
    func conversationList(didUpdate list: ConversationList) {
		UI {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			NotificationManager.updateAppBadge(self.conversationList?.unreadEventCount ?? 0)
		}
    }
	
	/* TODO: Just update the row that is updated. */
    func conversationList(list: ConversationList, didUpdateConversation conversation: Conversation) {
		UI {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			NotificationManager.updateAppBadge(self.conversationList?.unreadEventCount ?? 0)
		}
    }
	
    func selectConversation(conversation: Conversation?) {
		let item = (self.parentViewController as? NSSplitViewController)?.splitViewItems[1]
        if let vc = item?.viewController as? ConversationViewController {
            vc.representedObject = conversation
        }
    }
}

