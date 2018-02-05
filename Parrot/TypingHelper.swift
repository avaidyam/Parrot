import Cocoa
import protocol ParrotServiceExtension.Person
import enum ParrotServiceExtension.MessageError
import enum Hangouts.ServiceError

public struct TypingHelper {
    public enum State {
        case started
        case paused
        case stopped
    }
    
    public var handler: (State) -> ()
    public var typingTimeout = 0.4
    private var lastTypingTimestamp: Date?
    
    public init(handler: @escaping (State) -> ()) {
        self.handler = handler
    }
    
    public mutating func typing() {
        let now = Date()
        if self.lastTypingTimestamp == nil || now.timeIntervalSince(self.lastTypingTimestamp!) > typingTimeout {
            self.handler(.started)
        }
        
        self.lastTypingTimestamp = now
        DispatchQueue.main.asyncAfter(deadline: 1.seconds.later, execute: self.callback)
    }
    
    private func callback() {
        if let ts = self.lastTypingTimestamp , Date().timeIntervalSince(ts) > self.typingTimeout {
            self.handler(.stopped)
        } else {
            self.handler(.paused)
        }
    }
}

public extension NSObjectProtocol where Self: NSView {
    @discardableResult
    public func modernize(wantsLayer: Bool = false) -> Self {
        if !(self is NSTextView) { // Required for NSLayoutManager to lay out glyphs.
            self.postsFrameChangedNotifications = false
        }
        self.postsBoundsChangedNotifications = false
        self.translatesAutoresizingMaskIntoConstraints = false
        if wantsLayer { // Avoid explicit wantsLayer unless desired.
            self.wantsLayer = true
        }
        return self
    }
}

extension MessageError: LocalizedError {
    public var errorDescription: String? {
        return "The message couldn't be sent."
    }
    
    public var failureReason: String? {
        return "The messaging service doesn't support the kind of message you're trying to send."
    }
    
    public var recoverySuggestion: String? {
        return "Try sending a different kind of message instead, or use a provider."
    }
    
    public var helpAnchor: String? {
        return "Some services don't support rich messages like video or files, so you'll have to use a provider instead if you want to send those kinds of messages."
    }
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        return "An action you just made could not be completed."
    }
    
    public var failureReason: String? {
        return "Couldn't communicate with the service."
    }
    
    public var recoverySuggestion: String? {
        return "Make sure you're connected to the internet and allowed access for Parrot in your firewall settings."
    }
    
    public var helpAnchor: String? {
        return "Sometimes communicating with a remote service fails for unknown reasons. Try that again and it might work."
    }
}
