import Cocoa
import MochaUI

public class SearchCell: NSView {
    
    private lazy var searchField: NSSearchField = {
        let s = NSSearchField().modernize(wantsLayer: true)
        s.disableToolbarLook()
        s.performedAction = {
            self.handler(s.stringValue)
        }
        return s
    }()
    
    public var handler: (String) -> () = {_ in}
    
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
        
        self.addSubview(self.searchField)
        self.centerX == self.searchField.centerX
        self.centerY == self.searchField.centerY
    }
    
    public override var allowsVibrancy: Bool { return true }
    public override var wantsUpdateLayer: Bool { return true }
    public override func updateLayer() {
        //self.layer!.backgroundColor = NSColor.white.withAlphaComponent(0.2).cgColor
    }
    
    public override func prepareForReuse() {
        self.handler = {_ in}
    }
}

