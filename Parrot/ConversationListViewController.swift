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
    }()
    
    private lazy var indicator: MessageProgressView = {
        let v = MessageProgressView().modernize(wantsLayer: true)
        return v
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
        self.view = NSView()
        self.view.add(subviews: self.scrollView, self.indicator) {
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
        }
    }
    
    //
    //
    //
    
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
    }
    
    private func updateSelectionIndexes() {
        let paths = Array(MessageListViewController.openConversations.keys)
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
