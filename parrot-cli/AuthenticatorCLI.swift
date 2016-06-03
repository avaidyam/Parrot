import Foundation
import Hangouts

public class AuthenticatorCLI {
	
	private static let OAUTH2_CLIENT_ID = "936475272427.apps.googleusercontent.com"
	private static let OAUTH2_CLIENT_SECRET = "KWsJlkaMn1jGLxQpWxMnOox-"
	private static let OAUTH2_TOKEN_REQUEST_URL = "https://accounts.google.com/o/oauth2/token"
	
	private class func loadTokens() -> (access_token: String, refresh_token: String)? {
		let at = NSUserDefaults.standard().string(forKey: "access_token")
		let rt = NSUserDefaults.standard().string(forKey: "refresh_token")
		
		if let at = at, rt = rt {
			return (access_token: at, refresh_token: rt)
		} else {
			return nil
		}
	}
	
	private static func authenticate(session: NSURLSession, refresh_token: String, cb: (access_token: String, refresh_token: String) -> Void) {
		let token_request_data = [
			"client_id": OAUTH2_CLIENT_ID,
			"client_secret": OAUTH2_CLIENT_SECRET,
			"grant_type": "refresh_token",
			"refresh_token": refresh_token,
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
				if let access = json["access_token"] as? String  {
					cb(access_token: access, refresh_token: refresh_token)
				} else {
					print("JSON was invalid: \(json)")
				}
			} catch let error as NSError {
				print("JSON returned invalid data: \(error.localizedDescription)")
			}
		}
	}
	
	public static func authenticateClient(cb: (configuration: NSURLSessionConfiguration) -> Void) {
		let cfg = NSURLSessionConfiguration.default()
		cfg.httpCookieStorage = NSHTTPCookieStorage.shared()
		cfg.httpAdditionalHeaders = _defaultHTTPHeaders
		let session = NSURLSession(configuration: cfg)
		
		if let code = loadTokens() {
			
			// If we already have the tokens stored, authenticate.
			//  - second: authenticate(manager, refresh_token)
			authenticate(session: session, refresh_token: code.refresh_token) { (access_token: String, refresh_token: String) in
				
				let url = "https://accounts.google.com/accounts/OAuthLogin?source=hangups&issueuberauth=1"
				let request = NSMutableURLRequest(url: NSURL(string: url)!)
				request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
				
				session.request(request: request) {
					guard let data = $0.data else {
						print("Request failed with error: \($0.error!)")
						return
					}
					
					var uberauth = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
					uberauth.replaceSubrange(Range<String.Index>(uncheckedBounds: (
						lower: uberauth.index(uberauth.endIndex, offsetBy: -1),
						upper: uberauth.endIndex
					)), with: "")
					
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
		}
	}
}