import Foundation
import Hangouts
import Mocha

public struct Auth: AuthenticatorDelegate {
    
    private static let GROUP_DOMAIN = "group.com.avaidyam.Parrot"
    private static let ACCESS_TOKEN = "access_token"
    private static let REFRESH_TOKEN = "refresh_token"
    
    public var authenticationTokens: AuthenticationTokens? {
        get {
            let at = SecureSettings[Auth.ACCESS_TOKEN, domain: Auth.GROUP_DOMAIN] as? String
            let rt = SecureSettings[Auth.REFRESH_TOKEN, domain: Auth.GROUP_DOMAIN] as? String
            
            if let at = at, let rt = rt {
                return (access_token: at, refresh_token: rt)
            } else {
                SecureSettings[Auth.ACCESS_TOKEN, domain: Auth.GROUP_DOMAIN] = nil
                SecureSettings[Auth.REFRESH_TOKEN, domain: Auth.GROUP_DOMAIN] = nil
                return nil
            }
        }
        set { }//assert(false, "Cannot authenticate from the console! You must launch the GUI.") }
    }
    public func authenticationMethod(_ oauth_url: URL, _ result: @escaping AuthenticationResult) {
        assert(false, "Cannot authenticate from the console! You must launch the GUI.")
    }
    
    public static func signin() -> Client {
        let sem = DispatchSemaphore(value: 0)
        print("Initializing...")
        var client: Client!
        Authenticator.delegate = Auth()
        Authenticator.authenticateClient {
            client = Client(configuration: $0)
            sem.signal()
        }
        _ = sem.wait(timeout: DispatchTime.distantFuture)
        return client
    }
}
