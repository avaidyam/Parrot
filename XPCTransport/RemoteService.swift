import Dispatch

public protocol RemoteRequestable {
    associatedtype Request: Codable
}
public protocol RemoteRespondable {
    associatedtype Response: Codable
}
public protocol RemoteThrowable {
    associatedtype ErrorType: Codable, Error
}

/// func method()
public protocol RemoteMethod: RemoteMethodBase {}
/// func method(Self.Request)
public protocol RequestingMethod: RemoteMethodBase, RemoteRequestable {}
/// func method() -> Self.Response
public protocol RespondingMethod: RemoteMethodBase, RemoteRespondable {}
/// func method() throws[Self.ErrorType]
public protocol ThrowingMethod: RemoteMethodBase, RemoteThrowable {}
/// func method(Self.Request) throws[Self.ErrorType]
public protocol RequestingThrowingMethod: RemoteMethodBase, RemoteRequestable, RemoteThrowable {}
/// func method() throws[Self.ErrorType] -> Self.Response
public protocol RespondingThrowingMethod: RemoteMethodBase, RemoteRespondable, RemoteThrowable {}
/// func method(Self.Request) -> Self.Response
public protocol RequestingRespondingMethod: RemoteMethodBase, RemoteRequestable, RemoteRespondable {}
/// func method(Self.Request) throws[Self.ErrorType] -> Self.Response
public protocol RequestingRespondingThrowingMethod: RemoteMethodBase, RemoteRequestable, RemoteRespondable, RemoteThrowable {}

public enum RemoteServiceError: Error {
    case invalidSync
}

public protocol RemoteService {
    func async<RMI: RemoteMethod>(_: RMI.Type) throws
        where RMI.Service == Self
    func async<RMI: RequestingMethod>(_: RMI.Type, with: RMI.Request) throws
        where RMI.Service == Self
    func async<RMI: RespondingMethod>(_: RMI.Type, response: @escaping (RMI.Response) -> ()) throws
        where RMI.Service == Self
    func async<RMI: ThrowingMethod>(_: RMI.Type, response: @escaping (RMI.ErrorType?) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RequestingThrowingMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.ErrorType?) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RespondingThrowingMethod>(_: RMI.Type, response: @escaping (RMI.Response?, RMI.ErrorType?) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RequestingRespondingMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Response) -> ()) throws
        where RMI.Service == Self
    func async<RMI: RequestingRespondingThrowingMethod>(_: RMI.Type, with: RMI.Request, response: @escaping (RMI.Response?, RMI.ErrorType?) -> ()) throws
        where RMI.Service == Self
    
    func sync<RMI: RemoteMethod>(_: RMI.Type) throws
        where RMI.Service == Self
    func sync<RMI: RequestingMethod>(_: RMI.Type, with: RMI.Request) throws
        where RMI.Service == Self
    func sync<RMI: RespondingMethod>(_: RMI.Type) throws -> RMI.Response
        where RMI.Service == Self
    func sync<RMI: ThrowingMethod>(_: RMI.Type) throws -> RMI.ErrorType?
        where RMI.Service == Self
    func sync<RMI: RequestingThrowingMethod>(_: RMI.Type, with: RMI.Request) throws -> RMI.ErrorType?
        where RMI.Service == Self
    func sync<RMI: RespondingThrowingMethod>(_: RMI.Type) throws -> (RMI.Response?, RMI.ErrorType?)
        where RMI.Service == Self
    func sync<RMI: RequestingRespondingMethod>(_: RMI.Type, with: RMI.Request) throws -> RMI.Response
        where RMI.Service == Self
    func sync<RMI: RequestingRespondingThrowingMethod>(_: RMI.Type, with: RMI.Request) throws -> (RMI.Response?, RMI.ErrorType?)
        where RMI.Service == Self
}

/// Will never be instantiated.
public protocol RemoteSubsystem {
    associatedtype ParentService: RemoteService
    static var qualifiedName: String { get }
}

/// Will never be instantiated.
public protocol RemoteMethodBase {
    associatedtype Subsystem: RemoteSubsystem where Self.Subsystem.ParentService == Self.Service
    associatedtype Service
    
    static var qualifiedName: String { get }
}

public extension RemoteSubsystem {
    static var qualifiedName: String {
        return "\(type(of: self))".components(separatedBy: ".").first!
    }
}

public extension RemoteMethodBase {
    static var qualifiedName: String {
        return "\(type(of: self))".components(separatedBy: ".").first!
    }
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
        guard response != nil else { throw RemoteServiceError.invalidSync }
        return response!
    }
    
    public func sync<RMI: ThrowingMethod>(_ rmi: RMI.Type) throws -> RMI.ErrorType? where RMI.Service == Self {
        var response: (RMI.ErrorType?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { throw RemoteServiceError.invalidSync }
        return response!
    }
    
    public func sync<RMI: RequestingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> RMI.ErrorType? where RMI.Service == Self {
        var response: (RMI.ErrorType?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi, with: request) {
            response = $0
            s.signal()
        }
        s.wait()
        guard response != nil else { throw RemoteServiceError.invalidSync }
        return response!
    }
    
    public func sync<RMI: RespondingThrowingMethod>(_ rmi: RMI.Type) throws -> (RMI.Response?, RMI.ErrorType?) where RMI.Service == Self {
        var response: (RMI.Response?, RMI.ErrorType?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi) {
            response = ($0, $1)
            s.signal()
        }
        s.wait()
        guard response != nil else { throw RemoteServiceError.invalidSync }
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
        guard response != nil else { throw RemoteServiceError.invalidSync }
        return response!
    }
    
    public func sync<RMI: RequestingRespondingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws -> (RMI.Response?, RMI.ErrorType?) where RMI.Service == Self {
        var response: (RMI.Response?, RMI.ErrorType?)? = nil
        let s = DispatchSemaphore(value: 0)
        try self.async(rmi, with: request) {
            response = ($0, $1)
            s.signal()
        }
        s.wait()
        guard response != nil else { throw RemoteServiceError.invalidSync }
        return response!
    }
}


//
//
//


public struct ChatService: RemoteService {
    public func async<RMI: RemoteMethod>(_ rmi: RMI.Type) throws where RMI.Service == ChatService {
        
    }
    
    public func async<RMI: RequestingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws where RMI.Service == ChatService {
        
    }
    
    public func async<RMI: RespondingMethod>(_ rmi: RMI.Type, response: @escaping (RMI.Response) -> ()) throws where RMI.Service == ChatService {
        
    }
    
    public func async<RMI: ThrowingMethod>(_ rmi: RMI.Type, response: @escaping (RMI.ErrorType?) -> ()) throws where RMI.Service == ChatService {
        
    }
    
    public func async<RMI: RequestingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request, response: @escaping (RMI.ErrorType?) -> ()) throws where RMI.Service == ChatService {
        
    }
    
    public func async<RMI: RespondingThrowingMethod>(_ rmi: RMI.Type, response: @escaping (RMI.Response?, RMI.ErrorType?) -> ()) throws where RMI.Service == ChatService {
        
    }
    
    public func async<RMI: RequestingRespondingMethod>(_ rmi: RMI.Type, with request: RMI.Request, response: @escaping (RMI.Response) -> ()) throws where RMI.Service == ChatService {
        
    }
    
    public func async<RMI: RequestingRespondingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request, response: @escaping (RMI.Response?, RMI.ErrorType?) -> ()) throws where RMI.Service == ChatService {
        
    }
}

public struct AuthenticationSubsystem: RemoteSubsystem {
    private init() {}
    public typealias ParentService = ChatService
}

public struct LoggingSubsystem: RemoteSubsystem {
    private init() {}
    public typealias ParentService = ChatService
}

public enum AuthenticationError: Int, Error, Codable {
    case failed
}

public struct AuthenticateInvocation: RequestingRespondingThrowingMethod {
    private init() {}
    
    public typealias Subsystem = AuthenticationSubsystem
    public typealias Service = ChatService
    
    public typealias Request = String
    public typealias Response = String
    public typealias ErrorType = AuthenticationError
}

func tester() throws {
    let service = ChatService()
    (_, _) = try service.sync(AuthenticateInvocation.self, with: "test")
    
}
