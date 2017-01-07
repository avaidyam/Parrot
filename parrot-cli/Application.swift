import Foundation

public struct Termbox {
    
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
    
    public struct InputMode: OptionSet {
        public let rawValue: Int32
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        
        public static let esc     = InputMode(rawValue: 1)
        public static let alt     = InputMode(rawValue: 2)
        public static let mouse   = InputMode(rawValue: 4)
    }
    
    public enum OutputMode: Int32 {
        case normal    = 1
        case color256  = 2
        case color216  = 3
        case grayscale = 4
    }
    
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
    
    public static func app(inputMode: InputMode = [], outputMode: OutputMode = .normal, _ handler: () -> ()) {
        do {
            try Termbox.initialize()
            Termbox.inputMode = inputMode
            Termbox.outputMode = outputMode
            
            handler()
        } catch let error {
            Termbox.shutdown()
            print(error)
        }
        defer {
            Termbox.shutdown()
        }
    }
    
    /// Sets the position of the cursor. Upper-left character is (0, 0). If you
    /// pass (-1, -1) to hide the curser. Cursor is hidden by default.
    public static var cursor: Point = Point(x: -1, y: -1) {
        didSet { tb_set_cursor(Int32(cursor.x), Int32(cursor.y)) }
    }
    
    /// Returns the size of the internal back buffer (which is the same as
    /// terminal's window size in characters). The internal buffer can be
    /// resized after `clear()` or `present()` function calls. Both
    /// dimensions have an unspecified negative value when called before
    /// initialization or after shutdown.
    public static var size: Size {
        return Size(width: Int(tb_width()), height: Int(tb_height()))
    }
    
    /// Clears the internal back buffer using specified color/attributes.
    public static func clear(foreground: Attributes = .default, background: Attributes = .default) {
        tb_set_clear_attributes(foreground.rawValue, background.rawValue)
        tb_clear()
    }
    
    /// Synchronizes the internal back buffer with the terminal.
    public static func refresh() {
        tb_present()
    }
    
    /// Changes cell's parameters in the internal back buffer at the specified
    /// position.
    public static func put(at: Point, cell: Cell) {
        tb_change_cell(Int32(at.x), Int32(at.y), cell.character.value,
                       cell.foreground.rawValue, cell.background.rawValue)
    }
    
    /// Returns a pointer to internal cell back buffer. You can get its
    /// dimensions using `width` and `height`. The pointer stays
    /// valid as long as no `clear()` and `present()` calls are made. The
    /// buffer is one-dimensional buffer containing lines of cells starting from
    /// the top.
    public static var unsafeCellBuffer: UnsafeMutableBufferPointer<tb_cell> {
        return UnsafeMutableBufferPointer(start: tb_cell_buffer(),
                                          count: self.size.width * self.size.height)
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
    
    public static var inputMode: InputMode {
        get { return InputMode(rawValue: tb_select_input_mode(0)) }
        set { tb_select_input_mode(newValue.rawValue) }
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
        get { return OutputMode(rawValue: tb_select_output_mode(0))! }
        set { tb_select_output_mode(newValue.rawValue) }
    }
}
