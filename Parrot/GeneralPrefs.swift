import Foundation
import AppKit
import Mocha
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
        
        private var bindings = [AnyBinding]()
        
        public override func loadView() {
            let stack: NSStackView = NSStackView(views: [
                self.textSize, self.interfaceStyle, self.vibrancyStyle
            ]).modernize()
            
            stack.edgeInsets = NSEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
            stack.spacing = 8.0
            stack.orientation = .vertical
            stack.alignment = .centerX
            stack.distribution = .equalSpacing
            stack.width == 512.0
            stack.height == 512.0
            self.view = stack
            
            self.bindings.append(Binding(between: (self.interfaceStyle.cell! as! NSSegmentedCell, \.selectedSegment),
                                         and: (Settings, \.interfaceStyle), with: .right))
            self.bindings.append(Binding(between: (self.vibrancyStyle.cell! as! NSSegmentedCell, \.selectedSegment),
                                         and: (Settings, \.vibrancyStyle), with: .right))
        }
    }
}

// FIXME: COMPAT
public class GeneralPreferencesController: Preferences.Controllers.General {}
