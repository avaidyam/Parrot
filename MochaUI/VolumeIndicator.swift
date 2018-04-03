import AppKit
import Mocha

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController
public class VolumeIndicator: NSView {
    
    private enum ColorKeys {
        case background, segment
    }
    private let drawColors: [SystemBezel.ColorMode: [ColorKeys: NSColor]] = [
        .light: [.background: NSColor(deviceWhite: 0, alpha: 0.6), .segment: .controlBackgroundColor],
        .lightReducedTransparency: [.background: NSColor(deviceWhite: 0.50, alpha: 1.0), .segment: .white],
        .lightIncreasedContrast: [.background: NSColor(deviceWhite: 0.01, alpha: 1.0), .segment: .white],
        .dark: [.background: NSColor(deviceWhite: 0, alpha: 0.6), .segment: NSColor(deviceWhite: 1, alpha: 0.8)],
        .darkReducedTransparency: [.background: NSColor(deviceWhite: 0.01, alpha: 1.0), .segment: NSColor(deviceWhite: 0.49, alpha: 1.0)],
        .darkIncreasedContrast: [.background: NSColor(deviceWhite: 0.01, alpha: 1.0), .segment: NSColor(deviceWhite: 0.76, alpha: 1.0)],
    ]

    private var unitLayers: [CALayer] = []
    
    // Note that the color is inverted from the root appearance to stand out.
    private var colorMode: SystemBezel.ColorMode {
        let a = self.appearance?.name ?? .vibrantLight
        if NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast {
            return a == .vibrantDark ? .lightIncreasedContrast : .darkIncreasedContrast
        }
        if NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency {
            return a == .vibrantDark ? .lightReducedTransparency : .darkReducedTransparency
        }
        return a == .vibrantDark ? .light : .dark
    }
    
    private var barColor: NSColor {
        return self.drawColors[self.colorMode]![.background]!
    }

    private var segmentColor: NSColor {
        return self.drawColors[self.colorMode]![.segment]!
    }
    
    private let maxLevel: Int = 16
    
    public var level: Int = 0 {
        willSet {
            self.level = self.level.clamped(to: 0...maxLevel)
        }
        didSet {
            self.needsDisplay = true
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }
    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.wantsLayer = true
    }
    
    //
    //
    //
    
    public override var allowsVibrancy: Bool {
        return false
    }
    public override var intrinsicContentSize: NSSize {
        return NSSize(width: NSView.noIntrinsicMetric, height: 8.0)
    }
    
    public override var wantsUpdateLayer: Bool {
        return true
    }
    public override func updateLayer() {
        if self.unitLayers.count == 0 {
            for _ in (0..<self.maxLevel) {
                let layer = CALayer()
                self.layer!.addSublayer(layer)
                self.unitLayers.append(layer)
            }
        }
        
        self.layer!.backgroundColor = self.barColor.cgColor
        for (idx, layer) in self.unitLayers.enumerated() {
            layer.backgroundColor = self.segmentColor.cgColor
            layer.opacity = idx <= self.level ? 1.0 : 0.0
        }
    }
    
    public override func layout() {
        super.layout()
        for (idx, layer) in self.unitLayers.enumerated() {
            let sliceWidth = self.layer!.bounds.width / CGFloat(self.maxLevel)
            
            var rect = self.layer!.bounds
            rect.origin.x = sliceWidth * CGFloat(idx)
            rect.size.width = sliceWidth
            layer.frame = rect.insetBy(dx: 2.0, dy: 0.0)
        }
    }
}
