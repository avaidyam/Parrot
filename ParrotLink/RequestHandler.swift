import Foundation

class RequestHandler: NSObject, NSExtensionRequestHandling {
	func beginRequest(with context: NSExtensionContext) {
        let extensionItem = NSExtensionItem()
        extensionItem.userInfo = [
			"uniqueIdentifier": "uniqueIdentifierForSampleItem",
			"urlString": "http://apple.com",
			"date": Date()
		]
        extensionItem.attributedTitle = AttributedString(string: "Sample title")
        extensionItem.attributedContentText = AttributedString(string: "Sample description text")
        context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
    }
}
