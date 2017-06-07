import Foundation
import AppKit
import MochaUI

public extension Preferences.Controllers {
    public class General: NSViewController {
        
        private lazy var textSize: NSSlider = {
            let v = NSSlider(value: 12, minValue: 9, maxValue: 16, target: self, action: nil).modernize()
            v.allowsTickMarkValuesOnly = true
            v.tickMarkPosition = .above
            v.numberOfTickMarks = 7
            return v
        }()
        
        private lazy var interfaceStyle: NSSegmentedControl = {
            let v = NSSegmentedControl(labels: ["Light", "Dark", "System"], trackingMode: .selectOne, target: self, action: nil).modernize()
            v.segmentStyle = .texturedSquare
            v.selectedSegment = 0
            return v
        }()
        
        private lazy var vibrancyStyle: NSSegmentedControl = {
            let v = NSSegmentedControl(labels: ["Always", "Never", "Auto"], trackingMode: .selectOne, target: self, action: nil).modernize()
            v.segmentStyle = .texturedSquare
            v.selectedSegment = 0
            return v
        }()
        
        public override func loadView() {
            let stack: NSStackView = NSStackView(views: [
                self.textSize, self.interfaceStyle, self.vibrancyStyle
            ]).modernize()
            
            stack.edgeInsets = EdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
            stack.spacing = 8.0
            stack.orientation = .vertical
            stack.alignment = .centerX
            stack.distribution = .equalSpacing
            stack.width == 512.0
            stack.height == 512.0
            self.view = stack
        }
    }
}

// FIXME: COMPAT
public class GeneralPreferencesController: Preferences.Controllers.General {}
