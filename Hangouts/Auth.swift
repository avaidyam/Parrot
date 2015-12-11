import Foundation
import Alamofire
import Cocoa

/* TODO: Replace with OAuth2 framework. */

let oauth2 = [
	"client_id": "936475272427.apps.googleusercontent.com",
	"client_secret": "KWsJlkaMn1jGLxQpWxMnOox-",
	"authorize_uri": "https://accounts.google.com/o/oauth2/auth",
	"token_uri": "https://accounts.google.com/o/oauth2/token",
	"scope": "https://www.google.com/accounts/OAuthLogin",
	"redirect_uris": ["urn:ietf:wg:oauth:2.0:oob"],
	"keychain": true,
	"title": "Google Hangouts"
] /*as OAuth2JSON

let oauth2 = OAuth2CodeGrant(settings: settings)
oauth2.authConfig.authorizeEmbedded = true
oauth2.authConfig.authorizeContext = <# presenting view controller #>
oauth2.onAuthorize = { parameters in
	print("Did authorize with parameters: \(parameters)")
}
oauth2.onFailure = { error in        // `error` is nil on cancel
	if nil != error {
		print("Authorization went wrong: \(error!.localizedDescription)")
	}
}*/

let DEFAULTS = NSUserDefaults.standardUserDefaults()
let OAUTH2_SCOPE = "https://www.google.com/accounts/OAuthLogin"
let OAUTH2_CLIENT_ID = "936475272427.apps.googleusercontent.com"
let OAUTH2_CLIENT_SECRET = "KWsJlkaMn1jGLxQpWxMnOox-"
let OAUTH2_LOGIN_URL = "https://accounts.google.com/o/oauth2/auth?client_id=\(OAUTH2_CLIENT_ID)&scope=\(OAUTH2_SCOPE)&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code"
let OAUTH2_TOKEN_REQUEST_URL = "https://accounts.google.com/o/oauth2/token"

/**
Load access_token and refresh_token for OAuth2.
- returns: Tuple containing tokens, or nil on failure.
*/
func loadTokens() -> (access_token: String, refresh_token: String)? {
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
func saveTokens(access_token: String, refresh_token: String) {
	DEFAULTS.setObject(access_token, forKey: "access_token")
	DEFAULTS.setObject(refresh_token, forKey: "refresh_token")
}

/**
Clear the existing auth_token and refresh_token for OAuth2.
*/
func clearTokens() {
	DEFAULTS.removeObjectForKey("access_token")
	DEFAULTS.removeObjectForKey("refresh_token")
}

/**
Authenticate OAuth2 using an authentication code.
- parameter auth_code the authentication code
- parameter cb a callback to execute upon completion
*/
func authenticate(auth_code: String, cb: (access_token: String, refresh_token: String) -> Void) {
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
    Alamofire.request(.POST, OAUTH2_TOKEN_REQUEST_URL, parameters: token_request_data).responseJSON { response in
		switch response.result {
			case .Success(let JSON):
				cb(access_token: JSON["access_token"] as! String, refresh_token: JSON["refresh_token"] as! String)
			case .Failure(let error):
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
func authenticate(manager: Alamofire.Manager, refresh_token: String,
	cb: (access_token: String, refresh_token: String) -> Void) {
    let token_request_data = [
        "client_id": OAUTH2_CLIENT_ID,
        "client_secret": OAUTH2_CLIENT_SECRET,
        "grant_type": "refresh_token",
        "refresh_token": refresh_token,
    ]
    manager.request(.POST, OAUTH2_TOKEN_REQUEST_URL, parameters: token_request_data).responseJSON { response in
		switch response.result {
			case .Success(let JSON):
				cb(access_token: JSON["access_token"] as! String, refresh_token: refresh_token)
			case .Failure(let error):
				print("Request failed with error: \(error)")
		}
    }
}

//func get_auth_cookies() -> Dictionary<String, String> {
//    Login into Google and return cookies as a dict.
//    get_code_f() is called if authorization code is required to log in, and
//    should return the code as a string.
//    A refresh token is saved/loaded from refresh_token_filename if possible, so
//    subsequent logins may not require re-authenticating.
//    Raises GoogleAuthError on failure.
//
//    try:
//      logger.info('Authenticating with refresh token')
//      access_token = _authenticate(refresh_token_filename)
//    except GoogleAuthError as e:
//      logger.info('Failed to authenticate using refresh token: %s', e)
//      logger.info('Authenticating with authorization code')
//      access_token = _authenticate(get_code_f, refresh_token_filename)
//    logger.info('Authentication successful')
//    return _get_session_cookies(access_token)
//}

func withAuthenticatedManager(cb: (manager: Alamofire.Manager) -> Void) {
	let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
	cfg.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    withAuthenticatedManager(Alamofire.Manager(configuration: cfg), cb: cb)
}

func withAuthenticatedManager(manager: Alamofire.Manager, cb: (manager: Alamofire.Manager) -> Void) {
    // This method should *not* take an access_token, and pop up a window with web view
    // to authenticate the user with Google, if possible.
    if let codes = loadTokens() {
        authenticate(manager, refresh_token: codes.refresh_token) { (access_token: String, refresh_token: String) in
            //print("Auth'd with refresh token. New access token: \(access_token)")

            let url = "https://accounts.google.com/accounts/OAuthLogin?source=hangups&issueuberauth=1"
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
            manager.request(request).responseData { response in
                var uberauth = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)! as String
                uberauth.replaceRange(Range<String.Index>(
                    start: uberauth.endIndex.advancedBy(-1),
                    end: uberauth.endIndex
                    ), with: "")

                let request = NSMutableURLRequest(URL: NSURL(string: "https://accounts.google.com/MergeSession")!)
                request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
                manager.request(request).responseData { response in
                    let url = "https://accounts.google.com/MergeSession?service=mail&continue=http://www.google.com&uberauth=\(uberauth)"
                    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
                    request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
                    manager.request(request).responseData { response in
                        cb(manager: manager)
                    }
                }
            }
        }
    } else {
        promptForGoogleLogin(manager) {
            //print("Got callback, codes now \(loadTokens())")
            withAuthenticatedManager(manager, cb: cb)
        }
    }
}

//var loginWindowController: NSWindowController?
func promptForGoogleLogin(manager: Alamofire.Manager, cb: () -> Void) {
    //let storyboard = NSStoryboard(name: "Main", bundle: nil)

    //loginWindowController = storyboard.instantiateControllerWithIdentifier("LoginWindowController") as? NSWindowController

    //let loginViewController = loginWindowController?.contentViewController as? LoginViewController
    //loginViewController?.manager = manager
    //loginViewController?.cb = { (auth_code: String) in
	
	// FIXME: bad idea.
	let auth_code = readLine(stripNewline: true)!
	
        authenticate(auth_code) { (access_token, refresh_token) -> Void in
            saveTokens(access_token, refresh_token: refresh_token)
            cb()
        }
    //}

    //loginWindowController!.showWindow(nil)
}
