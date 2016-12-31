// from @dduan: https://github.com/dduan/Termbox

public struct Key: Equatable {

    let rawValue: UInt16

    // Key constants. See also struct tb_event's Key field.
    //
    // These are a safe subset of terminfo Keys, which exist on all popular
    // terminals. Termbox uses only them to stay truly portable.
    //
    public static let f1               = Key(rawValue: 0xffff-0)
    public static let f2               = Key(rawValue: 0xffff-1)
    public static let f3               = Key(rawValue: 0xffff-2)
    public static let f4               = Key(rawValue: 0xffff-3)
    public static let f5               = Key(rawValue: 0xffff-4)
    public static let f6               = Key(rawValue: 0xffff-5)
    public static let f7               = Key(rawValue: 0xffff-6)
    public static let f8               = Key(rawValue: 0xffff-7)
    public static let f9               = Key(rawValue: 0xffff-8)
    public static let f10              = Key(rawValue: 0xffff-9)
    public static let f11              = Key(rawValue: 0xffff-10)
    public static let f12              = Key(rawValue: 0xffff-11)
    public static let insert           = Key(rawValue: 0xffff-12)
    public static let delete           = Key(rawValue: 0xffff-13)
    public static let home             = Key(rawValue: 0xffff-14)
    public static let end              = Key(rawValue: 0xffff-15)
    public static let pageUp           = Key(rawValue: 0xffff-16)
    public static let pageDown         = Key(rawValue: 0xffff-17)
    public static let arrowUp          = Key(rawValue: 0xffff-18)
    public static let arrowDown        = Key(rawValue: 0xffff-19)
    public static let arrowLeft        = Key(rawValue: 0xffff-20)
    public static let arrowRight       = Key(rawValue: 0xffff-21)
    public static let mouseLeft        = Key(rawValue: 0xffff-22)
    public static let mouseRight       = Key(rawValue: 0xffff-23)
    public static let mouseMiddle      = Key(rawValue: 0xffff-24)
    public static let mouseRelease     = Key(rawValue: 0xffff-25)
    public static let mouseWheelUp     = Key(rawValue: 0xffff-26)
    public static let mouseWheelDown   = Key(rawValue: 0xffff-27)

    // These are all ASCII code points below SPACE character and a BACKSPACE
    // key.
    public static let ctrlTilde        = Key(rawValue: 0x00)
    public static let ctrl2            = Key(rawValue: 0x00)
    public static let ctrlA            = Key(rawValue: 0x01)
    public static let ctrlB            = Key(rawValue: 0x02)
    public static let ctrlC            = Key(rawValue: 0x03)
    public static let ctrlD            = Key(rawValue: 0x04)
    public static let ctrlE            = Key(rawValue: 0x05)
    public static let ctrlF            = Key(rawValue: 0x06)
    public static let ctrlG            = Key(rawValue: 0x07)
    public static let backPace         = Key(rawValue: 0x08)
    public static let ctrlH            = Key(rawValue: 0x08)
    public static let tab              = Key(rawValue: 0x09)
    public static let ctrlI            = Key(rawValue: 0x09)
    public static let ctrlJ            = Key(rawValue: 0x0a)
    public static let ctrlK            = Key(rawValue: 0x0b)
    public static let ctrlL            = Key(rawValue: 0x0c)
    public static let enter            = Key(rawValue: 0x0d)
    public static let ctrlM            = Key(rawValue: 0x0d)
    public static let ctrlN            = Key(rawValue: 0x0e)
    public static let ctrlO            = Key(rawValue: 0x0f)
    public static let ctrlP            = Key(rawValue: 0x10)
    public static let ctrlQ            = Key(rawValue: 0x11)
    public static let ctrlR            = Key(rawValue: 0x12)
    public static let ctrlS            = Key(rawValue: 0x13)
    public static let ctrlT            = Key(rawValue: 0x14)
    public static let ctrlU            = Key(rawValue: 0x15)
    public static let ctrlV            = Key(rawValue: 0x16)
    public static let ctrlW            = Key(rawValue: 0x17)
    public static let ctrlX            = Key(rawValue: 0x18)
    public static let ctrlY            = Key(rawValue: 0x19)
    public static let ctrlZ            = Key(rawValue: 0x1a)
    public static let esc              = Key(rawValue: 0x1b)
    public static let ctrlLeftBracket  = Key(rawValue: 0x1b)
    public static let ctrl3            = Key(rawValue: 0x1b)
    public static let ctrl4            = Key(rawValue: 0x1c)
    public static let ctrlBackslash    = Key(rawValue: 0x1c)
    public static let ctrl5            = Key(rawValue: 0x1d)
    public static let ctrlRightRracket = Key(rawValue: 0x1d)
    public static let ctrl6            = Key(rawValue: 0x1e)
    public static let ctrl7            = Key(rawValue: 0x1f)
    public static let ctrlSlash        = Key(rawValue: 0x1f)
    public static let ctrlUnderscore   = Key(rawValue: 0x1f)
    public static let space            = Key(rawValue: 0x20)
    public static let backspace2       = Key(rawValue: 0x7f)
    public static let ctrl8            = Key(rawValue: 0x7f)

    public static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}


/// Attributes, it is possible to use multiple attributes by combining them
/// using bitwise OR ('|'). Although, colors cannot be combined. But you can
/// combine attributes and a single color. See also `Cell`'s `foreground` and
/// `background` fields.
public struct Attributes: OptionSet {
    public let rawValue: UInt16

    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    // colors
    public static let `default` = Attributes(rawValue: 0x00)
    public static let black     = Attributes(rawValue: 0x01)
    public static let red       = Attributes(rawValue: 0x02)
    public static let green     = Attributes(rawValue: 0x03)
    public static let yellow    = Attributes(rawValue: 0x04)
    public static let blue      = Attributes(rawValue: 0x05)
    public static let magenta   = Attributes(rawValue: 0x06)
    public static let cyan      = Attributes(rawValue: 0x07)
    public static let white     = Attributes(rawValue: 0x08)

    // other
    public static let bold      = Attributes(rawValue: 0x0100)
    public static let underline = Attributes(rawValue: 0x0200)
    public static let reverse   = Attributes(rawValue: 0x0400)
}

/// Typealias of `tb_cell` with Swift version of the attributes.
///
/// A cell, single conceptual entity on the terminal screen. The terminal screen
/// is basically a 2d array of cells. It has the following fields:
///  - 'ch' is a unicode character
///  - 'fg' foreground color and attributes
///  - 'bg' background color and attributes
///
public typealias Cell = tb_cell
public extension Cell {
    /// Creates a cell with a character, foreground and background.
    public init(character: UnicodeScalar, foreground: Attributes = .default,
        background: Attributes = .default)
    {
        self.ch = character.value
        self.fg = foreground.rawValue
        self.bg = background.rawValue
    }

    public var character: UnicodeScalar {
        get {
            return UnicodeScalar(self.ch)!
        }
        set {
            self.ch = newValue.value
        }
    }

    public var foreground: Attributes {
        get {
            return Attributes(rawValue: self.fg)
        }
        set {
            self.fg = newValue.rawValue
        }
    }

    public var background: Attributes {
        get {
            return Attributes(rawValue: self.bg)
        }
        set {
            self.bg = newValue.rawValue
        }
    }
}

public enum Modifier: UInt8 {
    case alt         = 0x01
    case mouseMotion = 0x02
}

/// User interaction event.
public enum Event {

    case key(modifier: Modifier?, value: Key)
    case character(modifier: Modifier?, value: UnicodeScalar)
    case resize(width: Int32, height: Int32)
    case mouse(x: Int32, y: Int32)
    case timeout

    init?(_ tbEvent: tb_event) {
        switch tbEvent.type {
        case 1:
            if tbEvent.ch == 0 {
                self = .key(modifier: Modifier(rawValue: tbEvent.mod),
                            value: Key(rawValue: tbEvent.key))
            } else {
                self = .character(modifier: Modifier(rawValue: tbEvent.mod),
                                  value: UnicodeScalar(tbEvent.ch)!)
            }
        case 2:
            self = .resize(width: tbEvent.w, height: tbEvent.h)
        case 3:
            self = .mouse(x: tbEvent.x, y: tbEvent.y)
        default:
            return nil
        }
    }
}

/// Errors from initialization. All of them are self-explanatory, except
/// the pipe trap error. Termbox uses unix pipes in order to deliver a message
/// from a signal handler (SIGWINCH) to the main event reading loop.
public enum InitializationError: Error {
    case unsupportedTerminal
    case failedToOpenTTY
    case pipeTrapError
    case unknown(code: Int)

    init?(_ code: Int32) {
        switch code {
        case 0..<Int32.max:
            return nil
        case -1:
            self = .unsupportedTerminal
        case -2:
            self = .failedToOpenTTY
        case -3:
            self = .pipeTrapError
        default:
            self = .unknown(code: Int(code))
        }
    }
}

public struct InputModes: OptionSet {
    public let rawValue: Int32

    public init(rawValue: Int32) { self.rawValue = rawValue }

    public static let esc     = InputModes(rawValue: 1)
    public static let alt     = InputModes(rawValue: 2)
    public static let mouse   = InputModes(rawValue: 4)
}

public enum OutputMode: Int32 {
    case normal    = 1
    case color256  = 2
    case color216  = 3
    case grayscale = 4
}

public struct Termbox {
    /// Initializes the termbox library. This function should be called before
    /// any other functions. Function initialize is same as
    /// `initialize(file: "/dev/tty")`.  After successful initialization, the
    /// library must be finalized using the `shutdown()` function.
    public static func initialize() throws {
        if let error = InitializationError(tb_init()) {
            throw error
        }
    }

    public static func initialize(file: String) throws {
        if let error = InitializationError(tb_init_file(file)) {
            throw error
        }
    }

    public static func initialize(fileDescriptor: Int32) throws {
        if let error = InitializationError(tb_init_fd(fileDescriptor)) {
            throw error
        }
    }

    public static func shutdown() {
        tb_shutdown()
    }

    /// Returns the size of the internal back buffer (which is the same as
    /// terminal's window size in characters). The internal buffer can be
    /// resized after `clear()` or `present()` function calls. Both
    /// dimensions have an unspecified negative value when called before
    /// initialization or after shutdown.
    public static var width: Int32 {
        return Int32(tb_width())
    }

    public static var height: Int32 {
        return Int32(tb_height())
    }

    /// Clears the internal back buffer using default color.
    public static func clear() {
        tb_clear()
    }

    /// Clears the internal back buffer using specified color/attributes.
    public static func clear(withForeground foreground: Attributes,
        background: Attributes)
    {
        tb_set_clear_attributes(foreground.rawValue, background.rawValue)
    }

    /// Synchronizes the internal back buffer with the terminal.
    public static func present() {
        tb_present()
    }

    /// Sets the position of the cursor. Upper-left character is (0, 0). If you
    /// pass (-1, -1) to hide the curser. Cursor is hidden by default.
    public static func setCursor(x: Int32, y: Int32) {
        tb_set_cursor(x, y)
    }

    /// Hide the cursor. Equivalent to `setCursor(x: -1, y: -1)`.
    public static func hideCursor() {
        tb_set_cursor(-1, -1)
    }

    /// Changes cell's parameters in the internal back buffer at the specified
    /// position.
    public static func put(x: Int32, y: Int32, cell: Cell) {
        var cell = cell
        tb_put_cell(x, y, &cell)
    }

    /// Changes cell's parameters in the internal back buffer at the specified
    /// position.
    public static func put(x: Int32, y: Int32, character: UnicodeScalar,
        foreground: Attributes = .default, background: Attributes = .default)
    {
        tb_change_cell(x, y, character.value, foreground.rawValue,
                       background.rawValue)
    }

    /// Returns a pointer to internal cell back buffer. You can get its
    /// dimensions using `width` and `height`. The pointer stays
    /// valid as long as no `clear()` and `present()` calls are made. The
    /// buffer is one-dimensional buffer containing lines of cells starting from
    /// the top.
    public static var unsafeCellBuffer: UnsafeMutableBufferPointer<Cell> {
        return UnsafeMutableBufferPointer(start: tb_cell_buffer(),
                                          count: Int(self.width * self.height))
    }

    /// The termbox input mode. Termbox has two input modes:
    /// 1. Esc input mode.  When ESC sequence is in the buffer and it doesn't
    ///    match any known ESC sequence => ESC means `Key.esc`.
    /// 2. Alt input mode.  When ESC sequence is in the buffer and it doesn't
    ///    match any known sequence => ESC enables Modifier.alt modifier for the
    ///    next keyboard event.
    ///
    /// You can also apply `.mouse` via OR operation to either of
    /// the modes (e.g. .esc | .mouse). If none of the main two modes were set,
    /// but the mouse mode was, `.esc` mode is used. If for
    /// some reason you've decided to use (.esc | .alt)
    /// combination, it will behave as if only .esc was selected.
    ///
    ///
    /// Default termbox input mode is `.esc`.

    public static var inputModes: InputModes {
        get {
            return InputModes(rawValue: tb_select_input_mode(0))
        }
        set {
            tb_select_input_mode(newValue.rawValue)
        }
    }

    // Sets the termbox output mode. Termbox has three output options:
    // 1. normal     => [1..8]
    //    This mode provides 8 different colors:
    //      black, red, green, yellow, blue, magenta, cyan, white
    //    Shortcut: TB_BLACK, TB_RED, ...
    //    Attributes: TB_BOLD, TB_UNDERLINE, TB_REVERSE
    //
    //    Example usage:
    //        tb_change_cell(x, y, '@', TB_BLACK | TB_BOLD, TB_RED);
    //
    // 2. color256        => [0..256]
    //    In this mode you can leverage the 256 terminal mode:
    //    0x00 - 0x07: the 8 colors as in TB_OUTPUT_NORMAL
    //    0x08 - 0x0f: TB_* | TB_BOLD
    //    0x10 - 0xe7: 216 different colors
    //    0xe8 - 0xff: 24 different shades of grey
    //
    //    Example usage:
    //        tb_change_cell(x, y, '@', 184, 240);
    //        tb_change_cell(x, y, '@', 0xb8, 0xf0);
    //
    // 2. color        => [0..216]
    //    This mode supports the 3rd range of the 256 mode only.
    //    But you don't need to provide an offset.
    //
    // 3. greyscale  => [0..23]
    //    This mode supports the 4th range of the 256 mode only.
    //    But you dont need to provide an offset.
    //
    // Default termbox output mode is `.normal`.
    //
    public static var outputMode: OutputMode {
        get {
            return OutputMode(rawValue: tb_select_output_mode(0))!
        }
        set {
            tb_select_output_mode(newValue.rawValue)
        }
    }

    /// Wait for an event up to 'timeout' milliseconds and fill the 'event'
    /// structure with it, when the event is available.
    public static func peekEvent(timoutInMilliseconds timeout: Int32)
        -> Event?
    {
        var tbEvent = tb_event()
        switch tb_peek_event(&tbEvent, timeout) {
        case 0:
            return .timeout
        default:
            return Event(tbEvent)
        }
    }

    // Wait for an event forever and fill the 'event' structure with it when the
    // event is available.
    public static func pollEvent() -> Event? {
        var tbEvent = tb_event()
        tb_poll_event(&tbEvent)
        return Event(tbEvent)
    }
}

