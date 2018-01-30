import MochaUI

/* TODO: Generate portions of this file from Xcode Assets. */

// Strings
public extension String {
    public static let openLocationFailed = NSLocalizedString("Parrot couldn't open that location!", comment: "Parrot URL does not exist.")
    
    public static let xpcServer = "com.avaidyam.Parrot.parrotd"
    public static let feedbackURL = "https://gitreports.com/issue/avaidyam/Parrot"
    public static let reachabilityURL = "google.com"
}

// Colors
public extension NSColor/*.Name*/ {
    
}

// Fonts
public extension NSFont/*.Name*/ {
    //".SFCompactRounded-Medium"
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
    public static let buddyLoggingIn = NSSound.Name("Buddy Logging In")
    public static let buddyLoggingOut = NSSound.Name("Buddy Logging Out")
    public static let fileTransferComplete = NSSound.Name("File Transfer Complete")
    public static let invitationAccepted = NSSound.Name("Invitation Accepted")
    public static let invitation = NSSound.Name("Invitation")
    public static let loggedIn = NSSound.Name("Logged In")
    public static let mailFetchError = NSSound.Name("Mail Fetch Error")
    public static let mailSent = NSSound.Name("Mail Sent")
    public static let newMail = NSSound.Name("New Mail")
    public static let receivedAcknowledgement = NSSound.Name("Received Acknowledgement")
    public static let receivedMessage = NSSound.Name("Received Message")
    public static let ringerPause = NSSound.Name("Ringer Pause")
    public static let ringer = NSSound.Name("Ringer")
    public static let sentMessage = NSSound.Name("Sent Message")
}

// Data
public extension NSDataAsset.Name {
    
}

// Notifications
public extension NSNotification.Name {
    public static let openConversationsUpdated = NSNotification.Name(rawValue: "com.avaidyam.Parrot.openConversationsUpdated")
    public static let conversationAppearanceUpdated = NSNotification.Name(rawValue: "com.avaidyam.Parrot.conversationAppearanceUpdated")
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

// Screens
public extension Analytics.Screen {
    public static let conversation = Analytics.Screen(rawValue: "ConversationScreen")
    public static let conversationList = Analytics.Screen(rawValue: "ConversationListScreen")
    public static let directory = Analytics.Screen(rawValue: "DirectoryScreen")
    public static let preferences = Analytics.Screen(rawValue: "PreferencesScreen")
}

// Categories
public extension Analytics.Category {
    public static let misc = Analytics.Category(rawValue: "Misc")
}
