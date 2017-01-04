import Dispatch
// [modified] from @dduan: https://github.com/dduan/Termbox

/// User interaction event.
public enum Event {
    
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
    
    public enum Modifier: UInt8 {
        case alt         = 0x01
        case mouseMotion = 0x02
    }

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
    
    /// Wait for an event up to 'timeout' milliseconds and fill the 'event'
    /// structure with it, when the event is available.
    public static func peek(timeout: Int32) -> Event? {
        var tbEvent = tb_event()
        switch tb_peek_event(&tbEvent, timeout) {
        case 0: return .timeout
        default: return Event(tbEvent)
        }
    }
    
    // Wait for an event forever and fill the 'event' structure with it when the
    // event is available.
    public static func poll() -> Event? {
        var tbEvent = tb_event()
        tb_poll_event(&tbEvent)
        return Event(tbEvent)
    }
}
