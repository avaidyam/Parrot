import Cocoa
import Hangouts
import WebKit

let sb = NSStoryboard(name: "Main", bundle: nil)
let login = sb.instantiateControllerWithIdentifier("Login") as? NSWindowController
let vc = login?.contentViewController as? LoginViewController

class LoginViewController : NSViewController, WebPolicyDelegate, WKNavigationDelegate {
	
	var webView: WebView!
	
	var url: NSURL? = nil
	var valid: NSURL? = nil
	var cb: ((NSURLRequest) -> Void)? = nil

	override func loadView() {
		super.loadView()
		self.webView = WebView(frame: self.view.bounds)
		self.webView.autoresizingMask = [.ViewHeightSizable, .ViewWidthSizable]
		self.view.addSubview(self.webView)
    }
	
	class func login(url: NSURL, valid: NSURL, cb: (NSURLRequest) -> Void) -> LoginViewController? {
		vc?.url = url
		vc?.valid = valid
		vc?.cb = cb
		
		vc?.webView.policyDelegate = vc
		vc?.webView.mainFrame.loadRequest(NSMutableURLRequest(URL: url))
		
		// WKWebView request semantics for some reason does not yield the refresh_token.
		//vc?.webView.navigationDelegate = vc
		//vc?.webView.loadRequest(NSMutableURLRequest(URL: url))
		return vc
	}
	
	/*
	// WKWebView request semantics for some reason does not yield the refresh_token.
	func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction,
		decisionHandler: (WKNavigationActionPolicy) -> Void) {
			
		let url = navigationAction.request.URL!.absoluteString
		let val = (self.valid?.absoluteString)!
		if url.containsString(val) {
			decisionHandler(.Cancel)
			print(navigationAction.request)
			self.cb?(navigationAction.request)
			self.view.window?.close()
		} else {
			decisionHandler(.Allow)
		}
	}
	*/
	
	// WKWebView request semantics for some reason does not yield the refresh_token.
	func webView(
		webView: WebView!,
		decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!,
		request: NSURLRequest!,
		frame: WebFrame!,
		decisionListener listener: WebPolicyDecisionListener!) {
		
		let url = request.URL!.absoluteString
		let val = (self.valid?.absoluteString)!
		if url.containsString(val) {
			listener.ignore()
			self.cb?(request)
			self.view.window?.close()
		} else {
			listener.use()
		}
	}
}
