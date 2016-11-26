import Foundation
import Mocha
import ParrotServiceExtension

private let log = Logger(subsystem: "Hangouts.Authenticator")

public typealias AuthenticationResult = (_ oauth_code: String) -> Void
public typealias AuthenticationSuccess = (_ cookies: URLSessionConfiguration) -> Void
public typealias AuthenticationMethod = (_ oauth_url: URL, _ result: @escaping AuthenticationResult) -> Void
public typealias AuthenticationTokens = (access_token: String, refresh_token: String)

public protocol AuthenticatorDelegate {
    var authenticationTokens: AuthenticationTokens? { get set }
    func authenticationMethod(_ oauth_url: URL, _ result: @escaping AuthenticationResult)
}

public class Authenticator {
    
    private static let ACCESS_TOKEN = "access_token"
    private static let REFRESH_TOKEN = "refresh_token"
	private static let OAUTH2_SCOPE = "https%3A%2F%2Fwww.google.com%2Faccounts%2FOAuthLogin+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email"
	private static let OAUTH2_CLIENT_ID = "936475272427.apps.googleusercontent.com"
	private static let OAUTH2_CLIENT_SECRET = "KWsJlkaMn1jGLxQpWxMnOox-"
	private static let OAUTH2_LOGIN_URL = "https://accounts.google.com/o/oauth2/programmatic_auth?client_id=\(OAUTH2_CLIENT_ID)&scope=\(OAUTH2_SCOPE)"
	private static let OAUTH2_TOKEN_REQUEST_URL = "https://accounts.google.com/o/oauth2/token"
	
	/**
	Load access_token and refresh_token for OAuth2.
	- returns: Tuple containing tokens, or nil on failure.
	*/
	public class func loadTokens() -> AuthenticationTokens? {
		return self.delegate?.authenticationTokens
	}
	
	/**
	Store access_token and refresh_token for OAuth2.
	- parameter access_token the OAuth2 access token
	- parameter refresh_token the OAuth2 refresh token
	*/
	public class func saveTokens(_ tokens: AuthenticationTokens) {
		self.delegate?.authenticationTokens = tokens
	}
    
    public static var delegate: AuthenticatorDelegate? = nil
    
	public class func authenticateClient(_ handler: @escaping AuthenticationSuccess) {
        assert(Authenticator.delegate != nil, "Authenticator must have a method set first before it can authenticate.")
		
		// Prepare the manager for any requests.
		let cfg = URLSessionConfiguration.default
		cfg.httpCookieStorage = HTTPCookieStorage.shared
		cfg.httpAdditionalHeaders = _defaultHTTPHeaders
		let session = URLSession(configuration: cfg)
		
		if let code = loadTokens() {
			
			// If we already have the tokens stored, authenticate.
			//  - second: authenticate(manager, refresh_token)
			authenticate(session: session, refresh_token: code.refresh_token) { (access_token: String, refresh_token: String) in
				saveTokens((access_token, refresh_token: refresh_token))
				
				let url = "https://accounts.google.com/accounts/OAuthLogin?source=hangups&issueuberauth=1"
				var request = URLRequest(url: URL(string: url)! as URL)
				request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
				
				session.request(request: request) {
					guard let data = $0.data else {
						log.info("Request failed with error: \($0.error!)")
						return
					}
					
					var uberauth = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
					uberauth.replaceSubrange(uberauth.index(uberauth.endIndex, offsetBy: -1) ..< uberauth.endIndex, with: "")
                    
                    let url = "https://accounts.google.com/MergeSession?service=mail&continue=http://www.google.com&uberauth=\(uberauth)"
                    var request = URLRequest(url: URL(string: url)!)
                    request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
                    
                    session.request(request: request) {
                        guard let _ = $0.data else {
                            log.info("Request failed with error: \($0.error!)")
                            return
                        }
                        handler(session.configuration)
                    }
				}
			}
		} else {
			
            Authenticator.delegate?.authenticationMethod(URL(string: OAUTH2_LOGIN_URL)!) { oauth_code in
                //  - first: authenticate(auth_code)
                authenticate(auth_code: oauth_code) {
                    saveTokens($0)
                    handler(session.configuration)
                }
            }
		}
	}
	
	/**
	Authenticate OAuth2 using an authentication code.
	- parameter auth_code the authentication code
	- parameter cb a callback to execute upon completion
	*/
	private class func authenticate(auth_code: String, cb: @escaping (_ access_token: String, _ refresh_token: String) -> Void) {
		let token_request_data = [
			"client_id": OAUTH2_CLIENT_ID,
			"client_secret": OAUTH2_CLIENT_SECRET,
			"code": auth_code,
			"grant_type": "authorization_code",
			"redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
		]
		
		// Make request first.
		var req = URLRequest(url: URL(string: OAUTH2_TOKEN_REQUEST_URL)! as URL)
		req.httpMethod = "POST"
		req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		req.httpBody = query(parameters: token_request_data).data(using: .utf8)
		
		URLSession.shared.request(request: req) {
			guard let data = $0.data else {
				log.info("Request failed with error: \($0.error!)")
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
				if let access = json[ACCESS_TOKEN] as? String, let refresh = json[REFRESH_TOKEN] as? String  {
					cb(access, refresh)
				} else {
					log.info("JSON was invalid (auth): \(json)")
				}
			} catch let error as NSError {
				log.info("JSON returned invalid data: \(error.localizedDescription)")
			}
		}
	}
	
	/**
	Authenticate OAuth2 using a refresh_token.
	- parameter manager the Alamofire manager for the OAuth2 request
	- parameter refresh_token the specified refresh_token
	- parameter cb a callback to execute upon completion
	*/
	private class func authenticate(session: URLSession, refresh_token: String, cb: @escaping (_ access_token: String, _ refresh_token: String) -> Void) {
		let token_request_data = [
			"client_id": OAUTH2_CLIENT_ID,
			"client_secret": OAUTH2_CLIENT_SECRET,
			"grant_type": REFRESH_TOKEN,
			REFRESH_TOKEN: refresh_token,
		]
		
		// Make request first.
		var req = URLRequest(url: URL(string: OAUTH2_TOKEN_REQUEST_URL)! as URL)
		req.httpMethod = "POST"
		req.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
		req.httpBody = query(parameters: token_request_data).data(using: .utf8)
		
		session.request(request: req) {
			guard let data = $0.data else {
				log.info("Request failed with error: \($0.error!)")
				return
			}
			
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
				if let access = json[ACCESS_TOKEN] as? String  {
					cb(access, refresh_token)
				} else {
					log.info("JSON was invalid (refresh): \(json)")
				}
			} catch let error as NSError {
				log.info("JSON returned invalid data: \(error.localizedDescription)")
			}
		}
	}
}
