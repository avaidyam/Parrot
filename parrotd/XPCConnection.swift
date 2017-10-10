import Foundation
import XPC
import os
import ServiceManagement

// TODO: Test
public struct Person2: Codable {
    public var name: String
    public var address: String
    public var height: Float
    public var locale: Int
    public var _flags: UInt8
}

public struct _CookieRequest: Codable {
    
}

public struct _CookieResponse: Codable {
    var cookies: [[String: String]]
    
    public init(_ cookies: [HTTPCookie]) {
        self.cookies = cookies.map {
            var d = [String: String]()
            for c in ($0.properties ?? [:]) {
                if let str = c.value as? String {
                    d[c.key.rawValue] = str
                } else if let url = c.value as? URL {
                    d[c.key.rawValue] = url.absoluteString
                } else if let date = c.value as? Date {
                    d[c.key.rawValue] = date.description
                }
            }
            return d
        }
    }
    
    public func asCookies() -> [HTTPCookie] {
        return self.cookies.flatMap {
            let d = $0.map { (HTTPCookiePropertyKey(rawValue: $0.key), $0.value) }
            return HTTPCookie(properties: Dictionary(uniqueKeysWithValues: d))
        }
    }
}


var _ccon: XPCConnection? = nil

// stub:
public func host(_ handle: @escaping (_CookieResponse) -> ()) {
    os_log("LAUNCHING XPC CLIENT")
    _ccon = XPCConnection(name: "com.avaidyam.Parrot.parrotd")
    _ccon?.active = true
    
    try? _ccon?.send(message: "function_name") { (resp: _CookieResponse) in
        os_log("RESPONSE DATA: %@", String(describing: resp))
        handle(resp)
    }
}

public enum XPCError {
    case connectionInterrupted, connectionInvalid, replyInvalid, terminationImminent
}

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
/// Note: trying to {en,de}code this results in gibberish unless using XPC{En,De}Coder.
public final class XPCConnection: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    public let name: String
    internal var connection: xpc_connection_t! = nil
    internal var replyQueue = DispatchQueue(label: "")
    
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
    
    internal init(_ connection: xpc_connection_t) {
        self.connection = connection
        self.name = "<unknown>"//String(cString: xpc_connection_get_name(connection)!)
    }
    
    public init(name: String, on queue: DispatchQueue = DispatchQueue.global()) {
        self.name = name
        name.withCString {
            self.connection = xpc_connection_create($0, queue)
        }
        
        xpc_connection_set_event_handler(self.connection) { event in
            self.handle(event: event)
        }
    }
    
    private func handle(event: xpc_object_t) {
        if event === XPC_ERROR_CONNECTION_INVALID {
            os_log("INVALIDATED!")
        }
        os_log("EVENT: %@", event.description)
    }
    
    public func send<Request: Encodable, Response: Decodable>(message: Request, reply: ((Response) -> ())? = nil) throws {
        if let replyHandler = reply { // send_with_reply
            let request = try XPCEncoder(options: .primitiveRootValues).encode(["request": message])
            xpc_connection_send_message_with_reply(self.connection, request, self.replyQueue) { obj in
                guard let response: Response = try? XPCDecoder(options: .primitiveRootValues).decode(obj) else { return }
                
                replyHandler(response)
            }
        } else { // send_only
            let request = try XPCEncoder(options: .primitiveRootValues).encode(["request": message])
            xpc_connection_send_message(self.connection, request)
        }
    }
}

/*
 xpc_object_t xpc_connection_copy_entitlement_value(xpc_connection_t, const char* entitlement);
 void xpc_connection_get_audit_token(xpc_connection_t, audit_token_t*);
 void xpc_connection_kill(xpc_connection_t, int);
 void xpc_connection_set_instance(xpc_connection_t, uuid_t);
 mach_port_t xpc_dictionary_copy_mach_send(xpc_object_t, const char*);
 void xpc_dictionary_set_mach_send(xpc_object_t, const char*, mach_port_t);
 void xpc_connection_set_bootstrap(xpc_connection_t, xpc_object_t bootstrap);
 xpc_object_t xpc_copy_bootstrap(void);
 void xpc_connection_set_oneshot_instance(xpc_connection_t, uuid_t instance);
 
 SecTaskRef SecTaskCreateWithAuditToken(CFAllocatorRef, audit_token_t);
 SecTaskRef SecTaskCreateFromSelf(CFAllocatorRef);
 CFTypeRef SecTaskCopyValueForEntitlement(SecTaskRef, CFStringRef entitlement, CFErrorRef *);
 CFStringRef SecTaskCopySigningIdentifier(SecTaskRef, CFErrorRef *); //__MAC_OS_X_VERSION_MIN_REQUIRED >= 101200
 
 void xpc_dictionary_set_mach_send(xpc_object_t dictionary, const char* name, mach_port_t port);
 void xpc_dictionary_get_audit_token(xpc_object_t dictionary, audit_token_t* token);
 mach_port_t xpc_mach_send_get_right(xpc_object_t value);
 void xpc_dictionary_get_audit_token(xpc_object_t xdict, audit_token_t *token);

 xpc_pipe_t xpc_pipe_create(const char *name, uint64_t flags);
 void xpc_pipe_invalidate(xpc_pipe_t pipe);
 xpc_pipe_t xpc_pipe_create_from_port(mach_port_t port, int flags);
 int xpc_pipe_receive(mach_port_t port, xpc_object_t* message);
 int xpc_pipe_routine(xpc_pipe_t pipe, xpc_object_t request, xpc_object_t* reply);
 int xpc_pipe_routine_reply(xpc_object_t reply);
 int xpc_pipe_simpleroutine(xpc_pipe_t pipe, xpc_object_t message);
 int xpc_pipe_routine_forward(xpc_pipe_t forward_to, xpc_object_t request);
 */
