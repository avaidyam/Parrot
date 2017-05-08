import Dispatch

/// TODO: Convert blocks to @escaping @throws... with (T) -> (U), () -> (T), (T) -> () forms.

@discardableResult
public func promise(name: String? = nil, on queue: DispatchQueue = .main,
                    after delay: DispatchTimeInterval = .seconds(0),
                    do this: @escaping (Promise) -> ()) -> Promise {
    
    let first = Promise(name: name, on: queue, after: delay, index: 0, do: this)
    let action = {first.promise(first)}
    
    if delay.toSeconds() > 0 {
        queue.asyncAfter(deadline: .now() + delay, execute: action)
    } else {
        queue.async(execute: action)
    }
    return first
}

public class Promise {
    
    public private(set) var name: String?
    public private(set) var index: Int
    
    fileprivate var delay: DispatchTimeInterval = .seconds(0)
    fileprivate var onQueue: DispatchQueue = .main
    fileprivate var promise: (Promise) -> ()
    
    public fileprivate(set) var error: Error?
    public fileprivate(set) var previousResult: Any?
    
    fileprivate var next: Promise?
    fileprivate var catchThis: ((Promise) -> ())?
    fileprivate var finallyThis: ((Promise) -> ())?
    
    fileprivate init(name: String? = nil, on queue: DispatchQueue = .main,
                     after delay: DispatchTimeInterval = .seconds(0),
                     index: Int, do this: @escaping (Promise) -> ()) {
        self.name = name
        self.index = index
        self.onQueue = queue
        self.delay = delay
        self.promise = this
    }
    
    
    /// Done Callback, should be called within every this and then closures
    ///
    /// - Parameters:
    ///   - error: error if any, will continue to the catch and finally closures
    ///   - result: result (optional) passed to the next then or finally closures
    public func done(result: Any? = nil, error: Error? = nil) {
        if let error = error {
            self.error = error
            lastDo.catchThis?(self)
            lastDo.previousResult = result
            lastDo.finallyThis?(lastDo)
        } else if let next = self.next {
            if next.delay.toSeconds() > 0 {
                next.onQueue.asyncAfter(deadline: .now() + next.delay, execute: {
                    next.previousResult = result
                    next.promise(next)
                })
            } else {
                next.onQueue.async {
                    next.previousResult = result
                    next.promise(next)
                }
            }
        } else {
            lastDo.previousResult = result
            lastDo.finallyThis?(lastDo)
        }
    }
    
    public func then(name: String? = nil, on queue: DispatchQueue? = nil,
                     after delay: DispatchTimeInterval = .seconds(0),
                     do this: @escaping (Promise) -> ()) -> Promise {
        guard self.catchThis == nil else {
            fatalError("Can't call next() after catch()")
        }
        
        let queue = queue ?? self.onQueue
        let next = Promise(name: name, on: queue, after: delay, index: self.index + 1, do: this)
        self.next = next
        return next
    }
    
    @discardableResult
    public func `catch`(this: @escaping (Promise) -> ()) -> Promise {
        self.catchThis = this
        return self
    }
    
    public func finally(this: @escaping (Promise) -> ()) {
        self.finallyThis = this
    }
    
    private var lastDo: Promise {
        var last = self
        while let next = last.next {
            last = next
        }
        return last
    }
}
