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
        l.globalSections = (32, 32)
        l.layoutDefinition = .global(SizeMetrics(item: CGSize(width: 0, height: 64)))
        //l.appearEffect = [.effectFade, .slideUp]
        //l.disappearEffect = [.effectFade, .slideDown]
        c.collectionViewLayout = l
        c.register(ConversationCell.self,
                   forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ConversationCell.self)"))
        c.register(ReloadCell.self, forSupplementaryViewOfKind: .globalFooter,
                   withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ReloadCell.self)"))
        c.register(SearchCell.self, forSupplementaryViewOfKind: .globalHeader,
                   withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(SearchCell.self)"))
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
    
    private lazy var addButton: NSButton = {
        let b = NSButton(title: "", image: #imageLiteral(resourceName: "Compose"), target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.performedAction = {
            let d = DirectoryListViewController()
            d.view.frame.size.width = self.view.frame.width
            d.view.frame.size.height = (self.view.frame.height / 3).clamped(to: 128.0...4000.0)
            d.selectable = true
            
            self.presentViewControllerAsSheet(d)
            self.titleText.stringValue = " Create"
            d.selectionHandler = {
                guard d.selection.count > 0 else { return }
                self.dismissViewController(d)
                self.titleText.stringValue = " Conversations"
                self.startNewConversation(with: d.selection[0])
            }
        }
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
    
    private var updateToken: Bool = false
    private var childrenSub: Subscription? = nil
    
    private lazy var updateInterpolation: Interpolate = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.scrollView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 1.0) {
            UI { [weak self] in
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
            self.updateDataSource(Array(self.conversationList!.conversations.values)) {
                self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                             scrollPosition: [.centeredHorizontally, .nearestHorizontalEdge])
                self.updateInterpolation.animate(duration: 1.5)
            }
        }
    }
    
    private var dataSource = SortedArray<Conversation>() { a, b in
        return a.timestamp > b.timestamp
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
        if let vev = window.titlebar.view as? NSVisualEffectView {
            vev.material = .appearanceBased
            vev.state = .active
            vev.blendingMode = .withinWindow
        }
        window.titleVisibility = .hidden
        let container = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        window.addTitlebarAccessoryViewController(self.titleAccessory)
        
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "add"))
        item.view = self.addButton
        item.label = "Add"
        container.templateItems = [item]
        container.itemOrder = [.flexibleSpace, NSToolbarItem.Identifier(rawValue: "add")]
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
            
            UI {
                //self.collectionView.reloadData()
                self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                             scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
                self.updateSelectionIndexes()
            }
            
            let unread = self.dataSource.map { $0.unreadCount }.reduce(0, +)
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
        
        ParrotAppearance.registerListener(observer: self, invokeImmediately: true) { interface, style in
            self.view.window?.appearance = interface
            (self.view as? NSVisualEffectView)?.state = style
        }
    }
    
    /// If we need to close, make sure we clean up after ourselves, instead of deinit.
    public override func viewWillDisappear() {
        ParrotAppearance.unregisterListener(observer: self)
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
        return self.dataSource.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ConversationCell.self)"), for: indexPath)
        item.representedObject = self.dataSource[indexPath.item]
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        switch kind {
        case .globalHeader:
            let header = collectionView.makeSupplementaryView(ofKind: .globalHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(SearchCell.self)"), for: indexPath) as! SearchCell
            header.handler = {
                print("got string \(String(describing: $0))")
            }
            return header
        case .globalFooter:
            let footer = collectionView.makeSupplementaryView(ofKind: .globalFooter, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(ReloadCell.self)"), for: indexPath) as! ReloadCell
            footer.handler = self.scrollback
            return footer
        default:
            return NSView()
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.map { self.dataSource[$0.item] }.forEach {
            MessageListViewController.show(conversation: $0, parent: self.parent)
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.map { self.dataSource[$0.item] }.forEach {
            MessageListViewController.hide(conversation: $0)
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
    
    private func scrollback() {
        guard self.updateToken == false else { return }
        let _ = self.conversationList?.syncConversations(count: 25, since: self.conversationList!.syncTimestamp) { val in
            guard let val = val else { return }
            self.updateDataSource(Array(val.values)) {
                self.updateToken = false
            }
        }
        self.updateToken = true
    }
    
    private func updateList() {
        UI {
            self.collectionView.reloadData()
            self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                         scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
            let unread = self.dataSource.map { $0.unreadCount }.reduce(0, +)
            NSApp.badgeCount = UInt(unread)
            self.updateSelectionIndexes()
        }
    }
    
    private func updateDataSource(_ newContent: [Conversation], _ handler: @escaping () -> () = {}) {
        let oldVal = self.dataSource.map { $0.identifier }
        self.dataSource.insert(contentsOf: newContent.filter { !$0.archived })
        let updates = Changeset.edits(from: oldVal, to: self.dataSource.map { $0.identifier })
        UI { self.collectionView.update(with: updates, in: 0) { _ in handler() } }
    }
    
    private func updateSelectionIndexes() {
        let paths = Array(MessageListViewController.openConversations.keys)
            .flatMap { id in self.dataSource.index { $0.identifier == id } }
            .map { IndexPath(item: $0, section: 0) }
        self.collectionView.selectionIndexPaths = Set(paths)
    }
    
    //
    //
    //
    
    private func startNewConversation(with person: Person) {
        guard let c = self.conversationList?.begin(with: person) else {
            NSAlert(style: .critical, message: "Couldn't start a conversation with \"\(person.fullName)\"", buttons: ["Okay"]).runModal()
            return
        }
        MessageListViewController.show(conversation: c, parent: self.parent)
    }
}

