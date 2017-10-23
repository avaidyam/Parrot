import Foundation
import XPC
import os

/* TODO: Support SharedMemory and IOSurface. */

//
// MARK: Helpers
//

private let XPCDateInterval: TimeInterval = 1000000000

internal struct XPCCodingKey: CodingKey {
    init?(intValue: Int) {
        self.intValue = intValue
    }
    init?(stringValue: String) {
        return nil
    }
    
    var intValue: Int?
    var stringValue: String {
        return "\(self.intValue ?? 0)"
    }
}

fileprivate protocol DecodingChildContainer {}
fileprivate protocol EncodingChildContainer {
    func values() -> xpc_object_t
}

//
// MARK: XPCDecoder
//

///
public class XPCDecoder {
    
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
        public static let noPrimitiveRootValues = Options(rawValue: 1 << 1)
    }
    
    public let options: Options
    public init(options: Options = []) {
        self.options = options
    }
    
    private var root: DecoderContainer? = nil
    public func decode<T: Decodable>(_ type: T.Type, from value: xpc_object_t) throws -> T {
        self.root = DecoderContainer(owner: self, codingPath: [], content: value)
        return try T(from: self.root!)
    }
    
    //
    // MARK: XPCDecoder -> KeyedContainer
    //
    
    ///
    private class KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol, DecodingChildContainer {
        
        internal class Box {
            var content: [DecodingChildContainer] = []
        }
        
        var codingPath: [CodingKey]
        var children = Box()
        private let content: xpc_object_t
        
        let owner: XPCDecoder
        init(owner: XPCDecoder, codingPath: [CodingKey], content: xpc_object_t) {
            self.owner = owner
            self.codingPath = codingPath
            self.content = content
        }
        
        //
        // MARK: XPCDecoder -> KeyedContainer -> Decoding
        //
        
        func decodeNil(forKey key: Key) throws -> Bool {
            return key.stringValue.withCString {
                if let val = xpc_dictionary_get_value(self.content, $0) {
                    return xpc_get_type(val) == XPC_TYPE_NULL
                }
                return true
            }
        }
        
        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_bool(self.content, $0))
            }
        }
        
        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_int64(self.content, $0))
            }
        }
        
        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_int64(self.content, $0))
            }
        }
        
        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_int64(self.content, $0))
            }
        }
        
        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_int64(self.content, $0))
            }
        }
        
        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_int64(self.content, $0))
            }
        }
        
        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_uint64(self.content, $0))
            }
        }
        
        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_uint64(self.content, $0))
            }
        }
        
        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_uint64(self.content, $0))
            }
        }
        
        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_uint64(self.content, $0))
            }
        }
        
        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_uint64(self.content, $0))
            }
        }
        
        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_double(self.content, $0))
            }
        }
        
        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            return key.stringValue.withCString {
                type.init(xpc_dictionary_get_double(self.content, $0))
            }
        }
        
        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            return key.stringValue.withCString {
                String(cString: xpc_dictionary_get_string(self.content, $0)!)
            }
        }
        
        func decode(_ type: Date.Type, forKey key: Key) throws -> Date {
            return key.stringValue.withCString {
                Date(timeIntervalSince1970: Double(xpc_dictionary_get_date(self.content, $0)) / XPCDateInterval)
            }
        }
        
        func decode(_ type: Data.Type, forKey key: Key) throws -> Data {
            return key.stringValue.withCString {
                let value = xpc_dictionary_get_value(self.content, $0)!
                return Data(bytes: xpc_data_get_bytes_ptr(value)!, count: xpc_data_get_length(value))
            }
        }
        
        func decode(_ type: UUID.Type, forKey key: Key) throws -> UUID {
            return key.stringValue.withCString {
                NSUUID(uuidBytes: xpc_dictionary_get_uuid(self.content, $0)!) as UUID
            }
        }
        
        func decode(_ type: FileHandle.Type, forKey key: Key) throws -> FileHandle {
            return key.stringValue.withCString {
                return FileHandle(fileDescriptor: xpc_dictionary_dup_fd(self.content, $0), closeOnDealloc: true)
            }
        }
        
        func decode(_ type: XPCConnection.Type, forKey key: Key) throws -> XPCConnection {
            return key.stringValue.withCString {
                return XPCConnection(xpc_dictionary_create_connection(self.content, $0)!)
            }
        }
        
        func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            if type == Date.self {
                return try self.decode(Date.self, forKey: key) as! T
            } else if type == Data.self {
                return try self.decode(Data.self, forKey: key) as! T
            } else if type == UUID.self {
                return try self.decode(UUID.self, forKey: key) as! T
            } else if type == FileHandle.self {
                return try self.decode(FileHandle.self, forKey: key) as! T
            } else if type == XPCConnection.self {
                return try self.decode(XPCConnection.self, forKey: key) as! T
            } else {
                return try key.stringValue.withCString {
                    guard let outerValue = xpc_dictionary_get_value(self.content, $0) else {
                        let desc = "Expected type \(T.self) but container stored no such key."
                        throw DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
                    }
                    
                    return try T(from: DecoderContainer(owner: self.owner, codingPath: self.codingPath + [key], content: outerValue))
                }
            }
        }
        
        //
        // MARK: XPCDecoder -> KeyedContainer -> ChildContainer
        //
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
            return try key.stringValue.withCString {
                guard let outerValue = xpc_dictionary_get_value(self.content, $0) else {
                    let desc = "No dictionary element matching key \(key) in the container."
                    throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
                }
                
                let container = KeyedContainer<NestedKey>(owner: self.owner, codingPath: self.codingPath + [key], content: outerValue)
                self.children.content.append(container)
                return KeyedDecodingContainer(container)
            }
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            return try key.stringValue.withCString {
                guard let outerValue = xpc_dictionary_get_value(self.content, $0) else {
                    let desc = "No array element matching key \(key) in the container."
                    throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
                }
                
                let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath + [key], content: outerValue)
                self.children.content.append(container)
                return container
            }
        }
        
        func superDecoder() throws -> Decoder {
            let key = Key(stringValue: "super")! // or Key(intValue: 0)
            return try self.superDecoder(forKey: key)
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            return try key.stringValue.withCString {
                guard let outerValue = xpc_dictionary_get_value(self.content, $0) else {
                    let desc = "No dictionary superDecoder element matching key \(key) found in the container."
                    throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.codingPath + [key], debugDescription: desc))
                }
                
                let container = DecoderContainer(owner: self.owner, codingPath: self.codingPath + [key], content: outerValue)
                self.children.content.append(container)
                return container
            }
        }
        
        //
        // MARK: XPCDecoder -> KeyedContainer -> Misc
        //
        
        var allKeys: [Key] {
            var keys: [String] = []
            xpc_dictionary_apply(self.content) { key, _ in
                keys.append(String(cString: key)); return true
            }
            return keys.flatMap { Key(stringValue: $0) }
        }
        
        func contains(_ key: Key) -> Bool {
            return self.allKeys.contains { $0.stringValue == key.stringValue }
        }
    }
    
    //
    // MARK: XPCDecoder -> UnkeyedContainer
    //
    
    ///
    private class UnkeyedContainer: UnkeyedDecodingContainer, DecodingChildContainer {
        
        private let content: xpc_object_t
        var codingPath: [CodingKey]
        var count: Int? = nil
        var children: [DecodingChildContainer] = []
        var currentIndex: Int = 0
        
        let owner: XPCDecoder
        init(owner: XPCDecoder, codingPath: [CodingKey], content: xpc_object_t) {
            self.owner = owner
            self.codingPath = codingPath
            self.content = content
            self.count = xpc_array_get_count(content)
        }
        
        //
        // MARK: XPCDecoder -> UnkeyedContainer -> Decoding
        //
        
        func decodeNil() throws -> Bool {
            return xpc_get_type(xpc_array_get_value(self.content, try attemptIncrementIndex())) == XPC_TYPE_NULL
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            return xpc_array_get_bool(self.content, try attemptIncrementIndex())
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            return type.init(xpc_array_get_int64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            return type.init(xpc_array_get_int64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            return type.init(xpc_array_get_int64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            return type.init(xpc_array_get_int64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            return type.init(xpc_array_get_int64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            return type.init(xpc_array_get_uint64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            return type.init(xpc_array_get_uint64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            return type.init(xpc_array_get_uint64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            return type.init(xpc_array_get_uint64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            return type.init(xpc_array_get_uint64(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            return type.init(xpc_array_get_double(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            return type.init(xpc_array_get_double(self.content, try attemptIncrementIndex()))
        }
        
        func decode(_ type: String.Type) throws -> String {
            return String(cString: xpc_array_get_string(self.content, try attemptIncrementIndex())!)
        }
        
        func decode(_ type: Date.Type) throws -> Date {
            return Date(timeIntervalSince1970: Double(xpc_array_get_date(self.content, try attemptIncrementIndex())) / XPCDateInterval)
        }
        
        func decode(_ type: Data.Type) throws -> Data {
            let value = xpc_array_get_value(self.content, try attemptIncrementIndex())
            return Data(bytes: xpc_data_get_bytes_ptr(value)!, count: xpc_data_get_length(value))
        }
        
        func decode(_ type: UUID.Type) throws -> UUID {
            return NSUUID(uuidBytes: xpc_array_get_uuid(self.content, try attemptIncrementIndex())!) as UUID
        }
        
        func decode(_ type: FileHandle.Type) throws -> FileHandle {
            return FileHandle(fileDescriptor: xpc_array_dup_fd(self.content, try attemptIncrementIndex()), closeOnDealloc: true)
        }
        
        func decode(_ type: XPCConnection.Type) throws -> XPCConnection {
            return XPCConnection(xpc_array_create_connection(self.content, try attemptIncrementIndex())!)
        }
        
        func decode<T: Decodable>(_ type: T.Type) throws -> T {
            if type == Date.self {
                return try self.decode(Date.self) as! T
            } else if type == Data.self {
                return try self.decode(Data.self) as! T
            } else if type == UUID.self {
                return try self.decode(UUID.self) as! T
            } else if type == FileHandle.self {
                return try self.decode(FileHandle.self) as! T
            } else if type == XPCConnection.self {
                return try self.decode(XPCConnection.self) as! T
            } else {
                return try T(from: DecoderContainer(owner: self.owner,
                                                    codingPath: self.codingPath + [XPCCodingKey(intValue: self.currentIndex)!],
                                                    content: xpc_array_get_value(self.content, try attemptIncrementIndex())))
            }
        }
        
        //
        // MARK: XPCDecoder -> UnkeyedContainer -> ChildContainer
        //
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
            guard let outerValue = xpc_array_get_dictionary(self.content, try attemptIncrementIndex()) else {
                let desc = "Expected dictionary element but container stored nil."
                throw DecodingError.typeMismatch(Dictionary<String, Any>.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
            
            let container = KeyedContainer<NestedKey>(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: self.currentIndex)!], content: outerValue)
            self.children.append(container)
            return KeyedDecodingContainer(container)
        }
        
        func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            guard let outerValue = xpc_array_get_array(self.content, try attemptIncrementIndex()) else {
                let desc = "Expected array element but container stored nil."
                throw DecodingError.typeMismatch(Dictionary<String, Any>.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
            
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: self.currentIndex)!], content: outerValue)
            self.children.append(container)
            return container
        }
        
        func superDecoder() throws -> Decoder {
            let outerValue = xpc_array_get_value(self.content, try attemptIncrementIndex())
            
            let container = DecoderContainer(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: self.currentIndex)!], content: outerValue)
            self.children.append(container)
            return container
        }
        
        //
        // MARK: XPCDecoder -> UnkeyedContainer -> Misc
        //
        
        private func attemptIncrementIndex() throws -> Int {
            guard let count = self.count, self.currentIndex >= 0 && self.currentIndex < count else {
                let desc = "No more elements remaining in the container."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
            let val = self.currentIndex
            self.currentIndex += 1
            return val
        }
        
        var isAtEnd: Bool {
            return self.currentIndex == self.count
        }
    }
    
    //
    // MARK: XPCDecoder -> SingleValueContainer
    //
    
    ///
    private class SingleValueContainer: SingleValueDecodingContainer, DecodingChildContainer {
        
        private let content: xpc_object_t
        fileprivate var children: [DecodingChildContainer] {
            get { return [] } set { }
        }
        var codingPath: [CodingKey]
        
        let owner: XPCDecoder
        init(owner: XPCDecoder, codingPath: [CodingKey], content: xpc_object_t) {
            self.owner = owner
            self.codingPath = codingPath
            self.content = content
        }
        
        //
        // MARK: XPCDecoder -> SingleValueContainer -> Decoding
        //
        
        func decodeNil() -> Bool {
            return xpc_get_type(self.content) == XPC_TYPE_NULL
        }
        
        func decode(_ type: Bool.Type) throws -> Bool {
            try throwIfTypeMismatch(type, XPC_TYPE_BOOL)
            return xpc_bool_get_value(self.content)
        }
        
        func decode(_ type: Int.Type) throws -> Int {
            try throwIfTypeMismatch(type, XPC_TYPE_INT64)
            return type.init(xpc_int64_get_value(self.content))
        }
        
        func decode(_ type: Int8.Type) throws -> Int8 {
            try throwIfTypeMismatch(type, XPC_TYPE_INT64)
            return type.init(xpc_int64_get_value(self.content))
        }
        
        func decode(_ type: Int16.Type) throws -> Int16 {
            try throwIfTypeMismatch(type, XPC_TYPE_INT64)
            return type.init(xpc_int64_get_value(self.content))
        }
        
        func decode(_ type: Int32.Type) throws -> Int32 {
            try throwIfTypeMismatch(type, XPC_TYPE_INT64)
            return type.init(xpc_int64_get_value(self.content))
        }
        
        func decode(_ type: Int64.Type) throws -> Int64 {
            try throwIfTypeMismatch(type, XPC_TYPE_INT64)
            return type.init(xpc_int64_get_value(self.content))
        }
        
        func decode(_ type: UInt.Type) throws -> UInt {
            try throwIfTypeMismatch(type, XPC_TYPE_UINT64)
            return type.init(xpc_uint64_get_value(self.content))
        }
        
        func decode(_ type: UInt8.Type) throws -> UInt8 {
            try throwIfTypeMismatch(type, XPC_TYPE_UINT64)
            return type.init(xpc_uint64_get_value(self.content))
        }
        
        func decode(_ type: UInt16.Type) throws -> UInt16 {
            try throwIfTypeMismatch(type, XPC_TYPE_UINT64)
            return type.init(xpc_uint64_get_value(self.content))
        }
        
        func decode(_ type: UInt32.Type) throws -> UInt32 {
            try throwIfTypeMismatch(type, XPC_TYPE_UINT64)
            return type.init(xpc_uint64_get_value(self.content))
        }
        
        func decode(_ type: UInt64.Type) throws -> UInt64 {
            try throwIfTypeMismatch(type, XPC_TYPE_UINT64)
            return type.init(xpc_uint64_get_value(self.content))
        }
        
        func decode(_ type: Float.Type) throws -> Float {
            try throwIfTypeMismatch(type, XPC_TYPE_DOUBLE)
            return type.init(xpc_double_get_value(self.content))
        }
        
        func decode(_ type: Double.Type) throws -> Double {
            try throwIfTypeMismatch(type, XPC_TYPE_DOUBLE)
            return type.init(xpc_double_get_value(self.content))
        }
        
        func decode(_ type: String.Type) throws -> String {
            try throwIfTypeMismatch(type, XPC_TYPE_STRING)
            return String(cString: xpc_string_get_string_ptr(self.content)!)
        }
        
        func decode(_ type: Date.Type) throws -> Date {
            try throwIfTypeMismatch(type, XPC_TYPE_DATE)
            return Date(timeIntervalSince1970: Double(xpc_date_get_value(self.content)) / XPCDateInterval)
        }
        
        func decode(_ type: Data.Type) throws -> Data {
            try throwIfTypeMismatch(type, XPC_TYPE_DATA)
            return Data(bytes: xpc_data_get_bytes_ptr(self.content)!, count: xpc_data_get_length(self.content))
        }
        
        func decode(_ type: UUID.Type) throws -> UUID {
            try throwIfTypeMismatch(type, XPC_TYPE_UUID)
            return NSUUID(uuidBytes: xpc_uuid_get_bytes(self.content)!) as UUID
        }
        
        func decode(_ type: FileHandle.Type) throws -> FileHandle {
            try throwIfTypeMismatch(type, XPC_TYPE_FD)
            return FileHandle(fileDescriptor: xpc_fd_dup(self.content), closeOnDealloc: true)
        }
        
        func decode(_ type: XPCConnection.Type) throws -> XPCConnection {
            try throwIfTypeMismatch(type, XPC_TYPE_ENDPOINT)
            return XPCConnection(xpc_connection_create_from_endpoint(self.content))
        }
        
        func decode<T: Decodable>(_ type: T.Type) throws -> T {
            if type == Date.self {
                return try self.decode(Date.self) as! T
            } else if type == Data.self {
                return try self.decode(Data.self) as! T
            } else if type == UUID.self {
                return try self.decode(UUID.self) as! T
            } else if type == FileHandle.self {
                return try self.decode(FileHandle.self) as! T
            } else if type == XPCConnection.self {
                return try self.decode(XPCConnection.self) as! T
            } else {
                guard xpc_get_type(self.content) == XPC_TYPE_DICTIONARY || xpc_get_type(self.content) == XPC_TYPE_ARRAY else {
                    let desc = "Expected type \(type) but container stored value \(self.content)."
                    throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
                }
                
                return try T(from: DecoderContainer(owner: self.owner,
                                                    codingPath: self.codingPath,
                                                    content: self.content))
            }
        }
        
        //
        // MARK: XPCDecoder -> SingleValueContainer -> Misc
        //
        
        private func throwIfTypeMismatch<T>(_ type: T.Type, _ xpcType: xpc_type_t) throws {
            guard xpc_get_type(self.content) == xpcType else {
                let desc = "Expected type \(type) but container stored value \(self.content)."
                throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
        }
    }
    
    //
    // MARK: XPCDecoder -> DecoderContainer
    //
    
    private class DecoderContainer: Decoder, DecodingChildContainer {
        internal class Box {
            var content: [DecodingChildContainer] = []
        }
        
        public var codingPath: [CodingKey]
        public var userInfo: [CodingUserInfoKey : Any] = [:]
        
        fileprivate let owner: XPCDecoder
        internal var children = Box()
        fileprivate var content: xpc_object_t
        
        fileprivate init(owner: XPCDecoder, codingPath: [CodingKey], content: xpc_object_t) {
            self.owner = owner
            self.codingPath = codingPath
            self.content = content
        }
        
        //
        // MARK: XPCDecoder -> DecoderContainer -> ChildContainer
        //
        
        public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
            try! throwIfExists()
            guard xpc_get_type(self.content) == XPC_TYPE_DICTIONARY else {
                let desc = "This decoder's content could not support a keyed container."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
            
            let container = KeyedContainer<Key>(owner: self.owner, codingPath: self.codingPath, content: self.content)
            self.children.content.append(container)
            return KeyedDecodingContainer(container)
        }
        
        public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            try! throwIfExists()
            guard xpc_get_type(self.content) == XPC_TYPE_ARRAY else {
                let desc = "This decoder's content could not support an unkeyed container."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
            
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath, content: self.content)
            self.children.content.append(container)
            return container
        }
        
        public func singleValueContainer() throws -> SingleValueDecodingContainer {
            try! throwIfExists()
            if self.owner.options.contains(.noPrimitiveRootValues) {
                fatalError("This decoder does not support primitive root values.")
            }
            
            let container = SingleValueContainer(owner: self.owner, codingPath: self.codingPath, content: self.content)
            self.children.content.append(container)
            return container
        }
        
        //
        // MARK: XPCDecoder -> DecoderContainer -> Misc
        //
        
        private func throwIfExists() throws {
            if self.children.content.count > 0 && !self.owner.options.contains(.multipleRootContainers) {
                let desc = "This decoder is not configured to support multiple root containers."
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
        }
    }
}

//
// MARK: XPCEncoder
//

///
public class XPCEncoder {
    
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
        public static let noPrimitiveRootValues = Options(rawValue: 1 << 1)
        
        ///
        public static let overwriteDuplicates = Options(rawValue: 1 << 2)
    }
    
    public let options: Options
    public init(options: Options = []) {
        self.options = options
    }
    
    private var root: EncoderContainer? = nil
    public func encode<T: Encodable>(_ value: T) throws -> xpc_object_t {
        self.root = EncoderContainer(owner: self, codingPath: [])
        try value.encode(to: self.root!)
        return self.root!.values()
    }
    
    //
    // MARK: XPCEncoder -> KeyedContainer
    //
    
    ///
    private class KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol, EncodingChildContainer {
        
        let owner: XPCEncoder
        var codingPath: [CodingKey]
        var children: [String: EncodingChildContainer] = [:]
        var content: xpc_object_t = xpc_dictionary_create(nil, nil, 0)
        
        init(owner: XPCEncoder, codingPath: [CodingKey]) {
            self.owner = owner
            self.codingPath = codingPath
        }
        
        //
        // MARK: XPCEncoder -> KeyedContainer -> Encoding
        //
        
        func encodeNil(forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, xpc_null_create())
                xpc_dictionary_set_value(self.content, $0, xpc_null_create())
            }
        }
        
        func encode(_ value: Bool, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_bool_create(value))
            }
        }
        
        func encode(_ value: Int, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_int64_create(Int64(value)))
            }
        }
        
        func encode(_ value: Int8, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_int64_create(Int64(value)))
            }
        }
        
        func encode(_ value: Int16, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_int64_create(Int64(value)))
            }
        }
        
        func encode(_ value: Int32, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_int64_create(Int64(value)))
            }
        }
        
        func encode(_ value: Int64, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_int64_create(Int64(value)))
            }
        }
        
        func encode(_ value: UInt, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_uint64_create(UInt64(value)))
            }
        }
        
        func encode(_ value: UInt8, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_uint64_create(UInt64(value)))
            }
        }
        
        func encode(_ value: UInt16, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_uint64_create(UInt64(value)))
            }
        }
        
        func encode(_ value: UInt32, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_uint64_create(UInt64(value)))
            }
        }
        
        func encode(_ value: UInt64, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_uint64_create(UInt64(value)))
            }
        }
        
        func encode(_ value: Float, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_double_create(Double(value)))
            }
        }
        
        func encode(_ value: Double, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_value(self.content, $0, xpc_double_create(Double(value)))
            }
        }
        
        func encode(_ value: String, forKey key: Key) throws {
            try key.stringValue.withCString { k in
                try throwIfExists(key, k, value)
                value.withCString { v in
                    xpc_dictionary_set_value(self.content, k, xpc_string_create(v))
                }
            }
        }
        
        func encode(_ value: Date, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_date(self.content, $0, Int64(value.timeIntervalSince1970 * XPCDateInterval))
            }
        }
        
        func encode(_ value: Data, forKey key: Key) throws {
            try key.stringValue.withCString { k in
                try throwIfExists(key, k, value)
                value.withUnsafeBytes {
                    xpc_dictionary_set_data(self.content, k, $0, value.count)
                }
            }
        }
        
        func encode(_ value: UUID, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                var bytes = [UInt8](repeating: 0, count: 16)
                (value as NSUUID).getBytes(&bytes)
                xpc_dictionary_set_uuid(self.content, $0, bytes)
            }
        }
        
        func encode(_ value: FileHandle, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_fd(self.content, $0, value.fileDescriptor)
            }
        }
        
        func encode(_ value: XPCConnection, forKey key: Key) throws {
            try key.stringValue.withCString {
                try throwIfExists(key, $0, value)
                xpc_dictionary_set_connection(self.content, $0, value.connection)
            }
        }
        
        func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
            if value is Date {
                try self.encode(value as! Date, forKey: key)
            } else if value is Data {
                try self.encode(value as! Data, forKey: key)
            } else if value is UUID {
                try self.encode(value as! UUID, forKey: key)
            } else if value is FileHandle {
                try self.encode(value as! FileHandle, forKey: key)
            } else if value is XPCConnection {
                try self.encode(value as! XPCConnection, forKey: key)
            } else {
                try key.stringValue.withCString {
                    try throwIfExists(key, $0, value)
                    
                    let c = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [key])
                    try value.encode(to: c)
                    xpc_dictionary_set_value(self.content, $0, c.values())
                }
            }
        }
        
        func values() -> xpc_object_t {
            let childValues = self.children.mapValues { $0.values() }
            childValues.forEach { m in
                m.key.withCString {
                    xpc_dictionary_set_value(self.content, $0, m.value)
                }
            }
            return self.content
        }
        
        //
        // MARK: XPCEncoder -> KeyedContainer -> ChildContainer
        //
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
            let container = KeyedContainer<NestedKey>(owner: self.owner, codingPath: self.codingPath + [key])
            self.children[key.stringValue] = container
            return KeyedEncodingContainer(container)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath + [key])
            self.children[key.stringValue] = container
            return container
        }
        
        func superEncoder() -> Encoder {
            let key = Key(stringValue: "super")! // or Key(intValue: 0)
            return self.superEncoder(forKey: key)
        }
        
        func superEncoder(forKey key: Key) -> Encoder {
            let container = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [key])
            self.children[key.stringValue] = container
            return container
        }
        
        //
        //
        //
        
        private func throwIfExists(_ key: Key, _ id: UnsafePointer<Int8>, _ value: Any) throws {
            if xpc_dictionary_get_value(self.content, id) != nil && !self.owner.options.contains(.overwriteDuplicates) {
                let desc = "Key \(key) already exists in the container."
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
        }
    }
    
    //
    // MARK: XPCEncoder -> UnkeyedContainer
    //
    
    ///
    private class UnkeyedContainer: UnkeyedEncodingContainer, EncodingChildContainer {
        
        let owner: XPCEncoder
        var codingPath: [CodingKey]
        var children: [EncodingChildContainer] = []
        var content: xpc_object_t = xpc_array_create(nil, 0)
        var count: Int {
            return xpc_array_get_count(self.content)
        }
        
        init(owner: XPCEncoder, codingPath: [CodingKey]) {
            self.owner = owner
            self.codingPath = codingPath
        }
        
        //
        // MARK: XPCEncoder -> UnkeyedContainer -> Encoding
        //
        
        func encodeNil() throws {
            xpc_array_append_value(self.content, xpc_null_create())
        }
        
        func encode(_ value: Bool) throws {
            xpc_array_append_value(self.content, xpc_bool_create(value))
        }
        
        func encode(_ value: Int) throws {
            xpc_array_append_value(self.content, xpc_int64_create(Int64(value)))
        }
        
        func encode(_ value: Int8) throws {
            xpc_array_append_value(self.content, xpc_int64_create(Int64(value)))
        }
        
        func encode(_ value: Int16) throws {
            xpc_array_append_value(self.content, xpc_int64_create(Int64(value)))
        }
        
        func encode(_ value: Int32) throws {
            xpc_array_append_value(self.content, xpc_int64_create(Int64(value)))
        }
        
        func encode(_ value: Int64) throws {
            xpc_array_append_value(self.content, xpc_int64_create(Int64(value)))
        }
        
        func encode(_ value: UInt) throws {
            xpc_array_append_value(self.content, xpc_uint64_create(UInt64(value)))
        }
        
        func encode(_ value: UInt8) throws {
            xpc_array_append_value(self.content, xpc_uint64_create(UInt64(value)))
        }
        
        func encode(_ value: UInt16) throws {
            xpc_array_append_value(self.content, xpc_uint64_create(UInt64(value)))
        }
        
        func encode(_ value: UInt32) throws {
            xpc_array_append_value(self.content, xpc_uint64_create(UInt64(value)))
        }
        
        func encode(_ value: UInt64) throws {
            xpc_array_append_value(self.content, xpc_uint64_create(UInt64(value)))
        }
        
        func encode(_ value: Float) throws {
            xpc_array_append_value(self.content, xpc_double_create(Double(value)))
        }
        
        func encode(_ value: Double) throws {
            xpc_array_append_value(self.content, xpc_double_create(Double(value)))
        }
        
        func encode(_ value: String) throws {
            value.withCString {
                xpc_array_append_value(self.content, xpc_string_create($0))
            }
        }
        
        func encode(_ value: Date) throws {
            xpc_array_append_value(self.content, xpc_date_create(Int64(value.timeIntervalSince1970 * XPCDateInterval)))
        }
        
        func encode(_ value: Data) throws {
            value.withUnsafeBytes {
                xpc_array_append_value(self.content, xpc_data_create($0, value.count))
            }
        }
        
        func encode(_ value: UUID) throws {
            var bytes = [UInt8](repeating: 0, count: 16)
            (value as NSUUID).getBytes(&bytes)
            xpc_array_append_value(self.content, xpc_uuid_create(bytes))
        }
        
        func encode(_ value: FileHandle) throws {
            xpc_array_append_value(self.content, xpc_fd_create(value.fileDescriptor)!)
        }
        
        func encode(_ value: XPCConnection) throws {
            xpc_array_append_value(self.content, xpc_endpoint_create(value.connection))
        }
        
        func encode<T: Encodable>(_ value: T) throws {
            if value is Date {
                try self.encode(value as! Date)
            } else if value is Data {
                try self.encode(value as! Data)
            } else if value is UUID {
                try self.encode(value as! UUID)
            } else if value is FileHandle {
                try self.encode(value as! FileHandle)
            } else if value is XPCConnection {
                try self.encode(value as! XPCConnection)
            } else {
                let c = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: self.count)!])
                try value.encode(to: c)
                xpc_array_append_value(self.content, c.values())
            }
        }
        
        func values() -> xpc_object_t {
            self.children.forEach { xpc_array_append_value(self.content, $0.values()) }
            return self.content
        }
        
        //
        // MARK: XPCEncoder -> UnkeyedContainer -> ChildContainer
        //
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
            let container = KeyedContainer<NestedKey>(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: self.count)!])
            self.children.append(container)
            return KeyedEncodingContainer(container)
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: self.count)!])
            self.children.append(container)
            return container
        }
        
        func superEncoder() -> Encoder {
            let container = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: self.count)!])
            self.children.append(container)
            return container
        }
    }
    
    //
    // MARK: XPCEncoder -> SingleValueContainer
    //
    
    ///
    private class SingleValueContainer: SingleValueEncodingContainer, EncodingChildContainer {
        var codingPath: [CodingKey]
        var content: xpc_object_t?
        
        let owner: XPCEncoder
        init(owner: XPCEncoder, codingPath: [CodingKey]) {
            self.owner = owner
            self.codingPath = codingPath
        }
        
        //
        // MARK: XPCEncoder -> SingleValueContainer -> Encoding
        //
        
        func encodeNil() throws {
            try throwIfExists()
            self.content = xpc_null_create()
        }
        
        func encode(_ value: Bool) throws {
            try throwIfExists()
            self.content = xpc_bool_create(value)
        }
        
        func encode(_ value: Int) throws {
            try throwIfExists()
            self.content = xpc_int64_create(Int64(value))
        }
        
        func encode(_ value: Int8) throws {
            try throwIfExists()
            self.content = xpc_int64_create(Int64(value))
        }
        
        func encode(_ value: Int16) throws {
            try throwIfExists()
            self.content = xpc_int64_create(Int64(value))
        }
        
        func encode(_ value: Int32) throws {
            try throwIfExists()
            self.content = xpc_int64_create(Int64(value))
        }
        
        func encode(_ value: Int64) throws {
            try throwIfExists()
            self.content = xpc_int64_create(Int64(value))
        }
        
        func encode(_ value: UInt) throws {
            try throwIfExists()
            self.content = xpc_uint64_create(UInt64(value))
        }
        
        func encode(_ value: UInt8) throws {
            try throwIfExists()
            self.content = xpc_uint64_create(UInt64(value))
        }
        
        func encode(_ value: UInt16) throws {
            try throwIfExists()
            self.content = xpc_uint64_create(UInt64(value))
        }
        
        func encode(_ value: UInt32) throws {
            try throwIfExists()
            self.content = xpc_uint64_create(UInt64(value))
        }
        
        func encode(_ value: UInt64) throws {
            try throwIfExists()
            self.content = xpc_uint64_create(UInt64(value))
        }
        
        func encode(_ value: Float) throws {
            try throwIfExists()
            self.content = xpc_double_create(Double(value))
        }
        
        func encode(_ value: Double) throws {
            try throwIfExists()
            self.content = xpc_double_create(Double(value))
        }
        
        func encode(_ value: String) throws {
            try throwIfExists()
            value.withCString { self.content = xpc_string_create($0) }
        }
        
        func encode(_ value: Date) throws {
            try throwIfExists()
            self.content = xpc_date_create(Int64(value.timeIntervalSince1970 * XPCDateInterval))
        }
        
        func encode(_ value: Data) throws {
            try throwIfExists()
            value.withUnsafeBytes {
                self.content = xpc_data_create($0, value.count)
            }
        }
        
        func encode(_ value: UUID) throws {
            try throwIfExists()
            var bytes = [UInt8](repeating: 0, count: 16)
            (value as NSUUID).getBytes(&bytes)
            self.content = xpc_uuid_create(bytes)
        }
        
        func encode(_ value: FileHandle) throws {
            try throwIfExists()
            self.content = xpc_fd_create(value.fileDescriptor)!
        }
        
        func encode(_ value: XPCConnection) throws {
            try throwIfExists()
            self.content = xpc_endpoint_create(value.connection)
        }
        
        func encode<T: Encodable>(_ value: T) throws {
            try throwIfExists()
            if value is Date {
                try self.encode(value as! Date)
            } else if value is Data {
                try self.encode(value as! Data)
            } else if value is UUID {
                try self.encode(value as! UUID)
            } else if value is FileHandle {
                try self.encode(value as! FileHandle)
            } else if value is XPCConnection {
                try self.encode(value as! XPCConnection)
            } else {
                try throwIfExists()
                
                let c = EncoderContainer(owner: self.owner, codingPath: self.codingPath + [XPCCodingKey(intValue: 0)!])
                try value.encode(to: c)
                self.content = c.values()
            }
        }
        
        func values() -> xpc_object_t {
            /*
             if self.content == nil && !self.owner.options.contains(.overwriteDuplicates) {
             let desc = "Container was never encoded to."
             throw EncodingError.invalidValue(nil as Any, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
             }
             */
            
            return self.content ?? xpc_null_create()
        }
        
        //
        // MARK: SingleValueEncoder -> KeyedContainer -> Misc
        //
        
        private func throwIfExists() throws {
            if self.content != nil && !self.owner.options.contains(.overwriteDuplicates) {
                let desc = "Value already exists in the container."
                throw EncodingError.invalidValue(self.content as Any, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
        }
    }
    
    //
    // MARK: XPCCoder -> EncoderContainer
    //
    
    private class EncoderContainer: Encoder, EncodingChildContainer {
        internal class Box {
            var content: [EncodingChildContainer] = []
        }
        
        fileprivate let owner: XPCEncoder
        public var codingPath: [CodingKey]
        public var userInfo: [CodingUserInfoKey : Any] = [:]
        internal var children = Box()
        
        init(owner: XPCEncoder, codingPath: [CodingKey]) {
            self.owner = owner
            self.codingPath = codingPath
        }
        
        //
        // MARK: XPCCoder -> EncoderContainer -> Encoding
        //
        
        // message, dictionary
        func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
            try! throwIfExists()
            let container = KeyedContainer<Key>(owner: self.owner, codingPath: self.codingPath)
            self.children.content.append(container)
            return KeyedEncodingContainer(container)
        }
        
        // array, set
        func unkeyedContainer() -> UnkeyedEncodingContainer {
            try! throwIfExists()
            let container = UnkeyedContainer(owner: self.owner, codingPath: self.codingPath)
            self.children.content.append(container)
            return container
        }
        
        // values
        func singleValueContainer() -> SingleValueEncodingContainer {
            try! throwIfExists()
            if self.owner.options.contains(.noPrimitiveRootValues) {
                fatalError("This encoder does not support primitive root values.")
            }
            
            let container = SingleValueContainer(owner: self.owner, codingPath: self.codingPath)
            self.children.content.append(container)
            return container
        }
        
        //
        // MARK: XPCCoder -> EncoderContainer -> Misc
        //
        
        private func throwIfExists() throws {
            if self.children.content.count > 0 && !self.owner.options.contains(.multipleRootContainers) {
                let desc = "This encoder is not configured to support multiple root containers."
                throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: self.codingPath, debugDescription: desc))
            }
        }
        
        func values() -> xpc_object_t {
            //if self.owner.options.contains(.multipleRootContainers) {
            //    return self.children.content.map { $0.values() }
            //} else {
            return self.children.content[0].values()
            //}
        }
    }
}
