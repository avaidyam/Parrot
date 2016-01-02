import Darwin.ncurses

/* TODO: Panels, Menus, Forms... */

extension Array where Element : Equatable {
	mutating func removeObject(object : Generator.Element) {
		if let index = self.indexOf(object) {
			self.removeAtIndex(index)
		}
	}
}

class Canvas {
	var frame: Frame = (0, 0, 0, 0)
	var subwindows: [Canvas] = [Canvas]()
	var attributes: [Attribute] = [Attribute]()
	var border: Border = Border.`default`()
	var hasKeypad: Bool = true
	var window: COpaquePointer = nil
	var panel: UnsafeMutablePointer<PANEL> = nil
	
	static let origin = Canvas(window: stdscr)
	
	// If frame isn't specified, or given as (0, 0, 0, 0) it'll fill the screen.
	// If parent isn't specified, the mainWindow will be used as parent.
	init?(_ frame: Frame = (0, 0, 0, 0), parent: Canvas? = nil) {
		self.window = newwin(Int32(frame.h), Int32(frame.w), Int32(frame.y), Int32(frame.x))
		if self.window == nil {
			return nil
		}
		
		self.frame = frame
		keypad(self.window, true) // TODO: Wire into Terminal instead.
		self.panel = new_panel(self.window)
		(parent ?? Canvas.origin)?.subwindows.append(self)
		update_panels()
		doupdate()
	}
	
	// ONLY for Canvas.origin use!
	private init(window: COpaquePointer) {
		self.window = window
		keypad(self.window, true) // TODO: Wire into Terminal instead.
		self.panel = new_panel(self.window)
		self.frame = (0, 0, 0, 0)
		update_panels()
		doupdate()
	}
	
	deinit {
		delwin(self.window)
		del_panel(self.panel)
	}
	
	func cursor() -> Point {
		return (x: Int(getcurx(self.window)), y: Int(getcury(self.window)))
	}
	
	func move(frame: Frame) -> Bool {
		let newWindow = newwin(Int32(frame.h), Int32(frame.w), Int32(frame.y), Int32(frame.x))
		if newWindow == nil {
			return false
		}
		
		overwrite(self.window, newWindow)
		replace_panel(self.panel, newWindow)
		delwin(self.window)
		self.window = newWindow
		return true
	}
	
	func move(point: Point) -> Bool {
		let result = move_panel(self.panel, Int32(point.y), Int32(point.x))
		if result == OK {
			self.frame.x = point.x
			self.frame.y = point.y
		}
		
		update_panels()
		doupdate()
		return result == OK
	}
	
	func enableKeypad(flag: Bool) {
		keypad(self.window, flag ? true : false)
		self.hasKeypad = flag
	}
	
	/* TODO: Support ColorPairs here too! */
	
	func enableAttributes(attrs: [Attribute]) {
		for attr in attrs {
			wattron(self.window, attr.rawValue);
			self.attributes.append(attr)
		}
	}
	
	func disableAttributes(attrs: [Attribute]) {
		for attr in attrs {
			wattroff(self.window, attr.rawValue);
			self.attributes.removeObject(attr)
		}
	}
	
	func setAttributes(attrs: [Attribute]) {
		var sum: Int32 = 0
		for attr in attrs {
			sum |= attr.rawValue
		}
		
		wattrset(self.window, sum)
		self.attributes = attrs
	}
	
	func clearAttributes() {
		wattrset(self.window, Attribute.Normal.rawValue)
	}
	
	// If clear is true, the window is cleared and then refreshed.
	func refresh(clear: Bool = false) {
		if clear {
			wclear(self.window)
		}
		wrefresh(self.window)
		update_panels()
		doupdate()
	}
	
	func setBorder(string: String) {
		self.setBorder(Border.create(string))
	}
	
	func setBorder(border: Border? = nil) {
		let b = border ?? Border.`default`()
		wborder(self.window, b.leftSide, b.rightSide, b.topSide, b.bottomSide,
			b.topLeft, b.topRight, b.bottomLeft, b.bottomRight)
		self.border = b
		self.refresh()
	}
	
	// Writes a string or a single character if the string is only that long.
	// If a point is specified, it writes to that point in the window.
	func write(string: String, point: Point? = nil) -> Bool {
		var result: Int32 = 0
		let _p = (point ?? cursor())!, p = (x: Int32(_p.x), y: Int32(_p.y))
		if string.characters.count == 1 {
			let ch = string.unicodeScalars.first!.value
			result = mvwaddch(self.window, p.y, p.x, ch)
		} else {
			result = mvwaddstr(self.window, p.y, p.x, string)
		}
		self.refresh()
		return result == OK
	}
	
	// Scans a format string from the window at the current location.
	// If a point is specified, the window cursor is moved there first.
	func scan(fmt: UnsafeMutablePointer<Int8>, va: CVaListPointer, point: Point? = nil) -> Bool {
		let _p = (point ?? cursor())!, p = (x: Int32(_p.x), y: Int32(_p.y))
		if wmove(self.window, p.y, p.x) == OK {
			return vwscanw(self.window, fmt, va) == OK
		}
		return false
	}
	
	func readKeyCode(point: Point? = nil) -> KeyCode {
		var r: Int32 = 0
		if let p = point {
			r = mvwgetch(self.window, Int32(p.y), Int32(p.x))
		} else {
			r = wgetch(self.window)
		}
		return KeyCode(rawValue: r)
	}
	
	func readString(point: Point? = nil) -> String? {
		if let _p = point {
			let p = (x: Int32(_p.x), y: Int32(_p.y))
			if wmove(self.window, p.y, p.x) == ERR {
				return nil
			}
		}
		
		var chars = [UnicodeScalar]()
		while true {
			let c = wgetch(self.window)
			if c == ERR || c == 10 /* \n */ || c == EOF {
				break
			}
			chars.append(UnicodeScalar(Int(c)))
		}
		return String(chars)
	}
}
