import Cocoa
import Social

public final class ShareViewController: SLComposeServiceViewController {
    public override func loadView() {
        super.loadView()
        self.title = NSLocalizedString("ParrotShare", comment: "Title of the Social Service")
        NSLog("Input Items = %@", self.extensionContext!.inputItems)
    }
	
    public override func didSelectPost() {
        let inputItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
        let outputItem = inputItem.copy() as! NSExtensionItem
        outputItem.attributedContentText = NSAttributedString(string: self.contentText)
        self.extensionContext!.completeRequest(returningItems: [outputItem], completionHandler: nil)
    }
	
    public override func didSelectCancel() {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }
	
    public override func isContentValid() -> Bool {
        return true
    }
}
