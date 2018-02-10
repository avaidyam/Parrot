import Dispatch

// TODO: RemoteError: Codable
// TODO: RemoteValue = a promise-like type that wraps an async send()
// TODO: Swap recv(...) to yield a closure that can return instead of forcing a return inline

/// An `Error` that is also `Codable`-conformant.
public typealias CodableError = Codable & Error

/// An `Error` that originated at a remote source.
public enum RemoteError: Error /*CodableError*/ {
    
    case invalid
    case wrapped(CodableError)
    
    // TODO: Ambiguous reference to `decode(_:forKey:)` and `encode(_:forKey:)`.
    /*
    private enum CodingKeys: CodingKey {
        case type
        case underlyingError
    }
    
    private enum UnderlyingRemoteError: Int, Codable {
        case invalid
        case wrapped
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(UnderlyingRemoteError.self, forKey: .type)
        switch type {
        case .invalid:
            self = .invalid
        case .wrapped:
            let type = try container.decode(CodableError.self, forKey: .underlyingError)
            self = .wrapped(type)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .invalid:
            try container.encode(UnderlyingRemoteError.invalid, forKey: .type)
        case .wrapped(let value):
            try container.encode(UnderlyingRemoteError.wrapped, forKey: .type)
            try container.encode(value, forKey: .underlyingError)
        }
    }
 */
}

/// Will never be instantiated.
public protocol RemoteService {
    
}

/// Will never be instantiated.
public protocol RemoteMethod {
    //associatedtype Service: RemoteService
    associatedtype Request
    associatedtype Response
    associatedtype Error
    
    static var options: [AnyHashable: Any] { get }
}

public extension RemoteMethod {
    public static var options: [AnyHashable: Any] { return [:] }
    public static var qualifiedName: String {
        return "\(type(of: self))".components(separatedBy: ".").joined(separator: "/")
    }
}

public protocol RemoteConnection {
    func async<RMI: RemoteMethod>(_: RMI.Type) throws
        where RMI.Request == Void, RMI.Response == Void, RMI.Error == Void
    func async<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request) throws
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error == Void
    func async<RMI: RemoteMethod>(_: RMI.Type, response: @escaping (RMI.Response) -> ()) throws
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error == Void
    func async<RMI: RemoteMethod>(_: RMI.Type, response: @escaping (RMI.Error?) -> ()) throws
        where RMI.Request == Void, RMI.Response == Void, RMI.Error: CodableError
    func async<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Error?) -> ()) throws
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error: CodableError
    func async<RMI: RemoteMethod>(_: RMI.Type, response: @escaping (RMI.Response?, RMI.Error?) -> ()) throws
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error: CodableError
    func async<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Response) -> ()) throws
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error == Void
    func async<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Response?, RMI.Error?) -> ()) throws
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error: CodableError
    
    func sync<RMI: RemoteMethod>(_: RMI.Type) throws
        where RMI.Request == Void, RMI.Response == Void, RMI.Error == Void
    func sync<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request) throws
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error == Void
    func sync<RMI: RemoteMethod>(_: RMI.Type) throws -> RMI.Response
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error == Void
    func sync<RMI: RemoteMethod>(_: RMI.Type) throws -> RMI.Error?
        where RMI.Request == Void, RMI.Response == Void, RMI.Error: CodableError
    func sync<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request) throws -> RMI.Error?
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error: CodableError
    func sync<RMI: RemoteMethod>(_: RMI.Type) throws -> (RMI.Response?, RMI.Error?)
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error: CodableError
    func sync<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request) throws -> RMI.Response
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error == Void
    func sync<RMI: RemoteMethod>(_: RMI.Type, with: RMI.Request) throws -> (RMI.Response?, RMI.Error?)
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error: CodableError
    
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping () throws -> ())
        where RMI.Request == Void, RMI.Response == Void, RMI.Error == Void
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> ())
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error == Void
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping () throws -> (RMI.Response))
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error == Void
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping () throws -> (RMI.Error?))
        where RMI.Request == Void, RMI.Response == Void, RMI.Error: CodableError
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Error?))
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error: CodableError
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping () throws -> (RMI.Response?, RMI.Error?))
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error: CodableError
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response))
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error == Void
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response?, RMI.Error?))
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error: CodableError
}

public extension RemoteConnection {
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type) throws
        where RMI.Request == Void, RMI.Response == Void, RMI.Error == Void
    {
        try self.async(rmi)
    }
    
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error == Void
    {
        try self.async(rmi, with: request)
    }
    
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type) throws -> RMI.Response
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error == Void
    {
        var response: (RMI.Response)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type) throws -> RMI.Error?
        where RMI.Request == Void, RMI.Response == Void, RMI.Error: CodableError
    {
        var response: (RMI.Error?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> RMI.Error?
        where RMI.Request: Codable, RMI.Response == Void, RMI.Error: CodableError
    {
        var response: (RMI.Error?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi, with: request) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type) throws -> (RMI.Response?, RMI.Error?)
        where RMI.Request == Void, RMI.Response: Codable, RMI.Error: CodableError
    {
        var response: (RMI.Response?, RMI.Error?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi) {
            response = ($0, $1)
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> RMI.Response
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error == Void
    {
        var response: RMI.Response? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi, with: request) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> (RMI.Response?, RMI.Error?)
        where RMI.Request: Codable, RMI.Response: Codable, RMI.Error: CodableError
    {
        var response: (RMI.Response?, RMI.Error?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi, with: request) {
            response = ($0, $1)
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
}
