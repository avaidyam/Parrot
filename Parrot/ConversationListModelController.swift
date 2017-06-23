import Foundation

// todo: move this over
public protocol ConversationListViewInteracting: class {
    
}

public protocol ConversationListModelInteracting: class {
    
}

public class ConversationListModelController: NSObject, ConversationListViewInteracting {
    
    public var modelInteracter: ConversationListModelInteracting? = nil {
        didSet {
            
        }
    }
}
