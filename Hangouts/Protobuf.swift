import Foundation
import Mocha

/* TODO: Does not support: syntax, imports, packages, services, extensions, options, nested types, oneof, maps. */

// TODO: make natural types conform to this and make a big cache of types...
public protocol ProtoCustomType {}

public struct ProtoDescriptor {
    private init() {}
    
    public enum Import {
        case weak(String)
        case `public`(String)
    }
    
    public enum ValueType {
        case string
        case bytes
        case bool
        case double, float
        case int32, int64
        case uint32, uint64
        case sint32, sint64
        case fixed32, fixed64
        case sfixed32, sfixed64
        case message(String)
        
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
            default: self = .message(value)
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
            case .message(let name): return (name, Any.self)
            }
        }
    }
    
    public struct Enum: LosslessStringConvertible, ProtoCustomType {
        public struct Case: LosslessStringConvertible {
            public let name: String
            public let value: Int
            
            ///
            public init?(_ description: String) {
                let source = description
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: " ")
                    .filter { $0 != "=" && !$0.isEmpty }
                guard source.count > 0, let value = Int(source[1]) else { return nil }
                self.name = source[0]
                self.value = value
            }
            
            ///
            public var description: String {
                return "\(self.name) = \(self.value);"
            }
            
            // TODO: REMOVE // use this sparingly...
            public func adjustedName(_ root: String) -> String {
                let comps = self.name.components(separatedBy: "_")
                return comps.dropFirst()
                    .map { $0.capitalized }
                    .reduce(comps.first!.capitalized, +)
                    .replacingOccurrences(of: root, with: "", options: .caseInsensitive)
            }
        }
        
        public let name: String
        public let cases: [Case]
        
        ///
        public init?(_ description: String) {
            guard let title = description.substring(between: "enum ", and: " {") else { return nil }
            guard let content = description.substring(between: "{", and: "}") else { return nil }
            
            self.cases = content
                .components(separatedBy: ";")
                .flatMap { Case($0) }
                .sorted { $0.value < $1.value }
            self.name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        ///
        public var description: String {
            var output = "public struct \(self.name): ProtoEnum {\n"
            self.cases.forEach { (arg) in
                output += "\tpublic static let \(arg.adjustedName(self.name)): \(self.name) = \(arg.value)\n"
            }
            output += "\n\tpublic let rawValue: Int\n"
            output += "\tpublic init(_ rawValue: Int) {\n"
            output += "\t\tself.rawValue = rawValue\n\t}\n"
            return output + "}"
        }
    }
    
    public struct Message: LosslessStringConvertible, ProtoCustomType {
        public struct Field: LosslessStringConvertible {
            public enum Label: String {
                case required, repeated, optional
            }
            
            public let id: Int
            public let name: String
            public let type: ValueType
            public let label: Label
            
            ///
            public init?(_ description: String) {
                let source = description
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: " ")
                    .filter { $0 != "=" && !$0.isEmpty }
                
                guard source.count > 0,
                    let id = Int(source[3]),
                    let label = Label(rawValue: source[0])
                    else { return nil }
                let name = source[2], type = ValueType(stringLiteral: source[1])
                
                self.id = id
                self.name = name
                self.type = type
                self.label = label
            }
            
            ///
            public var description: String {
                return "\(self.label) \(self.type) \(self.name) = \(self.id);"
            }
            
            // TODO: REMOVE // use this sparingly...
            public var camelName: String {
                let comps = self.name.components(separatedBy: "_")
                return comps.dropFirst()
                    .map { $0.capitalized }
                    .reduce(comps.first!, +)
            }
            
            public func typed(_ container: Bool = false) -> String {
                switch self.label {
                case .optional: return "\(self.type.type.0)?" + (container ? " = nil" : "")
                case .required: return "\(self.type.type.0)"
                case .repeated: return "[\(self.type.type.0)]" + (container ? " = []" : "")
                }
            }
        }
        
        public let name: String
        public let fields: [Field]
        
        ///
        public init?(_ description: String) {
            guard let title = description.substring(between: "message ", and: " {") else { return nil }
            guard let content = description.substring(between: "{", and: "}") else { return nil }
            self.fields = content.components(separatedBy: ";").flatMap { Field($0) }
            self.name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        ///
        public var description: String {
            var output = ""
            output += "public struct \(self.name): ProtoMessage {\n"
            output += "\tpublic enum CodingKeys: Int, CodingKey {\n"
            for field in self.fields {
                output += "\t\tcase \(field.name) = \(field.id)\n"
            }
            output += "\t}\n\n"
            for field in self.fields {
                output += "\tpublic var \(field.name): \(field.typed(true))\n"
            }
            output += "\n\tpublic init("
            output += self.fields.map { field in "\(field.name): \(field.typed(true))" }.joined(separator: ", ")
            output += ") {\n"
            for field in self.fields {
                output += "\t\tself.\(field.name) = \(field.name)\n"
            }
            output += "\t}\n"
            return output + "}"
        }
    }
    
    public struct File: LosslessStringConvertible {
        private static let COMMENT_REGEX = "((?:\\/\\*)(?:[\\s\\S]*)(?:\\*\\/))|((?:\\/\\/)(?:.*))"
        private static let MESSAGE_REGEX = "(?:message)(?:[\\s\\S]*?)(?:\\{)(?:[\\s\\S]*?)(?:\\})"
        private static let ENUM_REGEX = "(?:enum)(?:[\\s\\S]*?)(?:\\{)(?:[\\s\\S]*?)(?:\\})"
        
        public let syntax: String // [proto2, proto3]
        public let package: String
        public let imports: [Import]
        public let enums: [Enum]
        public let messages: [Message]
        
        ///
        public init?(_ description: String) {
            var description = description
            description.replaceAllOccurrences(matching: File.COMMENT_REGEX, with: "")
            
            self.syntax = "proto2"
            self.package = ""
            self.imports = []
            
            self.enums = description
                .findAllOccurrences(matching: File.ENUM_REGEX, all: true)
                .flatMap { Enum($0) }
            
            self.messages = description
                .findAllOccurrences(matching: File.MESSAGE_REGEX, all: true)
                .flatMap { Message($0) }
        }
        
        ///
        public var description: String {
            var output = ""
            output += self.enums.map { $0.description + "\n\n" }.reduce("", +)
            output += self.messages.map { $0.description + "\n\n" }.reduce("", +)
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
        
        ///
        public static func translate(file inputURL: URL) throws {
            let component = inputURL.lastPathComponent + ".swift"
            let outputURL = inputURL.deletingLastPathComponent().appendingPathComponent(component)
            
            let content = try String(contentsOf: inputURL, encoding: .utf8)
            let output = ProtoDescriptor.File(content)?.description ?? ""
            try output.write(to: outputURL, atomically: true, encoding: .utf8)
        }
    }
}
