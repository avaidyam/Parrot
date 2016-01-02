import Darwin.ncurses

/* TODO: Support Terminal toggling curses, character break, half-delay, echo, raw mode. */

struct Border {
	let leftSide: UInt32
	let rightSide: UInt32
	let topSide: UInt32
	let bottomSide: UInt32
	
	let topLeft: UInt32
	let topRight: UInt32
	let bottomLeft: UInt32
	let bottomRight: UInt32
	
	// Using an array of zeros allows the standard values instead.
	static func `default`() -> Border {
		return fromArray([0, 0, 0, 0, 0, 0, 0, 0])!
	}
	
	// Creates a Border from an array of 8 elements.
	// Components must follow the same order as the above variables!
	static func fromArray(values: [UInt32]) -> Border? {
		if values.count != 8 {
			return nil
		}
		
		return Border(leftSide: values[0], rightSide: values[1],
					  topSide: values[2], bottomSide: values[3],
					  topLeft: values[4], topRight: values[5],
					  bottomLeft: values[6], bottomRight: values[7])
	}
	
	// Creates a Border from a string of 8 characters.
	// Components must follow the same order as the above variables!
	static func fromString(string: String) -> Border? {
		if string.characters.count != 8 {
			return nil
		}
		
		var values = [UInt32](count: 8, repeatedValue: 0)
		for i in (0 ... 7) {
			let str = String(Array(string.characters)[i])
			values[i] = str.unicodeScalars.first!.value
		}
		return fromArray(values)
	}
}

// For dimensions
typealias Size = (rows: Int, columns: Int)

struct Terminal {
	
	// Cannot be initialized; only class functions.
	private init() {}
	
	// What is the current terminal size?
	static func size() -> Size {
		return (Int(LINES), Int(COLS))
	}
	
	// Does the terminal support a specific key?
	static func supportsKey(key: Int) -> Bool {
		return has_key(Int32(key)) == OK
	}
	
	// Does the terminal support color mode?
	static func supportsColors() -> Bool {
		return has_colors()
	}
	
	// Does the terminal support changing the colors?
	static func canChangeColors() -> Bool {
		return can_change_color()
	}
	
	static func startColors() {
		if Terminal.supportsColors() {
			start_color()
			use_default_colors()
		}
	}
}