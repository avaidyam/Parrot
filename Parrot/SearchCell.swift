import Cocoa
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
        let b = NSButton(title: "", image: #imageLiteral(resourceName: "Compose"), target: nil, action: nil).modernize()
        b.bezelStyle = .texturedRounded
        b.imagePosition = .imageOnly
        b.performedAction = { [weak self] in
            self?.addHandler()
        }
        return b
    }()
    
    public var searchHandler: (String) -> () = {_ in}
    public var sortHandler: (Int) -> () = {_ in}
    public var addHandler: () -> () = {}
    
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
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.add(subviews: self.searchField, self.addButton)
        
        self.addButton.width == self.addButton.height + 4.0
        self.top == self.searchField.top - 5.0
        self.bottom == self.searchField.bottom + 5.0
        self.addButton.top == self.searchField.top
        self.addButton.bottom == self.searchField.bottom
        self.left == self.searchField.left - 5.0
        self.right == self.addButton.right + 5.0
        self.searchField.right == self.addButton.left - 5.0
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

