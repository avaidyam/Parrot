import Cocoa
import os
import Mocha
import Hangouts
import XPCTransport
import ParrotServiceExtension

public class ParrotAgentController: XPCService {
    
    /// Once launched, the Agent shouldn't die as it is the global event pump for Parrot.
    public static var keepAlive: XPCTransaction? = nil
    
    public override func serviceDidFinishLaunching() {
        ParrotAgentController.keepAlive = XPCTransaction()
        
        os_log("launched app")
        let u = NSUserNotification()
        u.title = "Parrot is running in the background."
        NSUserNotificationCenter.default.deliver(u)
    }
    
    public override func serviceWillTerminate() {
        os_log("app terminated!")
        let u = NSUserNotification()
        u.title = "Parrot is no longer running in the background."
        NSUserNotificationCenter.default.deliver(u)
    }
    
    public override func serviceShouldAccept(connection: XPCConnection) -> Bool {
        connection.recv(AuthenticationInvocation.self) {
            return self.cookies
        }
        connection.recv(SendLogInvocation.self) { [weak connection] unit in
            Logger.default.debug("\(connection?.name ?? "<null>") received log unit: \(unit)")
        }
        return true
    }
    
    // Note: Lazy computes when first requested AND on the thread requested.
    private lazy var cookies: [[String: String]] = {
        var r: [[String: String]]? = nil
        let s = DispatchSemaphore(value: 0)
        Authenticator.authenticateClient {
            let response = $0.httpCookieStorage!.cookies ?? []
            r = AuthenticationInvocation.package(response)
            s.signal()
        }
        s.wait()
        return r!
    }()
}

Authenticator.delegate = WebDelegate.delegate
ParrotAgentController.run()
