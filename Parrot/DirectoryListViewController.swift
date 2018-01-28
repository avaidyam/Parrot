import Foundation
import AppKit
import Mocha
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
        
        let l = NSCollectionViewFlowLayout()//NSCollectionViewListLayout()
        //l.globalSections = (32, 0)
        //l.layoutDefinition = .global(SizeMetrics(item: CGSize(width: 0, height: 48)))
        l.minimumInteritemSpacing = 0.0
        l.minimumLineSpacing = 0.0
        c.collectionViewLayout = l
        c.register(PersonCell.self,
                   forItemWithIdentifier: .personCell)
        c.register(SearchCell.self, forSupplementaryViewOfKind: .sectionHeader,
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
        let t = NSTextField(labelWithString: " Directory").modernize(wantsLayer: true)
        t.textColor = NSColor.labelColor
        t.font = NSFont.systemFont(ofSize: 32.0, weight: .heavy)
        return t
    }()
    
    private lazy var titleAccessory: NSTitlebarAccessoryViewController = {
        let v = NSView()
        v.add(subviews: self.titleText)
        v.autoresizingMask = [.width]
        v.frame.size.height = 44.0//80.0
        self.titleText.leftAnchor == v.leftAnchor + 2.0
        self.titleText.topAnchor == v.topAnchor + 2.0
        let t = NSTitlebarAccessoryViewController()
        t.view = v
        t.layoutAttribute = .bottom
        return t
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
    
    private var cachedFavorites: [Person] = []
    private var currentSearch: [Person]? = nil
    private var searchQuery: String = "" { // TODO: BINDING HERE
        didSet {
            self.currentSearch = self.searchQuery == "" ? nil :
                self.directory?.search(by: self.searchQuery, limit: 25)
            self.collectionView.reloadData()
        }
    }
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
    
    // We should be able to now edit things.
    public var selectable = false {
        didSet {
            self.collectionView.isSelectable = self.selectable
            //self.collectionView.allowsMultipleSelection = self.selectable
        }
    }
    
    public private(set) var selection: [Person] = []
    public var selectionHandler: (() -> ())? = nil
    
    //
    //
    //
    
    public override func loadView() {
        self.title = "Directory"
        self.view = NSVisualEffectView()
        self.view.add(subviews: self.scrollView, self.indicator)
        
        self.view.widthAnchor >= 128
        self.view.heightAnchor >= 128
        self.view.centerXAnchor == self.indicator.centerXAnchor
        self.view.centerYAnchor == self.indicator.centerYAnchor
        self.view.centerXAnchor == self.scrollView.centerXAnchor
        self.view.centerYAnchor == self.scrollView.centerYAnchor
        self.view.widthAnchor == self.scrollView.widthAnchor
        self.view.heightAnchor == self.scrollView.heightAnchor
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
            UI {
                self.collectionView.reloadData()
            }
        }
        GoogleAnalytics.view(screen: .conversation)
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
    
    ///
    ///
    ///
    
    // account for [selection] too
    private func currentSource() -> [Person] {
        return self.currentSearch != nil ? self.currentSearch! : self.cachedFavorites
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentSource().count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .personCell, for: indexPath)
        item.representedObject = self.currentSource()[indexPath.item]
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let header = collectionView.makeSupplementaryView(ofKind: .sectionHeader, withIdentifier: .searchCell, for: indexPath) as! SearchCell
        header.searchHandler = {
            self.searchQuery = $0
        }
        return header
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 48.0)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 32.0)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        //self.selection.append(contentsOf: indexPaths.map { self.currentSource()[$0.item] })
        self.selection = indexPaths.map { self.currentSource()[$0.item] }
        self.selectionHandler?()
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        /*for a in (indexPaths.map { self.currentSource()[$0.item] }) {
            let idx = self.selection.index { $0.identifier == a.identifier }
            self.selection.remove(at: idx!)
        }*/
        
        self.selectionHandler?()
    }
}
