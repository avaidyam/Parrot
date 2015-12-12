import Cocoa
import Hangouts

let storyboard = NSStoryboard(name: "Main", bundle: nil)
let loginWindowController = storyboard.instantiateControllerWithIdentifier("LoginWindowController") as? NSWindowController
let loginViewController = loginWindowController?.contentViewController as? LoginViewController

class ConversationsViewController: NSViewController, ClientDelegate, NSTableViewDataSource, NSTableViewDelegate, NSSplitViewDelegate, ConversationListDelegate {

    @IBOutlet weak var conversationTableView: NSTableView!
    override func viewDidLoad() {
		super.viewDidLoad()
		
		conversationTableView.setDataSource(self)
		conversationTableView.setDelegate(self)

        //  TODO: Don't do this here
        //if let splitView = (self.parentViewController as? NSSplitViewController)?.splitView {
        //    splitView.delegate = self
        //}
		
		//  TODO: Move this out to AppDelegate
		OAuth2.authenticateClient({ client in
			self.representedObject = client
			self.client?.delegate = self
			self.client?.connect()
			}, auth: { launch, actual, cb in
				loginViewController?.showLogin(launch, valid: actual, cb: cb)
				print("view is load \(loginWindowController?.window?.visible)")
				loginWindowController!.showWindow(nil)
		})
	}
	
	override func viewDidAppear() {
		print("view is here \(loginWindowController?.window?.visible)")
	}

    override var representedObject: AnyObject? {
        didSet {
            
        }
    }

    var client: Client? {
        get {
            return representedObject as? Client
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
            var view = tableView.makeViewWithIdentifier("ConversationListItemView", owner: self) as? ConversationListItemView

            if view == nil {
                view = ConversationListItemView.instantiateFromNib(identifier: "ConversationListItemView", owner: self)
                view!.identifier = "ConversationListItemView"
            }

            view!.configureWithConversation(conversation)
            return view
        }
        return nil
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 64
    }

    // MARK: NSSplitViewDelegate
    func splitView(
        splitView: NSSplitView,
        constrainSplitPosition proposedPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        switch (dividerIndex) {
        case 0: return 270
        default: return proposedPosition
        }
    }

    func splitView(splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        return splitView.subviews.indexOf(view) != 0
    }

    func splitView(splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
        let dividerThickness = CGFloat(1)

        let leftViewSize = NSMakeSize(
            270,
            splitView.frame.size.height
        )
        let rightViewSize = NSMakeSize(
            splitView.frame.size.width - leftViewSize.width - dividerThickness,
            splitView.frame.size.height
        )

        // Resizing and placing the left view
        splitView.subviews[0].setFrameOrigin(NSMakePoint(0, 0))
        splitView.subviews[0].setFrameSize(leftViewSize)

        print("Right view size: \(rightViewSize)")

        // Resizing and placing the right view
        splitView.subviews[1].setFrameOrigin(NSMakePoint(leftViewSize.width + dividerThickness, 0))
        splitView.subviews[1].setFrameSize(rightViewSize)
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

