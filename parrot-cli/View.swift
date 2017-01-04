import Foundation

public protocol Drawable {
    var frame: Rect { get set }
    func draw()
    func layout()
    func refresh()
}

public protocol Orderable {
    var parent: Orderable? { get }
    func add(child: Orderable)
    func remove(child: Orderable)
}

public protocol Respondable {
    associatedtype Consumable
    func handle(event: Consumable) -> Bool
}

public class View: Drawable, Orderable, Respondable {
    public typealias Consumable = Event
    
    public required init(frame: Rect) {
        self.frame = frame
    }
    
    public var frame: Rect {
        didSet {
            
        }
    }
    
    public private(set) var parent: Orderable?
    
    public func add(child: Orderable) {
        
    }
    
    public func remove(child: Orderable) {
        
    }
    
    public func draw() {
        
    }
    
    public func layout() {
        
    }
    
    public func refresh() {
        
    }
    
    public func handle(event: Event) -> Bool {
        return false
    }
}
