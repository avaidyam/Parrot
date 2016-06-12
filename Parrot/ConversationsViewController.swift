import Cocoa
import Hangouts

/* TODO: Support stickers, photos, videos, files, audio, and location. */

class ConversationsViewController:  NSViewController, ConversationListDelegate {
	
	@IBOutlet var personsView: PersonsView!
	
	var selectionProvider: ((Int) -> Void)? = nil
	var wallclock: NSTimer!
	
	deinit {
		self.wallclock?.invalidate()
	}
	
	override func loadView() {
		super.loadView()
		
		let nib = NSNib(nibNamed: "PersonView", bundle: nil)
		personsView.tableView.register(nib, forIdentifier: PersonView.className())
		
		personsView.updateScrollsToBottom = false
		
		/* TODO: VERY BAD! */
		_REMOVE.append {
			self.userList = $0
			self.conversationList = $1
			
			UI {
				self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			}
		}
		
		Notifications.subscribe(name: NSUserDefaultsDidChangeNotification) { note in
			
			// Handle appearance colors.
			let dark = Settings()[Parrot.DarkAppearance] as? Bool ?? false
			let appearance = (dark ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
			self.view.window?.appearance = NSAppearance(named: appearance)
		}
		
		NotificationManager.updateAppBadge(messages: conversationList?.unreadEventCount ?? 0)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.personsView.insets = NSEdgeInsets(top: 48.0, left: 0, bottom: 0, right: 0)
		self.personsView.selectionProvider = { row in
			if row >= 0 {
				self.selectionProvider?(row)
			}
		}
		
		self.personsView.rowActionProvider = { row, edge in
			var actions: [NSTableViewRowAction] = []
			if edge == .leading { // Swipe Right Actions
				actions = [
					NSTableViewRowAction(style: .regular, title: "Mute", handler: { action, select in
						print("Mute row:\(select)")
					}),
					NSTableViewRowAction(style: .destructive, title: "Block", handler: { action, select in
						print("Block row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = NSColor.materialBlue()
				actions[1].backgroundColor = NSColor.materialAmber()
			} else if edge == .trailing { // Swipe Left Actions
				actions = [
					NSTableViewRowAction(style: .destructive, title: "Delete", handler: { action, select in
						print("Delete row:\(select)")
					}),
					NSTableViewRowAction(style: .regular, title: "Archive", handler: { action, select in
						print("Archive row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = NSColor.materialAmber()
				actions[1].backgroundColor = NSColor.materialRed()
			}
			return actions
		}
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		let scroll = self.view.subviews[0] as? NSScrollView
		scroll!.scrollerInsets = NSEdgeInsets(top: -48.0, left: 0, bottom: 0, right: 0)
		//self.timeLabel?.stringValue = self.time.relativeString()
		
		self.wallclock = NSTimer.scheduledWallclock(target: self, selector: #selector(_updateWallclock(_:)))
	}
	
	func _updateWallclock(_ timer: NSTimer) {
		Notifications.post(name: "PersonView.UpdateTime", object: self)
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
	
	private func _getPerson(conversation: IConversation) -> Person {
		
		// Propogate info for data filling
		let a = conversation.messages.last?.userID
		let b = conversation.users.filter { $0.isSelf }.first?.id
		let c = conversation.users.filter { !$0.isSelf }.first
		let network_ = conversation.conversation.networkType
		let d = NetworkType(rawValue: network_[0].rawValue) // FIXME weird stuff here
		
		// Patch for Google Voice contacts to show their numbers.
		// FIXME: Sometimes [1] is actually you, fix that.
		var title = conversation.name
		if title == "Unknown" {
			if conversation.conversation.participantData.count > 0 {
				title = conversation.conversation.participantData[1].fallbackName! as String
			}
		}
		
		// Load all the field values from the conversation.
		var img: NSImage = defaultUserImage
		if let d = fetchData(id: c?.id.gaiaID, c?.photoURL) {
			img = NSImage(data: d)!
		}
		
		let ring = d == NetworkType.GoogleVoice ? NSColor.materialBlue() : NSColor.materialGreen()
		let cap = d == NetworkType.GoogleVoice ? "Google Voice" : "Hangouts"
		let ind = conversation.hasUnreadEvents
		let name = title
		// FIXME: Sometimes, the messages will be empty if there was a hangouts call as the last event.
		let sub = (a != b ? "" : "You: ") + (conversation.messages.last?.text ?? "")
		let time = conversation.messages.last?.timestamp ?? NSDate(timeIntervalSince1970: 0)
		
		return Person(photo: img, caption: cap, highlight: ring,
		              indicator: ind, primary: name, secondary: sub, time: time)
	}
	
	private func _getAllPersons() -> [Person]? {
		return self.conversationList?.conversations.map { _getPerson(conversation: $0) }
	}
	
    func conversationList(list: ConversationList, didReceiveEvent event: IEvent) {}
    func conversationList(list: ConversationList, didChangeTypingStatusTo status: TypingType) {}
    func conversationList(list: ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {}
	
	/* TODO: Just update the row that is updated. */
    func conversationList(didUpdate list: ConversationList) {
		UI {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			NotificationManager.updateAppBadge(messages: self.conversationList?.unreadEventCount ?? 0)
		}
    }
	
	/* TODO: Just update the row that is updated. */
    func conversationList(list: ConversationList, didUpdateConversation conversation: IConversation) {
		UI {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			NotificationManager.updateAppBadge(messages: self.conversationList?.unreadEventCount ?? 0)
		}
    }
}
