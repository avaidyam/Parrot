import Foundation

public class Subscription {
    
    /// Describes a trigger Event.
    public typealias Event = Notification
    
    /// Describes the Location where the stream of events come from.
    public enum Location {
        
        /// The events will be broadcast within the current process boundary.
        case local
        
        /// The events will be broadcast to all processes owned by the current user.
        /// Note: the origin `object` parameter of the Event MUST be a string.
        case system
        
        /// The events will be broadcast to all processes owned by any users.
        // TODO: This is not supported yet.
        //case global
        
        /// The events will be broadcast via Bonjour to any network listener daemons.
        // TODO: This is not supported yet.
        //case network
        
        fileprivate var underlyingCenter: NotificationCenter {
            switch self {
            case .local: return NotificationCenter.default
            case .system: return DistributedNotificationCenter.default
            }
        }
    }
    
    fileprivate let handler: (Event) -> Void
    
    public private(set) var active = false
    public let location: Location
    public let queue: DispatchQueue
    public private(set) var source: Any?
    public let name: Notification.Name
    
    /// Constructs a new subscription using the `where`, `on`, `from`, and `kind` parameters,
    /// that executes the provided handler when triggered on the `on` queue.
    /// Note: the handler also receives one optional dictionary parameter from the source.
    public init(where location: Location = .local, on queue: DispatchQueue = .main, from source: Any? = nil,
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
    @objc private func _runHandler(_ note: Notification) {
        self.queue.async {
            self.handler(note)
        }
    }
    
    /// Subscribe for Events on the chosen Location, dispatching to
    /// the provided `queue`. If a `source` is not provided, all notifications of `name`
    /// will be forwarded to the `sink`. Upon registration of the sink, a transient
    /// subscription is returned. Use this to unsubscribe.
    public func activate() {
        guard !self.active else { return }
        self.location.underlyingCenter.addObserver(self, selector: #selector(Subscription._runHandler(_:)),
                                                   name: self.name, object: self.source)
        self.active = true
    }
    
    /// Unsubscribe from a Notification on the chosen Location, removing the sink.
    public func deactivate() {
        guard self.active else { return }
        self.location.underlyingCenter.removeObserver(self)
        self.active = false
    }
}

/// The AutoSubscription class operates exactly the same as the Subscription class,
/// except it automatically activates when created, and deactivates as it is released.
public class AutoSubscription: Subscription {
    public override init(where location: Subscription.Location = .local, on queue: DispatchQueue = .main,
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
    public func post(to location: Subscription.Location = .local) {
        location.underlyingCenter.post(self)
    }
}
