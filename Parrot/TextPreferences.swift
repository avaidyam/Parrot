import MochaUI

public extension Preferences.Controllers {
    public class Text: PreferencePaneViewController {
        
        private lazy var tableMenu: NSMenu = {
            return NSMenu()
        }()
        
        private lazy var dictionaryController: NSDictionaryController = {
            let dc = NSDictionaryController(content: nil)
            dc.automaticallyPreparesContent = true
            dc.bind(.content, to: NSUserDefaultsController.shared,
                    withKeyPath: "values.completions", options: nil)
            return dc
        }()
        
        private lazy var textCompletions: NSTableView = {
            let v = NSTableView(frame: .zero).modernize()
            v.allowsColumnResizing = false
            v.allowsColumnReordering = false
            v.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
            
            // Table Setup
            let c1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Key"))
            c1.headerCell.title = "Left"
            v.addTableColumn(c1)
            let c2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Value"))
            c2.headerCell.title = "Right"
            v.addTableColumn(c2)
            return v
        }()
        
        private lazy var addButton: NSButton = {
            let b = NSButton(checkboxWithTitle: "Automatically convert emoji",
                            target: nil, action: nil).setupForBindings()
            return b
        }()
        
        private lazy var removeButton: NSButton = {
            let b = NSButton(checkboxWithTitle: "Automatically convert emoji",
                            target: nil, action: nil).setupForBindings()
            return b
        }()
        
        private lazy var spacerButton: NSButton = {
            let b = NSButton(checkboxWithTitle: "Automatically convert emoji",
                            target: nil, action: nil).setupForBindings()
            return b
        }()
        
        public override func loadView() {
            self.view = NSScrollView(for: self.textCompletions)
            self.view.widthAnchor == 400.0
            self.view.heightAnchor == 400.0
            self.title = "Text"
            self.image = NSImage(named: .advanced)
            
            self.textCompletions.dataSource = self.dictionaryController
            self.textCompletions.delegate = self.dictionaryController
        }
    }
}

extension NSDictionaryController: NSTableViewDelegate, NSTableViewDataSource {
    private var contents: [NSDictionaryControllerKeyValuePair] {
        return (self.arrangedObjects as! [NSDictionaryControllerKeyValuePair])
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.contents.count
    }
    
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if let c = tableColumn, c.identifier.rawValue == "Key" {
            return self.contents[row].key
        } else if let c = tableColumn, c.identifier.rawValue == "Value" {
            return self.contents[row].value
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        if let c = tableColumn, c.identifier.rawValue == "Key" {
            self.contents[row].key = object == nil ? nil : "\(object!)"
        } else if let c = tableColumn, c.identifier.rawValue == "Value" {
            self.contents[row].value = object
        } else {
            //
        }
    }
    
    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return self.isEditable
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        self.setSelectionIndexes((notification.object as! NSTableView).selectedRowIndexes)
    }
}

