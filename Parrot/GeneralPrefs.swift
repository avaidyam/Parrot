import Foundation
import AppKit
import Mocha
import MochaUI

public extension Preferences.Controllers {
    public class General: NSViewController {
        public var image: NSImage? = NSImage(named: .advanced)
        public override var title: String? {
            set{} get { return "General" }
        }
        
        private lazy var textSize: NSSlider = {
            let v = NSSlider(value: 12, minValue: 9, maxValue: 16,
                             target: nil, action: nil).modernize()
            v.setupForBindings()
            v.allowsTickMarkValuesOnly = true
            v.tickMarkPosition = .above
            v.numberOfTickMarks = 8
            v.isContinuous = true
            return v
        }()
        
        private lazy var interfaceStyle: NSSegmentedControl = {
            let v = NSSegmentedControl(labels: ["Light", "Dark", "System"],
                                       trackingMode: .selectOne,
                                       target: nil, action: nil).modernize()
            v.setupForBindings()
            v.segmentStyle = .texturedSquare
            v.selectedSegment = 0
            return v
        }()
        
        private lazy var vibrancyStyle: NSSegmentedControl = {
            let v = NSSegmentedControl(labels: ["Always", "Never", "Auto"],
                                       trackingMode: .selectOne,
                                       target: nil, action: nil).modernize()
            v.setupForBindings()
            v.segmentStyle = .texturedSquare
            v.selectedSegment = 0
            return v
        }()
        
        private var bindings: [AnyBinding] = []
        
        public override func loadView() {
            let stack: NSStackView = NSStackView(views: [
                self.textSize, self.interfaceStyle, self.vibrancyStyle
            ]).modernize()
            
            stack.edgeInsets = NSEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
            stack.spacing = 20.0
            stack.orientation = .vertical
            stack.alignment = .centerX
            stack.distribution = .fill
            stack.width == 400.0
            self.view = stack
            
            self.bindings = [
                Binding(between: (self.textSize, \.doubleValue),
                        and: (Settings, \.messageTextSize), with: .right),
                Binding(between: (self.interfaceStyle, \.integerValue),
                        and: (Settings, \.interfaceStyle), with: .right),
                Binding(between: (self.vibrancyStyle, \.integerValue),
                        and: (Settings, \.vibrancyStyle), with: .right)
            ]
        }
    }
}
