import Foundation
import AppKit
import Mocha
import MochaUI
import ParrotServiceExtension

/* TODO: UISearchController for NSViewControllers. */

public class DirectoryListViewController: NSViewController, WindowPresentable, ListViewDataDelegate {
    
    private lazy var listView: ListView = {
        let v = ListView().modernize(wantsLayer: true)
        v.flowDirection = .top
        v.selectionType = .any
        v.delegate = self
        v.insets = EdgeInsets(top: 36.0, left: 0, bottom: 0, right: 0)
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
        let b = NSButton(title: "", image: NSImage(named: NSImageNameAddTemplate)!,
                         target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        return b
    }()
    
    private lazy var titleAccessory: NSTitlebarAccessoryViewController = {
        let v = NSView()
        v.add(subviews: [self.titleText, self.addButton/*, self.searchField*/])
        v.autoresizingMask = [.viewWidthSizable]
        v.frame.size.height = 48.0//80.0
        
        self.titleText.left == v.left + 2.0
        self.titleText.top == v.top + 2.0
        self.titleText.right <= self.addButton.left - 8.0
        self.addButton.centerY == self.titleText.centerY + 2.0
        self.addButton.right == v.right - 8.0
        self.addButton.height == 22.0
        self.addButton.width == 22.0
        
        //self.titleText.bottom == self.searchField.top - 8.0
        //self.addButton.bottom == self.titleText.bottom
        
        /*
         self.searchField.height == 22.0
         self.searchField.left == v.left + 8.0
         self.searchField.right == v.right - 8.0
         self.searchField.bottom == v.bottom - 8.0
         */
        
        let t = NSTitlebarAccessoryViewController()
        t.view = v
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
        return group
    }()
    
    //
    //
    //
    
    var directory: ParrotServiceExtension.Directory? {
        didSet {
            self.listView.update(animated: false) {
                self.updateInterpolation.animate(duration: 1.5)
            }
        }
    }
    
    public func numberOfItems(in: ListView) -> [UInt] {
        return [UInt(self.directory?.people.count ?? 0)]
    }
    
    public func object(in: ListView, at: ListView.Index) -> Any? {
        let t = Array(self.directory!.people.values)[Int(at.item)]
        return t
    }
    
    public func itemClass(in: ListView, at: ListView.Index) -> NSView.Type {
        return PersonCell.self
    }
    
    public func cellHeight(in view: ListView, at: ListView.Index) -> Double {
        return 32.0 + 16.0 /* padding */
    }
    
    //
    //
    //
    
    public override func loadView() {
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
    }
    
    public func prepare(window: NSWindow) {
        window.styleMask = [window.styleMask, .unifiedTitleAndToolbar, .fullSizeContentView]
        window.appearance = ParrotAppearance.interfaceStyle().appearance()
        window.enableRealTitlebarVibrancy(.withinWindow)
        window.titleVisibility = .hidden
        let container = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        window.addTitlebarAccessoryViewController(self.titleAccessory)
        
        /*
        let item = NSToolbarItem(itemIdentifier: "search")
        let s = NSSearchField()
        item.view = s
        item.label = "Search"
        container.templateItems = [item]
        container.itemOrder = [NSToolbarFlexibleSpaceItemIdentifier, "search", NSToolbarFlexibleSpaceItemIdentifier]
        */
    }
    
    public override func viewDidLoad() {
        if let service = ServiceRegistry.services.values.first {
            self.directory = service.directory
        }
        NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
            self.directory = c.directory
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
}
