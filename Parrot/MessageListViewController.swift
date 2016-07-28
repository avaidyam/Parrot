import Cocoa
import Hangouts
import ParrotServiceExtension

/* TODO: Use NSTextAlternatives instead of force-replacing text. */
/* TODO: Needs a complete refactor, with something like CSS styling. */
/* TODO: Re-enable link previews later when they're not terrible... */
/* TODO: "Mention me when someone says [...]" option. */
/* TODO: Use the PlaceholderMessage for sending messages. */
/* TODO: When selecting text and typing a completion character, wrap the text. */
/* TODO: When typing a word and typing a completion character, wrap the entire word. */

private let completionsL = ["(", "[", "{", "\"", "'", "`", "*", "_", "-", "~"]
private let completionsR = [")", "]", "}", "\"", "'", "`", "*", "_", "-", "~"]

public class MessageListViewController: NSWindowController, NSTextViewExtendedDelegate, ConversationDelegate {
	
	// This is instantly shown to the user when they send a message. It will
	// be updated automatically when the status of the message is known.
	public struct PlaceholderMessage: Message {
		public let sender: Person?
		public let timestamp: Date
		public let text: String
		public var failed: Bool = false
	}
	
	@IBOutlet var listView: ListView!
    @IBOutlet var entryView: NSTextView!
	@IBOutlet var statusView: NSTextField!
	@IBOutlet var imageView: NSButton!
	
	public var parentController: ConversationListViewController? = nil
	
	var _previews = [String: [LinkPreviewType]]()
	var _focusRow = -1
	var _note: NSObjectProtocol!
	lazy var popover: NSPopover = {
		let p = NSPopover()
		let v = NSViewController()
		v.view = self.statusView.superview!
		p.contentViewController = v
		p.behavior = .applicationDefined
		return p
	}()
	
	private var dataSource: [EventStreamItem] = []
	
	public override func loadWindow() {
		super.loadWindow()
		self.window?.appearance = ParrotAppearance.current()
		self.window?.enableRealTitlebarVibrancy()
		self.window?.titleVisibility = .hidden
		
		self.listView.register(nibName: "MessageCell", forClass: MessageCell.self)
		self.listView.register(nibName: "FocusCell", forClass: FocusCell.self)
		self.listView.register(nibName: "LinkPreviewCell", forClass: LinkPreviewCell.self)
		
		// oh lawd pls forgibs my sins
		self.listView.dataSourceProvider = {
			return self.dataSource.map { $0 as Any }
		}
		
		self.listView.viewClassProvider = { row in
			let cls = self.listView.dataSourceProvider!()[row]
			if cls is Message {
				return MessageCell.self
			} else if cls is LinkPreviewType {
				return LinkPreviewCell.self
			} else {
				log.debug("\(row) OMG GOT NOTHING \(cls)")
				return ListViewCell.self
			}
		}
		
		self.listView.sizeClass = .dynamic
		self.entryView.delegate = self
		
		if let me = self.conversation?.client.userList.me {
			if let photo = self.imageView, let layer = photo.layer {
				layer.masksToBounds = true
				layer.cornerRadius = photo.bounds.width / 2.0
			}
			self.imageView.image = fetchImage(user: me as! User, conversation: self.conversation!)
		}
    }
	
	public override func showWindow(_ sender: AnyObject?) {
		super.showWindow(nil)
		self.listView.insets = EdgeInsets(top: 22.0, left: 0, bottom: 40.0, right: 0)
		
		/*
		if self.window?.isKeyWindow ?? false {
			self.windowDidBecomeKey(Notification(name: "" as Notification.Name))
		}
		*/
		self.windowDidChangeOcclusionState(Notification(name: "" as Notification.Name))
		
		// Set up dark/light notifications.
		ParrotAppearance.registerAppearanceListener(observer: self, invokeImmediately: true) { appearance in
			self.window?.appearance = appearance
			
			// NSTextView doesn't automatically change its text color when the
			// backing view's appearance changes, so we need to set it each time.
			// In addition, make sure links aren't blue as usual.
			guard let text = self.entryView else { return }
			text.layer?.masksToBounds = true
			text.layer?.cornerRadius = 2.0
			text.layer?.backgroundColor = NSColor.darkOverlay(forAppearance: self.window!.effectiveAppearance).cgColor
			
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
				NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.window!.effectiveAppearance),
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
			text.markedTextAttributes = [
				NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.window!.effectiveAppearance),
				NSForegroundColorAttributeName: NSColor.labelColor(),
				NSUnderlineStyleAttributeName: 0,
			]
			/*text.placeholderTextAttributes = [
				NSForegroundColorAttributeName: NSColor.tertiaryLabelColor(),
				NSFontAttributeName: text.font!
			]*/
		}
    }
	
	// NSWindowOcclusionState: 8194 is Visible, 8192 is Occluded
	public func windowDidChangeOcclusionState(_ notification: Notification) {
		self.conversation?.setFocus(self.window!.occlusionState.rawValue == 8194)
	}
	
	public func windowWillClose(_ notification: Notification) {
		ParrotAppearance.unregisterAppearanceListener(observer: self)
	}
	
	var conversation: IConversation? {
		didSet {
			/*
			if let oldConversation = oldValue {
				oldConversation.delegate = nil
			}
			self.conversation?.delegate = self
			*/
			
			self.conversation?.getEvents(event_id: nil, max_events: 50) { events in
				for chat in (events.flatMap { $0 as? IChatMessageEvent }) {
					self.dataSource.append(chat)
					linkQ.async {
						/*
						let d = try! NSDataDetector(types: TextCheckingResult.CheckingType.link.rawValue)
						let t = chat.text
						d.enumerateMatches(in: t, options: RegularExpression.MatchingOptions(rawValue: UInt(0)),
						                   range: NSMakeRange(0, t.unicodeScalars.count)) { (res, flag, stop) in
							let key = res!.url!.absoluteString!
							guard let meta = try? _getLinkCached(key) else { return }
							
							if let arr = self._previews[chat.id] {
								self._previews[chat.id] = arr + [meta]
							} else {
								self._previews[chat.id] = [meta]
							}
						}
						*/
						self.listView.update()
					}
				}
			}
			self.window?.title = self.conversation?.name ?? ""
			self.window?.setFrameAutosaveName("\(self.conversation?.identifier)")
			
			/*
			self.conversation!.messages.map {
				if let prev = self._previews[($0 as! IChatMessageEvent).id] {
					let ret = [$0 as Any] + prev.map { $0 as Any }
					return ret
				} else { return [$0 as Any] }
			}.reduce([], combine: +)
			*/
			self.listView?.update()
		}
	}
	
    public func conversation(_ conversation: IConversation, didChangeTypingStatusForUser user: User, toStatus status: TypingType) {
        guard !user.isSelf else { return }
		DispatchQueue.main.async {
			switch (status) {
			case TypingType.Started:
				//let cell = self.listView.tableView.make(withIdentifier: "Typing", owner: nil)
				self.popover.show(relativeTo: self.entryView!.bounds, of: self.entryView!, preferredEdge: .minY)
				self.statusView.stringValue = "Typing..."
			case TypingType.Paused:
				self.statusView.stringValue = "Entered text."
			case TypingType.Stopped: fallthrough
			default: // TypingType.Unknown:
				self.popover.performClose(self)
				self.statusView.stringValue = ""
			}
		}
    }
	public func conversation(_ conversation: IConversation, didReceiveEvent event: IEvent) {
		guard let e = event as? IChatMessageEvent else { return }
		self.dataSource.append(e)
		let idx = IndexSet(integer: self.dataSource.count-1)
		DispatchQueue.main.async {
			self.listView.tableView.insertRows(at: idx, withAnimation: [.effectFade, .slideUp])
		}
		DispatchQueue.main.async {
			self.listView.scroll(toRow: idx.first!)
		}
    }
	public func conversation(_ conversation: IConversation, didReceiveWatermarkNotification: IWatermarkNotification) {}
	public func conversationDidUpdateEvents(_ conversation: IConversation) {}
    public func conversationDidUpdate(conversation: IConversation) {}
	
    // MARK: Window notifications

	public func windowDidBecomeKey(_ notification: Notification) {
        if let conversation = conversation {
			UserNotificationCenter.remove(byIdentifier: conversation.id)
        }
		
        //  Delay here to ensure that small context switches don't send focus messages.
		DispatchQueue.main.after(when: .now() + .seconds(1)) {
            if let window = self.window where window.isKeyWindow {
				self.conversation?.setFocus(true) // set it here too just in case.
            }
			self.conversation?.updateReadTimestamp()
			
			// Get current states
			for state in self.conversation!.readStates {
				let person = self.conversation!.client.directory.people[state.participantId!.gaiaId!]!
				let timestamp = Date.from(UTC: Double(state.latestReadTimestamp!))
				//log.debug("conv => { conv: \(self.conversation!.conversation) }")
				log.debug("state => { person: \(person.nameComponents), timestamp: \(timestamp) }")
			}
			
			// Find the last visible row that was sent by the user.
			/*
			var lastR: Int = -1
			for r in self.listView.visibleRows {
				if self.conversation!._messages[r].sender.me {
					lastR = r
				}
			}
			
			// If we found a row, set the focus.
			if lastR > 0 {
				if let c = self.listView.tableView.view(atColumn: 0, row: lastR, makeIfNecessary: false) as? MessageCell {
					c.setFocus(true)
					self._focusRow = lastR
					self.listView.tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integer: lastR))
				}
			}*/
        }
    }
	
	//func textViewDidChangeText?
	
    // MARK: NSTextFieldDelegate
    var lastTypingTimestamp: Date?
	public func textDidChange(_ obj: Notification) {
        if entryView.string == "" {
            return
        }
		
		/*
		let typedStr = entryView.attributedSubstring(
			forProposedRange: entryView.rangeForUserCompletion,
			actualRange: nil)?.string
		log.debug("got \(typedStr)")
		*/
		
        let typingTimeout = 0.4
        let now = Date()
        if lastTypingTimestamp == nil || now.timeIntervalSince(lastTypingTimestamp!) > typingTimeout {
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
	// If the user presses TAB, insert four spaces instead. // TODO: configurable later
	public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		switch commandSelector {
			
		case #selector(NSResponder.insertNewline(_:)) where !NSEvent.modifierFlags().contains(.shift):
			guard let text = entryView.string where text.characters.count > 0 else { return true }
			self.entryView.string = ""
			self.parentController?.sendMessage(text, self.conversation!)
			
		case #selector(NSResponder.insertTab(_:)):
			textView.textStorage?.append(AttributedString(string: "    ", attributes: textView.typingAttributes))
			
		default: return false
		}; return true
	}
	
	private var insertToken = false
	public func textView(_ textView: NSTextView, didInsertText string: AnyObject, replacementRange: NSRange) {
		guard !insertToken else { insertToken = false; return }
		
		// Only deal with actual Strings, not AttributedStrings.
		var inserted = string as? String
		if let str = string as? AttributedString {
			inserted = str.string
		}
		guard let insertedStr = inserted else { return }
		
		// If the entered text was a completion character, place the matching
		// one after the insertion point and move the cursor back.
		if let r = completionsL.index(of: insertedStr) {
			insertToken = true // prevent re-entrance
			self.entryView.insertText(completionsR[r], replacementRange: self.entryView.selectedRange())
			self.entryView.moveBackward(nil)
		}
	}
	
	public func textView(_ textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>?) -> [String] {
		return ["this", "is", "a", "test"]
	}
}
