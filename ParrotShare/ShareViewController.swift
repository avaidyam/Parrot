import Cocoa
import Social

class ShareViewController: SLComposeServiceViewController {
	
    override func loadView() {
        super.loadView()
		
        self.title = NSLocalizedString("ParrotShare", comment: "Title of the Social Service")
        NSLog("Input Items = %@", self.extensionContext!.inputItems)
    }

    override func didSelectPost() {
        // Perform the post operation
        // When the operation is complete (probably asynchronously), the service should notify the success or failure as well as the items that were actually shared
    
        let inputItem = self.extensionContext!.inputItems[0] as! NSExtensionItem
    
        let outputItem = inputItem.copy() as! NSExtensionItem
        outputItem.attributedContentText = NSAttributedString(string: self.contentText)
        // Complete implementation by setting the appropriate value on the output item
    
        let outputItems = [outputItem]
    
        self.extensionContext!.completeRequestReturningItems(outputItems, completionHandler: nil)
    }

    override func didSelectCancel() {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequestWithError(cancelError)
    }

    override func isContentValid() -> Bool {
        let messageLength = self.contentText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let charactersRemaining = 140 - messageLength
        self.charactersRemaining = charactersRemaining
        
        if charactersRemaining >= 0 {
            return true
        }
        
        return false
    }

}
