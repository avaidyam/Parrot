import Darwin.ncurses

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
	
	// Default terminal values, initialized when begin() is called.
	private static var _cursesActive = false
	private static var _rawMode = false
	private static var _charBreak = true
	private static var _echoOn = false
	private static var _halfDelay = 0
	
	// Cannot be initialized; only class functions.
	private init() {}
	
	//
	// Terminal Session
	//
	
	// Starts the ncurses session.
	static func begin() -> COpaquePointer {
		let win = initscr()
		noraw()
		cbreak()
		noecho()
		halfdelay(0)
		_cursesActive = true
		return win
	}
	
	// Pause ncurses session to standard terminal.
	static func pause() {
		if _cursesActive {
			def_prog_mode()
			endwin()
			_cursesActive = false
		}
	}
	
	// Resume ncurses session from standard terminal.
	static func resume() {
		if !_cursesActive {
			reset_prog_mode();
			_cursesActive = true
		}
	}
	
	// Ends the ncurses session.
	static func end() {
		endwin();
		_cursesActive = false
	}
	
	// Is there an active ncurses session?
	static func active() -> Bool {
		return _cursesActive
	}
	
	// What is the current terminal size?
	static func size() -> Size {
		return (Int(LINES), Int(COLS))
	}
	
	// Beep the terminal!
	static func bell() {
		beep()
	}
	
	// Does the terminal support a specific key?
	static func supportsKey(key: Int) -> Bool {
		return has_key(Int32(key)) == OK
	}
	
	//
	// Color Properties
	//
	
	// Does the terminal support color mode?
	static func supportsColors() -> Bool {
		return has_colors()
	}
	
	// Does the terminal support changing the colors?
	static func canChangeColors() -> Bool {
		return can_change_color()
	}
	
	// Start color support if possible.
	// Ideally this will be automatic, done by the window.
	static func startColors() {
		if Terminal.supportsColors() {
			start_color()
			use_default_colors()
		}
	}
	
	//
	// Terminal Properties
	//
	
	static func rawMode() -> Bool {
		return _rawMode
	}
	
	static func rawMode(flag: Bool) {
		flag ? raw() : noraw()
		_rawMode = flag
	}
	
	static func characterBreak() -> Bool {
		return _charBreak
	}
	
	static func characterBreak(flag: Bool) {
		flag ? cbreak() : nocbreak()
		_charBreak = flag
	}
	
	static func echoMode() -> Bool {
		return _echoOn
	}
	
	static func echoMode(flag: Bool) {
		flag ? echo() : noecho()
		_echoOn = flag
	}
	
	static func halfDelay() -> Int {
		return _halfDelay
	}
	
	static func halfDelay(value: Int) {
		halfdelay(Int32(value))
		_halfDelay = value
	}
}