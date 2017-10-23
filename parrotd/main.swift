//import XPCServices
import Cocoa
import os
import Mocha
import Hangouts
import XPCTransport

public class ParrotAgentController: XPCService {
    
    public override func serviceDidFinishLaunching() {
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
        connection.recv(AuthenticationSubsystem.AuthenticationInvocation.self) {
            return self.cookies
        }
        return true
    }
    
    // Note: Lazy computes when first requested AND on the thread requested.
    private lazy var cookies: [[String: String]] = {
        var r: [[String: String]]? = nil
        let s = DispatchSemaphore(value: 0)
        Authenticator.authenticateClient {
            let response = $0.httpCookieStorage!.cookies ?? []
            r = AuthenticationSubsystem.AuthenticationInvocation.package(response)
            s.signal()
        }
        s.wait()
        return r!
    }()
}

Authenticator.delegate = WebDelegate.delegate
ParrotAgentController.run()
