import Foundation
import Cocoa
import CommonCrypto

public class OAuth2 {
	
	// For UI authentication, we ask the client to take our request
	// URL as well as the expected approval URL. We'll use their request.
	public typealias Authenticator = (NSURL, NSURL, (request: NSURLRequest) -> Void) -> Void
	
	private static let DEFAULTS = NSUserDefaults.standardUserDefaults()
	
	private static let OAUTH2_SCOPE = "https://www.google.com/accounts/OAuthLogin"
	private static let OAUTH2_CLIENT_ID = "936475272427.apps.googleusercontent.com"
	private static let OAUTH2_CLIENT_SECRET = "KWsJlkaMn1jGLxQpWxMnOox-"
	private static let OAUTH2_LOGIN_URL = "https://accounts.google.com/o/oauth2/auth?client_id=\(OAUTH2_CLIENT_ID)&scope=\(OAUTH2_SCOPE)&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code"
	private static let OAUTH2_TOKEN_REQUEST_URL = "https://accounts.google.com/o/oauth2/token"
	
	/**
	Load access_token and refresh_token for OAuth2.
	- returns: Tuple containing tokens, or nil on failure.
	*/
	private class func loadTokens() -> (access_token: String, refresh_token: String)? {
		let at = DEFAULTS.stringForKey("access_token")
		let rt = DEFAULTS.stringForKey("refresh_token")
		
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
	private class func saveTokens(access_token: String, refresh_token: String) {
		DEFAULTS.setObject(access_token, forKey: "access_token")
		DEFAULTS.setObject(refresh_token, forKey: "refresh_token")
	}
	
	/**
	Clear the existing auth_token and refresh_token for OAuth2.
	*/
	private class func clearTokens() {
		DEFAULTS.removeObjectForKey("access_token")
		DEFAULTS.removeObjectForKey("refresh_token")
	}
	
	/**
	Authenticate OAuth2 using an authentication code.
	- parameter auth_code the authentication code
	- parameter cb a callback to execute upon completion
	*/
	private class func authenticate(auth_code: String, cb: (access_token: String, refresh_token: String) -> Void) {
		// Authenticate using OAuth authentication code.
		// Raises GoogleAuthError authentication fails.
		// Return access token string.
		
		// Make a token request.
		let token_request_data = [
			"client_id": OAUTH2_CLIENT_ID,
			"client_secret": OAUTH2_CLIENT_SECRET,
			"code": auth_code,
			"grant_type": "authorization_code",
			"redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
		]
		
		// Make request first.
		let req = NSMutableURLRequest(URL: NSURL(string: OAUTH2_TOKEN_REQUEST_URL)!)
		req.HTTPMethod = "POST"
		req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		req.HTTPBody = query(token_request_data).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
		
		NSURLSession.sharedSession().request(req) {
			guard let _ = $0.data else {
				print("Request failed with error: \($0.error!)")
				return
			}
			
			do {
				let JSON = try NSJSONSerialization.JSONObjectWithData($0.data!, options: .AllowFragments)
				cb(access_token: JSON["access_token"] as! String, refresh_token: JSON["refresh_token"] as! String)
			} catch {
				print("Request failed with error: \(error)")
			}
		}
	}
	
	/**
	Authenticate OAuth2 using a refresh_token.
	- parameter manager the Alamofire manager for the OAuth2 request
	- parameter refresh_token the specified refresh_token
	- parameter cb a callback to execute upon completion
	*/
	private class func authenticate(session: NSURLSession, refresh_token: String,
		cb: (access_token: String, refresh_token: String) -> Void) {
			let token_request_data = [
				"client_id": OAUTH2_CLIENT_ID,
				"client_secret": OAUTH2_CLIENT_SECRET,
				"grant_type": "refresh_token",
				"refresh_token": refresh_token,
			]
			
			// Make request first.
			let req = NSMutableURLRequest(URL: NSURL(string: OAUTH2_TOKEN_REQUEST_URL)!)
			req.HTTPMethod = "POST"
			req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
			req.HTTPBody = query(token_request_data).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
			
			session.request(req) {
				guard let data = $0.data else {
					print("Request failed with error: \($0.error!)")
					return
				}
				
				do {
					let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
					print("got \(JSON)")
					cb(access_token: JSON["access_token"] as! String, refresh_token: refresh_token)
				} catch {
					print("Request failed with error: \(error)")
				}
			}
	}
	
	public class func authenticateClient(cb: (client: Client) -> Void, auth: Authenticator) {
		
		// Prepare the manager for any requests.
		let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
		cfg.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
		cfg.HTTPAdditionalHeaders = _defaultHTTPHeaders
		let session = NSURLSession(configuration: cfg)
		
		if let code = loadTokens() {
			
			// If we already have the tokens stored, authenticate.
			//  - second: authenticate(manager, refresh_token)
			authenticate(session, refresh_token: code.refresh_token) { (access_token: String, refresh_token: String) in
				saveTokens(access_token, refresh_token: refresh_token)
				
				let url = "https://accounts.google.com/accounts/OAuthLogin?source=hangups&issueuberauth=1"
				let request = NSMutableURLRequest(URL: NSURL(string: url)!)
				request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
				
				session.request(request) {
					guard let data = $0.data else {
						print("Request failed with error: \($0.error!)")
						return
					}
					
					var uberauth = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
					uberauth.replaceRange(Range<String.Index>(
						start: uberauth.endIndex.advancedBy(-1),
						end: uberauth.endIndex
						), with: "")
					
					let request = NSMutableURLRequest(URL: NSURL(string: "https://accounts.google.com/MergeSession")!)
					request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
					
					session.request(request) {
						guard let _ = $0.data else {
							print("Request failed with error: \($0.error!)")
							return
						}
						
						let url = "https://accounts.google.com/MergeSession?service=mail&continue=http://www.google.com&uberauth=\(uberauth)"
						let request = NSMutableURLRequest(URL: NSURL(string: url)!)
						request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
						
						session.request(request) {
							guard let _ = $0.data else {
								print("Request failed with error: \($0.error!)")
								return
							}
							cb(client: Client(configuration: session.configuration))
						}
					}
				}
			}
		} else {
			
			// Otherwise, we need to authenticate, so use the callback to do so.
			let a = NSURL(string: OAUTH2_LOGIN_URL)!
			let b = NSURL(string: "https://accounts.google.com/o/oauth2/approval")!
			auth(a, b, { request in
				session.request(request) {
					guard let data = $0.data else {
						print("Request failed with error: \($0.error!)")
						return
					}
					
					let body = NSString(data: data, encoding: NSUTF8StringEncoding)!
					let auth_code = Regex("value=\"(.+?)\"").match(body as String).first!
					
					//  - first: authenticate(auth_code)
					authenticate(auth_code, cb: { (access_token, refresh_token) in
						saveTokens(access_token, refresh_token: refresh_token)
						cb(client: Client(configuration: session.configuration))
					})
				}
			})
		}
	}
	
	// Return authorization headers for API request. It doesn't seem to matter 
	// what the url and time are as long as they are consistent.
	public class func getAuthorizationHeaders(sapisid_cookie: String) -> Dictionary<String, String> {
		let time_msec = Int(NSDate().timeIntervalSince1970 * 1000)
		let auth_string = "\(time_msec) \(sapisid_cookie) \(Channel.ORIGIN_URL)"
		let auth_hash = auth_string.SHA1()
		let sapisidhash = "SAPISIDHASH \(time_msec)_\(auth_hash)"
		return [
			"Authorization": sapisidhash,
			"X-Origin": Channel.ORIGIN_URL,
			"X-Goog-Authuser": "0",
		]
	}
}

/* String Crypto extensions */
public extension String {
	public func SHA1() -> String {
		let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
		var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
		CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
		let hexBytes = digest.map {
			String(format: "%02hhx", $0)
		}
		return hexBytes.joinWithSeparator("")
	}
}
