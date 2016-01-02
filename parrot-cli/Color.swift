import Darwin.ncurses

// For RGB components.
typealias RGB = (R: Double, G: Double, B: Double)

struct Color {
	let rawValue: Int32
	
	// All the available terminal colors.
	static var Black = Color(rawValue: COLOR_BLACK)
	static var Red = Color(rawValue: COLOR_RED)
	static var Green = Color(rawValue: COLOR_GREEN)
	static var Yellow = Color(rawValue: COLOR_YELLOW)
	static var Blue = Color(rawValue: COLOR_BLUE)
	static var Magenta = Color(rawValue: COLOR_MAGENTA)
	static var Cyan = Color(rawValue: COLOR_CYAN)
	static var White = Color(rawValue: COLOR_WHITE)
	
	// You can only access the predefined colors!
	internal init(rawValue: Int32) {
		self.rawValue = rawValue
	}
	
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
			let r = Int16(min(newValue.R, 0) * 1000)
			let g = Int16(min(newValue.G, 0) * 1000)
			let b = Int16(min(newValue.B, 0) * 1000)
			init_color(Int16(self.rawValue), r, g, b)
		}
	}
}

// For Foreground/Background values.
typealias FB = (F: Color, B: Color)

// We have to put this here to appease the Swift gods.
private var _p = 0

struct ColorPair {
	let rawValue: Int32
	
	// Note that pair 0 may not be modifiable.
	init(_ rawValue: Int) {
		self.rawValue = Int32(rawValue < COLOR_PAIRS - 1 ? rawValue : 0)
	}
	
	init(_ rawValue: Int, colors: FB) {
		self.init(rawValue)
		self.colors = colors
	}
	
	// The foreground/background pair for this ColorPair.
	var colors: FB {
		get {
			var f: Int16 = 0
			var b: Int16 = 0
			pair_content(Int16(self.rawValue), &f, &b)
			return (Color(rawValue: Int32(f)), Color(rawValue: Int32(b)))
		}
		set {
			let f = Int16(newValue.F.rawValue)
			let b = Int16(newValue.B.rawValue)
			init_pair(Int16(self.rawValue), f, b)
		}
	}
}