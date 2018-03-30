import MochaUI

public extension Preferences.Controllers {
    public class General: PreferencePaneViewController {
        
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
            let v = NSSegmentedControl(labels: ["System", "Light", "Dark"],
                                       trackingMode: .selectOne,
                                       target: nil, action: nil).modernize()
            v.setupForBindings()
            v.segmentStyle = .texturedSquare
            v.selectedSegment = 0
            return v
        }()
        
        private lazy var vibrancyStyle: NSSegmentedControl = {
            let v = NSSegmentedControl(labels: ["Auto", "Always", "Never"],
                                       trackingMode: .selectOne,
                                       target: nil, action: nil).modernize()
            v.setupForBindings()
            v.segmentStyle = .texturedSquare
            v.selectedSegment = 0
            return v
        }()
        
        private lazy var autoEmoji: NSButton = {
            return NSButton(checkboxWithTitle: "Automatically convert emoji",
                            target: nil, action: nil).setupForBindings()
        }()
        
        private lazy var menubarIcon: NSButton = {
            return NSButton(checkboxWithTitle: "Display in menu bar only",
                            target: nil, action: nil).setupForBindings()
        }()
        
        private lazy var shoeboxAppStyle: NSButton = {
            return NSButton(checkboxWithTitle: "Show recents and conversations as one window (requires restart)",
                            target: nil, action: nil).setupForBindings()
        }()
        
        private var bindings: [AnyBinding] = []
        
        public override func loadView() {
            let stack: NSStackView = NSStackView(views: [
                self.textSize, self.interfaceStyle, self.vibrancyStyle, self.autoEmoji, self.menubarIcon, self.shoeboxAppStyle
            ]).modernize()
            
            stack.edgeInsets = NSEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
            stack.spacing = 20.0
            stack.orientation = .vertical
            stack.alignment = .centerX
            stack.distribution = .fill
            stack.widthAnchor == 400.0
            self.view = stack
            self.title = "General"
            self.image = NSImage(named: .advanced)
            
            self.bindings = [
                Binding(between: (self.textSize, \.doubleValue),
                        and: (Settings, \.messageTextSize), with: .right),
                Binding(between: (self.interfaceStyle, \.integerValue),
                        and: (Settings, \.interfaceStyle), with: .right),
                Binding(between: (self.vibrancyStyle, \.integerValue),
                        and: (Settings, \.vibrancyStyle), with: .right),
                Binding(between: (self.autoEmoji, \.boolValue),
                        and: (Settings, \.autoEmoji), with: .right),
                Binding(between: (self.menubarIcon, \.boolValue),
                        and: (Settings, \.menubarIcon), with: .right),
            ]
            self.bindings.append(
                Binding(between: (self.shoeboxAppStyle, \.boolValue),
                        and: (Settings, \.prefersShoeboxAppStyle), with: .right)
            )
        }
    }
}
