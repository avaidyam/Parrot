import Foundation

/* TODO: Add support for strongly typed event types (requires KeyValue*Coder). */
/*
// kind == "Module.TestEvent", userInfo == TestEvent()
public struct TestEvent: Subscription.Event {
    let str: String
}
*/

public class Subscription {
    
    /// Describes a trigger Event.
    public typealias Event = Notification
    
    fileprivate let handler: (Event) -> Void
    
    public private(set) var active = false
    public weak var location: NotificationCenter?
    public weak var queue: DispatchQueue?
    public private(set) var source: Any? //weak?
    public let name: Notification.Name
    
    /// Constructs a new subscription using the `where`, `on`, `from`, and `kind` parameters,
    /// that executes the provided handler when triggered on the `on` queue.
    /// Note: the handler also receives one optional dictionary parameter from the source.
    public init(where location: NotificationCenter = .default, on queue: DispatchQueue = .main, from source: Any? = nil,
                kind name: Notification.Name, _ handler: @escaping (Event) -> Void) {
        self.location = location
        self.queue = queue
        self.source = source
        self.name = name
        self.handler = handler
    }
    
    /// Be sure to dereference (and release!) the source object, if applicable.
    deinit {
        assert(!self.active, "Attempting to deinitialize an active Subscription!")
        self.source = nil
    }
    
    /// The worker function bridged into Objective-C.
    @objc dynamic private func _runHandler(_ note: Notification) {
        (self.queue ?? .main).async {
            self.handler(note)
        }
    }
    
    /// Subscribe for Events on the chosen Location, dispatching to
    /// the provided `queue`. If a `source` is not provided, all notifications of `name`
    /// will be forwarded to the `sink`. Upon registration of the sink, a transient
    /// subscription is returned. Use this to unsubscribe.
    public func activate() {
        guard let center = self.location, !self.active else { return }
        center.addObserver(self, selector: #selector(Subscription._runHandler(_:)),
                           name: self.name, object: self.source)
        self.active = true
    }
    
    /// Unsubscribe from a Notification on the chosen Location, removing the sink.
    public func deactivate() {
        guard let center = self.location, self.active else { return }
        center.removeObserver(self)
        self.active = false
    }
    
    /// Causes the Subscription's handler to be executed as if an Event had triggered it.
    /// Note: an optional `userInfo` may be provided, but the kind and source are 
    /// pre-set from the Subscription's parameters.
    public func trigger(_ userInfo: [AnyHashable : Any]? = nil) {
        self._runHandler(Event(name: self.name, object: self.source, userInfo: userInfo))
    }
}

/// The AutoSubscription class operates exactly the same as the Subscription class,
/// except it automatically activates when created, and deactivates as it is released.
public class AutoSubscription: Subscription {
    public override init(where location: NotificationCenter = .default, on queue: DispatchQueue = .main,
                         from source: Any? = nil,  kind name: Notification.Name,
                         _ handler: @escaping (Event) -> Void) {
        super.init(where: location, on: queue, from: source, kind: name, handler)
        self.activate()
    }
    deinit {
        self.deactivate()
    }
}

public extension Subscription.Event {
    
    /// Publish an Event to the chosen Location.
    public func post(to location: NotificationCenter = .default) {
        location.post(self)
    }
}

public extension NotificationCenter {
    public static var distributed: DistributedNotificationCenter {
        return DistributedNotificationCenter.default()
    }
}
