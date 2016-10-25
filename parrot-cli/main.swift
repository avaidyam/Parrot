import Hangouts

var curCol: Int32 = 0, curRune: Int32 = 0
var backbuf = [tb_cell]()
var bbw: Int32 = 0, bbh: Int32 = 0

let runes: [UInt32] = [
    0x20, // ' '
    0x2591, // '░'
    0x2592, // '▒'
    0x2593, // '▓'
    0x2588, // '█'
]

let colors: [Int32] = [
    TB_BLACK,
    TB_RED,
    TB_GREEN,
    TB_YELLOW,
    TB_BLUE,
    TB_MAGENTA,
    TB_CYAN,
    TB_WHITE,
]

func updateAndDrawButtons(_ current: inout Int32, _ x: Int32, _ y: Int32, _ mx: Int32, _ my: Int32, _ n: Int32, _ attrFunc: (Int32, inout UInt32, inout UInt16, inout UInt16) -> ()) {
    var lx = x;
    var ly = y;
    for i in 0..<n {
        if (lx <= mx && mx <= lx+3 && ly <= my && my <= ly+1) {
            current = i
        }
        var r: UInt32 = 0
        var fg: UInt16 = 0, bg: UInt16 = 0
        attrFunc(i, &r, &fg, &bg)
        tb_change_cell(lx+0, ly+0, r, fg, bg)
        tb_change_cell(lx+1, ly+0, r, fg, bg)
        tb_change_cell(lx+2, ly+0, r, fg, bg)
        tb_change_cell(lx+3, ly+0, r, fg, bg)
        tb_change_cell(lx+0, ly+1, r, fg, bg)
        tb_change_cell(lx+1, ly+1, r, fg, bg)
        tb_change_cell(lx+2, ly+1, r, fg, bg)
        tb_change_cell(lx+3, ly+1, r, fg, bg)
        lx += 4;
    }
    lx = x;
    ly = y;
    for i in 0..<n {
        if (current == i) {
            let fg: UInt16 = UInt16(TB_RED | TB_BOLD)
            let bg: UInt16 = UInt16(TB_DEFAULT)
            tb_change_cell(lx+0, ly+2, UInt32("^".unicodeScalars.first!), fg, bg)
            tb_change_cell(lx+1, ly+2, UInt32("^".unicodeScalars.first!), fg, bg)
            tb_change_cell(lx+2, ly+2, UInt32("^".unicodeScalars.first!), fg, bg)
            tb_change_cell(lx+3, ly+2, UInt32("^".unicodeScalars.first!), fg, bg)
        }
        lx += 4
    }
}

func runeAttrFunc(_ i: Int32, _ r: inout UInt32, _ fg: inout UInt16, _ bg: inout UInt16) {
    r = runes[Int(i)]
    fg = UInt16(TB_DEFAULT)
    bg = UInt16(TB_DEFAULT)
}

func colorAttrFunc(_ i: Int32, _ r: inout UInt32, _ fg: inout UInt16, _ bg: inout UInt16) {
    r = UInt32(" ".unicodeScalars.first!)
    fg = UInt16(TB_DEFAULT)
    bg = UInt16(colors[Int(i)])
}

func updateAndRedrawAll(_ mx: Int32, _ my: Int32) {
    tb_clear()
    if mx != -1 && my != -1 {
        backbuf[Int(bbw*my+mx)].ch = runes[Int(curRune)]
        backbuf[Int(bbw*my+mx)].fg = UInt16(colors[Int(curCol)])
    }
    memcpy(tb_cell_buffer(), backbuf, Int(MemoryLayout<tb_cell>.size)*Int(bbw)*Int(bbh))
    let h = tb_height()
    updateAndDrawButtons(&curRune, 0, 0, mx, my, Int32(runes.count), runeAttrFunc)
    updateAndDrawButtons(&curCol, 0, h-3, mx, my, Int32(colors.count), colorAttrFunc)
    tb_present();
}

func reallocBackBuffer(_ w: Int32, _ h: Int32) {
    bbw = w; bbh = h
    //if backbuf != nil {
    //    free(&backbuf)
    //}
    //backbuf = UnsafeMutablePointer<tb_cell>.allocate(capacity: )//calloc(sizeof(tb_cell), Int(w)*Int(h))
}

if tb_init() < 0 {
    fatalError("termbox failed to initialize!")
}

tb_select_input_mode(TB_INPUT_ESC | TB_INPUT_MOUSE)
let w: Int32 = tb_width()
let h: Int32 = tb_height()
reallocBackBuffer(w, h)
updateAndRedrawAll(-1, -1)

while true {
    var ev = tb_event()
    var mx: Int32 = -1, my: Int32 = -1
    switch tb_poll_event(&ev) {
    case -1:
        tb_shutdown()
        fatalError("termbox poll event error!")
    case TB_EVENT_KEY:
        if (Int32(ev.key) == TB_KEY_ESC) {
            tb_shutdown(); exit(0)
        }
    case TB_EVENT_MOUSE:
        if (ev.key == /*TB_KEY_MOUSE_LEFT*/(0xFFFF-22)) {
            mx = ev.x; my = ev.y
        }
    case TB_EVENT_RESIZE:
        reallocBackBuffer(ev.w, ev.h)
    default: break
    }
    updateAndRedrawAll(mx, my)
}



/*






*/

/*
let sem = DispatchSemaphore(value: 0)
print("Initializing...")

// Authenticate and initialize the Hangouts client.
// Build the user and conversation lists.
var client: Client!
var userList: UserList!
var conversationList: ConversationList!

AuthenticatorCLI.authenticateClient {
	client = Client(configuration: $0)
	
	client.buildUserConversationList {
		userList = $0; conversationList = $1
		print("Obtained userList \(userList) and conversationList! \(conversationList)")
		sem.signal()
	}
}
_ = sem.wait(timeout: DispatchTime.distantFuture)
print("Continuing...")

print(conversationList.all_conversations.map { $0.conversation.conversationId })

// Start with the constant strings up here.
let str1 = "Parrot is not yet ready as a CLI tool."
let str2 = "Press ESC to exit."


// Launch an encapsulated interactive Terminal.
Terminal.interactive {
	
	// A quick macro that will let us get the padded 1/3 and 2/3 width of the screen.
	// Yes, it's disgusting. Here's what it does:
	//
	// 1. Obtain the current terminal frame.
	// 2. Slice its first third.
	// 3. Pad it by 2 lines horizontally.
	// 4. Squash it down 2 lines vertically.
	//
	// The second macro does the same after calculating the 2/3 slice of the screen.
	// The third macro simply provides a single line header at the top.
	let g: (Void) -> Frame = {
		return shift(f: pad(frame: slice(s: (x: 0.33, y: 1.00), Terminal.size()), (2, 0)), (0, 2))
	}
	let f: (Void) -> Frame = {
		var r = slice(s: (x: 0.33, y: 1.00), Terminal.size())
		var q = slice(s: (x: 0.66, y: 1.00), Terminal.size())
		q.p.x += r.s.w + 1
		q = shift(f: q, (0, 2))
		return q
	}
	let t: (Void) -> Frame = {
		return (p: (x: 0, y: 0), s: (w: Terminal.size().s.w, h: 1))
	}
	
	var sidebar = Canvas(g())
	sidebar.border = Border.`default`()
	sidebar.borderColor = ColorPair(4, colors: (.Magenta, .Black))
	
	// Write our three strings by centering them with specific colors.
	sidebar.redraw = { c in
		
		// Readjust the size of the canvas.
		let str3 = "\(c.frame)"
		c.frame = g()
		
		// Redraw all our strings.
		_ = c.write(string: str2,
			point: (center(item: c.frame.s.w, str2.characters.count), center(item: c.frame.s.h, 0) + 0),
			colors: ColorPair(2, colors: (.Black, .Blue)))
		_ = c.write(string: str3,
			point: (center(item: c.frame.s.w, str3.characters.count), center(item: c.frame.s.h, 0) + 1),
			colors: ColorPair(3, colors: (.Black, .Yellow)))
	}
	
	var content = Canvas(f())
	content.border = Border.`default`()
	content.borderColor = ColorPair(4, colors: (.Magenta, .Black))
	
	// Write our three strings by centering them with specific colors.
	content.redraw = { c in
		
		// Readjust the size of the canvas.
		let str3 = "Debug[size: \(c.frame)]"
		c.frame = f()
		
		// Redraw all our strings.
		_ = c.write(string: str1,
			point: (center(item: c.frame.s.w, str1.characters.count), center(item: c.frame.s.h, 0) + 0),
			colors: ColorPair(1, colors: (.Black, .Red)))
		_ = c.write(string: str3,
			point: (center(item: c.frame.s.w, str3.characters.count), center(item: c.frame.s.h, 0) + 1),
			colors: ColorPair(3, colors: (.Black, .Yellow)))
	}
	
	let title = "PARROT - HANGOUTS"
	var header = Canvas(t())
	header.redraw = { c in
		c.frame = t()
		_ = c.write(string: title,
			point: (center(item: c.frame.s.w, title.characters.count), center(item: c.frame.s.h, 0) + 0),
			colors: ColorPair(6, colors: (.Black, .White)))
	}
	
	// End the program when ESC is pressed.
	Terminal.bell()
	Terminal.wait(key: KeyCode(27))
}

*/
