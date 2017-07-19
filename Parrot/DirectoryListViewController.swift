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
        
        let l = NSCollectionViewListLayout()
        l.layoutDefinition = .global(SizeMetrics(item: CGSize(width: 0, height: 48)))
        c.collectionViewLayout = l
        c.register(PersonCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(PersonCell.self)"))
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
    
    private lazy var searchField: NSSearchField = {
        let s = NSSearchField().modernize(wantsLayer: true)
        s.disableToolbarLook()
        s.performedAction = {
            self.searchQuery = s.stringValue
        }
        return s
    }()
    
    private lazy var titleAccessory: NSTitlebarAccessoryViewController = {
        let v = NSView()
        v.add(subviews: [self.titleText])
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
    
    private lazy var updateInterpolation: Interpolate = {
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
        let group = Interpolate.group(indicatorAnim, scaleAnim)
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
            UI {
                self.collectionView.reloadData()
                //self.collectionView.animator().scrollToItems(at: [IndexPath(item: 0, section: 0)],
                //                                             scrollPosition: [.centeredHorizontally, .nearestVerticalEdge])
                self.updateInterpolation.animate(duration: 1.5)
            }
            self.cachedFavorites = self.directory?.list(200) ?? []//.search(by: "Test", limit: 200) ?? []
        }
    }
    
    // We should be able to now edit things.
    public var selectable = false {
        didSet {
            self.collectionView.isSelectable = self.selectable
            self.collectionView.allowsMultipleSelection = self.selectable
        }
    }
    
    public private(set) var selection: [Person] = []
    
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
        window.addTitlebarAccessoryViewController(self.searchAccessory)
        
        /// Re-synchronizes the conversation name and identifier with the window.
        /// Center by default, but load a saved frame if available, and autosave.
        window.center()
        window.setFrameUsingName(NSWindow.FrameAutosaveName(rawValue: "Directory"))
        window.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: "Directory"))
    }
    
    public override func viewDidLoad() {
        if let service = ServiceRegistry.services.values.first {
            self.directory = service.directory
        }
        NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
            self.directory = c.directory
            UI {
                self.title = c.directory.me.fullName
                self.collectionView.reloadData()
            }
        }
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
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "\(PersonCell.self)"), for: indexPath)
        item.representedObject = self.currentSource()[indexPath.item]
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        self.selection.append(contentsOf: indexPaths.map { self.currentSource()[$0.item] })
        print(self.selection, self.collectionView.selectionIndexPaths)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        for a in (indexPaths.map { self.currentSource()[$0.item] }) {
            let idx = self.selection.index { $0.identifier == a.identifier }
            self.selection.remove(at: idx!)
        }
        print(self.selection, self.collectionView.selectionIndexPaths)
    }
}
