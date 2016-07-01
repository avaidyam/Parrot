import Cocoa
import Hangouts

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */

class ConversationsViewController:  NSViewController, ConversationListDelegate {
	
	@IBOutlet var personsView: PersonsView!
	@IBOutlet var indicator: NSProgressIndicator!
	
	var selectionProvider: ((Int) -> Void)? = nil
	var wallclock: Timer!
	
	deinit {
		self.wallclock?.invalidate()
	}
	
	override func loadView() {
		super.loadView()
		self.title = "Parrot" // weird stuff
		
		let nib = NSNib(nibNamed: "PersonView", bundle: nil)
		personsView.tableView.register(nib, forIdentifier: PersonView.className())
		
		personsView.updateScrollsToBottom = false
		
		NotificationCenter.default().addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
			let c = note.object as! Hangouts.Client
			self.userList = c.userList
			self.conversationList = c.conversationList
			
			DispatchQueue.main.async {
				self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			}
		}
		
		UserNotificationCenter.updateDockBadge(conversationList?.unreadEventCount ?? 0)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.personsView.insets = EdgeInsets(top: 48.0, left: 0, bottom: 0, right: 0)
		self.personsView.clickedRowProvider = { row in
			if row >= 0 {
				self.selectionProvider?(row)
			}
		}
		self.personsView.rowActionProvider = { row, edge in
			var actions: [NSTableViewRowAction] = []
			if edge == .leading { // Swipe Right Actions
				actions = [
					NSTableViewRowAction(style: .regular, title: "Mute", handler: { action, select in
						log.info("Mute row:\(select)")
					}),
					NSTableViewRowAction(style: .destructive, title: "Block", handler: { action, select in
						log.info("Block row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = #colorLiteral(red: 0.06274510175, green: 0.360784322, blue: 0.7960784435, alpha: 1)
				actions[1].backgroundColor = #colorLiteral(red: 1, green: 0.5607843399, blue: 0, alpha: 1)
			} else if edge == .trailing { // Swipe Left Actions
				actions = [
					NSTableViewRowAction(style: .destructive, title: "Delete", handler: { action, select in
						log.info("Delete row:\(select)")
					}),
					NSTableViewRowAction(style: .regular, title: "Archive", handler: { action, select in
						log.info("Archive row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = #colorLiteral(red: 1, green: 0.5607843399, blue: 0, alpha: 1)
				actions[1].backgroundColor = #colorLiteral(red: 0.7882353067, green: 0.09019608051, blue: 0.1215686277, alpha: 1)
			}
			return actions
		}
		self.personsView.menuProvider = { rows in
			let m = NSMenu(title: "")
			m.addItem(withTitle: "Mute", action: nil, keyEquivalent: "")
			m.addItem(withTitle: "Block", action: nil, keyEquivalent: "")
			m.addItem(withTitle: "Delete", action: nil, keyEquivalent: "")
			m.addItem(withTitle: "Archive", action: nil, keyEquivalent: "")
			return m
		}
		self.personsView.pasteboardProvider = { row in
			let pb = NSPasteboardItem()
			//NSPasteboardTypeRTF, NSPasteboardTypeString, NSPasteboardTypeTabularText
			log.info("pb for row \(row)")
			pb.setString("TEST", forType: "public.utf8-plain-text")
			return pb
		}
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		self.wallclock = Timer.scheduledWallclock(self, selector: #selector(_updateWallclock(_:)))
		ParrotAppearance.registerAppearanceListener(observer: self) { appearance in
			self.view.window?.appearance = appearance
		}
	}
	
	override func viewDidDisappear() {
		ParrotAppearance.unregisterAppearanceListener(observer: self)
	}
	
	func _updateWallclock(_ timer: Timer) {
		NotificationCenter.default().post(name: Notification.Name("PersonView.UpdateTime"), object: self)
	}
	
	var userList: UserList? // FIXME
    var conversationList: ConversationList? {
        didSet {
            conversationList?.delegate = self
			DispatchQueue.main.async {
				self.indicator.isHidden = true
				self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			}
        }
    }
	
	private func _getPerson(_ conversation: IConversation) -> Person {
		
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
		if let d = fetchData(c?.id.gaiaID, c?.photoURL) {
			img = NSImage(data: d)!
		}
		
		let ring = d == NetworkType.GoogleVoice ? #colorLiteral(red: 0, green: 0.611764729, blue: 1, alpha: 1) : #colorLiteral(red: 0.03921568766, green: 0.9098039269, blue: 0.3686274588, alpha: 1)
		let cap = d == NetworkType.GoogleVoice ? "Google Voice" : "Hangouts"
		let ind = conversation.unread_events.count
		let name = title
		// FIXME: Sometimes, the messages will be empty if there was a hangouts call as the last event.
		let sub = (a != b ? "" : "You: ") + (conversation.messages.last?.text ?? "")
		let time = conversation.messages.last?.timestamp ?? Date(timeIntervalSince1970: 0)
		
		return Person(photo: img, caption: cap, highlight: ring,
		              indicator: ind, primary: name, secondary: sub, time: time)
	}
	
	private func _getAllPersons() -> [Person]? {
		return self.conversationList?.conversations.map { _getPerson($0) }
	}
	
    func conversationList(_ list: ConversationList, didReceiveEvent event: IEvent) {}
    func conversationList(_ list: ConversationList, didChangeTypingStatusTo status: TypingType) {}
    func conversationList(_ list: ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {}
	
	/* TODO: Just update the row that is updated. */
    func conversationList(didUpdate list: ConversationList) {
		DispatchQueue.main.async {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			UserNotificationCenter.updateDockBadge(self.conversationList?.unreadEventCount ?? 0)
		}
    }
	
	/* TODO: Just update the row that is updated. */
    func conversationList(_ list: ConversationList, didUpdateConversation conversation: IConversation) {
		DispatchQueue.main.async {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			UserNotificationCenter.updateDockBadge(self.conversationList?.unreadEventCount ?? 0)
		}
    }
}
