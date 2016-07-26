import Cocoa
import Hangouts
import ParrotServiceExtension
import protocol ParrotServiceExtension.Conversation

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */

let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", attributes: [.serial, .qosUserInteractive])
let linkQ = DispatchQueue(label: "com.avaidyam.Parrot.linkQ", attributes: [.serial, .qosUserInitiated])

public class ConversationListViewController: NSWindowController, ConversationListDelegate {
	
	// How to sort the conversation list: by recency or name, or manually.
	enum SortMode {
		case none
		case recent
		case name
	}
	enum SortDirection {
		case ascending
		case descending
	}
	
	@IBOutlet var listView: ListView!
	@IBOutlet var indicator: NSProgressIndicator!
	
	private var childConversations = [MessageListViewController]()
	
	var wallclock: DispatchSourceTimer? = nil
	var userList: Directory?
	
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
		self.wallclock?.cancel()
	}
	
	public override func loadWindow() {
		super.loadWindow()
		self.window?.appearance = ParrotAppearance.current()
		self.window?.enableRealTitlebarVibrancy()
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
		
		self.wallclock = DispatchSource.timer(flags: [], queue: DispatchQueue.main)
		self.wallclock?.scheduleRepeating(wallDeadline: .now() + Date().nearestMinute().timeIntervalSinceNow, interval: 60.0, leeway: .seconds(3))
		self.wallclock?.setEventHandler {
			log.verbose("Updated visible timestamp for Conversations.")
			for row in self.listView.visibleRows {
				if let cell = self.listView.tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? ConversationView {
					cell.updateTimestamp()
				}
			}
		}
		
		//self.listView.insets = EdgeInsets(top: 48.0, left: 0, bottom: 0, right: 0)
		self.listView.selectionProvider = { row in
			guard row >= 0 else { return }
			let wc = MessageListViewController(windowNibName: "MessageListViewController")
			self.childConversations.append(wc)
			wc.conversation = (self.sortedConversations[row] as! IConversation)
			wc.parentController = self
			wc.showWindow(nil)
			//_ = MessageListViewController.display(from: self, conversation: self.sortedConversations[row])
			DispatchQueue.main.after(when: .now() + .milliseconds(150)) {
				self.listView.tableView.animator().selectRowIndexes(IndexSet(), byExtendingSelection: false)
			}
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
	
	public override func showWindow(_ sender: AnyObject?) {
		super.showWindow(sender)
		self.wallclock?.resume()
		
		ParrotAppearance.registerAppearanceListener(observer: self) { appearance in
			self.window?.appearance = appearance
		}
	}
	
	public func windowWillClose(_ notification: Notification) {
		ParrotAppearance.unregisterAppearanceListener(observer: self)
		self.wallclock?.suspend()
	}
	
	// MARK - Conversations
	
	
	func sendMessage(_ text: String, _ conversation: Conversation) {
		func segmentsForInput(_ text: String, emojify: Bool = true) -> [IChatMessageSegment] {
			return [IChatMessageSegment(text: (emojify ? text.applyGoogleEmoji(): text))]
		}
		
		// Grab a local copy of the text and let the user continue.
		guard text.characters.count > 0 else { return }
		
		// Create an operation to process the message and then send it.
		let operation = DispatchWorkItem(qos: .userInteractive, flags: .enforceQoS) {
			var emojify = Settings[Parrot.AutoEmoji] as? Bool ?? false
			emojify = NSEvent.modifierFlags().contains(.option) ? false : emojify
			let txt = segmentsForInput(text, emojify: emojify)
			
			let s = DispatchSemaphore.mutex
			(conversation as! IConversation).sendMessage(segments: txt) { s.signal() }
			s.wait()
		}
		
		// Send the operation to the serial send queue, and notify on completion.
		operation.notify(queue: DispatchQueue.main) {
			log.debug("message sent")
		}
		sendQ.async(execute: operation)
	}
	
	
	// MARK - Delegate
	
	
	
    public func conversationList(_ list: Hangouts.ConversationList, didReceiveEvent event: IEvent) {
		guard event is IChatMessageEvent else { return }
		
		// pls fix :(
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, combine: +)
			UserNotificationCenter.updateDockBadge(unread)
		}
	}
	
    public func conversationList(_ list: Hangouts.ConversationList, didChangeTypingStatusTo status: TypingType) {}
    public func conversationList(_ list: Hangouts.ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {
		log.info("Received watermark \(status)")
	}
	
	/* TODO: Just update the row that is updated. */
    public func conversationList(didUpdate list: Hangouts.ConversationList) {
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, combine: +)
			UserNotificationCenter.updateDockBadge(unread)
		}
    }
	
	/* TODO: Just update the row that is updated. */
    public func conversationList(_ list: Hangouts.ConversationList, didUpdateConversation conversation: IConversation) {
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, combine: +)
			UserNotificationCenter.updateDockBadge(unread)
		}
    }
}
