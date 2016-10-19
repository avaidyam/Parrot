import Cocoa
import Hangouts
import ParrotServiceExtension
import protocol ParrotServiceExtension.Conversation

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */

let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", qos: .userInteractive)
let linkQ = DispatchQueue(label: "com.avaidyam.Parrot.linkQ", qos: .userInitiated)

public class ConversationListViewController: NSWindowController, ConversationListDelegate {
	
	// How to sort the conversation list: by recency or name, or manually.
	enum SortMode {
		enum Direction {
			case ascending
			case descending
		}
		
		case none
		case recent(Direction)
		case name(Direction)
	}
	
	@IBOutlet var listView: ListView!
	@IBOutlet var indicator: NSProgressIndicator!
	
	private var updateToken: Bool = false
	private var userList: Directory?
	private var wallclock: DispatchSourceTimer? = nil
    private var wallclockStarted: Bool = false
	private var childConversations = [String: MessageListViewController]()
	
	deinit {
        self.wallclockStarted = false
		self.wallclock?.cancel()
	}
	
	var conversationList: ParrotServiceExtension.ConversationList? {
		didSet {
			// FIXME: FORCE-CAST TO HANGOUTS
			(conversationList as? Hangouts.ConversationList)?.delegate = self
			self.animatedUpdate()
            
            // Open conversations that were previously open.
            if let a = Settings["Parrot.OpenConversations"] as? [String] {
                a.forEach {
                    if let c = self.conversationList?[$0] {
                        DispatchQueue.main.async {
                            //self.showConversation(c)
                        }
                    }
                }
            }
		}
	}
	
	var sortedConversations: [ParrotServiceExtension.Conversation] {
		guard self.conversationList != nil else { return [] }
		
		// FIXME: FORCE-CAST TO HANGOUTS
		let all = self.conversationList?.conversations.map { $1 as! IConversation }.filter { !$0.is_archived }
		return all!.sorted { $0.last_modified > $1.last_modified }.map { $0 as ParrotServiceExtension.Conversation }
	}
	
	// Performs a visual refresh of the conversation list.
	private func animatedUpdate() {
		DispatchQueue.main.async {
			self.listView.animator().isHidden = true
			self.indicator.animator().alphaValue = 1.0
			self.indicator.isHidden = false
			self.indicator.startAnimation(nil)
			
			self.listView.update(animated: false) {
				self.listView.animator().isHidden = false
				self.indicator.animator().alphaValue = 0.0
				
				let scaleIn = CAAnimation.scaleIn(forFrame: self.listView.layer!.frame)
				self.listView.layer?.add(scaleIn, forKey: "updates")
				
				let durMS = Int(NSAnimationContext.current().duration * 1000.0)
				DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(durMS)) {
					self.indicator.stopAnimation(nil)
					self.indicator.isHidden = true
				}
			}
		}
	}
	
	public override func loadWindow() {
		super.loadWindow()
		self.window?.appearance = ParrotAppearance.interfaceStyle().appearance()
		self.window?.enableRealTitlebarVibrancy(.withinWindow)
		self.window?.titleVisibility = .hidden
		ParrotAppearance.registerVibrancyStyleListener(observer: self, invokeImmediately: true) { style in
			guard let vev = self.window?.contentView as? NSVisualEffectView else { return }
			vev.state = style.visualEffectState()
		}
		
		self.listView.dataSourceProvider = { self.sortedConversations.map { $0 as Any } }
		self.listView.register(nibName: "ConversationCell", forClass: ConversationCell.self)
		
		self.listView.updateScrollDirection = .top
		self.listView.viewClassProvider = { row in ConversationCell.self }
		
		NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService) { note in
            guard let c = note.object as? Service else { return }
			self.userList = c.directory
			self.conversationList = c.conversations
			
			DispatchQueue.main.async {
				//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
				self.listView.update()
			}
		}
		
		let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
		NSApp.badgeCount = UInt(unread)
		
		NotificationCenter.default.addObserver(forName: NSUserNotification.didActivateNotification) {
			guard	let notification = $0.object as? NSUserNotification,
					var conv = self.conversationList?.conversations[notification.identifier ?? ""]
			else { return }
			
			switch notification.activationType {
			case .contentsClicked:
				self.showConversation(conv as! IConversation)
			case .actionButtonClicked:
				conv.muted = true
			case .replied where notification.response?.string != nil:
				self.sendMessage(notification.response!.string, conv)
			default: break
			}
		}
		
		self.wallclock = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
		self.wallclock?.scheduleRepeating(wallDeadline: .now() + Date().nearestMinute().timeIntervalSinceNow, interval: 60.0, leeway: .seconds(3))
		self.wallclock?.setEventHandler {
			log.verbose("Updated visible timestamp for Conversations.")
            // FIXME: THIS IS BAD!
            self.listView.collectionView.visibleItems().forEach {
                ($0 as? ConversationCell)?.updateTimestamp()
            }
		}
		
		self.listView.insets = EdgeInsets(top: 36.0, left: 0, bottom: 0, right: 0)
		self.listView.clickedRowProvider = { row in
			guard row >= 0 else { return }
			
			let conv = (self.sortedConversations[row] as! IConversation)
			self.showConversation(conv)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                self.listView.collectionView.animator().selectItems(at: Set<IndexPath>([]), scrollPosition: .top)
			}
		}
		self.listView.rowActionProvider = { row, edge in
			guard edge == .trailing else { return [] }
			var actions = [
				NSTableViewRowAction(style: .regular, title: "Delete") { action, select in
					log.info("Delete row:\(select)")
				},
				NSTableViewRowAction(style: .regular, title: "Archive") { action, select in
					log.info("Archive row:\(select)")
				},
				NSTableViewRowAction(style: .regular, title: "Block") { action, select in
					log.info("Block row:\(select)")
				},
				NSTableViewRowAction(style: .destructive, title: "Mute") { action, select in
					log.info("Mute row:\(select)")
					//self.sortedConversations[row].muted = true
				},
			]
			
			// Fix the colors set by the given styles.
			actions[0].backgroundColor = #colorLiteral(red: 0.7960784435, green: 0, blue: 0, alpha: 1)
			actions[1].backgroundColor = #colorLiteral(red: 1, green: 0.2117647082, blue: 0.2392156869, alpha: 1)
			actions[2].backgroundColor = #colorLiteral(red: 0.1843137294, green: 0.7098039389, blue: 1, alpha: 1)
			actions[3].backgroundColor = #colorLiteral(red: 0, green: 0.4745098054, blue: 0.9098039269, alpha: 1)
			return actions
		}
		self.listView.menuProvider = { rows in
			let m = NSMenu(title: "Settings")
			m.addItem(title: "Mute") {
				log.info("Mute rows:\(rows)")
			}
			m.addItem(title: "Block") {
				log.info("Block rows:\(rows)")
			}
			m.addItem(NSMenuItem.separator())
			m.addItem(title: "Delete") {
				log.info("Delete rows:\(rows)")
			}
			m.addItem(title: "Archive") {
				log.info("Archive rows:\(rows)")
			}
			return m
		}
		self.listView.pasteboardProvider = { row in
			let pb = NSPasteboardItem()
			//NSPasteboardTypeRTF, NSPasteboardTypeString, NSPasteboardTypeTabularText
			log.info("pb for row \(row)")
			pb.setString("TEST", forType: "public.utf8-plain-text")
			return pb
		}
		self.listView.scrollbackProvider = {
			guard $0 == .bottom else { return }
			guard self.updateToken == false else { return }
			
			log.debug("SCROLLBACK")
			self.updateToken = true
		}
	}
	
	private func showConversation(_ conv: Conversation) {
		if let wc = self.childConversations[conv.identifier] {
			log.debug("Conversation found for id \(conv.identifier)")
			wc.showWindow(nil)
		} else {
			log.debug("Conversation NOT found for id \(conv.identifier)")
			
			let wc = MessageListViewController(windowNibName: "MessageListViewController")
			wc.conversation = (conv as! IConversation)
			wc.sendMessageHandler = { [weak self] message, conv2 in
				self?.sendMessage(message, conv2)
			}
            self.childConversations[conv.identifier] = wc
            Settings["Parrot.OpenConversations"] = Array(self.childConversations.keys)
			let sel = #selector(ConversationListViewController.childWindowWillClose(_:))
			NotificationCenter.default.addObserver(self, selector: sel,
			                                         name: .NSWindowWillClose, object: wc.window)
			wc.showWindow(nil)
		}
	}
	
	/// As we are about to display, configure our UI elements.
	public override func showWindow(_ sender: Any?) {
		super.showWindow(sender)
		self.indicator.startAnimation(nil)
		
        if !self.wallclockStarted { // "BUG IN LIBDISPATCH: Over-resume of object"
            self.wallclock?.resume()
            self.wallclockStarted = true
        }
		ParrotAppearance.registerInterfaceStyleListener(observer: self) { appearance in
			self.window?.appearance = appearance.appearance()
		}
	}
	
	/// If we're notified that our child window has closed (that is, a conversation),
	/// clean up by removing it from the `childConversations` dictionary.
	public func childWindowWillClose(_ notification: Notification) {
		guard	let win = notification.object as? NSWindow,
				let ctrl = win.windowController as? MessageListViewController,
				let conv2 = ctrl.conversation else { return }
		
        _ = self.childConversations.removeValue(forKey: conv2.identifier)
        Settings["Parrot.OpenConversations"] = Array(self.childConversations.keys)
		NotificationCenter.default.removeObserver(self, name: notification.name, object: win)
	}
	
	/// If we need to close, make sure we clean up after ourselves, instead of deinit.
	public func windowWillClose(_ notification: Notification) {
		ParrotAppearance.unregisterInterfaceStyleListener(observer: self)
        if self.wallclockStarted {
            self.wallclock?.suspend()
        }
	}
    
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        for (_, s) in ServiceRegistry.services {
            s.userInteractionState = true // FIXME
        }
    }
	
	func sendMessage(_ text: String, _ conversation: Conversation) {
		func segmentsForInput(_ text: String, emojify: Bool = true) -> [IChatMessageSegment] {
			return [IChatMessageSegment(text: (emojify ? text.applyGoogleEmoji(): text))]
		}
		
		// Grab a local copy of the text and let the user continue.
		guard text.characters.count > 0 else { return }
		
		var emojify = Settings[Parrot.AutoEmoji] as? Bool ?? false
		emojify = NSEvent.modifierFlags().contains(.option) ? false : emojify
		let txt = segmentsForInput(text, emojify: emojify)
		
		// Create an operation to process the message and then send it.
		let operation = DispatchWorkItem(qos: .userInteractive, flags: .enforceQoS) {
			let s = DispatchSemaphore(value: 0)
			(conversation as! IConversation).sendMessage(segments: txt) { s.signal() }
			s.wait()
		}
		
		// Send the operation to the serial send queue, and notify on completion.
		operation.notify(queue: DispatchQueue.main) {
			log.debug("message sent")
		}
		sendQ.async(execute: operation)
	}
	
    public func conversationList(_ list: Hangouts.ConversationList, didReceiveEvent event: IEvent) {
		guard event is IChatMessageEvent else { return }
		
		// pls fix :(
		DispatchQueue.main.async {
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
			NSApp.badgeCount = UInt(unread)
		}
		
		let conv = self.conversationList?.conversations[event.conversation_id]
		
		// Support mentioning a person's name. // TODO, FIXME
		/*if	let user = (conv as? IConversation)?.user_list[event.userID],
			let name = self.userList?.me.firstName,
			let ev = event as? IChatMessageEvent
			where !user.isSelf && ev.text.contains(name) {
			
			let notification = NSUserNotification()
			notification.identifier = "mention"
			notification.title = user.firstName + " (via Hangouts) mentioned you..." /* FIXME */
			//notification.subtitle = "via Hangouts"
			notification.deliveryDate = Date()
			notification.identityImage = fetchImage(user: user, conversation: conv!)
			notification.identityStyle = .circle
			//notification.soundName = "texttone:Bamboo" // this works!!
			notification.set(option: .customSoundPath, value: "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/sms_alert_bamboo.caf")
			notification.set(option: .vibrateForceTouch, value: true)
			notification.set(option: .alwaysShow, value: true)
			
			// Post the notification "uniquely" -- that is, replace it while it is displayed.
			NSUserNotification.notifications()
				.filter { $0.identifier == notification.identifier }
				.forEach { $0.remove() }
			notification.post()
		}*/
		
		// Forward the event to the conversation if it's open. Also, if the 
		// conversation is not open, or if it isn't the main window, show a notification.
		var showNote = true
		if let c = self.childConversations[event.conversation_id] {
			c.conversation(c.conversation!, didReceiveEvent: event)
			showNote = !(c.window?.isKeyWindow ?? false)
		}
		
		if let user = (conv as? IConversation)?.user_list[event.userID.gaiaID] , !user.me && showNote {
			log.debug("Sending notification...")
			
			let text = (event as? IChatMessageEvent)?.text ?? "Event"
			
			let notification = NSUserNotification()
			notification.identifier = event.conversation_id
			notification.title = user.firstName + " (via Hangouts)" /* FIXME */
			//notification.subtitle = "via Hangouts"
			notification.informativeText = text
			notification.deliveryDate = Date()
			notification.alwaysShowsActions = true
			notification.hasReplyButton = true
			notification.otherButtonTitle = "Mute"
			notification.responsePlaceholder = "Send a message..."
			notification.identityImage = fetchImage(user: user, conversation: conv!)
			notification.identityStyle = .circle
			//notification.soundName = "texttone:Bamboo" // this works!!
			notification.set(option: .customSoundPath, value: "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/sms_alert_bamboo.caf")
			notification.set(option: .vibrateForceTouch, value: true)
			notification.set(option: .alwaysShow, value: true)
			
			// Post the notification "uniquely" -- that is, replace it while it is displayed.
			NSUserNotification.notifications()
				.filter { $0.identifier == notification.identifier }
				.forEach { $0.remove() }
			notification.post()
		}
	}
	
    public func conversationList(_ list: Hangouts.ConversationList, didChangeTypingStatus status: ITypingStatusMessage, forUser: User) {
		if let c = self.childConversations[status.convID] {
			//if (c.window?.isKeyWindow ?? false) {
				c.conversation(c.conversation!, didChangeTypingStatusForUser: forUser, toStatus: status.status)
			//}
		}
	}
    public func conversationList(_ list: Hangouts.ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {
		/*if let c = self.childConversations[status.convID] {
			if (c.window?.isKeyWindow ?? false) {
				c.conversation(c.conversation!, didChangeTypingStatusForUser: forUser, toStatus: status.status)
			}
		}*/
	}
	
	/* TODO: Just update the row that is updated. */
    public func conversationList(didUpdate list: Hangouts.ConversationList) {
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
			NSApp.badgeCount = UInt(unread)
		}
    }
	
	/* TODO: Just update the row that is updated. */
    public func conversationList(_ list: Hangouts.ConversationList, didUpdateConversation conversation: IConversation) {
		DispatchQueue.main.async {
			//self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
			self.listView.update()
			let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
			NSApp.badgeCount = UInt(unread)
		}
    }
}
