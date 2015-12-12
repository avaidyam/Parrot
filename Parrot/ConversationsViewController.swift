import Cocoa
import Hangouts

class ConversationsViewController: NSViewController, ClientDelegate, NSTableViewDataSource, NSTableViewDelegate, NSSplitViewDelegate, ConversationListDelegate {

    @IBOutlet weak var conversationTableView: NSTableView!
	
	override func loadView() {
		super.loadView()
	}
	
	override func viewWillAppear() {
		OAuth2.authenticateClient({ client in
			self.representedObject = client
		}, auth: { launch, actual, cb in
			let vc = LoginViewController.login(launch, valid: actual, cb: cb)
			self.presentViewControllerAsSheet(vc!)
		})
	}
	
    override func viewDidLoad() {
		super.viewDidLoad()
		conversationTableView.setDataSource(self)
		conversationTableView.setDelegate(self)
	}

    override var representedObject: AnyObject? {
        didSet {
			let client = representedObject as! Client
			client.delegate = self
			client.connect()
        }
    }

    func updateAppBadge() {
        if let list = conversationList where list.unreadEventCount > 0 {
            NSApplication.sharedApplication().dockTile.badgeLabel = "\(list.unreadEventCount)"
        } else {
            NSApplication.sharedApplication().dockTile.badgeLabel = ""
        }
    }

    // MARK: Client Delegate
    var conversationList: ConversationList? {
        didSet {
            conversationList?.delegate = self
			
			dispatch_async(dispatch_get_main_queue(), {
				self.conversationTableView.reloadData()
			})
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
			
			dispatch_async(dispatch_get_main_queue(), {
				self.conversationTableView.reloadData()
				self.conversationTableView.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
				self.conversationTableView.scrollRowToVisible(0)
			})
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

    // MARK: NSTableViewDelegate

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let conversation = conversationList?.conversations[row] {
            let view = tableView.makeViewWithIdentifier("ConversationListItemView", owner: self) as? ConversationListItemView
            view!.configureWithConversation(conversation)
            return view
        }
        return nil
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 64
    }
    
    // MARK: ConversationListDelegate
    func conversationList(list: ConversationList, didReceiveEvent event: ConversationEvent) {

    }

    func conversationList(list: ConversationList, didChangeTypingStatusTo status: TypingType) {

    }

    func conversationList(list: ConversationList, didReceiveWatermarkNotification status: WatermarkNotification) {

    }

    func conversationListDidUpdate(list: ConversationList) {
		dispatch_async(dispatch_get_main_queue(), {
			self.conversationTableView.reloadData()
			self.updateAppBadge()
		})
    }

    func conversationList(list: ConversationList, didUpdateConversation conversation: Conversation) {
        //  TODO: Just update the one row that needs updating
		
		dispatch_async(dispatch_get_main_queue(), {
			self.conversationTableView.reloadData()
			self.updateAppBadge()
		})
    }


    // MARK: IBActions

    func selectConversation(conversation: Conversation?) {
        if let conversationViewController = (self.parentViewController as? NSSplitViewController)?.splitViewItems[1].viewController as? ConversationViewController {
            conversationViewController.representedObject = conversation
        }
    }
}

