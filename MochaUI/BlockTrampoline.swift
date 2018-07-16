import AppKit
import Mocha

public protocol BlockTrampolineSupporting: NSObjectProtocol {
    /*weak*/ var target: AnyObject? { get set }
    var action: Selector? { get set }
}
extension NSControl: BlockTrampolineSupporting {}
extension NSMenuItem: BlockTrampolineSupporting {}

public extension BlockTrampolineSupporting {
    var performedAction: (() -> ())? {
        get {
            guard let trampoline = BlockTrampoline.handlerProp[self] else { return nil }
            return trampoline.action
        }
        set {
            if let trampoline = BlockTrampoline.handlerProp[self], let update = newValue {
                trampoline.action = update
            } else if let update = newValue {
                let trampoline = BlockTrampoline(action: update)
                BlockTrampoline.handlerProp[self] = trampoline
                
                self.target = trampoline
                self.action = #selector(BlockTrampoline.performAction(_:))
            } else {
                BlockTrampoline.handlerProp[self] = nil
                
                self.target = nil
                self.action = nil
            }
        }
    }
}

//
//
//

public extension NSMenu {
    
    @discardableResult
    public func addItem(title: String, keyEquivalent: String = "", handler: @escaping () -> ()) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: keyEquivalent)
        item.performedAction = handler
        self.addItem(item)
        return item
    }
}

public extension NSMenuItem {
    
    public convenience init(title: String, isEnabled: Bool = true, target: AnyObject? = nil, action: String? = nil, keyEquivalent: String = "", modifierMask: NSEvent.ModifierFlags = [], _ submenuItems: [NSMenuItem]? = nil) {
        self.init(title: title, action: action != nil ? Selector(action!) : nil, keyEquivalent: keyEquivalent)
        self.isEnabled = isEnabled
        self.target = target
        self.keyEquivalentModifierMask = modifierMask
        
        if let submenuItems = submenuItems {
            let m = NSMenu(title: title)
            for x in submenuItems {
                m.addItem(x)
            }
            self.submenu = m
        }
    }
}

//
//
//

@objc fileprivate class BlockTrampoline: NSObject {
    fileprivate typealias Action = () -> ()
    
    fileprivate fileprivate(set) var action: Action
    
    fileprivate init(action: @escaping Action) {
        self.action = action
    }
    
    @objc dynamic fileprivate func performAction(_ sender: Any!) {
        self.action()
    }
    
    fileprivate static var handlerProp = AssociatedProperty<BlockTrampolineSupporting, BlockTrampoline>(.strong)
}
