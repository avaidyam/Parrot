import Foundation

class RequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        let extensionItem = NSExtensionItem()
        extensionItem.userInfo = [
			"uniqueIdentifier": "uniqueIdentifierForSampleItem",
			"urlString": "http://apple.com",
			"date": NSDate()
		]
        extensionItem.attributedTitle = NSAttributedString(string: "Sample title")
        extensionItem.attributedContentText = NSAttributedString(string: "Sample description text")
        context.completeRequestReturningItems([extensionItem], completionHandler: nil)
    }

}
