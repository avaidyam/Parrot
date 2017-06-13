import AppKit
import protocol ParrotServiceExtension.Person

/* FIXME: Turn this into PersonaUI's PRMonogram, essentially. */

public let materialIndex = [
	"Red": #colorLiteral(red: 0.9450980425, green: 0.1568627506, blue: 0.1294117719, alpha: 1), "Pink": #colorLiteral(red: 0.8941176534, green: 0, blue: 0.3098039329, alpha: 1), "Purple": #colorLiteral(red: 0.5411764979, green: 0, blue: 0.6392157078, alpha: 1), "Deep Purple": #colorLiteral(red: 0.3254902065, green: 0.1019607857, blue: 0.6705882549, alpha: 1), "Indigo": #colorLiteral(red: 0.1843137294, green: 0.2117647082, blue: 0.6627451181, alpha: 1), "Blue": #colorLiteral(red: 0.08235294372, green: 0.4941176474, blue: 0.9568627477, alpha: 1), "Light Blue": #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1), "Cyan": #colorLiteral(red: 0, green: 0.6862745285, blue: 0.8000000119, alpha: 1), "Teal": #colorLiteral(red: 0.003921568859, green: 0.5254902244, blue: 0.4588235319, alpha: 1),
	"Green": #colorLiteral(red: 0.2352941185, green: 0.6470588446, blue: 0.2274509817, alpha: 1), "Light Green": #colorLiteral(red: 0.4745098054, green: 0.7372549176, blue: 0.1960784346, alpha: 1), "Lime": #colorLiteral(red: 0.7647058964, green: 0.8549019694, blue: 0.1019607857, alpha: 1), "Yellow": #colorLiteral(red: 1, green: 0.9254902005, blue: 0.08627451211, alpha: 1), "Amber": #colorLiteral(red: 1, green: 0.7176470757, blue: 0, alpha: 1), "Orange": #colorLiteral(red: 1, green: 0.5254902244, blue: 0, alpha: 1), "Deep Orange": #colorLiteral(red: 1, green: 0.2431372553, blue: 0.04705882445, alpha: 1), "Brown": #colorLiteral(red: 0.400000006, green: 0.2627451122, blue: 0.2156862766, alpha: 1), "Blue Gray": #colorLiteral(red: 0.3019607961, green: 0.4156862795, blue: 0.4745098054, alpha: 1), "Gray": #colorLiteral(red: 0.4599502683, green: 0.4599616528, blue: 0.4599555135, alpha: 1),
]
public let materialColors = Array(materialIndex.values)

public let materialColorList: NSColorList = {
    let l = NSColorList(name: NSColorList.Name(rawValue: "Material Design"))
    for (i, e) in materialIndex.enumerated() {
        l.insertColor(e.value, key: NSColor.Name(rawValue: e.key), at: i)
    }
    return l
}()

public extension NSColor {
    func isLight() -> Bool {
        let p3 = self.usingColorSpace(NSColorSpace.deviceRGB)!
        let brightness = (p3.redComponent * 299) + (p3.greenComponent * 587) + (p3.blueComponent * 114)
        return !(brightness < 500)
    }
}

public func imageForString(forString source: String, size: NSSize = NSSize(width: 64, height: 64), colors: [NSColor] = materialColors) -> NSImage {
	return NSImage(size: size, flipped: false) { rect in
		colors[abs(source.hashValue) % colors.count].set()
		rect.fill()
		
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		textStyle.alignment = .center
		let font = NSFont.systemFont(ofSize: rect.size.width * 0.75)
		let attrs = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: NSColor.white,
            NSAttributedStringKey.paragraphStyle: textStyle
		]
		
		var rect2 = rect
		rect2.origin.y = rect.midY - (font.capHeight / 2)
		let str = String(source.characters.first!).uppercased()
		str.draw(with: rect2, attributes: attrs)
		return true
	}
}

public func defaultImageForString(forString source: String, size: NSSize = NSSize(width: 64, height: 64), colors: [NSColor] = materialColors) -> NSImage {
	return NSImage(size: size, flipped: false) { rect in
		colors[abs(source.hashValue) % colors.count].set()
		rect.fill()
		var r = rect.insetBy(dx: -size.width * 0.05, dy: -size.height * 0.05)
		r.origin.y -= size.height * 0.1
        NSImage(named: NSImage.Name(rawValue: "NSUserGuest"))!.draw(in: r) // composite this somehow.
		return true
	}
}

public extension Person {
    var image: NSImage {
        return fetchImage(user: self, monogram: true)
    }
}

public extension NSColor {
	public static func darkOverlay(forAppearance a: NSAppearance) -> NSColor {
        if a.name == NSAppearance.Name.vibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.2)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.1)
		}
	}
	
	public static func lightOverlay(forAppearance a: NSAppearance) -> NSColor {
        if a.name == NSAppearance.Name.vibrantDark {
			return NSColor(calibratedWhite: 1.00, alpha: 0.6)
		} else {
			return NSColor(calibratedWhite: 0.00, alpha: 0.3)
		}
	}
}
