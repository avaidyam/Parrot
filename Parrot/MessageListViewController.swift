import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts // FIXME ASAP!!!
import ParrotServiceExtension

/* TODO: Re-enable link previews later when they're not terrible... */
/* TODO: Use the PlaceholderMessage for sending messages. */
/* TODO: When selecting text and typing a completion character, wrap the text. */

public struct MessageBundle {
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

// TODO: not here...
public extension Notification.Name {
    public static let OpenConversationsUpdated = Notification.Name(rawValue: "Parrot.OpenConversationsUpdated")
}

public class MessageListViewController: NSViewController, WindowPresentable, TextInputHost,
NSSearchFieldDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    
    /// The openConversations keeps track of all open conversations and when the
    /// list is updated, it is cached and all selections are synchronized.
    public /*private(set)*/ static var openConversations = [String: MessageListViewController]() {
        didSet {
            Settings.openConversations = Array(self.openConversations.keys)
            Subscription.Event(name: .OpenConversationsUpdated).post()
        }
    }
    
    public static func show(conversation conv: ParrotServiceExtension.Conversation, parent: NSViewController? = nil) {
        if let wc = MessageListViewController.openConversations[conv.identifier] {
            log.debug("Conversation found for id \(conv.identifier)")
            UI {
                wc.presentAsWindow()
            }
        } else {
            log.debug("Conversation NOT found for id \(conv.identifier)")
            UI {
                let wc = MessageListViewController()
                wc.conversation = (conv as! IConversation)
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
        v.layerContentsRedrawPolicy = .onSetNeedsDisplay
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
        
        let l = NSCollectionViewFlowLayout()//NSCollectionViewListLayout()
        //l.globalSections = (32, 0)
        //l.layoutDefinition = .custom
        l.minimumInteritemSpacing = 0.0
        l.minimumLineSpacing = 0.0
        c.collectionViewLayout = l
        c.register(MessageCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(MessageCell.self)"))
        c.register(PhotoCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(PhotoCell.self)"))
        c.register(LocationCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(LocationCell.self)"))
        c.register(ReloadCell.self, forSupplementaryViewOfKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ReloadCell.self)"))
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
        v.extensions = ["swift"]
        v.defaultOperation = .copy
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
    private lazy var updateInterpolation: Interpolate = {
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
        let group = Interpolate.group(indicatorAnim, scaleAnim)
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
    private var toolbarContainer = ToolbarItemContainer()
    
    /// The currently active user's image or monogram.
    public var image: NSImage? {
        if let me = self.conversation?.client.userList.me {
            return (me as! User).image
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
        self.view.add(subviews: [self.scrollView, self.indicator, self.moduleView, self.textInputCell.view, self.dropZone])
        
        self.view.width >= 96
        self.view.height >= 128
        self.view.centerX == self.indicator.centerX
        self.view.centerY == self.indicator.centerY
        self.view.centerX == self.scrollView.centerX
        self.view.centerY == self.scrollView.centerY
        self.view.width == self.scrollView.width
        self.view.height == self.scrollView.height
        self.moduleView.left == self.view.left
        self.moduleView.right == self.view.right
        self.moduleView.bottom == self.view.bottom
        self.moduleView.height <= 250
        self.textInputCell.view.left == self.moduleView.left
        self.textInputCell.view.right == self.moduleView.right
        self.textInputCell.view.top == self.moduleView.top
        self.textInputCell.view.bottom == self.moduleView.bottom
        self.dropZone.left == self.view.left
        self.dropZone.right == self.view.right
        self.dropZone.bottom == self.view.bottom
        self.dropZone.top == self.view.top
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
        self.toolbarContainer = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        self._setToolbar()
    }
    
    public override func viewDidLoad() {
        self.indicator.startAnimation(nil)
        self.scrollView.alphaValue = 0.0
        GoogleAnalytics.view(screen: GoogleAnalytics.Screen("\(type(of: self))"))
    }
    
    public override func viewWillAppear() {
        if let _ = self.view.window {
            syncAutosaveTitle()
            PopWindowAnimator.show(self.view.window!)
        }
        
        // Monitor changes to the view background and colors.
        self.colorsSub = AutoSubscription(kind: Notification.Name("com.avaidyam.Parrot.UpdateColors")) { _ in
            self.layer.contents = Settings.conversationBackground
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
        case .image(let data, _):
            return NSSize(width: collectionView.bounds.width,
                          height: PhotoCell.measure(data, collectionView.bounds.width))
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
        case .image(_, _):
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(PhotoCell.self)"), for: indexPath)
        case .location(_, _):
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(LocationCell.self)"), for: indexPath)
        default:
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(MessageCell.self)"), for: indexPath)
        }
        
        let row = indexPath.item
        let prev = (row - 1) > 0 && (row - 1) < self.dataSource.count
        let next = (row + 1) < self.dataSource.count && (row + 1) < 0
        item.representedObject = MessageBundle(current: self.dataSource[row],
                                               previous: prev ? self.dataSource[row - 1] : nil,
                                               next: next ? self.dataSource[row + 1] : nil) as Any
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let footer = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ReloadCell.self)"), for: indexPath) as! ReloadCell
        footer.handler = self.scrollback
        return footer
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 32.0)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        switch self.dataSource[indexPath.item].content {
        case .image(let data, _):
            return NSImage(data: data)
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
    
	var conversation: IConversation? {
        didSet {
            NotificationCenter.default.removeObserver(self)
            
            self.settingsController.conversation = self.conversation
            self.syncAutosaveTitle()
            self.invalidateRestorableState()
            self._setToolbar()
            
            // Register for Conversation "delegate" changes.
            let c = NotificationCenter.default
            c.addObserver(self, selector: #selector(self.conversationDidReceiveEvent(_:)),
                          name: Notification.Conversation.DidReceiveEvent, object: self.conversation!)
            c.addObserver(self, selector: #selector(self.conversationDidReceiveWatermark(_:)),
                          name: Notification.Conversation.DidReceiveWatermark, object: self.conversation!)
            c.addObserver(self, selector: #selector(self.conversationDidChangeTypingStatus(_:)),
                          name: Notification.Conversation.DidChangeTypingStatus, object: self.conversation!)
            c.addObserver(self, selector: #selector(self.conversationDidChangeFocus(_:)),
                          name: Notification.Conversation.DidChangeFocus, object: self.conversation!)
			
			self.conversation?.getEvents(event_id: nil, max_events: 50) { events in
				for chat in (events.flatMap { $0 as? IChatMessageEvent }) {
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
                
                let group = self.updateInterpolation // lazy
                UI {
                    self.collectionView.performBatchUpdates({
                        let t = (0..<self.dataSource.count).map {
                            IndexPath(item: $0, section: 0)
                        }
                        self.collectionView.animator().insertItems(at: Set(t))
                    }, completionHandler: { b in
                        group.animate(duration: 0.5)
                        self.collectionView.animator().scrollToItems(at: [self.collectionView.indexPathForLastItem()],
                                                                     scrollPosition: [.bottom])
                    })
                }
			}
            
		}
    }
    
    @objc public func conversationDidReceiveEvent(_ notification: Notification) {
        guard let event = notification.userInfo?["event"] as? IChatMessageEvent else { return }
        
        // Support mentioning a person's name. // TODO, FIXME
        UI {
            let shouldScroll = self.collectionView.indexPathsForVisibleItems().contains(IndexPath(item: self.dataSource.count - 1, section: 0))
            
            self.dataSource.insert(event)
            self.collectionView.performBatchUpdates({
                self.collectionView.animator().insertItems(at: [IndexPath(item: self.dataSource.count - 1, section: 0)])
            }, completionHandler: { b in
                guard shouldScroll else { return }
                self.collectionView.animator().scrollToItems(at: [self.collectionView.indexPathForLastItem()],
                                                             scrollPosition: [.bottom])
            })
        }
    }
    
    @objc public func conversationDidChangeTypingStatus(_ notification: Notification) {
        guard let status = notification.userInfo?["status"] as? ITypingStatusMessage else { return }
        guard let forUser = notification.userInfo?["user"] as? User else { return }
        
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
        self.focusModeChanged(mode, forUser)
    }
    
    @objc public func conversationDidChangeFocus(_ notification: Notification) {
        for (u, f) in self.conversation!.focus {
            self._usersToIndicators[u]?.isDimmed = f == .away
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
    
    public func focusModeChanged(_ focus: FocusMode, _ user: User) {
        guard !user.me else { return }
        UI {
            switch focus {
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
			self.conversation?.update(readTimestamp: nil)
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
        let first = self.dataSource[0] as! IChatMessageEvent
        self.conversation?.getEvents(event_id: first.event.event_id, max_events: 50) { events in
            let count = self.dataSource.count
            self.dataSource.insert(contentsOf: events.flatMap { $0 as? IChatMessageEvent })
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
        try! self.conversation!.send(message: PlaceholderMessage(content: .text(text)))
    }
    
    public func send(image: Data, filename: String) {
        do {
            try self.conversation?.send(message: PlaceholderMessage(content: .image(image, filename)))
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
                try self.conversation?.send(message: PlaceholderMessage(content: .location(coord.latitude, coord.longitude)))
            } catch {
                log.debug("sending a location was not supported; sending maps link instead")
                let text = "https://maps.google.com/maps?q=\(coord.latitude),\(coord.longitude)"
                try! self.conversation?.send(message: PlaceholderMessage(content: .text(text)))
            }
            return true
        }
    }
    
    // LEGACY
    static func sendMessage(_ text: String, _ conversation: ParrotServiceExtension.Conversation) {
        try! conversation.send(message: PlaceholderMessage(content: .text(text)))
    }
    
    //
    //
    //
    
    private lazy var addButton: NSButton = {
        let b = NSButton(title: "", image: NSImage(named: NSImage.Name(rawValue: "NSAddBookmarkTemplate"))!,
                         target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        return b
    }()
    
    private lazy var searchToggle: NSButton = {
        let b = NSButton(title: "", image: NSImage(named: NSImage.Name.revealFreestandingTemplate)!,
                         target: nil, action: nil)
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.setButtonType(.onOff)
        b.state = NSControl.StateValue.on
        return b
    }()
    
    private var _usersToIndicators: [Person.IdentifierType: PersonIndicatorViewController] = [:]
    private func _usersToItems() -> [NSToolbarItem] {
        if _usersToIndicators.count == 0 {
            self.conversation?.users.filter { !$0.me }.forEach {
                let vc = PersonIndicatorViewController()
                vc.person = $0
                vc.isDimmed = self.conversation!.focus[$0.identifier] == .away
                _usersToIndicators[$0.identifier] = vc
            }
        }
        return self._usersToIndicators.values.map { $0.toolbarItem }
    }
    private func _setToolbar() {
        /*
        let i = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "search"))
        i.view = self.searchToggle
        i.label = "Search"
        */
        
        let h = self.toolbarContainer
        h.templateItems = Set(_usersToItems())
        //h.templateItems.insert(i)
        var order = _usersToItems().map { $0.itemIdentifier }
        order.insert(.flexibleSpace, at: 0)
        order.append(.flexibleSpace)
        //order.append(NSToolbarItem.Identifier(rawValue: "search"))
        h.itemOrder = order
        
        /*
        let item = NSToolbarItem(itemIdentifier: "add")
        item.view = self.addButton
        item.label = "Add"
        let item2 = NSToolbarItem(itemIdentifier: "search")
        item2.view = self.searchToggle
        item2.label = "Search"
        container.templateItems = [item, item2]
        container.itemOrder = [NSToolbarFlexibleSpaceItemIdentifier, "add", "search"]
        */
    }
}
