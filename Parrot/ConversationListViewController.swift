import Foundation
import AppKit
import Mocha
import MochaUI
import ParrotServiceExtension

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: Show DND icon in Cell when conversation is muted. */
/* TODO: Support not sending Read Receipts. */

//private let log = Logger(subsystem: "Parrot.ConversationListViewController")
let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", qos: .userInteractive)
let linkQ = DispatchQueue(label: "com.avaidyam.Parrot.linkQ", qos: .userInitiated)

public class ConversationListViewController: NSViewController, WindowPresentable,
NSSearchFieldDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    
    private lazy var collectionView: NSCollectionView = {
        let c = NSCollectionView(frame: .zero)//.modernize(wantsLayer: true)
        //c.layerContentsRedrawPolicy = .onSetNeedsDisplay // FIXME: causes a random white background
        c.dataSource = self
        c.delegate = self
        c.backgroundColors = [.clear]
        c.selectionType = .any
        
        let l = NSCollectionViewListLayout()
        l.layoutDefinition = .global(SizeMetrics(item: CGSize(width: 0, height: 64)))
        c.collectionViewLayout = l
        c.register(ConversationCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ConversationCell.self)"))
        return c
    }()
    
    private lazy var scrollView: NSScrollView = {
        let s = NSScrollView(for: self.collectionView).modernize()
        return s
    }()
    
    private lazy var indicator: MessageProgressView = {
        let v = MessageProgressView().modernize(wantsLayer: true)
        return v
    }()
    
    private lazy var titleText: NSTextField = {
        let t = NSTextField(labelWithString: " Conversations").modernize(wantsLayer: true)
        t.textColor = NSColor.labelColor
        t.font = NSFont.systemFont(ofSize: 32.0, weight: .heavy)
        return t
    }()
    
    private lazy var searchField: NSSearchField = {
        let s = NSSearchField().modernize(wantsLayer: true)
        s.sendsWholeSearchString = true
        s.sendsSearchStringImmediately = true
        s.target = self
        s.action = #selector(self.searching(_:))
        return s
    }()
    
    private lazy var addButton: NSButton = {
        let b = NSButton(title: "", image: NSImage(named: NSImage.Name(rawValue: "NSAddBookmarkTemplate"))!,
                         target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        return b
    }()
    
    private lazy var searchToggle: NSButton = {
        let b = NSButton(title: "", image: NSImage(named: NSImage.Name.revealFreestandingTemplate)!,
                         target: self, action: #selector(self.toggleSearchField(_:))).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.setButtonType(.onOff)
        b.state = NSControl.StateValue.on
        return b
    }()
    
    private lazy var titleAccessory: NSTitlebarAccessoryViewController = {
        let v = NSView()
        v.add(subviews: [self.titleText/*, self.addButton*//*, self.searchField*/])
        v.autoresizingMask = [.width]
        v.frame.size.height = 44.0//80.0
        self.titleText.left == v.left + 2.0
        self.titleText.top == v.top + 2.0
        let t = NSTitlebarAccessoryViewController()
        t.view = v
        t.layoutAttribute = .bottom
        return t
    }()
    
    private lazy var searchAccessory: NSTitlebarAccessoryViewController = {
        let t = NSTitlebarAccessoryViewController()
        t.view = NSView()
        t.view.frame.size.height = 22.0 + 12.0
        t.view.addSubview(self.searchField)
        self.searchField.left == t.view.left + 8.0
        self.searchField.right == t.view.right - 8.0
        self.searchField.top == t.view.top + 4.0
        self.searchField.bottom == t.view.bottom - 8.0
        t.layoutAttribute = .bottom
        return t
    }()
    
    private var updateToken: Bool = false
    private var childrenSub: Subscription? = nil
    
    private lazy var updateInterpolation: Interpolate = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.scrollView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 1.0) {
            DispatchQueue.main.async { [weak self] in
                self?.indicator.stopAnimation()
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
    //
    //
    
    var conversationList: ConversationList? {
        didSet {
            DispatchQueue.main.async {
                self.recacheConversations()
                self.collectionView.reloadData()
                self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                             scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
                self.updateInterpolation.animate(duration: 1.5)
            }
        }
    }
    
    private var sortedConversations = [Conversation]()
    
    private func recacheConversations() {
        guard self.conversationList != nil else {
            self.sortedConversations = []; return
        }
        self.sortedConversations = self.conversationList!.conversations.values
            .filter { !$0.archived }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    //
    //
    //
    
    public override func loadView() {
        self.view = NSVisualEffectView()
        self.view.add(subviews: [self.scrollView, self.indicator])
        
        self.view.width >= 128
        self.view.height >= 128
        self.view.centerX == self.indicator.centerX
        self.view.centerY == self.indicator.centerY
        self.view.centerX == self.scrollView.centerX
        self.view.centerY == self.scrollView.centerY
        self.view.width == self.scrollView.width
        self.view.height == self.scrollView.height
        
        // Register for Conversation "delegate" changes.
        let c = NotificationCenter.default
        c.addObserver(self, selector: #selector(ConversationListViewController.conversationDidUpdate(_:)),
                      name: Notification.Conversation.DidUpdate, object: nil)
        c.addObserver(self, selector: #selector(ConversationListViewController.conversationDidUpdateList(_:)),
                      name: Notification.Conversation.DidUpdateList, object: nil)
        c.addObserver(self, selector: #selector(ConversationListViewController.conversationDidReceiveEvent(_:)),
                      name: Notification.Conversation.DidReceiveEvent, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.childrenSub = nil
    }
    
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .unifiedTitleAndToolbar, .fullSizeContentView]
        window.appearance = ParrotAppearance.interfaceStyle().appearance()
        window.enableRealTitlebarVibrancy(.withinWindow)
        window.titleVisibility = .hidden
        let container = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        window.addTitlebarAccessoryViewController(self.titleAccessory)
        window.addTitlebarAccessoryViewController(self.searchAccessory)
        
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "add"))
        item.view = self.addButton
        item.label = "Add"
        let item2 = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "search"))
        item2.view = self.searchToggle
        item2.label = "Search"
        container.templateItems = [item, item2]
        container.itemOrder = [.flexibleSpace, NSToolbarItem.Identifier(rawValue: "add"), NSToolbarItem.Identifier(rawValue: "search")]
    }
    
    public override func viewDidLoad() {
        self.childrenSub = AutoSubscription(kind: .OpenConversationsUpdated) { _ in
            log.debug("Updating childConversations... \(Array(MessageListViewController.openConversations.keys))")
            self.updateSelectionIndexes()
        }
        
        if let service = ServiceRegistry.services.values.first {
            self.conversationList = service.conversations
        }
        NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
            self.conversationList = c.conversations
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                             scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
                self.updateSelectionIndexes()
            }
            
            let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
            NSApp.badgeCount = UInt(unread)
        }
    }
    
    public override func viewWillAppear() {
        if self.view.window != nil {
            syncAutosaveTitle()
            PopWindowAnimator.show(self.view.window!)
        }
        
        let frame = self.scrollView.layer!.frame
        self.scrollView.layer!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scrollView.layer!.position = CGPoint(x: frame.midX, y: frame.midY)
        self.scrollView.alphaValue = 0.0
        self.indicator.startAnimation()
        
        ParrotAppearance.registerVibrancyStyleListener(observer: self, invokeImmediately: true) { style in
            guard let vev = self.view as? NSVisualEffectView else { return }
            vev.state = style.visualEffectState()
        }
    }
    
    /// If we need to close, make sure we clean up after ourselves, instead of deinit.
    public override func viewWillDisappear() {
        ParrotAppearance.unregisterInterfaceStyleListener(observer: self)
        ParrotAppearance.unregisterVibrancyStyleListener(observer: self)
    }
    
    /// Re-synchronizes the conversation name and identifier with the window.
    /// Center by default, but load a saved frame if available, and autosave.
    private func syncAutosaveTitle() {
        self.view.window?.center()
        self.view.window?.setFrameUsingName(NSWindow.FrameAutosaveName(rawValue: "Conversations"))
        self.view.window?.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: "Conversations"))
    }
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        guard self.view.window != nil else { return true }
        PopWindowAnimator.hide(self.view.window!)
        return false
    }
    
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        for (_, s) in ServiceRegistry.services {
            s.userInteractionState = true // FIXME
        }
    }
    
    ///
    ///
    ///
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sortedConversations.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ConversationCell.self)"), for: indexPath)
        item.representedObject = self.sortedConversations[indexPath.item]
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.map { self.sortedConversations[$0.item] }.forEach {
            MessageListViewController.show(conversation: $0, parent: self.parent)
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.map { self.sortedConversations[$0.item] }.forEach {
            MessageListViewController.hide(conversation: $0)
        }
    }
    
    
    
    public func reachedEdge(in: NSView, edge: NSRectEdge) {
        func scrollback() {
            guard self.updateToken == false else { return }
            let _ = self.conversationList?.syncConversations(count: 25, since: self.conversationList!.syncTimestamp) { val in
                self.recacheConversations()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()//.tableView.noteNumberOfRowsChanged()
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
    
    //
    //
    //
    
    /* TODO: Just update the row that is updated. */
    @objc public func conversationDidReceiveEvent(_ notification: Notification) {
        self.updateList()
    }
    @objc public func conversationDidUpdate(_ notification: Notification) {
        self.updateList()
    }
    @objc public func conversationDidUpdateList(_ notification: Notification) {
        self.updateList()
    }
    
    private func updateList() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                         scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
            let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
            NSApp.badgeCount = UInt(unread)
            self.updateSelectionIndexes()
        }
    }
    
    private func updateSelectionIndexes() {
        let paths = Array(MessageListViewController.openConversations.keys)
            .flatMap { id in self.sortedConversations.index { $0.identifier == id } }
            .map { IndexPath(item: $0, section: 0) }
        self.collectionView.selectionIndexPaths = Set(paths)
    }
    
    @objc private func toggleSearchField(_ sender: NSButton!) {
        self.searchAccessory.animator().isHidden = (sender.state != NSControl.StateValue.on)
    }
    
    @objc private func searching(_ sender: NSSearchField!) {
        print("got string \(sender.stringValue)")
    }
}

