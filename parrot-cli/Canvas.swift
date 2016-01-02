import Darwin.ncurses

/* TODO: Scrolling, Lines, Menus and Forms...? */
/* TODO: Use mvwinnstr instead of scanning or reading. */
/* TODO: Switch to pads instead of windows for offscreen size. */

// del char, get char

private extension Array where Element : Equatable {
	mutating func removeObject(object : Generator.Element) {
		if let index = self.indexOf(object) {
			self.removeAtIndex(index)
		}
	}
}

class Canvas {
	
	// Underlying structures that communicate with ncurses.
	private var window: COpaquePointer
	private var panel: UnsafeMutablePointer<PANEL>
	private var isRoot = false
	
	// Indicates current size and location on screen.
	var frame: Frame {
		get {
			let bx = getbegx(self.window), by = getbegy(self.window)
			let mx = getmaxx(self.window), my = getmaxy(self.window)
			return (x: Int(bx), y: Int(by), w: Int(mx - bx), h: Int(my - by))
		}
		set(frame) {
			let newWindow = newwin(Int32(frame.h), Int32(frame.w), Int32(frame.y), Int32(frame.x))
			overwrite(self.window, newWindow)
			replace_panel(self.panel, newWindow)
			delwin(self.window)
			self.window = newWindow
		}
	}
	var origin: Point {
		get {
			return (x: self.frame.x, y: self.frame.y)
		}
		set(point) {
			move_panel(self.panel, Int32(point.y), Int32(point.x))
			self.refresh(soft: true)
		}
	}
	var cursor: Point {
		get {
			return (x: Int(getcurx(self.window)), y: Int(getcury(self.window)))
		}
		set(new) {} // possibly move cursor later
	}
	
	// Forms a Canvas tree hierarchy.
	let parent: Canvas?
	let children: [Canvas] = [Canvas]()
	
	// TODO: Attributes.
	var attributes: [Attribute] = [Attribute]()
	
	// The border pattern, which once set will refresh and display the canvas.
	var border: Border = Border.none() {
		didSet {
			wattron(self.window, COLOR_PAIR(self.borderColor.rawValue))
			wborder(self.window,
				self.border.leftSide, self.border.rightSide,
				self.border.topSide, self.border.bottomSide,
				self.border.topLeft, self.border.topRight,
				self.border.bottomLeft, self.border.bottomRight)
			wattroff(self.window, COLOR_PAIR(self.borderColor.rawValue))
			self.refresh()
		}
	}
	
	// The border color, which once set will refresh and display the canvas.
	var borderColor: ColorPair = ColorPair(0) {
		didSet {
			wattron(self.window, COLOR_PAIR(self.borderColor.rawValue))
			wborder(self.window,
				self.border.leftSide, self.border.rightSide,
				self.border.topSide, self.border.bottomSide,
				self.border.topLeft, self.border.topRight,
				self.border.bottomLeft, self.border.bottomRight)
			wattroff(self.window, COLOR_PAIR(self.borderColor.rawValue))
			self.refresh()
		}
	}
	
	// The redraw handler is called whenever an event occurs that needs redrawing.
	// It's also called when it's first set or when the terminal resizes.
	var redraw: (Canvas) -> Void = {c in} {
		didSet {
			self.needsRedraw()
		}
	}
	
	// The root of the Canvas hierarchy. Cannot be modified.
	static let root = Canvas(window: stdscr)
	
	// If frame isn't specified, or given as (0, 0, 0, 0) it'll fill the screen.
	// If parent isn't specified, the mainWindow will be used as parent.
	init(_ frame: Frame = (0, 0, 0, 0), parent: Canvas? = nil) {
		self.window = newwin(Int32(frame.h), Int32(frame.w), Int32(frame.y), Int32(frame.x))
		self.panel = new_panel(self.window)
		
		self.parent = parent ?? Canvas.root
		self.parent!.children.append(self)
		
		keypad(self.window, true)
		self.refresh(soft: true)
	}
	
	// ONLY for Canvas.root!
	private init(window: COpaquePointer) {
		self.window = window
		self.panel = new_panel(self.window)
		
		self.parent = nil
		self.isRoot = true
		
		keypad(self.window, true)
		self.refresh(soft: true)
	}
	
	deinit {
		delwin(self.window)
		del_panel(self.panel)
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
	// If soft is true, wrefresh() isn't called. Panels are updated.
	func refresh(clear: Bool = false, soft: Bool = false) {
		if clear {
			wclear(self.window)
		}
		if !soft {
			wrefresh(self.window)
		}
		update_panels()
		doupdate()
	}
	
	// Writes a string or a single character if the string is only that long.
	// If a point is specified, it writes to that point in the window.
	func write(string: String, point: Point? = nil, colors: ColorPair? = nil) -> Bool {
		var result: Int32 = 0
		let _p = (point ?? self.cursor)!, p = (x: Int32(_p.x), y: Int32(_p.y))
		if let colors = colors {
			wattron(self.window, COLOR_PAIR(colors.rawValue))
		}
		
		if string.characters.count == 1 {
			let ch = string.unicodeScalars.first!.value
			result = mvwaddch(self.window, p.y, p.x, ch)
		} else {
			result = mvwaddstr(self.window, p.y, p.x, string)
		}
		
		if let colors = colors {
			wattroff(self.window, COLOR_PAIR(colors.rawValue))
		}
		self.refresh()
		return result == OK
	}
	
	// Scans a format string from the window at the current location.
	// If a point is specified, the window cursor is moved there first.
	func scan(fmt: UnsafeMutablePointer<Int8>, va: CVaListPointer, point: Point? = nil) -> Bool {
		let _p = (point ?? self.cursor)!, p = (x: Int32(_p.x), y: Int32(_p.y))
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
		return KeyCode(r)
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
	
	// Allows the subcanvas heirarchy to redraw itself.
	func needsRedraw() {
		if self.isRoot {
			// Canvas.origin also HAS to resize.
			//self.frame = (0, 0, Terminal.size().w, Terminal.size().h)
		}
		
		// Handle border and borderColor.
		wattron(self.window, COLOR_PAIR(self.borderColor.rawValue))
		wborder(self.window,
			self.border.leftSide, self.border.rightSide,
			self.border.topSide, self.border.bottomSide,
			self.border.topLeft, self.border.topRight,
			self.border.bottomLeft, self.border.bottomRight)
		wattroff(self.window, COLOR_PAIR(self.borderColor.rawValue))
		
		self.redraw(self)
		self.refresh()
		for cv in self.children {
			cv.needsRedraw()
		}
	}
}
