import Foundation

// FIXME: syntax, imports, packages, map field types
// TODO: Does not support: services, extensions, options, inner class, oneof

private let COMMENT_REGEX = "((?:\\/\\*)(?:[\\s\\S]*)(?:\\*\\/))|((?:\\/\\/)(?:.*))"
private let MESSAGE_REGEX = "(?:message)(?:[\\s\\S]*?)(?:\\{)(?:[\\s\\S]*?)(?:\\})"
private let ENUM_REGEX = "(?:enum)(?:[\\s\\S]*?)(?:\\{)(?:[\\s\\S]*?)(?:\\})"
private let FIELD_REGEX = "(?:(required|optional|repeated))(?:.*)(?:\\;)"

public protocol ProtoEnum {
	var rawValue: Int { get }
	init(_ rawValue: Int)
}

public protocol ProtoEnumExtensor: ProtoEnum, IntegerLiteralConvertible, RawRepresentable, Hashable, Equatable {}
public extension ProtoEnumExtensor {
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

public protocol ProtoMessage {
	static var __declaredFields: [Int: ProtoFieldDescriptor] { get }
	var _declaredFields: [Int: ProtoFieldDescriptor] { get }
	var _unknownFields: [Int: Any] { get set }
	
	mutating func set(id: Int, value: Any?) throws
	func get(id: Int) throws -> Any?
	
	mutating func set(id: Int, value: Any?, at index: Int) throws
	func get(id: Int, at index: Int) throws -> Any?
	
	init()
}

// Message: Builder Support
public extension ProtoMessage {
	public init(fields: [Int: Any?]) throws {
		self.init()
		for (id, value) in fields {
			try self.set(id: id, value: value)
		}
	}
}

// Message: String Conversion Support
/*public extension ProtoMessage {
	public func _toProto(_ indent: String = "", _ value: Bool = false) -> String {
		var output = ""
		for (_, field) in Self._protoFields {
			output += "\(indent)\(field.label) \(field.type) \(field.name) = \(field.id);\n"
		}
		return output
	}
}*/

// Message: Hashable & Equatable Support
public protocol ProtoMessageExtensor: ProtoMessage, Hashable, Equatable {}
public extension ProtoMessageExtensor {
	public mutating func with(closure: ((inout Self) -> Void)) {
		closure(&self)
	}
}
public func ==<T: ProtoMessageExtensor>(lhs: T, rhs: T) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

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
	
	public var camelName: String {
		let comps = self.name.components(separatedBy: "_")
		return comps.dropFirst()
			.map { $0.capitalized }
			.reduce(comps.first!, combine: +)
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
		case string: return ("String", String.self)
		case bytes: return ("String", String.self)
		case bool: return ("Bool", Bool.self)
		case double: return ("Double", Double.self)
		case float: return ("Float", Float.self)
		case uint32, fixed32: return ("UInt32", UInt32.self)
		case uint64, fixed64: return ("UInt64", UInt64.self)
		case int32, sint32, sfixed32: return ("Int32", Int32.self)
		case int64, sint64, sfixed64: return ("Int64", Int64.self)
		case prototype(let name): return (name, Any.self)
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
		case double: return Double(value)!
		case float: return Float(value)!
		case uint32, fixed32: return UInt32(value)!
		case uint64, fixed64: return UInt64(value)!
		case int32, sint32, sfixed32: return Int32(value)!
		case int64, sint64, sfixed64: return Int64(value)!
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

public enum ProtoError: ErrorProtocol {
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
		var output = "public struct \(self.name): ProtoEnumExtensor {\n"
		self.values.forEach { k, v in
			let comps = v.components(separatedBy: "_")
			let name = comps.dropFirst()
				.map { $0.capitalized }
				.reduce(comps.first!.capitalized, combine: +)
				.replacingOccurrences(of: self.name, with: "", options: .caseInsensitiveSearch)
			
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
		output += "public struct \(self.name): ProtoMessageExtensor {\n\n"
		output += "\tpublic init() {}\n"
		output += "\tpublic var _unknownFields = [Int: Any]()\n\n"
		output += "\tpublic static let __declaredFields: [Int: ProtoFieldDescriptor] = [\n"
		for field in self.fields {
			output += "\t\t\(field.id): ProtoFieldDescriptor(id: \(field.id), name: \"\(field.name)\","
			output += " type: .\(field.type), label: .\(field.label)),\n"
		}
		output += "\t]\n"
		output += "\tpublic var _declaredFields: [Int: ProtoFieldDescriptor] {\n"
		output += "\t\treturn \(self.name).__declaredFields\n"
		output += "\t}\n\n"
		output += "\tpublic mutating func set(id: Int, value: Any?) throws {\n"
		output += "\t\tswitch id {\n"
		for field in self.fields {
			output += "\t\tcase \(field.id):\n"
			let mod = (field.label == .repeated ? "" : "value == nil || ")
			output += "\t\t\tguard " + mod + "value is \(field.type.typed(labeled: field.label))"
			output += " else { throw ProtoError.typeMismatchError }\n"
			output += "\t\t\tself.\(field.camelName) = value as! \(field.type.typed(labeled: field.label))\n"
		}
		output += "\t\tdefault: throw ProtoError.fieldNameNotFoundError\n"
		output += "\t\t}\n\t}\n\n"
		output += "\tpublic mutating func set(id: Int, value: Any?, at index: Int) throws {\n"
		output += "\t\tswitch id {\n"
		for field in self.fields {
			guard field.label == .repeated else { continue }
			output += "\t\tcase \(field.id):\n"
			output += "\t\t\tif value is \(field.type.typed(labeled: field.label)) {\n"
			output += "\t\t\t\tself.\(field.camelName).insert(contentsOf: value as! \(field.type.typed(labeled: field.label))"
			output += ", at: index > 0 ? index : self.\(field.camelName).endIndex)\n"
			output += "\t\t\t} else if value is \(field.type.type.0) {\n"
			output += "\t\t\t\tself.\(field.camelName).insert(value as! \(field.type.type.0)"
			output += ", at: index > 0 ? index : self.\(field.camelName).endIndex)\n"
			output += "\t\t\t} else {\n\t\t\t\tthrow ProtoError.typeMismatchError\n\t\t\t}\n"
		}
		output += "\t\tdefault: throw ProtoError.fieldNameNotFoundError\n"
		output += "\t\t}\n\t}\n\n"
		output += "\tpublic func get(id: Int) throws -> Any? {\n"
		output += "\t\tswitch id {\n"
		for field in self.fields {
			output += "\t\tcase \(field.id): return self.\(field.camelName)\n"
		}
		output += "\t\tdefault: throw ProtoError.fieldNameNotFoundError\n"
		output += "\t\t}\n\t}\n\n"
		output += "\tpublic func get(id: Int, at index: Int) throws -> Any? {\n"
		output += "\t\tswitch id {\n"
		for field in self.fields {
			guard field.label == .repeated else { continue }
			output += "\t\tcase \(field.id):\n"
			output += "\t\t\tguard index > 0 && index < self.\(field.camelName).endIndex else { throw ProtoError.unknownError }\n"
			output += "\t\t\treturn self.\(field.camelName)[index]\n"
		}
		output += "\t\tdefault: throw ProtoError.fieldNameNotFoundError\n"
		output += "\t\t}\n\t}\n\n"
		output += "\tpublic var hashValue: Int {\n"
		output += "\t\tvar hash = 7\n"
		for field in self.fields {
			switch field.label {
			case .required:
				output += "\t\thash = (hash &* 31) &+ self.\(field.camelName).hashValue\n"
			case .optional:
				output += "\t\t_= self.\(field.camelName).flatMap { hash = (hash &* 31) &+ $0.hashValue }\n"
			case .repeated:
				output += "\t\tself.\(field.camelName).forEach { hash = (hash &* 31) &+ $0.hashValue }\n"
			}
		}
		output += "\t\treturn hash\n"
		output += "\t}\n\n"
		for field in self.fields {
			output += "\tpublic var \(field.camelName): \(field.type.typed(labeled: field.label, container: true))\n"
		}
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
		output += self.enums.map { $0.toString() + "\n\n" }.reduce("", combine: +)
		output += self.messages.map { $0.toString() + "\n\n" }.reduce("", combine: +)
		output += "let _protoEnums: [String: ProtoEnum.Type] = [\n"
		for e in self.enums {
			output += "\t\"\(e.name)\": \(e.name).self,\n"
		}
		output += "]\n\n"
		output += "let _protoMessages: [String: ProtoMessage.Type] = [\n"
		for e in self.messages {
			output += "\t\"\(e.name)\": \(e.name).self,\n"
		}
		return output + "]"
	}
}

public func translateProtoFile(filename: String) {
	func _convert(_ file: String) -> String {
		let components = file.components(separatedBy: "/")
		let filename = components.last! + ".swift"
		return components.dropLast().joined(separator: "/") + "/" + filename
	}
	
	do {
		let content = try String(contentsOfFile: Process.arguments[1], encoding: String.Encoding.utf8)
		let output = try! ProtoFileDescriptor.fromString(string: content).toString()
		
		do {
			let outputFilename = _convert(filename)
			try output.write(toFile: outputFilename, atomically: true, encoding: String.Encoding.utf8)
			log.info("\(filename) written successfully.")
			
		} catch {
			log.error("Could not write output file \(filename).")
		}
	} catch {
		log.error("Could not read input file \(filename).")
	}
}
