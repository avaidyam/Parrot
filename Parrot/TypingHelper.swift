<<<<<<< Updated upstream
import Cocoa
import protocol ParrotServiceExtension.Person
import enum ParrotServiceExtension.MessageError
import enum Hangouts.ServiceError
=======
import Foundation
import AddressBook
import protocol ParrotServiceExtension.Person

// FIXME: Temporary location...
public func searchContacts(person user: Person) -> [ABPerson] {
    var possible = [ABSearchElement]()
    for location in user.locations {
        possible.append(ABPerson.searchElement(
            forProperty: kABEmailProperty, label: "", key: "", value: location,
            comparison: ABSearchComparison(kABEqualCaseInsensitive.rawValue))!
        )
        possible.append(ABPerson.searchElement(
            forProperty: kABPhoneProperty, label: "", key: "", value: location,
            comparison: ABSearchComparison(kABEqualCaseInsensitive.rawValue))!
        )
    }
    
    let records = ABAddressBook.shared().records(
        matching: ABSearchElement(forConjunction:
            ABSearchConjunction(kABSearchOr.rawValue), children: possible)
        )!.flatMap { $0 as? ABPerson }
    return records
}
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
        DispatchQueue.main.asyncAfter(deadline: 1.seconds.later, execute: self.callback)
=======
        let dt = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dt, execute: self.callback)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

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
=======
>>>>>>> Stashed changes
