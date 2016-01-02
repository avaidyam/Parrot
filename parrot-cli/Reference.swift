import Darwin.ncurses

// For dimensions of various things.
typealias Point = (x: Int, y: Int)
typealias Size = (w: Int, h: Int)
typealias Frame = (p: Point, s: Size)

// For percentage-based dimensions of various things.
// Finds the % slice of any bounds.
func slice(bounds: (Int, Int), percent: Double) -> Int {
	return 0 // TODO
}

// Returns the midpoint of a dimension
func mid(item: Int) -> Int {
	return (item / 2) - 1
}

func center(item: Int, _ inset: Int) -> Int {
	return (item / 2) - (inset / 2)
}

// Returns a frame padded by the given X/Y padding.
func pad(frame: Frame, _ pad: Size) -> Frame {
	return (p: (x: frame.p.x + pad.w, y: frame.p.y + pad.h),
		s: (w: frame.s.w - (2 * pad.w), h: frame.s.h - (2 * pad.h)))
}

// For RGB components.
typealias RGB = (R: Double, G: Double, B: Double)

// For Foreground/Background values.
typealias FB = (F: Color, B: Color)

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

// A set of extended characters for NCurses terminal support.
// This mess seriously reeks of the 1980s...
struct ExtendedCharacters {
	let rawValue: UInt32
	
	private init(rawValue: UInt32) {
		self.rawValue = rawValue
	}
	
	static let UpperLeftCorner = ExtendedCharacters(rawValue: _ULCORNER())
	static let LowerLeftCorner = ExtendedCharacters(rawValue: _LLCORNER())
	static let UpperRightCorner = ExtendedCharacters(rawValue: _URCORNER())
	static let LowerRightCorner = ExtendedCharacters(rawValue: _LRCORNER())
	static let LeftTee = ExtendedCharacters(rawValue: _LTEE())
	static let RightTee = ExtendedCharacters(rawValue: _RTEE())
	static let BottomTee = ExtendedCharacters(rawValue: _BTEE())
	static let TopTee = ExtendedCharacters(rawValue: _TTEE())
	static let HorizontalLine = ExtendedCharacters(rawValue: _HLINE())
	static let VerticalLine = ExtendedCharacters(rawValue: _VLINE())
	static let Plus = ExtendedCharacters(rawValue: _PLUS())
	static let ScanLine1 = ExtendedCharacters(rawValue: _S1())
	static let ScanLine9 = ExtendedCharacters(rawValue: _S9())
	static let Diamond = ExtendedCharacters(rawValue: _DIAMOND())
	static let Checkerboard = ExtendedCharacters(rawValue: _CKBOARD())
	static let Degree = ExtendedCharacters(rawValue: _DEGREE())
	static let PlusMinus = ExtendedCharacters(rawValue: _PLMINUS())
	static let Bullet = ExtendedCharacters(rawValue: _BULLET())
	static let LeftArrow = ExtendedCharacters(rawValue: _LARROW())
	static let RightArrow = ExtendedCharacters(rawValue: _RARROW())
	static let DownArrow = ExtendedCharacters(rawValue: _DARROW())
	static let UpArrow = ExtendedCharacters(rawValue: _UARROW())
	static let Board = ExtendedCharacters(rawValue: _BOARD())
	static let Lantern = ExtendedCharacters(rawValue: _LANTERN())
	static let Block = ExtendedCharacters(rawValue: _BLOCK())
}

struct KeyCode {
	let rawValue: Int32
	
	init(_ rawValue: Int32) {
		self.rawValue = rawValue
	}
	
	// Can also be initialized with a character.
	init(_ charValue: Character) {
		self.rawValue = Int32(String(charValue).unicodeScalars.first!.value)
	}
	
	static let Down = KeyCode(KEY_DOWN)
	static let Up = KeyCode(KEY_UP)
	static let Left = KeyCode(KEY_LEFT)
	static let Right = KeyCode(KEY_RIGHT)
	static let Home = KeyCode(KEY_HOME)
	static let Backspace =  KeyCode(KEY_BACKSPACE)
	static let Function0 =  KeyCode(KEY_F0)
	static let DeleteLine = KeyCode(KEY_DL)
	static let InsertLine = KeyCode(KEY_IL)
	static let DeleteCharacter = KeyCode(KEY_DC)
	static let InsertCharacter = KeyCode(KEY_IC)
	static let EnterInsertMode = KeyCode(KEY_EIC)
	static let Clear = KeyCode(KEY_CLEAR)
	static let ClearScreen = KeyCode(KEY_EOS)
	static let ClearLine = KeyCode(KEY_EOL)
	static let ScrollForward = KeyCode(KEY_SF)
	static let ScrollReverse = KeyCode(KEY_SR)
	static let NextPage = KeyCode(KEY_NPAGE)
	static let PreviousPage = KeyCode(KEY_PPAGE)
	static let SetTab = KeyCode(KEY_STAB)
	static let ClearTab = KeyCode(KEY_CTAB)
	static let ClearAllTabs = KeyCode(KEY_CATAB)
	static let Enter = KeyCode(KEY_ENTER)
	static let Print = KeyCode(KEY_PRINT)
	static let HomeKeypad = KeyCode(KEY_LL)
	static let UpperLeftKeypad = KeyCode(KEY_A1)
	static let UpperRightKeypad = KeyCode(KEY_A3)
	static let CenterKeypad = KeyCode(KEY_B2)
	static let LowerLeftKeypad = KeyCode(KEY_C1)
	static let LowerRightKeypad = KeyCode(KEY_C3)
	static let BackTab = KeyCode(KEY_BTAB)
	static let Begin = KeyCode(KEY_BEG)
	static let Cancel = KeyCode(KEY_CANCEL)
	static let Close = KeyCode(KEY_CLOSE)
	static let Command = KeyCode(KEY_COMMAND)
	static let Copy = KeyCode(KEY_COPY)
	static let Create = KeyCode(KEY_CREATE)
	static let End = KeyCode(KEY_END)
	static let Exit = KeyCode(KEY_EXIT)
	static let Find = KeyCode(KEY_FIND)
	static let Help = KeyCode(KEY_HELP)
	static let Mark = KeyCode(KEY_MARK)
	static let Message = KeyCode(KEY_MESSAGE)
	static let Move = KeyCode(KEY_MOVE)
	static let Next = KeyCode(KEY_NEXT)
	static let Open = KeyCode(KEY_OPEN)
	static let Options = KeyCode(KEY_OPTIONS)
	static let Previous = KeyCode(KEY_PREVIOUS)
	static let Redo = KeyCode(KEY_REDO)
	static let Reference = KeyCode(KEY_REFERENCE)
	static let Refresh = KeyCode(KEY_REFRESH)
	static let Replace = KeyCode(KEY_REPLACE)
	static let Restart = KeyCode(KEY_RESTART)
	static let Resume = KeyCode(KEY_RESUME)
	static let Save = KeyCode(KEY_SAVE)
	static let ShiftedBegin = KeyCode(KEY_SBEG)
	static let ShiftedCancel = KeyCode(KEY_SCANCEL)
	static let ShiftedCommand = KeyCode(KEY_SCOMMAND)
	static let ShiftedCopy = KeyCode(KEY_SCOPY)
	static let ShiftedCreate = KeyCode(KEY_SCREATE)
	static let ShiftedDeleteCharacter = KeyCode(KEY_SDC)
	static let ShiftedDeleteLine = KeyCode(KEY_SDL)
	static let Select = KeyCode(KEY_SELECT)
	static let ShiftedEnd = KeyCode(KEY_SEND)
	static let ShiftedClearLine = KeyCode(KEY_SEOL)
	static let ShiftedExit = KeyCode(KEY_SEXIT)
	static let ShiftedFind = KeyCode(KEY_SFIND)
	static let ShiftedHelp = KeyCode(KEY_SHELP)
	static let ShiftedHome = KeyCode(KEY_SHOME)
	static let ShiftedInsertCharacter = KeyCode(KEY_SIC)
	static let ShiftedLeft = KeyCode(KEY_SLEFT)
	static let ShiftedMessage = KeyCode(KEY_SMESSAGE)
	static let ShiftedMove = KeyCode(KEY_SMOVE)
	static let ShiftedNext = KeyCode(KEY_SNEXT)
	static let ShiftedOptions = KeyCode(KEY_SOPTIONS)
	static let ShiftedPrevious = KeyCode(KEY_SPREVIOUS)
	static let ShiftedPrint = KeyCode(KEY_SPRINT)
	static let ShiftedRedo = KeyCode(KEY_SREDO)
	static let ShiftedReplace = KeyCode(KEY_SREPLACE)
	static let ShiftedRight = KeyCode(KEY_SRIGHT)
	static let ShiftedResume = KeyCode(KEY_SRSUME)
	static let ShiftedSave = KeyCode(KEY_SSAVE)
	static let ShiftedSuspend = KeyCode(KEY_SSUSPEND)
	static let ShiftedUndo = KeyCode(KEY_SUNDO)
	static let Suspend = KeyCode(KEY_SUSPEND)
	static let Undo = KeyCode(KEY_UNDO)
	static let Mouse = KeyCode(KEY_MOUSE)
	static let Resize = KeyCode(KEY_RESIZE)
	static let F1 = KeyCode(KEY_F0 + 1)
	static let F2 = KeyCode(KEY_F0 + 2)
	static let F3 = KeyCode(KEY_F0 + 3)
	static let F4 = KeyCode(KEY_F0 + 4)
	static let F5 = KeyCode(KEY_F0 + 5)
	static let F6 = KeyCode(KEY_F0 + 6)
	static let F7 = KeyCode(KEY_F0 + 7)
	static let F8 = KeyCode(KEY_F0 + 8)
	static let F9 = KeyCode(KEY_F0 + 9)
	static let F10 = KeyCode(KEY_F0 + 10)
	static let F11 = KeyCode(KEY_F0 + 11)
	static let F12 = KeyCode(KEY_F0 + 12)
}

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

struct Border {
	let leftSide: UInt32
	let rightSide: UInt32
	let topSide: UInt32
	let bottomSide: UInt32
	
	let topLeft: UInt32
	let topRight: UInt32
	let bottomLeft: UInt32
	let bottomRight: UInt32
	
	// Using an array of zeros shows the default border.
	static func `default`() -> Border {
		return create([0, 0, 0, 0, 0, 0, 0, 0])
	}
	
	// Using an array of spaces shows no border.
	static func none() -> Border {
		return create([32, 32, 32, 32, 32, 32, 32, 32])
	}
	
	// Creates a Border from an array of 8 elements.
	// Components must follow the same order as the above variables!
	static func create(var values: [UInt32]) -> Border {
		if values.count != 8 {
			values = [32, 32, 32, 32, 32, 32, 32, 32]
		}
		return Border(leftSide: values[0], rightSide: values[1],
			topSide: values[2], bottomSide: values[3],
			topLeft: values[4], topRight: values[5],
			bottomLeft: values[6], bottomRight: values[7])
	}
	
	// Creates a Border from a string of 8 characters.
	// Components must follow the same order as the above variables!
	static func create(var string: String) -> Border {
		if string.characters.count != 8 {
			string = "        " // 8 spaces
		}
		
		var values = [UInt32](count: 8, repeatedValue: 0)
		for i in (0 ... 7) {
			let str = String(Array(string.characters)[i])
			values[i] = str.unicodeScalars.first!.value
		}
		return create(values)
	}
}
