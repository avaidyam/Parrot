import Foundation

/* TODO: Support sharing the Coder with super. */

//
// MARK: PBLiteEncoder
//

///
public class PBLiteEncoder {
    
    ///
    public struct Options: OptionSet {
        public typealias RawValue = Int
        public var rawValue: Int
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        ///
        public static let multipleRootContainers = Options(rawValue: 1 << 0)
        
        ///
        public static let primitiveRootValues = Options(rawValue: 1 << 1)
        
        ///
        public static let overwriteDuplicates = Options(rawValue: 1 << 2)
        
        // zeroIndexed?
    }
    
    public let options: Options
    public init(options: Options = []) {
        self.options = options
    }
    
    private var root: EncoderContainer? = nil
    public func encode<T: Encodable>(_ value: T) throws -> Any {
        self.root = EncoderContainer(owner: self, codingPath: [])
        try value.encode(to: self.root!)
        return self.root!.values()
    }
    
    public func encode<T: Encodable>(value: T) throws -> Data {
        let inner: Any = try self.encode(value)
        return try JSONSerialization.data(withJSONObject: inner, options: [])
    }
    
    //
    // MARK: PBLiteEncoder -> KeyedContainer
    //
    
    ///
    private class KeyedContainer<Key: CodingKey>: KeyedEncodingChildContainer {
        let owner: PBLiteEncoder
        var codingPath: [CodingKey?]
        var children: [Int: EncodingChildContainer] = [:]
        var content: [Int: Encodable] = [:]
        
        init(owner: PBLiteEncoder, codingPath: [CodingKey?]) {
            self.owner = owner
            self.codingPath = codingPath
        }
        
        //
        // MARK: PBLiteEncoder -> KeyedContainer -> Encoding
        //
        
        func encode<T: Encodable>(value: T, forKey key: Key) throws {
            if let _ = self.content.index(forKey: key.value()), !self.owner.options.contains(.overwriteDuplicates) {
                let desc = "Key \(key) already exists in the container."
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
            self.content[key.value()] = value
        }
        
        func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
            if let _ = self.content.index(forKey: key.value()), !self.owner.options.contains(.overwriteDuplicates) {
                let desc = "Key \(key) already exists in the container."
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
            let c = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [key])
            try value.encode(to: c)
            self.content[key.value()] = (c.values() as! Encodable)
        }
        
        func values() -> Any {
            var values = self.content as [Int: Any]
            let childValues = self.children.mapValues { $0.values() }
            childValues.forEach { values[$0.key] = $0.value }
            return KeyedContainer.transform(values)
        }
        
        //
        // MARK: PBLiteEncoder -> KeyedContainer -> ChildContainer
        //
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
            let container = KeyedContainer<NestedKey>(owner: self.owner, codingPath: self.codingPath + [key])
            self.children[key.value()] = container
            return KeyedEncodingContainer(container)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath + [key])
            self.children[key.value()] = container
            return container
        }
        
        func superEncoder() -> Encoder {
            let key = Key(intValue: 0)!
            return self.superEncoder(forKey: key)
        }
        
        func superEncoder(forKey key: Key) -> Encoder {
            let container = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [key])
            self.children[key.value()] = container
            return container
        }
        
        //
        // MARK: PBLiteEncoder -> KeyedContainer -> Misc
        //
        
        /// Convert between an Int-keyed Dictionary and Array.
        /// k-1 because protobuf message indexes start at 1.
        private static func transform(_ content: [Int: Any]) -> [Any] {
            let normal = content.filter { $0.key <= Int(Int16.max) }
            let extended = content.filter { $0.key > Int(Int16.max) }
            
            var arrayed: [Any] = Array<Any>(repeating: Optional<Any>.none as Any,
                                            count: normal.keys.max() ?? 0)
            for (k, v) in normal {
                arrayed[k - 1] = v
            }
            
            // Add the extended stuff to the end of the protobuf.
            if extended.count > 0 {
                if arrayed.count == 0 {
                    arrayed.append([]) // padding?
                }
                arrayed.append(extended.mapKeyValues { ("\($0)", $1) })
            }
            return arrayed
        }
    }
    
    //
    // MARK: PBLiteEncoder -> UnkeyedContainer
    //
    
    ///
    private class UnkeyedContainer: UnkeyedEncodingChildContainer {
        let owner: PBLiteEncoder
        var codingPath: [CodingKey?]
        var children: [EncodingChildContainer] = []
        var content: [Encodable] = []
        
        init(owner: PBLiteEncoder, codingPath: [CodingKey?]) {
            self.owner = owner
            self.codingPath = codingPath
        }
        
        //
        // MARK: PBLiteEncoder -> UnkeyedContainer -> Encoding
        //
        
        func encode<T: Encodable>(value: T) throws {
            self.content.append(value)
        }
        
        func encode<T: Encodable>(_ value: T) throws {
            let c = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [nil])
            try value.encode(to: c)
            self.content.append((c.values() as! Encodable))
        }
        
        func values() -> Any {
            return (self.content as [Any]) + self.children.map { $0.values() }
        }
        
        //
        // MARK: PBLiteEncoder -> UnkeyedContainer -> ChildContainer
        //
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
            let container = KeyedContainer<NestedKey>(owner: self.owner, codingPath: self.codingPath + [nil])
            self.children.append(container)
            return KeyedEncodingContainer(container)
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath + [nil])
            self.children.append(container)
            return container
        }
        
        func superEncoder() -> Encoder {
            let container = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [nil])
            self.children.append(container)
            return container
        }
        
        //
        // MARK: PBLiteEncoder -> UnkeyedContainer -> Misc
        //
        
        /*
         func throwIfExists<T: Encodable>(_ value: T, forKey key: Key) throws {
         if let _ = self.content.index(forKey: key.value()) {
         let desc = "Key \(key) already exists in the container."
         throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
         }
         }
         */
    }
    
    //
    // MARK: PBLiteEncoder -> SingleValueContainer
    //
    
    ///
    private class SingleValueContainer: SingleValueEncodingChildContainer {
        fileprivate var children: [EncodingChildContainer] {
            get { return [] } set { }
        }
        var content: [Encodable] = [] // strange way to not deal with Optional.
        
        let owner: PBLiteEncoder
        init(owner: PBLiteEncoder) {
            self.owner = owner
        }
        
        //
        // MARK: PBLiteEncoder -> SingleValueContainer -> Encoding
        //
        
        func encodeNil() throws {
            if self.content.count > 0 && !self.owner.options.contains(.overwriteDuplicates) {
                let desc = "Value already exists in the container."
                throw EncodingError.invalidValue(self.content[0] as Any, EncodingError.Context(codingPath: [], debugDescription: desc))
            }
            self.content = [Optional<Any>.none]
        }
        
        func encode<T: Encodable>(value: T) throws {
            if self.content.count > 0 && !self.owner.options.contains(.overwriteDuplicates) {
                let desc = "Value already exists in the container."
                throw EncodingError.invalidValue(value as Any, EncodingError.Context(codingPath: [], debugDescription: desc))
            }
            self.content = [value]
        }
        
        // uh should we do this?
        func encode<T: Encodable>(_ value: T) throws {
            if self.content.count > 0 && !self.owner.options.contains(.overwriteDuplicates) {
                let desc = "Value already exists in the container."
                throw EncodingError.invalidValue(value as Any, EncodingError.Context(codingPath: [], debugDescription: desc))
            }
            let c = EncoderContainer(owner: self.owner, codingPath: [nil])
            try value.encode(to: c)
            self.content = [c.values() as! Encodable]
        }
        
        func values() -> Any {
            // Keep the Optionals happy...
            if let inner = self.content.first {
                return inner
            } else {
                return Optional<Any>.none as Any
            }
        }
    }
    
    //
    // MARK: PBLiteCoder -> EncoderContainer
    //
    
    private class EncoderContainer: EncoderEncodingChildContainer {
        fileprivate let owner: PBLiteEncoder
        public var codingPath: [CodingKey?]
        public var userInfo: [CodingUserInfoKey : Any] = [:]
        internal var children: [EncodingChildContainer] = []
        
        init(owner: PBLiteEncoder, codingPath: [CodingKey?]) {
            self.owner = owner
            self.codingPath = codingPath
        }
        
        //
        // MARK: PBLiteCoder -> EncoderContainer -> Encoding
        //
        
        // message, dictionary
        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
            try! throwIfExists()
            let container = KeyedContainer<Key>(owner: self.owner, codingPath: self.codingPath)
            self.children.append(container)
            return KeyedEncodingContainer(container)
        }
        
        // array, set
        func unkeyedContainer() -> UnkeyedEncodingContainer {
            try! throwIfExists()
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath)
            self.children.append(container)
            return container
        }
        
        // values
        func singleValueContainer() -> SingleValueEncodingContainer {
            try! throwIfExists()
            let container = SingleValueContainer(owner: self.owner)
            self.children.append(container)
            return container
        }
        
        //
        // MARK: PBLiteCoder -> EncoderContainer -> Misc
        //
        
        private func throwIfExists() throws {
            if self.children.count > 0 && !self.owner.options.contains(.multipleRootContainers) {
                let desc = "This encoder is not configured to support multiple root containers."
                throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
        }
        
        func values() -> Any {
            if self.owner.options.contains(.multipleRootContainers) {
                return self.children.map { $0.values() }
            } else {
                return self.children[0].values()
            }
        }
    }
}

//
// MARK: Helpers
//

///
fileprivate extension CodingKey {
    func value() -> String {
        return self.stringValue
    }
    func value() -> Int {
        if let i = self.intValue { return i }
        fatalError("requires an integer coding key")
    }
}

///
fileprivate protocol EncodingChildContainer {
    
    ///
    func values() -> Any
}

fileprivate protocol EncoderEncodingChildContainer: Encoder, EncodingChildContainer {}
fileprivate protocol KeyedEncodingChildContainer: KeyedEncodingContainerProtocol, EncodingChildContainer {
    mutating func encode<T: Encodable>(value: T, forKey: Key) throws
}
fileprivate protocol UnkeyedEncodingChildContainer: UnkeyedEncodingContainer, EncodingChildContainer {
    mutating func encode<T: Encodable>(value: T) throws
}
fileprivate protocol SingleValueEncodingChildContainer: SingleValueEncodingContainer, EncodingChildContainer {
    mutating func encodeNil() throws
    mutating func encode<T: Encodable>(value: T) throws
}

fileprivate extension KeyedEncodingChildContainer {
    mutating func encode(_ value: Bool, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: Int, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: Int8, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: Int16, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: Int32, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: Int64, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: UInt, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: UInt8, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: UInt16, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: UInt32, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: UInt64, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: Float, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: Double, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
    
    mutating func encode(_ value: String, forKey key: Key) throws {
        try encode(value: value, forKey: key)
    }
}

fileprivate extension UnkeyedEncodingChildContainer {
    mutating func encode(_ value: Bool) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int8) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int16) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int32) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int64) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt8) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt16) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt32) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt64) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Float) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Double) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: String) throws {
        try self.encode(value: value)
    }
    
    mutating func encode<T: Encodable>(_ value: T) throws {
        try self.encode(value: value)
    }
}

fileprivate extension SingleValueEncodingChildContainer {
    mutating func encode(_ value: Bool) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int8) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int16) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int32) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Int64) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt8) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt16) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt32) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: UInt64) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Float) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: Double) throws {
        try self.encode(value: value)
    }
    
    mutating func encode(_ value: String) throws {
        try self.encode(value: value)
    }
    
    mutating func encode<T: Encodable>(_ value: T) throws {
        try self.encode(value: value)
    }
}

//
//
//

fileprivate extension Dictionary {
    func mapKeyValues<K, V> (transform: (Key, Value) -> (K, V)) -> Dictionary<K, V> {
        var results: Dictionary<K, V> = [:]
        for k in self.keys {
            if let value = self[k] {
                let (u, w) = transform(k, value)
                results.updateValue(w, forKey: u)
            }
        }
        return results
    }
}
