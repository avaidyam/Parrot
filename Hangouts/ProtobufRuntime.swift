import Foundation

//
// ProtoEnum
//

public protocol _ProtoEnum: Codable {
    var rawValue: Int { get }
    init(_ rawValue: Int)
}

public protocol ProtoEnum: _ProtoEnum, ExpressibleByIntegerLiteral, RawRepresentable, Hashable {}
public extension ProtoEnum {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    public init?(rawValue value: Int) {
        self.init(value)
    }
    public var hashValue: Int {
        return self.rawValue.hashValue
    }
}

//
// ProtoMessage
//

public protocol _ProtoMessage: Codable {}
extension _ProtoMessage where Self: Hashable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
public typealias ProtoMessage = _ProtoMessage & Hashable

//
// Hashable Utils
//

typealias Hash = Int

@inline(__always)
func magic() -> UInt {
    #if arch(x86_64) || arch(arm64)
        return 0x9e3779b97f4a7c15
    #elseif arch(i386) || arch(arm)
        return 0x9e3779b9
    #endif
}

@inline(__always)
func combine(hashes: [Hash]) -> Hash {
    return hashes.reduce(0, combine(hash:with:))
}

@inline(__always)
func combine(hash initial: Hash, with other: Hash) -> Hash {
    var lhs = UInt(bitPattern: initial)
    let rhs = UInt(bitPattern: other)
    lhs ^= rhs &+ magic() &+ (lhs << 6) &+ (lhs >> 2)
    return Int(bitPattern: lhs)
}

extension Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self.hashValue
    }
}

extension Optional where Wrapped: Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self?.hashValue ?? 0
    }
}

extension Array where Element: Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self.reduce(5381) { ($0 << 5) &+ $0 &+ $1.hashValue }
    }
}

extension Dictionary where Value: Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self.reduce(5381) { combine(hash: $0, with: combine(hash: $1.key.hashValue, with: $1.value.hashValue)) }
    }
}
