//
//  Promise.swift
//  Promise
//
//  Created by Soroush Khanlou on 7/21/16.
//
//

import Foundation

struct Callback<Value> {
    let onFulfilled: (Value) -> ()
    let onRejected: (ErrorProtocol) -> ()
    let queue: DispatchQueue
    
    func callFulfill(_ value: Value) {
        queue.async(execute: {
            self.onFulfilled(value)
        })
    }
    
    func callReject(_ error: ErrorProtocol) {
        queue.async(execute: {
            self.onRejected(error)
        })
    }
}

enum State<Value>: CustomStringConvertible {
    
    /// The promise has not completed yet.
    /// Will transition to either the `fulfilled` or `rejected` state.
    case pending
    
    /// The promise now has a value.
    /// Will not transition to any other state.
    case fulfilled(value: Value)
    
    /// The promise failed with the included error.
    /// Will not transition to any other state.
    case rejected(error: ErrorProtocol)
    
    
    var isPending: Bool {
        if case .pending = self {
            return true
        } else {
            return false
        }
    }
    
    var isFulfilled: Bool {
        if case .fulfilled = self {
            return true
        } else {
            return false
        }
    }
    
    var isRejected: Bool {
        if case .rejected = self {
            return true
        } else {
            return false
        }
    }
    
    var value: Value? {
        if case let .fulfilled(value) = self {
            return value
        }
        return nil
    }
    
    var error: ErrorProtocol? {
        if case let .rejected(error) = self {
            return error
        }
        return nil
    }
    
    
    var description: String {
        switch self {
        case .fulfilled(let value):
            return "Fulfilled (\(value))"
        case .rejected(let error):
            return "Rejected (\(error))"
        case .pending:
            return "Pending"
        }
    }
}

private let lockQueue = DispatchQueue(label: "promise_lock_queue", attributes: [.qosUserInitiated], target: nil)

public final class Promise<Value> {
    
    private var state: State<Value>
    private var callbacks: [Callback<Value>] = []
    
    public init() {
        state = .pending
    }
    
    public init(value: Value) {
        state = .fulfilled(value: value)
    }
    
    public init(error: ErrorProtocol) {
        state = .rejected(error: error)
    }
    
    public convenience init(queue: DispatchQueue = DispatchQueue.global(attributes: .qosUserInitiated),
                            work: ((Value) -> Void, (ErrorProtocol) -> Void) throws -> Void) {
        self.init()
        queue.async(execute: {
            do {
                try work(self.fulfill, self.reject)
            } catch let error {
                self.reject(error)
            }
        })
    }

    /// - note: This one is "flatMap"
    @discardableResult
    public func then<NewValue>(on queue: DispatchQueue = .main, _ onFulfilled: (Value) throws -> Promise<NewValue>) -> Promise<NewValue> {
        return Promise<NewValue>(work: { fulfill, reject in
            self.addCallbacks(
                on: queue,
                onFulfilled: { value in
                    do {
                        try onFulfilled(value).then(on: .main, fulfill, reject)
                    } catch let error {
                        reject(error)
                    }
                },
                onRejected: reject
            )
        })
    }
    
    /// - note: This one is "map"
    @discardableResult
    public func then<NewValue>(on queue: DispatchQueue = .main, _ onFulfilled: (Value) throws -> NewValue) -> Promise<NewValue> {
        return then(on: queue, { (value) -> Promise<NewValue> in
            do {
                return Promise<NewValue>(value: try onFulfilled(value))
            } catch let error {
                return Promise<NewValue>(error: error)
            }
        })
    }
    
    @discardableResult
    public func then(on queue: DispatchQueue = .main, _ onFulfilled: (Value) -> Void, _ onRejected: (ErrorProtocol) -> Void) -> Promise<Value> {
        return Promise<Value>(work: { fulfill, reject in
            self.addCallbacks(
                on: queue,
                onFulfilled: { value in
                    fulfill(value)
                    onFulfilled(value)
                },
                onRejected: { error in
                    reject(error)
                    onRejected(error)
                }
            )
        })
    }

    @discardableResult
    public func then(on queue: DispatchQueue = .main, _ onFulfilled: (Value) -> Void) -> Promise<Value> {
        return then(on: queue, onFulfilled, { _ in })
    }
    
    public func `catch`(on queue: DispatchQueue, _ onRejected: (ErrorProtocol) -> Void) -> Promise<Value> {
        return then(on: queue, { _ in }, onRejected)
    }
    
    @discardableResult
    public func `catch`(_ onRejected: (ErrorProtocol) -> Void) -> Promise<Value> {
        return then(on: DispatchQueue.main, { _ in }, onRejected)
    }
    
    public func reject(_ error: ErrorProtocol) {
        updateState(.rejected(error: error))
    }
    
    public func fulfill(_ value: Value) {
        updateState(.fulfilled(value: value))
    }
    
    public var isPending: Bool {
        return !isFulfilled && !isRejected
    }
    
    public var isFulfilled: Bool {
        return value != nil
    }
    
    public var isRejected: Bool {
        return error != nil
    }
    
    public var value: Value? {
        var result: Value?
        lockQueue.sync(execute: {
            result = self.state.value
        })
        return result
    }
    
    public var error: ErrorProtocol? {
        var result: ErrorProtocol?
        lockQueue.sync(execute: {
            result = self.state.error
        })
        return result
    }
    
    private func updateState(_ state: State<Value>) {
        guard self.isPending else { return }
        lockQueue.sync(execute: {
            self.state = state
        })
        fireCallbacksIfCompleted()
    }
    
    private func addCallbacks(on queue: DispatchQueue, onFulfilled: (Value) -> Void, onRejected: (ErrorProtocol) -> ()) {
        let callback = Callback(onFulfilled: onFulfilled, onRejected: onRejected, queue: queue)
        lockQueue.async(execute: {
            self.callbacks.append(callback)
        })
        fireCallbacksIfCompleted()
    }
    
    private func fireCallbacksIfCompleted() {
        lockQueue.async(execute: {
            guard !self.state.isPending else { return }
            self.callbacks.forEach { callback in
                switch self.state {
                case let .fulfilled(value):
                    callback.callFulfill(value)
                case let .rejected(error):
                    callback.callReject(error)
                default:
                    break
                }
            }
            self.callbacks.removeAll()
        })
    }
}


extension Promise {
    /// Wait for all the promises you give it to fulfill, and once they have, fulfill itself
    /// with the array of all fulfilled values.
    public static func all<T>(_ promises: [Promise<T>]) -> Promise<[T]> {
        return Promise<[T]>(work: { fulfill, reject in
            guard !promises.isEmpty else { fulfill([]); return }
            for promise in promises {
                promise.then({ value in
                    if !promises.contains({ $0.isRejected || $0.isPending }) {
                        fulfill(promises.flatMap({ $0.value }))
                    }
                }).catch({ error in
                    reject(error)
                })
            }
        })
    }
    
    /// Resolves itself after some delay.
    /// - parameter delay: In seconds
    public static func delay(_ delay: TimeInterval) -> Promise<()> {
        return Promise<()>(work: { fulfill, reject in
            DispatchQueue.main.after(when: .now() + delay) {
                fulfill(())
            }
        })
    }
    
    /// This promise will be rejected after a delay.
    public static func timeout<T>(_ timeout: TimeInterval) -> Promise<T> {
        return Promise<T>(work: { fulfill, reject in
            delay(timeout).then({ _ in
                reject(NSError(domain: "com.khanlou.Promise", code: -1111, userInfo: [ NSLocalizedDescriptionKey: "Timed out" ]))
            })
        })
    }
    
    /// Fulfills or rejects with the first promise that completes
    /// (as opposed to waiting for all of them, like `.all()` does).
    public static func race<T>(_ promises: [Promise<T>]) -> Promise<T> {
        return Promise<T>(work: { fulfill, reject in
            guard !promises.isEmpty else { fatalError() }
            for promise in promises {
                promise.then(on: .main, fulfill, reject)
            }
        })
    }
    public func addTimeout(_ timeout: TimeInterval) -> Promise<Value> {
        return Promise.race(Array([self, Promise<Value>.timeout(timeout)]))
    }
    
    @discardableResult
    public func always(on queue: DispatchQueue, _ onComplete: () -> ()) -> Promise<Value> {
        return then(on: queue, { _ in
            onComplete()
            }, { _ in
                onComplete()
        })
    }
    
    @discardableResult
    public func always(_ onComplete: () -> ()) -> Promise<Value> {
        return always(on: DispatchQueue.main, onComplete)
    }
    
    /*
    public func recover(_ recovery: (ErrorProtocol) -> Promise<Value>) -> Promise<Value> {
        return Promise(work: { fulfill, reject in
            self.then(fulfill).catch({ error in
                recovery(error).then(fulfill, reject)
            })
        })
    }
    
    public static func retry<T>(count: Int, delay: TimeInterval, generate: () -> Promise<T>) -> Promise<T> {
        if count <= 0 {
            return generate()
        }
        return Promise<T>(work: { fulfill, reject in
            generate().recover({ error in
                return self.delay(delay).then({
                    return retry(count: count-1, delay: delay, generate: generate)
                })
            }).then(fulfill).catch(reject)
        })
    }
    */
    
    public static func zip<T, U>(_ first: Promise<T>, and second: Promise<U>) -> Promise<(T, U)> {
        return Promise<(T, U)>(work: { fulfill, reject in
            let resolver: (Any) -> () = { _ in
                if let firstValue = first.value, let secondValue = second.value {
                    fulfill((firstValue, secondValue))
                }
            }
            first.then(on: .main, resolver, reject)
            second.then(on: .main, resolver, reject)
        })
    }
}
