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
// ServiceRequest/Response
//

/// Defines a protobuf message used as an RPC request.
internal protocol ServiceRequest: ProtoMessage {
    
    /// Links the protobuf message used as the response to this request.
    associatedtype Response: ServiceResponse
    
    /// Specifies the remote location this RPC request should be sent to.
    static var location: String { get }
    
    /// The client-sent header describing the RPC request.
    var request_header: RequestHeader? { get set }
}

/// Defines a protobuf message used as an RPC response.
internal protocol ServiceResponse: ProtoMessage {
    
    /// The server-sent header describing the RPC response.
    var response_header: ResponseHeader? { get set }
}


/// An error that may occur during Service RPC transmission.
public enum ServiceError: Error {
    
    /// The server returned an error (status code and description).
    case server(ResponseStatus, String)
    
    /// An unknown error occurred during RPC transmission.
    case unknown
}

//
// Hashable Utils
//

typealias Hash = Int

// Generate 64-bit random value in a range that is divisible by upper_bound:
// from @martin-r: http://stackoverflow.com/questions/26549830/swift-random-number-for-64-bit-integers
func random64(_ upper_bound: UInt64) -> UInt64 {
    let range = UInt64.max - UInt64.max % upper_bound
    var rnd: UInt64 = 0
    repeat {
        arc4random_buf(&rnd, MemoryLayout.size(ofValue: rnd))
    } while rnd >= range
    return rnd % upper_bound
}

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

//
//
//

// Convert a microsecond timestamp to an Date instance.
// Convert UTC datetime to microsecond timestamp used by Hangouts.
private let MicrosecondsPerSecond: Double = 1000000.0
extension Date {
    init(UTC: UInt64?) {
        self = Date(timeIntervalSince1970: (Double(UTC ?? 0) / MicrosecondsPerSecond))
    }
    func toUTC() -> UInt64 {
        return UInt64(self.timeIntervalSince1970 * MicrosecondsPerSecond)
    }
}
