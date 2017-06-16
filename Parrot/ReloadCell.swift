import Cocoa
import MochaUI

public class ReloadCell: NSView {
    
    private lazy var button: NSButton = {
        let b = NSButton(title: "Load More", image: NSImage(named: .refreshTemplate)!,
                         target: self, action: #selector(self.reloadPressed(_:)))
            .modernize()
        return b
    }()
    
    public var title: String = "Load More" {
        didSet {
            self.button.title = self.title
        }
    }
    public var image: NSImage? = NSImage(named: .refreshTemplate) {
        didSet {
            self.button.image = self.image
        }
    }
    public var handler: () -> () = {}
    
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
        
        self.addSubview(self.button)
        self.centerX == self.button.centerX
        self.centerY == self.button.centerY
    }
    
    public override var allowsVibrancy: Bool { return true }
    public override var wantsUpdateLayer: Bool { return true }
    public override func updateLayer() {
        //self.layer!.backgroundColor = NSColor.white.withAlphaComponent(0.2).cgColor
    }
    
    public override func prepareForReuse() {
        self.handler = {}
    }
    
    @objc private func reloadPressed(_ sender: NSButton!) {
        self.handler()
    }
}
