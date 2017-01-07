import Foundation

// range 0..<string.length
//      -addBold:inRange:
//      -addFg:inRange:
//      -addBg:inRange:

public struct AttributedString: ExpressibleByStringLiteral {
    
    public let string: String
    public private(set) var boldRanges: CountableRange<Int>
    
    public init(_ value: String) {
        self.string = String(value)
        self.boldRanges = 0..<self.string.unicodeScalars.count - 1
    }
    
    public init(unicodeScalarLiteral value: UnicodeScalar) {
        self.init(String(value))
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public mutating func add(bold: Bool, in range: CountableRange<Int>) {
        
    }
}
