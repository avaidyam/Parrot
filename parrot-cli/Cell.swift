import Foundation

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
