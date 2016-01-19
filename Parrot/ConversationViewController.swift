import Cocoa
import Hangouts

/* TODO: Use NSWindow occlusion API to fully support focus. */

class ConversationViewController: NSViewController, ConversationDelegate, NSTextFieldDelegate {
	
	@IBOutlet var messagesView: MessagesView!
    @IBOutlet weak var messageTextField: NSTextField!
	@IBOutlet var statusView: NSTextField!
	
	var _note: TokenObserver!
	var popover: NSPopover!
	var conversation: Conversation? {
		get { return representedObject as? Conversation }
	}
	var window: NSWindow? {
		get { return self.view.window }
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.messagesView.insets = NSEdgeInsets(top: -48.0, left: 0, bottom: 0, right: 0)
        self.messageTextField.delegate = self
		
		self.popover = NSPopover()
		self.popover.contentViewController = NSViewController()
		self.popover.contentViewController!.view = self.statusView
		self.popover.behavior = .ApplicationDefined
    }

    override func viewWillAppear() {
		_note = Notifications.subscribe(NSWindowDidBecomeKeyNotification, object: self.window) { a in
			self.windowDidBecomeKey(nil)
		}
        if self.window?.keyWindow ?? false {
            self.windowDidBecomeKey(nil)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
            if let oldConversation = oldValue as? Conversation {
                oldConversation.delegate = nil
            }

            self.conversation?.delegate = self
			self.conversation?.getEvents(conversation?.events.first?.id, max_events: 50)
			
			//self.messagesView.removeElements(self._getAllMessages()!)
			self.messagesView.dataSource = self._getAllMessages()!
        }
    }
	
    func conversation(conversation: Conversation, didChangeTypingStatusForUser user: User, toStatus status: TypingType) {
        if user.isSelf {
            return
        }
		
		UI {
			switch (status) {
			case TypingType.STARTED:
				self.popover.showRelativeToRect(self.messageTextField!.bounds, ofView: self.messageTextField!, preferredEdge: .MinY)
				self.statusView.stringValue = "Typing..."
			case TypingType.PAUSED:
				self.statusView.stringValue = "Entered text."
			default: // .STOPPED, .UNKNOWN
				self.popover.performClose(self)
				self.statusView.stringValue = "Done."
			}
		}
    }

	func conversation(conversation: Conversation, didReceiveEvent event: Event) {
		self.messagesView.dataSource = self._getAllMessages()!
		
		//let msg = conversation.events.filter { $0.id == event.id }.map { _getMessage($0 as! ChatMessageEvent)! }
		//self.messagesView.appendElements(found)
		//print("got \(msg)")
		
        if !(self.window?.keyWindow ?? false) {
            let user = conversation.user_list[event.userID]
            if !user.isSelf {
				let a = (event.conversation_id as String, event.id as String)
				let text = (event as? ChatMessageEvent)?.text ?? "Event"
				
				let notification = NSUserNotification()
				notification.title = user.fullName
				notification.informativeText = text
				notification.deliveryDate = NSDate()
				notification.soundName = NSUserNotificationDefaultSoundName
				
				var img: NSImage = defaultUserImage
				if let d = fetchData(user.id.chatID, user.photoURL) {
					img = NSImage(data: d)!
				}
				notification.contentImage = img
				
				NotificationManager.sharedInstance.sendNotificationFor(a, notification: notification)
            }
        }
    }

    func conversation(conversation: Conversation, didReceiveWatermarkNotification: WatermarkNotification) {

    }

	func conversationDidUpdateEvents(conversation: Conversation) {
		self.messagesView.dataSource = self._getAllMessages()!
    }

    func conversationDidUpdate(conversation: Conversation) {
        
    }
	
	// get all messages
	private func _getAllMessages() -> [Message]? {
		return self.conversation?.messages.map { _getMessage($0) }
	}
	
	// get a single message
	func _getMessage(ev: ChatMessageEvent) -> Message {
		let user = self.conversation!.user_list[ev.userID]
		let network_ = self.conversation!.conversation.network_type as NSArray
		let network = NetworkType(value: network_[0] as! NSNumber)
		
		var color: NSColor = NSColor.materialBlueGreyColor()
		if !user.isSelf && network == NetworkType.BABEL {
			color = NSColor.materialGreenColor()
		} else if !user.isSelf && network == NetworkType.GVOICE {
			color = NSColor.materialBlueColor()
		}
		
		let text = ConversationViewController.attributedStringForText(ev.text)
		let orientation = (user.isSelf ? NSTextAlignment.Right : .Left)
		
		return Message(string: text, orientation: orientation, color: color)
	}
	
    // MARK: Window notifications

    func windowDidBecomeKey(sender: AnyObject?) {
        if let conversation = conversation {
            NotificationManager.sharedInstance.clearNotificationsFor(conversation.id)
        }

        //  Delay here to ensure that small context switches don't send focus messages.
		let dt = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
		dispatch_after(dt, dispatch_get_main_queue()) {
            if let window = self.window where window.keyWindow {
                self.conversation?.setFocus()
            }
            self.conversation?.updateReadTimestamp()
        }
    }

    // MARK: NSTextFieldDelegate
    var lastTypingTimestamp: NSDate?
    override func controlTextDidChange(obj: NSNotification) {
        if messageTextField.stringValue == "" {
            return
        }

        let typingTimeout = 0.4
        let now = NSDate()

        if lastTypingTimestamp == nil || NSDate().timeIntervalSinceDate(lastTypingTimestamp!) > typingTimeout {
            self.conversation?.setTyping(TypingType.STARTED)
        }

        lastTypingTimestamp = now
		let dt = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
		dispatch_after(dt, dispatch_get_main_queue()) {
            if let ts = self.lastTypingTimestamp where NSDate().timeIntervalSinceDate(ts) > typingTimeout {
                self.conversation?.setTyping(TypingType.STOPPED)
            }
        }
    }

    // MARK: IBActions
    @IBAction func messageTextFieldDidAction(_:AnyObject?) {
		if NSEvent.modifierFlags().contains(.ShiftKeyMask) {
			return
		}
		
        let text = messageTextField.stringValue
        if text.characters.count > 0 {
			var emojify = Settings()[Parrot.AutoEmoji] as? Bool ?? false
			emojify = NSEvent.modifierFlags().contains(.AlternateKeyMask) ? false : emojify
			conversation?.sendMessage(ConversationViewController.segmentsForInput(text, emojify: emojify))
            messageTextField.stringValue = ""
        }
    }
	
	private class func segmentsForInput(text: String, emojify: Bool = true) -> [ChatMessageSegment] {
		return [ChatMessageSegment(text: (emojify ? text.applyGoogleEmoji(): text))]
	}
	
	private class func attributedStringForText(text: String) -> NSAttributedString {
		let attrString = NSMutableAttributedString(string: text)
		
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = NSLineBreakMode.ByWordWrapping
		
		let linkDetector = try! NSDataDetector(types: NSTextCheckingType.Link.rawValue)
		for match in linkDetector.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count)) {
			if let url = match.URL {
				attrString.addAttribute(NSLinkAttributeName, value: url, range: match.range)
				attrString.addAttribute(
					NSUnderlineStyleAttributeName,
					value: NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue),
					range: match.range
				)
			}
		}
		
		/* TODO: Move this paragraph style and font stuff to the view. */
		attrString.addAttribute(
			NSFontAttributeName,
			value: NSFont.systemFontOfSize(12),
			range: NSMakeRange(0, attrString.length)
		)
		
		attrString.addAttribute(
			NSParagraphStyleAttributeName,
			value: style,
			range: NSMakeRange(0, attrString.length)
		)
		
		return attrString
	}
}
