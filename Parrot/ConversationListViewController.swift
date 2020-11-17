<<<<<<< Updated upstream
import MochaUI
import ParrotServiceExtension

// Plan for this class:
//
// - ModelController <--> Controller <--> ViewController
// - Yeah, that's *three* controller classes.
// - The ViewInteracting/ModelInteracting protocols describe interactions between them.
// - Alternatively, better `Bindable` or `Observable` support would help.
// - `Controller` would then be a wrapper for all the bindings and house both `Model/ViewController`s
// - `Controller` probably needs a better name...
// - `ModelController` will handle dataSource-side events and all.
// - Use something like NSViewControllerEmptyPresenting or NSViewControllerLoadingPresenting?
=======
import Foundation
import AppKit
import Mocha
import MochaUI
import ParrotServiceExtension

/* TODO: Support stickers, photos, videos, files, audio, and location. */
/* TODO: Show DND icon in Cell when conversation is muted. */
/* TODO: Support not sending Read Receipts. */
>>>>>>> Stashed changes

//private let log = Logger(subsystem: "Parrot.ConversationListViewController")
let sendQ = DispatchQueue(label: "com.avaidyam.Parrot.sendQ", qos: .userInteractive)
let linkQ = DispatchQueue(label: "com.avaidyam.Parrot.linkQ", qos: .userInitiated)

<<<<<<< Updated upstream
public class ConversationListViewController: NSViewController,
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
        l.appearEffect = [.effectFade, .slideUp]
        l.disappearEffect = [.effectFade, .slideDown]
        //l.minimumInteritemSpacing = 0.0
        //l.minimumLineSpacing = 0.0
        //l.sectionInset = NSEdgeInsetsZero
        c.collectionViewLayout = l
        c.register(ConversationCell.self,
                   forItemWithIdentifier: .conversationCell)
        c.register(ReloadCell.self, forSupplementaryViewOfKind: .globalFooter,
                   withIdentifier: .reloadCell)
        c.register(SearchCell.self, forSupplementaryViewOfKind: .globalHeader,
                   withIdentifier: .searchCell)
        return c
    }()
    
    private lazy var scrollView: NSScrollView = {
        let s = NSScrollView(for: self.collectionView).modernize()
        return s
=======
public class ConversationListViewController: NSViewController, WindowPresentable,
ListViewDataDelegate2, ListViewSelectionDelegate2, ListViewScrollbackDelegate2 {
    
    private lazy var listView: ListView2 = {
        let v = ListView2().modernize(wantsLayer: true)
        v.flowDirection = .top
        v.selectionType = .any
        v.delegate = self
        v.scrollView.automaticallyAdjustsContentInsets = true
        v.collectionView.register(ConversationCell.self, forItemWithIdentifier: "\(ConversationCell.self)")
        //v.insets = EdgeInsets(top: 114.0, left: 0, bottom: 0, right: 0)
        return v
>>>>>>> Stashed changes
    }()
    
    private lazy var indicator: MessageProgressView = {
        let v = MessageProgressView().modernize(wantsLayer: true)
        return v
    }()
    
<<<<<<< Updated upstream
    private var updateToken: Bool = false
    private var childrenSub: Subscription? = nil
    
    private lazy var updateInterpolation: Interpolate<Double> = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.scrollView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 1.0) {
            UI { [weak self] in
=======
    private lazy var titleText: NSTextField = {
        let t = NSTextField(labelWithString: " Conversations").modernize(wantsLayer: true)
        t.textColor = NSColor.labelColor
        t.font = NSFont.systemFont(ofSize: 32.0, weight: NSFontWeightHeavy)
        return t
    }()
    
    private lazy var searchField: NSSearchField = {
        return NSSearchField().modernize(wantsLayer: true)
    }()
    
    private lazy var addButton: NSButton = {
        let b = NSButton(title: "", image: NSImage(named: "NSAddBookmarkTemplate")!,
                         target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        return b
    }()
    
    private lazy var searchToggle: NSButton = {
        let b = NSButton(title: "", image: NSImage(named: NSImageNameRevealFreestandingTemplate)!,
                         target: self, action: #selector(self.toggleSearchField(_:))).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.setButtonType(.onOff)
        b.state = NSControlStateValueOn
        return b
    }()
    
    private lazy var titleAccessory: NSTitlebarAccessoryViewController = {
        let v = NSView()
        v.add(subviews: [self.titleText/*, self.addButton*//*, self.searchField*/])
        v.autoresizingMask = [.viewWidthSizable]
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
            self?.listView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 1.0) {
            DispatchQueue.main.async { [weak self] in
>>>>>>> Stashed changes
                self?.indicator.stopAnimation()
            }
        }
        indicatorAnim.handlerRunPolicy = .always
<<<<<<< Updated upstream
        let scaleAnim = Interpolate(from: CGAffineTransform(translationX: 0, y: 196), to: .identity, interpolator: EaseInOutInterpolator()) { [weak self] scale in
            self?.scrollView.layer!.setAffineTransform(scale)
        }
        let group = AnyInterpolate.group(indicatorAnim, scaleAnim)
=======
        let scaleAnim = Interpolate(from: CGAffineTransform(scaleX: 1.5, y: 1.5), to: .identity, interpolator: EaseInOutInterpolator()) { [weak self] scale in
            self?.listView.layer!.setAffineTransform(scale)
        }
        let group = Interpolate.group(indicatorAnim, scaleAnim)
>>>>>>> Stashed changes
        return group
    }()
    
    //
    //
    //
    
    var conversationList: ConversationList? {
        didSet {
<<<<<<< Updated upstream
            self.updateDataSource(Array(self.conversationList!.conversations.values)) {
                self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                             scrollPosition: [.centeredHorizontally, .nearestHorizontalEdge])
=======
            self.listView.update(animated: false) {
>>>>>>> Stashed changes
                self.updateInterpolation.animate(duration: 1.5)
            }
        }
    }
    
<<<<<<< Updated upstream
    private var dataSource = SortedArray<Conversation>() { a, b in
        return a.sortTimestamp > b.sortTimestamp
=======
    // FIXME: this is recomputed A LOT! bad idea...
    var sortedConversations: [Conversation] {
        guard self.conversationList != nil else { return [] }
        return self.conversationList!.conversations.values
            .filter { !$0.archived }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    public func numberOfItems(in: ListView2) -> [UInt] {
        return [UInt(self.sortedConversations.count)]
    }
    
    public func object(in: ListView2, at: ListView2.Index) -> Any? {
        return self.sortedConversations[Int(at.item)]
    }
    
    public func itemClass(in: ListView2, at: ListView2.Index) -> NSCollectionViewItem.Type {
        return ConversationCell.self
    }
    
    public func cellHeight(in view: ListView2, at: ListView2.Index) -> Double {
        return 48.0 + 16.0 /* padding */
    }
    
    public func proposedSelection(in list: ListView2, at: [ListView2.Index], selecting: Bool) -> [ListView2.Index] {
        return at//list.selection + at // Only additive!
    }
    
    public func selectionChanged(in: ListView2, is selection: [ListView2.Index], selecting: Bool) {
        let src = self.sortedConversations
        let dest = Set(MessageListViewController.openConversations.keys)
        let convs = Set(Array(self.listView.collectionView.selectionIndexPaths).map { src[Int($0.item)].identifier })
        
        // Conversations selected that we don't already have. --> ADD
        convs.subtracting(dest).forEach { id in
            let conv = self.sortedConversations.filter { $0.identifier == id }.first!
            MessageListViewController.show(conversation: conv, parent: self.parent)
        }
        // Conversations we have that are not selected. --> REMOVE
        dest.subtracting(convs).forEach { id in
            let conv = self.sortedConversations.filter { $0.identifier == id }.first!
            MessageListViewController.hide(conversation: conv)
        }
    }
    
    public func reachedEdge(in: ListView2, edge: NSRectEdge) {
        func scrollback() {
            guard self.updateToken == false else { return }
            let _ = self.conversationList?.syncConversations(count: 25, since: self.conversationList!.syncTimestamp) { val in
                DispatchQueue.main.async {
                    self.listView.collectionView.reloadData()//.tableView.noteNumberOfRowsChanged()
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
>>>>>>> Stashed changes
    }
    
    //
    //
    //
    
    public override func loadView() {
<<<<<<< Updated upstream
        self.view = NSView()
        self.view.add(subviews: self.scrollView, self.indicator) {
            self.view.sizeAnchors >= CGSize(width: 128, height: 128)
            self.view.centerAnchors == self.indicator.centerAnchors
            self.view.edgeAnchors == self.scrollView.edgeAnchors
        }
=======
        self.view = NSVisualEffectView()
        self.view.add(subviews: [self.listView, self.indicator])
        
        self.view.width >= 128
        self.view.height >= 128
        self.view.centerX == self.indicator.centerX
        self.view.centerY == self.indicator.centerY
        self.view.centerX == self.listView.centerX
        self.view.centerY == self.listView.centerY
        self.view.width == self.listView.width
        self.view.height == self.listView.height
>>>>>>> Stashed changes
        
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
    
<<<<<<< Updated upstream
    public override func viewDidLoad() {
        self.childrenSub = AutoSubscription(kind: .openConversationsUpdated) { _ in
=======
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .unifiedTitleAndToolbar, .fullSizeContentView]
        window.appearance = ParrotAppearance.interfaceStyle().appearance()
        window.enableRealTitlebarVibrancy(.withinWindow)
        window.titleVisibility = .hidden
        let container = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        window.addTitlebarAccessoryViewController(self.titleAccessory)
        window.addTitlebarAccessoryViewController(self.searchAccessory)
        
        let item = NSToolbarItem(itemIdentifier: "add")
        item.view = self.addButton
        item.label = "Add"
        let item2 = NSToolbarItem(itemIdentifier: "search")
        item2.view = self.searchToggle
        item2.label = "Search"
        container.templateItems = [item, item2]
        container.itemOrder = [NSToolbarFlexibleSpaceItemIdentifier, "add", "search"]
    }
    
    public override func viewDidLoad() {
        self.childrenSub = AutoSubscription(kind: .OpenConversationsUpdated) { _ in
>>>>>>> Stashed changes
            log.debug("Updating childConversations... \(Array(MessageListViewController.openConversations.keys))")
            self.updateSelectionIndexes()
        }
        
        if let service = ServiceRegistry.services.values.first {
            self.conversationList = service.conversations
        }
        NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
            self.conversationList = c.conversations
            
<<<<<<< Updated upstream
            UI {
                //self.collectionView.reloadData()
                self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                             scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
                self.updateSelectionIndexes()
            }
            
            let unread = self.dataSource.map { $0.unreadCount }.reduce(0, +)
            NSApp.badgeCount = UInt(unread)
        }
        Analytics.view(screen: .conversationList)
    }
    
    public override func viewWillAppear() {
        //let frame = self.scrollView.layer!.frame
        //self.scrollView.layer!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //self.scrollView.layer!.position = CGPoint(x: frame.midX, y: frame.midY)
        self.scrollView.alphaValue = 0.0
        self.indicator.startAnimation()
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
        return self.currentDataSource().count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .conversationCell, for: indexPath)
        item.representedObject = self.currentDataSource()[indexPath.item]
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        switch kind {
        case .globalHeader:
            let header = collectionView.makeSupplementaryView(ofKind: .globalHeader, withIdentifier: .searchCell, for: indexPath) as! SearchCell
            header.searchHandler = self.searchTerm(_:)
            header.sortOptions = ["Name", "Date"]
            header.addHandler = {
                let d = DirectoryListViewController()
                d.view.frame.size.width = self.view.frame.width
                d.view.frame.size.height = (self.view.frame.height / 3).clamped(to: 128.0...4000.0)
                d.canSelect = true
                d.displaysCloseOptions = true
                
                self.presentViewControllerAsSheet(d)
                if let t = self.view.window?.titlebarAccessoryViewControllers.filter({ $0 is LargeTypeTitleController }).first {
                    t.title = "Create"
                }
                d.selectionHandler = {
                    guard d.selection.count > 0 else { return }
                    self.dismissViewController(d)
                    if let t = self.view.window?.titlebarAccessoryViewControllers.filter({ $0 is LargeTypeTitleController }).first {
                        t.title = "Conversations"
                    }
                    self.startNewConversation(with: d.selection)
                }
            }
            return header
        case .globalFooter:
            let footer = collectionView.makeSupplementaryView(ofKind: .globalFooter, withIdentifier: .reloadCell, for: indexPath) as! ReloadCell
            footer.handler = self.scrollback
            return footer
        default:
            return NSView()
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 64.0)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 32.0)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 32.0)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.map { self.dataSource[$0.item] }.forEach {
            MessageListViewController.show(conversation: $0, parent: self.parent)
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.map { self.dataSource[$0.item] }.forEach {
            MessageListViewController.hide(conversation: $0)
=======
            DispatchQueue.main.async {
                self.listView.update()
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
        
        let frame = self.listView.layer!.frame
        self.listView.layer!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.listView.layer!.position = CGPoint(x: frame.midX, y: frame.midY)
        self.listView.alphaValue = 0.0
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
        self.view.window?.setFrameUsingName("Conversations")
        self.view.window?.setFrameAutosaveName("Conversations")
    }
    
    public func windowShouldClose(_ sender: Any) -> Bool {
        guard self.view.window != nil else { return true }
        PopWindowAnimator.hide(self.view.window!)
        return false
    }
    
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        for (_, s) in ServiceRegistry.services {
            s.userInteractionState = true // FIXME
>>>>>>> Stashed changes
        }
    }
    
    //
    //
    //
    
<<<<<<< Updated upstream
    // Re-sort the conversation list based on the latest sort timestamps and update the list.
    @objc dynamic public func conversationDidReceiveEvent(_ notification: Notification) {
        let oldVal = self.currentDataSource().map { $0.identifier }
        self.dataSource.resort()
        let updates = Changeset.edits(from: oldVal, to: self.currentDataSource().map { $0.identifier })
        UI { self.collectionView.update(with: updates, in: 0) {_ in} }
    }
    
    /* TODO: Just update the row that is updated. */
    @objc dynamic public func conversationDidUpdate(_ notification: Notification) {
        self.conversationDidUpdateList(notification)
    }
    @objc dynamic public func conversationDidUpdateList(_ notification: Notification) {
        /*
         let oldVal = self.dataSource.map { $0.identifier }
         let updates = Changeset.edits(from: oldVal, to: self.dataSource.map { $0.identifier })
         UI { self.collectionView.update(with: updates, in: 0) {_ in} }
         */
        UI {
            self.collectionView.reloadData()
            self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                                                         scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
            let unread = self.dataSource.map { $0.unreadCount }.reduce(0, +)
            NSApp.badgeCount = UInt(unread)
            self.updateSelectionIndexes()
        }
    }
    
    //
    //
    //
    
    // filters stuff too!
    private func currentDataSource() -> SortedArray<Conversation> {
        if let st = self.searchTerm {
            return self.dataSource.filter { $0.name.lowercased().contains(st.lowercased()) }
        } else {
            return self.dataSource
        }
    }
    private var searchTerm: String? = nil
    private func searchTerm(_ str: String) {
        let oldVal = self.currentDataSource().map { $0.identifier }
        self.searchTerm = str == "" ? nil : str
        let updates = Changeset.edits(from: oldVal, to: self.currentDataSource().map { $0.identifier })
        UI { self.collectionView.update(with: updates, in: 0) {_ in} }
        
    }
    
    //
    //
    //
    
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
    
    private func updateDataSource(_ newContent: [Conversation], _ handler: @escaping () -> () = {}) {
        let oldVal = self.currentDataSource().map { $0.identifier }
        self.dataSource.insert(contentsOf: newContent.filter { !$0.archived })
        let updates = Changeset.edits(from: oldVal, to: self.currentDataSource().map { $0.identifier })
        UI { self.collectionView.update(with: updates, in: 0) { _ in handler() } }
=======
    /* TODO: Just update the row that is updated. */
    public func conversationDidReceiveEvent(_ notification: Notification) {
        self.updateList()
    }
    public func conversationDidUpdate(_ notification: Notification) {
        self.updateList()
    }
    public func conversationDidUpdateList(_ notification: Notification) {
        self.updateList()
    }
    
    private func updateList() {
        DispatchQueue.main.async {
            self.listView.update()
            let unread = self.sortedConversations.map { $0.unreadCount }.reduce(0, +)
            NSApp.badgeCount = UInt(unread)
            self.updateSelectionIndexes()
        }
>>>>>>> Stashed changes
    }
    
    private func updateSelectionIndexes() {
        let paths = Array(MessageListViewController.openConversations.keys)
<<<<<<< Updated upstream
            .compactMap { id in self.dataSource.index { $0.identifier == id } }
            .map { IndexPath(item: $0, section: 0) }
        self.collectionView.selectionIndexPaths = Set(paths)
    }
    
    //
    //
    //
    
    private func startNewConversation(with people: [Person]) {
        guard let c = self.conversationList?.begin(with: people) else {
            NSAlert(style: .critical, message: "Couldn't start a conversation with \"\(people.map { $0.fullName })\"", buttons: ["Okay"]).runModal()
            return
        }
        MessageListViewController.show(conversation: c, parent: self.parent)
    }
}
=======
            .flatMap { id in self.sortedConversations.index { $0.identifier == id } }
            .map { (section: UInt(0), item: UInt($0)) }
        self.listView.selection = paths
    }
    
    @objc private func toggleSearchField(_ sender: NSButton!) {
        self.searchAccessory.animator().isHidden = (sender.state != NSControlStateValueOn)
    }
}

>>>>>>> Stashed changes
