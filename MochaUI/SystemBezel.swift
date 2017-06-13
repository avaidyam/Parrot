import Cocoa

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController

/* TODO: Add SystemBezel queueing support (like Toast). */
/* TODO: Add SystemBezel margin/gravity support (like Toast). */

/// A SystemBezel is an on-screen view containing a quick message for the user.
///
/// When the view is shown to the user, it appears as a floating window over all 
/// applications, but will never become key. The user will probably not be interacting
/// with your app. The idea is to be as unobtrusive as possible, while still 
/// showing the user the information you want them to see. Two examples are the 
/// volume control, and a brief message saying that your settings have been saved.
///
/// Note: The easiest way to use this class is to call the static `create()` method.
///
/// Example: SystemBezel.create(text: "Mail Sent!", image: ImageAssets.mailIcon).show(duration: .seconds(2))
public class SystemBezel {
    
    // window size = 200x200
    // window padding = 20x20
    // window position = centerx140
    // window corners = 19
    public enum ColorMode {
        case light, lightReducedTransparency, lightIncreasedContrast
        case dark, darkReducedTransparency, darkIncreasedContrast
    }
    
    //
    //
    //
    
    private let window: NSWindow
    private let effectView: NSVisualEffectView
    
    public var contentView: NSView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let n = self.contentView, let e = Optional(self.effectView) {
                e.addSubview(n)
                n.frame = e.bounds.insetBy(dx: 20, dy: 20)
            }
        }
    }
    
    private var activeColorMode: ColorMode {
        if NSAppearance.increaseContrast {
            return NSAppearance.darkMode ? .darkIncreasedContrast : .lightIncreasedContrast
        }
        if NSAppearance.reduceTransparency {
            return NSAppearance.darkMode ? .darkReducedTransparency : .lightReducedTransparency
        }
        return NSAppearance.darkMode ? .dark : .light
    }
    
    // If nil, follows the system appearance.
    public var appearance: NSAppearance? = nil {
        didSet {
            self._updateAppearance()
        }
    }
    
    public var darkMaterial: NSVisualEffectView.Material = .popover
    
    public var lightMaterial: NSVisualEffectView.Material = .mediumLight
    
    //
    //
    //
    
    public init() {
        let cornerRadius: CGFloat = 19.0
        let bezelFrame = NSRect(x: 0, y: 140, width: 200, height: 200)
        
        self.window = NSWindow(contentRect: bezelFrame,
                               styleMask: .borderless, backing: .buffered, defer: false)
        self.effectView = NSVisualEffectView(frame: NSRect(origin: .zero,
                                                           size: bezelFrame.size))
        
        self.window.ignoresMouseEvents = true
        self.window.backgroundColor = NSColor.clear
        self.window.isOpaque = false
        self.window.level = .screenSaverWindowLevel
        self.window.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle, .stationary,
                                          .fullScreenNone, .fullScreenDisallowsTiling]
        
        self.window.contentView = effectView
        self.effectView.wantsLayer = true
        self.effectView.state = .active
        self.effectView.blendingMode = .behindWindow
        self.effectView.maskImage = self._maskImage(cornerRadius: cornerRadius)
    }
    
    public func show(autohide time: DispatchTimeInterval? = nil) {
        NSAnimationContext.runAnimationGroup({
            $0.duration = 0.01
            self.window.alphaValue = 1
        }, completionHandler: {
            self._updateAppearance()
            self._centerBezel()
            self.window.orderFront(nil)
            
            if let time = time {
                self.hide(after: time)
            }
        })
    }

    public func hide(after: DispatchTimeInterval = .seconds(0)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            NSAnimationContext.runAnimationGroup({
                $0.duration = 0.7
                self.window.animator().alphaValue = 0
            }, completionHandler: {
                self.window.close()
            })
        }
    }
    
    public static func create(text: String? = nil, image: NSImage? = nil, appearance: NSAppearance? = nil) -> SystemBezel {
        let b = SystemBezel()
        let t = BezelImageTextView()
        t.image = image
        t.text = text
        b.appearance = appearance
        b.contentView = t
        return b
    }
    
    //
    //
    //
    
    private func _maskImage(cornerRadius c: CGFloat) -> NSImage {
        let edge = 2.0 * c + 1.0
        let size = NSSize(width: edge, height: edge)
        let inset = NSEdgeInsets(top: c, left: c, bottom: c, right: c)
        
        let maskImage = NSImage(size: size, flipped: false) {
            let bezierPath = NSBezierPath(roundedRect: $0, xRadius: c, yRadius: c)
            NSColor.black.set()
            bezierPath.fill()
            return true
        }
        
        maskImage.capInsets = inset
        maskImage.resizingMode = .stretch
        return maskImage
    }
    
    // FIXME: this is a gnarly func here...
    private func _updateAppearance() {
        func _inner(_ dark: Bool) {
            if dark {
                let a = NSAppearance(named: NSAppearance.Name.vibrantDark)
                self.window.appearance = a
                self.contentView?.appearance = a
                self.effectView.material = self.darkMaterial
            } else {
                let a = NSAppearance(named: NSAppearance.Name.vibrantLight)
                self.window.appearance = a
                self.contentView?.appearance = a
                self.effectView.material = self.lightMaterial
            }
        }
        
        // trampoline
        if let a = self.appearance {
            _inner(a.name == NSAppearance.Name.vibrantDark)
        } else {
            _inner(NSAppearance.darkMode)
        }
    }
    
    private func _centerBezel() {
        if let mainScreen = NSScreen.main {
            let screenHorizontalMidPoint = mainScreen.frame.size.width / 2
            var newFrame = self.window.frame
            newFrame.origin.x = screenHorizontalMidPoint - (window.frame.size.width / 2)
            self.window.setFrame(newFrame, display: true, animate: false)
        }
    }
}
