import Foundation

public enum NotificationCenterType {
    
    /// This is the local NSNotificationCenter. The notifications will be broadcast 
    /// within the current process boundary.
    case local
    
    /// This is the NSDistributedNotificationCenter. The notifications will be broadcast
    /// to all processes owned by the current user. Note: this type assumes the origin
    /// `object` parameter of the Notification is a string identifier.
    case system
    
    /// This is the NSDistributedNotificationCenter. The notifications will be broadcast
    /// to all processes owned by any users.
    //case global // TODO: This is not supported yet.
    
    /// This is the NSDistributedNotificationCenter. The notifications will be broadcast
    /// via Bonjour to any network listener daemons.
    //case network // TODO: This is not supported yet.
    
    fileprivate var underlyingCenter: NotificationCenter {
        switch self {
        case .local: return NotificationCenter.default
        case .system: return DistributedNotificationCenter.default
        }
    }
}

/// Publish a Notification to the chosen NotificationCenter.
public func publish(on center: NotificationCenterType = .local, _ notification: Notification) {
    center.underlyingCenter.post(notification)
}

/// Subscribe for Notifications on the chosen NotificationCenter, dispatching to 
/// the provided `queue`. If a `source` is not provided, all notifications of `name`
/// will be forwarded to the `sink`. Upon registration of the sink, a transient 
/// subscription is returned. Use this to unsubscribe.
public func subscribe(on center: NotificationCenterType = .local, queue: DispatchQueue = .main,
                      source: Any?, _ name: Notification.Name, sink: @escaping (Notification) -> ()) -> Any {
    return center.underlyingCenter.addObserver(forName: name, object: source, queue: nil, using: { n in
        queue.async {
            sink(n)
        }
    })
}

/// Unsubscribe from a Notification on the chosen NotificationCenter, removing the sink.
public func unsubscribe(on center: NotificationCenterType = .local, _ subscription: Any?) {
    guard subscription != nil else { return }
    center.underlyingCenter.removeObserver(subscription!)
}
