import Foundation
import AppKit
import MochaUI

public class GeneralPreferencesController: NSViewController {
    
    private var stackView: NSStackView? {
        return self.view as? NSStackView
    }
    
    private lazy var textSize: NSSlider = {
        let b = NSSlider(value: 12, minValue: 9, maxValue: 16, target: self, action: nil)
        return NSView.prepare(b) { (v: NSSlider) in
            v.allowsTickMarkValuesOnly = true
            v.tickMarkPosition = .above
            v.numberOfTickMarks = 7
        }
    }()
    
    private lazy var interfaceStyle: NSSegmentedControl = {
        let b = NSSegmentedControl(labels: ["Light", "Dark", "System"], trackingMode: .selectOne, target: self, action: nil)
        return NSView.prepare(b) { (v: NSSegmentedControl) in
            v.segmentStyle = .texturedSquare
        }
    }()
    
    private lazy var vibrancyStyle: NSSegmentedControl = {
        let b = NSSegmentedControl(labels: ["Always", "Never", "Auto"], trackingMode: .selectOne, target: self, action: nil)
        return NSView.prepare(b) { (v: NSSegmentedControl) in
            v.segmentStyle = .texturedSquare
        }
    }()
    
    public override func loadView() {
        let stack: NSStackView = NSView.prepare(NSStackView(views: [
            self.textSize, self.interfaceStyle, self.vibrancyStyle
        ]))
        stack.edgeInsets = EdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        stack.spacing = 8.0
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.distribution = .fill
        stack.width == 128.0
        self.view = stack
    }
}
