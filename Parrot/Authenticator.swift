import Cocoa
import Hangouts
import WebKit

public class Authenticator {
	
	private static let DEFAULTS = NSUserDefaults.init(suiteName: "group.com.avaidyam.Parrot")!
	private static let ACCESS_TOKEN = "access_token"
	private static let REFRESH_TOKEN = "refresh_token"
	
	private static let OAUTH2_SCOPE = "https://www.google.com/accounts/OAuthLogin"
	private static let OAUTH2_CLIENT_ID = "936475272427.apps.googleusercontent.com"
	private static let OAUTH2_CLIENT_SECRET = "KWsJlkaMn1jGLxQpWxMnOox-"
	private static let OAUTH2_LOGIN_URL = "https://accounts.google.com/o/oauth2/auth?client_id=\(OAUTH2_CLIENT_ID)&scope=\(OAUTH2_SCOPE)&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code"
	private static let OAUTH2_TOKEN_REQUEST_URL = "https://accounts.google.com/o/oauth2/token"
	
	private static var window: NSWindow? = nil
	private static var validURL: NSURL? = nil
	private static var handler: ((NSURLRequest) -> Void)? = nil
	private static var delegate = WebDelegate()
	
	class WebDelegate: NSObject, WebPolicyDelegate {
		func webView(
			_ webView: WebView!,
			decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!,
			request: NSURLRequest!,
			frame: WebFrame!,
			decisionListener listener: WebPolicyDecisionListener!) {
			
				let url = request.url!.absoluteString
				let val = (validURL?.absoluteString)!
				if url.contains(val) {
					listener.ignore()
					handler?(request)
					window?.close()
				} else {
					listener.use()
				}
		}
	}
	
	/**
	Load access_token and refresh_token for OAuth2.
	- returns: Tuple containing tokens, or nil on failure.
	*/
	public class func loadTokens() -> (access_token: String, refresh_token: String)? {
		let at = DEFAULTS.string(forKey: ACCESS_TOKEN)
		let rt = DEFAULTS.string(forKey: REFRESH_TOKEN)
		
		if let at = at, rt = rt {
			return (access_token: at, refresh_token: rt)
		} else {
			clearTokens()
			return nil
		}
	}
	
	/**
	Store access_token and refresh_token for OAuth2.
	- parameter access_token the OAuth2 access token
	- parameter refresh_token the OAuth2 refresh token
	*/
	public class func saveTokens(access_token: String, refresh_token: String) {
		DEFAULTS.set(access_token, forKey: ACCESS_TOKEN)
		DEFAULTS.set(refresh_token, forKey: REFRESH_TOKEN)
	}
	
	/**
	Clear the existing auth_token and refresh_token for OAuth2.
	*/
	public class func clearTokens() {
		DEFAULTS.removeObject(forKey: ACCESS_TOKEN)
		DEFAULTS.removeObject(forKey: REFRESH_TOKEN)
	}
	
	public class func authenticateClient(cb: (configuration: NSURLSessionConfiguration) -> Void) {
		
		// Prepare the manager for any requests.
		let cfg = NSURLSessionConfiguration.default()
		cfg.httpCookieStorage = NSHTTPCookieStorage.shared()
		cfg.httpAdditionalHeaders = _defaultHTTPHeaders
		let session = NSURLSession(configuration: cfg)
		
		if let code = loadTokens() {
			
			// If we already have the tokens stored, authenticate.
			//  - second: authenticate(manager, refresh_token)
			authenticate(session: session, refresh_token: code.refresh_token) { (access_token: String, refresh_token: String) in
				saveTokens(access_token: access_token, refresh_token: refresh_token)
				
				let url = "https://accounts.google.com/accounts/OAuthLogin?source=hangups&issueuberauth=1"
				let request = NSMutableURLRequest(url: NSURL(string: url)!)
				request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
				
				session.request(request: request) {
					guard let data = $0.data else {
						print("Request failed with error: \($0.error!)")
						return
					}
					
					var uberauth = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
					uberauth.replaceSubrange(uberauth.index(uberauth.endIndex, offsetBy: -1) ..< uberauth.endIndex, with: "")
					
					let request = NSMutableURLRequest(url: NSURL(string: "https://accounts.google.com/MergeSession")!)
					request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
					
					session.request(request: request) {
						guard let _ = $0.data else {
							print("Request failed with error: \($0.error!)")
							return
						}
						
						let url = "https://accounts.google.com/MergeSession?service=mail&continue=http://www.google.com&uberauth=\(uberauth)"
						let request = NSMutableURLRequest(url: NSURL(string: url)!)
						request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
						
						session.request(request: request) {
							guard let _ = $0.data else {
								print("Request failed with error: \($0.error!)")
								return
							}
							cb(configuration: session.configuration)
						}
					}
				}
			}
		} else {
			
			// Otherwise, we need to authenticate, so use the callback to do so.
			let a = NSURL(string: OAUTH2_LOGIN_URL)!
			let b = NSURL(string: "https://accounts.google.com/o/oauth2/approval")!
			
			prompt(url: a, valid: b) { request in
				session.request(request: request) {
					guard let data = $0.data else {
						print("Request failed with error: \($0.error!)")
						return
					}
					
					let body = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
					let auth_code = body.findAllOccurrences(matching: "value=\"(.+?)\"").first!
					
					//  - first: authenticate(auth_code)
					authenticate(auth_code: auth_code, cb: { (access_token, refresh_token) in
						saveTokens(access_token: access_token, refresh_token: refresh_token)
						cb(configuration: session.configuration)
					})
				}
			}
		}
	}
	
	/**
	Authenticate OAuth2 using an authentication code.
	- parameter auth_code the authentication code
	- parameter cb a callback to execute upon completion
	*/
	private class func authenticate(auth_code: String, cb: (access_token: String, refresh_token: String) -> Void) {
		let token_request_data = [
			"client_id": OAUTH2_CLIENT_ID,
			"client_secret": OAUTH2_CLIENT_SECRET,
			"code": auth_code,
			"grant_type": "authorization_code",
			"redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
		]
		
		// Make request first.
		let req = NSMutableURLRequest(url: NSURL(string: OAUTH2_TOKEN_REQUEST_URL)!)
		req.httpMethod = "POST"
		req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		req.httpBody = query(parameters: token_request_data).data(using: NSUTF8StringEncoding, allowLossyConversion: false)
		
		NSURLSession.shared().request(request: req) {
			guard let data = $0.data else {
				print("Request failed with error: \($0.error!)")
				return
			}
			
			do {
				let json = try NSJSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
				if let access = json[ACCESS_TOKEN] as? String, refresh = json[REFRESH_TOKEN] as? String  {
					cb(access_token: access, refresh_token: refresh)
				} else {
					print("JSON was invalid: \(json)")
				}
			} catch let error as NSError {
				print("JSON returned invalid data: \(error.localizedDescription)")
			}
		}
	}
	
	/**
	Authenticate OAuth2 using a refresh_token.
	- parameter manager the Alamofire manager for the OAuth2 request
	- parameter refresh_token the specified refresh_token
	- parameter cb a callback to execute upon completion
	*/
	private class func authenticate(session: NSURLSession, refresh_token: String, cb: (access_token: String, refresh_token: String) -> Void) {
		let token_request_data = [
			"client_id": OAUTH2_CLIENT_ID,
			"client_secret": OAUTH2_CLIENT_SECRET,
			"grant_type": REFRESH_TOKEN,
			REFRESH_TOKEN: refresh_token,
		]
		
		// Make request first.
		let req = NSMutableURLRequest(url: NSURL(string: OAUTH2_TOKEN_REQUEST_URL)!)
		req.httpMethod = "POST"
		req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		req.httpBody = query(parameters: token_request_data).data(using: NSUTF8StringEncoding, allowLossyConversion: false)
		
		session.request(request: req) {
			guard let data = $0.data else {
				print("Request failed with error: \($0.error!)")
				return
			}
			
			do {
				let json = try NSJSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
				if let access = json[ACCESS_TOKEN] as? String  {
					cb(access_token: access, refresh_token: refresh_token)
				} else {
					print("JSON was invalid: \(json)")
				}
			} catch let error as NSError {
				print("JSON returned invalid data: \(error.localizedDescription)")
			}
		}
	}
	
	private class func prompt(url: NSURL, valid: NSURL, cb: (NSURLRequest) -> Void) {
		validURL = valid
		handler = cb
		
		
		let webView = WebView(frame: NSMakeRect(0, 0, 386, 512))
		webView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]
		webView.policyDelegate = delegate
		webView.mainFrame.load(NSMutableURLRequest(url: url))
		
		window = NSWindow(contentRect: NSMakeRect(0, 0, 386, 512),
			styleMask: NSTitledWindowMask | NSClosableWindowMask,
			backing: .buffered, defer: false)
		window?.title = "Login to Parrot"
		window?.isOpaque = false
		window?.isMovableByWindowBackground = true
		window?.contentView = webView
		window?.center()
		window?.makeKeyAndOrderFront(nil)
	}
}
