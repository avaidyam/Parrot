import AppKit
import Mocha

/// A monogram image rep that draws a single initial letter from the given string
/// over a gradient background, optionally masking with an overlay image instead.
public class NSMonogramImageRep: NSImageRep {
    
    public var string: String = ""
    public var color: NSColor = .clear
    public var overlay: NSImage? = nil
    public var fontName: NSFont.Name? = nil
    
    public init(size: NSSize, string: String, color: NSColor, fontName: NSFont.Name? = nil, overlay: NSImage? = nil) {
        super.init()
        self.size = size
        self.string = string
        self.color = color
        self.fontName = fontName
        self.overlay = overlay
    }
    
    public override init() {
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func draw() -> Bool {
        let rect = NSRect(origin: .zero, size: self.size)
        NSGradient(starting: self.color, ending: self.baseColor)?.draw(in: rect, angle: 270)
        
        // If we have an overlay image, draw that via XOR (cutout) if it's a template.
        if let overlay = self.overlay {
            var r = rect.insetBy(dx: -size.width * 0.05, dy: -size.height * 0.05)
            r.origin.y -= size.height * 0.1
            overlay.draw(in: r, from: .zero, operation: .XOR, fraction: 1.0)
        } else {
            
            // Draw the monogram text.
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = .center
            let textSize = rect.size.width * 0.75
            let font = NSMonogramImageRep.monogramFont(name: self.fontName, size: textSize)
            var rect2 = rect
            rect2.origin.y = rect.midY - (font.capHeight / 2)
            
            String(self.string.characters.first!).uppercased().draw(with: rect2, attributes: [
                .font: font,
                .foregroundColor: NSColor.white,
                .paragraphStyle: textStyle
            ])
        }
        return true
    }
    
    private static func monogramFont(name: NSFont.Name?, size textSize: CGFloat) -> NSFont {
        if let name = name, let font = NSFont(name: name.rawValue, size: textSize) {
            return font
        }
        return  NSFont.systemFont(ofSize: textSize, weight: .semibold)
    }
    
    private var baseColor: NSColor {
        return self.color.blended(withFraction: 0.33, of: .black) ?? self.color
    }
}

public extension NSImage {
    public convenience init(monogramOfSize size: NSSize, string: String,
                            color: NSColor, fontName: NSFont.Name? = nil, overlay: NSImage? = nil)
    {
        self.init()
        self.addRepresentation(NSMonogramImageRep(size: size, string: string,
                                                  color: color, fontName: fontName, overlay: overlay))
    }
}

public extension NSColor {
    
    /// Determines whether the color is a human-perceived "light" color.
    func isLight() -> Bool {
        let p3 = self.usingColorSpace(NSColorSpace.deviceRGB)!
        let brightness = (p3.redComponent * 299) + (p3.greenComponent * 587) + (p3.blueComponent * 114)
        return !(brightness < 500)
    }
    
    /// Returns a tinted version of the receiver if the receiver is an RGB color.
    func tinted() -> NSColor {
        var h = CGFloat(), s = CGFloat(), b = CGFloat(), a = CGFloat()
        let rgbColor = usingColorSpaceName(NSColorSpaceName.calibratedRGB)
        rgbColor?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return NSColor(hue: h, saturation: s, brightness: b == 0 ? 0.2 : b * 0.8, alpha: a)
    }
    
    /// Returns an dark overlay color suitable for the given appearance.
	public static func darkOverlay(forAppearance a: NSAppearance) -> NSColor {
        if a.name == .vibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.2)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.1)
		}
	}
	
    /// Returns a light overlay color suitable for the given appearance.
	public static func lightOverlay(forAppearance a: NSAppearance) -> NSColor {
        if a.name == .vibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.6)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.3)
		}
	}
}
