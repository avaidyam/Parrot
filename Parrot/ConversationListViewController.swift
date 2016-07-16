import Cocoa
import Hangouts
import ParrotServiceExtension

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */
/* TODO: Support group images and letter images instead of generic noimage icon. */

let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", attributes: [.serial, .qosUserInteractive])

class ConversationListViewController: NSViewController, ConversationListDelegate {
	
	@IBOutlet var personsView: ListView!
	@IBOutlet var indicator: NSProgressIndicator!
	
	var selectionProvider: ((Int) -> Void)? = nil
	var wallclock: Timer!
	var userList: Directory?
	var conversationList: ParrotServiceExtension.ConversationList? {
		didSet {
			// FIXME: FORCE-CAST TO HANGOUTS
			(conversationList as? Hangouts.ConversationList)?.delegate = self
			DispatchQueue.main.async {
				self.indicator.isHidden = true
				self.personsView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			}
		}
	}
	var sortedConversations: [ParrotServiceExtension.Conversation] {
		// FIXME: FORCE-CAST TO HANGOUTS
		let all = self.conversationList?.conversations.map { $1 as! IConversation }.filter { !$0.is_archived }
		return all!.sorted { $0.last_modified > $1.last_modified }.map { $0 as ParrotServiceExtension.Conversation }
	}
	
	deinit {
		self.wallclock?.invalidate()
	}
	
	override func loadView() {
		super.loadView()
		self.title = "Parrot" // weird stuff
		
		let nib = NSNib(nibNamed: "ConversationView", bundle: nil)
		personsView.tableView.register(nib, forIdentifier: ConversationView.className())
		
		personsView.updateScrollDirection = .top
		personsView.viewClassProvider = { row in ConversationView.self }
		
		NotificationCenter.default().addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
			let c = note.object as! Hangouts.Client
			self.userList = c.userList
			self.conversationList = c.conversationList
			
			DispatchQueue.main.async {
				self.personsView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			}
		}
		
		//UserNotificationCenter.updateDockBadge(conversationList?.unreadEventCount ?? 0)
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
			m.addItem(NSMenuItem.separator())
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
		let r = self.personsView.tableView.rows(in: self.personsView.tableView.visibleRect)
		for row in r.location..<r.location+r.length {
			if	let cell = self.personsView.tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? ConversationView {
				cell.updateTimestamp()
			}
		}
		
		NotificationCenter.default().post(name: Notification.Name("ConversationView.UpdateTime"), object: self)
	}
	
    func conversationList(_ list: Hangouts.ConversationList, didReceiveEvent event: IEvent) {
		guard event is IChatMessageEvent else { return }
		
		// pls fix :(
		DispatchQueue.main.async {
			self.personsView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			//UserNotificationCenter.updateDockBadge(self.conversationList?.unreadEventCount ?? 0)
		}
	}
	
    func conversationList(_ list: Hangouts.ConversationList, didChangeTypingStatusTo status: TypingType) {}
    func conversationList(_ list: Hangouts.ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {}
	
	/* TODO: Just update the row that is updated. */
    func conversationList(didUpdate list: Hangouts.ConversationList) {
		DispatchQueue.main.async {
			self.personsView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			//UserNotificationCenter.updateDockBadge(self.conversationList?.unreadEventCount ?? 0)
		}
    }
	
	/* TODO: Just update the row that is updated. */
    func conversationList(_ list: Hangouts.ConversationList, didUpdateConversation conversation: IConversation) {
		DispatchQueue.main.async {
			self.personsView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			//UserNotificationCenter.updateDockBadge(self.conversationList?.unreadEventCount ?? 0)
		}
    }
}
