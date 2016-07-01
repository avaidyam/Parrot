import Foundation

class RequestHandler: NSObject, NSExtensionRequestHandling {
	func beginRequest(with context: NSExtensionContext) {
        let extensionItem = NSExtensionItem()
        extensionItem.userInfo = [
			"uniqueIdentifier": "uniqueIdentifierForSampleItem",
			"urlString": "http://apple.com",
			"date": Date(),
			"displayName": "Shared by User"
		]
        extensionItem.attributedTitle = AttributedString(string: "Sample title")
        extensionItem.attributedContentText = AttributedString(string: "Sample description text")
		//extensionItem.attachments = [NSItemProvider(contentsOf: URL(string: (Bundle.main().infoDictionary?["icon"])! as! String)!)!]
        context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
    }
}
