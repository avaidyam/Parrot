import Cocoa

/* TODO: Generate portions of this file from Xcode Assets. */

// Strings
public extension String {
    
}

// Colors
public extension NSColor/*.Name*/ {
    
}

// Fonts
public extension NSFont/*.Name*/ {
    
}

// Images
public extension NSImage.Name {
    public static let materialVolumeHigh = NSImage.Name("MaterialVolumeHigh")
    public static let materialVolumeMute = NSImage.Name("MaterialVolumeMute")
    public static let materialSync = NSImage.Name("MaterialSync")
    public static let materialSearch = NSImage.Name("MaterialSearch")
    public static let dndRead = NSImage.Name("DNDRead")
    public static let dndUnread = NSImage.Name("DNDUnread")
    public static let connection = NSImage.Name("Connection")
    public static let compose = NSImage.Name("Compose")
    public static let communicationVideo = NSImage.Name("CommunicationVideo")
}

// Sounds
public extension NSSound.Name {
    
}

// Data
public extension NSDataAsset.Name {
    public static let buddyLoggingIn = NSDataAsset.Name("Buddy Logging In")
    public static let buddyLoggingOut = NSDataAsset.Name("Buddy Logging Out")
    public static let fileTransferComplete = NSDataAsset.Name("File Transfer Complete")
    public static let invitationAccepted = NSDataAsset.Name("Invitation Accepted")
    public static let invitation = NSDataAsset.Name("Invitation")
    public static let loggedIn = NSDataAsset.Name("Logged In")
    public static let mailFetchError = NSDataAsset.Name("Mail Fetch Error")
    public static let mailSent = NSDataAsset.Name("Mail Sent")
    public static let newMail = NSDataAsset.Name("New Mail")
    public static let receivedAcknowledgement = NSDataAsset.Name("Received Acknowledgement")
    public static let receivedMessage = NSDataAsset.Name("Received Message")
    public static let ringerPause = NSDataAsset.Name("Ringer Pause")
    public static let ringer = NSDataAsset.Name("Ringer")
    public static let sentMessage = NSDataAsset.Name("Sent Message")
}

// Notifications
public extension NSNotification.Name {
    
}

// Views
public extension NSUserInterfaceItemIdentifier {
    public static let personCell = NSUserInterfaceItemIdentifier(rawValue: "\(PersonCell.self)")
    public static let searchCell = NSUserInterfaceItemIdentifier(rawValue: "\(SearchCell.self)")
    public static let reloadCell = NSUserInterfaceItemIdentifier(rawValue: "\(ReloadCell.self)")
    public static let conversationCell = NSUserInterfaceItemIdentifier(rawValue: "\(ConversationCell.self)")
    public static let messageCell = NSUserInterfaceItemIdentifier(rawValue: "\(MessageCell.self)")
    public static let photoCell = NSUserInterfaceItemIdentifier(rawValue: "\(PhotoCell.self)")
    public static let locationCell = NSUserInterfaceItemIdentifier(rawValue: "\(LocationCell.self)")
}

// ToolbarItems
public extension NSToolbarItem.Identifier {
    public static let add = NSToolbarItem.Identifier(rawValue: "add")
    public static let search = NSToolbarItem.Identifier(rawValue: "search")
}
