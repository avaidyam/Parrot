import Hangouts

// A TUI program uses your terminal (simulator) as a canvas and draws characters
// on it. Combined with user inputs, we can create applications similar those
// with a GUI.
// A terminal can display a fixed number of characters horizontally and
// vertically. Each character, in addition to its glyph, can have a foreground
// color, a background color, among other things.
//
// Let's see how that works with a function that prints a line of text:
/// - Parameters:
///   - x:          x location of the text.
///   - y:          y location of the text.
///   - text:       what does the text say.
///   - foreground: what attributes should the text have for its foreground.
///   - background: what attributes should the text have for its background.
func printAt(x: Int32, y: Int32, text: String,
             foreground: Attributes = .default, background: Attributes = .default)
{
    // We can get the terminal's height and width like this:
    let border = Termbox.width
    
    // We can update characters on the screen one at a time with, each with a
    // distinct style. Here we are going to start at `x` and set characters in
    // `text` until we run out of horizontal space in row `y`.
    for (c, xi) in zip(text.unicodeScalars, x ..< border) {
        Termbox.put(x: xi, y: y, character: c, foreground: foreground,
                    background: background)
    }
}

// There's more demo of the similar ideas as in `printAt` in this next function.
/// Draw a bar at the bottom to display help messages.
func updateHelp(drawing: UnicodeScalar) {
    let lastY = Termbox.height - 1
    let content = [
        "Drawing [\(drawing)]",
        "Press other character to change",
        "Use mouse to draw",
        "Press 'q' to quit"
        ].joined(separator: " | ")
    
    let filler = String(repeating: " ",
                        count: Int(Termbox.width) - content.unicodeScalars.count)
    
    printAt(x: 0, y: lastY, text: content + filler, foreground: .white,
            background: .blue)
}

// Now we handle some user input and update our canvas! This is going to be a
// painting program that lets user draw pictures with the mouse cursor.
func paint() {
    // It's routine to initialize the canvas and select input modes.
    do {
        try Termbox.initialize()
    } catch let error {
        print(error)
        return
    }
    Termbox.inputModes = [.esc, .mouse]
    
    // We let user select which character to paint with.
    var drawingCharacter: UnicodeScalar = "." {
        didSet {
            updateHelp(drawing: drawingCharacter)
        }
    }
    
    // prepare the help message for the first time.
    updateHelp(drawing: drawingCharacter)
    
    // `put` only update the content in an internal buffer. We have to call
    // `present` each time we are satified with changes we made in the buffer so
    // that the terminal will actually display it.
    Termbox.present()
    
    outer: while true {
        // We can pause the program to gather user input in the form of an
        // `Event`.
        guard let event = Termbox.pollEvent() else {
            continue
        }
        
        // There are several types of events. User pressed key for a character,
        // a control key, or clicked with a mouse. Each type of event comes with
        // different kinds of data. For example, mouse click comes with
        // a position while character event comes with the character.
        switch event {
        case let .character(_, value):
            if value == "q" { // quit the program if user pressed 'q'.
                break outer
            }
            // otherwise user has selected a new character to draw with.
            drawingCharacter = value
            
        case let .key(_, value):
            // we want to be able to draw the space character, which is
            // categorized under a `Event.key`.
            if value == .space {
                drawingCharacter = " "
            }
            
        case let .mouse(x, y):
            // As promised, mouse clicks comes with an x and a y position. We
            // draw the selected character at this position.
            Termbox.put(x: x, y: y, character: drawingCharacter,
                        foreground: .red)
        default:
            continue
        }
        
        // Again, need to call `present` to update the terminal.
        Termbox.present()
    }
    
    // this routine mirrors `initialize()`
    Termbox.shutdown()
}

paint()


/*
let sem = DispatchSemaphore(value: 0)
print("Initializing...")

// Authenticate and initialize the Hangouts client.
// Build the user and conversation lists.
var client: Client!
var userList: UserList!
var conversationList: ConversationList!

AuthenticatorCLI.authenticateClient {
	client = Client(configuration: $0)
	
	client.buildUserConversationList {
		userList = $0; conversationList = $1
		print("Obtained userList \(userList) and conversationList! \(conversationList)")
		sem.signal()
	}
}
_ = sem.wait(timeout: DispatchTime.distantFuture)
print("Continuing...")

print(conversationList.all_conversations.map { $0.conversation.conversationId })
*/
