import Cocoa
import Hangouts

// Experimenting with new typealias to make code readable.
typealias Sender = AnyObject?

// Existing Parrot Settings keys.
public class Parrot {
	public static let AutoEmoji = "Parrot.AutoEmoji"
	public static let DarkAppearance = "Parrot.DarkAppearance"
	public static let InvertChatStyle = "Parrot.InvertChatStyle"
}

class ConversationsViewController:  NSViewController, ClientDelegate,
									NSTableViewDataSource, NSTableViewDelegate,
									NSSplitViewDelegate, ConversationListDelegate {

    @IBOutlet weak var tableView: NSTableView!
	
	override func loadView() {
		super.loadView()
		Notifications.subscribe(NSUserDefaultsDidChangeNotification) { note in
			
			// Handle appearance colors.
			let dark = Settings()[Parrot.DarkAppearance] as? Bool ?? false
			let appearance = (dark ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
			self.view.window?.appearance = NSAppearance(named: appearance)
		}
		
		/* TODO: Should be a singleton outer class! */
		OAuth2.authenticateClient({ client in
			self.representedObject = client
			client.delegate = self
			client.connect()
			self.updateAppBadge()
		}, auth: { launch, actual, cb in
			LoginViewController.loginWindow(launch, valid: actual, cb: cb)
		})
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		/* TODO: Should not be set here! Use a special window. */
		self.view.window?.titleVisibility = .Hidden;
		self.view.window?.titlebarAppearsTransparent = true;
		
		let dark = Settings()[Parrot.DarkAppearance] as? Bool ?? false
		let appearance = (dark ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
		self.view.window?.appearance = NSAppearance(named: appearance)
		
		let scroll = self.view.subviews[0] as? NSScrollView
		scroll!.scrollerInsets = NSEdgeInsets(top: -48.0, left: 0, bottom: 0, right: 0)
	}

    func updateAppBadge() {
        if let list = conversationList where list.unreadEventCount > 0 {
            NSApp.dockTile.badgeLabel = "\(list.unreadEventCount)"
        } else {
            NSApp.dockTile.badgeLabel = ""
        }
    }

    // MARK: Client Delegate
    var conversationList: ConversationList? {
        didSet {
            conversationList?.delegate = self
			
			Dispatch.main().run {
				self.tableView.reloadData()
			}
        }
    }

    func clientDidConnect(client: Client, initialData: InitialData) {
		buildUserList(client, initial_data: initialData) { user_list in
			//print("users: \(user_list.get_all())")
			
            self.conversationList = ConversationList(
                client: client,
                conv_states: initialData.conversation_states,
                user_list: user_list,
                sync_timestamp: initialData.sync_timestamp
            )
			
			Dispatch.main().run {
				self.tableView.reloadData()
				self.tableView.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
				self.tableView.scrollRowToVisible(0)
			}
        }
    }

    func clientDidDisconnect(client: Client) {

    }

    func clientDidReconnect(client: Client) {

    }

    func clientDidUpdateState(client: Client, update: STATE_UPDATE) {
        
    }

    // MARK: NSTableViewDataSource delegate
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return conversationList?.conversations.count ?? 0
    }

    func tableViewSelectionDidChange(notification: NSNotification) {
        if tableView.selectedRow >= 0 {
            selectConversation(conversationList?.conversations[tableView.selectedRow])
        } else {
            selectConversation(nil)
        }
    }
	
	func tableView(tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		var actions: [NSTableViewRowAction] = []
		if edge == .Leading { // Swipe Right Actions
			actions = [
				NSTableViewRowAction(style: .Regular, title: "Mute", handler: { action, select in
					print("Mute row:\(select)")
				}),
				NSTableViewRowAction(style: .Destructive, title: "Block", handler: { action, select in
					print("Block row:\(select)")
				})
			]
			
			// Fix the colors set by the given styles.
			actions[0].backgroundColor = NSColor.blueColor()
			actions[1].backgroundColor = NSColor.clearColor()
		} else if edge == .Trailing { // Swipe Left Actions
			actions = [
				NSTableViewRowAction(style: .Destructive, title: "Delete", handler: { action, select in
					print("Delete row:\(select)")
				}),
				NSTableViewRowAction(style: .Regular, title: "Archive", handler: { action, select in
					print("Archive row:\(select)")
				})
			]
			
			// Fix the colors set by the given styles.
			actions[0].backgroundColor = NSColor.clearColor()
			actions[1].backgroundColor = NSColor.redColor()
		}
		return actions
	}
	
	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		return conversationList?.conversations[row]
	}

    // MARK: NSTableViewDelegate

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return tableView.makeViewWithIdentifier("ConversationListItemView", owner: self)
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 64
    }
    
    // MARK: ConversationListDelegate
    func conversationList(list: ConversationList, didReceiveEvent event: Event) {

    }

    func conversationList(list: ConversationList, didChangeTypingStatusTo status: TypingType) {
		print("changed something \(status)")
    }

    func conversationList(list: ConversationList, didReceiveWatermarkNotification status: WatermarkNotification) {

    }

    func conversationList(didUpdate list: ConversationList) {
		Dispatch.main().run {
			self.tableView.reloadData()
			self.updateAppBadge()
		}
    }

    func conversationList(list: ConversationList, didUpdateConversation conversation: Conversation) {
        //  TODO: Just update the one row that needs updating
		
		Dispatch.main().run {
			self.tableView.reloadData()
			self.updateAppBadge()
		}
    }


    // MARK: IBActions

    func selectConversation(conversation: Conversation?) {
		let item = (self.parentViewController as? NSSplitViewController)?.splitViewItems[1]
        if let vc = item?.viewController as? ConversationViewController {
            vc.representedObject = conversation
        }
    }
}

