import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts
import ParrotServiceExtension

/* TODO: Re-enable link previews later when they're not terrible... */
/* TODO: Use the PlaceholderMessage for sending messages. */
/* TODO: When selecting text and typing a completion character, wrap the text. */

public struct EventStreamItemBundle {
    public let current: EventStreamItem
    public let previous: EventStreamItem?
    public let next: EventStreamItem?
}

/// This is instantly shown to the user when they send a message. It will
/// be updated automatically when the status of the message is known.
public struct PlaceholderMessage: Message {
    public var contentType: ContentType = .text
    public let sender: Person?
    public let timestamp: Date
    public let text: String
    public var failed: Bool = false
}

// states: nothing-loaded, loading, error, valid view

public class MessageListViewController: NSViewController, NSWindowDelegate, TextInputHost, ListViewDataDelegate, ListViewScrollbackDelegate {
    
    //
    // MARK: Content Views
    //
    
    /// The backing visual effect view for the text input cell.
    private lazy var moduleView: NSVisualEffectView = {
        let v = NSVisualEffectView().modernize()
        v.layerContentsRedrawPolicy = .onSetNeedsDisplay
        v.state = .active
        v.blendingMode = .withinWindow
        v.material = .appearanceBased
        return v
    }()
    
    /// The primary messages content ListView.
    private lazy var listView: ListView = {
        let v = ListView().modernize()
        v.flowDirection = .bottom
        v.selectionType = .none
        v.delegate = self
        
        v.insets = EdgeInsets(top: 36.0, left: 0, bottom: 40.0, right: 0)
        return v
    }()
    
    /// The "loading data" indicator.
    private lazy var indicator: NSProgressIndicator = {
        let v = NSProgressIndicator().modernize()
        v.usesThreadedAnimation = true
        v.isIndeterminate = true
        v.style = .spinningStyle
        return v
    }()
    
    /// The conversation details/settings controller.
    /// Note: this should be presented in a popover by this parent view controller.
    private lazy var settingsController: ConversationDetailsViewController = {
        return ConversationDetailsViewController()
    }()
    
    /// The input cell at the bottom of the view.
    private lazy var textInputCell: TextInputCell = {
        let t = TextInputCell()
        t.host = self
        t.view.modernize() // prepare & attach
        return t
    }()
    
    /// The interpolation animation run when data is loaded.
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
    
    //
    // MARK: Members
    //
    
    /// A typing helper to debounce typing events and adapt them to Conversation.
    private lazy var typingHelper: TypingHelper = {
        TypingHelper {
            switch $0 {
            case .started:
                self.conversation?.setTyping(typing: TypingType.Started)
            case .paused:
                self.conversation?.setTyping(typing: TypingType.Paused)
            case .stopped:
                self.conversation?.setTyping(typing: TypingType.Stopped)
            }
        }
    }()
	
    public var sendMessageHandler: (String, ParrotServiceExtension.Conversation) -> Void = {_ in}
    private var updateToken: Bool = false
    private var showingFocus: Bool = false
    private var lastWatermarkIdx = -1
	private var _previews = [String: [LinkPreviewType]]()
    
    /// The currently active user's image or monogram.
    public var image: NSImage? {
        if let me = self.conversation?.client.userList.me {
            return fetchImage(user: me as! User, monogram: true)
        }
        return nil
    }
    
    /// The primary EventStreamItem dataSource.
	private var dataSource: [EventStreamItem] = []
    
    /// The background image and colors update Subscription.
    private var colorsSub: Subscription? = nil
    
    /// The window occlusion/focus update Subscription.
    private var occlusionSub: Subscription? = nil
    
    deinit {
        self.colorsSub = nil
        self.occlusionSub = nil
    }
    
    //
    // MARK: ListView: DataSource + Delegate
    //
    
    public func numberOfItems(in: ListView) -> [UInt] {
        return [UInt(self.dataSource.count)]
    }
    
    public func object(in: ListView, at: ListView.Index) -> Any? {
        let row = Int(at.item)
        if let f = self.dataSource[row] as? Focus {
            return f
        }
        
        let prev = (row - 1) > 0 && (row - 1) < self.dataSource.count
        let next = (row + 1) < self.dataSource.count && (row + 1) < 0
        return EventStreamItemBundle(current: self.dataSource[row],
                                     previous: prev ? self.dataSource[row - 1] : nil,
                                     next: next ? self.dataSource[row + 1] : nil) as Any
    }
    
    public func itemClass(in: ListView, at: ListView.Index) -> NSView.Type {
        let row = Int(at.item)
        if let _ = self.dataSource[row] as? Focus {
            return WatermarkCell.self
        }
        return MessageCell.self
    }
    
    public func cellHeight(in view: ListView, at: ListView.Index) -> Double {
        let row = Int(at.item)
        if let _ = self.dataSource[row] as? Focus {
            return 32.0
        } else if let m = self.dataSource[row] as? Message {
            return MessageCell.measure(m.text, view.frame.width)
        }
        return 0.0
    }
    
    public func reachedEdge(in: ListView, edge: NSRectEdge) {
        func scrollback() {
            guard self.updateToken == false else { return }
            let first = self.dataSource[0] as? IChatMessageEvent
            self.conversation?.getEvents(event_id: first?.event.eventId, max_events: 50) { events in
                let count = self.dataSource.count
                self.dataSource.insert(contentsOf: events.flatMap { $0 as? IChatMessageEvent }, at: 0)
                DispatchQueue.main.async {
                    self.listView.tableView.insertRows(at: IndexSet(integersIn: 0..<(self.dataSource.count - count)),
                                                       withAnimation: .slideDown)
                    self.updateToken = false
                }
            }
            self.updateToken = true
        }
        
        // Driver/filter here:
        switch edge {
        case .maxY: scrollback()
        default: break
        }
    }
    
    //
    // MARK: ViewController Events
    //
    
    public override func loadView() {
        self.view = NSView()
        self.view.add(subviews: [self.listView, self.indicator, self.moduleView, self.textInputCell.view])
        
        self.view.width >= 96
        self.view.height >= 128
        self.view.centerX == self.indicator.centerX
        self.view.centerY == self.indicator.centerY
        self.view.centerX == self.listView.centerX
        self.view.centerY == self.listView.centerY
        self.view.width == self.listView.width
        self.view.height == self.listView.height
        self.moduleView.left == self.view.left
        self.moduleView.right == self.view.right
        self.moduleView.bottom == self.view.bottom
        self.moduleView.height <= 250
        self.textInputCell.view.left == self.moduleView.left
        self.textInputCell.view.right == self.moduleView.right
        self.textInputCell.view.top == self.moduleView.top
        self.textInputCell.view.bottom == self.moduleView.bottom
    }
    
    public override func viewDidLoad() {
        /*
		self.window?.appearance = ParrotAppearance.interfaceStyle().appearance()
		self.window?.enableRealTitlebarVibrancy(.withinWindow)
		self.window?.titleVisibility = .hidden
        self.window?.contentView?.superview?.wantsLayer = true
        */
        
        self.indicator.startAnimation(nil)
        self.listView.alphaValue = 0.0
    }
    
    public override func viewWillAppear() {
        syncAutosaveTitle()
        
        // Monitor changes to the view background and colors.
        self.colorsSub = AutoSubscription(kind: Notification.Name("com.avaidyam.Parrot.UpdateColors")) { _ in
            if  let dat = Settings["Parrot.ConversationBackground"] as? NSData,
                let img = NSImage(data: dat as Data) {
                self.view.layer?.contents = img
            } else {
                self.view.layer?.contents = nil
            }
        }
        self.colorsSub?.trigger()
        
        // Monitor changes to the window's occlusion state and map it to conversation focus.
        self.occlusionSub = AutoSubscription(from: self.view.window!, kind: .NSWindowDidChangeOcclusionState) { [weak self] _ in
            // NSWindowOcclusionState: 8194 is Visible, 8192 is Occluded
            self?.conversation?.setFocus((self?.view.window?.occlusionState.rawValue ?? 0) == 8194)
        }
        self.occlusionSub?.trigger()
        
        // Set up dark/light notifications.
        ParrotAppearance.registerInterfaceStyleListener(observer: self, invokeImmediately: true) { interface in
            self.view.window?.appearance = interface.appearance()
        }
        
        // Force the window to follow the current ParrotAppearance.
        ParrotAppearance.registerVibrancyStyleListener(observer: self, invokeImmediately: true) { style in
            guard let vev = self.view.window?.contentView as? NSVisualEffectView else { return }
            vev.state = style.visualEffectState()
            if let s = self.view.window?.standardWindowButton(.closeButton)?.superview as? NSVisualEffectView {
                s.state = style.visualEffectState()
            }
        }
    }
    
    public override func viewWillDisappear() {
        self.colorsSub = nil
        self.occlusionSub = nil
        
        ParrotAppearance.unregisterInterfaceStyleListener(observer: self)
        ParrotAppearance.unregisterVibrancyStyleListener(observer: self)
    }
    
    //
    // MARK: Misc. Methods
    //
	
    // TODO: this goes in a new ParrotWindow class or something.
    /*
    public func windowShouldClose(_ sender: AnyObject) -> Bool {
        guard let w = self.window else { return false }
        
        let old_rect = w.frame
        var rect = w.frame
        rect.origin.y = -(rect.height)
        
        let scale = Interpolate(from: 1.0, to: 0.5, interpolator: EaseInOutInterpolator()) { scale in
            w.scale(to: scale, by: CGPoint(x: 0.5, y: 0.5))
        }
        let alpha = Interpolate(from: 1.0, to: 0.0, interpolator: EaseInInterpolator()) { alpha in
            w.alphaValue = alpha
        }
        let frame = Interpolate(from: old_rect, to: rect, interpolator: EaseInInterpolator()) { frame in
            w.setFrame(frame, display: false)
        }
        
        let group = Interpolate.group(scale, alpha, frame)
        group.add {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                w.setFrame(old_rect, display: false)
                w.alphaValue = 1.0
                w.scale()
                w.close()
            }
        }
        
        group.animate(duration: 0.25)
        return false
    }
    */
	
    /// Re-synchronizes the conversation name and identifier with the window.
    /// Center by default, but load a saved frame if available, and autosave.
    private func syncAutosaveTitle() {
        self.title = self.conversation?.name ?? ""
        let id = self.conversation?.identifier ?? "Messages"
        self.view.window?.center()
        self.view.window?.setFrameUsingName(id)
        self.view.window?.setFrameAutosaveName(id)
    }
    
	var conversation: IConversation? {
        didSet {
            self.settingsController.conversation = self.conversation
            self.syncAutosaveTitle()
			
			self.conversation?.getEvents(event_id: nil, max_events: 50) { events in
				for chat in (events.flatMap { $0 as? IChatMessageEvent }) {
					self.dataSource.append(chat)
					/* // Disabled because it takes a WHILE to run.
                    linkQ.async {
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
					}
                    */
				}
                
                let group = self.updateInterpolation // lazy
                DispatchQueue.main.async {
                    self.listView.update(animated: false) {
                        group.animate(duration: 0.5)
                    }
                }
			}
            
		}
	}
	
	public func conversation(_ conversation: IConversation, didReceiveEvent event: IEvent) {
		guard let e = event as? IChatMessageEvent else { return }
        DispatchQueue.main.async {
            self.dataSource.append(e)
            log.debug("section 0: \(self.dataSource.count)")
            self.listView.insert(at: [(section: 0, item: UInt(self.dataSource.count - 1))])
            //self.listView.scroll(toRow: self.dataSource.count - 1)
		}
    }
    
    // FIXME: Watermark!!
    public func watermarkEvent(_ focus: Focus) {
        guard let s = focus.sender, !s.me else { return }
        DispatchQueue.main.async {
            let oldWatermarkIdx = self.lastWatermarkIdx
            if oldWatermarkIdx > 0 {
                self.dataSource.remove(at: oldWatermarkIdx)
            }
            self.dataSource.append(focus)
            self.lastWatermarkIdx = self.dataSource.count - 1
            
            if oldWatermarkIdx > 0 && self.lastWatermarkIdx > 0 {
                log.debug("MOVE WATERMARK")
                //self.listView.remove(at: [(section: 0, item: UInt(oldWatermarkIdx))])
                //self.listView.insert(at: [(section: 0, item: UInt(self.lastWatermarkIdx))])
                self.listView.move(from: [(section: 0, item: UInt(oldWatermarkIdx))],
                                   to: [(section: 0, item: UInt(self.lastWatermarkIdx))])
            } else if self.lastWatermarkIdx > 0 {
                log.debug("ADD WATERMARK")
                self.listView.insert(at: [(section: 0, item: UInt(self.lastWatermarkIdx))])
            }
        }
    }
    
    public func focusModeChanged(_ focus: Focus) {
        guard let s = focus.sender, !s.me else { return }
        DispatchQueue.main.async {
            switch focus.mode {
            case .typing: fallthrough
            case .enteredText:
                log.debug("typing start")
                guard !self.showingFocus else { return }
                self.showingFocus = true
                //self.listView.insert(at: [(section: 1, item: 0)])
                //self.listView.scroll(toRow: self.dataSource.count)
            case .here: fallthrough
            case .away:
                log.debug("typing stop")
                guard self.showingFocus else { return }
                self.showingFocus = false
                //self.listView.remove(at: [(section: 1, item: 0)])
            }
        }
    }
    
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
		let cv = self.conversation!
		cv.muted = (button.state == NSOnState ? true : false)
	}
	
    // MARK: Window notifications
	
	public func windowDidBecomeKey(_ notification: Notification) {
        if let conversation = conversation {
			NSUserNotification.notifications().remove(identifier: conversation.id)
        }
		
        // Delay here to ensure that small context switches don't send focus messages.
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if let window = self.view.window, window.isKeyWindow {
				self.conversation?.setFocus(true) // set it here too just in case.
            }
			self.conversation?.updateReadTimestamp()
			
			// Get current states
			for state in self.conversation!.readStates {
				let person = self.conversation!.client.directory.people[state.participantId!.gaiaId!]!
				let timestamp = Date.from(UTC: Double(state.latestReadTimestamp!))
				log.debug("state => { person: \(person.nameComponents), timestamp: \(timestamp) }")
			}
        }
    }
	
    // TODO: Add a toolbar button and do this with that.
    /*
	public func drawerWillOpen(_ notification: Notification) {
		self.drawerButton.state = NSOnState
		self.drawer.drawerWindow?.animator().alphaValue = 1.0
	}
	public func drawerWillClose(_ notification: Notification) {
		self.drawerButton.state = NSOffState
		self.drawer.drawerWindow?.animator().alphaValue = 0.0
	}
    */
    
    public func resized(to: Double) {
        self.listView.insets = EdgeInsets(top: 36.0, left: 0, bottom: CGFloat(to), right: 0)
        self.moduleView.needsLayout = true
        self.moduleView.layoutSubtreeIfNeeded()
    }
    
    public func typing() {
        self.typingHelper.typing()
    }
    
    public func send(message: String) {
        self.sendMessageHandler(message, self.conversation!)
    }
}
