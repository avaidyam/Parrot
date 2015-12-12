import Cocoa
import Hangouts

import Alamofire
import WebKit

class LoginViewController : NSViewController, WebResourceLoadDelegate, WebFrameLoadDelegate, WebPolicyDelegate {
	
	@IBOutlet weak var webView: WebView?
	
	var url: NSURL? = nil
	var cb: ((NSURLRequest) -> Void)? = nil

	override func loadView() {
		//self.view = WebView()
		//self.webView = self.view as? WebView
		self.webView?.autoresizingMask = [.ViewHeightSizable, .ViewWidthSizable]
    }
	
	func showLogin(url: NSURL, valid: NSURL, cb: (NSURLRequest) -> Void) {
		self.cb = cb
		webView?.resourceLoadDelegate = self
		webView?.frameLoadDelegate = self
		webView?.policyDelegate = self
		cb(NSURLRequest())
	}
	
	override func viewWillAppear() {
		if let abc = self.url {
			webView?.mainFrame.loadRequest(NSMutableURLRequest(URL:abc))
		}
	}

    func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {

    }

    func webView(
        webView: WebView!,
        decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!,
        request: NSURLRequest!,
        frame: WebFrame!,
        decisionListener listener: WebPolicyDecisionListener!)
    {
        if request.URL!.absoluteString.rangeOfString("https://accounts.google.com/o/oauth2/approval") != nil {
            listener.ignore()
            self.cb?(request)
        } else {
            listener.use()
        }
    }
}