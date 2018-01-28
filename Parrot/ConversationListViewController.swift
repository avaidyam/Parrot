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
    
    private lazy var titleAccessory: NSTitlebarAccessoryViewController = {
        let v = NSView()
        v.add(subviews: self.titleText/*, self.addButton*//*, self.searchField*/)
        v.autoresizingMask = [.width]
        v.frame.size.height = 44.0//80.0
        self.titleText.leftAnchor == v.leftAnchor + 2.0
        self.titleText.topAnchor == v.topAnchor + 2.0
        let t = NSTitlebarAccessoryViewController()
        t.view = v
        t.layoutAttribute = .bottom
        return t
    }()
    
    private var updateToken: Bool = false
    private var childrenSub: Subscription? = nil
    
    private lazy var updateInterpolation: Interpolate<Double> = {
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
        let scaleAnim = Interpolate(from: CGAffineTransform(translationX: 0, y: 196), to: .identity, interpolator: EaseInOutInterpolator()) { [weak self] scale in
            self?.scrollView.layer!.setAffineTransform(scale)
        }
        let group = AnyInterpolate.group(indicatorAnim, scaleAnim)
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
        return a.sortTimestamp > b.sortTimestamp
    }
    
    //
    //
    //
    
    public override func loadView() {
        self.view = NSVisualEffectView()
        self.view.add(subviews: self.scrollView, self.indicator)
        batch {
            self.view.sizeAnchors >= CGSize(width: 128, height: 128)
            self.view.centerAnchors == self.indicator.centerAnchors
            self.view.edgeAnchors == self.scrollView.edgeAnchors
        }
        
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
        _ = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        window.addTitlebarAccessoryViewController(self.titleAccessory)
        
        //let item = NSToolbarItem(itemIdentifier: .add)
        //item.view = self.addButton
        //item.label = "Add"
        //container.templateItems = [item]
        //container.itemOrder = [.flexibleSpace, .add]
    }
    
    public override func viewDidLoad() {
        self.childrenSub = AutoSubscription(kind: .openConversationsUpdated) { _ in
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
        GoogleAnalytics.view(screen: .conversationList)
    }
    
    public override func viewWillAppear() {
        if self.view.window != nil {
            syncAutosaveTitle()
            PopWindowAnimator.show(self.view.window!)
        }
        
        //let frame = self.scrollView.layer!.frame
        //self.scrollView.layer!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //self.scrollView.layer!.position = CGPoint(x: frame.midX, y: frame.midY)
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
        }
    }
    
    //
    //
    //
    
    // Re-sort the conversation list based on the latest sort timestamps and update the list.
    @objc public func conversationDidReceiveEvent(_ notification: Notification) {
        let oldVal = self.currentDataSource().map { $0.identifier }
        self.dataSource.resort()
        let updates = Changeset.edits(from: oldVal, to: self.currentDataSource().map { $0.identifier })
        UI { self.collectionView.update(with: updates, in: 0) {_ in} }
    }
    
    /* TODO: Just update the row that is updated. */
    @objc public func conversationDidUpdate(_ notification: Notification) {
        self.conversationDidUpdateList(notification)
    }
    @objc public func conversationDidUpdateList(_ notification: Notification) {
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
