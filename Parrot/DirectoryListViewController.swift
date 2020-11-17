<<<<<<< Updated upstream
=======
import Foundation
import AppKit
import Mocha
>>>>>>> Stashed changes
import MochaUI
import ParrotServiceExtension

/* TODO: UISearchController for NSViewControllers. */

<<<<<<< Updated upstream
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
        b.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        b.bezelStyle = .roundRect // height = 18px
        return b
    }()
    
    private lazy var baseView: NSVisualEffectView = {
        let v = NSVisualEffectView().modernize()
        v.blendingMode = .withinWindow
        v.material = .sidebar
        v.state = .active
        v.isHidden = true // initial state
        v.add(subviews: self.statusText, self.statusButton) {
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
=======
public class DirectoryListViewController: NSViewController, WindowPresentable, ListViewDataDelegate2 {
    
    private lazy var listView: ListView2 = {
        let v = ListView2().modernize(wantsLayer: true)
        v.flowDirection = .top
        v.selectionType = .any
        v.delegate = self
        v.scrollView.automaticallyAdjustsContentInsets = true
        v.collectionView.register(PersonCell.self, forItemWithIdentifier: "\(PersonCell.self)")
        //v.insets = EdgeInsets(top: 114.0, left: 0, bottom: 0, right: 0)
        return v
    }()
    
    private lazy var indicator: MessageProgressView = {
        let v = MessageProgressView().modernize(wantsLayer: true)
        return v
    }()
    
    private lazy var titleText: NSTextField = {
        let t = NSTextField(labelWithString: " Directory").modernize(wantsLayer: true)
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
        v.add(subviews: [self.titleText, self.addButton/*, self.searchField*/])
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
    
    private lazy var updateInterpolation: Interpolate = {
        let indicatorAnim = Interpolate(from: 0.0, to: 1.0, interpolator: EaseInOutInterpolator()) { [weak self] alpha in
            self?.listView.alphaValue = CGFloat(alpha)
            self?.indicator.alphaValue = CGFloat(1.0 - alpha)
        }
        indicatorAnim.add(at: 1.0) {
            DispatchQueue.main.async {
                self.indicator.stopAnimation()
            }
        }
        indicatorAnim.handlerRunPolicy = .always
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
    
    var directory: ParrotServiceExtension.Directory? {
        didSet {
<<<<<<< Updated upstream
            DispatchQueue.global(qos: .background).async {
                self.cachedFavorites = self.directory?.list(25) ?? []
                UI {
                    self.collectionView.reloadData()
                    //self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                    //                                             scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
                    self.updateInterpolation.animate(duration: 1.5)
                }
=======
            self.listView.update(animated: false) {
                self.updateInterpolation.animate(duration: 1.5)
>>>>>>> Stashed changes
            }
        }
    }
    
<<<<<<< Updated upstream
    public var displaysCloseOptions = false {
        didSet {
            self.scrollView.contentInsets = NSEdgeInsetsMake(0, 0, self.displaysCloseOptions ? 32 : 0, 0)
            self.baseView.isHidden = !self.displaysCloseOptions
        }
    }
    
    // We should be able to now edit things.
    public var canSelect: Bool = false {
        didSet {
            self.collectionView.selectionType = self.canSelect ? .any : .none
            //self.collectionView.allowsMultipleSelection = self.canSelect
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
=======
    public func numberOfItems(in: ListView2) -> [UInt] {
        return [UInt(self.directory?.people.count ?? 0)]
    }
    
    public func object(in: ListView2, at: ListView2.Index) -> Any? {
        let t = Array(self.directory!.people.values)[Int(at.item)]
        return t
    }
    
    public func itemClass(in: ListView2, at: ListView2.Index) -> NSCollectionViewItem.Type {
        return PersonCell.self
    }
    
    public func cellHeight(in view: ListView2, at: ListView2.Index) -> Double {
        return 32.0 + 16.0 /* padding */
>>>>>>> Stashed changes
    }
    
    //
    //
    //
    
    public override func loadView() {
<<<<<<< Updated upstream
        self.title = "Directory"
        self.view = NSVisualEffectView()
        self.view.add(subviews: self.scrollView, self.baseView, self.indicator) {
            self.view.sizeAnchors >= CGSize(width: 128, height: 128)
            self.view.centerAnchors == self.indicator.centerAnchors
            self.view.edgeAnchors == self.scrollView.edgeAnchors
            self.view.bottomAnchor == self.baseView.bottomAnchor
            self.view.horizontalAnchors == self.baseView.horizontalAnchors
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
    }
    
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .unifiedTitleAndToolbar, .fullSizeContentView]
<<<<<<< Updated upstream
        window.appearance = InterfaceStyle.current.appearance()
        if let vev = window.titlebar.view as? NSVisualEffectView {
            vev.material = .appearanceBased
            vev.state = .active
            vev.blendingMode = .withinWindow
        }
        window.titleVisibility = .hidden
        window.installToolbar(self)
        window.addTitlebarAccessoryViewController(LargeTypeTitleController(title: self.title))
        
        /// Re-synchronizes the conversation name and identifier with the window.
        /// Center by default, but load a saved frame if available, and autosave.
        window.center()
        window.setFrameUsingName(NSWindow.FrameAutosaveName(rawValue: self.title!))
        window.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: self.title!))
    }
    
    /*
    public override func makeToolbarContainer() -> ToolbarContainer? {
        let t = ToolbarContainer()
        t.templateItems = [.windowTitle(viewController: self)]
        t.itemOrder = [.windowTitle]
        return t
    }
    */
=======
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
>>>>>>> Stashed changes
    
    public override func viewDidLoad() {
        if let service = ServiceRegistry.services.values.first {
            self.directory = service.directory
        }
        NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
            self.directory = c.directory
<<<<<<< Updated upstream
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
        
        self.visualSubscriptions = [
            Settings.observe(\.effectiveInterfaceStyle, options: [.initial, .new]) { _, change in
                self.view.window?.crossfade()
                self.view.window?.appearance = InterfaceStyle.current.appearance()
            },
            Settings.observe(\.vibrancyStyle, options: [.initial, .new]) { _, change in
                (self.view as? NSVisualEffectView)?.state = VibrancyStyle.current.state()
            },
        ]
    }
    private var visualSubscriptions: [NSKeyValueObservation] = []
    
    /// If we need to close, make sure we clean up after ourselves, instead of deinit.
    public override func viewWillDisappear() {
        self.visualSubscriptions = []
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
=======
            DispatchQueue.main.async {
                self.title = c.directory.me.fullName
                self.listView.update()
            }
        }
    }
    
    public override func viewWillAppear() {
        syncAutosaveTitle()
        PopWindowAnimator.show(self.view.window!)
        
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
        self.view.window?.setFrameUsingName("Directory")
        self.view.window?.setFrameAutosaveName("Directory")
    }
    
    @objc private func toggleSearchField(_ sender: NSButton!) {
        self.searchAccessory.animator().isHidden = (sender.state != NSControlStateValueOn)
>>>>>>> Stashed changes
    }
}
