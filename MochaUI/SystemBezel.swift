import Cocoa

// Example:
/*
let b = SystemBezel()
let t = BezelImageIndicatorView()

t.image = NSImage(named: NSImageNameTouchBarMailTemplate)
//t.text = "Mail Sent!"
t.level = 8

b.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
b.contentView = t
b.show(autohide: .seconds(2))
*/

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController
public class SystemBezel {
    
    public enum ColorMode {
        case light, lightReducedTransparency, lightIncreasedContrast
        case dark, darkReducedTransparency, darkIncreasedContrast
    }
    
    //
    //
    //
    
    // window size = 200x200
    // window padding = 20x20
    // window position = centerx140
    // window corners = 19
    
    /*
    private class var windowFrameRect: NSRect {
        return NSRect(x: 0, y: 140, width: 200, height: 200)
    }

    private class var windowCornerRadius: CGFloat {
        return 19
    }
    */
    
    /*
    private class var imageViewFrameRect: NSRect {
        return NSRect(x: 20, y: 62, width: 100, height: 100)
    }

    private class var centredImageViewFrameRect: NSRect {
        return NSRect(x: 20, y: 20, width: 160, height: 160)
    }

    private class var levelIndicatorFrameRect: NSRect {
        return NSRect(x: 20, y: 20, width: 161, height: 8)
    }
    */
    
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
        if NSAppearance.increaseContrastEnabled {
            return NSAppearance.darkModeEnabled ? .darkIncreasedContrast : .lightIncreasedContrast
        }
        if NSAppearance.reduceTransparencyEnabled {
            return NSAppearance.darkModeEnabled ? .darkReducedTransparency : .lightReducedTransparency
        }
        return NSAppearance.darkModeEnabled ? .dark : .light
    }
    
    // If nil, follows the system appearance.
    public var appearance: NSAppearance? = nil {
        didSet {
            self._updateAppearance()
        }
    }
    
    public var darkMaterial: NSVisualEffectMaterial = .popover
    
    public var lightMaterial: NSVisualEffectMaterial = .mediumLight
    
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
        self.window.level = Int(CGWindowLevelKey.overlayWindow.rawValue)
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
    
    //
    //
    //
    
    private func _maskImage(cornerRadius c: CGFloat) -> NSImage {
        let edge = 2.0 * c + 1.0
        let size = NSSize(width: edge, height: edge)
        let inset = EdgeInsets(top: c, left: c, bottom: c, right: c)
        
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
                let a = NSAppearance(named: NSAppearanceNameVibrantDark)
                self.window.appearance = a
                self.contentView?.appearance = a
                self.effectView.material = self.darkMaterial
            } else {
                let a = NSAppearance(named: NSAppearanceNameVibrantLight)
                self.window.appearance = a
                self.contentView?.appearance = a
                self.effectView.material = self.lightMaterial
            }
        }
        
        // trampoline
        if let a = self.appearance {
            _inner(a.name == NSAppearanceNameVibrantDark)
        } else {
            _inner(NSAppearance.darkModeEnabled)
        }
    }
    
    private func _centerBezel() {
        if let mainScreen = NSScreen.main() {
            let screenHorizontalMidPoint = mainScreen.frame.size.width / 2
            var newFrame = self.window.frame
            newFrame.origin.x = screenHorizontalMidPoint - (window.frame.size.width / 2)
            self.window.setFrame(newFrame, display: true, animate: false)
        }
    }
}

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController
extension NSImage {
    public func tintedImage(_ tintColor: NSColor) -> NSImage {
        let size = self.size
        let imageBounds = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // Tint the image.
        let tintedImage = self.copy() as! NSImage
        tintedImage.lockFocus()
        tintColor.set()
        NSRectFillUsingOperation(imageBounds, .sourceAtop)
        tintedImage.unlockFocus()
        
        return tintedImage
    }
}

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController
extension NSAppearance {
    // MARK: - User Interface Preferences
    public static var darkModeEnabled: Bool {
        if let darkModeString = CFPreferencesCopyAppValue(("AppleInterfaceStyle" as NSString as CFString), ("NSGlobalDomain" as NSString as CFString)) as? String {
            return darkModeString == "Dark"
        }
        return false
    }
    
    public static var reduceTransparencyEnabled: Bool {
        return CFPreferencesGetAppBooleanValue(("reduceTransparency" as NSString as CFString), ("com.apple.universalaccess" as NSString as CFString), nil)
    }
    
    public static var increaseContrastEnabled: Bool {
        return CFPreferencesGetAppBooleanValue(("increaseContrast" as NSString as CFString), ("com.apple.universalaccess" as NSString as CFString), nil)
    }
}
