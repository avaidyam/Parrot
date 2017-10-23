import Dispatch

// TODO: RemoteError: Codable
// TODO: RemoteValue = a promise-like type that wraps an async send()
// TODO: Swap recv(...) to yield a closure that can return instead of forcing a return inline
// TODO: Remove RemoteMethodBase.Service --> or make it a static descriptor

public enum RemoteError: Error {//}, Codable {
    
    /*
    private enum CodingKeys: CodingKey {
        case type
        case underlyingError
    }
    
    private enum UnderlyingRemoteError: Int, Codable {
        case invalid
        case wrapped
    }
    */
    
    case invalid
    case wrapped(Error)
    
    /*
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(UnderlyingRemoteError.self, forKey: .type)
        switch type {
        case .invalid:
            self = .invalid
        case .wrapped:
            let type = try container.decodeIfPresent(Error.self, forKey: .underlyingError)
            self = .wrapped(type)
        }
    }
    */
    
    /*
    public func encode(to encoder: Encoder) throws {
     
    }
    */
}

/// Will never be instantiated.
public protocol RemoteMethodBase {
    associatedtype Service
}

public extension RemoteMethodBase {
    public static var qualifiedName: String {
        return "\(type(of: self))".components(separatedBy: ".").joined(separator: "/")
    }
}

public protocol RemoteRequestable {
    associatedtype Request: Codable
}
public protocol RemoteRespondable {
    associatedtype Response: Codable
}
public protocol RemoteThrowable {
    associatedtype Exception: Codable, Error
}

/// func method()
public protocol RemoteMethod: RemoteMethodBase {}
/// func method(Self.Request)
public protocol RequestingMethod: RemoteMethodBase, RemoteRequestable {}
/// func method() -> Self.Response
public protocol RespondingMethod: RemoteMethodBase, RemoteRespondable {}
/// func method() throws[Self.Exception]
public protocol ThrowingMethod: RemoteMethodBase, RemoteThrowable {}
/// func method(Self.Request) throws[Self.Exception]
public protocol RequestingThrowingMethod: RemoteMethodBase, RemoteRequestable, RemoteThrowable {}
/// func method() throws[Self.Exception] -> Self.Response
public protocol RespondingThrowingMethod: RemoteMethodBase, RemoteRespondable, RemoteThrowable {}
/// func method(Self.Request) -> Self.Response
public protocol RequestingRespondingMethod: RemoteMethodBase, RemoteRequestable, RemoteRespondable {}
/// func method(Self.Request) throws[Self.Exception] -> Self.Response
public protocol RequestingRespondingThrowingMethod: RemoteMethodBase, RemoteRequestable, RemoteRespondable, RemoteThrowable {}

public protocol RemoteService {
    func async<RMI: RemoteMethod>(_: RMI.Type) throws
        where RMI.Service == Self
    func async<RMI: RequestingMethod>(_: RMI.Type, with: RMI.Request) throws
        where RMI.Service == Self
    func async<RMI: RespondingMethod>(_: RMI.Type, response: @escaping (RMI.Response) -> ()) throws
        where RMI.Service == Self
    func async<RMI: ThrowingMethod>(_: RMI.Type, response: @escaping (RMI.Exception?) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RequestingThrowingMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Exception?) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RespondingThrowingMethod>(_: RMI.Type, response: @escaping (RMI.Response?, RMI.Exception?) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RequestingRespondingMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Response) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RequestingRespondingThrowingMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Response?, RMI.Exception?) -> ()) throws
        where RMI.Service == Self
    
    func sync<RMI: RemoteMethod>(_: RMI.Type) throws
        where RMI.Service == Self
    func sync<RMI: RequestingMethod>(_: RMI.Type, with: RMI.Request) throws
        where RMI.Service == Self
    func sync<RMI: RespondingMethod>(_: RMI.Type) throws -> RMI.Response
        where RMI.Service == Self
    func sync<RMI: ThrowingMethod>(_: RMI.Type) throws -> RMI.Exception?
        where RMI.Service == Self
    func sync<RMI: RequestingThrowingMethod>(_: RMI.Type, with: RMI.Request) throws -> RMI.Exception?
        where RMI.Service == Self
    func sync<RMI: RespondingThrowingMethod>(_: RMI.Type) throws -> (RMI.Response?, RMI.Exception?)
        where RMI.Service == Self
    func sync<RMI: RequestingRespondingMethod>(_: RMI.Type, with: RMI.Request) throws -> RMI.Response
        where RMI.Service == Self
    func sync<RMI: RequestingRespondingThrowingMethod>(_: RMI.Type, with: RMI.Request) throws -> (RMI.Response?, RMI.Exception?)
        where RMI.Service == Self
    
    func recv<RMI: RemoteMethod>(_: RMI.Type, handler: @escaping () throws -> ())
        where RMI.Service == Self
    func recv<RMI: RequestingMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> ())
        where RMI.Service == Self
    func recv<RMI: RespondingMethod>(_: RMI.Type, handler: @escaping () throws -> (RMI.Response))
        where RMI.Service == Self
    func recv<RMI: ThrowingMethod>(_: RMI.Type, handler: @escaping () throws -> (RMI.Exception?))
        where RMI.Service == Self
    func recv<RMI: RequestingThrowingMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Exception?))
        where RMI.Service == Self
    func recv<RMI: RespondingThrowingMethod>(_: RMI.Type, handler: @escaping () throws -> (RMI.Response?, RMI.Exception?))
        where RMI.Service == Self
    func recv<RMI: RequestingRespondingMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response))
        where RMI.Service == Self
    func recv<RMI: RequestingRespondingThrowingMethod>(_: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response?, RMI.Exception?))
        where RMI.Service == Self
}

public extension RemoteService {
    public func sync<RMI: RemoteMethod>(_ rmi: RMI.Type) throws where RMI.Service == Self {
        try self.async(rmi)
    }
    
    public func sync<RMI: RequestingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws where RMI.Service == Self {
        try self.async(rmi, with: request)
    }
    
    public func sync<RMI: RespondingMethod>(_ rmi: RMI.Type) throws -> RMI.Response where RMI.Service == Self {
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
    
    public func sync<RMI: ThrowingMethod>(_ rmi: RMI.Type) throws -> RMI.Exception? where RMI.Service == Self {
        var response: (RMI.Exception?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RequestingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> RMI.Exception? where RMI.Service == Self {
        var response: (RMI.Exception?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi, with: request) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RespondingThrowingMethod>(_ rmi: RMI.Type) throws -> (RMI.Response?, RMI.Exception?) where RMI.Service == Self {
        var response: (RMI.Response?, RMI.Exception?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi) {
            response = ($0, $1)
            s.signal()
        }
        s.wait()
        guard response != nil else { fatalError("async(...) was not supposed to be nil!") }
        return response!
    }
    
    public func sync<RMI: RequestingRespondingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> RMI.Response where RMI.Service == Self {
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
    
    public func sync<RMI: RequestingRespondingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> (RMI.Response?, RMI.Exception?) where RMI.Service == Self {
        var response: (RMI.Response?, RMI.Exception?)? = nil
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
