import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts
import ParrotServiceExtension
import protocol ParrotServiceExtension.Conversation

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: When moving window, use NSAlignmentFeedbackFilter to snap to size and edges of screen. */

let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", qos: .userInteractive)
let linkQ = DispatchQueue(label: "com.avaidyam.Parrot.linkQ", qos: .userInitiated)

public class ConversationListViewController: NSWindowController, ConversationListDelegate,
ListViewDataDelegate, ListViewSelectionDelegate, ListViewScrollbackDelegate, NSWindowDelegate {
	
    private lazy var listView: ListView = {
        let v = ListView().modernize()
        v.flowDirection = .top
        v.selectionType = .any
        v.delegate = self
        return v
    }()
    
    private lazy var indicator: NSProgressIndicator = {
        let v = NSProgressIndicator().modernize()
        v.usesThreadedAnimation = true
        v.isIndeterminate = true
        v.style = .spinningStyle
        return v
    }()
	
	private var updateToken: Bool = false
	private var userList: Directory?
    
    private lazy var updateInterpolation: Interpolate = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.listView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 0.0) { [weak self] in
            DispatchQueue.main.async {
                self?.indicator.startAnimation(nil)
            }
        }
        indicatorAnim.add(at: 1.0) { [weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimation(nil)
            }
        }
        indicatorAnim.handlerRunPolicy = .always
        let scaleAnim = Interpolate(from: CGAffineTransform(scaleX: 1.5, y: 1.5), to: .identity, interpolator: EaseInOutInterpolator()) { [weak self] scale in
            self?.listView.layer!.setAffineTransform(scale)
        }
        let group = Interpolate.group(indicatorAnim, scaleAnim)
        return group
    }()
    
    /// The childConversations keeps track of all open conversations and when the
    /// list is updated, it is cached and the list selection is synchronized.
    private var childConversations = [String: MessageListViewController]() {
        didSet {
            log.debug("Updating childConversations... \(Array(self.childConversations.keys))")
            Settings["Parrot.OpenConversations"] = Array(self.childConversations.keys)
            self.updateSelectionIndexes()
        }
    }
	
	var conversationList: ParrotServiceExtension.ConversationList? {
		didSet {
            (conversationList as? Hangouts.ConversationList)?.delegate = self // FIXME: FORCE-CAST TO HANGOUTS
            
            // Open conversations that were previously open.
            self.listView.update(animated: false) {
                self.updateInterpolation.animate(duration: 1.5)
                self.updateInterpolation.add(at: 1.0) {
                    // FIXME: If an old opened conversation isn't in the recents, it won't open!
                    (Settings["Parrot.OpenConversations"] as? [String])?
                        .flatMap { self.conversationList?[$0] }
                        .forEach { self.showConversation($0) }
                }
            }
		}
	}
	
    // FIXME: this is recomputed A LOT! bad idea...
    var sortedConversations: [ParrotServiceExtension.Conversation] {
		guard self.conversationList != nil else { return [] }
        return self.conversationList!.conversations.values
            .filter { !$0.archived }
            .sorted { $0.timestamp > $1.timestamp }
	}
    
    public init() {
        let w = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 256, height: 512),
                         styleMask: [.titled, .unifiedTitleAndToolbar, .resizable, .closable, .miniaturizable, .fullSizeContentView],
                         backing: .buffered, defer: true)
        super.init(window: w)
        
        // FIXME: needs a delegate :(
        let t = NSToolbar()
        t.insertItem(withItemIdentifier: NSToolbarFlexibleSpaceItemIdentifier, at: 0)
        w.toolbar = t
        
        // Center by default, but load a saved frame if available, and set the autosave.
        w.center()
        w.setFrameUsingName("Conversations")
        w.setFrameAutosaveName("Conversations")
        
        // Finish up initialization we lost by not using nibs.
        w.delegate = self
        self.windowDidLoad()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    public func cellHeight(in view: ListView, at: ListView.Index) -> Double {
        return 48.0 + 16.0 /* padding */
    }
    
    public func proposedSelection(in list: ListView, at: [ListView.Index]) -> [ListView.Index] {
        return list.selection + at // Only additive!
    }
    
    public func selectionChanged(in: ListView, is selection: [ListView.Index]) {
        let src = self.sortedConversations
        let dest = Set(self.childConversations.keys)
        let convs = Set(selection.map { src[Int($0.item)].identifier })
        
        // Conversations selected that we don't already have. --> ADD
        convs.subtracting(dest).forEach { id in
            log.debug("ADD: \(id)")
            let conv = self.sortedConversations.filter { $0.identifier == id }.first!
            self.showConversation(conv)
        }
        // Conversations we have that are not selected. --> REMOVE
        dest.subtracting(convs).forEach { id in
            log.debug("REMOVE: \(id)")
            let conv = self.sortedConversations.filter { $0.identifier == id }.first!
            self.hideConversation(conv)
        }
    }
    
    public func reachedEdge(in: ListView, edge: NSRectEdge) {
        func scrollback() {
            guard self.updateToken == false else { return }
            let _ = self.conversationList?.syncConversations(count: 25, since: self.conversationList!.syncTimestamp) { val in
                DispatchQueue.main.async {
                    self.listView.tableView.noteNumberOfRowsChanged()
                    self.updateToken = false
                }
            }
            self.updateToken = true
        }
        
        // Driver/filter here:
        switch edge {
        case .minY: scrollback()
        default: break
        }
    }
	
    public override func windowDidLoad() {
		self.window?.appearance = ParrotAppearance.interfaceStyle().appearance()
		self.window?.enableRealTitlebarVibrancy(.withinWindow)
        self.window?.titleVisibility = .hidden
        self.window?.titlebarAppearsTransparent = true
        self.window?.contentView!.superview?.wantsLayer = true
        
        self.window?.contentView?.add(subviews: [self.listView, self.indicator])
        
        self.window!.contentView!.centerX == self.indicator.centerX
        self.window!.contentView!.centerY == self.indicator.centerY
        self.window!.contentView!.centerX == self.listView.centerX
        self.window!.contentView!.centerY == self.listView.centerY
        self.window!.contentView!.width == self.listView.width
        self.window!.contentView!.height == self.listView.height
        
        let frame = self.listView.layer!.frame
        self.listView.layer!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.listView.layer!.position = CGPoint(x: frame.midX, y: frame.midY)
        self.listView.alphaValue = 0.0
        
		ParrotAppearance.registerVibrancyStyleListener(observer: self, invokeImmediately: true) { style in
			guard let vev = self.window?.contentView as? NSVisualEffectView else { return }
			vev.state = style.visualEffectState()
		}
		
        //let nib = NSNib(nibNamed: "ConversationCell", bundle: nil)!
		//self.listView.register(nib: nib, forClass: ConversationCell.self)
		
		NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
			self.userList = c.directory
			self.conversationList = c.conversations
			
            DispatchQueue.main.async {
                self.window?.title = c.directory.me.fullName
                //self.imageView.layer?.masksToBounds = true
                //self.imageView.layer?.cornerRadius = self.imageView.bounds.width / 2
                //self.imageView.image = fetchImage(user: c.directory.me, monogram: true)
                
                self.listView.update()
                self.updateSelectionIndexes()
			}
		}
		
		let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
		NSApp.badgeCount = UInt(unread)
		
		NotificationCenter.default.addObserver(forName: NSUserNotification.didActivateNotification, object: nil, queue: nil) {
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
        
		self.listView.insets = EdgeInsets(top: 36.0, left: 0, bottom: 0, right: 0)
		/*self.listView.pasteboardProvider = { row in
			let pb = NSPasteboardItem()
			//NSPasteboardTypeRTF, NSPasteboardTypeString, NSPasteboardTypeTabularText
			log.info("pb for row \(row)")
			pb.setString("TEST", forType: "public.utf8-plain-text")
			return pb
		}*/
	}
	
	private func showConversation(_ conv: Conversation) {
		if let wc = self.childConversations[conv.identifier] {
			log.debug("Conversation found for id \(conv.identifier)")
            DispatchQueue.main.async {
                wc.presentAsWindow()
                //wc.showWindow(nil)
            }
		} else {
            log.debug("Conversation NOT found for id \(conv.identifier)")
            DispatchQueue.main.async {
                let wc = MessageListViewController()
                wc.conversation = (conv as! IConversation)
                wc.sendMessageHandler = { [weak self] message, conv2 in
                    self?.sendMessage(message, conv2)
                }
                self.childConversations[conv.identifier] = wc
                let sel = #selector(ConversationListViewController.childWindowWillClose(_:))
                wc.presentAsWindow()
                NotificationCenter.default.addObserver(self, selector: sel,
                                                       name: .NSWindowWillClose, object: wc.view.window)
            }
            
            // TODO: This plus some window snapping and sizing would allow for a UI mode.
            // Also, remove the drawer and add popover if in single window mode.
            /*
             self.window?.addChildWindow(wc.window!, ordered: .above)
             //wc.window?.isResizable = false
             wc.window?.standardWindowButton(.closeButton)?.isHidden = true
             wc.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
             wc.window?.standardWindowButton(.zoomButton)?.isHidden = true
             wc.window?.standardWindowButton(.toolbarButton)?.isHidden = true
             wc.window?.standardWindowButton(.documentIconButton)?.isHidden = true
             wc.window?.standardWindowButton(.documentVersionsButton)?.isHidden = true
             wc.window?.standardWindowButton(.fullScreenButton)?.isHidden = true
             */
		}
	}
    
    private func hideConversation(_ conv: Conversation) {
        if let conv2 = self.childConversations[conv.identifier] {
            self.childConversations[conv.identifier] = nil
            conv2.dismissFromWindow()
        }
    }
	
	/// As we are about to display, configure our UI elements.
	public override func showWindow(_ sender: Any?) {
        let scale = Interpolate(from: 0.25, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] scale in
            self?.window?.scale(to: scale, by: CGPoint(x: 0.5, y: 0.5))
        }
        let alpha = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.window?.alphaValue = CGFloat(alpha)
        }
        
        self.window?.scale(to: 0.25, by: CGPoint(x: 0.5, y: 0.5))
        self.window?.alphaValue = 0.0
        self.window?.makeKeyAndOrderFront(nil)
        DispatchQueue.main.async {
            self.indicator.startAnimation(nil)
        }
        
        let group = Interpolate.group(scale, alpha)
        group.animate(duration: 0.35)
        
		ParrotAppearance.registerInterfaceStyleListener(observer: self) { appearance in
			self.window?.appearance = appearance.appearance()
		}
	}
    
    public func windowShouldClose(_ sender: Any) -> Bool {
        guard let w = self.window else { return false }
        
        let scale = Interpolate(from: 1.0, to: 0.25, interpolator: EaseInOutInterpolator()) { scale in
            w.scale(to: scale, by: CGPoint(x: 0.5, y: 0.5))
        }
        let alpha = Interpolate(from: 1.0, to: 0.0, interpolator: EaseInOutInterpolator()) { alpha in
            w.alphaValue = CGFloat(alpha)
        }
        let group = Interpolate.group(scale, alpha)
        group.add(at: 1.0) {
            DispatchQueue.main.async {
                w.close()
            }
        }
        group.animate(duration: 0.35)
        return false
    }
	
	/// If we're notified that our child window has closed (that is, a conversation),
	/// clean up by removing it from the `childConversations` dictionary.
	public func childWindowWillClose(_ notification: Notification) {
		guard	let win = notification.object as? NSWindow,
				let ctrl = win.contentViewController as? MessageListViewController,
				let conv2 = ctrl.conversation else { return }
        
        self.hideConversation(conv2)
        NotificationCenter.default.removeObserver(self, name: notification.name, object: win)
	}
	
	/// If we need to close, make sure we clean up after ourselves, instead of deinit.
	public func windowWillClose(_ notification: Notification) {
		ParrotAppearance.unregisterInterfaceStyleListener(observer: self)
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
			showNote = !(c.view.window?.isKeyWindow ?? false)
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
			notification.identityImage = fetchImage(user: user, monogram: true)
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
            var mode = FocusMode.here
            switch status.status {
            case TypingType.Started:
                mode = .typing
            case TypingType.Paused:
                mode = .enteredText
            case TypingType.Stopped: fallthrough
            default: // TypingType.Unknown:
                mode = .here
            }
            c.focusModeChanged(IFocus(sender: forUser, timestamp: Date(), mode: mode))
		}
	}
    public func conversationList(_ list: Hangouts.ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {
        log.debug("watermark for \(status.convID) from \(status.userID.gaiaID)")
        if let c = self.childConversations[status.convID], let person = self.userList?.people[status.userID.gaiaID] {
            log.debug("passthrough")
            c.watermarkEvent(IFocus(sender: person, timestamp: status.readTimestamp, mode: .here))
		}
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
    
    private func updateSelectionIndexes() {
        let paths = Array(self.childConversations.keys)
            .flatMap { id in self.sortedConversations.index { $0.identifier == id } }
            .map { (section: UInt(0), item: UInt($0)) }
        self.listView.selection = paths
    }
}
