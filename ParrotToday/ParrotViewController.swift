import Cocoa
import NotificationCenter
import Hangouts

// Private service points go here:
private var _hangoutsClient: Client? = nil

class ParrotViewController: NSViewController, ConversationListDelegate {
	
	var personsView: PersonsView {
		return self.view as! PersonsView
	}
	var viewingVC: ConversationViewController? = nil
	
	// Sets up the content size and adds the edit view to the controller.
	override func loadView() {
		super.loadView()
		self.preferredContentSize = CGSize(width: 320, height: 480)
		self.setup()
	}
	
	// We're jumpstarted into the setup function here.
	func setup() {
		Authenticator.authenticateClient {
			_hangoutsClient = Client(configuration: $0)
			_hangoutsClient?.connect()
			
			NotificationCenter.default()
				.addObserver(forName: Client.didConnectNotification, object: _hangoutsClient!, queue: nil) { _ in
					_hangoutsClient!.buildUserConversationList { (userList, conversationList) in
						_REMOVE.forEach {
							$0(userList, conversationList)
						}
					}
			}
			
			self.personsView.updateScrollsToBottom = false
			
			/* TODO: VERY BAD! */
			_REMOVE.append {
				self.userList = $0
				self.conversationList = $1
				
				UI {
					self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
				}
				
				NotificationCenter.default().subscribe(name: UserDefaults.didChangeNotification.rawValue) { note in
					
					// Handle appearance colors.
					let dark = Settings[Parrot.DarkAppearance] as? Bool ?? false
					let appearance = (dark ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
					self.view.window?.appearance = NSAppearance(named: appearance)
				}
				
				// Instantiate storyboard and controller and begin the UI from here.
				DispatchQueue.main.async {
					self.viewingVC = ConversationViewController(nibName: "ConversationViewController", bundle: nil)
					self.viewingVC?.preferredContentSize = CGSize(width: 320, height: 480)
					
					self.selectionProvider = { row in
						self.viewingVC?.representedObject = self.conversationList?.conversations[row]
						self.present(inWidget: self.viewingVC!)
					}
				}
			}
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
						print("Mute row:\(select)")
					}),
					NSTableViewRowAction(style: .destructive, title: "Block", handler: { action, select in
						print("Block row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = NSColor.materialBlue()
				actions[1].backgroundColor = NSColor.materialAmber()
			} else if edge == .trailing { // Swipe Left Actions
				actions = [
					NSTableViewRowAction(style: .destructive, title: "Delete", handler: { action, select in
						print("Delete row:\(select)")
					}),
					NSTableViewRowAction(style: .regular, title: "Archive", handler: { action, select in
						print("Archive row:\(select)")
					})
				]
				
				// Fix the colors set by the given styles.
				actions[0].backgroundColor = NSColor.materialAmber()
				actions[1].backgroundColor = NSColor.materialRed()
			}
			return actions
		}
	}
	
	var userList: UserList? // FIXME
	var conversationList: ConversationList? {
		didSet {
			conversationList?.delegate = self
			UI {
				self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
			}
		}
	}
	
	private func _getPerson(_ conversation: IConversation) -> Person {
		
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
		
		let ring = d == NetworkType.GoogleVoice ? NSColor.materialBlue() : NSColor.materialGreen()
		let cap = d == NetworkType.GoogleVoice ? "Google Voice" : "Hangouts"
		let ind = conversation.unread_events.count
		let name = title
		let sub = (a != b ? "" : "You: ") + (conversation.messages.last?.text ?? "")
		let time = conversation.messages.last?.timestamp ?? Date(timeIntervalSince1970: 0)
		
		return Person(photo: img, caption: cap, highlight: ring, indicator: ind, primary: name, secondary: sub, time: time)
	}
	
	private func _getAllPersons() -> [Person]? {
		return self.conversationList?.conversations.map { _getPerson($0) }
	}
	
	func conversationList(_ list: ConversationList, didReceiveEvent event: IEvent) {}
	func conversationList(_ list: ConversationList, didChangeTypingStatusTo status: TypingType) {}
	func conversationList(_ list: ConversationList, didReceiveWatermarkNotification status: IWatermarkNotification) {}
	
	/* TODO: Just updat
	e the row that is updated. */
	func conversationList(didUpdate list: ConversationList) {
		UI {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
		}
	}
	
	/* TODO: Just update the row that is updated. */
	func conversationList(_ list: ConversationList, didUpdateConversation conversation: IConversation) {
		UI {
			self.personsView.dataSource = self._getAllPersons()!.map { Wrapper.init($0) }
		}
	}
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
