import Dispatch

/// TODO: Convert blocks to @escaping @throws... with (T) -> (U), () -> (T), (T) -> () forms.

public final class Promise<T> {
    
    public private(set) var name: String?
    public private(set) var index: Int
    
    fileprivate var delay: DispatchTimeInterval = .seconds(0)
    fileprivate var onQueue: DispatchQueue = .main
    fileprivate var promise: (Promise) -> ()
    
    public fileprivate(set) var error: Error?
    public fileprivate(set) var previousResult: T?
    
    fileprivate var next: Promise?
    fileprivate var catchThis: ((Promise) -> ())?
    fileprivate var finallyThis: ((Promise) -> ())?
    
    fileprivate init(name: String? = nil, on queue: DispatchQueue = .main,
                     after delay: DispatchTimeInterval = .seconds(0),
                     index: Int, do this: @escaping (Promise<T>) -> ()) {
        self.name = name
        self.index = index
        self.onQueue = queue
        self.delay = delay
        self.promise = this
    }
    
    public init(name: String? = nil, on queue: DispatchQueue = .main,
                after delay: DispatchTimeInterval = .seconds(0),
                do this: @escaping (Promise<T>) -> ()) {
        self.name = name
        self.index = 0
        self.onQueue = queue
        self.delay = delay
        self.promise = this
        
        let action = { self.promise(self) }
        if delay.toSeconds() > 0 {
            queue.asyncAfter(deadline: .now() + delay, execute: action)
        } else {
            queue.async(execute: action)
        }
    }
    
    /// Done Callback, should be called within every this and then closures
    ///
    /// - Parameters:
    ///   - error: error if any, will continue to the catch and finally closures
    ///   - result: result (optional) passed to the next then or finally closures
    public func done(result: T? = nil, error: Error? = nil) {
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
    public func `catch`(_ this: @escaping (Promise) -> ()) -> Promise {
        self.catchThis = this
        return self
    }
    
    public func `finally`(_ this: @escaping (Promise) -> ()) {
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

/// A Callback mimics the Swift do-catch-finally block asynchronously.
/// It's something like a Promise, but not chainable or "evaluatable."
///
/// sync: `do { ... } catch(...) { ... } finally { ... }`
///
/// async: `myFunc().do { value in ... }.catch { error in ... }.finally { ... }`
///
/// Note: `finally` always executes on the queue of the block executed
/// before itself; that is, if the `do` block was executed on a queue A,
/// `finally` will also execute there (and similarly for `catch`).
public final class Callback<T> {
    public enum Result {
        case result(T)
        case error(Error)
    }
    
    public private(set) var completed = false
    
    private var do_handler: (T) -> () = {_ in}
    private var catch_handler: (Error) -> () = {_ in}
    private var finally_handler: () -> () = {}
    
    private var do_queue: DispatchQueue? = nil
    private var catch_queue: DispatchQueue? = nil
    //private var finally_queue: DispatchQueue? = nil
    
    /// do { ... }
    public func `do`(on queue: DispatchQueue? = nil, _ handler: @escaping (T) -> ()) -> Callback<T> {
        self.do_queue = queue
        self.do_handler = handler
        return self
    }
    
    /// catch(let error) { ... }
    public func `catch`(on queue: DispatchQueue? = nil, _ handler: @escaping (Error) -> ()) -> Callback<T> {
        self.catch_queue = queue
        self.catch_handler = handler
        return self
    }
    
    /// finally { ... }
    public func `finally`(/*on queue: DispatchQueue? = nil, */_ handler: @escaping () -> ()) -> Callback<T> {
        //self.finally_queue = queue
        self.finally_handler = handler
        return self
    }
    
    // Server-side completion.
    public func complete(with result: Result) {
        guard !self.completed else { return }
        self.completed = true
        
        switch result {
        case .result(let value):
            self.perform(on: self.do_queue) {
                self.do_handler(value)
                self.finally_handler()
            }
        case .error(let error):
            self.perform(on: self.catch_queue) {
                self.catch_handler(error)
                self.finally_handler()
            }
        }
    }
    
    // Optional<DispatchQueue> support.
    private func perform(on queue: DispatchQueue?, _ handler: @escaping () -> ()) {
        if let q = queue {
            q.async(execute: handler)
        } else {
            handler()
        }
    }
}
