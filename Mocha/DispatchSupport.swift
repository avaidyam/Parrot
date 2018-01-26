import Dispatch

/* TODO: DispatchWorkItem: name, dependencies, isExecuting, Result<Any, Error> + retry. */

// Marks global and main queues in an accessible way.
public extension DispatchQueue {
    
    public enum QueueType: Equatable {
        case main
        case global(DispatchQoS.QoSClass)
        case custom(String?)
        
        public static func ==(lhs: QueueType, rhs: QueueType) -> Bool {
            switch (lhs, rhs) {
            case (let .global(qos1), let .global(qos2)):
                return qos1 == qos2
            case (let .custom(str1), let .custom(str2)):
                return str1 == str2
            case (.main, .main):
                return true
            default:
                return false
            }
        }
    }
    
    /// Retrieve the current queue AuxType, and bootstrap the system if needed.
    /// Note: bootstrapping occurs on the invoking queue.
    /// Note: if invoked, no label is returned for a custom queue.
    public static var current: QueueType {
        _ = DispatchQueue.setupQueueToken
        return DispatchQueue.getSpecific(key: DispatchQueue._key) ?? .custom(nil)
    }
    
    public var queueType: QueueType {
        _ = DispatchQueue.setupQueueToken
        return self.getSpecific(key: DispatchQueue._key) ?? .custom(self.label)
    }
    
    private static let _key = DispatchSpecificKey<DispatchQueue.QueueType>()
    private static var setupQueueToken: Void = {
        DispatchQueue.main.setSpecific(key: _key, value: .main)
        DispatchQueue.global(qos: .background).setSpecific(key: _key, value: .global(.background))
        DispatchQueue.global(qos: .default).setSpecific(key: _key, value: .global(.default))
        DispatchQueue.global(qos: .userInitiated).setSpecific(key: _key, value: .global(.userInitiated))
        DispatchQueue.global(qos: .userInteractive).setSpecific(key: _key, value: .global(.userInteractive))
        DispatchQueue.global(qos: .utility).setSpecific(key: _key, value: .global(.utility))
        return ()
    }()
}
