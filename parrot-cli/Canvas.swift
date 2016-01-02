import Darwin.ncurses

/* TODO: Scrolling, Lines, Menus and Forms...? */
/* TODO: Use mvwinnstr instead of scanning or reading. */
/* TODO: Maybe use panel_userptr to link back to the Canvas? */
/* TODO: Canvas Attributes don't work. */
/* TODO: Use panel_above and panel_below for Z-order. */
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
	
	// Forms a Canvas tree hierarchy.
	let parent: Canvas?
	let children: [Canvas] = [Canvas]()
	
	// A_BLINK, A_BOLD, A_DIM, A_REVERSE, A_STANDOUT and A_UNDERLINE
	var attributes: [Attribute] = [Attribute]()
	
	// Sets and gets the canvas's current cursor position.
	var cursor: Point {
		get {
			return (x: Int(getcurx(self.window)), y: Int(getcury(self.window)))
		}
		set(new) {
			wmove(self.window, Int32(new.y), Int32(new.x))
		}
	}
	
	// Sets and gets the canvas's origin position.
	var origin: Point {
		get {
			let bx = getbegx(self.window), by = getbegy(self.window)
			return (x: Int(bx), y: Int(by))
		}
		set(origin) {
			move_panel(self.panel, Int32(origin.y), Int32(origin.x))
			self.refresh()
		}
	}
	
	// Sets and gets the canvas's size position.
	var size: Size {
		get {
			let bx = getbegx(self.window), by = getbegy(self.window)
			let mx = getmaxx(self.window), my = getmaxy(self.window)
			return (w: Int(mx - bx), h: Int(my - by))
		}
		set(size) {
			let _pt = self.origin
			let newWindow = newwin(Int32(size.h), Int32(size.w), Int32(_pt.y), Int32(_pt.x))
			overwrite(self.window, newWindow)
			replace_panel(self.panel, newWindow)
			delwin(self.window)
			self.window = newWindow
		}
	}
	
	// Sets and gets the canvas's origin and size together.
	var frame: Frame {
		get {
			let bx = getbegx(self.window), by = getbegy(self.window)
			let mx = getmaxx(self.window), my = getmaxy(self.window)
			return (p: (x: Int(bx), y: Int(by)), s: (w: Int(mx - bx), h: Int(my - by)))
		}
		set(frame) {
			let newWindow = newwin(Int32(frame.s.h), Int32(frame.s.w), Int32(frame.p.y), Int32(frame.p.x))
			overwrite(self.window, newWindow)
			replace_panel(self.panel, newWindow)
			delwin(self.window)
			self.window = newWindow
		}
	}
	
	// Returns the depth of the canvas in the hierarchy.
	var depth: Int {
		get {
			var counter = 0
			var curr_parent: Canvas? = self.parent
			
			// Traverse the canvas hierarchy until the root.
			while true {
				if curr_parent == nil {
					break
				}
				
				curr_parent = self.parent
				counter++
			}
			return counter
		}
	}
	
	// Returns the Z-order of this canvas in relation to its siblings.
	// That is, of the stacked appearance, and not the container depth.
	var zOrder: Int {
		get {
			// Currently there needs to be a way to distinguish z-order from depth.
			// i.e. subviews could be clipped by size, etc.
			return 0
		}
	}
	
	// Allows or disables the Canvas from rendering in the current hierarchy.
	var hidden: Bool {
		get {
			return panel_hidden(self.panel) == 0
		}
		set(hidden) {
			if hidden {
				hide_panel(self.panel)
			} else {
				show_panel(self.panel)
			}
		}
	}
	
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
	init(_ frame: Frame = ((0, 0), (0, 0)), parent: Canvas? = nil) {
		
		// Establish underlying ncurses structures.
		self.window = newwin(Int32(frame.s.h), Int32(frame.s.w), Int32(frame.p.y), Int32(frame.p.x))
		keypad(self.window, true)
		self.panel = new_panel(self.window)
		
		// Establish hierarchy and clear canvas.
		self.parent = parent ?? Canvas.root
		self.parent!.children.append(self)
		self.refresh(clear: true)
	}
	
	// ONLY for Canvas.root!
	private init(window: COpaquePointer) {
		
		// Establish underlying ncurses structures.
		self.window = window
		keypad(self.window, true)
		self.panel = new_panel(self.window)
		
		// Establish hierarchy and clear canvas.
		self.parent = nil
		self.isRoot = true
		self.refresh(clear: true)
	}
	
	deinit {
		del_panel(self.panel)
		delwin(self.window)
	}
	
	// Brings this canvas to the front of the hierarchy (highest Z order).
	// Note that a hidden panel cannot perform this action.
	func bringToFront() {
		top_panel(self.panel)
	}
	
	// Sends this canvas to the back of the hierarchy (lowest Z order).
	// Note that a hidden panel cannot perform this action.
	func sendToBack() {
		bottom_panel(self.panel)
	}
	
	// Scrolls the contents of the canvas vertically by the given amount.
	// Note: if amount is positive, the canvas scrolls up, and vice versa.
	func scrollBy(amount: Int) {
		wscrl(self.window, Int32(amount))
	}
	
	// If clear is true, the window is cleared and then refreshed.
	// If soft is true, wrefresh() isn't called. Panels are updated.
	func refresh(clear clear: Bool = false) {
		if clear {
			wclear(self.window)
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
		result = mvwaddstr(self.window, p.y, p.x, string)
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
		self.refresh(clear: true)
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
		for cv in self.children {
			cv.needsRedraw()
		}
	}
}
