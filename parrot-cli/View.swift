import Foundation

/*
public protocol Drawable {
    var frame: Rect { get set }
    func draw()
    func layout()
    func refresh()
}

public protocol Orderable {
    
    var parent: Self? { get }
    var children: [Self] { get }
    
    func add(child: Self)
    func remove(child: Self)
}

public protocol Respondable {
    associatedtype Consumable
    func becomeFirstResponder()
    func resignFirstResponder()
    func handle(event: Consumable) -> Bool
}

public extension Respondable {
    func becomeFirstResponder() {}
    func resignFirstResponder() {}
}
*/


public class View {//}: Drawable, Orderable, Respondable {
    public typealias Consumable = Event
    
    public var contents: [[Cell]] = [[]]
    
    public private(set) var parent: View? = nil
    public private(set) var children: [View] = []
    public var frame: Rect {
        didSet {
            
        }
    }
    
    public required init(frame: Rect) {
        self.frame = frame
    }
    
    public func add(child: View) {
        
    }
    
    public func remove(child: View) {
        
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

public class Window: View {
    
    public var foreground: Attributes = .white
    public var background: Attributes = .black
    
    public required init(frame: Rect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: Rect, foreground: Attributes, background: Attributes) {
        self.init(frame: frame)
        self.foreground = foreground
        self.background = background
    }
    
    public override func draw() {
        
    }
}
