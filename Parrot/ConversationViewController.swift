import Cocoa
import Hangouts

class ConversationViewController:
    NSViewController,
    ConversationDelegate,
    NSTableViewDataSource,
    NSTableViewDelegate,
    NSTextFieldDelegate {

    @IBOutlet weak var conversationTableView: NSTableView!
    @IBOutlet weak var messageTextField: NSTextField!
	
	var notifications = [TokenObserver]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let scroll = self.view.subviews[0] as? NSScrollView
		scroll!.scrollerInsets = NSEdgeInsets(top: -48.0, left: 0, bottom: 0, right: 0)
		
        conversationTableView.setDataSource(self)
        conversationTableView.setDelegate(self)
        messageTextField.delegate = self
        self.view.postsFrameChangedNotifications = true
    }

    override func viewWillAppear() {
		self.notifications.append(Notifications.subscribe(NSWindowDidBecomeKeyNotification, object: self.window) { a in
			self.windowDidBecomeKey(nil)
		})
		
		self.notifications.append(Notifications.subscribe(NSViewFrameDidChangeNotification, object: self.view) { a in
			self.frameDidChangeNotification(nil)
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
			
			dispatch_async(dispatch_get_main_queue(), {
				self.conversationTableView.reloadData()
				self.conversationTableView.scrollRowToVisible(self.numberOfRowsInTableView(self.conversationTableView) - 1)
			})
        }
    }

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

    func attributedStringForMessage(row: Int) -> NSAttributedString? {
        if let conversation = conversation where row < conversation.messages.count {
            let message = conversation.messages[row]
            return TextMapper.attributedStringForText(message.text)
        }
        return nil
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
            if conversationTableView.numberOfRows == conversation.messages.count {
				dispatch_async(dispatch_get_main_queue(), {
					self.conversationTableView.insertRowsAtIndexes(
						NSIndexSet(index: conversation.messages.count),
						withAnimation: .SlideDown
					)
					self.conversationTableView.scrollRowToVisible(conversation.messages.count)
				})
            }
        case TypingType.STOPPED, TypingType.PAUSED:
            if conversationTableView.numberOfRows > conversation.messages.count {
				dispatch_async(dispatch_get_main_queue(), {
					self.conversationTableView.scrollRowToVisible(conversation.messages.count - 1)
					self.conversationTableView.removeRowsAtIndexes(
						NSIndexSet(index: conversation.messages.count),
						withAnimation: .SlideUp
					)
				})
            }
        default:
            break
        }
        //conversationTableView.reloadData()
    }

    func conversation(conversation: Conversation, didReceiveEvent event: Event) {
		dispatch_async(dispatch_get_main_queue(), {
			self.conversationTableView.reloadData()
			self.conversationTableView.scrollRowToVisible(self.numberOfRowsInTableView(self.conversationTableView) - 1)
		})

        if !(self.window?.keyWindow ?? false) {
            let user = conversation.user_list.get_user(event.user_id)
            if !user.isSelf {
                NotificationManager.sharedInstance.sendNotificationFor(event, fromUser: user)
            }
        }
    }

    func conversation(conversation: Conversation, didReceiveWatermarkNotification: WatermarkNotification) {

    }

    func conversationDidUpdateEvents(conversation: Conversation) {
		dispatch_async(dispatch_get_main_queue(), {
			self.conversationTableView.reloadData()
			self.conversationTableView.scrollRowToVisible(self.numberOfRowsInTableView(self.conversationTableView) - 1)
		})
    }

    func conversationDidUpdate(conversation: Conversation) {
        
    }

    // MARK: NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return conversation?.messages.count ?? 0
    }

    // MARK: NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let conversation = conversation where row < conversation.messages.count {
            var view = tableView.makeViewWithIdentifier(MessageView.className(), owner: self) as? MessageView

            if view == nil {
                view = MessageView(frame: NSZeroRect)
                view!.identifier = MessageView.className()
            }
			
			let message = conversation.messages[row]
			let user = conversation.user_list.get_user(message.user_id)
			let network = conversation.conversation.network_type![0] as! Int
			var color: NSColor?
			if user.isSelf {
				color = NSColor.materialBlueGreyColor()
			} else if network == 1 {
				color = NSColor.materialGreenColor()
			} else if network == 2 {
				color = NSColor.materialBlueColor()
			}
			
            view!.objectValue = Wrapper<MessageView.Configuration>((TextMapper.attributedStringForText(message.text),
									orientation: user.isSelf ? .Right : .Left,
									color: color!))
            return view
        }
		
        if conversation?.otherUserIsTyping ?? false {
            print("THEY'RE TYPING!")
        }
		
        return nil
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if let conversation = conversation where row < conversation.messages.count {
			return MessageView.heightForContainerWidth(attributedStringForMessage(row)!, width: self.view.frame.width)
		}
		return 0
    }

    // MARK: Window notifications

    func windowDidBecomeKey(sender: AnyObject?) {
        if let conversation = conversation {
            NotificationManager.sharedInstance.clearNotificationsFor(conversation)
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

    func frameDidChangeNotification(sender: AnyObject?) {
        //  TODO: This is a horrible, horrible way to do this, and super CPU-intensive.
        //  B U T   I T   W O R K S   F O R   N O W
		//dispatch_async(dispatch_get_main_queue(), {
		//	self.conversationTableView.reloadData()
		//})
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

    @IBAction func conversationTableViewDidAction(sender: AnyObject) {
        self.window?.makeFirstResponder(messageTextField)
    }
}
