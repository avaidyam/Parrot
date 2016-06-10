import Foundation

class RequestHandler: NSObject, NSExtensionRequestHandling {
	func beginRequest(with context: NSExtensionContext) {
        let extensionItem = NSExtensionItem()
        extensionItem.userInfo = [
			"uniqueIdentifier": "uniqueIdentifierForSampleItem",
			"urlString": "http://apple.com",
			"date": NSDate()
		]
        extensionItem.attributedTitle = NSAttributedString(string: "Sample title")
        extensionItem.attributedContentText = NSAttributedString(string: "Sample description text")
        context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
    }
}
