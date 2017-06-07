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
ListViewDataDelegate, ListViewSelectionDelegate, ListViewScrollbackDelegate {
	
    private lazy var listView: ListView = {
        let v = ListView().modernize(wantsLayer: true)
        v.flowDirection = .top
        v.selectionType = .any
        v.delegate = self
        v.insets = EdgeInsets(top: 84.0, left: 0, bottom: 0, right: 0)
        return v
    }()
    
    private lazy var indicator: MessageProgressView = {
        let v = MessageProgressView().modernize()
        return v
    }()
    
    private lazy var titleText: NSTextField = {
        let t = NSTextField(labelWithString: " Conversations").modernize()
        t.textColor = NSColor.labelColor
        t.font = NSFont.systemFont(ofSize: 32.0, weight: NSFontWeightHeavy)
        /*
        let img = NSImage(named: NSImageNameAddTemplate)!
        let v = NSButton(title: "", image: img, target: nil, action: nil)
        t.addSubview(v)
        t.right == v.right - 8.0
        t.centerY == v.centerY
        */
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
                self?.indicator.stopAnimation()
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
    
	var conversationList: ConversationList? {
		didSet {
            self.listView.update(animated: false) {
                self.updateInterpolation.animate(duration: 1.5)
            }
		}
	}
	
    // FIXME: this is recomputed A LOT! bad idea...
    var sortedConversations: [Conversation] {
		guard self.conversationList != nil else { return [] }
        return self.conversationList!.conversations.values
            .filter { !$0.archived }
            .sorted { $0.timestamp > $1.timestamp }
	}
    
    public func numberOfItems(in: ListView) -> [UInt] {
        return [UInt(self.sortedConversations.count)]
    }
    
    public func object(in: ListView, at: ListView.Index) -> Any? {
        return self.sortedConversations[Int(at.item)]
    }
    
    public func itemClass(in: ListView, at: ListView.Index) -> NSView.Type {
        return ConversationCell.self
    }
    
    public func cellHeight(in view: ListView, at: ListView.Index) -> Double {
        return 48.0 + 16.0 /* padding */
    }
    
    public func proposedSelection(in list: ListView, at: [ListView.Index]) -> [ListView.Index] {
        return list.selection + at // Only additive!
    }
    
    public func selectionChanged(in: ListView, is selection: [ListView.Index]) {
        let src = self.sortedConversations
        let dest = Set(MessageListViewController.openConversations.keys)
        let convs = Set(selection.map { src[Int($0.item)].identifier })
        
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
    
    public func reachedEdge(in: ListView, edge: NSRectEdge) {
        func scrollback() {
            guard self.updateToken == false else { return }
            let _ = self.conversationList?.syncConversations(count: 25, since: self.conversationList!.syncTimestamp) { val in
                DispatchQueue.main.async {
                    self.listView.tableView.noteNumberOfRowsChanged()
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
        window.enableRealTitlebarVibrancy(.withinWindow)
        window.titleVisibility = .hidden
        _ = window.installToolbar()
        window.toolbar?.showsBaselineSeparator = false
        
        let t = NSTitlebarAccessoryViewController()
        t.view = self.titleText
        t.view.frame.size.height = 48.0
        t.layoutAttribute = .bottom
        window.addTitlebarAccessoryViewController(t)
    }
    
    public override func viewDidLoad() {
        self.childrenSub = AutoSubscription(kind: .OpenConversationsUpdated) { _ in
            log.debug("Updating childConversations... \(Array(MessageListViewController.openConversations.keys))")
            self.updateSelectionIndexes()
        }
        
        NotificationCenter.default.addObserver(forName: ServiceRegistry.didAddService, object: nil, queue: nil) { note in
            guard let c = note.object as? Service else { return }
            self.conversationList = c.conversations
            
            DispatchQueue.main.async {
                self.title = c.directory.me.fullName
                //self.imageView.layer?.masksToBounds = true
                //self.imageView.layer?.cornerRadius = self.imageView.bounds.width / 2
                //self.imageView.image = fetchImage(user: c.directory.me, monogram: true)
                
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
        }
    }
	
    //
    //
    //
    
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
    }
    
    private func updateSelectionIndexes() {
        let paths = Array(MessageListViewController.openConversations.keys)
            .flatMap { id in self.sortedConversations.index { $0.identifier == id } }
            .map { (section: UInt(0), item: UInt($0)) }
        self.listView.selection = paths
    }
}
