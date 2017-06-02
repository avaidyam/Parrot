import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts
import ParrotServiceExtension
import protocol ParrotServiceExtension.Conversation

public class DirectoryListViewController: NSViewController, WindowPresentable, ListViewDataDelegate {
    
    private lazy var listView: ListView = {
        let v = ListView().modernize()
        v.flowDirection = .top
        v.selectionType = .any
        v.delegate = self
        v.insets = EdgeInsets(top: 36.0, left: 0, bottom: 0, right: 0)
        return v
    }()
    
    private lazy var indicator: MessageProgressView = {
        let v = MessageProgressView().modernize()
        return v
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
        return 48.0 + 16.0 /* padding */
    }
    
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
        
        let item = NSToolbarItem(itemIdentifier: "search")
        let s = NSSearchField()
        item.view = s
        item.label = "Search"
        container.templateItems = [item]
        container.itemOrder = [NSToolbarFlexibleSpaceItemIdentifier, "search", NSToolbarFlexibleSpaceItemIdentifier]
    }
    
    public override func viewDidLoad() {
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
