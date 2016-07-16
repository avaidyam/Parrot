import Cocoa
import Hangouts
import ParrotServiceExtension

/* TODO: Use NSTextAlternatives instead of force-replacing text. */
/* TODO: Smart entry completion for ()/[]/""/etc. */
/* TODO: Support /cmd's (i.e. /remove <username>) for power-users. */
/* TODO: Support Slack-like plugin integrations. */
/* TODO: Needs a complete refactor, with something like CSS styling. */

class MessageListViewController: NSViewController, ConversationDelegate, NSTextViewDelegate, NSTextDelegate {
	
	@IBOutlet var messagesView: ListView!
    @IBOutlet var messageTextField: NSTextView!
	@IBOutlet var statusView: NSTextField!
	@IBOutlet var imageView: NSImageView!
	
	var _measure: MessageView? = nil
	var _note: NSObjectProtocol!
	lazy var popover: NSPopover = {
		let p = NSPopover()
		let v = NSViewController()
		v.view = self.statusView
		p.contentViewController = v
		p.behavior = .applicationDefined
		return p
	}()
	
	static func display(from: NSViewController, conversation: ParrotServiceExtension.Conversation) -> MessageListViewController {
		let controller = MessageListViewController(nibName: "MessageListViewController", bundle: nil)!
		controller.conversation = (conversation as! IConversation) // FIXME FORCE DOWN-CAST TO HANGOUTS
		from.presentViewController(controller, animator: WindowTransitionAnimator { w in
			w.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView]
			w.collectionBehavior = [.managed, .participatesInCycle, .fullScreenAuxiliary, .fullScreenDisallowsTiling]
			w.appearance = ParrotAppearance.current()
			w.enableRealTitlebarVibrancy()
			
			// Because autosave is miserable.
			w.setFrameAutosaveName("\(conversation.identifier)")
			if w.frame == .zero {
				w.setFrame(NSRect(x: 0, y: 0, width: 480, height: 320), display: false, animate: true)
				w.center()
			}
		})
		return controller
	}
	
	override func loadView() {
		super.loadView()
		
		messagesView.viewClassProvider = { row in MessageView.self }
		
		// Set up the measurement view.
		let nib = NSNib(nibNamed: "MessageView", bundle: nil)
		messagesView.tableView.register(nib, forIdentifier: MessageView.className())
		messagesView.tableView.register(NSNib(nibNamed: "TypingEventView", bundle: nil), forIdentifier: "Typing")
		let stuff = nib?.instantiate(nil)
		_measure = stuff?.filter { $0 is MessageView }.first as? MessageView// stuff[0]: NSApplication
		
		NotificationCenter.default().addObserver(forName: UserNotification.didActivateNotification, object: nil, queue: nil) { n in
			guard let u = n.object as? UserNotification where u.identifier ?? "" == self.conversation?.id else { return }
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
		
		if let me = self.conversation?.client.userList.me {
			if let photo = self.imageView, let layer = photo.layer {
				layer.masksToBounds = true
				layer.cornerRadius = photo.bounds.width / 2.0
			}
			self.imageView.image = fetchImage(user: me as! User, conversation: self.conversation!)
		}
		
		self.messagesView.sizeClass = .dynamic
        self.messageTextField.delegate = self
		
		self.messagesView.dynamicHeightProvider = { (row: Int) -> Double in
			
			// TODO: Use the cached measurement sample and grab its frame after layout.
			let a = (self.messagesView.dataSource[row].element as? Message)!.text
			//self._measure?.textLabel?.string = a as String
			//self._measure?.layout()
			//log.info(self._measure?.frame.size.height)
			
			let b = self.messagesView.frame.width
			return MessageView.heightForContainerWidth(a, size: 12, width: b).native
		}
    }

    override func viewWillAppear() {
		_note = NotificationCenter.default().addObserver(forName: Notification.Name.NSWindowDidBecomeKey,
		                                                 object: self.window, queue: nil) { a in
			self.windowDidBecomeKey(nil)
		}
        if self.window?.isKeyWindow ?? false {
            self.windowDidBecomeKey(nil)
        }
		
		// NSWindowOcclusionState: 8194 is Visible, 8192 is Occluded,
		NotificationCenter.default().addObserver(forName: Notification.Name.NSWindowDidChangeOcclusionState,
		                                         object: self.window, queue: nil) { a in
			self.conversation?.focus = self.window!.occlusionState.rawValue == 8194
		}
		self.conversation?.focus = self.window!.occlusionState.rawValue == 8194
		
		// Set up dark/light notifications.
		ParrotAppearance.registerAppearanceListener(observer: self, invokeImmediately: true) { appearance in
			self.view.window?.appearance = appearance
			
			// NSTextView doesn't automatically change its text color when the
			// backing view's appearance changes, so we need to set it each time.
			// In addition, make sure links aren't blue as usual.
			guard let text = self.messageTextField else { return }
			text.layer?.masksToBounds = true
			text.layer?.cornerRadius = 2.0
			text.layer?.backgroundColor = NSColor.darkOverlay(forAppearance: self.view.effectiveAppearance).cgColor
			
			text.textColor = NSColor.labelColor()
			text.font = NSFont.systemFont(ofSize: 12.0)
			text.typingAttributes = [
				NSForegroundColorAttributeName: text.textColor!,
				NSFontAttributeName: text.font!
			]
			text.linkTextAttributes = [
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSCursorAttributeName: NSCursor.pointingHand(),
				NSUnderlineStyleAttributeName: 1,
			]
			text.selectedTextAttributes = [
				NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.view.effectiveAppearance),
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
			text.markedTextAttributes = [
				NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.view.effectiveAppearance),
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
			/*text.placeholderTextAttributes = [
				NSForegroundColorAttributeName: NSColor.tertiaryLabelColor(),
				NSFontAttributeName: text.font!
			]*/
		}
    }
	
	override func viewDidDisappear() {
		ParrotAppearance.unregisterAppearanceListener(observer: self)
	}
	
	var conversation: IConversation? {
		didSet {
			if let oldConversation = oldValue {
				oldConversation.delegate = nil
			}
			
			self.conversation?.delegate = self
			self.conversation?.getEvents(event_id: conversation?.events.first?.id, max_events: 50)
			self.title = self.conversation?.name
			
			/*self.conversation?.client.queryPresence(chat_ids: self.conversation!.users.map { $0.id.chatID }) { response in
			log.info("GOT \(response?.presenceResult)")
			}*/
			
			//self.messagesView.removeElements(self._getAllMessages()!)
			if self.messagesView != nil {
				self.messagesView.dataSource = self.conversation!.messages.map { Wrapper.init($0) }
			} else {
				//log.info("Not initialized.")
			}
		}
	}
	
	var window: NSWindow? {
		return self.view.window
	}
	
    func conversation(_ conversation: IConversation, didChangeTypingStatusForUser user: User, toStatus status: TypingType) {
        if user.isSelf || self.messageTextField?.window == nil {
            return
        }
		
		DispatchQueue.main.async {
			switch (status) {
			case TypingType.Started:
				//let cell = self.messagesView.tableView.make(withIdentifier: "Typing", owner: nil)
				self.popover.show(relativeTo: self.messageTextField!.bounds, of: self.messageTextField!, preferredEdge: .minY)
				self.statusView.stringValue = "Typing..."
			case TypingType.Paused:
				self.statusView.stringValue = "Entered text."
			case TypingType.Stopped: fallthrough
			default: // TypingType.Unknown:
				self.popover.performClose(self)
				self.statusView.stringValue = "Done."
			}
		}
    }

	func conversation(_ conversation: IConversation, didReceiveEvent event: IEvent) {
		self.messagesView.dataSource = self.conversation!.messages.map { Wrapper.init($0) }
		
		//let msg = conversation.events.filter { $0.id == event.id }.map { _getMessage($0 as! ChatMessageEvent)! }
		//self.messagesView.appendElements(found)
		if !(self.window?.isKeyWindow ?? false) {
			let user = conversation.user_list[event.userID]
			if !user.isSelf {
				let a = (event.conversation_id as String, event.id as String)
				let text = (event as? IChatMessageEvent)?.text ?? "Event"
				
				let notification = NSUserNotification()
				notification.identifier = a.0
				notification.title = user.fullName
				//notification.subtitle = "Hangouts"
				notification.informativeText = text
				notification.deliveryDate = Date()
				notification.hasReplyButton = true
				notification.responsePlaceholder = "Reply..."
				//notification.soundName = "texttone:Bamboo" // this works!!
				notification.set(option: .customSoundPath, value: "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/sms_alert_bamboo.caf")
				notification.set(option: .vibrateForceTouch, value: true)
				
				var img: NSImage = defaultUserImage
				if let d = fetchData(user.id.chatID, user.photoURL) {
					img = NSImage(data: d)!
				}
				notification.contentImage = img
				
				UserNotificationCenter.remove(byIdentifier: a.0)
				UserNotificationCenter.post(notification: notification)
            }
        }
    }

    func conversation(_ conversation: IConversation, didReceiveWatermarkNotification: IWatermarkNotification) {

    }

	func conversationDidUpdateEvents(_ conversation: IConversation) {
		self.messagesView.dataSource = self.conversation!.messages.map { Wrapper.init($0) }
    }

    func conversationDidUpdate(conversation: IConversation) {
        
    }
	
    // MARK: Window notifications

    func windowDidBecomeKey(_ sender: AnyObject?) {
        if let conversation = conversation {
			UserNotificationCenter.remove(byIdentifier: conversation.id)
        }

        //  Delay here to ensure that small context switches don't send focus messages.
		let dt = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.after(when: dt) {
            if let window = self.window where window.isKeyWindow {
				self.conversation?.focus = true // set it here too just in case.
            }
            self.conversation?.updateReadTimestamp()
        }
    }

    // MARK: NSTextFieldDelegate
    var lastTypingTimestamp: Date?
	func textDidChange(_ obj: Notification) {
        if messageTextField.string == "" {
            return
        }
		
        let typingTimeout = 0.4
        let now = Date()

        if lastTypingTimestamp == nil || Date().timeIntervalSince(lastTypingTimestamp!) > typingTimeout {
            self.conversation?.setTyping(typing: TypingType.Started)
        }

        lastTypingTimestamp = now
		let dt = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.after(when: dt) {
            if let ts = self.lastTypingTimestamp where Date().timeIntervalSince(ts) > typingTimeout {
                self.conversation?.setTyping(typing: TypingType.Stopped)
            }
        }
    }
	
	// If the user presses ENTER and doesn't hold SHIFT, send the message.
	func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		switch commandSelector {
			
		case #selector(NSResponder.insertNewline(_:)) where !NSEvent.modifierFlags().contains(.shift):
			self.sendCurrentMessage()
		case #selector(NSResponder.insertTab(_:)): // TODO: configurable later
			textView.textStorage?.append(AttributedString(string: "    ", attributes: textView.typingAttributes))
			
		default: return false
		}; return true
	}
	
	func textView(_ textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>?) -> [String] {
		return ["this", "is", "a", "test"]
	}
	
	//["()", "[]", "{}", "\"\"", "''", "``"]
	//func textViewDidChangeText?
	
	func sendCurrentMessage() {
		func segmentsForInput(_ text: String, emojify: Bool = true) -> [IChatMessageSegment] {
			return [IChatMessageSegment(text: (emojify ? text.applyGoogleEmoji(): text))]
		}
		
		// Grab a local copy of the text and let the user continue.
		guard let text = messageTextField.string where text.characters.count > 0 else { return }
		self.messageTextField.string = ""
		
		// Create an operation to process the message and then send it.
		let operation = DispatchWorkItem(group: nil, qos: .userInteractive, flags: [.enforceQoS]) {
			var emojify = Settings[Parrot.AutoEmoji] as? Bool ?? false
			emojify = NSEvent.modifierFlags().contains(.option) ? false : emojify
			let txt = segmentsForInput(text, emojify: emojify)
			
			let s = DispatchSemaphore.mutex
			self.conversation?.sendMessage(segments: txt) { s.signal() }
			s.wait()
		}
		
		// Send the operation to the serial send queue, and notify on completion.
		operation.notify(queue: DispatchQueue.main) {
			log.debug("message sent")
		}
		sendQ.async(execute: operation)
	}
}
