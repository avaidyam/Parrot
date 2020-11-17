<<<<<<< Updated upstream
import MochaUI
import AVFoundation
=======
import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts // FIXME ASAP!!!
>>>>>>> Stashed changes
import ParrotServiceExtension

/* TODO: Re-enable link previews later when they're not terrible... */
/* TODO: Use the PlaceholderMessage for sending messages. */
/* TODO: When selecting text and typing a completion character, wrap the text. */
<<<<<<< Updated upstream
/* TODO: Stretch the background image. */

public struct EventBundle {
    public let conversationId: String
    public let current: Event
    public let previous: Event?
    public let next: Event?
=======

public struct EventStreamItemBundle {
    public let current: EventStreamItem
    public let previous: EventStreamItem?
    public let next: EventStreamItem?
>>>>>>> Stashed changes
}

/// This is instantly shown to the user when they send a message. It will
/// be updated automatically when the status of the message is known.
public struct PlaceholderMessage: Message {
    public let serviceIdentifier: String = ""
    public let identifier: String = ""
<<<<<<< Updated upstream
    public let sender: Person
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

public class MessageListViewController: NSViewController, TextInputHost, DroppableViewDelegate,
NSSearchFieldDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
=======

    public var contentType: ContentType = .text
    public let sender: Person?
    public let timestamp: Date
    public let text: String
    public var failed: Bool = false
}

// TODO: not here...
public extension Notification.Name {
    public static let OpenConversationsUpdated = Notification.Name(rawValue: "Parrot.OpenConversationsUpdated")
}

public class MessageListViewController: NSViewController, WindowPresentable,
TextInputHost, ListViewDataDelegate2 {
>>>>>>> Stashed changes
    
    /// The openConversations keeps track of all open conversations and when the
    /// list is updated, it is cached and all selections are synchronized.
    public /*private(set)*/ static var openConversations = [String: MessageListViewController]() {
        didSet {
<<<<<<< Updated upstream
            Settings.openConversations = Array(self.openConversations.keys)
            Subscription.Event(name: .openConversationsUpdated).post()
=======
            Settings["Parrot.OpenConversations"] = Array(self.openConversations.keys)
            Subscription.Event(name: .OpenConversationsUpdated).post()
>>>>>>> Stashed changes
        }
    }
    
    public static func show(conversation conv: ParrotServiceExtension.Conversation, parent: NSViewController? = nil) {
        if let wc = MessageListViewController.openConversations[conv.identifier] {
            log.debug("Conversation found for id \(conv.identifier)")
<<<<<<< Updated upstream
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
=======
            DispatchQueue.main.async {
                wc.presentAsWindow()
            }
        } else {
            log.debug("Conversation NOT found for id \(conv.identifier)")
            DispatchQueue.main.async {
                let wc = MessageListViewController()
                wc.conversation = conv as! IConversation
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        let v = NSVisualEffectView().modernize(wantsLayer: true)
        //v.layerContentsRedrawPolicy = .onSetNeedsDisplay
=======
        let v = NSVisualEffectView().modernize()
        v.layerContentsRedrawPolicy = .onSetNeedsDisplay
>>>>>>> Stashed changes
        v.state = .active
        v.blendingMode = .withinWindow
        v.material = .appearanceBased
        return v
    }()
    
<<<<<<< Updated upstream
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
        c.register(EventCell.self, forItemWithIdentifier: .eventCell)
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
=======
    /// The primary messages content ListView.
    private lazy var listView: ListView2 = {
        let v = ListView2().modernize(wantsLayer: true)
        v.flowDirection = .bottom
        v.selectionType = .none
        v.delegate = self
        v.collectionView.register(MessageCell.self, forItemWithIdentifier: "\(MessageCell.self)")
        
        v.insets = EdgeInsets(top: 36.0, left: 0, bottom: 40.0, right: 0)
        return v
>>>>>>> Stashed changes
    }()
    
    /// The "loading data" indicator.
    private lazy var indicator: NSProgressIndicator = {
        let v = NSProgressIndicator().modernize()
        v.usesThreadedAnimation = true
        v.isIndeterminate = true
<<<<<<< Updated upstream
        v.style = .spinning
=======
        v.style = .spinningStyle
>>>>>>> Stashed changes
        return v
    }()
    
    /// The dropping zone.
    private lazy var dropZone: DroppableView = {
        let v = DroppableView().modernize()
<<<<<<< Updated upstream
        v.acceptedTypes = [.of(kUTTypeImage)]
        v.operation = .copy
        v.delegate = self
=======
        v.extensions = ["swift"]
        v.defaultOperation = .copy
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    private lazy var updateInterpolation: Interpolate<Double> = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.scrollView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 0.0) { [weak self] in
            UI {
=======
    private lazy var updateInterpolation: Interpolate = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.listView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 0.0) { [weak self] in
            DispatchQueue.main.async {
>>>>>>> Stashed changes
                self?.indicator.startAnimation(nil)
            }
        }
        indicatorAnim.add(at: 1.0) { [weak self] in
<<<<<<< Updated upstream
            UI {
=======
            DispatchQueue.main.async {
>>>>>>> Stashed changes
                self?.indicator.stopAnimation(nil)
            }
        }
        indicatorAnim.handlerRunPolicy = .always
        let scaleAnim = Interpolate(from: CGAffineTransform(scaleX: 1.5, y: 1.5), to: .identity, interpolator: EaseInOutInterpolator()) { [weak self] scale in
<<<<<<< Updated upstream
            self?.scrollView.layer!.setAffineTransform(scale)
        }
        let group = AnyInterpolate.group(indicatorAnim, scaleAnim)
=======
            self?.listView.layer!.setAffineTransform(scale)
        }
        let group = Interpolate.group(indicatorAnim, scaleAnim)
>>>>>>> Stashed changes
        return group
    }()
    
    //
    // MARK: Members
    //
    
    private var focusComponents: (TypingHelper.State, Bool) = (.stopped, false) {
        didSet {
            switch self.focusComponents.0 {
<<<<<<< Updated upstream
            case .started: self.conversation?.focus(mode: .typing)
            case .paused: self.conversation?.focus(mode: .enteredText)
            case .stopped: self.conversation?.focus(mode: self.focusComponents.1 ? .here : .away)
=======
            case .started: self.conversation?.selfFocus = .typing
            case .paused: self.conversation?.selfFocus = .enteredText
            case .stopped: self.conversation?.selfFocus = self.focusComponents.1 ? .here : .away
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    /*public override var toolbarContainer: ToolbarContainer? {
        didSet {
            //self._setToolbar()
        }
    }*/
    
    /// The currently active user's image or monogram.
    public var image: NSImage? {
        if let me = (self.conversation?.participants.first { $0.me }) {
            return me.image
=======
    private var toolbarContainer = ToolbarItemContainer()
    
    /// The currently active user's image or monogram.
    public var image: NSImage? {
        if let me = self.conversation?.client.userList.me {
            return (me as! User).image
>>>>>>> Stashed changes
        }
        return nil
    }
    
    /// The primary EventStreamItem dataSource.
<<<<<<< Updated upstream
    private var dataSource = SortedArray<Event>() { a, b in
        return a.timestamp < b.timestamp
    }
=======
	private var dataSource: [EventStreamItem] = []
>>>>>>> Stashed changes
    
    /// The background image and colors update Subscription.
    private var colorsSub: Subscription? = nil
    
<<<<<<< Updated upstream
    public var settings: ConversationSettings? {
        guard let conv = self.conversation else { return nil }
        return ConversationSettings(serviceIdentifier: conv.serviceIdentifier,
                                    identifier: conv.identifier)
    }
=======
    /// The window occlusion/focus update Subscription.
    private var occlusionSub: Subscription? = nil
>>>>>>> Stashed changes
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.colorsSub = nil
<<<<<<< Updated upstream
=======
        self.occlusionSub = nil
    }
    
    //
    // MARK: ListView: DataSource + Delegate
    //
    
    public func numberOfItems(in: ListView2) -> [UInt] {
        return [UInt(self.dataSource.count)]
    }
    
    public func object(in: ListView2, at: ListView2.Index) -> Any? {
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
    
    public func itemClass(in: ListView2, at: ListView2.Index) -> NSCollectionViewItem.Type {
        let row = Int(at.item)
        return MessageCell.self
    }
    
    public func cellHeight(in view: ListView2, at: ListView2.Index) -> Double {
        let row = Int(at.item)
        if let _ = self.dataSource[row] as? Focus {
            return 32.0
        } else if let m = self.dataSource[row] as? Message {
            return MessageCell.measure(m.text, view.frame.width)
        }
        return 0.0
    }
    
    public func reachedEdge(in: ListView2, edge: NSRectEdge) {
        func scrollback() {
            guard self.updateToken == false else { return }
            let first = self.dataSource[0] as? IChatMessageEvent
            self.conversation?.getEvents(event_id: first?.event.eventId, max_events: 50) { events in
                let count = self.dataSource.count
                self.dataSource.insert(contentsOf: events.flatMap { $0 as? IChatMessageEvent }, at: 0)
                DispatchQueue.main.async {
                    self.listView.collectionView.insertItems(at: Set((0..<(self.dataSource.count - count)).map { IndexPath(item: $0, section: 0) }))
                    /*self.listView.tableView.insertRows(at: IndexSet(integersIn: 0..<(self.dataSource.count - count)),
                                                       withAnimation: .slideDown)
                    */
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
>>>>>>> Stashed changes
    }
    
    //
    // MARK: ViewController Events
    //
    
    public override func loadView() {
        self.view = NSView()
<<<<<<< Updated upstream
        self.view.add(subviews: self.scrollView, self.indicator, self.moduleView, self.textInputCell.view, self.dropZone) {
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
=======
        self.view.add(subviews: [self.listView, self.indicator, self.moduleView, self.textInputCell.view, self.dropZone])
        
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
        self.dropZone.left == self.view.left
        self.dropZone.right == self.view.right
        self.dropZone.bottom == self.view.bottom
        self.dropZone.top == self.view.top
    }
    
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .unifiedTitleAndToolbar, .fullSizeContentView]
        window.appearance = ParrotAppearance.interfaceStyle().appearance()
        window.enableRealTitlebarVibrancy(.withinWindow)
        window.titleVisibility = .hidden
        //window.titlebarAppearsTransparent = true
        self.toolbarContainer = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        self._setToolbar()
>>>>>>> Stashed changes
    }
    
    public override func viewDidLoad() {
        self.indicator.startAnimation(nil)
<<<<<<< Updated upstream
        self.scrollView.alphaValue = 0.0
        Analytics.view(screen: .conversation)
    }
    
    public override func viewWillAppear() {
        // Monitor changes to the view background and colors.
        self.colorsSub = AutoSubscription(kind: .conversationAppearanceUpdated) { _ in
            if let img = self.settings?.backgroundImage {
                self.collectionView.backgroundView = NSImageView(image: img)
            } else {
                self.collectionView.backgroundView = nil
=======
        self.listView.alphaValue = 0.0
    }
    
    public override func viewWillAppear() {
        if let w = self.view.window {
            syncAutosaveTitle()
            PopWindowAnimator.show(self.view.window!)
        }
        
        // Monitor changes to the view background and colors.
        self.colorsSub = AutoSubscription(kind: Notification.Name("com.avaidyam.Parrot.UpdateColors")) { _ in
            if  let dat = Settings["Parrot.ConversationBackground"] as? NSData,
                let img = NSImage(data: dat as Data) {
                self.view.layer?.contents = img
            } else {
                self.view.layer?.contents = nil
>>>>>>> Stashed changes
            }
        }
        self.colorsSub?.trigger()
        
        // Set up dark/light notifications.
<<<<<<< Updated upstream
        self.visualSubscriptions = [
            Settings.observe(\.effectiveInterfaceStyle, options: [.initial, .new]) { _, change in
                // Reset cell colors too - this fixes a visual glitch.
                self.collectionView.visibleItems().forEach {
                    guard let cell = $0 as? MessageCell else { return }
                    cell.setColors()
                }
            },
        ]
    }
    private var visualSubscriptions: [NSKeyValueObservation] = []
    
    public override func viewWillDisappear() {
        self.colorsSub = nil
        self.visualSubscriptions = []
    }
    
    public override func viewWillLayout() {
        super.viewWillLayout()
        if self.oldFrame == .zero || self.oldFrame.width != self.view.frame.width {
            let ctx = NSCollectionViewFlowLayoutInvalidationContext()
            ctx.invalidateFlowLayoutDelegateMetrics = true
            ctx.invalidateFlowLayoutAttributes = true
            self.collectionView.collectionViewLayout?.invalidateLayout(with: ctx)
        }
        self.oldFrame = self.view.frame
    }
    private var oldFrame = NSRect.zero
    
    ///
    ///
    ///
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let event = self.dataSource[indexPath.item]
        if let msg = event as? Message {
            switch msg.content {
            case .image(let url):
                return NSSize(width: collectionView.bounds.width,
                              height: PhotoCell.measure(url, collectionView.bounds.width))
            case .location(_, _):
                return NSSize(width: collectionView.bounds.width,
                              height: LocationCell.measure(collectionView.bounds.width))
            default:
                return NSSize(width: collectionView.bounds.width,
                              height: MessageCell.measure(msg.text ?? "", collectionView.bounds.width))
            }
        } else {
            return NSSize(width: collectionView.bounds.width,
                          height: EventCell.measure(collectionView.bounds.width))
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item: NSCollectionViewItem
        if let message = self.dataSource[indexPath.item] as? Message {
            switch message.content {
            case .image(_):
                item = collectionView.makeItem(withIdentifier: .photoCell, for: indexPath)
            case .location(_, _):
                item = collectionView.makeItem(withIdentifier: .locationCell, for: indexPath)
            default:
                item = collectionView.makeItem(withIdentifier: .messageCell, for: indexPath)
            }
        } else { // not specialized
            item = collectionView.makeItem(withIdentifier: .eventCell, for: indexPath)
        }
        
        let row = indexPath.item
        let prev = (row - 1) > 0 && (row - 1) < self.dataSource.count
        let next = (row + 1) > 0 && (row + 1) < self.dataSource.count
        item.representedObject = EventBundle(conversationId: self.conversation?.identifier ?? "",
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
        let event = self.dataSource[indexPath.item]
        if let message = event as? Message {
            switch message.content {
            case .image(let url):
                let (data, _, _) = URLSession.shared.synchronousRequest(url)
                return NSImage(data: data!)
            case .text(let text):
                return text as NSString
            default:
                return nil
            }
        } else {
            return nil // todo
        }
=======
        ParrotAppearance.registerInterfaceStyleListener(observer: self, invokeImmediately: true) { interface in
            self.view.window?.appearance = interface.appearance()
        }
        
        // Force the window to follow the current ParrotAppearance.
        ParrotAppearance.registerVibrancyStyleListener(observer: self, invokeImmediately: true) { style in
            guard let vev = self.view.window?.contentView as? NSVisualEffectView else { return }
            vev.state = style.visualEffectState()
            /*if let s = self.view.window?.standardWindowButton(.closeButton)?.superview as? NSVisualEffectView {
                s.state = style.visualEffectState()
            }*/
        }
    }
    
    public override func viewWillDisappear() {
        self.colorsSub = nil
        
        ParrotAppearance.unregisterInterfaceStyleListener(observer: self)
        ParrotAppearance.unregisterVibrancyStyleListener(observer: self)
>>>>>>> Stashed changes
    }
    
    //
    // MARK: Misc. Methods
    //
<<<<<<< Updated upstream
    
	var conversation: ParrotServiceExtension.Conversation? {
=======
	
    /// Re-synchronizes the conversation name and identifier with the window.
    /// Center by default, but load a saved frame if available, and autosave.
    private func syncAutosaveTitle() {
        self.title = self.conversation?.name ?? ""
        let id = self.conversation?.identifier ?? "Messages"
        self.identifier = id
        
        self.view.window?.center()
        self.view.window?.setFrameUsingName(id)
        self.view.window?.setFrameAutosaveName(id)
    }
    
	var conversation: IConversation? {
>>>>>>> Stashed changes
        didSet {
            NotificationCenter.default.removeObserver(self)
            
            self.settingsController.conversation = self.conversation
<<<<<<< Updated upstream
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
			
			self.conversation?.syncEvents(count: 50, before: nil) { events in
                self.dataSource.insert(contentsOf: events)
				//for chat in events {
				//	self.dataSource.insert(chat)
                    
=======
            self.syncAutosaveTitle()
            self.invalidateRestorableState()
            self._setToolbar()
            
            // Register for Conversation "delegate" changes.
            let c = NotificationCenter.default
            c.addObserver(self, selector: #selector(ConversationListViewController.conversationDidReceiveEvent(_:)),
                          name: Notification.Conversation.DidReceiveEvent, object: self.conversation!)
            c.addObserver(self, selector: #selector(MessageListViewController.conversationDidReceiveWatermark(_:)),
                          name: Notification.Conversation.DidReceiveWatermark, object: self.conversation!)
            c.addObserver(self, selector: #selector(MessageListViewController.conversationDidChangeTypingStatus(_:)),
                          name: Notification.Conversation.DidChangeTypingStatus, object: self.conversation!)
			
			self.conversation?.getEvents(event_id: nil, max_events: 50) { events in
				for chat in (events.flatMap { $0 as? IChatMessageEvent }) {
					self.dataSource.append(chat)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
				//}
                
                UI {
                    self.collectionView.animator().performBatchUpdates({
                        let t = (0..<self.dataSource.count).map { IndexPath(item: $0, section: 0) }
                        self.collectionView.insertItems(at: Set(t))
                    }, completionHandler: { b in
                        self.updateInterpolation.animate(duration: 0.5)
                        let idx = self.collectionView.indexPathForLastItem()
                        guard !(idx.item == 0 && idx.section == 0) else { return }
                        self.collectionView.scrollToItems(at: [idx],
                                                          scrollPosition: [.bottom])
                        
                        // first pass:
                        let ctx = NSCollectionViewFlowLayoutInvalidationContext()
                        ctx.invalidateFlowLayoutDelegateMetrics = true
                        ctx.invalidateFlowLayoutAttributes = true
                        self.collectionView.collectionViewLayout?.invalidateLayout(with: ctx)
                    })
=======
				}
                
                let group = self.updateInterpolation // lazy
                DispatchQueue.main.async {
                    self.listView.update(animated: false) {
                        group.animate(duration: 0.5)
                    }
>>>>>>> Stashed changes
                }
			}
            
		}
    }
    
<<<<<<< Updated upstream
    @objc dynamic public func conversationDidReceiveEvent(_ notification: Notification) {
        guard let event = notification.userInfo?["event"] as? Event else { return }
        
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
    
    @objc dynamic public func conversationDidChangeFocus(_ notification: Notification) {
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
    
    @objc dynamic public func conversationDidReceiveWatermark(_ notification: Notification) {
=======
    public func conversationDidReceiveEvent(_ notification: Notification) {
        guard let event = notification.userInfo?["event"] as? IChatMessageEvent else { return }
        
        // Support mentioning a person's name. // TODO, FIXME
        DispatchQueue.main.async {
            self.dataSource.append(event)
            log.debug("section 0: \(self.dataSource.count)")
            let idx = IndexPath(item: self.dataSource.count - 1, section: 0)
            self.listView.collectionView.insertItems(at: [idx])
            //self.listView.scroll(toRow: self.dataSource.count - 1)
        }
    }
    
    public func conversationDidChangeTypingStatus(_ notification: Notification) {
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
        self.focusModeChanged(IFocus("", identifier: "", sender: forUser, timestamp: Date(), mode: mode))
    }
    
    public func conversationDidReceiveWatermark(_ notification: Notification) {
>>>>>>> Stashed changes
        /*guard let status = notification.userInfo?["status"] as? IWatermarkNotification else { return }
        if let person = self.conversation?.client.userList?.people[status.userID.gaiaID] {
            self.watermarkEvent(IFocus("", sender: person, timestamp: status.readTimestamp, mode: .here))
        }*/
    }
    
    // FIXME: Watermark!!
<<<<<<< Updated upstream
    /*public func watermarkEvent(_ focus: FocusMode) {
        guard let s = focus.sender, !s.me else { return }
        UI {
=======
    public func watermarkEvent(_ focus: Focus) {
        guard let s = focus.sender, !s.me else { return }
        DispatchQueue.main.async {
>>>>>>> Stashed changes
            let oldWatermarkIdx = self.lastWatermarkIdx
            if oldWatermarkIdx > 0 {
                self.dataSource.remove(at: oldWatermarkIdx)
            }
<<<<<<< Updated upstream
            //self.dataSource.insert(focus)
=======
            self.dataSource.append(focus)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    }*/
=======
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
>>>>>>> Stashed changes
    
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
<<<<<<< Updated upstream
        let cv = self.conversation! // don't cause didSet to fire!
        cv.muted = (button.state == .on)
=======
		let cv = self.conversation!
		cv.muted = (button.state == NSOnState ? true : false)
>>>>>>> Stashed changes
	}
	
    // MARK: Window notifications
	
	public func windowDidBecomeKey(_ notification: Notification) {
        if let conversation = conversation {
<<<<<<< Updated upstream
			NSUserNotification.notifications().remove(identifier: conversation.identifier)
        }
		
        // Delay here to ensure that small context switches don't send focus messages.
		DispatchQueue.main.asyncAfter(deadline: 1.seconds.later) {
            if let window = self.view.window, window.isKeyWindow {
                self.focusComponents.1 = true // set it here too just in case.
            }
			//(self.conversation as? IConversation)?.update(readTimestamp: nil)
=======
			NSUserNotification.notifications().remove(identifier: conversation.id)
        }
		
        // Delay here to ensure that small context switches don't send focus messages.
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if let window = self.view.window, window.isKeyWindow {
                self.focusComponents.1 = true // set it here too just in case.
            }
			self.conversation?.updateReadTimestamp()
			
			// Get current states
			for state in self.conversation!.readStates {
				let person = self.conversation!.client.directory.people[state.participantId!.gaiaId!]!
				let timestamp = Date.from(UTC: Double(state.latestReadTimestamp!))
				log.debug("state => { person: \(person.nameComponents), timestamp: \(timestamp) }")
			}
>>>>>>> Stashed changes
        }
    }
    
    // Monitor changes to the window's occlusion state and map it to conversation focus.
<<<<<<< Updated upstream
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        self.focusComponents.1 = self.view.window?.occlusionState.contains(.visible) ?? false
    }
    
    public func windowWillClose(_ notification: Notification) {
        MessageListViewController.openConversations[self.conversation!.identifier] = nil
    }
    
    private func scrollback() {
        guard self.updateToken == false else { return }
        let first = self.dataSource[0]
        self.conversation?.syncEvents(count: 50, before: first) { events in
            let count = self.dataSource.count
            self.dataSource.insert(contentsOf: events)
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
=======
    // NSWindowOcclusionState: 8194 is Visible, 8192 is Occluded
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        self.focusComponents.1 = (self.view.window?.occlusionState.rawValue ?? 0) == 8194
    }
    
    public func windowShouldClose(_ sender: Any) -> Bool {
        guard self.view.window != nil else { return true }
        ZoomWindowAnimator.hide(self.view.window!)
        return false
    }
    
    public func windowWillClose(_ notification: Notification) {
        MessageListViewController.openConversations[self.conversation!.identifier] = nil
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
>>>>>>> Stashed changes
        self.moduleView.needsLayout = true
        self.moduleView.layoutSubtreeIfNeeded()
    }
    
    public func typing() {
        self.typingHelper.typing()
    }
    
<<<<<<< Updated upstream
    public func send(message text: String) {
        try! self.conversation!.send(message: PlaceholderMessage(sender: self.conversation!.participants.first { $0.me }!, content: .text(text)))
    }
    
    public func send(image: URL) {
        do {
            try self.conversation?.send(message: PlaceholderMessage(sender: self.conversation!.participants.first { $0.me }!, content: .image(image)))
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
                try self.conversation?.send(message: PlaceholderMessage(sender: self.conversation!.participants.first { $0.me }!, content: .location(coord.latitude, coord.longitude)))
            } catch {
                log.debug("sending a location was not supported; sending maps link instead")
                let text = "https://maps.google.com/maps?q=\(coord.latitude),\(coord.longitude)"
                try! self.conversation?.send(message: PlaceholderMessage(sender: self.conversation!.participants.first { $0.me }!, content: .text(text)))
            }
            return true
        }
    }
    
    public func send(video: URL) { // Screw Google Photos upload!
        try! self.conversation?.send(message: PlaceholderMessage(sender: self.conversation!.participants.first { $0.me }!, content: .file(video)))
        //try? FileManager.default.trashItem(at: video, resultingItemURL: nil) // get rid of the temp file
    }
    
    public func send(file: URL) {
        try! self.conversation?.send(message: PlaceholderMessage(sender: self.conversation!.participants.first { $0.me }!, content: .file(file)))
    }
    
    // LEGACY
    static func sendMessage(_ text: String, _ conversation: ParrotServiceExtension.Conversation) {
        try! conversation.send(message: PlaceholderMessage(sender: conversation.participants.first { $0.me }!, content: .text(text)))
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
=======
    public func send(message: String) {
        MessageListViewController.sendMessage(message, self.conversation!)
        //self.sendMessageHandler(message, self.conversation!)
    }
    
    static func sendMessage(_ text: String, _ conversation: ParrotServiceExtension.Conversation) {
        conversation.send(message: text)
>>>>>>> Stashed changes
    }
    
    //
    //
    //
    
<<<<<<< Updated upstream
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
=======
    /*
    private lazy var addButton: NSButton = {
        let b = NSButton(title: "", image: NSImage(named: "NSAddBookmarkTemplate")!,
                         target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
>>>>>>> Stashed changes
        return b
    }()
    
    private lazy var searchToggle: NSButton = {
<<<<<<< Updated upstream
        let b = LayerButton(title: "", image: NSImage(named: .revealFreestandingTemplate)!,
                         target: nil, action: nil)
        b.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.setButtonType(.onOff)
        b.state = NSControl.StateValue.on
        return b
    }()
=======
        let b = NSButton(title: "", image: NSImage(named: NSImageNameRevealFreestandingTemplate)!,
                         target: self, action: #selector(self.toggleSearchField(_:))).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.setButtonType(.onOff)
        b.state = NSControlStateValueOn
        return b
    }()
    */
>>>>>>> Stashed changes
    
    private var _usersToIndicators: [Person.IdentifierType: PersonIndicatorViewController] = [:]
    private func _usersToItems() -> [NSToolbarItem] {
        if _usersToIndicators.count == 0 {
<<<<<<< Updated upstream
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
=======
            self.conversation?.users.filter { !$0.me }.map {
                let vc = PersonIndicatorViewController()
                vc.representedObject = $0
                _usersToIndicators[$0.identifier] = vc
            }
        }
        
        return self._usersToIndicators.values.map { $0.toolbarItem }
    }
    private func _setToolbar() {
        let h = self.toolbarContainer
        h.templateItems = Set(_usersToItems())
        var order = _usersToItems().map { $0.itemIdentifier }
        order.insert(NSToolbarFlexibleSpaceItemIdentifier, at: 0)
        order.append(NSToolbarFlexibleSpaceItemIdentifier)
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
>>>>>>> Stashed changes
    }
}
