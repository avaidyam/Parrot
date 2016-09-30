import Cocoa
import Hangouts
import ParrotServiceExtension

/* TODO: Re-enable link previews later when they're not terrible... */
/* TODO: Use the PlaceholderMessage for sending messages. */
/* TODO: When selecting text and typing a completion character, wrap the text. */

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
	@IBOutlet var indicator: NSProgressIndicator!
    @IBOutlet var entryView: NSTextView!
	@IBOutlet var statusView: NSTextField!
	@IBOutlet var imageView: NSButton!
	@IBOutlet var drawer: NSDrawer!
	@IBOutlet var drawerButton: NSButton!
	@IBOutlet var drawerView: NSView!
	
	// TODO: BEGONE!
	public var sendMessageHandler: (String, ParrotServiceExtension.Conversation) -> Void = {_ in}
	
	var _previews = [String: [LinkPreviewType]]()
	var _focusRow = -1
	var _note: NSObjectProtocol!
	lazy var popover: NSPopover = {
		let p = NSPopover()
		let v = NSViewController()
		v.view = self.statusView!
		p.contentViewController = v
		p.behavior = .applicationDefined
		return p
	}()
	
	private var dataSource: [EventStreamItem] = []
	
	public override func loadWindow() {
		super.loadWindow()
		self.drawer.__setupModernDrawer()
		
		self.window?.appearance = ParrotAppearance.interfaceStyle().appearance()
		self.window?.enableRealTitlebarVibrancy(.withinWindow)
		self.window?.titleVisibility = .hidden
		
		ParrotAppearance.registerVibrancyStyleListener(observer: self, invokeImmediately: true) { style in
			guard let vev = self.window?.contentView as? NSVisualEffectView else { return }
			vev.state = style.visualEffectState()
			guard let vev2 = self.drawer.contentView as? NSVisualEffectView else { return }
			vev2.state = style.visualEffectState()
		}
		
		self.listView.register(nibName: "MessageCell", forClass: MessageCell.self)
		self.listView.register(nibName: "FocusCell", forClass: FocusCell.self)
		self.listView.register(nibName: "LinkPreviewCell", forClass: LinkPreviewCell.self)
		
		// oh lawd pls forgibs my sins
		self.listView.dataSourceProvider = { // watch for invalid Collection: count differed in successive traversals
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
		
		// [BUG] [macOS 12] NSTextView doesn't fill width if layer-backed?
		if let text = self.entryView {
			text.frame = text.enclosingScrollView!.bounds
		}
    }
	
	public override func showWindow(_ sender: AnyObject?) {
		super.showWindow(nil)
        self.animatedUpdate(true)
		self.listView.insets = EdgeInsets(top: 36.0, left: 0, bottom: 40.0, right: 0)
		
		/*
		if self.window?.isKeyWindow ?? false {
			self.windowDidBecomeKey(Notification(name: "" as Notification.Name))
		}
		*/
		self.windowDidChangeOcclusionState(Notification(name: "" as Notification.Name))
		
		// Set up dark/light notifications.
		ParrotAppearance.registerInterfaceStyleListener(observer: self, invokeImmediately: true) { interface in
			self.window?.appearance = interface.appearance()
			self.drawer.window?.appearance = interface.appearance()
			
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
		
		/*
		runSelectionPanel(for: self.window!, fileTypes: ["mp3", "caf", "aiff", "wav"]) {
			log.debug("received \($0)")
		}*/
    }
	
	// Performs a visual refresh of the conversation list.
    // If preconfigure is true, it specifies that this is init stuff.
	private func animatedUpdate(_ preconfigure: Bool = false) {
		DispatchQueue.main.async {
			self.listView.superview!.isHidden = true
			self.indicator.alphaValue = 1.0
			self.indicator.isHidden = false
			self.indicator.startAnimation(nil)
			
            //if preconfigure { return }
			self.listView.update(animated: false) {
				self.listView.superview!.animator().isHidden = false
				self.indicator.animator().alphaValue = 0.0
				
				let scaleIn = CAAnimation.scaleIn(forFrame: self.listView.superview!.layer!.frame)
				self.listView.superview!.layer?.add(scaleIn, forKey: "updates")
				
				let durMS = Int(NSAnimationContext.current().duration * 1000.0)
				DispatchQueue.main.after(when: .now() + .milliseconds(durMS)) {
					self.indicator.stopAnimation(nil)
					self.indicator.isHidden = true
                    
                    // Fixes the loss of responder when hiding the view.
                    self.window?.makeFirstResponder(self.entryView)
				}
			}
		}
	}
	
	// NSWindowOcclusionState: 8194 is Visible, 8192 is Occluded
	public func windowDidChangeOcclusionState(_ notification: Notification) {
		self.conversation?.setFocus(self.window!.occlusionState.rawValue == 8194)
	}
    
    public func windowShouldClose(_ sender: AnyObject) -> Bool {
        //guard let self.
        if let w = self.window {
            let old_rect = w.frame
            var rect = w.frame
            rect.origin.y = -(rect.height)
            
            /* // It's a good idea but also needs some work.
            let animT = NSClassFromString("NSWindowScaleAnimation") as! NSAnimation.Type,
                anim = animT.init(duration: 0.25, animationCurve: .easeIn)
            anim.setValue(w, forKey: "window")
            anim.setValue(1.0, forKey: "startScale")
            anim.setValue(0.5, forKey: "endScale")
            anim.animationBlockingMode = .nonblocking
            anim.start()
            */
            //DispatchQueue.main.after(when: .now() + .milliseconds(250)) {
                NSAnimationContext.runAnimationGroup({ ctx in
                    ctx.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                    w.animator().setFrame(rect, display: true)
                    w.animator().alphaValue = 0.0
                }, completionHandler: {
                    w.setFrame(old_rect, display: false)
                    w.alphaValue = 1.0
                    w.close()
                })
            //}
        }
        return false
    }
	
	public func windowWillClose(_ notification: Notification) {
		ParrotAppearance.unregisterInterfaceStyleListener(observer: self)
	}
	
	var conversation: IConversation? {
		didSet {
			//DispatchQueue.main.sync {
				self.window?.title = self.conversation?.name ?? ""
				self.window?.setFrameAutosaveName("\(self.conversation?.identifier)")
			//}
			
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
					}
				}
				self.animatedUpdate()
			}
			
			/*
			self.conversation!.messages.map {
				if let prev = self._previews[($0 as! IChatMessageEvent).id] {
					let ret = [$0 as Any] + prev.map { $0 as Any }
					return ret
				} else { return [$0 as Any] }
			}.reduce([], combine: +)
			*/
			//self.listView?.update()
		}
	}
	
    public func conversation(_ conversation: IConversation, didChangeTypingStatusForUser user: User, toStatus status: TypingType) {
		guard !user.isSelf else { return }
		DispatchQueue.main.async {
			switch (status) {
			case TypingType.Started:
				//let cell = self.listView.tableView.make(withIdentifier: "Typing", owner: nil)
				self.popover.show(relativeTo: self.entryView!.bounds.offsetBy(dx: 0, dy: -16), of: self.entryView!.superview!, preferredEdge: .minY)
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
		let idx = IndexSet(integer: self.dataSource.count - 1)
		DispatchQueue.main.async {
			self.listView.tableView.insertRows(at: idx, withAnimation: [.effectFade, .slideUp])
		}
		self.listView.scroll(toRow: idx.first!)
    }
	public func conversation(_ conversation: IConversation, didReceiveWatermarkNotification: IWatermarkNotification) {}
	public func conversationDidUpdateEvents(_ conversation: IConversation) {}
    public func conversationDidUpdate(conversation: IConversation) {}
	
	@IBAction public func toggleMute(_ sender: AnyObject?) {
		guard let button = sender as? NSButton else { return }
		
		// Swap button images on toggle.
		let altI = button.alternateImage
		button.alternateImage = button.image
		button.image = altI
		
		// Swap button titles on toggle.
		let altT = button.alternateTitle
		button.alternateTitle = button.title
		button.title = altT
		
		// Mute or unmute the conversation.
		var cv = self.conversation as! ParrotServiceExtension.Conversation
		cv.muted = (button.state == NSOnState ? true : false)
	}
	
    // MARK: Window notifications
	
	public func windowDidBecomeKey(_ notification: Notification) {
        if let conversation = conversation {
			NSUserNotification.notifications()
				.filter { $0.identifier == conversation.id }
				.forEach { $0.remove() }
        }
		
        // Delay here to ensure that small context switches don't send focus messages.
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
	
	// Bind the drawer state to the button that toggles it.
	public func drawerWillOpen(_ notification: Notification) {
		self.drawerButton.state = NSOnState
		self.drawer.window?.animator().alphaValue = 1.0
	}
	public func drawerWillClose(_ notification: Notification) {
		self.drawerButton.state = NSOffState
		self.drawer.window?.animator().alphaValue = 0.0
	}
	
	//func textViewDidChangeText?
	
    // MARK: NSTextFieldDelegate
    var lastTypingTimestamp: Date?
	public func textDidChange(_ obj: Notification) {
        if entryView.string == "" {
			entryView.font = NSFont.systemFont(ofSize: 12.0)
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
			} else {
				self.conversation?.setTyping(typing: TypingType.Paused)
			}
        }
    }
	
	// If the user presses ENTER and doesn't hold SHIFT, send the message.
	// If the user presses TAB, insert four spaces instead. // TODO: configurable later
	public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		switch commandSelector {
			
		case #selector(NSResponder.insertNewline(_:)) where !NSEvent.modifierFlags().contains(.shift):
			guard let text = entryView.string where text.characters.count > 0 else { return true }
			NSSpellChecker.shared().dismissCorrectionIndicator(for: textView)
			self.entryView.string = ""
			self.sendMessageHandler(text, self.conversation!)
			//self.parentController?.sendMessage(text, self.conversation!)
			
		case #selector(NSResponder.insertTab(_:)):
			textView.textStorage?.append(AttributedString(string: "    ", attributes: textView.typingAttributes))
			
		default: return false
		}; return true
	}
	
	private var insertToken = false
	public func textView(_ textView: NSTextView, didInsertText string: AnyObject, replacementRange: NSRange) {
		guard !insertToken else { insertToken = false; return }
		
		/* // Only deal with actual Strings, not AttributedStrings.
		var inserted = string as? String
		if let str = string as? AttributedString {
			inserted = str.string
		}
		guard let insertedStr = inserted else { return }
		*/
		
		// Use the user's last entered word as the entry.
		let tString = textView.attributedString().string as NSString
		var _r = tString.range(of: " ", options: .backwardsSearch)
		if _r.location == NSNotFound { _r.location = 0 } else { _r.location += 1 }
		let userRange = NSMakeRange(_r.location, tString.length - _r.location)
		let userStr = tString.substring(from: _r.location)
		
		NSSpellChecker.shared().dismissCorrectionIndicator(for: textView)
		if let r = Settings[Parrot.Completions]?[userStr] as? String {
			insertToken = true // prevent re-entrance
			
			// If the entered text was a completion character, place the matching
			// one after the insertion point and move the cursor back.
			textView.insertText(r, replacementRange: self.entryView.selectedRange())
			textView.moveBackward(nil)
			
			// Display a text bubble showing visual replacement to the user.
			let range = NSMakeRange(textView.attributedString().length - r.characters.count, r.characters.count)
			textView.showFindIndicator(for: range)
		} else if let found = emoticonDescriptors[userStr] {
			insertToken = true // prevent re-entrance
			
			// Handle emoticon replacement.
			let attr = AttributedString(string: found, attributes: textView.typingAttributes)
			textView.insertText(attr, replacementRange: userRange)
			let range = NSMakeRange(_r.location, 1)
			NSSpellChecker.shared().showCorrectionIndicator(
				of: .reversion,
				primaryString: userStr,
				alternativeStrings: [found],
				forStringIn: textView.characterRect(forRange: range),
				view: textView) { [weak textView] in
					guard $0 != nil else { return }
					log.debug("user selected \($0)")
					//textView?.insertText($0, replacementRange: range)
					textView?.showFindIndicator(for: userRange)
			}
			textView.showFindIndicator(for: range)
		}
	}
}
