import Cocoa
import Hangouts

/* TODO: Use NSWindow occlusion API to fully support focus. */

class ConversationViewController: NSViewController, ConversationDelegate, NSTextViewDelegate {
	
	@IBOutlet var messagesView: MessagesView!
    @IBOutlet var messageTextField: NSTextView!
	@IBOutlet var statusView: NSTextField!
	
	var _note: NSObjectProtocol!
	var popover: NSPopover!
	
	var _measure: MessageView? = nil
	
	private var _textBack: NSColor {
		if self.view.effectiveAppearance.name == NSAppearanceNameVibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.2)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.1)
		}
	}
	
	private var _textFront: NSColor {
		if self.view.effectiveAppearance.name == NSAppearanceNameVibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.5)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.6)
		}
	}
	
	override func loadView() {
		super.loadView()
		
		// Set up the measurement view.
		let nib = NSNib(nibNamed: "MessageView", bundle: nil)
		messagesView.tableView.register(nib, forIdentifier: MessageView.className())
		let stuff = nib?.instantiate(nil)
		_measure = stuff?.filter { $0 is MessageView }.first as? MessageView// stuff[0]: NSApplication
		
		NotificationCenter.default().addObserver(forName: UserNotification.didActivateNotification, object: nil, queue: nil) { n in
			guard let u = n.object as? UserNotification where u.identifier ?? "" == self.conversation?.id else { return }
			print("note \(u.identifier) with response \(u.response)")
			guard u.response != nil else { return }
			
			let emojify = Settings[Parrot.AutoEmoji] as? Bool ?? false
			let txt = ConversationViewController.segmentsForInput(u.response!.string, emojify: emojify)
			self.conversation?.sendMessage(segments: txt)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.messagesView.insets = EdgeInsets(top: 48.0, left: 0, bottom: 0, right: 0)
		self.messagesView.sizeClass = .dynamic
        self.messageTextField.delegate = self
		
		self.messagesView.dynamicHeightProvider = { (row: Int) -> Double in
			
			// TODO: Use the cached measurement sample and grab its frame after layout.
			let a = (self.messagesView.dataSource[row].element as? Message)!.string
			//self._measure?.textLabel?.string = a as String
			//self._measure?.layout()
			//print(self._measure?.frame.size.height)
			
			let b = self.messagesView.frame.width
			return Double(MessageView.heightForContainerWidth(a, width: b)) + 20.0
		}
		
		self.popover = NSPopover()
		self.popover.contentViewController = NSViewController()
		self.popover.contentViewController!.view = self.statusView
		self.popover.behavior = .applicationDefined
    }

    override func viewWillAppear() {
		_note = NotificationCenter.default().addObserver(forName: Notification.Name.NSWindowDidBecomeKey, object: self.window, queue: nil) { a in
			self.windowDidBecomeKey(nil)
		}
        if self.window?.isKeyWindow ?? false {
            self.windowDidBecomeKey(nil)
        }
		
		// woohoo this is a terrible idea, move this out of here later.
		self.window?.collectionBehavior = [.fullScreenAuxiliary, .fullScreenAllowsTiling]
		
		// Set up dark/light notifications.
		ParrotAppearance.registerAppearanceListener(observer: self) { appearance in
			self.view.window?.appearance = appearance
			
			if let text = self.messageTextField, let layer = text.enclosingScrollView?.layer {
				layer.masksToBounds = true
				layer.cornerRadius = 2.0
				layer.backgroundColor = self._textBack.cgColor
				// FIXME: If the appearance changes, the layer disappears...
				
				// NSTextView doesn't automatically change its text color when the
				// backing view's appearance changes, so we need to set it each time.
				// In addition, make sure links aren't blue as usual.
				text.textColor = NSColor.labelColor()
				text.linkTextAttributes = [
					NSCursorAttributeName: NSColor.labelColor()
				]
				text.selectedTextAttributes = [
					NSBackgroundColorAttributeName: self._textFront,
					NSForegroundColorAttributeName: NSColor.labelColor(),
				]
			}
		}
    }
	
	override func viewDidDisappear() {
		ParrotAppearance.unregisterAppearanceListener(observer: self)
	}

    override var representedObject: AnyObject? {
        didSet {
            if let oldConversation = oldValue as? IConversation {
                oldConversation.delegate = nil
            }

            self.conversation?.delegate = self
			self.conversation?.getEvents(event_id: conversation?.events.first?.id, max_events: 50)
			self.title = self.conversation?.name
			
			self.conversation?.client.queryPresence(chat_ids: self.conversation!.users.map { $0.id.chatID }) { response in
				//print("GOT \(response?.presenceResult)")
			}
			
			//self.messagesView.removeElements(self._getAllMessages()!)
			if self.messagesView != nil {
				self.messagesView.dataSource = self._getAllMessages()!.map { Wrapper.init($0) }
			} else {
				print("Not initialized.")
			}
        }
	}
	
	var conversation: IConversation? {
		return representedObject as? IConversation
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
				self.popover.show(relativeTo: self.messageTextField!.bounds, of: self.messageTextField!, preferredEdge: .minY)
				self.statusView.stringValue = "Typing..."
			case TypingType.Paused:
				self.statusView.stringValue = "Entered text."
			default: // .STOPPED, .UNKNOWN
				self.popover.performClose(self)
				self.statusView.stringValue = "Done."
			}
		}
    }

	func conversation(_ conversation: IConversation, didReceiveEvent event: IEvent) {
		self.messagesView.dataSource = self._getAllMessages()!.map { Wrapper.init($0) }
		
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
				notification.subtitle = "Hangouts"
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
		self.messagesView.dataSource = self._getAllMessages()!.map { Wrapper.init($0) }
    }

    func conversationDidUpdate(conversation: IConversation) {
        
    }
	
	// get all messages
	private func _getAllMessages() -> [Message]? {
		return self.conversation?.messages.map { _getMessage($0) }
	}
	
	// get a single message
	func _getMessage(_ ev: IChatMessageEvent) -> Message {
		let user = self.conversation!.user_list[ev.userID]
		let network_ = self.conversation!.conversation.networkType
		let network = NetworkType(rawValue: network_[0].rawValue) // FIXME weird stuff here
		
		var color: NSColor = #colorLiteral(red: 0.2078431398, green: 0.2823529541, blue: 0.3215686381, alpha: 1)
		if !user.isSelf && network == NetworkType.Babel {
			color = #colorLiteral(red: 0.03921568766, green: 0.9098039269, blue: 0.3686274588, alpha: 1)
		} else if !user.isSelf && network == NetworkType.GoogleVoice {
			color = #colorLiteral(red: 0, green: 0.611764729, blue: 1, alpha: 1)
		}
		let cap = network == NetworkType.GoogleVoice ? "Google Voice" : "Hangouts"
		
		let text = ev.text
		let orientation = (user.isSelf ? NSUserInterfaceLayoutDirection.rightToLeft : .leftToRight)
		
		// Load all the field values from the conversation.
		var img: NSImage = defaultUserImage
		if let d = fetchData(user.id.gaiaID, user.photoURL) {
			img = NSImage(data: d)!
		}
		
		let time = ev.timestamp ?? Date(timeIntervalSince1970: 0)
		return Message(photo: img, caption: cap, string: text,
		               orientation: orientation, color: color, time: time)
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
                self.conversation?.setFocus()
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

    // MARK: IBActions
    @IBAction func messageTextFieldDidAction(_:AnyObject?) {
		if NSEvent.modifierFlags().contains(.shift) {
			return
		}
		
        let text = messageTextField.string
        if text?.characters.count > 0 {
			var emojify = Settings[Parrot.AutoEmoji] as? Bool ?? false
			emojify = NSEvent.modifierFlags().contains(.option) ? false : emojify
			let txt = ConversationViewController.segmentsForInput(text!, emojify: emojify)
			conversation?.sendMessage(segments: txt)
            messageTextField.string = ""
			
			//NSAnimationContext.runAnimationGroup({ c in
			//	self.messagesView.tableView.noteHeightOfRows(withIndexesChanged: idx as IndexSet)
			//}, completionHandler: nil)
        }
    }
	
	private class func segmentsForInput(_ text: String, emojify: Bool = true) -> [IChatMessageSegment] {
		return [IChatMessageSegment(text: (emojify ? text.applyGoogleEmoji(): text))]
	}
}
