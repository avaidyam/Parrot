import MochaUI

public class SearchCell: NSView {
    
    private static let sortTag = 104402048273 // ??? why even
    
    private lazy var recentsMenu: NSMenu = {
        let recentsMenu = NSMenu(title: "Recents")
        
        let sort = recentsMenu.addItem(withTitle: "Sort By", action: nil, keyEquivalent: "")
        sort.tag = SearchCell.sortTag
        recentsMenu.addItem(NSMenuItem.separator())
        
        let title = recentsMenu.addItem(withTitle: "Recent Searches", action: nil, keyEquivalent: "")
        title.tag = NSSearchField.recentsTitleMenuItemTag
        
        let recents = recentsMenu.addItem(withTitle: "", action: nil, keyEquivalent: "")
        recents.tag = NSSearchField.recentsMenuItemTag
        
        recentsMenu.addItem(NSMenuItem.separator())
        
        let none = recentsMenu.addItem(withTitle: "No Recents", action: nil, keyEquivalent: "")
        none.tag = NSSearchField.noRecentsMenuItemTag
        
        let clear = recentsMenu.addItem(withTitle: "Clear Recents", action: nil, keyEquivalent: "")
        clear.tag = NSSearchField.clearRecentsMenuItemTag
        
        return recentsMenu
    }()
    
    private lazy var searchField: NSSearchField = {
        let s = NSSearchField().modernize(wantsLayer: true)
        s.disableToolbarLook()
        s.searchMenuTemplate = self.recentsMenu
        s.performedAction = { [weak self] in
            self?.searchHandler(s.stringValue)
        }
        return s
    }()
    
    private lazy var addButton: NSButton = {
        let b = LayerButton(title: "", image: #imageLiteral(resourceName: "Compose"), target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.isHidden = true // initial state
        b.performedAction = { [weak self] in
            self?.addHandler?()
        }
        return b
    }()
    
    public var searchHandler: (String) -> () = {_ in}
    public var sortHandler: (Int) -> () = {_ in}
    public var addHandler: (() -> ())? = nil {
        didSet {
            self.addButton.isHidden = self.addHandler == nil
            if self.addHandler != nil {
                self.right_addAnchor.animator().isActive = true
                self.right_viewAnchor.animator().isActive = false
            } else {
                self.right_addAnchor.animator().isActive = false
                self.right_viewAnchor.animator().isActive = true
            }
        }
    }
    
    public var sortOptions: [String] = [] {
        didSet {
            self.sortSelectedIndex = -1
            
            if let item = self.recentsMenu.item(withTag: SearchCell.sortTag) {
                item.isEnabled = true
                let m = NSMenu(title: "Sort By")
                for (idx, val) in self.sortOptions.enumerated() {
                    m.addItem(title: val) { [weak self] in self?.sortSelectedIndex = idx }
                }
                item.submenu = m
            }
        }
    }
    public var sortSelectedIndex: Int = -1 {
        didSet {
            guard self.sortSelectedIndex >= 0 else { return }
            self.sortHandler(self.sortSelectedIndex)
        }
    }
    
    private var right_addAnchor: NSLayoutConstraint! = nil
    private var right_viewAnchor: NSLayoutConstraint! = nil
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    private func setup() {
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.add(subviews: self.searchField, self.addButton)
        batch {
            self.addButton.widthAnchor == self.addButton.heightAnchor + 4.0
            self.verticalAnchors == self.searchField.verticalAnchors - 5.0
            self.verticalAnchors == self.addButton.verticalAnchors - 5.0
            
            self.leftAnchor == self.searchField.leftAnchor - 5.0
            self.rightAnchor == self.addButton.rightAnchor + 5.0
        }
        self.right_addAnchor = batch(active: false) {
            self.searchField.rightAnchor == self.addButton.leftAnchor - 5.0
        }.first!
        self.right_viewAnchor = batch(active: true) {
            self.searchField.rightAnchor == self.rightAnchor - 5.0
        }.first!
    }
    
    public override var allowsVibrancy: Bool { return true }
    public override var wantsUpdateLayer: Bool { return true }
    public override func updateLayer() {
        //self.layer!.backgroundColor = NSColor.white.withAlphaComponent(0.2).cgColor
    }
    
    public override func prepareForReuse() {
        //self.handler = {_ in}
    }
}

