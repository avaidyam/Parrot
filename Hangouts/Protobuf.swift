import Foundation
import Mocha

// FIXME: syntax, imports, packages, map field types
// TODO: Does not support: services, extensions, options, inner class, oneof

private let COMMENT_REGEX = "((?:\\/\\*)(?:[\\s\\S]*)(?:\\*\\/))|((?:\\/\\/)(?:.*))"
private let MESSAGE_REGEX = "(?:message)(?:[\\s\\S]*?)(?:\\{)(?:[\\s\\S]*?)(?:\\})"
private let ENUM_REGEX = "(?:enum)(?:[\\s\\S]*?)(?:\\{)(?:[\\s\\S]*?)(?:\\})"
private let FIELD_REGEX = "(?:(required|optional|repeated))(?:.*)(?:\\;)"

//
//
//

typealias Hash = Int

@inline(__always)
func magic() -> UInt {
    #if arch(x86_64) || arch(arm64)
        return 0x9e3779b97f4a7c15
    #elseif arch(i386) || arch(arm)
        return 0x9e3779b9
    #endif
}

@inline(__always)
func combine(hashes: [Hash]) -> Hash {
    return hashes.reduce(0, combine(hash:with:))
}

@inline(__always)
func combine(hash initial: Hash, with other: Hash) -> Hash {
    var lhs = UInt(bitPattern: initial)
    let rhs = UInt(bitPattern: other)
    lhs ^= rhs &+ magic() &+ (lhs << 6) &+ (lhs >> 2)
    return Int(bitPattern: lhs)
}

extension Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self.hashValue
    }
}

extension Optional where Wrapped: Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self?.hashValue ?? 0
    }
}

extension Array where Element: Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self.reduce(5381) { ($0 << 5) &+ $0 &+ $1.hashValue }
    }
}

extension Dictionary where Value: Hashable {
    @inline(__always)
    func hash() -> Hash {
        return self.reduce(5381) { combine(hash: $0, with: combine(hash: $1.key.hashValue, with: $1.value.hashValue)) }
    }
}

//
//
//

public protocol _ProtoEnum {
    var rawValue: Int { get }
    init(_ rawValue: Int)
}

public protocol ProtoEnum: _ProtoEnum, ExpressibleByIntegerLiteral, RawRepresentable, Codable, Hashable {}
public extension ProtoEnum {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    public init?(rawValue value: Int) {
        self.init(value)
    }
    public var hashValue: Int {
        return self.rawValue.hashValue
    }
}

//
//
//

public protocol _ProtoMessage {
    init()
}
extension _ProtoMessage where Self: Hashable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
public typealias ProtoMessage = _ProtoMessage & Codable & Hashable

//
//
//

public enum ProtoImportDescriptor {
    case weak(String)
    case `public`(String)
}

public enum ProtoFieldLabel: String {
    case required, repeated, optional
}

public struct ProtoFieldDescriptor {
    public let id: Int
    public let name: String
    public let type: ProtoFieldType
    public let label: ProtoFieldLabel
    
    // use this sparingly...
    public var camelName: String {
        let comps = self.name.components(separatedBy: "_")
        return comps.dropFirst()
            .map { $0.capitalized }
            .reduce(comps.first!, +)
    }
}

public enum ProtoFieldType {
    case string
    case bytes
    case bool
    case double, float
    case int32, int64
    case uint32, uint64
    case sint32, sint64
    case fixed32, fixed64
    case sfixed32, sfixed64
    case prototype(String)
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(stringLiteral value: String) {
        switch value {
        case "string": self = .string
        case "bytes": self = .bytes
        case "bool": self = .bool
        case "double": self = .double
        case "float": self = .float
        case "int32": self = .int32
        case "int64": self = .int64
        case "uint32": self = .uint32
        case "uint64": self = .uint64
        case "sint32": self = .sint32
        case "sint64": self = .sint64
        case "fixed32": self = .fixed32
        case "fixed64": self = .fixed64
        case "sfixed32": self = .sfixed32
        case "sfixed64": self = .sfixed64
        default: self = .prototype(value)
        }
    }
    
    public var type: (String, Any.Type) {
        switch self {
        case .string: return ("String", String.self)
        case .bytes: return ("String", String.self)
        case .bool: return ("Bool", Bool.self)
        case .double: return ("Double", Double.self)
        case .float: return ("Float", Float.self)
        case .uint32, .fixed32: return ("UInt32", UInt32.self)
        case .uint64, .fixed64: return ("UInt64", UInt64.self)
        case .int32, .sint32, .sfixed32: return ("Int32", Int32.self)
        case .int64, .sint64, .sfixed64: return ("Int64", Int64.self)
        case .prototype(let name): return (name, Any.self)
        }
    }
    
    // FIXME: this is a really really terrible idea...
    // FIXME: sins were committed here
    // FIXME: no seriously dear god this is horrifying
    // FIXME: pls save me, lawd pls
    // TODO: Use a protocol like `AnyInstantiable` and conform types.
    public func _cast(value value2: Any?) -> Any? {
        guard value2 != nil else { return value2 }
        let value = "\(value2!)"
        switch self {
        case .double: return Double(value)!
        case .float: return Float(value)!
        case .uint32, .fixed32: return UInt32(value)!
        case .uint64, .fixed64: return UInt64(value)!
        case .int32, .sint32, .sfixed32: return Int32(value)!
        case .int64, .sint64, .sfixed64: return Int64(value)!
        default: return value2 /* CANNOT CAST */
        }
    }
    
    public func typed(labeled label: ProtoFieldLabel, container: Bool = false) -> String {
        switch label {
        case .optional: return "\(self.type.0)?"
        case .required: return "\(self.type.0)" + (container ? "!" : "")
        case .repeated: return "[\(self.type.0)]" + (container ? " = []" : "")
        }
    }
}

public enum ProtoError: Error {
    case typeMismatchError
    case requiredFieldError
    case fieldNameNotFoundError
    case fieldIdNotFoundError
    case unknownError
}

public struct ProtoEnumDescriptor {
    public let name: String
    public let values: [(Int, String)]
    
    public static func fromString(string: String) throws -> ProtoEnumDescriptor {
        guard var title = string.substring(between: "enum ", and: " {") else {
            throw ProtoError.unknownError
        }
        guard let content = string.substring(between: "{", and: "}") else {
            throw ProtoError.unknownError
        }
        
        let f2 = content.components(separatedBy: ";").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }.filter { !$0.isEmpty } as [String]
        let fields = f2.map {
            let a = $0.components(separatedBy: " ").filter { $0 != "=" }
            return (Int(a[1])!, a[0])
            }.sorted { $0.0 < $1.0 } as [(Int, String)]
        
        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return ProtoEnumDescriptor(name: title, values: fields)
    }
    
    public func toString() -> String {
        var output = "public struct \(self.name): ProtoEnum {\n"
        self.values.forEach { (arg) in
            let (k, v) = arg
            let comps = v.components(separatedBy: "_")
            let name = comps.dropFirst()
                .map { $0.capitalized }
                .reduce(comps.first!.capitalized, +)
                .replacingOccurrences(of: self.name, with: "", options: .caseInsensitive)
            
            output += "\tpublic static let \(name): \(self.name) = \(k)\n"
        }
        output += "\n\tpublic let rawValue: Int\n"
        output += "\tpublic init(_ rawValue: Int) {\n"
        output += "\t\tself.rawValue = rawValue\n\t}\n"
        return output + "}"
    }
}

public struct ProtoMessageDescriptor {
    public let name: String
    public let fields: [ProtoFieldDescriptor]
    
    public static func fromString(string: String) throws -> ProtoMessageDescriptor {
        guard var title = string.substring(between: "message ", and: " {") else {
            throw ProtoError.unknownError
        }
        guard let content = string.substring(between: "{", and: "}") else {
            throw ProtoError.unknownError
        }
        
        let f2 = content.components(separatedBy: ";").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }.filter { !$0.isEmpty } as [String]
        let fields = f2.map {
            let a = $0.components(separatedBy: " ").filter { $0 != "=" }.filter { !$0.isEmpty }
            return ProtoFieldDescriptor(id: Int(a[3])!, name: a[2],
                                        type: ProtoFieldType(stringLiteral: a[1]),
                                        label: ProtoFieldLabel(rawValue: a[0])!)
            } as [ProtoFieldDescriptor]
        
        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return ProtoMessageDescriptor(name: title, fields: fields)
    }
    
    public func toString() -> String {
        var output = ""
        output += "public struct \(self.name): ProtoMessage {\n\n"
        output += "\tpublic enum CodingKeys: Int, CodingKey {\n"
        for field in self.fields {
            output += "\t\tcase \(field.name) = \(field.id)\n"
        }
        output += "\t}\n\n"
        for field in self.fields {
            output += "\tpublic var \(field.name): \(field.type.typed(labeled: field.label, container: true))\n"
        }
        output += "\n\tpublic init() {}\n"
        output += "\n\tpublic var hashValue: Int {\n"
        output += "\t\treturn combine(hashes: ["
        for field in self.fields {
            output += "self.\(field.name).hash(), "
        }
        output += "])\n\t}\n"
        return output + "}"
    }
}

public struct ProtoFileDescriptor {
    public let syntax: String // [proto2, proto3]
    public let package: String
    public let imports: [ProtoImportDescriptor]
    public let enums: [ProtoEnumDescriptor]
    public let messages: [ProtoMessageDescriptor]
    
    public static func fromString(string: String) throws -> ProtoFileDescriptor {
        var string = string
        string.replaceAllOccurrences(matching: COMMENT_REGEX, with: "")
        
        let enums = string
            .findAllOccurrences(matching: ENUM_REGEX, all: true)
            .map { try? ProtoEnumDescriptor.fromString(string: $0) }
            .flatMap { $0 }
        
        let messages = string
            .findAllOccurrences(matching: MESSAGE_REGEX, all: true)
            .map { try? ProtoMessageDescriptor.fromString(string: $0) }
            .flatMap { $0 }
        
        return ProtoFileDescriptor(syntax: "proto2", package: "",
                                   imports: [], enums: enums, messages: messages)
    }
    
    public func toString() -> String {
        var output = ""
        output += self.enums.map { $0.toString() + "\n\n" }.reduce("", +)
        output += self.messages.map { $0.toString() + "\n\n" }.reduce("", +)
        output += "let _protoEnums: [String: _ProtoEnum.Type] = [\n"
        for e in self.enums {
            output += "\t\"\(e.name)\": \(e.name).self,\n"
        }
        output += "]\n\n"
        output += "let _protoMessages: [String: _ProtoMessage.Type] = [\n"
        for e in self.messages {
            output += "\t\"\(e.name)\": \(e.name).self,\n"
        }
        return output + "]"
    }
}

//
//
//

public func translateProtoFile(filename: String) {
    func _convert(_ file: String) -> String {
        let components = file.components(separatedBy: "/")
        let filename = components.last! + ".swift"
        return components.dropLast().joined(separator: "/") + "/" + filename
    }
    
    do {
        let content = try String(contentsOfFile: filename, encoding: .utf8)
        let output = try! ProtoFileDescriptor.fromString(string: content).toString()
        
        do {
            let outputFilename = _convert(filename)
            try output.write(toFile: outputFilename, atomically: true, encoding: .utf8)
            print("\(filename) written successfully.")
            
        } catch {
            print("Could not write output file \(filename).")
        }
    } catch(let error) {
        print("Could not read input file \(filename): \(error)")
    }
}
