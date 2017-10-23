import Foundation
import XPC
import os

/// An XPC transaction acts as a "keep-alive" mechanism to avoid being killed while
/// performing background work. You must keep a strong reference to the transaction
/// while it is operating, or transaction auto-invalidates. If it is never de-init-
/// ialized, then the service will never be killed.
public final class XPCTransaction: Hashable {
    
    private static var hashTable = NSHashTable<XPCTransaction>.weakObjects()
    public static var pending: [XPCTransaction] {
        return hashTable.allObjects
    }
    
    public let identifier = UUID()
    
    public init() {
        xpc_transaction_begin()
        XPCTransaction.hashTable.add(self)
    }
    
    deinit {
        XPCTransaction.hashTable.remove(self)
        xpc_transaction_end()
    }
    
    public func performing(action: () -> ()) {
        action()
    }
    
    public var hashValue: Int {
        return self.identifier.hashValue
    }
    
    public static func ==(lhs: XPCTransaction, rhs: XPCTransaction) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}







//
//
//




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
    
    /*
     try? _ccon?.send(message: "function_name") { (resp: _CookieResponse) in
     os_log("RESPONSE DATA: %@", String(describing: resp))
     handle(resp)
     }
     */
}




// TODO: ADD THESE:
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
