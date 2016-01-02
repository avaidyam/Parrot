import Darwin.ncurses

/* TODO: This is going to become an NCurses library real fast... */

struct Attribute: OptionSetType {
	let rawValue: Int32
	
	static let Normal = Attribute(rawValue: _NORMAL)
	static let Standout = Attribute(rawValue: _STANDOUT)
	static let Underline = Attribute(rawValue: _UNDERLINE)
	static let Reverse = Attribute(rawValue: _REVERSE)
	static let Blink = Attribute(rawValue: _BLINK)
	static let Dim = Attribute(rawValue: _DIM)
	static let Bold = Attribute(rawValue: _BOLD)
	static let AlternativeCharacterSet = Attribute(rawValue: _ALTCHARSET)
	static let Invisible = Attribute(rawValue: _INVIS)
	static let Protected = Attribute(rawValue: _PROTECT)
}

typealias RGB = (R: Double, G: Double, B: Double)

struct Color {
	let rawValue: Int32
	
	static var Black = Color(rawValue: COLOR_BLACK)
	static var Red = Color(rawValue: COLOR_RED)
	static var Green = Color(rawValue: COLOR_GREEN)
	static var Yellow = Color(rawValue: COLOR_YELLOW)
	static var Blue = Color(rawValue: COLOR_BLUE)
	static var Magenta = Color(rawValue: COLOR_MAGENTA)
	static var Cyan = Color(rawValue: COLOR_CYAN)
	static var White = Color(rawValue: COLOR_WHITE)
	
	// The RGB components of this defined color.
	var rgb: RGB {
		get {
			var r: Int16 = 0
			var g: Int16 = 0
			var b: Int16 = 0
			color_content(Int16(self.rawValue), &r, &g, &b)
			return (Double(r) / 1000.0, Double(g) / 1000.0, Double(b) / 1000.0)
		}
		set {
			let r: Int16 = Int16(min(newValue.R, 0) * 1000)
			let g: Int16 = Int16(min(newValue.G, 0) * 1000)
			let b: Int16 = Int16(min(newValue.B, 0) * 1000)
			init_color(Int16(self.rawValue), r, g, b)
		}
	}
	
	// Does the terminal support color mode?
	static func isSupported() -> Bool {
		return has_colors()
	}
	
	// Does the terminal support changing the colors?
	static func canChange() -> Bool {
		return can_change_color()
	}
}

/* TODO: Needs some work. */
struct ColorPair {
	static var used: Int = 0 // to keep track
	let pair: Int
	
	let first: Color
	let second: Color
	
	init(first: Color, second: Color) {
		self.pair = ++ColorPair.used
		self.first = first
		self.second = second
		init_pair(Int16(pair), Int16(first.rawValue), Int16(second.rawValue))
	}
	
	
}