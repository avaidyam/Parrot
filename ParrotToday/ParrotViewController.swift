import Foundation
import AppKit
import NotificationCenter
import Hangouts
import ParrotServiceExtension
import Mocha
import MochaUI

// Private service points go here:
private var _hangoutsClient: Client? = nil

private let log = Logger(subsystem: "Parrot.Today.Global")

class ParrotViewController: NSViewController {
    
    /*
    private lazy var listView: ListView = {
        let v = ListView()
        v.flowDirection = .top
        v.selectionType = .any
        v.delegate = self
        v.insets = NSEdgeInsets(top: 36.0, left: 0, bottom: 0, right: 0)
        return v
    }()
    
    // Dirty auth for Hangouts...
    private var connectSub: Subscription? = nil
    
    private var userList: Directory?
    var conversationList: ParrotServiceExtension.ConversationList?
    
    // FIXME: this is recomputed A LOT! bad idea...
    var sortedConversations: [ParrotServiceExtension.Conversation] {
        guard self.conversationList != nil else { return [] }
        let x = self.conversationList!.conversations.values
            .filter { !$0.archived }
            .sorted { $0.timestamp > $1.timestamp }
        return x
    }
    
    public func numberOfItems(in: ListView) -> [UInt] {
        log.debug("GETTING COUNT \(self.sortedConversations.count)")
        return [UInt(self.sortedConversations.count)]
    }
    
    public func object(in: ListView, at: ListView.Index) -> Any? {
        log.debug("GETTING OBJECT \(at)")
        return self.sortedConversations[Int(at.item)]
    }
    
    public func itemClass(in: ListView, at: ListView.Index) -> NSView.Type {
        log.debug("GETTING CLASS \(at)")
        return TodayConversationCell.self
    }
    
    public func cellHeight(in view: ListView, at: ListView.Index) -> Double {
        return 48.0 + 16.0 /* padding */
    }
    
    public override func loadView() {
        self.view = self.listView
        self.view.autoresizingMask = [.width, .height]
        self.preferredContentSize = CGSize(width: 320, height: 480)
    }
    
    public override func viewDidLoad() {
        Authenticator.delegate = AuthDelegate.delegate
        Authenticator.authenticateClient {
            let c = Client(configuration: $0)
            _hangoutsClient = c
            _ = c.connect()
            self.connectSub = AutoSubscription(from: c, kind: Notification.Service.DidConnect) { _ in
                if c.conversationList == nil {
                    //c.buildUserConversationList {
                        self.userList = c.directory
                        self.conversationList = c.conversations
                        
                        // FIXME: FORCE-CAST TO HANGOUTS
                        //(c.conversations as? Hangouts.ConversationList)?.delegate = self
                        self.listView.update()
                    //}
                }
            }
        }
    }
    
    /* TODO: Just update the row that is updated. */
    public func conversationList(_ list: Hangouts.ConversationList, didReceiveEvent event: IEvent) {
        guard event is IChatMessageEvent else { return }
        DispatchQueue.main.async {
            self.listView.update()
        }
    }
    
    /* TODO: Just update the row that is updated. */
    public func conversationList(didUpdate list: Hangouts.ConversationList) {
        DispatchQueue.main.async {
            self.listView.update()
        }
    }
    
    /* TODO: Just update the row that is updated. */
    public func conversationList(_ list: Hangouts.ConversationList, didUpdateConversation conversation: IConversation) {
        DispatchQueue.main.async {
            self.listView.update()
        }
    }
    
    public func conversationList(_ list: Hangouts.ConversationList, didChangeTypingStatus status: ITypingStatusMessage, forUser: User) {}
    public func conversationList(_ list: Hangouts.ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {}
 */
}

// Boilerplate stuff for NCWidgetProviding
extension ParrotViewController: NCWidgetProviding {
	override var nibName: NSNib.Name? {
		return nil
	}
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
		return NSEdgeInsetsZero
	}
	func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
		completionHandler(.newData)
	}
	var widgetAllowsEditing: Bool {
		return false
	}
}

internal class AuthDelegate: NSObject, AuthenticatorDelegate {
    
    private static let GROUP_DOMAIN = "group.com.avaidyam.Parrot"
    private static let ACCESS_TOKEN = "access_token"
    private static let REFRESH_TOKEN = "refresh_token"
    
    internal static var window: NSWindow? = nil
    internal static var validURL: URL? = nil
    internal static var handler: ((_ oauth_code: String) -> Void)? = nil
    internal static var delegate = AuthDelegate()
    
    var authenticationTokens: AuthenticationTokens? {
        get {
            let at = SecureSettings[AuthDelegate.ACCESS_TOKEN, domain: AuthDelegate.GROUP_DOMAIN] as? String
            let rt = SecureSettings[AuthDelegate.REFRESH_TOKEN, domain: AuthDelegate.GROUP_DOMAIN] as? String
            
            if let at = at, let rt = rt {
                return (access_token: at, refresh_token: rt)
            } else {
                SecureSettings[AuthDelegate.ACCESS_TOKEN, domain: AuthDelegate.GROUP_DOMAIN] = nil
                SecureSettings[AuthDelegate.REFRESH_TOKEN, domain: AuthDelegate.GROUP_DOMAIN] = nil
                return nil
            }
        }
        set {
            SecureSettings[AuthDelegate.ACCESS_TOKEN, domain: AuthDelegate.GROUP_DOMAIN] = newValue?.access_token ?? nil
            SecureSettings[AuthDelegate.REFRESH_TOKEN, domain: AuthDelegate.GROUP_DOMAIN] = newValue?.refresh_token ?? nil
        }
    }
    
    func authenticationMethod(_ oauth_url: URL, _ result: @escaping AuthenticationResult) {
        log.debug("TEST \(String(describing: self.authenticationTokens))")
        result("")
    }
}
