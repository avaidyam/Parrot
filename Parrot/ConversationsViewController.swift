import Cocoa
import Hangouts

class ConversationsViewController: NSViewController, ClientDelegate, NSTableViewDataSource, NSTableViewDelegate, NSSplitViewDelegate, ConversationListDelegate {

    @IBOutlet weak var conversationTableView: NSTableView!
	
    override func viewDidLoad() {
		super.viewDidLoad()
		
		conversationTableView.setDataSource(self)
		conversationTableView.setDelegate(self)
		
		OAuth2.authenticateClient({ client in
			self.representedObject = client
		}, auth: { launch, actual, cb in
			let vc = LoginViewController.login(launch, valid: actual, cb: cb)
			self.presentViewControllerAsSheet(vc!)
		})
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		self.view.window?.styleMask = self.view.window!.styleMask | NSFullSizeContentViewWindowMask
		self.view.window?.titleVisibility = .Hidden;
		self.view.window?.titlebarAppearsTransparent = true;
		//self.view.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
	}

    override var representedObject: AnyObject? {
        didSet {
			let client = representedObject as? Client
			client?.delegate = self
			client?.connect()
			updateAppBadge()
        }
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
			
			NSOperationQueue.mainQueue().addOperationWithBlock {
				self.conversationTableView.reloadData()
			}
        }
    }

    func clientDidConnect(client: Client, initialData: InitialData) {
        buildUserList(client, initial_data: initialData) { user_list in
			
            self.conversationList = ConversationList(
                client: client,
                conv_states: initialData.conversation_states,
                user_list: user_list,
                sync_timestamp: initialData.sync_timestamp
            )
			
			NSOperationQueue.mainQueue().addOperationWithBlock {
				self.conversationTableView.reloadData()
				self.conversationTableView.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
				self.conversationTableView.scrollRowToVisible(0)
			}
        }
    }

    func clientDidDisconnect(client: Client) {

    }

    func clientDidReconnect(client: Client) {

    }

    func clientDidUpdateState(client: Client, update: CLIENT_STATE_UPDATE) {
        
    }

    // MARK: NSTableViewDataSource delegate
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return conversationList?.conversations.count ?? 0
    }

    func tableViewSelectionDidChange(notification: NSNotification) {
        if conversationTableView.selectedRow >= 0 {
            selectConversation(conversationList?.conversations[conversationTableView.selectedRow])
        } else {
            selectConversation(nil)
        }
    }
	
	func tableView(tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction] {
		var actions: [NSTableViewRowAction] = []
		if edge == .Leading { // Swipe Right Actions
			actions = [
				NSTableViewRowAction(style: .Regular, title: "Mute", handler: { a, b in
					print("\(a) \(b)")
				}),
				NSTableViewRowAction(style: .Regular, title: "Mute", handler: { a, b in
					print("\(a) \(b)")
				})
			]
			actions[1].backgroundColor = NSColor.darkGrayColor()
		} else if edge == .Trailing { // Swipe Left Actions
			actions = [
				NSTableViewRowAction(style: .Destructive, title: "Archive", handler: { a, b in
					print("\(a) \(b)")
				}),
				NSTableViewRowAction(style: .Destructive, title: "Delete", handler: { a, b in
					print("\(a) \(b)")
				})
			]
			actions[0].backgroundColor = NSColor.darkGrayColor()
		}
		return actions
	}
	
	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		return conversationList?.conversations[row]
	}

    // MARK: NSTableViewDelegate

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return tableView.makeViewWithIdentifier("ConversationListItemView", owner: self) as? ConversationListItemView
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 64
    }
    
    // MARK: ConversationListDelegate
    func conversationList(list: ConversationList, didReceiveEvent event: ConversationEvent) {

    }

    func conversationList(list: ConversationList, didChangeTypingStatusTo status: TypingType) {
		print("changed something \(status)")
    }

    func conversationList(list: ConversationList, didReceiveWatermarkNotification status: WatermarkNotification) {

    }

    func conversationListDidUpdate(list: ConversationList) {
		NSOperationQueue.mainQueue().addOperationWithBlock {
			self.conversationTableView.reloadData()
			self.updateAppBadge()
		}
    }

    func conversationList(list: ConversationList, didUpdateConversation conversation: Conversation) {
        //  TODO: Just update the one row that needs updating
		
		NSOperationQueue.mainQueue().addOperationWithBlock {
			self.conversationTableView.reloadData()
			self.updateAppBadge()
		}
    }


    // MARK: IBActions

    func selectConversation(conversation: Conversation?) {
        if let conversationViewController = (self.parentViewController as? NSSplitViewController)?.splitViewItems[1].viewController as? ConversationViewController {
            conversationViewController.representedObject = conversation
        }
    }
}

