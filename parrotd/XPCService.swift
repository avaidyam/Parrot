import Cocoa

/// Note: requires the XPCService dictionary in the Info.plist to set RunLoopType=_NSApplicationMain.
open class XPCService {
    
    /// The internal adapter class to abstract away any *delegate things.
    private class _Adapter: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
        
        private var service: XPCService? = nil
        
        public override init() {
            super.init()
            NSApp.setActivationPolicy(.accessory)
            NSUserNotificationCenter.default.delegate = self
        }
        
        public convenience init(_ service: XPCService) {
            self.init()
            self.service = service
        }
        
        public func applicationWillFinishLaunching(_ notification: Notification) {
            self.service?.serviceWillFinishLaunching()
        }
        
        public func applicationDidFinishLaunching(_ notification: Notification) {
            self.service?.serviceDidFinishLaunching()
        }
        
        public func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
            return self.service?.serviceShouldTerminate() ?? .terminateNow
        }
        
        public func applicationWillTerminate(_ notification: Notification) {
            self.service?.serviceWillTerminate()
        }
        
        public func application(_ application: NSApplication, willPresentError error: Error) -> Error {
            return self.service?.serviceWillPresent(error: error) ?? error
        }
        
        public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
            return true
        }
    }
    
    fileprivate static var _service: XPCService? = nil
    
    public private(set) var peers: [XPCConnection] = []
    
    public static func isApplicationService() -> Bool {
        if  let xpc = Bundle.main.infoDictionary?["XPCService"] as? [String: Any],
            let runloop = xpc["RunLoopType"] as? String, runloop == "_NSApplicationMain" {
            return true
        }
        return false
    }
    
    public class func run() -> Never {
        XPCService._service = self.init()
        if XPCService.isApplicationService() {
            NSApplication.shared.delegate = _Adapter(XPCService._service!)
        }
        xpc_main { XPCService._service!.handle(peer: $0) }
    }
    
    public required init() {}
    
    fileprivate final func handle(peer rawPeer: xpc_connection_t) {
        let peer = XPCConnection(rawPeer)
        guard self.serviceShouldAccept(connection: peer) else { return }
        
        xpc_connection_set_event_handler(peer.connection, { event in
            if xpc_get_type(event) == XPC_TYPE_DICTIONARY {
                self.serviceConnection(peer, received: event)
            } else if xpc_get_type(event) == XPC_TYPE_ERROR {
                if event === XPC_ERROR_CONNECTION_INVALID {
                    self.serviceConnection(peer, experienced: .connectionInvalid)
                } else if event === XPC_ERROR_CONNECTION_INTERRUPTED {
                    self.serviceConnection(peer, experienced: .connectionInterrupted)
                } else if event === XPC_ERROR_TERMINATION_IMMINENT {
                    self.serviceConnection(peer, experienced: .terminationImminent)
                }
            } else {
                //???
            }
            
            if let peerIdx = (self.peers.index { xpc_equal($0.connection, peer.connection) }) {
                self.peers.remove(at: peerIdx)
            }
        })
        
        xpc_connection_resume(peer.connection)
        self.peers.append(peer)
    }
    
    /// Note: RunLoopType=_NSApplicationMain only.
    open func serviceWillFinishLaunching() {
        
    }
    
    /// Note: RunLoopType=_NSApplicationMain only.
    open func serviceDidFinishLaunching() {
        
    }
    
    /// Note: RunLoopType=_NSApplicationMain only.
    open func serviceShouldTerminate() -> NSApplication.TerminateReply {
        return .terminateNow
    }
    
    /// Note: RunLoopType=_NSApplicationMain only.
    open func serviceWillTerminate() {
        
    }
    
    /// Note: RunLoopType=_NSApplicationMain only.
    open func serviceWillPresent(error: Error) -> Error {
        return error
    }
    
    // ???
    open func serviceShouldAccept(connection: XPCConnection) -> Bool {
        return false
    }
    
    // ???
    open func serviceConnection(_ connection: XPCConnection, received payload: xpc_object_t) {
        
    }
    
    // ???
    open func serviceConnection(_ connection: XPCConnection, experienced error: XPCError) {
        
    }
}
