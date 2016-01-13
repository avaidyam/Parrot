import Cocoa
import Hangouts

class ConversationViewController: NSViewController, ConversationDelegate, NSTextFieldDelegate {

	@IBOutlet var messagesView: MessagesView!
    @IBOutlet weak var messageTextField: NSTextField!
	@IBOutlet var statusView: NSTextField!
	
	var popover: NSPopover!
	
	var notifications = [TokenObserver]()
	
	var conversation: Conversation? {
		get {
			return representedObject as? Conversation
		}
	}
	
	var window: NSWindow? {
		get {
			return self.view.window
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.messagesView.insets = NSEdgeInsets(top: -48.0, left: 0, bottom: 0, right: 0)
        messageTextField.delegate = self
        self.view.postsFrameChangedNotifications = true
		
		self.popover = NSPopover()
		self.popover.contentViewController = NSViewController()
		self.popover.contentViewController!.view = self.statusView
		self.popover.behavior = .ApplicationDefined
    }

    override func viewWillAppear() {
		self.notifications.append(Notifications.subscribe(NSWindowDidBecomeKeyNotification, object: self.window) { a in
			self.windowDidBecomeKey(nil)
		})
		
        if self.window?.keyWindow ?? false {
            self.windowDidBecomeKey(nil)
        }

        if let window = self.window, name = conversation?.name {
            window.title = name
		}
    }

    override func viewWillDisappear() {
		self.notifications.forEach {
			Notifications.unsubscribe($0)
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

    // conversation delegate
    func conversation(
        conversation: Conversation,
        didChangeTypingStatusForUser user: User,
        toStatus status: TypingType
    ) {
        if user.isSelf {
            return
        }
		
        switch (status) {
        case TypingType.STARTED:
			self.popover.showRelativeToRect(self.messageTextField!.bounds, ofView: self.messageTextField!, preferredEdge: .MaxY)
			self.statusView.stringValue = "Typing..."
		case TypingType.PAUSED:
			self.statusView.stringValue = "Entered text"
		default: // .STOPPED, .UNKNOWN
			self.popover.performClose(self)
			self.statusView.stringValue = "None"
        }
        //conversationTableView.reloadData()
    }

	func conversation(conversation: Conversation, didReceiveEvent event: Event) {
		
		self.messagesView.dataSource = self._getAllMessages()!
		let msg = conversation.events.filter { $0.id == event.id }.map { _getMessage($0 as! ChatMessageEvent)! }
		//self.messagesView.appendElements(found)
		print("got \(msg)")
		
        if !(self.window?.keyWindow ?? false) {
            let user = conversation.user_list.get_user(event.user_id)
            if !user.isSelf {
				let a = (event.event.conversation_id.id as! GroupID, event.id as ItemID)
				let text = event.event.chat_message?.message_content.segment?.first?.text as? String
				
				let notification = NSUserNotification()
				notification.title = user.full_name
				notification.informativeText = text
				notification.deliveryDate = NSDate()
				notification.soundName = NSUserNotificationDefaultSoundName
				notification.contentImage = ImageCache.sharedInstance.getImage(forUser: user)
				
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
	
	// get a single message
	private func _getMessage(message: ChatMessageEvent) -> Message? {
		/*if conversation != nil {
			let user = conversation!.user_list.get_user(message.user_id)
			let network = conversation!.conversation.network_type![0] as! Int
			var color: NSColor?
			if user.isSelf {
				color = NSColor.materialBlueGreyColor()
			} else if network == 1 {
				color = NSColor.materialGreenColor()
			} else if network == 2 {
				color = NSColor.materialBlueColor()
			}
			return Message(string: TextMapper.attributedStringForText(message.text),
				orientation: (user.isSelf ? .Right : .Left), color: color!)
		}*/
		return nil
	}
	
	// get all messages
	private func _getAllMessages() -> [Message]? {
		return conversation?.messages.map { message in
			let user = conversation!.user_list.get_user(message.user_id)
			let network = conversation!.conversation.network_type![0] as! Int
			var color: NSColor?
			if user.isSelf {
				color = NSColor.materialBlueGreyColor()
			} else if network == 1 {
				color = NSColor.materialGreenColor()
			} else if network == 2 {
				color = NSColor.materialBlueColor()
			}
			return Message(string: TextMapper.attributedStringForText(message.text),
				orientation: (user.isSelf ? .Right : .Left), color: color!)
		}
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
			conversation?.sendMessage(TextMapper.segmentsForInput(text, emojify: emojify))
            messageTextField.stringValue = ""
        }
    }
}
