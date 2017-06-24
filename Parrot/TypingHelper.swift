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
