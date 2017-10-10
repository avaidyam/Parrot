import Foundation
import XPC

/// An XPC transaction acts as a "keep-alive" mechanism to avoid being killed while
/// performing background work. You must keep a strong reference to the transaction
/// while it is operating, or transaction auto-invalidates. If it is never de-init-
/// ialized, then the service will never be killed.
public final class XPCTransaction: Hashable {
    
    private static var hashTable = NSHashTable<XPCTransaction>.weakObjects()
    public static var pending: [XPCTransaction] {
        return hashTable.allObjects
    }
    
    public let identifier = UUID()
    
    public init() {
        xpc_transaction_begin()
        XPCTransaction.hashTable.add(self)
    }
    
    deinit {
        XPCTransaction.hashTable.remove(self)
        xpc_transaction_end()
    }
    
    public func performing(action: () -> ()) {
        action()
    }
    
    public var hashValue: Int {
        return self.identifier.hashValue
    }
    
    public static func ==(lhs: XPCTransaction, rhs: XPCTransaction) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
