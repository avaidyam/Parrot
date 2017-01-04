import Foundation

public typealias Point = (x: Int, y: Int)
public typealias Size = (width: Int, height: Int)
public typealias Rect = (origin: Point, size: Size)

// For percentage-based dimensions of various things.
typealias Slicer = (x: Double, y: Double)

// Finds the % slice of any frame.
func slice(_ s: Slicer, _ f: Rect) -> Rect {
    return (origin: f.origin, size: (Int(Double(f.size.width - f.origin.x) * s.x),
                                     Int(Double(f.size.height - f.origin.y) * s.y)))
}

func shift(_ f: Rect, _ p: Point) -> Rect {
    var q = f
    q.origin.y += p.y
    q.size.height -= p.y
    q.origin.x += p.x
    q.size.width -= p.x
    return q
}

// Returns the midpoint of a dimension
func mid(_ item: Int) -> Int {
    return (item / 2) - 1
}
func center(_ item: Int, _ inset: Int) -> Int {
    return (item / 2) - (inset / 2)
}

// Returns a frame padded by the given X/Y padding.
func pad(_ frame: Rect, _ pad: Size) -> Rect {
    return (origin: (x: frame.origin.x + pad.width, y: frame.origin.y + pad.height),
            size: (width: frame.size.width - (2 * pad.width), height: frame.size.height - (2 * pad.height)))
}

let runes: [UInt32] = [
    0x20,   // ' '
    0x2591, // '░'
    0x2592, // '▒'
    0x2593, // '▓'
    0x2588, // '█'
]

public extension String {
    
    // Let's see how that works with a function that prints a line of text:
    /// - Parameters:
    ///   - at:         (x,y) location of the text.
    ///   - foreground: what attributes should the text have for its foreground.
    ///   - background: what attributes should the text have for its background.
    public func draw(at pt: Point, foreground: Attributes = .default, background: Attributes = .default) {
        guard pt.y < Termbox.size.height else { return }
        
        // We can update characters on the screen one at a time with, each with a
        // distinct style. Here we are going to start at `x` and set characters in
        // `text` until we run out of horizontal space in row `y`.
        for (c, xi) in zip(self.unicodeScalars, pt.x..<Termbox.size.width) {
            Termbox.put(x: Int32(xi), y: Int32(pt.y), character: c,
                        foreground: foreground, background: background)
        }
    }
}

public func drawBorder(_ rect: Rect, foreground: Attributes = .default, background: Attributes = .default) {
    for i in 1..<rect.size.height-1 {
        Termbox.put(x: Int32(rect.origin.x), y: Int32(i), character: "║",
                    foreground: foreground, background: background)
        Termbox.put(x: Int32(rect.size.width - 1), y: Int32(i), character: "║",
                    foreground: foreground, background: background)
    }
    for i in 1..<rect.size.width-1 {
        Termbox.put(x: Int32(i), y: Int32(rect.origin.y), character: "═",
                    foreground: foreground, background: background)
        Termbox.put(x: Int32(i), y: Int32(rect.size.height - 1), character: "═",
                    foreground: foreground, background: background)
    }
    Termbox.put(x: Int32(rect.origin.x), y: Int32(rect.origin.y), character: "╔",
                foreground: foreground, background: background)
    Termbox.put(x: Int32(rect.size.width - 1), y: Int32(rect.origin.y), character: "╗",
                foreground: foreground, background: background)
    Termbox.put(x: Int32(rect.origin.x), y: Int32(rect.size.height - 1), character: "╚",
                foreground: foreground, background: background)
    Termbox.put(x: Int32(rect.size.width - 1), y: Int32(rect.size.height - 1), character: "╝",
                foreground: foreground, background: background)
}
