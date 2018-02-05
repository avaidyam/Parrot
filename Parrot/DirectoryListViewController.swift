import MochaUI
import ParrotServiceExtension

/* TODO: UISearchController for NSViewControllers. */

public class DirectoryListViewController: NSViewController, WindowPresentable,
NSSearchFieldDelegate, NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    
    private lazy var collectionView: NSCollectionView = {
        let c = NSCollectionView(frame: .zero)//.modernize(wantsLayer: true)
        //c.layerContentsRedrawPolicy = .onSetNeedsDisplay // FIXME: causes a random white background
        c.dataSource = self
        c.delegate = self
        c.backgroundColors = [.clear]
        c.selectionType = .any
        
        let l = NSCollectionViewListLayout()
        l.globalSections = (32, 0)
        l.layoutDefinition = .global(SizeMetrics(item: CGSize(width: 0, height: 48)))
        //l.minimumInteritemSpacing = 0.0
        //l.minimumLineSpacing = 0.0
        //l.sectionInset = NSEdgeInsetsZero
        c.collectionViewLayout = l
        c.register(PersonCell.self,
                   forItemWithIdentifier: .personCell)
        c.register(SearchCell.self, forSupplementaryViewOfKind: .globalHeader,
                   withIdentifier: .searchCell)
        return c
    }()
    
    private lazy var scrollView: NSScrollView = {
        NSScrollView(for: self.collectionView).modernize()
    }()
    
    private lazy var indicator: MessageProgressView = {
        MessageProgressView().modernize(wantsLayer: true)
    }()
    
    private lazy var statusText: NSTextField = {
        let b = NSTextField(labelWithString: "Create...")
        b.textColor = .secondaryLabelColor
        b.controlSize = .small
        return b
    }()
    
    private lazy var statusButton: NSButton = {
        let b = LayerButton(title: "Cancel", target: nil, action: nil)
            .modernize(wantsLayer: true)
        b.performedAction = { [weak self] in
            if (self?.selection.count ?? 0) > 0 {
                self?.selectionHandler?()
            } else {
                self?.cancelOperation(nil)
            }
        }
        b.bezelStyle = .roundRect // height = 18px
        return b
    }()
    
    private lazy var baseView: NSVisualEffectView = {
        let v = NSVisualEffectView().modernize()
        v.blendingMode = .withinWindow
        v.material = .sidebar
        v.state = .active
        v.isHidden = true // initial state
        v.add(subviews: self.statusText, self.statusButton)
        batch {
            v.heightAnchor == (18.0 + 8.0)
            v.centerYAnchor == self.statusText.centerYAnchor
            v.centerYAnchor == self.statusButton.centerYAnchor
            self.statusText.leadingAnchor == v.leadingAnchor + 4.0
            self.statusButton.trailingAnchor == v.trailingAnchor - 4.0
            self.statusText.trailingAnchor <= self.statusButton.leadingAnchor - 4.0
        }
        return v
    }()
    
    private lazy var updateInterpolation: Interpolate<Double> = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.scrollView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 1.0) {
            UI { self.indicator.stopAnimation() }
        }
        indicatorAnim.handlerRunPolicy = .always
        let scaleAnim = Interpolate(from: CGAffineTransform(scaleX: 1.5, y: 1.5), to: .identity, interpolator: EaseInOutInterpolator()) { [weak self] scale in
            self?.scrollView.layer!.setAffineTransform(scale)
        }
        let group = AnyInterpolate.group(indicatorAnim, scaleAnim)
        return group
    }()
    
    //
    //
    //
    
    var directory: ParrotServiceExtension.Directory? {
        didSet {
            DispatchQueue.global(qos: .background).async {
                self.cachedFavorites = self.directory?.list(25) ?? []
                UI {
                    self.collectionView.reloadData()
                    //self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                    //                                             scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
                    self.updateInterpolation.animate(duration: 1.5)
                }
            }
        }
    }
    
    public var displaysCloseOptions = false {
        didSet {
            self.scrollView.contentInsets = NSEdgeInsetsMake(0, 0, self.displaysCloseOptions ? 32 : 0, 0)
            self.baseView.isHidden = !self.displaysCloseOptions
        }
    }
    
    // We should be able to now edit things.
    public var selectable = false {
        didSet {
            self.collectionView.selectionType = self.selectable ? .any : .none
            //self.collectionView.allowsMultipleSelection = self.selectable
        }
    }
    
    public var selectionHandler: (() -> ())? = nil
    
    //
    //
    //
    
    public private(set) var selection: [Person] = []
    private var cachedFavorites: [Person] = []
    private var currentSearch: [Person]? = nil
    
    private var searchQuery: String = "" { // TODO: BINDING HERE
        didSet {
            let oldVal = self.currentSource().map { $0.identifier }
            self.currentSearch = self.searchQuery == "" ? nil :
                self.directory?.search(by: self.searchQuery, limit: 25)
            let newVal = self.currentSource().map { $0.identifier }
            
            let updates = Changeset.edits(from: oldVal, to: newVal)
            UI { self.collectionView.update(with: updates, in: 1) {_ in} }
        }
    }
    
    private func currentSource() -> [Person] {
        var active = self.currentSearch != nil ? self.currentSearch! : self.cachedFavorites
        for s in self.selection {
            guard let idx = (active.index { $0.identifier == s.identifier }) else { continue }
            active.remove(at: idx)
        }
        return active
    }
    
    //
    //
    //
    
    public override func loadView() {
        self.title = "Directory"
        self.view = NSVisualEffectView()
        self.view.add(subviews: self.scrollView, self.baseView, self.indicator)
        batch {
            self.view.sizeAnchors >= CGSize(width: 128, height: 128)
            self.view.centerAnchors == self.indicator.centerAnchors
            self.view.edgeAnchors == self.scrollView.edgeAnchors
            self.view.bottomAnchor == self.baseView.bottomAnchor
            self.view.horizontalAnchors == self.baseView.horizontalAnchors
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
        _ = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        window.addTitlebarAccessoryViewController(LargeTypeTitleController(title: self.title))
        
        /// Re-synchronizes the conversation name and identifier with the window.
        /// Center by default, but load a saved frame if available, and autosave.
        window.center()
        window.setFrameUsingName(NSWindow.FrameAutosaveName(rawValue: self.title!))
        window.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: self.title!))
    }
    
    public override func viewDidLoad() {
        if let service = ServiceRegistry.services.values.first {
            self.directory = service.directory
        }
        NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
            self.directory = c.directory
        }
        Analytics.view(screen: .directory)
    }
    
    public override func viewWillAppear() {
        PopWindowAnimator.show(self.view.window!)
        
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
    
    public override func viewWillLayout() {
        super.viewWillLayout()
        let ctx = NSCollectionViewFlowLayoutInvalidationContext()
        ctx.invalidateFlowLayoutDelegateMetrics = true
        self.collectionView.collectionViewLayout?.invalidateLayout(with: ctx)
    }
    
    public override func cancelOperation(_ sender: Any?) {
        if let _ = self.presenting {
            self.dismiss(sender)
        } else {
            PopWindowAnimator.hide(self.view.window!)
        }
    }
    
    ///
    ///
    ///
    
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 2 // selection, currentSource
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.selection.count : self.currentSource().count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .personCell, for: indexPath)
        item.representedObject = indexPath.section == 0 ? self.selection[indexPath.item] : self.currentSource()[indexPath.item]
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let header = collectionView.makeSupplementaryView(ofKind: .globalHeader, withIdentifier: .searchCell, for: indexPath) as! SearchCell
        header.searchHandler = { [weak self] in self?.searchQuery = $0 }
        return header
    }
    
    public func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        let existingSMS = self.selection.first?.locations.contains("OffNetworkPhone") ?? false
        let ret = indexPaths.filter { $0.section != 0 } // can't select from the selection group
        return ret.filter { // can't mix'n'match SMS + Hangouts
            let newSMS = self.currentSource()[$0.item].locations.contains("OffNetworkPhone")
            return (existingSMS && newSMS) || (!existingSMS && !newSMS) // either both are SMS or both are NOT
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, shouldDeselectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return indexPaths.filter { $0.section == 0 } // can't deselect from the currentSource group
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        self.editSelection {
            let indexPaths = indexPaths.filter { $0.section != 0 } // can't select from the selection group
            self.selection.append(contentsOf: (indexPaths.map { self.currentSource()[$0.item] }))
            //self.selection = indexPaths.map { self.currentSource()[$0.item] }
            self.updateStatus()
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        self.editSelection {
            let indexPaths = indexPaths.filter { $0.section == 0 }.map { $0.item }.reversed() // can't deselect from the currentSource group
            for idx in indexPaths { self.selection.remove(at: idx) }
            self.updateStatus()
        }
    }
    
    private func editSelection(_ handler: () -> ()) {
        // Cache the previous dataSource arrangement.
        let oldSelectionVal = self.selection.map { $0.identifier }
        let oldSourceVal = self.currentSource().map { $0.identifier }
        
        handler()
        
        // Create an update list from the new dataSource arrangement.
        let newSelectionVal = self.selection.map { $0.identifier }
        let newSourceVal = self.currentSource().map { $0.identifier }
        
        let selectionUpdates = Changeset.edits(from: oldSelectionVal, to: newSelectionVal)
        let sourceUpdates = Changeset.edits(from: oldSourceVal, to: newSourceVal)
        UI {
            self.collectionView.update(with: selectionUpdates, in: 0) {_ in}
            self.collectionView.update(with: sourceUpdates, in: 1) {_ in}
            
            // Since we can't do cross-section moves with Changeset, and selection is reset:
            let selectionSet = self.selection.enumerated().map { IndexPath(item: $0.offset, section: 0) }
            let sourceSet = self.currentSource().enumerated().map { IndexPath(item: $0.offset, section: 1) }
            self.collectionView.animator().reloadItems(at: Set(selectionSet + sourceSet))
            self.collectionView.animator().selectionIndexPaths = Set(selectionSet)
        }
    }
    
    private func updateStatus() {
        if self.selection.count > 1 {
            let sms = self.selection.first?.locations.contains("OffNetworkPhone") ?? false
            self.statusText.stringValue = "New group \(sms ? "SMS " : "")conversation..."
            self.statusButton.title = "Create"
        } else if self.selection.count == 1 {
            let sms = self.selection.first?.locations.contains("OffNetworkPhone") ?? false
            self.statusText.stringValue = "New \(sms ? "SMS " : "")conversation..."
            self.statusButton.title = "Create"
        } else {
            self.statusText.stringValue = "Create..."
            self.statusButton.title = "Cancel"
        }
    }
}
