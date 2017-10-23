import Foundation
import XPC
import os
import ServiceManagement

/// Note: trying to {en,de}code this results in gibberish unless using XPC{En,De}Coder.
public final class XPCConnection: Hashable, Codable, RemoteService {
    
    public enum Error {
        case connectionInterrupted, connectionInvalid, replyInvalid, terminationImminent
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    /// Acts as an intermediate because type-erasure is difficult when you need to use Codable.
    // Note: we don't keep a shared/global {en,de}coder because we'll need threading primitives;
    // the XPC{En,De}coder is lightweight enough that it's not worth locking.
    // But, please use this on a background queue...
    private struct _MessageHandler {
        let requiresReply: Bool
        let handler: (xpc_object_t?) throws -> (xpc_object_t?, xpc_object_t?)
        
        init<RMI: RemoteMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> ()) {
            self.requiresReply = false
            self.handler = { _ in
                try handler()
                return (nil, nil)
            }
        }
        
        init<RMI: RequestingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> ()) {
            self.requiresReply = false
            self.handler = {
                try handler(try XPCDecoder().decode(RMI.Request.self, from: $0!))
                return (nil, nil)
            }
        }
        
        init<RMI: RespondingMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> (RMI.Response)) {
            self.requiresReply = true
            self.handler = { _ in
                let t = try handler()
                return (try XPCEncoder().encode(t), nil)
            }
        }
        
        init<RMI: ThrowingMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> (RMI.Exception?)) {
            self.requiresReply = true
            self.handler = { _ in
                let t = try handler()
                return (nil, t != nil ? try XPCEncoder().encode(t) : nil)
            }
        }
        
        init<RMI: RequestingThrowingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Exception?)) {
            self.requiresReply = true
            self.handler = {
                let t = try handler(try XPCDecoder().decode(RMI.Request.self, from: $0!))
                return (nil, t != nil ? try XPCEncoder().encode(t) : nil)
            }
        }
        
        init<RMI: RespondingThrowingMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> (RMI.Response?, RMI.Exception?)) {
            self.requiresReply = true
            self.handler = { _ in
                let t = try handler()
                return (t.0 != nil ? try XPCEncoder().encode(t.0) : nil,
                        t.1 != nil ? try XPCEncoder().encode(t.1) : nil)
            }
        }
        
        init<RMI: RequestingRespondingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response)) {
            self.requiresReply = true
            self.handler = {
                let t = try handler(try XPCDecoder().decode(RMI.Request.self, from: $0!))
                return (try XPCEncoder().encode(t), nil)
            }
        }
        
        init<RMI: RequestingRespondingThrowingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response?, RMI.Exception?)) {
            self.requiresReply = true
            self.handler = {
                let t = try handler(try XPCDecoder().decode(RMI.Request.self, from: $0!))
                return (t.0 != nil ? try XPCEncoder().encode(t.0) : nil,
                        t.1 != nil ? try XPCEncoder().encode(t.1) : nil)
            }
        }
    }
    
    ///
    public let name: String
    
    ///
    internal var connection: xpc_connection_t! = nil
    
    ///
    internal var replyQueue = DispatchQueue(label: "")
    
    ///
    private var replyHandlers = [String: _MessageHandler]()
    
    /*
     //xpc_connection_create(nil, nil) -> anonymous
     //xpc_connection_send_barrier
     //xpc_connection_cancel + activate
     //xpc_connection_get_euid
     //xpc_connection_get_egid
     //xpc_connection_get_pid
     //xpc_connection_get_asid
     // xpc_dictionary_get_remote_connection ???
     */
    
    // Note: NOP for unconfigured connection.
    public var active: Bool = false {
        didSet {
            guard self.connection != nil else { return }
            if active {
                xpc_connection_resume(self.connection)
            } else {
                xpc_connection_suspend(self.connection)
            }
        }
    }
    
    /// Create an XPCConnection for an existing underlying connection.
    internal init(_ connection: xpc_connection_t) {
        self.connection = connection
        self.name = "<unknown>"//String(cString: xpc_connection_get_name(connection)!)
    }
    
    /// When creating an XPCConnection for an existing underlying connection, the event handler
    /// is not automatically configured; if needed, bootstrap() must be called to do so.
    internal func bootstrap() {
        xpc_connection_set_event_handler(self.connection, self._recv(_:))
        xpc_connection_resume(self.connection)
    }
    
    /// Connect to a service in the local bootstrap domain called `name`.
    /// Wire messages will be serviced on the designated `queue`.
    public init(name: String, on queue: DispatchQueue = DispatchQueue.global(), active: Bool = false) {
        self.name = name
        name.withCString {
            self.connection = xpc_connection_create($0, queue)
        }
        xpc_connection_set_event_handler(self.connection, self._recv(_:))
        if active {
            xpc_connection_resume(self.connection)
        }
    }
    
    /// Connect to a service in the global bootstrap domain called `machName`.
    /// Wire messages will be serviced on the designated `queue`.
    public init(machName: String, on queue: DispatchQueue = DispatchQueue.global(), active: Bool = false) {
        self.name = machName
        name.withCString {
            self.connection = xpc_connection_create_mach_service($0, queue, 0)
        }
        xpc_connection_set_event_handler(self.connection, self._recv(_:))
        if active {
            xpc_connection_resume(self.connection)
        }
    }
    
    /// Connect to a privileged service in the global bootstrap domain called `privilegedMachName`.
    /// Wire messages will be serviced on the designated `queue`.
    public init(privilegedMachName: String, on queue: DispatchQueue = DispatchQueue.global(), active: Bool = false) {
        self.name = privilegedMachName
        name.withCString {
            self.connection = xpc_connection_create_mach_service($0, queue, UInt64(XPC_CONNECTION_MACH_SERVICE_PRIVILEGED))
        }
        xpc_connection_set_event_handler(self.connection, self._recv(_:))
        if active {
            xpc_connection_resume(self.connection)
        }
    }
}

/// XPCConnection: Hashable, Equatable
public extension XPCConnection {
    public var hashValue: Int {
        return self.connection == nil ? 0 : xpc_hash(self.connection)
    }
    
    public static func ==(lhs: XPCConnection, rhs: XPCConnection) -> Bool {
        return xpc_equal(lhs.connection, rhs.connection)
    }
}

/// Primitive send & recv utilities.
public extension XPCConnection {
    
    /// Sends a handled message on the internal XPC connection with an optional reply.
    private func _send(_ event: xpc_object_t, _ reply: ((xpc_object_t) throws -> ())? = nil) {
        if reply != nil {
            xpc_connection_send_message_with_reply(self.connection, event, self.replyQueue) {
                do {
                    try reply!($0)
                } catch(let error) {
                    os_log("remote coding error! %@", error.localizedDescription)
                }
            }
        } else {
            xpc_connection_send_message(self.connection, event)
        }
    }
    
    /// Receives a handled message on the internal XPC connection. Note: needs a preset handler.
    private func _recv(_ event: xpc_object_t) {
        guard xpc_get_type(event) == XPC_TYPE_DICTIONARY else { //XPC_TYPE_ERROR
            os_log("ERROR!")
            return
        }
        
        // Dispatch the message to an applicable handler on our reply queue.
        if  let identity = xpc_dictionary_get_string(event, "identity"),
            let handler = self.replyHandlers[String(cString: identity)] {
            self.replyQueue.async {
                do {
                    let x = try handler.handler(xpc_dictionary_get_value(event, "request"))
                    
                    // If the remote end awaits on a reply, respond.
                    if handler.requiresReply == true {
                        let dict = xpc_dictionary_create_reply(event)!
                        xpc_dictionary_set_value(dict, "response", x.0)
                        xpc_dictionary_set_value(dict, "error", x.1)
                        xpc_connection_send_message(self.connection, dict)
                    }
                } catch(let error) {
                    
                    // If we catch a handler error and we need to send a reply, send the
                    // error description if possible. (TODO: CodableError?)
                    if handler.requiresReply == true {
                        let dict = xpc_dictionary_create_reply(event)!
                        error.localizedDescription.withCString {
                            xpc_dictionary_set_string(dict, "__error", $0)
                        }
                        xpc_connection_send_message(self.connection, dict)
                    }
                }
            }
        } else {
            os_log("ignoring unregistered message: %@", event.description)
        }
    }
}

/// Over-the-wire packaging and unpackaging utilities.
public extension XPCConnection {
    
    /// Create a wire package (optionally with an embedded request).
    private func _package<RMI: RemoteMethodBase>(_ rmi: RMI.Type) throws -> xpc_object_t {
        let message = xpc_dictionary_create(nil, nil, 0)
        RMI.qualifiedName.withCString {
            xpc_dictionary_set_string(message, "identity", $0)
        }
        return message
    }
    
    /// Variant of _package(_:) to support RemoteRequestables.
    private func _package<RMI: RemoteMethodBase & RemoteRequestable>(_ rmi: RMI.Type, _ request: RMI.Request) throws -> xpc_object_t {
        let message = xpc_dictionary_create(nil, nil, 0)
        RMI.qualifiedName.withCString {
            xpc_dictionary_set_string(message, "identity", $0)
        }
        xpc_dictionary_set_value(message, "request", try XPCEncoder().encode(request))
        return message
    }
    
    /// Retrieve the response from the wire package.
    /// Variant of _unpackage(_:_:) to support RemoteRespondables.
    private func _unpackage<RMI: RemoteMethodBase & RemoteRespondable>(_ rmi: RMI.Type, _ event: xpc_object_t) throws -> RMI.Response {
        guard let r = xpc_dictionary_get_value(event, "response") else {
            throw RemoteError.invalid
        }
        return try XPCDecoder().decode(RMI.Response.self, from: r)
    }
    
    /// Retrieve the error from the wire package.
    /// Variant of _unpackage(_:_:) to support RemoteThrowables.
    private func _unpackage<RMI: RemoteMethodBase & RemoteThrowable>(_ rmi: RMI.Type, _ event: xpc_object_t) throws -> RMI.Exception? {
        guard let r = xpc_dictionary_get_value(event, "error") else { return nil }
        return try XPCDecoder().decode(RMI.Exception.self, from: r)
    }
}

/// XPCConnection: RemoteService (Async)
public extension XPCConnection {
    public func async<RMI: RemoteMethod>(_ rmi: RMI.Type) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi))
    }
    
    public func async<RMI: RequestingMethod>(_ rmi: RMI.Type, with request: RMI.Request) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi, request))
    }
    
    public func async<RMI: RespondingMethod>(_ rmi: RMI.Type, response: @escaping (RMI.Response) -> ()) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi)) {
            response(try self._unpackage(rmi, $0))
        }
    }
    
    public func async<RMI: ThrowingMethod>(_ rmi: RMI.Type, response: @escaping (RMI.Exception?) -> ()) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi)) {
            response(try self._unpackage(rmi, $0))
        }
    }
    
    public func async<RMI: RequestingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request, response: @escaping (RMI.Exception?) -> ()) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi, request)) {
            response(try self._unpackage(rmi, $0))
        }
    }
    
    public func async<RMI: RespondingThrowingMethod>(_ rmi: RMI.Type, response: @escaping (RMI.Response?, RMI.Exception?) -> ()) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi)) {
            response(try self._unpackage(rmi, $0), try self._unpackage(rmi, $0))
        }
    }
    
    public func async<RMI: RequestingRespondingMethod>(_ rmi: RMI.Type, with request: RMI.Request, response: @escaping (RMI.Response) -> ()) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi, request)) {
            response(try self._unpackage(rmi, $0))
        }
    }
    
    public func async<RMI: RequestingRespondingThrowingMethod>(_ rmi: RMI.Type, with request: RMI.Request, response: @escaping (RMI.Response?, RMI.Exception?) -> ()) throws where RMI.Service == XPCConnection {
        self._send(try self._package(rmi, request)) {
            response(try self._unpackage(rmi, $0), try self._unpackage(rmi, $0))
        }
    }
}

/// XPCConnection: RemoteService (Recv)
public extension XPCConnection {
    public func recv<RMI: RemoteMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> ()) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
    
    public func recv<RMI: RequestingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> ()) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
    
    public func recv<RMI: RespondingMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> (RMI.Response)) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
    
    public func recv<RMI: ThrowingMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> (RMI.Exception?)) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
    
    public func recv<RMI: RequestingThrowingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Exception?)) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
    
    public func recv<RMI: RespondingThrowingMethod>(_ rmi: RMI.Type, handler: @escaping () throws -> (RMI.Response?, RMI.Exception?)) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
    
    public func recv<RMI: RequestingRespondingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response)) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
    
    public func recv<RMI: RequestingRespondingThrowingMethod>(_ rmi: RMI.Type, handler: @escaping (RMI.Request) throws -> (RMI.Response?, RMI.Exception?)) where RMI.Service == XPCConnection {
        self.replyHandlers[rmi.qualifiedName] = _MessageHandler(rmi, handler: handler)
    }
}
