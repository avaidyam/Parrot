import MochaUI
import AVFoundation
import ParrotServiceExtension
import class Hangouts.IConversation // required for [IConversation.client, .getEvents(...), .update(readTimestamp:)]

/* TODO: Re-enable link previews later when they're not terrible... */
/* TODO: Use the PlaceholderMessage for sending messages. */
/* TODO: When selecting text and typing a completion character, wrap the text. */
/* TODO: Stretch the background image. */

public struct MessageBundle {
    public let conversationId: String
    public let current: Message
    public let previous: Message?
    public let next: Message?
}

/// This is instantly shown to the user when they send a message. It will
/// be updated automatically when the status of the message is known.
public struct PlaceholderMessage: Message {
    public let serviceIdentifier: String = ""
    public let identifier: String = ""
    public let sender: Person? = nil
    public let timestamp: Date = Date()
    
    public var content: Content
    //public var failed: Bool = false
}

// Use this in the future:
/*
public enum MessagePromise: Message {
    case pending(Content)
    case sent(Message)
    case failed(Error)
    
    public var serviceIdentifier: String {
        guard case .sent(let msg) = self else { return "" }
        return msg.serviceIdentifier
    }
    
    public var identifier: String {
        guard case .sent(let msg) = self else { return "" }
        return msg.identifier
    }
    
    public var sender: Person? {
        guard case .sent(let msg) = self else { return nil }
        return msg.sender
    }
    
    public var timestamp: Date {
        guard case .sent(let msg) = self else { return Date() }
        return msg.timestamp
    }
    
    public var content: Content {
        if case .pending(let content) = self {
            return content
        } else if case .sent(let msg) = self {
            return msg.content
        }
        return .text("")
    }
}
*/

public class MessageListViewController: NSViewController, WindowPresentable, TextInputHost, DroppableViewDelegate,
NSSearchFieldDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    
    /// The openConversations keeps track of all open conversations and when the
    /// list is updated, it is cached and all selections are synchronized.
    public /*private(set)*/ static var openConversations = [String: MessageListViewController]() {
        didSet {
            Settings.openConversations = Array(self.openConversations.keys)
            Subscription.Event(name: .openConversationsUpdated).post()
        }
    }
    
    public static func show(conversation conv: ParrotServiceExtension.Conversation, parent: NSViewController? = nil) {
        if let wc = MessageListViewController.openConversations[conv.identifier] {
            log.debug("Conversation found for id \(conv.identifier)")
            UI {
                if let _ = parent {
                    // visibility is managed by the parent here
                } else {
                    wc.presentAsWindow()
                }
            }
        } else {
            log.debug("Conversation NOT found for id \(conv.identifier)")
            UI {
                let wc = MessageListViewController()
                wc.conversation = conv
                MessageListViewController.openConversations[conv.identifier] = wc
                if let p = parent {
                    p.addChildViewController(wc)
                } else {
                    wc.presentAsWindow()
                }
            }
        }
    }
    
    public static func hide(conversation conv: ParrotServiceExtension.Conversation) {
        if let conv2 = MessageListViewController.openConversations[conv.identifier] {
            MessageListViewController.openConversations[conv.identifier] = nil
            if let _ = conv2.parent {
                conv2.removeFromParentViewController()
            } else {
                conv2.dismiss(nil)
            }
        }
    }
    
    //
    // MARK: Content Views
    //
    
    /// The backing visual effect view for the text input cell.
    private lazy var moduleView: NSVisualEffectView = {
        let v = NSVisualEffectView().modernize(wantsLayer: true)
        //v.layerContentsRedrawPolicy = .onSetNeedsDisplay
        v.state = .active
        v.blendingMode = .withinWindow
        v.material = .appearanceBased
        return v
    }()
    
    private lazy var collectionView: NSCollectionView = {
        // NOTE: Do not reference `scrollView` because lazy init cycles!
        let c = NSCollectionView(frame: .zero)//.modernize(wantsLayer: true)
        //c.layerContentsRedrawPolicy = .onSetNeedsDisplay // FIXME: causes a random white background
        c.dataSource = self
        c.delegate = self
        c.backgroundColors = [.clear]
        c.selectionType = .one
        
        c.registerForDraggedTypes([.png, .string, .filePromise])
        c.setDraggingSourceOperationMask([.copy], forLocal: true)
        c.setDraggingSourceOperationMask([.copy], forLocal: false)
        
        let l = NSCollectionViewListLayout()
        l.globalSections = (32, 0)
        l.layoutDefinition = .custom
        l.appearEffect = [.effectFade, .slideUp]
        //l.minimumInteritemSpacing = 0.0
        //l.minimumLineSpacing = 0.0
        c.collectionViewLayout = l
        c.register(MessageCell.self, forItemWithIdentifier: .messageCell)
        c.register(PhotoCell.self, forItemWithIdentifier: .photoCell)
        c.register(LocationCell.self, forItemWithIdentifier: .locationCell)
        c.register(ReloadCell.self, forSupplementaryViewOfKind: .globalHeader, withIdentifier: .reloadCell)
        return c
    }()
    
    private lazy var scrollView: NSScrollView = {
        let s = NSScrollView(for: self.collectionView).modernize()
        s.automaticallyAdjustsContentInsets = false
        s.contentInsets = NSEdgeInsets(top: 36.0, left: 0, bottom: 32.0, right: 0)
        return s
    }()
    
    /// The "loading data" indicator.
    private lazy var indicator: NSProgressIndicator = {
        let v = NSProgressIndicator().modernize()
        v.usesThreadedAnimation = true
        v.isIndeterminate = true
        v.style = .spinning
        return v
    }()
    
    /// The dropping zone.
    private lazy var dropZone: DroppableView = {
        let v = DroppableView().modernize()
        v.acceptedTypes = [.of(kUTTypeImage)]
        v.operation = .copy
        v.delegate = self
        return v
    }()
    
    /// The conversation details/settings controller.
    /// Note: this should be presented in a popover by this parent view controller.
    private lazy var settingsController: ConversationDetailsViewController = {
        return ConversationDetailsViewController()
    }()
    
    /// The input cell at the bottom of the view.
    private lazy var textInputCell: MessageInputViewController = {
        let t = MessageInputViewController()
        t.host = self
        t.view.modernize() // prepare & attach
        return t
    }()
    
    /// The interpolation animation run when data is loaded.
    private lazy var updateInterpolation: Interpolate<Double> = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.scrollView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 0.0) { [weak self] in
            UI {
                self?.indicator.startAnimation(nil)
            }
        }
        indicatorAnim.add(at: 1.0) { [weak self] in
            UI {
                self?.indicator.stopAnimation(nil)
            }
        }
        indicatorAnim.handlerRunPolicy = .always
        let scaleAnim = Interpolate(from: CGAffineTransform(scaleX: 1.5, y: 1.5), to: .identity, interpolator: EaseInOutInterpolator()) { [weak self] scale in
            self?.scrollView.layer!.setAffineTransform(scale)
        }
        let group = AnyInterpolate.group(indicatorAnim, scaleAnim)
        return group
    }()
    
    //
    // MARK: Members
    //
    
    private var focusComponents: (TypingHelper.State, Bool) = (.stopped, false) {
        didSet {
            switch self.focusComponents.0 {
            case .started: self.conversation?.focus(mode: .typing)
            case .paused: self.conversation?.focus(mode: .enteredText)
            case .stopped: self.conversation?.focus(mode: self.focusComponents.1 ? .here : .away)
            }
        }
    }
    
    /// A typing helper to debounce typing events and adapt them to Conversation.
    private lazy var typingHelper: TypingHelper = {
        TypingHelper {
            self.focusComponents.0 = $0
        }
    }()
	
    //public var sendMessageHandler: (String, ParrotServiceExtension.Conversation) -> Void = {_ in}
    private var updateToken: Bool = false
    private var showingFocus: Bool = false
    private var lastWatermarkIdx = -1
	private var _previews = [String: [LinkPreviewType]]()
    /*public override var toolbarContainer: ToolbarContainer? {
        didSet {
            //self._setToolbar()
        }
    }*/
    
    /// The currently active user's image or monogram.
    public var image: NSImage? {
        if let me = (self.conversation as? IConversation)?.client.directory.me {
            return me.image
        }
        return nil
    }
    
    /// The primary EventStreamItem dataSource.
    private var dataSource = SortedArray<Message>() { a, b in
        return a.timestamp < b.timestamp
    }
    
    /// The background image and colors update Subscription.
    private var colorsSub: Subscription? = nil
    
    /// The window occlusion/focus update Subscription.
    private var occlusionSub: Subscription? = nil
    
    public var settings: ConversationSettings? {
        guard let conv = self.conversation else { return nil }
        return ConversationSettings(serviceIdentifier: conv.serviceIdentifier,
                                    identifier: conv.identifier)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.colorsSub = nil
        self.occlusionSub = nil
    }
    
    //
    // MARK: ViewController Events
    //
    
    public override func loadView() {
        self.view = NSVisualEffectView()
        self.view.add(subviews: self.scrollView, self.indicator, self.moduleView, self.textInputCell.view, self.dropZone)
        batch {
            self.view.sizeAnchors >= CGSize(width: 96, height: 128)
            self.view.centerAnchors == self.indicator.centerAnchors
            self.view.edgeAnchors == self.scrollView.edgeAnchors
            
            self.view.horizontalAnchors == self.moduleView.horizontalAnchors
            self.textInputCell.view.edgeAnchors == self.moduleView.edgeAnchors
            self.moduleView.bottomAnchor == self.view.bottomAnchor
            self.moduleView.heightAnchor <= 250
            
            self.view.horizontalAnchors == self.dropZone.horizontalAnchors
            self.dropZone.bottomAnchor == self.moduleView.topAnchor
            self.dropZone.topAnchor == self.view.topAnchor + 36 /* toolbar */
        }
    }
    
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .unifiedTitleAndToolbar, .fullSizeContentView]
        window.appearance = ParrotAppearance.interfaceStyle().appearance()
        if let vev = window.titlebar.view as? NSVisualEffectView {
            vev.material = .appearanceBased
            vev.state = .active
            vev.blendingMode = .withinWindow
        }
        window.titleVisibility = .hidden
        //window.titlebarAppearsTransparent = true
        window.installToolbar(self)
    }
    
    public override func viewDidLoad() {
        self.indicator.startAnimation(nil)
        self.scrollView.alphaValue = 0.0
        Analytics.view(screen: .conversation)
    }
    
    public override func viewWillAppear() {
        if let _ = self.view.window {
            syncAutosaveTitle()
            PopWindowAnimator.show(self.view.window!)
        }
        
        // Monitor changes to the view background and colors.
        self.colorsSub = AutoSubscription(kind: .conversationAppearanceUpdated) { _ in
            if let img = self.settings?.backgroundImage {
                self.collectionView.backgroundView = NSImageView(image: img)
            } else {
                self.collectionView.backgroundView = nil
            }
        }
        self.colorsSub?.trigger()
        
        // Set up dark/light notifications.
        ParrotAppearance.registerListener(observer: self, invokeImmediately: true) { interface, style in
            self.view.window?.appearance = interface
            (self.view as? NSVisualEffectView)?.state = style
        }
    }
    
    public override func viewWillDisappear() {
        self.colorsSub = nil
        
        ParrotAppearance.unregisterListener(observer: self)
    }
    
    public override func viewWillLayout() {
        super.viewWillLayout()
        let ctx = NSCollectionViewFlowLayoutInvalidationContext()
        ctx.invalidateFlowLayoutDelegateMetrics = true
        ctx.invalidateFlowLayoutAttributes = true
        self.collectionView.collectionViewLayout?.invalidateLayout(with: ctx)
    }
    
    ///
    ///
    ///
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let msg = self.dataSource[indexPath.item]
        switch msg.content {
        case .image(let url):
            return NSSize(width: collectionView.bounds.width,
                          height: PhotoCell.measure(url, collectionView.bounds.width))
        case .location(_, _):
            return NSSize(width: collectionView.bounds.width,
                          height: LocationCell.measure(collectionView.bounds.width))
        default:
            return NSSize(width: collectionView.bounds.width,
                          height: MessageCell.measure(msg.text, collectionView.bounds.width))
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item: NSCollectionViewItem
        switch self.dataSource[indexPath.item].content {
        case .image(_):
            item = collectionView.makeItem(withIdentifier: .photoCell, for: indexPath)
        case .location(_, _):
            item = collectionView.makeItem(withIdentifier: .locationCell, for: indexPath)
        default:
            item = collectionView.makeItem(withIdentifier: .messageCell, for: indexPath)
        }
        
        let row = indexPath.item
        let prev = (row - 1) > 0 && (row - 1) < self.dataSource.count
        let next = (row + 1) < self.dataSource.count && (row + 1) < 0
        item.representedObject = MessageBundle(conversationId: self.conversation?.identifier ?? "",
                                               current: self.dataSource[row],
                                               previous: prev ? self.dataSource[row - 1] : nil,
                                               next: next ? self.dataSource[row + 1] : nil) as Any
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let footer = collectionView.makeSupplementaryView(ofKind: .globalHeader, withIdentifier: .reloadCell, for: indexPath) as! ReloadCell
        footer.handler = self.scrollback
        return footer
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return .zero//NSSize(width: collectionView.bounds.width, height: 32.0)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        switch self.dataSource[indexPath.item].content {
        case .image(let url):
            let (data, _, _) = URLSession.shared.synchronousRequest(url)
            return NSImage(data: data!)
        case .text(let text):
            return text as NSString
        default:
            return nil
        }
    }
    
    //
    // MARK: Misc. Methods
    //
	
    /// Re-synchronizes the conversation name and identifier with the window.
    /// Center by default, but load a saved frame if available, and autosave.
    private func syncAutosaveTitle() {
        self.title = self.conversation?.name ?? ""
        let id = self.conversation?.identifier ?? "Messages"
        self.identifier = NSUserInterfaceItemIdentifier(rawValue: id)
        
        self.view.window?.center()
        self.view.window?.setFrameUsingName(NSWindow.FrameAutosaveName(rawValue: id))
        self.view.window?.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: id))
    }
    
	var conversation: ParrotServiceExtension.Conversation? {
        didSet {
            NotificationCenter.default.removeObserver(self)
            
            self.settingsController.conversation = self.conversation
            self.syncAutosaveTitle()
            self.invalidateRestorableState()
            //self._setToolbar()
            
            // Register for Conversation "delegate" changes.
            let c = NotificationCenter.default
            c.addObserver(self, selector: #selector(self.conversationDidReceiveEvent(_:)),
                          name: Notification.Conversation.DidReceiveEvent, object: self.conversation!)
            c.addObserver(self, selector: #selector(self.conversationDidReceiveWatermark(_:)),
                          name: Notification.Conversation.DidReceiveWatermark, object: self.conversation!)
            c.addObserver(self, selector: #selector(self.conversationDidChangeFocus(_:)),
                          name: Notification.Conversation.DidChangeFocus, object: self.conversation!)
			
			(self.conversation as? IConversation)?.getEvents(event_id: nil, max_events: 50) { events in
				for chat in (events.flatMap { $0 as? Message }) {
					self.dataSource.insert(chat)
                    
					 // Disabled because it takes a WHILE to run.
                    /*
                    linkQ.async {
                        
						let d = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
						let t = chat.text
						d.enumerateMatches(in: t, options: NSRegularExpression.MatchingOptions(rawValue: UInt(0)),
						                   range: NSMakeRange(0, t.unicodeScalars.count)) { (res, flag, stop) in
							let key = res!.url!.absoluteString
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
                
                UI {
                    self.collectionView.animator().performBatchUpdates({
                        let t = (0..<self.dataSource.count).map { IndexPath(item: $0, section: 0) }
                        self.collectionView.animator().insertItems(at: Set(t))
                    }, completionHandler: { b in
                        self.updateInterpolation.animate(duration: 0.5)
                        self.collectionView.animator().scrollToItems(at: [self.collectionView.indexPathForLastItem()],
                                                                     scrollPosition: [.bottom])
                    })
                }
			}
            
		}
    }
    
    @objc public func conversationDidReceiveEvent(_ notification: Notification) {
        guard let event = notification.userInfo?["event"] as? Message else { return }
        
        self.dataSource.insert(event)
        UI {
            // First check if we're at the bottom of the screen already to scroll.
            let idx = self.collectionView.indexPathForLastItem()
            let attrs = self.collectionView.layoutAttributesForItem(at: idx)?.frame ?? .zero
            let shouldScroll = self.collectionView.visibleRect.contains(attrs)
            
            self.collectionView.animator().performBatchUpdates({
                self.collectionView.animator().insertItems(at: [IndexPath(item: self.dataSource.count - 1, section: 0)])
            }, completionHandler: { b in
                guard shouldScroll else { return }
                self.collectionView.animator().scrollToItems(at: [self.collectionView.indexPathForLastItem()],
                                                             scrollPosition: [.bottom])
            })
        }
    }
    
    @objc public func conversationDidChangeFocus(_ notification: Notification) {
        guard let mode = notification.userInfo?["status"] as? FocusMode else { return }
        guard let user = notification.userInfo?["user"] as? Person else { return }
        
        // First reset all the focus indicators.
        for (u, f) in self.conversation!.focus {
            self._usersToIndicators[u]?.isDimmed = f == .away
        }
        guard !user.me else { return }
        
        // handle other-user typing cases:
        UI {
            switch mode {
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
    
    @objc public func conversationDidReceiveWatermark(_ notification: Notification) {
        /*guard let status = notification.userInfo?["status"] as? IWatermarkNotification else { return }
        if let person = self.conversation?.client.userList?.people[status.userID.gaiaID] {
            self.watermarkEvent(IFocus("", sender: person, timestamp: status.readTimestamp, mode: .here))
        }*/
    }
    
    // FIXME: Watermark!!
    /*public func watermarkEvent(_ focus: FocusMode) {
        guard let s = focus.sender, !s.me else { return }
        UI {
            let oldWatermarkIdx = self.lastWatermarkIdx
            if oldWatermarkIdx > 0 {
                self.dataSource.remove(at: oldWatermarkIdx)
            }
            //self.dataSource.insert(focus)
            self.lastWatermarkIdx = self.dataSource.count - 1
            
            /*
            if oldWatermarkIdx > 0 && self.lastWatermarkIdx > 0 {
                log.debug("MOVE WATERMARK")
                //self.listView.remove(at: [(section: 0, item: UInt(oldWatermarkIdx))])
                //self.listView.insert(at: [(section: 0, item: UInt(self.lastWatermarkIdx))])
                self.listView.move(from: [(section: 0, item: UInt(oldWatermarkIdx))],
                                   to: [(section: 0, item: UInt(self.lastWatermarkIdx))])
            } else if self.lastWatermarkIdx > 0 {
                log.debug("ADD WATERMARK")
                self.listView.insert(at: [(section: 0, item: UInt(self.lastWatermarkIdx))])
            }*/
        }
    }*/
    
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
        let cv = self.conversation! // don't cause didSet to fire!
        cv.muted = (button.state == .on)
	}
	
    // MARK: Window notifications
	
	public func windowDidBecomeKey(_ notification: Notification) {
        if let conversation = conversation {
			NSUserNotification.notifications().remove(identifier: conversation.identifier)
        }
		
        // Delay here to ensure that small context switches don't send focus messages.
		DispatchQueue.main.asyncAfter(deadline: 1.seconds.later) {
            if let window = self.view.window, window.isKeyWindow {
                self.focusComponents.1 = true // set it here too just in case.
            }
			(self.conversation as? IConversation)?.update(readTimestamp: nil)
        }
    }
    
    // Monitor changes to the window's occlusion state and map it to conversation focus.
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        self.focusComponents.1 = self.view.window?.occlusionState.contains(.visible) ?? false
    }
    
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        guard self.view.window != nil else { return true }
        ZoomWindowAnimator.hide(self.view.window!)
        return false
    }
    
    public func windowWillClose(_ notification: Notification) {
        MessageListViewController.openConversations[self.conversation!.identifier] = nil
    }
    
    private func scrollback() {
        guard self.updateToken == false else { return }
        let first = self.dataSource[0]
        (self.conversation as? IConversation)?.getEvents(event_id: first.identifier, max_events: 50) { events in
            let count = self.dataSource.count
            self.dataSource.insert(contentsOf: events.flatMap { $0 as? Message })
            UI {
                let idxs = (0..<(self.dataSource.count - count)).map {
                    IndexPath(item: $0, section: 0)
                }
                self.collectionView.animator().insertItems(at: Set(idxs))
                self.updateToken = false
            }
        }
        self.updateToken = true
    }
    
    public func resized(to: Double) {
        self.scrollView.contentInsets = NSEdgeInsets(top: 36.0, left: 0, bottom: CGFloat(to), right: 0)
        self.moduleView.needsLayout = true
        self.moduleView.layoutSubtreeIfNeeded()
    }
    
    public func typing() {
        self.typingHelper.typing()
    }
    
    public func send(message text: String) {
        NSSound(assetName: .sentMessage)?.play()
        try! self.conversation!.send(message: PlaceholderMessage(content: .text(text)))
    }
    
    public func send(image: URL) {
        NSSound(assetName: .sentMessage)?.play()
        do {
            try self.conversation?.send(message: PlaceholderMessage(content: .image(image)))
        } catch {
            log.debug("sending an image was not supported; sending text after provider upload instead")
            // upload the image on a different provider
            // send a link to it here
        }
    }
    
    public func sendLocation() {
        locate(reason: "Send location.") { loc, _ in
            guard let coord = loc?.coordinate else { return true }
            do {
                NSSound(assetName: .sentMessage)?.play()
                try self.conversation?.send(message: PlaceholderMessage(content: .location(coord.latitude, coord.longitude)))
            } catch {
                log.debug("sending a location was not supported; sending maps link instead")
                let text = "https://maps.google.com/maps?q=\(coord.latitude),\(coord.longitude)"
                try! self.conversation?.send(message: PlaceholderMessage(content: .text(text)))
            }
            return true
        }
    }
    
    public func send(video: URL) { // Screw Google Photos upload!
        try! self.conversation?.send(message: PlaceholderMessage(content: .file(video)))
        NSSound(assetName: .sentMessage)?.play()
        //try? FileManager.default.trashItem(at: video, resultingItemURL: nil) // get rid of the temp file
    }
    
    public func send(file: URL) {
        try! self.conversation?.send(message: PlaceholderMessage(content: .file(file)))
        NSSound(assetName: .sentMessage)?.play() // TODO: no guarantee we've sent anything yet...
    }
    
    // LEGACY
    static func sendMessage(_ text: String, _ conversation: ParrotServiceExtension.Conversation) {
        NSSound(assetName: .sentMessage)?.play()
        try! conversation.send(message: PlaceholderMessage(content: .text(text)))
    }
    
    public func dragging(phase: DroppableView.OperationPhase, for info: NSDraggingInfo) -> Bool {
        guard case .performing = phase else { return true }
        for item in info.draggingPasteboard().pasteboardItems ?? [] {
            
            // We have a "direct" image UTI type.
            if let type = item.availableType(from: [.of(kUTTypeImage)]),
                let data = item.data(forType: type)  {
                
                do {
                    let url = URL(temporaryFileWithExtension: "png")
                    try data.write(to: url, options: .atomic)
                    self.send(image: url)
                } catch {
                    NSAlert(style: .critical, message: "Couldn't send that file - write error!").beginModal()
                }
                
            // We have an "indirect" fileURL UTI type.
            } else if let _ = item.availableType(from: [._fileURL]),
                let plist = item.propertyList(forType: ._fileURL),
                let url = NSURL(pasteboardPropertyList: plist, ofType: ._fileURL) as URL? {
                self.send(image: url)
            } else {
                NSAlert(style: .critical, message: "Couldn't send that file!", information: "Here's some debug information:\n\(item.types.map { $0.rawValue })").beginModal()
            }
        }
        return true
    }
    
    //
    //
    //
    
    private lazy var addButton: NSButton = {
        let b = LayerButton(title: "", image: NSImage(named: .actionTemplate)!,
                         target: nil, action: nil).modernize()
        b.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.performedAction = {
            let c = ConversationDetailsViewController()
            c.conversation = self.conversation
            self.presentViewController(c, asPopoverRelativeTo: b.bounds, of: b, preferredEdge: .maxY, behavior: .transient)
        }
        return b
    }()
    
    private lazy var searchToggle: NSButton = {
        let b = LayerButton(title: "", image: NSImage(named: .revealFreestandingTemplate)!,
                         target: nil, action: nil)
        b.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.setButtonType(.onOff)
        b.state = NSControl.StateValue.on
        return b
    }()
    
    private var _usersToIndicators: [Person.IdentifierType: PersonIndicatorViewController] = [:]
    private func _usersToItems() -> [NSToolbarItem] {
        if _usersToIndicators.count == 0 {
            self.conversation?.participants.filter { !$0.me }.forEach {
                let vc = PersonIndicatorViewController()
                vc.person = $0
                vc.isDimmed = self.conversation!.focus[$0.identifier] == .away
                _usersToIndicators[$0.identifier] = vc
            }
        }
        return self._usersToIndicators.values.map { $0.toolbarItem }
    }
    private func _setToolbar() {
        guard let h = self.toolbarContainer else { return }
        
        let item = NSToolbarItem(itemIdentifier: .add)
        item.view = self.addButton
        item.label = "Add"
        
        h.templateItems = Set(_usersToItems())
        h.itemOrder = [.flexibleSpace] + _usersToItems().map { $0.itemIdentifier } + [.flexibleSpace]
        
        h.templateItems.insert(item)
        h.itemOrder.append(.add)
    }
    public override func makeToolbarContainer() -> ToolbarContainer? {
        let h = ToolbarContainer()
        
        // custom ID because we could potentially have multiple diff VC's on screen at a time!
        let id = NSToolbarItem.Identifier(rawValue: "add.\(self.conversation!.identifier)")
        let item = NSToolbarItem(itemIdentifier: id)
        item.view = self.addButton
        item.label = "Add"
        
        h.templateItems = Set(_usersToItems())
        h.itemOrder = [.flexibleSpace] + _usersToItems().map { $0.itemIdentifier } + [.flexibleSpace]
        
        h.templateItems.insert(item)
        h.itemOrder.append(id)
        //h.delegate = self
        return h
    }
}
