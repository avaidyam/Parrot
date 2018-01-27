import Foundation

public final class Observation {
    private let dispose: () -> ()
    public init(_ dispose: @escaping () -> ()) {
        self.dispose = dispose
    }
    public func invalidate() {
        self.dispose()
    }
    deinit {
        self.dispose()
    }
}

// from @chriseidhof: http://chris.eidhof.nl/post/references/
public final class Observable<A> {
    public typealias Observer = (A) -> ()
    
    private let _get: () -> A
    private let _set: (A) -> ()
    private let _observe: (@escaping Observer) -> Observation
    
    ///
    public var value: A {
        get { return self._get() }
        set { self._set(newValue) }
    }
    
    ///
    internal init(get: @escaping () -> A, set: @escaping (A) -> (), 
                  observe: @escaping (@escaping Observer) -> Observation) {
        self._get = get
        self._set = set
        self._observe = observe
    }
    
    ///
    public convenience init(_ initialValue: A) {
        var observers: [Int: Observer] = [:]
        var theValue = initialValue {
            didSet { observers.values.forEach { $0(theValue) } }
        }
        var freshId = (Int.min...).makeIterator()
        
        let get = { theValue }
        let set = { newValue in theValue = newValue }
        let observe = { (newObserver: @escaping Observer) -> Observation in
            let id = freshId.next()!
            observers[id] = newObserver
            return Observation { observers[id] = nil }
        }
        self.init(get: get, set: set, observe: observe)
    }
    
    ///
    public func observe(observer: @escaping Observer) -> Observation {
        return self._observe(observer)
    }
    
    ///
    public subscript<B>(keyPath: WritableKeyPath<A,B>) -> Observable<B> {
        let parent = self
        return Observable<B>(get: {
            parent._get()[keyPath: keyPath]
        }, set: {
            var oldValue = parent.value
            oldValue[keyPath: keyPath] = $0
            parent._set(oldValue)
        }, observe: { observer in
            parent.observe { observer($0[keyPath: keyPath]) }
        })
    }
}

public extension Observable where A: MutableCollection {
    
    ///
    public subscript(index: A.Index) -> Observable<A.Element> {
        return Observable<A.Element>(get: {
            self._get()[index]
        }, set: { newValue in
            var old = self.value
            old[index] = newValue
            self._set(old)
        }, observe: { observer in
            self.observe { observer($0[index]) }
        })
    }
}
