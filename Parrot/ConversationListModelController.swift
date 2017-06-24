import Cocoa

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

// Plan for this class:
//
// - ModelController <--> Controller <--> ViewController
// - Yeah, that's *three* controller classes.
// - The ViewInteracting/ModelInteracting protocols describe interactions between them.
// - Alternatively, better `Bindable` or `Observable` support would help.
// - `Controller` would then be a wrapper for all the bindings and house both `Model/ViewController`s
// - `Controller` probably needs a better name...
// - `ModelController` will handle dataSource-side events and all.
// - Use something like NSViewControllerEmptyPresenting or NSViewControllerLoadingPresenting?
