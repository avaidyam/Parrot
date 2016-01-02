import Darwin.ncurses

// For dimensions of various things.
typealias Point = (x: Int, y: Int)
typealias Size = (w: Int, h: Int)
typealias Frame = (x: Int, y: Int, w: Int, h: Int)

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
	
	static let Down = KeyCode(rawValue: KEY_DOWN)
	static let Up = KeyCode(rawValue: KEY_UP)
	static let Left = KeyCode(rawValue: KEY_LEFT)
	static let Right = KeyCode(rawValue: KEY_RIGHT)
	static let Home = KeyCode(rawValue: KEY_HOME)
	static let Backspace =  KeyCode(rawValue: KEY_BACKSPACE)
	static let Function0 =  KeyCode(rawValue: KEY_F0)
	static let DeleteLine = KeyCode(rawValue: KEY_DL)
	static let InsertLine = KeyCode(rawValue: KEY_IL)
	static let DeleteCharacter = KeyCode(rawValue: KEY_DC)
	static let InsertCharacter = KeyCode(rawValue: KEY_IC)
	static let EnterInsertMode = KeyCode(rawValue: KEY_EIC)
	static let Clear = KeyCode(rawValue: KEY_CLEAR)
	static let ClearScreen = KeyCode(rawValue: KEY_EOS)
	static let ClearLine = KeyCode(rawValue: KEY_EOL)
	static let ScrollForward = KeyCode(rawValue: KEY_SF)
	static let ScrollReverse = KeyCode(rawValue: KEY_SR)
	static let NextPage = KeyCode(rawValue: KEY_NPAGE)
	static let PreviousPage = KeyCode(rawValue: KEY_PPAGE)
	static let SetTab = KeyCode(rawValue: KEY_STAB)
	static let ClearTab = KeyCode(rawValue: KEY_CTAB)
	static let ClearAllTabs = KeyCode(rawValue: KEY_CATAB)
	static let Enter = KeyCode(rawValue: KEY_ENTER)
	static let Print = KeyCode(rawValue: KEY_PRINT)
	static let HomeKeypad = KeyCode(rawValue: KEY_LL)
	static let UpperLeftKeypad = KeyCode(rawValue: KEY_A1)
	static let UpperRightKeypad = KeyCode(rawValue: KEY_A3)
	static let CenterKeypad = KeyCode(rawValue: KEY_B2)
	static let LowerLeftKeypad = KeyCode(rawValue: KEY_C1)
	static let LowerRightKeypad = KeyCode(rawValue: KEY_C3)
	static let BackTab = KeyCode(rawValue: KEY_BTAB)
	static let Begin = KeyCode(rawValue: KEY_BEG)
	static let Cancel = KeyCode(rawValue: KEY_CANCEL)
	static let Close = KeyCode(rawValue: KEY_CLOSE)
	static let Command = KeyCode(rawValue: KEY_COMMAND)
	static let Copy = KeyCode(rawValue: KEY_COPY)
	static let Create = KeyCode(rawValue: KEY_CREATE)
	static let End = KeyCode(rawValue: KEY_END)
	static let Exit = KeyCode(rawValue: KEY_EXIT)
	static let Find = KeyCode(rawValue: KEY_FIND)
	static let Help = KeyCode(rawValue: KEY_HELP)
	static let Mark = KeyCode(rawValue: KEY_MARK)
	static let Message = KeyCode(rawValue: KEY_MESSAGE)
	static let Move = KeyCode(rawValue: KEY_MOVE)
	static let Next = KeyCode(rawValue: KEY_NEXT)
	static let Open = KeyCode(rawValue: KEY_OPEN)
	static let Options = KeyCode(rawValue: KEY_OPTIONS)
	static let Previous = KeyCode(rawValue: KEY_PREVIOUS)
	static let Redo = KeyCode(rawValue: KEY_REDO)
	static let Reference = KeyCode(rawValue: KEY_REFERENCE)
	static let Refresh = KeyCode(rawValue: KEY_REFRESH)
	static let Replace = KeyCode(rawValue: KEY_REPLACE)
	static let Restart = KeyCode(rawValue: KEY_RESTART)
	static let Resume = KeyCode(rawValue: KEY_RESUME)
	static let Save = KeyCode(rawValue: KEY_SAVE)
	static let ShiftedBegin = KeyCode(rawValue: KEY_SBEG)
	static let ShiftedCancel = KeyCode(rawValue: KEY_SCANCEL)
	static let ShiftedCommand = KeyCode(rawValue: KEY_SCOMMAND)
	static let ShiftedCopy = KeyCode(rawValue: KEY_SCOPY)
	static let ShiftedCreate = KeyCode(rawValue: KEY_SCREATE)
	static let ShiftedDeleteCharacter = KeyCode(rawValue: KEY_SDC)
	static let ShiftedDeleteLine = KeyCode(rawValue: KEY_SDL)
	static let Select = KeyCode(rawValue: KEY_SELECT)
	static let ShiftedEnd = KeyCode(rawValue: KEY_SEND)
	static let ShiftedClearLine = KeyCode(rawValue: KEY_SEOL)
	static let ShiftedExit = KeyCode(rawValue: KEY_SEXIT)
	static let ShiftedFind = KeyCode(rawValue: KEY_SFIND)
	static let ShiftedHelp = KeyCode(rawValue: KEY_SHELP)
	static let ShiftedHome = KeyCode(rawValue: KEY_SHOME)
	static let ShiftedInsertCharacter = KeyCode(rawValue: KEY_SIC)
	static let ShiftedLeft = KeyCode(rawValue: KEY_SLEFT)
	static let ShiftedMessage = KeyCode(rawValue: KEY_SMESSAGE)
	static let ShiftedMove = KeyCode(rawValue: KEY_SMOVE)
	static let ShiftedNext = KeyCode(rawValue: KEY_SNEXT)
	static let ShiftedOptions = KeyCode(rawValue: KEY_SOPTIONS)
	static let ShiftedPrevious = KeyCode(rawValue: KEY_SPREVIOUS)
	static let ShiftedPrint = KeyCode(rawValue: KEY_SPRINT)
	static let ShiftedRedo = KeyCode(rawValue: KEY_SREDO)
	static let ShiftedReplace = KeyCode(rawValue: KEY_SREPLACE)
	static let ShiftedRight = KeyCode(rawValue: KEY_SRIGHT)
	static let ShiftedResume = KeyCode(rawValue: KEY_SRSUME)
	static let ShiftedSave = KeyCode(rawValue: KEY_SSAVE)
	static let ShiftedSuspend = KeyCode(rawValue: KEY_SSUSPEND)
	static let ShiftedUndo = KeyCode(rawValue: KEY_SUNDO)
	static let Suspend = KeyCode(rawValue: KEY_SUSPEND)
	static let Undo = KeyCode(rawValue: KEY_UNDO)
	static let Mouse = KeyCode(rawValue: KEY_MOUSE)
	static let Resize = KeyCode(rawValue: KEY_RESIZE)
	static let F1 = KeyCode(rawValue: KEY_F0 + 1)
	static let F2 = KeyCode(rawValue: KEY_F0 + 2)
	static let F3 = KeyCode(rawValue: KEY_F0 + 3)
	static let F4 = KeyCode(rawValue: KEY_F0 + 4)
	static let F5 = KeyCode(rawValue: KEY_F0 + 5)
	static let F6 = KeyCode(rawValue: KEY_F0 + 6)
	static let F7 = KeyCode(rawValue: KEY_F0 + 7)
	static let F8 = KeyCode(rawValue: KEY_F0 + 8)
	static let F9 = KeyCode(rawValue: KEY_F0 + 9)
	static let F10 = KeyCode(rawValue: KEY_F0 + 10)
	static let F11 = KeyCode(rawValue: KEY_F0 + 11)
	static let F12 = KeyCode(rawValue: KEY_F0 + 12)
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
	
	// Using a string of spaces shows no border.
	static func `default`() -> Border {
		return create("        ")
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
