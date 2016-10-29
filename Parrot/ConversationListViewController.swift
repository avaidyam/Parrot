import Cocoa
import Hangouts
import ParrotServiceExtension
import protocol ParrotServiceExtension.Conversation

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */

let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", qos: .userInteractive)
let linkQ = DispatchQueue(label: "com.avaidyam.Parrot.linkQ", qos: .userInitiated)

public class ConversationListViewController: NSWindowController, ConversationListDelegate, ListViewDataSource {
	
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
    private var bleh: Any? = nil
    
    /// The childConversations keeps track of all open conversations and when the
    /// list is updated, it is cached and the list selection is synchronized.
    private var childConversations = [String: MessageListViewController]() {
        didSet {
            log.debug("Updating childConversations... \(Array(self.childConversations.keys))")
            Settings["Parrot.OpenConversations"] = Array(self.childConversations.keys)
            self.updateSelectionIndexes()
        }
    }
	
	deinit {
        self.wallclockStarted = false
		self.wallclock?.cancel()
        unsubscribe(self.bleh)
	}
	
	var conversationList: ParrotServiceExtension.ConversationList? {
		didSet {
            (conversationList as? Hangouts.ConversationList)?.delegate = self // FIXME: FORCE-CAST TO HANGOUTS
            
            // Open conversations that were previously open.
            self.animatedUpdate {
                (Settings["Parrot.OpenConversations"] as? [String])?
                    .flatMap { self.conversationList?[$0] }
                    .forEach { self.showConversation($0) }
            }
            
            self.bleh = subscribe(on: .system, source: nil, Notification.Name("com.avaidyam.Parrot.Service.getConversations")) {
                log.debug("received \($0)")
                publish(on: .system, Notification(name: Notification.Name("com.avaidyam.Parrot.Service.giveConversations"), object: nil, userInfo: ["abc":"def"]))
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
    private func animatedUpdate(handler: @escaping () -> () = {}) {
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
                    handler()
				}
			}
		}
	}
    
    public func numberOfItems(in: ListView) -> [UInt] {
        return [UInt(self.sortedConversations.count)]
    }
    
    public func object(in: ListView, at: ListView.Index) -> Any? {
        return self.sortedConversations[Int(at.item)]
    }
    
    public func itemClass(in: ListView, at: ListView.Index) -> NSView.Type {
        return ConversationCell.self
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
		
        self.listView.dataSource = self
		self.listView.register(nibName: "ConversationCell", forClass: ConversationCell.self)
		
		NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService) { note in
            guard let c = note.object as? Service else { return }
			self.userList = c.directory
			self.conversationList = c.conversations
			
			DispatchQueue.main.async {
				self.listView.update()
                self.updateSelectionIndexes()
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
            self.listView.visibleCells.forEach {
                ($0 as? ConversationCell)?.updateTimestamp()
            }
		}
		
		self.listView.insets = EdgeInsets(top: 36.0, left: 0, bottom: 0, right: 0)
		/*self.listView.selectionProvider = { row in
			self.showConversation(self.sortedConversations[row])
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
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                log.info("updateToken is automatically being cleared. THIS IS A BUG. Please fix it.")
                self.updateToken = false
            }
		}*/
	}
	
	private func showConversation(_ conv: Conversation) {
		if let wc = self.childConversations[conv.identifier] {
			log.debug("Conversation found for id \(conv.identifier)")
            DispatchQueue.main.async {
                wc.showWindow()
            }
		} else {
			log.debug("Conversation NOT found for id \(conv.identifier)")
            DispatchQueue.main.async {
                let wc = MessageListViewController(windowNibName: "MessageListViewController")
                wc.conversation = (conv as! IConversation)
                wc.sendMessageHandler = { [weak self] message, conv2 in
                    self?.sendMessage(message, conv2)
                }
                self.childConversations[conv.identifier] = wc
                let sel = #selector(ConversationListViewController.childWindowWillClose(_:))
                NotificationCenter.default.addObserver(self, selector: sel,
                                                       name: .NSWindowWillClose, object: wc.window)
                wc.showWindow()
                
                // TODO: This plus some window snapping and sizing would allow for a UI mode.
                // Also, remove the drawer and add popover if in single window mode.
                //self.window?.addChildWindow(wc.window!, ordered: .below)
                //wc.window?.isResizable = false
                //wc.window?.standardWindowButton(.closeButton)?.isHidden = true
                //wc.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
                //wc.window?.standardWindowButton(.zoomButton)?.isHidden = true
                //wc.window?.standardWindowButton(.toolbarButton)?.isHidden = true
                //wc.window?.standardWindowButton(.documentIconButton)?.isHidden = true
                //wc.window?.standardWindowButton(.documentVersionsButton)?.isHidden = true
                //wc.window?.standardWindowButton(.fullScreenButton)?.isHidden = true
            }
		}
	}
    
    private func updateSelectionIndexes() {
        //let paths = Array(self.childConversations.keys)
        //    .flatMap { id in self.sortedConversations.index { $0.identifier == id } }
        //    .reduce(IndexSet()) { set, elem in set.insert(elem) }
        
        
        //self.listView.tableView.selectedRowIndexes = IndexSet()
        //self.listView.collectionView.animator().selectionIndexPaths = Set(paths)
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
		
        self.childConversations[conv2.identifier] = nil
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
		self.updateList()
		
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
		self.updateList()
    }
	
	/* TODO: Just update the row that is updated. */
    public func conversationList(_ list: Hangouts.ConversationList, didUpdateConversation conversation: IConversation) {
		self.updateList()
    }
    
    private func updateList() {
        DispatchQueue.main.async {
            //self.listView.dataSource = self.sortedConversations.map { Wrapper.init($0) }
            self.listView.update()
            let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
            NSApp.badgeCount = UInt(unread)
            self.updateSelectionIndexes()
        }
    }
}
