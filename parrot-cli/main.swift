import Hangouts
import Dispatch
import Foundation
import os
import XPCTransport
import ParrotServiceExtension

// Sign in first.
var server = XPCConnection(name: "com.avaidyam.Parrot.parrotd")
server.active = true
let cookies = try! server.sync(AuthenticationInvocation.self)
let config = URLSessionConfiguration.default
AuthenticationInvocation.unpackage(cookies).forEach {
    config.httpCookieStorage?.setCookie($0)
}
let client = Client(configuration: config)

// Non-interactive: block the interactive screen mode and enter the runloop.
if !CommandLine.arguments.contains("--interactive") {
    client.conversationList.conversations.forEach {
        print($0.value.identifier + "\t" + $0.value.name)
    }
    dispatchMain()
}

// Block CTRL-C in favor of our `q` action.
signal(SIGTERM) { _ in }
signal(SIGINT) { _ in }

Termbox.app(inputMode: [.esc, .mouse]) {
    
    drawBorder(Rect(origin: Point(x: 0, y: 0), size: Termbox.size),
               foreground: .white, background: .red)
    client.conversationList.conversations.enumerated().forEach {
        $0.element.value.name.draw(at: Point(x: 1, y: $0.offset + 1),
                                   foreground: .white, background: .red)
    }
    "✖\u{20DD} Conversations".draw(at: Point(x: 1, y: 0),
                                     foreground: [.white, .bold], background: .red)
    
    Termbox.refresh()
    outer: while true {
        guard let event = Event.poll() else { continue }
        
        switch event {
        case let .key(_, value) where value == .space:
            continue
            
        case let .key(_, value) where value == .ctrlC:
            break outer
        case let .key(_, value) where value == .ctrlZ:
            Termbox.clear()
            
        case let .mouse(_, y) where y < Int32(Termbox.size.height - 1):
            continue
        
        case .resize(_, _):
            Termbox.refresh()
        default:
            continue
        }
        Termbox.refresh()
    }
}
