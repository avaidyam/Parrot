import Foundation
import Cocoa
import Mocha
import MochaUI

/// Only one may be visible on screen at a time!
public class PersonIndicatorToolTipController: NSViewController {
    public static var popover: NSPopover = {
        let p = NSPopover()
        p.behavior = .applicationDefined
        p.contentViewController = PersonIndicatorToolTipController()
        return p
    }()
    
    public lazy var text: NSTextField! = {
        let v = NSTextField(labelWithString: "").modernize()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alignment = .center
        v.font = NSFont.systemFont(ofSize: 11.0, weight: .semibold)
        return v
    }()
    
    public override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
        self.view.addSubview(self.text)
        batch {
            self.text.topAnchor == self.view.topAnchor + 4.0
            self.text.bottomAnchor == self.view.bottomAnchor - 4.0
            self.text.leftAnchor == self.view.leftAnchor + 4.0
            self.text.rightAnchor == self.view.rightAnchor - 4.0
        }
    }
}

/// Only one may be visible on screen at a time!
public class GroupIndicatorToolTipController: NSViewController {
    public static var popover: NSPopover = {
        let p = NSPopover()
        p.behavior = .applicationDefined
        p.contentViewController = GroupIndicatorToolTipController()
        return p
    }()
    
    private lazy var stackView: NSStackView! = {
        let s = NSStackView(views: [])
        s.wantsLayer = true
        s.edgeInsets = NSEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        s.spacing = 8.0
        s.orientation = .horizontal
        s.alignment = .centerY
        s.distribution = .fill
        s.setHuggingPriority(.required, for: .horizontal)
        s.setHuggingPriority(.required, for: .vertical)
        return s
    }()
    
    public var images: [NSImage] = [] {
        didSet {
            self.stackView.arrangedSubviews
                .forEach { $0.removeFromSuperview() }
            self.images.map { self.photoView(for: $0) }
                .forEach { self.stackView.addArrangedSubview($0) }
        }
    }
    
    public override func loadView() {
        self.view = self.stackView
        batch {
            self.view.heightAnchor == (48.0 + 8.0)
        }
    }
    
    private func photoView(for image: NSImage) -> NSImageView {
        let v = NSImageView(frame: NSRect(x: 0, y: 0, width: 48, height: 48)).modernize(wantsLayer: true)
        v.layer?.backgroundColor = .ns(.red)
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        v.image = image
        v.clipPath = NSBezierPath(ovalIn: v.bounds)
        v.sizeAnchors == v.bounds.size
        return v
    }
}
