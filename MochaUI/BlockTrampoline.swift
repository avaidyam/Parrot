import Cocoa
import Mocha

public protocol BlockTrampolineSupporting: NSObjectProtocol {
    weak var target: AnyObject? { get set }
    var action: Selector? { get set }
}
extension NSControl: BlockTrampolineSupporting {}
extension NSMenuItem: BlockTrampolineSupporting {}

public extension BlockTrampolineSupporting {
    var handler: (() -> ())? {
        get {
            guard let trampoline = BlockTrampolineSupporting_handlerProp.get(self) else { return nil }
            return trampoline.action
        }
        set {
            if let trampoline = BlockTrampolineSupporting_handlerProp.get(self), let update = newValue {
                trampoline.action = update
            } else if let update = newValue {
                let trampoline = BlockTrampoline(action: update)
                BlockTrampolineSupporting_handlerProp.set(self, value: trampoline)
                
                self.target = trampoline
                self.action = #selector(BlockTrampoline.performAction(_:))
            } else {
                BlockTrampolineSupporting_handlerProp.set(self, value: nil)
                
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
        item.handler = handler
        self.addItem(item)
        return item
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
    
    @objc fileprivate func performAction(_ sender: Any!) {
        self.action()
    }
}
fileprivate var BlockTrampolineSupporting_handlerProp = AssociatedProperty<BlockTrampolineSupporting, BlockTrampoline>(.strong)
