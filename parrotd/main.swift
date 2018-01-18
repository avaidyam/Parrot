import Cocoa
import os
import Mocha
import Hangouts
import XPCTransport
import ParrotServiceExtension

/* TODO: Check for updates every 2-3 days and cache it. */
/* TODO: In-place update Parrot.app if needed. */

public class ParrotAgentController: XPCService {
    
    /// Once launched, the Agent shouldn't die as it is the global event pump for Parrot.
    public static var keepAlive: XPCTransaction? = nil
    
    public override func serviceDidFinishLaunching() {
        ParrotAgentController.keepAlive = XPCTransaction()
        
        os_log("launched app")
        let u = NSUserNotification()
        u.title = "Parrot is running in the background."
        NSUserNotificationCenter.default.deliver(u)
        
        // Check for updates if any are available.
        if let release = AppRelease.checkForUpdates(prerelease: true) {
            NSAlert(style: .informational, message: "\(release.releaseName) available",
                information: release.releaseNotes, buttons: ["Update", "Ignore"],
                suppressionIdentifier: "update.\(release.buildTag)").beginModal {
                    if $0 == .alertFirstButtonReturn {
                        NSWorkspace.shared.open(release.githubURL)
                    }
            }
        }
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
        connection.recv(LogOutInvocation.self) {
            let cookieStorage = HTTPCookieStorage.shared
            if let cookies = cookieStorage.cookies {
                for cookie in cookies {
                    cookieStorage.deleteCookie(cookie)
                }
            }
            self.cookies = []
            WebDelegate.delegate.authenticationTokens = nil
            NSApp.terminate(self)
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


// TODO: Dynamic please?
public extension NSAlert {
    @discardableResult
    public func customize() -> Self {
        self.window.appearance = .dark
        if let vev = self.window.titlebar.view as? NSVisualEffectView {
            vev.material = .appearanceBased
            vev.state = .active
            vev.blendingMode = .withinWindow
        }
        return self
    }
}
