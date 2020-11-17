import Foundation
import AppKit
import Mocha
import MochaUI
import Hangouts
import WebKit

internal class WebDelegate: NSObject, WebPolicyDelegate, WebResourceLoadDelegate, AuthenticatorDelegate {
    
    private static let GROUP_DOMAIN = "group.com.avaidyam.Parrot"
    private static let ACCESS_TOKEN = "access_token"
    private static let REFRESH_TOKEN = "refresh_token"
    
    internal static var window: NSWindow? = nil
    internal static var validURL: URL? = nil
    internal static var handler: ((_ oauth_code: String) -> Void)? = nil
    internal static var delegate = WebDelegate()
    
    internal func webView(_ sender: WebView!, resource identifier: Any!, didFinishLoadingFrom dataSource: WebDataSource!) {
        guard   let cookiejar = dataSource.response as? HTTPURLResponse,
            let cookies = cookiejar.allHeaderFields["Set-Cookie"] as? String,
            let cookie = cookies.substring(between: "oauth_code=", and: ";")
            else { return }
        WebDelegate.handler?(cookie)
        sender.close()
    }
    
    internal class func prompt(url: URL, cb: @escaping AuthenticationResult) {
        var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comp.query = nil
        let valid = comp.url
        guard valid != nil else { return }
        
        WebDelegate.validURL = valid
        WebDelegate.handler = cb
        
        let webView = WebView(frame: NSMakeRect(0, 0, 386, 512))
        webView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
        //webView.policyDelegate = WebDelegate.delegate
        webView.resourceLoadDelegate = WebDelegate.delegate
        
        let window = NSWindow(contentRect: NSMakeRect(0, 0, 386, 512),
                              styleMask: [.titled, .closable],
                              backing: .buffered, defer: false)
        window.title = "Login to Parrot"
        window.isOpaque = false
        window.isMovableByWindowBackground = true
        window.contentView = webView
        window.center()
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.collectionBehavior = [.moveToActiveSpace, .transient, .ignoresCycle, .fullScreenAuxiliary, .fullScreenDisallowsTiling]
        window.makeKeyAndOrderFront(nil)
        
        WebDelegate.window = window
        webView.mainFrame.load(URLRequest(url: url as URL))
    }
    
    var authenticationTokens: AuthenticationTokens? {
        get {
            let at = SecureSettings[WebDelegate.ACCESS_TOKEN, domain: WebDelegate.GROUP_DOMAIN] as? String
            let rt = SecureSettings[WebDelegate.REFRESH_TOKEN, domain: WebDelegate.GROUP_DOMAIN] as? String
            
            if let at = at, let rt = rt {
                return (access_token: at, refresh_token: rt)
            } else {
                SecureSettings[WebDelegate.ACCESS_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = nil
                SecureSettings[WebDelegate.REFRESH_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = nil
                return nil
            }
        }
        set {
            SecureSettings[WebDelegate.ACCESS_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = newValue?.access_token ?? nil
            SecureSettings[WebDelegate.REFRESH_TOKEN, domain: WebDelegate.GROUP_DOMAIN] = newValue?.refresh_token ?? nil
        }
    }
    
    func authenticationMethod(_ oauth_url: URL, _ result: @escaping AuthenticationResult) {
        WebDelegate.prompt(url: oauth_url, cb: result)
    }
}
