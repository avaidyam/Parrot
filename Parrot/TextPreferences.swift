import MochaUI

public extension Preferences.Controllers {
    public class Text: PreferencePaneViewController, NSTableViewDelegate {
        
        private lazy var tableMenu: NSMenu = {
            return NSMenu()
        }()
        
        private lazy var dictionaryController: NSDictionaryController = {
            let c = NSDictionaryController(content: [:])
            c.preservesSelection = true
            c.selectsInsertedObjects = true
            c.clearsFilterPredicateOnInsertion = true
            c.automaticallyPreparesContent = true
            c.isEditable = true
            //c.bind(.contentDictionary, to: NSUserDefaultsController.shared,
            //       withKeyPath: "completions", options: nil)
            return c
        }()
        
        private lazy var textCompletions: NSTableView = {
            let v = NSTableView(frame: .zero)//.modernize()
            v.delegate = self
            
            // Table Setup
            let c1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Left"))
            c1.headerCell.title = "Left"
            v.addTableColumn(c1)
            let c2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Right"))
            c2.headerCell.title = "Right"
            v.addTableColumn(c2)
            
            // Bindings
            v.bind(.content, to: self.dictionaryController,
                   withKeyPath: "arrangedObjects", options: nil)
            v.bind(.sortDescriptors, to: self.dictionaryController,
                   withKeyPath: "sortDescriptors", options: nil)
            v.bind(.selectionIndexes, to: self.dictionaryController,
                   withKeyPath: "selectionIndexes", options: nil)
            return v
        }()
        
        private lazy var addButton: NSButton = {
            let b = NSButton(checkboxWithTitle: "Automatically convert emoji",
                            target: nil, action: nil).setupForBindings()
            b.bind(.enabled, to: self.dictionaryController,
                   withKeyPath: "isEditable", options: nil)
            b.bind(.enabled, to: self.dictionaryController,
                   withKeyPath: "canAdd", options: nil)
            return b
        }()
        
        private lazy var removeButton: NSButton = {
            let b = NSButton(checkboxWithTitle: "Automatically convert emoji",
                            target: nil, action: nil).setupForBindings()
            b.bind(.enabled, to: self.dictionaryController,
                   withKeyPath: "isEditable", options: nil)
            b.bind(.enabled, to: self.dictionaryController,
                   withKeyPath: "canAdd", options: nil)
            return b
        }()
        
        private lazy var spacerButton: NSButton = {
            let b = NSButton(checkboxWithTitle: "Automatically convert emoji",
                            target: nil, action: nil).setupForBindings()
            b.bind(.enabled, to: self.dictionaryController,
                   withKeyPath: "isEditable", options: nil)
            b.bind(.enabled, to: self.dictionaryController,
                   withKeyPath: "canAdd", options: nil)
            return b
        }()
        
        public override func loadView() {
            self.view = self.textCompletions
            self.view.widthAnchor == 400.0
            self.view.heightAnchor == 400.0
            self.title = "Text"
            self.image = NSImage(named: .advanced)
        }
        
        public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
            return 32.0
        }
        
        public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            if let c = tableColumn, c.identifier.rawValue == "Left" {
                return NSTableCellView(frame: .zero)
            } else if let c = tableColumn, c.identifier.rawValue == "Right" {
                return NSTableCellView(frame: .zero)
            } else {
                return nil
            }
        }
    }
}

