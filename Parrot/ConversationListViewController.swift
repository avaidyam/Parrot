import Cocoa
import Hangouts
import ParrotServiceExtension
import protocol ParrotServiceExtension.Conversation

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */

let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", attributes: [.serial, .qosUserInteractive])
let linkQ = DispatchQueue(label: "com.avaidyam.Parrot.linkQ", attributes: [.serial, .qosUserInitiated])

class ConversationListViewController: NSViewController, ConversationListDelegate {
	
	@IBOutlet var listView: ListView!
	@IBOutlet var indicator: NSProgressIndicator!
	
	var wallclock: Timer!
	var userList: Directory?
	
	static func display() -> WindowTransitionAnimator {
		let vc = ConversationListViewController(nibName: "ConversationListViewController", bundle: nil)
		
		// The .titlebar material has no transluency in dark appearances, and
		// has a standard window gradient in light ones.
		let trans = WindowTransitionAnimator { w in
			w.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView]
			w.collectionBehavior = [.managed, .participatesInCycle, .fullScreenPrimary, .fullScreenAllowsTiling]
			w.appearance = ParrotAppearance.current()
			w.enableRealTitlebarVibrancy()
			
			// Because autosave is miserable.
			w.setFrameAutosaveName("Conversations")
			if w.frame == .zero {
				w.setFrame(NSRect(x: 0, y: 0, width: 386, height: 512), display: false, animate: true)
				w.center()
			}
		}
		trans.displayViewController(vc!)
		return trans
	}
	
	var conversationList: ParrotServiceExtension.ConversationList? {
		didSet {
			// FIXME: FORCE-CAST TO HANGOUTS
			(conversationList as? Hangouts.ConversationList)?.delegate = self
			
			DispatchQueue.main.async {
				NSAnimationContext.runAnimationGroup({ ctx in
					self.indicator.stopAnimation(nil)
					self.indicator.isHidden = true
				}, completionHandler: {
					//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
					self.listView.update()
					//let i = (0..<self.listView.dataSource.count) as Range<Int>
					//self.listView.tableView.insertRows(at: IndexSet(integersIn: i), withAnimation: [.effectFade, .slideUp])
				})
			}
		}
	}
	
	var sortedConversations: [ParrotServiceExtension.Conversation] {
		guard self.conversationList != nil else { return [] }
		
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
		self.indicator.startAnimation(nil)
		
		self.listView.dataSourceProvider = { self.sortedConversations.map { $0 as Any } }
		self.listView.register(nibName: "ConversationView", forClass: ConversationView.self)
		
		self.listView.updateScrollDirection = .top
		self.listView.viewClassProvider = { row in ConversationView.self }
		
		NotificationCenter.default().addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
			let c = note.object as! Hangouts.Client
			self.userList = c.userList
			self.conversationList = c.conversationList
			
			DispatchQueue.main.async {
				//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
				self.listView.update()
			}
		}
		
		let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, combine: +)
		UserNotificationCenter.updateDockBadge(unread)
		
		NotificationCenter.default().addObserver(forName: UserNotification.didActivateNotification, object: nil, queue: nil) { n in
			guard	let u = n.object as? UserNotification
					where ((self.conversationList?.conversations[u.identifier ?? ""]) != nil)
			else { return }
			
			log.info("note \(u.identifier) with response \(u.response)")
			guard u.response != nil else { return }
			
			log.warning("sending disabled temporarily")
			/*
			let emojify = Settings[Parrot.AutoEmoji] as? Bool ?? false
			let txt = MessageListViewController.segmentsForInput(u.response!.string, emojify: emojify)
			self.conversation?.sendMessage(segments: txt)
			*/
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.listView.insets = EdgeInsets(top: 48.0, left: 0, bottom: 0, right: 0)
		self.listView.clickedRowProvider = { row in
			guard row >= 0 else { return }
			_ = MessageListViewController.display(from: self, conversation: self.sortedConversations[row])
		}
		self.listView.rowActionProvider = { row, edge in
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
		self.listView.menuProvider = { rows in
			let m = NSMenu(title: "")
			m.addItem(withTitle: "Mute", action: nil, keyEquivalent: "")
			m.addItem(withTitle: "Block", action: nil, keyEquivalent: "")
			m.addItem(NSMenuItem.separator())
			m.addItem(withTitle: "Delete", action: nil, keyEquivalent: "")
			m.addItem(withTitle: "Archive", action: nil, keyEquivalent: "")
			return m
		}
		self.listView.pasteboardProvider = { row in
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
		log.verbose("Updated visible timestamp for Conversations.")
		for row in self.listView.visibleRows {
			if let cell = self.listView.tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? ConversationView {
				cell.updateTimestamp()
			}
		}
	}
	
	
	
	// MARK - Delegate
	
	
	
    func conversationList(_ list: Hangouts.ConversationList, didReceiveEvent event: IEvent) {
		guard event is IChatMessageEvent else { return }
		
		// pls fix :(
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, combine: +)
			UserNotificationCenter.updateDockBadge(unread)
		}
	}
	
    func conversationList(_ list: Hangouts.ConversationList, didChangeTypingStatusTo status: TypingType) {}
    func conversationList(_ list: Hangouts.ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {
		log.info("Received watermark \(status)")
	}
	
	/* TODO: Just update the row that is updated. */
    func conversationList(didUpdate list: Hangouts.ConversationList) {
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, combine: +)
			UserNotificationCenter.updateDockBadge(unread)
		}
    }
	
	/* TODO: Just update the row that is updated. */
    func conversationList(_ list: Hangouts.ConversationList, didUpdateConversation conversation: IConversation) {
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, combine: +)
			UserNotificationCenter.updateDockBadge(unread)
		}
    }
}
