import Cocoa
import NotificationCenter
import Hangouts
import ParrotServiceExtension

// Private service points go here:
private var _hangoutsClient: Client? = nil

class ParrotViewController: NSViewController {//, ConversationListDelegate {
	
	/*
	var personsView: ConversationListView {
		return self.view as! ConversationListView
	}
	var viewingVC: MessageListViewController? = nil
	*/
	
	// Sets up the content size and adds the edit view to the controller.
	override func loadView() {
		super.loadView()
		self.preferredContentSize = CGSize(width: 320, height: 480)
		//self.setup()
	}
	
	/*// We're jumpstarted into the setup function here.
	func setup() {
		AppActivity.start("Authenticate")
		Authenticator.authenticateClient {
			let c = Client(configuration: $0)
			_ = c.connect() {_ in}
			AppActivity.end("Authenticate")
			
			NotificationCenter.default()
				.addObserver(forName: Client.didConnectNotification, object: c, queue: nil) { _ in
					AppActivity.start("Setup")
					c.buildUserConversationList { 
						AppActivity.end("Setup")
						ServiceRegistry.add(service: c)
						
						self.userList = c.userList
						self.conversationList = c.conversationList
						
						DispatchQueue.main.async {
							self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
						}
						
						ParrotAppearance.registerInterfaceStyleListener(observer: self) { appearance in
							self.view.window?.appearance = appearance
						}
						
						// Instantiate storyboard and controller and begin the UI from here.
						DispatchQueue.main.async {
							self.viewingVC = MessageListViewController(nibName: "MessageListViewController", bundle: nil)
							self.viewingVC?.preferredContentSize = CGSize(width: 320, height: 480)
							
							self.selectionProvider = { row in
								self.viewingVC?.representedObject = self.conversationList?.conversations[row]
								self.present(inWidget: self.viewingVC!)
							}
						}
					}
			}
			self.personsView.updateScrollsToBottom = false
		}
	}
	
	var selectionProvider: ((Int) -> Void)? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.personsView.insets = EdgeInsets(top: 48.0, left: 0, bottom: 0, right: 0)
		self.personsView.selectionProvider = { row in
			if row >= 0 {
				self.selectionProvider?(row)
			}
		}
		
		self.personsView.rowActionProvider = { row, edge in
			var actions: [NSTableViewRowAction] = []
			if edge == .leading { // Swipe Right Actions
				actions = [
					NSTableViewRowAction(style: .regular, title: "Mute", handler: { action, select in
						log.info("Mute row:\(select)")
					}),
					NSTableViewRowAction(style: .destructive, title: "Block", handler: { action, select in
						log.info("Block row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = #colorLiteral(red: 0.06274510175, green: 0.360784322, blue: 0.7960784435, alpha: 1)
				actions[1].backgroundColor = #colorLiteral(red: 1, green: 0.5607843399, blue: 0, alpha: 1)
			} else if edge == .trailing { // Swipe Left Actions
				actions = [
					NSTableViewRowAction(style: .destructive, title: "Delete", handler: { action, select in
						log.info("Delete row:\(select)")
					}),
					NSTableViewRowAction(style: .regular, title: "Archive", handler: { action, select in
						log.info("Archive row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = #colorLiteral(red: 1, green: 0.5607843399, blue: 0, alpha: 1)
				actions[1].backgroundColor = #colorLiteral(red: 0.7882353067, green: 0.09019608051, blue: 0.1215686277, alpha: 1)
			}
			return actions
		}
	}
	
	var userList: UserList? // FIXME
	var conversationList: Hangouts.ConversationList? {
		didSet {
			conversationList?.delegate = self
			DispatchQueue.main.async {
				self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			}
		}
	}
	
	private func _getPerson(_ conversation: IConversation) -> ConversationView.Info {
		
		// Propogate info for data filling
		let a = conversation.messages.last?.userID
		let b = conversation.users.filter { $0.isSelf }.first?.id
		let c = conversation.users.filter { !$0.isSelf }.first
		let network_ = conversation.conversation.networkType
		let d = NetworkType(rawValue: network_[0].rawValue) // FIXME weird stuff here
		
		// Patch for Google Voice contacts to show their numbers.
		// FIXME: Sometimes [1] is actually you, fix that.
		var title = conversation.name
		if title == "Unknown" {
			if conversation.conversation.participantData.count > 0 {
				title = conversation.conversation.participantData[1].fallbackName! as String
			}
		}
		
		// Load all the field values from the conversation.
		var img: NSImage = defaultUserImage
		if let d = fetchData(c?.id.gaiaID, c?.photoURL) {
			img = NSImage(data: d)!
		}
		
		let ring = d == NetworkType.GoogleVoice ? #colorLiteral(red: 0, green: 0.611764729, blue: 1, alpha: 1) : #colorLiteral(red: 0.03921568766, green: 0.9098039269, blue: 0.3686274588, alpha: 1)
		let cap = d == NetworkType.GoogleVoice ? "Google Voice" : "Hangouts"
		let ind = conversation.unread_events.count
		let name = title
		let sub = (a != b ? "" : "You: ") + (conversation.messages.last?.text ?? "")
		let time = conversation.messages.last?.timestamp ?? .origin
		
		return ConversationView.Info(photo: img, caption: cap, highlight: ring, indicator: ind, primary: name, secondary: sub, time: time)
	}
	
	private func _getAllPersons() -> [ConversationView.Info]? {
		return self.conversationList?._conversations.map { _getPerson($0) }
	}
	
	func conversationList(_ list: Hangouts.ConversationList, didReceiveEvent event: IEvent) {}
	func conversationList(_ list: Hangouts.ConversationList, didChangeTypingStatusTo status: TypingType) {}
	func conversationList(_ list: Hangouts.ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {}
	
	/* TODO: Just updat
	e the row that is updated. */
	func conversationList(didUpdate list: Hangouts.ConversationList) {
		DispatchQueue.main.async {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
		}
	}
	
	/* TODO: Just update the row that is updated. */
	func conversationList(_ list: Hangouts.ConversationList, didUpdateConversation conversation: IConversation) {
		DispatchQueue.main.async {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
		}
	}*/
}

// Boilerplate stuff for NCWidgetProviding
extension ParrotViewController: NCWidgetProviding {
	override var nibName: String? {
		return self.className
	}
	func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: EdgeInsets) -> EdgeInsets {
		return NSEdgeInsetsZero
	}
	func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
		completionHandler(.newData)
	}
	var widgetAllowsEditing: Bool {
		return false
	}
}
