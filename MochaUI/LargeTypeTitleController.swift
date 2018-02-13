import AppKit
import Mocha

public class LargeTypeTitleController: NSTitlebarAccessoryViewController {
    
    private lazy var titleText: NSTextField = {
        let t = NSTextField(labelWithString: "")
        t.wantsLayer = true
        t.translatesAutoresizingMaskIntoConstraints = false
        t.textColor = NSColor.labelColor
        t.font = NSFont.systemFont(ofSize: 32.0, weight: .heavy)
        return t
    }()
    
    public override var title: String? {
        didSet {
            self.titleText.stringValue = self.title ?? ""
        }
    }
    
    public init(title: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self._init()
        self.title = title
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self._init()
    }
    
    private func _init() {
        let v = NSView()
        v.autoresizingMask = [.width]
        v.frame.size.height = 44.0//80.0
        v.add(subviews: self.titleText) {
            self.titleText.leftAnchor == v.leftAnchor + 22.0
            self.titleText.topAnchor == v.topAnchor + 2.0
        }
        
        self.view = v
        self.layoutAttribute = .bottom
    }
}
