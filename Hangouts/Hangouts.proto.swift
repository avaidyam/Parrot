public struct DoNotDisturbSetting: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "doNotDisturb", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "expirationTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "version", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "doNotDisturb":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.doNotDisturb = value as! Bool?
		case "expirationTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.expirationTimestamp = value as! UInt64?
		case "version":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.version = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "doNotDisturb": return self.doNotDisturb
		case "expirationTimestamp": return self.expirationTimestamp
		case "version": return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var doNotDisturb: Bool?
	public var expirationTimestamp: UInt64?
	public var version: UInt64?
}

public struct NotificationSettings: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "dndSettings", type: .prototype("DoNotDisturbSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "dndSettings":
			guard value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.dndSettings = value as! DoNotDisturbSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "dndSettings": return self.dndSettings
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var dndSettings: DoNotDisturbSetting?
}

public struct ConversationId: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "id", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.id = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "id": return self.id
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var id: String?
}

public struct ParticipantId: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "gaiaId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "chatId", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "gaiaId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case "chatId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.chatId = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "gaiaId": return self.gaiaId
		case "chatId": return self.chatId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var gaiaId: String?
	public var chatId: String?
}

public struct DeviceStatus: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "mobile", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "desktop", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "tablet", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "mobile":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.mobile = value as! Bool?
		case "desktop":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.desktop = value as! Bool?
		case "tablet":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.tablet = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "mobile": return self.mobile
		case "desktop": return self.desktop
		case "tablet": return self.tablet
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var mobile: Bool?
	public var desktop: Bool?
	public var tablet: Bool?
}

public struct LastSeen: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "lastSeenTimestampUsec", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "lastSeenTimestampUsec":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastSeenTimestampUsec = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "lastSeenTimestampUsec": return self.lastSeenTimestampUsec
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var lastSeenTimestampUsec: UInt64?
}

public struct Presence: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "reachable", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "available", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 6, name: "deviceStatus", type: .prototype("DeviceStatus"), label: .optional),
		ProtoFieldDescriptor(id: 9, name: "moodMessage", type: .prototype("MoodMessage"), label: .optional),
		ProtoFieldDescriptor(id: 10, name: "lastSeen", type: .prototype("LastSeen"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "reachable":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.reachable = value as! Bool?
		case "available":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.available = value as! Bool?
		case "deviceStatus":
			guard value is DeviceStatus? else { throw ProtoError.typeMismatchError }
			self.deviceStatus = value as! DeviceStatus?
		case "moodMessage":
			guard value is MoodMessage? else { throw ProtoError.typeMismatchError }
			self.moodMessage = value as! MoodMessage?
		case "lastSeen":
			guard value is LastSeen? else { throw ProtoError.typeMismatchError }
			self.lastSeen = value as! LastSeen?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "reachable": return self.reachable
		case "available": return self.available
		case "deviceStatus": return self.deviceStatus
		case "moodMessage": return self.moodMessage
		case "lastSeen": return self.lastSeen
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var reachable: Bool?
	public var available: Bool?
	public var deviceStatus: DeviceStatus?
	public var moodMessage: MoodMessage?
	public var lastSeen: LastSeen?
}

public struct PresenceResult: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "userId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "presence", type: .prototype("Presence"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "userId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.userId = value as! ParticipantId?
		case "presence":
			guard value is Presence? else { throw ProtoError.typeMismatchError }
			self.presence = value as! Presence?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "userId": return self.userId
		case "presence": return self.presence
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var userId: ParticipantId?
	public var presence: Presence?
}

public struct ClientIdentifier: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "resource", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "headerId", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "resource":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.resource = value as! String?
		case "headerId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.headerId = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "resource": return self.resource
		case "headerId": return self.headerId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var resource: String?
	public var headerId: String?
}

public struct ClientPresenceState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "identifier", type: .prototype("ClientIdentifier"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "state", type: .prototype("ClientPresenceStateType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "identifier":
			guard value is ClientIdentifier? else { throw ProtoError.typeMismatchError }
			self.identifier = value as! ClientIdentifier?
		case "state":
			guard value is ClientPresenceStateType? else { throw ProtoError.typeMismatchError }
			self.state = value as! ClientPresenceStateType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "identifier": return self.identifier
		case "state": return self.state
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var identifier: ClientIdentifier?
	public var state: ClientPresenceStateType?
}

public struct UserEventState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "userId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "clientGeneratedId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "notificationLevel", type: .prototype("NotificationLevel"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "userId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.userId = value as! ParticipantId?
		case "clientGeneratedId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! String?
		case "notificationLevel":
			guard value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.notificationLevel = value as! NotificationLevel?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "userId": return self.userId
		case "clientGeneratedId": return self.clientGeneratedId
		case "notificationLevel": return self.notificationLevel
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var userId: ParticipantId?
	public var clientGeneratedId: String?
	public var notificationLevel: NotificationLevel?
}

public struct Formatting: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "bold", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "italic", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "strikethrough", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "underline", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "bold":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.bold = value as! Bool?
		case "italic":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.italic = value as! Bool?
		case "strikethrough":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.strikethrough = value as! Bool?
		case "underline":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.underline = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "bold": return self.bold
		case "italic": return self.italic
		case "strikethrough": return self.strikethrough
		case "underline": return self.underline
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var bold: Bool?
	public var italic: Bool?
	public var strikethrough: Bool?
	public var underline: Bool?
}

public struct LinkData: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "linkTarget", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "linkTarget":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.linkTarget = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "linkTarget": return self.linkTarget
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var linkTarget: String?
}

public struct Segment: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("SegmentType"), label: .required),
		ProtoFieldDescriptor(id: 2, name: "text", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "formatting", type: .prototype("Formatting"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "linkData", type: .prototype("LinkData"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is SegmentType else { throw ProtoError.typeMismatchError }
			self.type = value as! SegmentType
		case "text":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.text = value as! String?
		case "formatting":
			guard value is Formatting? else { throw ProtoError.typeMismatchError }
			self.formatting = value as! Formatting?
		case "linkData":
			guard value is LinkData? else { throw ProtoError.typeMismatchError }
			self.linkData = value as! LinkData?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "text": return self.text
		case "formatting": return self.formatting
		case "linkData": return self.linkData
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: SegmentType
	public var text: String?
	public var formatting: Formatting?
	public var linkData: LinkData?
}

public struct Thumbnail: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "url", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "imageUrl", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 10, name: "widthPx", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 11, name: "heightPx", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case "imageUrl":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.imageUrl = value as! String?
		case "widthPx":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.widthPx = value as! UInt64?
		case "heightPx":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.heightPx = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "url": return self.url
		case "imageUrl": return self.imageUrl
		case "widthPx": return self.widthPx
		case "heightPx": return self.heightPx
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var url: String?
	public var imageUrl: String?
	public var widthPx: UInt64?
	public var heightPx: UInt64?
}

public struct PlusPhoto: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "thumbnail", type: .prototype("Thumbnail"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "ownerObfuscatedId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "albumId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "photoId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 6, name: "url", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 10, name: "originalContentUrl", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 13, name: "mediaType", type: .prototype("MediaType"), label: .optional),
		ProtoFieldDescriptor(id: 14, name: "streamId", type: .string, label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "thumbnail":
			guard value is Thumbnail? else { throw ProtoError.typeMismatchError }
			self.thumbnail = value as! Thumbnail?
		case "ownerObfuscatedId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.ownerObfuscatedId = value as! String?
		case "albumId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.albumId = value as! String?
		case "photoId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.photoId = value as! String?
		case "url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case "originalContentUrl":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.originalContentUrl = value as! String?
		case "mediaType":
			guard value is MediaType? else { throw ProtoError.typeMismatchError }
			self.mediaType = value as! MediaType?
		case "streamId":
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.streamId = value as! [String]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "thumbnail": return self.thumbnail
		case "ownerObfuscatedId": return self.ownerObfuscatedId
		case "albumId": return self.albumId
		case "photoId": return self.photoId
		case "url": return self.url
		case "originalContentUrl": return self.originalContentUrl
		case "mediaType": return self.mediaType
		case "streamId": return self.streamId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var thumbnail: Thumbnail?
	public var ownerObfuscatedId: String?
	public var albumId: String?
	public var photoId: String?
	public var url: String?
	public var originalContentUrl: String?
	public var mediaType: MediaType?
	public var streamId: [String]
}

public struct RepresentativeImage: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 2, name: "url", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "url": return self.url
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var url: String?
}

public struct Place: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "url", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "name", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 185, name: "representativeImage", type: .prototype("RepresentativeImage"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case "name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case "representativeImage":
			guard value is RepresentativeImage? else { throw ProtoError.typeMismatchError }
			self.representativeImage = value as! RepresentativeImage?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "url": return self.url
		case "name": return self.name
		case "representativeImage": return self.representativeImage
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var url: String?
	public var name: String?
	public var representativeImage: RepresentativeImage?
}

public struct EmbedItem: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("ItemType"), label: .repeated),
		ProtoFieldDescriptor(id: 2, name: "id", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 27639957, name: "plusPhoto", type: .prototype("PlusPhoto"), label: .optional),
		ProtoFieldDescriptor(id: 35825640, name: "place", type: .prototype("Place"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is [ItemType] else { throw ProtoError.typeMismatchError }
			self.type = value as! [ItemType]
		case "id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.id = value as! String?
		case "plusPhoto":
			guard value is PlusPhoto? else { throw ProtoError.typeMismatchError }
			self.plusPhoto = value as! PlusPhoto?
		case "place":
			guard value is Place? else { throw ProtoError.typeMismatchError }
			self.place = value as! Place?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "id": return self.id
		case "plusPhoto": return self.plusPhoto
		case "place": return self.place
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: [ItemType]
	public var id: String?
	public var plusPhoto: PlusPhoto?
	public var place: Place?
}

public struct Attachment: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "embedItem", type: .prototype("EmbedItem"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "embedItem":
			guard value is EmbedItem? else { throw ProtoError.typeMismatchError }
			self.embedItem = value as! EmbedItem?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "embedItem": return self.embedItem
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var embedItem: EmbedItem?
}

public struct MessageContent: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "segment", type: .prototype("Segment"), label: .repeated),
		ProtoFieldDescriptor(id: 2, name: "attachment", type: .prototype("Attachment"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "segment":
			guard value is [Segment] else { throw ProtoError.typeMismatchError }
			self.segment = value as! [Segment]
		case "attachment":
			guard value is [Attachment] else { throw ProtoError.typeMismatchError }
			self.attachment = value as! [Attachment]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "segment": return self.segment
		case "attachment": return self.attachment
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var segment: [Segment]
	public var attachment: [Attachment]
}

public struct EventAnnotation: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "type", type: .int32, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "value", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is Int32? else { throw ProtoError.typeMismatchError }
			self.type = value as! Int32?
		case "value":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.value = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "value": return self.value
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: Int32?
	public var value: String?
}

public struct ChatMessage: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 2, name: "annotation", type: .prototype("EventAnnotation"), label: .repeated),
		ProtoFieldDescriptor(id: 3, name: "messageContent", type: .prototype("MessageContent"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "annotation":
			guard value is [EventAnnotation] else { throw ProtoError.typeMismatchError }
			self.annotation = value as! [EventAnnotation]
		case "messageContent":
			guard value is MessageContent? else { throw ProtoError.typeMismatchError }
			self.messageContent = value as! MessageContent?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "annotation": return self.annotation
		case "messageContent": return self.messageContent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var annotation: [EventAnnotation]
	public var messageContent: MessageContent?
}

public struct MembershipChange: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("MembershipChangeType"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "participantIds", type: .prototype("ParticipantId"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is MembershipChangeType? else { throw ProtoError.typeMismatchError }
			self.type = value as! MembershipChangeType?
		case "participantIds":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantIds = value as! [ParticipantId]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "participantIds": return self.participantIds
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: MembershipChangeType?
	public var participantIds: [ParticipantId]
}

public struct ConversationRename: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "newName", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "oldName", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "newName":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.newName = value as! String?
		case "oldName":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.oldName = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "newName": return self.newName
		case "oldName": return self.oldName
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var newName: String?
	public var oldName: String?
}

public struct HangoutEvent: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "eventType", type: .prototype("HangoutEventType"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "participantId", type: .prototype("ParticipantId"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "eventType":
			guard value is HangoutEventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! HangoutEventType?
		case "participantId":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantId = value as! [ParticipantId]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "eventType": return self.eventType
		case "participantId": return self.participantId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var eventType: HangoutEventType?
	public var participantId: [ParticipantId]
}

public struct OTRModification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "oldOtrStatus", type: .prototype("OffTheRecordStatus"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "newOtrStatus", type: .prototype("OffTheRecordStatus"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "oldOtrToggle", type: .prototype("OffTheRecordToggle"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "newOtrToggle", type: .prototype("OffTheRecordToggle"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "oldOtrStatus":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.oldOtrStatus = value as! OffTheRecordStatus?
		case "newOtrStatus":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.newOtrStatus = value as! OffTheRecordStatus?
		case "oldOtrToggle":
			guard value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.oldOtrToggle = value as! OffTheRecordToggle?
		case "newOtrToggle":
			guard value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.newOtrToggle = value as! OffTheRecordToggle?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "oldOtrStatus": return self.oldOtrStatus
		case "newOtrStatus": return self.newOtrStatus
		case "oldOtrToggle": return self.oldOtrToggle
		case "newOtrToggle": return self.newOtrToggle
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var oldOtrStatus: OffTheRecordStatus?
	public var newOtrStatus: OffTheRecordStatus?
	public var oldOtrToggle: OffTheRecordToggle?
	public var newOtrToggle: OffTheRecordToggle?
}

public struct HashModifier: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "updateId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "hashDiff", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "version", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "updateId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.updateId = value as! String?
		case "hashDiff":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.hashDiff = value as! UInt64?
		case "version":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.version = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "updateId": return self.updateId
		case "hashDiff": return self.hashDiff
		case "version": return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var updateId: String?
	public var hashDiff: UInt64?
	public var version: UInt64?
}

public struct Event: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "senderId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "selfEventState", type: .prototype("UserEventState"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "sourceType", type: .prototype("SourceType"), label: .optional),
		ProtoFieldDescriptor(id: 7, name: "chatMessage", type: .prototype("ChatMessage"), label: .optional),
		ProtoFieldDescriptor(id: 9, name: "membershipChange", type: .prototype("MembershipChange"), label: .optional),
		ProtoFieldDescriptor(id: 10, name: "conversationRename", type: .prototype("ConversationRename"), label: .optional),
		ProtoFieldDescriptor(id: 11, name: "hangoutEvent", type: .prototype("HangoutEvent"), label: .optional),
		ProtoFieldDescriptor(id: 12, name: "eventId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 13, name: "expirationTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 14, name: "otrModification", type: .prototype("OTRModification"), label: .optional),
		ProtoFieldDescriptor(id: 15, name: "advancesSortTimestamp", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 16, name: "otrStatus", type: .prototype("OffTheRecordStatus"), label: .optional),
		ProtoFieldDescriptor(id: 17, name: "persisted", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 20, name: "mediumType", type: .prototype("DeliveryMedium"), label: .optional),
		ProtoFieldDescriptor(id: 23, name: "eventType", type: .prototype("EventType"), label: .optional),
		ProtoFieldDescriptor(id: 24, name: "eventVersion", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 26, name: "hashModifier", type: .prototype("HashModifier"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "senderId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		case "selfEventState":
			guard value is UserEventState? else { throw ProtoError.typeMismatchError }
			self.selfEventState = value as! UserEventState?
		case "sourceType":
			guard value is SourceType? else { throw ProtoError.typeMismatchError }
			self.sourceType = value as! SourceType?
		case "chatMessage":
			guard value is ChatMessage? else { throw ProtoError.typeMismatchError }
			self.chatMessage = value as! ChatMessage?
		case "membershipChange":
			guard value is MembershipChange? else { throw ProtoError.typeMismatchError }
			self.membershipChange = value as! MembershipChange?
		case "conversationRename":
			guard value is ConversationRename? else { throw ProtoError.typeMismatchError }
			self.conversationRename = value as! ConversationRename?
		case "hangoutEvent":
			guard value is HangoutEvent? else { throw ProtoError.typeMismatchError }
			self.hangoutEvent = value as! HangoutEvent?
		case "eventId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.eventId = value as! String?
		case "expirationTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.expirationTimestamp = value as! UInt64?
		case "otrModification":
			guard value is OTRModification? else { throw ProtoError.typeMismatchError }
			self.otrModification = value as! OTRModification?
		case "advancesSortTimestamp":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.advancesSortTimestamp = value as! Bool?
		case "otrStatus":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.otrStatus = value as! OffTheRecordStatus?
		case "persisted":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.persisted = value as! Bool?
		case "mediumType":
			guard value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.mediumType = value as! DeliveryMedium?
		case "eventType":
			guard value is EventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! EventType?
		case "eventVersion":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.eventVersion = value as! UInt64?
		case "hashModifier":
			guard value is HashModifier? else { throw ProtoError.typeMismatchError }
			self.hashModifier = value as! HashModifier?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "senderId": return self.senderId
		case "timestamp": return self.timestamp
		case "selfEventState": return self.selfEventState
		case "sourceType": return self.sourceType
		case "chatMessage": return self.chatMessage
		case "membershipChange": return self.membershipChange
		case "conversationRename": return self.conversationRename
		case "hangoutEvent": return self.hangoutEvent
		case "eventId": return self.eventId
		case "expirationTimestamp": return self.expirationTimestamp
		case "otrModification": return self.otrModification
		case "advancesSortTimestamp": return self.advancesSortTimestamp
		case "otrStatus": return self.otrStatus
		case "persisted": return self.persisted
		case "mediumType": return self.mediumType
		case "eventType": return self.eventType
		case "eventVersion": return self.eventVersion
		case "hashModifier": return self.hashModifier
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var senderId: ParticipantId?
	public var timestamp: UInt64?
	public var selfEventState: UserEventState?
	public var sourceType: SourceType?
	public var chatMessage: ChatMessage?
	public var membershipChange: MembershipChange?
	public var conversationRename: ConversationRename?
	public var hangoutEvent: HangoutEvent?
	public var eventId: String?
	public var expirationTimestamp: UInt64?
	public var otrModification: OTRModification?
	public var advancesSortTimestamp: Bool?
	public var otrStatus: OffTheRecordStatus?
	public var persisted: Bool?
	public var mediumType: DeliveryMedium?
	public var eventType: EventType?
	public var eventVersion: UInt64?
	public var hashModifier: HashModifier?
}

public struct UserReadState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "participantId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "latestReadTimestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "participantId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.participantId = value as! ParticipantId?
		case "latestReadTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.latestReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "participantId": return self.participantId
		case "latestReadTimestamp": return self.latestReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var participantId: ParticipantId?
	public var latestReadTimestamp: UInt64?
}

public struct DeliveryMedium: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "mediumType", type: .prototype("DeliveryMediumType"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "phoneNumber", type: .prototype("PhoneNumber"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "mediumType":
			guard value is DeliveryMediumType? else { throw ProtoError.typeMismatchError }
			self.mediumType = value as! DeliveryMediumType?
		case "phoneNumber":
			guard value is PhoneNumber? else { throw ProtoError.typeMismatchError }
			self.phoneNumber = value as! PhoneNumber?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "mediumType": return self.mediumType
		case "phoneNumber": return self.phoneNumber
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var mediumType: DeliveryMediumType?
	public var phoneNumber: PhoneNumber?
}

public struct DeliveryMediumOption: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "deliveryMedium", type: .prototype("DeliveryMedium"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "currentDefault", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "deliveryMedium":
			guard value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.deliveryMedium = value as! DeliveryMedium?
		case "currentDefault":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.currentDefault = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "deliveryMedium": return self.deliveryMedium
		case "currentDefault": return self.currentDefault
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var deliveryMedium: DeliveryMedium?
	public var currentDefault: Bool?
}

public struct UserConversationState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 2, name: "clientGeneratedId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 7, name: "selfReadState", type: .prototype("UserReadState"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "status", type: .prototype("ConversationStatus"), label: .optional),
		ProtoFieldDescriptor(id: 9, name: "notificationLevel", type: .prototype("NotificationLevel"), label: .optional),
		ProtoFieldDescriptor(id: 10, name: "view", type: .prototype("ConversationView"), label: .repeated),
		ProtoFieldDescriptor(id: 11, name: "inviterId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 12, name: "inviteTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 13, name: "sortTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 14, name: "activeTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 15, name: "inviteAffinity", type: .prototype("InvitationAffinity"), label: .optional),
		ProtoFieldDescriptor(id: 17, name: "deliveryMediumOption", type: .prototype("DeliveryMediumOption"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "clientGeneratedId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! String?
		case "selfReadState":
			guard value is UserReadState? else { throw ProtoError.typeMismatchError }
			self.selfReadState = value as! UserReadState?
		case "status":
			guard value is ConversationStatus? else { throw ProtoError.typeMismatchError }
			self.status = value as! ConversationStatus?
		case "notificationLevel":
			guard value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.notificationLevel = value as! NotificationLevel?
		case "view":
			guard value is [ConversationView] else { throw ProtoError.typeMismatchError }
			self.view = value as! [ConversationView]
		case "inviterId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.inviterId = value as! ParticipantId?
		case "inviteTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.inviteTimestamp = value as! UInt64?
		case "sortTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.sortTimestamp = value as! UInt64?
		case "activeTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.activeTimestamp = value as! UInt64?
		case "inviteAffinity":
			guard value is InvitationAffinity? else { throw ProtoError.typeMismatchError }
			self.inviteAffinity = value as! InvitationAffinity?
		case "deliveryMediumOption":
			guard value is [DeliveryMediumOption] else { throw ProtoError.typeMismatchError }
			self.deliveryMediumOption = value as! [DeliveryMediumOption]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "clientGeneratedId": return self.clientGeneratedId
		case "selfReadState": return self.selfReadState
		case "status": return self.status
		case "notificationLevel": return self.notificationLevel
		case "view": return self.view
		case "inviterId": return self.inviterId
		case "inviteTimestamp": return self.inviteTimestamp
		case "sortTimestamp": return self.sortTimestamp
		case "activeTimestamp": return self.activeTimestamp
		case "inviteAffinity": return self.inviteAffinity
		case "deliveryMediumOption": return self.deliveryMediumOption
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var clientGeneratedId: String?
	public var selfReadState: UserReadState?
	public var status: ConversationStatus?
	public var notificationLevel: NotificationLevel?
	public var view: [ConversationView]
	public var inviterId: ParticipantId?
	public var inviteTimestamp: UInt64?
	public var sortTimestamp: UInt64?
	public var activeTimestamp: UInt64?
	public var inviteAffinity: InvitationAffinity?
	public var deliveryMediumOption: [DeliveryMediumOption]
}

public struct ConversationParticipantData: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "id", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "fallbackName", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "invitationStatus", type: .prototype("InvitationStatus"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "participantType", type: .prototype("ParticipantType"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "newInvitationStatus", type: .prototype("InvitationStatus"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.id = value as! ParticipantId?
		case "fallbackName":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.fallbackName = value as! String?
		case "invitationStatus":
			guard value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.invitationStatus = value as! InvitationStatus?
		case "participantType":
			guard value is ParticipantType? else { throw ProtoError.typeMismatchError }
			self.participantType = value as! ParticipantType?
		case "newInvitationStatus":
			guard value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.newInvitationStatus = value as! InvitationStatus?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "id": return self.id
		case "fallbackName": return self.fallbackName
		case "invitationStatus": return self.invitationStatus
		case "participantType": return self.participantType
		case "newInvitationStatus": return self.newInvitationStatus
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var id: ParticipantId?
	public var fallbackName: String?
	public var invitationStatus: InvitationStatus?
	public var participantType: ParticipantType?
	public var newInvitationStatus: InvitationStatus?
}

public struct Conversation: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ConversationType"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "name", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "selfConversationState", type: .prototype("UserConversationState"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "readState", type: .prototype("UserReadState"), label: .repeated),
		ProtoFieldDescriptor(id: 9, name: "hasActiveHangout", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 10, name: "otrStatus", type: .prototype("OffTheRecordStatus"), label: .optional),
		ProtoFieldDescriptor(id: 11, name: "otrToggle", type: .prototype("OffTheRecordToggle"), label: .optional),
		ProtoFieldDescriptor(id: 12, name: "conversationHistorySupported", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 13, name: "currentParticipant", type: .prototype("ParticipantId"), label: .repeated),
		ProtoFieldDescriptor(id: 14, name: "participantData", type: .prototype("ConversationParticipantData"), label: .repeated),
		ProtoFieldDescriptor(id: 18, name: "networkType", type: .prototype("NetworkType"), label: .repeated),
		ProtoFieldDescriptor(id: 19, name: "forceHistoryState", type: .prototype("ForceHistory"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "type":
			guard value is ConversationType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ConversationType?
		case "name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case "selfConversationState":
			guard value is UserConversationState? else { throw ProtoError.typeMismatchError }
			self.selfConversationState = value as! UserConversationState?
		case "readState":
			guard value is [UserReadState] else { throw ProtoError.typeMismatchError }
			self.readState = value as! [UserReadState]
		case "hasActiveHangout":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.hasActiveHangout = value as! Bool?
		case "otrStatus":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.otrStatus = value as! OffTheRecordStatus?
		case "otrToggle":
			guard value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.otrToggle = value as! OffTheRecordToggle?
		case "conversationHistorySupported":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.conversationHistorySupported = value as! Bool?
		case "currentParticipant":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.currentParticipant = value as! [ParticipantId]
		case "participantData":
			guard value is [ConversationParticipantData] else { throw ProtoError.typeMismatchError }
			self.participantData = value as! [ConversationParticipantData]
		case "networkType":
			guard value is [NetworkType] else { throw ProtoError.typeMismatchError }
			self.networkType = value as! [NetworkType]
		case "forceHistoryState":
			guard value is ForceHistory? else { throw ProtoError.typeMismatchError }
			self.forceHistoryState = value as! ForceHistory?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "type": return self.type
		case "name": return self.name
		case "selfConversationState": return self.selfConversationState
		case "readState": return self.readState
		case "hasActiveHangout": return self.hasActiveHangout
		case "otrStatus": return self.otrStatus
		case "otrToggle": return self.otrToggle
		case "conversationHistorySupported": return self.conversationHistorySupported
		case "currentParticipant": return self.currentParticipant
		case "participantData": return self.participantData
		case "networkType": return self.networkType
		case "forceHistoryState": return self.forceHistoryState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var type: ConversationType?
	public var name: String?
	public var selfConversationState: UserConversationState?
	public var readState: [UserReadState]
	public var hasActiveHangout: Bool?
	public var otrStatus: OffTheRecordStatus?
	public var otrToggle: OffTheRecordToggle?
	public var conversationHistorySupported: Bool?
	public var currentParticipant: [ParticipantId]
	public var participantData: [ConversationParticipantData]
	public var networkType: [NetworkType]
	public var forceHistoryState: ForceHistory?
}

public struct EasterEgg: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "message", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "message":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.message = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "message": return self.message
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var message: String?
}

public struct BlockStateChange: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "participantId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "newBlockState", type: .prototype("BlockState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "participantId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.participantId = value as! ParticipantId?
		case "newBlockState":
			guard value is BlockState? else { throw ProtoError.typeMismatchError }
			self.newBlockState = value as! BlockState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "participantId": return self.participantId
		case "newBlockState": return self.newBlockState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var participantId: ParticipantId?
	public var newBlockState: BlockState?
}

public struct Photo: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "photoId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "deleteAlbumlessSourcePhoto", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "userId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "isCustomUserId", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "photoId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.photoId = value as! String?
		case "deleteAlbumlessSourcePhoto":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.deleteAlbumlessSourcePhoto = value as! Bool?
		case "userId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.userId = value as! String?
		case "isCustomUserId":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isCustomUserId = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "photoId": return self.photoId
		case "deleteAlbumlessSourcePhoto": return self.deleteAlbumlessSourcePhoto
		case "userId": return self.userId
		case "isCustomUserId": return self.isCustomUserId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var photoId: String?
	public var deleteAlbumlessSourcePhoto: Bool?
	public var userId: String?
	public var isCustomUserId: Bool?
}

public struct ExistingMedia: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "photo", type: .prototype("Photo"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "photo":
			guard value is Photo? else { throw ProtoError.typeMismatchError }
			self.photo = value as! Photo?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "photo": return self.photo
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var photo: Photo?
}

public struct EventRequestHeader: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "clientGeneratedId", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "expectedOtr", type: .prototype("OffTheRecordStatus"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "deliveryMedium", type: .prototype("DeliveryMedium"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "eventType", type: .prototype("EventType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "clientGeneratedId":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! UInt64?
		case "expectedOtr":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.expectedOtr = value as! OffTheRecordStatus?
		case "deliveryMedium":
			guard value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.deliveryMedium = value as! DeliveryMedium?
		case "eventType":
			guard value is EventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! EventType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "clientGeneratedId": return self.clientGeneratedId
		case "expectedOtr": return self.expectedOtr
		case "deliveryMedium": return self.deliveryMedium
		case "eventType": return self.eventType
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var clientGeneratedId: UInt64?
	public var expectedOtr: OffTheRecordStatus?
	public var deliveryMedium: DeliveryMedium?
	public var eventType: EventType?
}

public struct ClientVersion: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "clientId", type: .prototype("ClientId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "buildType", type: .prototype("ClientBuildType"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "majorVersion", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "versionTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "deviceOsVersion", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 6, name: "deviceHardware", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "clientId":
			guard value is ClientId? else { throw ProtoError.typeMismatchError }
			self.clientId = value as! ClientId?
		case "buildType":
			guard value is ClientBuildType? else { throw ProtoError.typeMismatchError }
			self.buildType = value as! ClientBuildType?
		case "majorVersion":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.majorVersion = value as! String?
		case "versionTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.versionTimestamp = value as! UInt64?
		case "deviceOsVersion":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.deviceOsVersion = value as! String?
		case "deviceHardware":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.deviceHardware = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "clientId": return self.clientId
		case "buildType": return self.buildType
		case "majorVersion": return self.majorVersion
		case "versionTimestamp": return self.versionTimestamp
		case "deviceOsVersion": return self.deviceOsVersion
		case "deviceHardware": return self.deviceHardware
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var clientId: ClientId?
	public var buildType: ClientBuildType?
	public var majorVersion: String?
	public var versionTimestamp: UInt64?
	public var deviceOsVersion: String?
	public var deviceHardware: String?
}

public struct RequestHeader: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "clientVersion", type: .prototype("ClientVersion"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "clientIdentifier", type: .prototype("ClientIdentifier"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "languageCode", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "clientVersion":
			guard value is ClientVersion? else { throw ProtoError.typeMismatchError }
			self.clientVersion = value as! ClientVersion?
		case "clientIdentifier":
			guard value is ClientIdentifier? else { throw ProtoError.typeMismatchError }
			self.clientIdentifier = value as! ClientIdentifier?
		case "languageCode":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.languageCode = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "clientVersion": return self.clientVersion
		case "clientIdentifier": return self.clientIdentifier
		case "languageCode": return self.languageCode
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var clientVersion: ClientVersion?
	public var clientIdentifier: ClientIdentifier?
	public var languageCode: String?
}

public struct ResponseHeader: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "status", type: .prototype("ResponseStatus"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "errorDescription", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "debugUrl", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "requestTraceId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "currentServerTime", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "status":
			guard value is ResponseStatus? else { throw ProtoError.typeMismatchError }
			self.status = value as! ResponseStatus?
		case "errorDescription":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.errorDescription = value as! String?
		case "debugUrl":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.debugUrl = value as! String?
		case "requestTraceId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.requestTraceId = value as! String?
		case "currentServerTime":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.currentServerTime = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "status": return self.status
		case "errorDescription": return self.errorDescription
		case "debugUrl": return self.debugUrl
		case "requestTraceId": return self.requestTraceId
		case "currentServerTime": return self.currentServerTime
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var status: ResponseStatus?
	public var errorDescription: String?
	public var debugUrl: String?
	public var requestTraceId: String?
	public var currentServerTime: UInt64?
}

public struct Entity: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 9, name: "id", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "presence", type: .prototype("Presence"), label: .optional),
		ProtoFieldDescriptor(id: 10, name: "properties", type: .prototype("EntityProperties"), label: .optional),
		ProtoFieldDescriptor(id: 13, name: "entityType", type: .prototype("ParticipantType"), label: .optional),
		ProtoFieldDescriptor(id: 16, name: "hadPastHangoutState", type: .prototype("PastHangoutState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.id = value as! ParticipantId?
		case "presence":
			guard value is Presence? else { throw ProtoError.typeMismatchError }
			self.presence = value as! Presence?
		case "properties":
			guard value is EntityProperties? else { throw ProtoError.typeMismatchError }
			self.properties = value as! EntityProperties?
		case "entityType":
			guard value is ParticipantType? else { throw ProtoError.typeMismatchError }
			self.entityType = value as! ParticipantType?
		case "hadPastHangoutState":
			guard value is PastHangoutState? else { throw ProtoError.typeMismatchError }
			self.hadPastHangoutState = value as! PastHangoutState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "id": return self.id
		case "presence": return self.presence
		case "properties": return self.properties
		case "entityType": return self.entityType
		case "hadPastHangoutState": return self.hadPastHangoutState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var id: ParticipantId?
	public var presence: Presence?
	public var properties: EntityProperties?
	public var entityType: ParticipantType?
	public var hadPastHangoutState: PastHangoutState?
}

public struct EntityProperties: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("ProfileType"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "displayName", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "firstName", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "photoUrl", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "email", type: .string, label: .repeated),
		ProtoFieldDescriptor(id: 6, name: "phone", type: .string, label: .repeated),
		ProtoFieldDescriptor(id: 10, name: "inUsersDomain", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 11, name: "gender", type: .prototype("Gender"), label: .optional),
		ProtoFieldDescriptor(id: 12, name: "photoUrlStatus", type: .prototype("PhotoUrlStatus"), label: .optional),
		ProtoFieldDescriptor(id: 15, name: "canonicalEmail", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is ProfileType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ProfileType?
		case "displayName":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.displayName = value as! String?
		case "firstName":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.firstName = value as! String?
		case "photoUrl":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.photoUrl = value as! String?
		case "email":
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.email = value as! [String]
		case "phone":
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.phone = value as! [String]
		case "inUsersDomain":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.inUsersDomain = value as! Bool?
		case "gender":
			guard value is Gender? else { throw ProtoError.typeMismatchError }
			self.gender = value as! Gender?
		case "photoUrlStatus":
			guard value is PhotoUrlStatus? else { throw ProtoError.typeMismatchError }
			self.photoUrlStatus = value as! PhotoUrlStatus?
		case "canonicalEmail":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.canonicalEmail = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "displayName": return self.displayName
		case "firstName": return self.firstName
		case "photoUrl": return self.photoUrl
		case "email": return self.email
		case "phone": return self.phone
		case "inUsersDomain": return self.inUsersDomain
		case "gender": return self.gender
		case "photoUrlStatus": return self.photoUrlStatus
		case "canonicalEmail": return self.canonicalEmail
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: ProfileType?
	public var displayName: String?
	public var firstName: String?
	public var photoUrl: String?
	public var email: [String]
	public var phone: [String]
	public var inUsersDomain: Bool?
	public var gender: Gender?
	public var photoUrlStatus: PhotoUrlStatus?
	public var canonicalEmail: String?
}

public struct ConversationState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversation", type: .prototype("Conversation"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "event", type: .prototype("Event"), label: .repeated),
		ProtoFieldDescriptor(id: 5, name: "eventContinuationToken", type: .prototype("EventContinuationToken"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "conversation":
			guard value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case "event":
			guard value is [Event] else { throw ProtoError.typeMismatchError }
			self.event = value as! [Event]
		case "eventContinuationToken":
			guard value is EventContinuationToken? else { throw ProtoError.typeMismatchError }
			self.eventContinuationToken = value as! EventContinuationToken?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "conversation": return self.conversation
		case "event": return self.event
		case "eventContinuationToken": return self.eventContinuationToken
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var conversation: Conversation?
	public var event: [Event]
	public var eventContinuationToken: EventContinuationToken?
}

public struct EventContinuationToken: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "eventId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "storageContinuationToken", type: .bytes, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "eventTimestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "eventId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.eventId = value as! String?
		case "storageContinuationToken":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.storageContinuationToken = value as! String?
		case "eventTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.eventTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "eventId": return self.eventId
		case "storageContinuationToken": return self.storageContinuationToken
		case "eventTimestamp": return self.eventTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var eventId: String?
	public var storageContinuationToken: String?
	public var eventTimestamp: UInt64?
}

public struct EntityLookupSpec: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "gaiaId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "email", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "phone", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 6, name: "createOffnetworkGaia", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "gaiaId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case "email":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.email = value as! String?
		case "phone":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.phone = value as! String?
		case "createOffnetworkGaia":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.createOffnetworkGaia = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "gaiaId": return self.gaiaId
		case "email": return self.email
		case "phone": return self.phone
		case "createOffnetworkGaia": return self.createOffnetworkGaia
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var gaiaId: String?
	public var email: String?
	public var phone: String?
	public var createOffnetworkGaia: Bool?
}

public struct ConfigurationBit: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "configurationBitType", type: .prototype("ConfigurationBitType"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "value", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "configurationBitType":
			guard value is ConfigurationBitType? else { throw ProtoError.typeMismatchError }
			self.configurationBitType = value as! ConfigurationBitType?
		case "value":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.value = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "configurationBitType": return self.configurationBitType
		case "value": return self.value
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var configurationBitType: ConfigurationBitType?
	public var value: Bool?
}

public struct RichPresenceState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 3, name: "getRichPresenceEnabledState", type: .prototype("RichPresenceEnabledState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "getRichPresenceEnabledState":
			guard value is [RichPresenceEnabledState] else { throw ProtoError.typeMismatchError }
			self.getRichPresenceEnabledState = value as! [RichPresenceEnabledState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "getRichPresenceEnabledState": return self.getRichPresenceEnabledState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var getRichPresenceEnabledState: [RichPresenceEnabledState]
}

public struct RichPresenceEnabledState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("RichPresenceType"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "enabled", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is RichPresenceType? else { throw ProtoError.typeMismatchError }
			self.type = value as! RichPresenceType?
		case "enabled":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.enabled = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "enabled": return self.enabled
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: RichPresenceType?
	public var enabled: Bool?
}

public struct DesktopOffSetting: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "desktopOff", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktopOff":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.desktopOff = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "desktopOff": return self.desktopOff
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopOff: Bool?
}

public struct DesktopOffState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "desktopOff", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "version", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktopOff":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.desktopOff = value as! Bool?
		case "version":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.version = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "desktopOff": return self.desktopOff
		case "version": return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopOff: Bool?
	public var version: UInt64?
}

public struct DndSetting: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "doNotDisturb", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "timeoutSecs", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "doNotDisturb":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.doNotDisturb = value as! Bool?
		case "timeoutSecs":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "doNotDisturb": return self.doNotDisturb
		case "timeoutSecs": return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var doNotDisturb: Bool?
	public var timeoutSecs: UInt64?
}

public struct PresenceStateSetting: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "timeoutSecs", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ClientPresenceStateType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "timeoutSecs":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		case "type":
			guard value is ClientPresenceStateType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ClientPresenceStateType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "timeoutSecs": return self.timeoutSecs
		case "type": return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var timeoutSecs: UInt64?
	public var type: ClientPresenceStateType?
}

public struct MoodMessage: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "moodContent", type: .prototype("MoodContent"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "moodContent":
			guard value is MoodContent? else { throw ProtoError.typeMismatchError }
			self.moodContent = value as! MoodContent?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "moodContent": return self.moodContent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var moodContent: MoodContent?
}

public struct MoodContent: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "segment", type: .prototype("Segment"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "segment":
			guard value is [Segment] else { throw ProtoError.typeMismatchError }
			self.segment = value as! [Segment]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "segment": return self.segment
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var segment: [Segment]
}

public struct MoodSetting: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "moodMessage", type: .prototype("MoodMessage"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "moodMessage":
			guard value is MoodMessage? else { throw ProtoError.typeMismatchError }
			self.moodMessage = value as! MoodMessage?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "moodMessage": return self.moodMessage
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var moodMessage: MoodMessage?
}

public struct MoodState: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 4, name: "moodSetting", type: .prototype("MoodSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "moodSetting":
			guard value is MoodSetting? else { throw ProtoError.typeMismatchError }
			self.moodSetting = value as! MoodSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "moodSetting": return self.moodSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var moodSetting: MoodSetting?
}

public struct DeleteAction: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "deleteActionTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "deleteUpperBoundTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "deleteType", type: .prototype("DeleteType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "deleteActionTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteActionTimestamp = value as! UInt64?
		case "deleteUpperBoundTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteUpperBoundTimestamp = value as! UInt64?
		case "deleteType":
			guard value is DeleteType? else { throw ProtoError.typeMismatchError }
			self.deleteType = value as! DeleteType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "deleteActionTimestamp": return self.deleteActionTimestamp
		case "deleteUpperBoundTimestamp": return self.deleteUpperBoundTimestamp
		case "deleteType": return self.deleteType
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var deleteActionTimestamp: UInt64?
	public var deleteUpperBoundTimestamp: UInt64?
	public var deleteType: DeleteType?
}

public struct InviteeID: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "gaiaId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "fallbackName", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "gaiaId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case "fallbackName":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.fallbackName = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "gaiaId": return self.gaiaId
		case "fallbackName": return self.fallbackName
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var gaiaId: String?
	public var fallbackName: String?
}

public struct Country: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "regionCode", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "countryCode", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "regionCode":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.regionCode = value as! String?
		case "countryCode":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.countryCode = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "regionCode": return self.regionCode
		case "countryCode": return self.countryCode
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var regionCode: String?
	public var countryCode: UInt64?
}

public struct DesktopSoundSetting: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "desktopSoundState", type: .prototype("SoundState"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "desktopRingSoundState", type: .prototype("SoundState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktopSoundState":
			guard value is SoundState? else { throw ProtoError.typeMismatchError }
			self.desktopSoundState = value as! SoundState?
		case "desktopRingSoundState":
			guard value is SoundState? else { throw ProtoError.typeMismatchError }
			self.desktopRingSoundState = value as! SoundState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "desktopSoundState": return self.desktopSoundState
		case "desktopRingSoundState": return self.desktopRingSoundState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopSoundState: SoundState?
	public var desktopRingSoundState: SoundState?
}

public struct PhoneData: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "phone", type: .prototype("Phone"), label: .repeated),
		ProtoFieldDescriptor(id: 3, name: "callerIdSettingsMask", type: .prototype("CallerIdSettingsMask"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "phone":
			guard value is [Phone] else { throw ProtoError.typeMismatchError }
			self.phone = value as! [Phone]
		case "callerIdSettingsMask":
			guard value is CallerIdSettingsMask? else { throw ProtoError.typeMismatchError }
			self.callerIdSettingsMask = value as! CallerIdSettingsMask?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "phone": return self.phone
		case "callerIdSettingsMask": return self.callerIdSettingsMask
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var phone: [Phone]
	public var callerIdSettingsMask: CallerIdSettingsMask?
}

public struct Phone: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "phoneNumber", type: .prototype("PhoneNumber"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "googleVoice", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "verificationStatus", type: .prototype("PhoneVerificationStatus"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "discoverable", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "discoverabilityStatus", type: .prototype("PhoneDiscoverabilityStatus"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "primary", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "phoneNumber":
			guard value is PhoneNumber? else { throw ProtoError.typeMismatchError }
			self.phoneNumber = value as! PhoneNumber?
		case "googleVoice":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.googleVoice = value as! Bool?
		case "verificationStatus":
			guard value is PhoneVerificationStatus? else { throw ProtoError.typeMismatchError }
			self.verificationStatus = value as! PhoneVerificationStatus?
		case "discoverable":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.discoverable = value as! Bool?
		case "discoverabilityStatus":
			guard value is PhoneDiscoverabilityStatus? else { throw ProtoError.typeMismatchError }
			self.discoverabilityStatus = value as! PhoneDiscoverabilityStatus?
		case "primary":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.primary = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "phoneNumber": return self.phoneNumber
		case "googleVoice": return self.googleVoice
		case "verificationStatus": return self.verificationStatus
		case "discoverable": return self.discoverable
		case "discoverabilityStatus": return self.discoverabilityStatus
		case "primary": return self.primary
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var phoneNumber: PhoneNumber?
	public var googleVoice: Bool?
	public var verificationStatus: PhoneVerificationStatus?
	public var discoverable: Bool?
	public var discoverabilityStatus: PhoneDiscoverabilityStatus?
	public var primary: Bool?
}

public struct I18nData: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "nationalNumber", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "internationalNumber", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "countryCode", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "regionCode", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "isValid", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 6, name: "validationResult", type: .prototype("PhoneValidationResult"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "nationalNumber":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.nationalNumber = value as! String?
		case "internationalNumber":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.internationalNumber = value as! String?
		case "countryCode":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.countryCode = value as! UInt64?
		case "regionCode":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.regionCode = value as! String?
		case "isValid":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isValid = value as! Bool?
		case "validationResult":
			guard value is PhoneValidationResult? else { throw ProtoError.typeMismatchError }
			self.validationResult = value as! PhoneValidationResult?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "nationalNumber": return self.nationalNumber
		case "internationalNumber": return self.internationalNumber
		case "countryCode": return self.countryCode
		case "regionCode": return self.regionCode
		case "isValid": return self.isValid
		case "validationResult": return self.validationResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var nationalNumber: String?
	public var internationalNumber: String?
	public var countryCode: UInt64?
	public var regionCode: String?
	public var isValid: Bool?
	public var validationResult: PhoneValidationResult?
}

public struct PhoneNumber: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "e164", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "i18nData", type: .prototype("I18nData"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "e164":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.e164 = value as! String?
		case "i18nData":
			guard value is I18nData? else { throw ProtoError.typeMismatchError }
			self.i18nData = value as! I18nData?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "e164": return self.e164
		case "i18nData": return self.i18nData
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var e164: String?
	public var i18nData: I18nData?
}

public struct SuggestedContactGroupHash: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "maxResults", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "hash", type: .bytes, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "maxResults":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxResults = value as! UInt64?
		case "hash":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.hash = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "maxResults": return self.maxResults
		case "hash": return self.hash
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var maxResults: UInt64?
	public var hash: String?
}

public struct SuggestedContact: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "entity", type: .prototype("Entity"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "invitationStatus", type: .prototype("InvitationStatus"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "entity":
			guard value is Entity? else { throw ProtoError.typeMismatchError }
			self.entity = value as! Entity?
		case "invitationStatus":
			guard value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.invitationStatus = value as! InvitationStatus?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "entity": return self.entity
		case "invitationStatus": return self.invitationStatus
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var entity: Entity?
	public var invitationStatus: InvitationStatus?
}

public struct SuggestedContactGroup: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "hashMatched", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 2, name: "hash", type: .bytes, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "contact", type: .prototype("SuggestedContact"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "hashMatched":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.hashMatched = value as! Bool?
		case "hash":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.hash = value as! String?
		case "contact":
			guard value is [SuggestedContact] else { throw ProtoError.typeMismatchError }
			self.contact = value as! [SuggestedContact]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "hashMatched": return self.hashMatched
		case "hash": return self.hash
		case "contact": return self.contact
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashMatched: Bool?
	public var hash: String?
	public var contact: [SuggestedContact]
}

public struct StateUpdate: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "stateUpdateHeader", type: .prototype("StateUpdateHeader"), label: .optional),
		ProtoFieldDescriptor(id: 13, name: "conversation", type: .prototype("Conversation"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationNotification", type: .prototype("ConversationNotification"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "eventNotification", type: .prototype("EventNotification"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "focusNotification", type: .prototype("SetFocusNotification"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "typingNotification", type: .prototype("SetTypingNotification"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "notificationLevelNotification", type: .prototype("SetConversationNotificationLevelNotification"), label: .optional),
		ProtoFieldDescriptor(id: 7, name: "replyToInviteNotification", type: .prototype("ReplyToInviteNotification"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "watermarkNotification", type: .prototype("WatermarkNotification"), label: .optional),
		ProtoFieldDescriptor(id: 11, name: "viewModification", type: .prototype("ConversationViewModification"), label: .optional),
		ProtoFieldDescriptor(id: 12, name: "easterEggNotification", type: .prototype("EasterEggNotification"), label: .optional),
		ProtoFieldDescriptor(id: 14, name: "selfPresenceNotification", type: .prototype("SelfPresenceNotification"), label: .optional),
		ProtoFieldDescriptor(id: 15, name: "deleteNotification", type: .prototype("DeleteActionNotification"), label: .optional),
		ProtoFieldDescriptor(id: 16, name: "presenceNotification", type: .prototype("PresenceNotification"), label: .optional),
		ProtoFieldDescriptor(id: 17, name: "blockNotification", type: .prototype("BlockNotification"), label: .optional),
		ProtoFieldDescriptor(id: 19, name: "notificationSettingNotification", type: .prototype("SetNotificationSettingNotification"), label: .optional),
		ProtoFieldDescriptor(id: 20, name: "richPresenceEnabledStateNotification", type: .prototype("RichPresenceEnabledStateNotification"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "stateUpdateHeader":
			guard value is StateUpdateHeader? else { throw ProtoError.typeMismatchError }
			self.stateUpdateHeader = value as! StateUpdateHeader?
		case "conversation":
			guard value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case "conversationNotification":
			guard value is ConversationNotification? else { throw ProtoError.typeMismatchError }
			self.conversationNotification = value as! ConversationNotification?
		case "eventNotification":
			guard value is EventNotification? else { throw ProtoError.typeMismatchError }
			self.eventNotification = value as! EventNotification?
		case "focusNotification":
			guard value is SetFocusNotification? else { throw ProtoError.typeMismatchError }
			self.focusNotification = value as! SetFocusNotification?
		case "typingNotification":
			guard value is SetTypingNotification? else { throw ProtoError.typeMismatchError }
			self.typingNotification = value as! SetTypingNotification?
		case "notificationLevelNotification":
			guard value is SetConversationNotificationLevelNotification? else { throw ProtoError.typeMismatchError }
			self.notificationLevelNotification = value as! SetConversationNotificationLevelNotification?
		case "replyToInviteNotification":
			guard value is ReplyToInviteNotification? else { throw ProtoError.typeMismatchError }
			self.replyToInviteNotification = value as! ReplyToInviteNotification?
		case "watermarkNotification":
			guard value is WatermarkNotification? else { throw ProtoError.typeMismatchError }
			self.watermarkNotification = value as! WatermarkNotification?
		case "viewModification":
			guard value is ConversationViewModification? else { throw ProtoError.typeMismatchError }
			self.viewModification = value as! ConversationViewModification?
		case "easterEggNotification":
			guard value is EasterEggNotification? else { throw ProtoError.typeMismatchError }
			self.easterEggNotification = value as! EasterEggNotification?
		case "selfPresenceNotification":
			guard value is SelfPresenceNotification? else { throw ProtoError.typeMismatchError }
			self.selfPresenceNotification = value as! SelfPresenceNotification?
		case "deleteNotification":
			guard value is DeleteActionNotification? else { throw ProtoError.typeMismatchError }
			self.deleteNotification = value as! DeleteActionNotification?
		case "presenceNotification":
			guard value is PresenceNotification? else { throw ProtoError.typeMismatchError }
			self.presenceNotification = value as! PresenceNotification?
		case "blockNotification":
			guard value is BlockNotification? else { throw ProtoError.typeMismatchError }
			self.blockNotification = value as! BlockNotification?
		case "notificationSettingNotification":
			guard value is SetNotificationSettingNotification? else { throw ProtoError.typeMismatchError }
			self.notificationSettingNotification = value as! SetNotificationSettingNotification?
		case "richPresenceEnabledStateNotification":
			guard value is RichPresenceEnabledStateNotification? else { throw ProtoError.typeMismatchError }
			self.richPresenceEnabledStateNotification = value as! RichPresenceEnabledStateNotification?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "stateUpdateHeader": return self.stateUpdateHeader
		case "conversation": return self.conversation
		case "conversationNotification": return self.conversationNotification
		case "eventNotification": return self.eventNotification
		case "focusNotification": return self.focusNotification
		case "typingNotification": return self.typingNotification
		case "notificationLevelNotification": return self.notificationLevelNotification
		case "replyToInviteNotification": return self.replyToInviteNotification
		case "watermarkNotification": return self.watermarkNotification
		case "viewModification": return self.viewModification
		case "easterEggNotification": return self.easterEggNotification
		case "selfPresenceNotification": return self.selfPresenceNotification
		case "deleteNotification": return self.deleteNotification
		case "presenceNotification": return self.presenceNotification
		case "blockNotification": return self.blockNotification
		case "notificationSettingNotification": return self.notificationSettingNotification
		case "richPresenceEnabledStateNotification": return self.richPresenceEnabledStateNotification
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var stateUpdateHeader: StateUpdateHeader?
	public var conversation: Conversation?
	public var conversationNotification: ConversationNotification?
	public var eventNotification: EventNotification?
	public var focusNotification: SetFocusNotification?
	public var typingNotification: SetTypingNotification?
	public var notificationLevelNotification: SetConversationNotificationLevelNotification?
	public var replyToInviteNotification: ReplyToInviteNotification?
	public var watermarkNotification: WatermarkNotification?
	public var viewModification: ConversationViewModification?
	public var easterEggNotification: EasterEggNotification?
	public var selfPresenceNotification: SelfPresenceNotification?
	public var deleteNotification: DeleteActionNotification?
	public var presenceNotification: PresenceNotification?
	public var blockNotification: BlockNotification?
	public var notificationSettingNotification: SetNotificationSettingNotification?
	public var richPresenceEnabledStateNotification: RichPresenceEnabledStateNotification?
}

public struct StateUpdateHeader: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "activeClientState", type: .prototype("ActiveClientState"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "requestTraceId", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "notificationSettings", type: .prototype("NotificationSettings"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "currentServerTime", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "activeClientState":
			guard value is ActiveClientState? else { throw ProtoError.typeMismatchError }
			self.activeClientState = value as! ActiveClientState?
		case "requestTraceId":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.requestTraceId = value as! String?
		case "notificationSettings":
			guard value is NotificationSettings? else { throw ProtoError.typeMismatchError }
			self.notificationSettings = value as! NotificationSettings?
		case "currentServerTime":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.currentServerTime = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "activeClientState": return self.activeClientState
		case "requestTraceId": return self.requestTraceId
		case "notificationSettings": return self.notificationSettings
		case "currentServerTime": return self.currentServerTime
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var activeClientState: ActiveClientState?
	public var requestTraceId: String?
	public var notificationSettings: NotificationSettings?
	public var currentServerTime: UInt64?
}

public struct BatchUpdate: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "stateUpdate", type: .prototype("StateUpdate"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "stateUpdate":
			guard value is [StateUpdate] else { throw ProtoError.typeMismatchError }
			self.stateUpdate = value as! [StateUpdate]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "stateUpdate": return self.stateUpdate
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var stateUpdate: [StateUpdate]
}

public struct ConversationNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversation", type: .prototype("Conversation"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation":
			guard value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation": return self.conversation
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversation: Conversation?
}

public struct EventNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "event", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "event":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.event = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "event": return self.event
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var event: Event?
}

public struct SetFocusNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "senderId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "type", type: .prototype("FocusType"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "device", type: .prototype("FocusDevice"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "senderId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		case "type":
			guard value is FocusType? else { throw ProtoError.typeMismatchError }
			self.type = value as! FocusType?
		case "device":
			guard value is FocusDevice? else { throw ProtoError.typeMismatchError }
			self.device = value as! FocusDevice?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "senderId": return self.senderId
		case "timestamp": return self.timestamp
		case "type": return self.type
		case "device": return self.device
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var senderId: ParticipantId?
	public var timestamp: UInt64?
	public var type: FocusType?
	public var device: FocusDevice?
}

public struct SetTypingNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "senderId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "type", type: .prototype("TypingType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "senderId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		case "type":
			guard value is TypingType? else { throw ProtoError.typeMismatchError }
			self.type = value as! TypingType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "senderId": return self.senderId
		case "timestamp": return self.timestamp
		case "type": return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var senderId: ParticipantId?
	public var timestamp: UInt64?
	public var type: TypingType?
}

public struct SetConversationNotificationLevelNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "level", type: .prototype("NotificationLevel"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "level":
			guard value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.level = value as! NotificationLevel?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "level": return self.level
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var level: NotificationLevel?
	public var timestamp: UInt64?
}

public struct ReplyToInviteNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ReplyToInviteType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "type":
			guard value is ReplyToInviteType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ReplyToInviteType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "type": return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var type: ReplyToInviteType?
}

public struct WatermarkNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "senderId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "latestReadTimestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "senderId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "latestReadTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.latestReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "senderId": return self.senderId
		case "conversationId": return self.conversationId
		case "latestReadTimestamp": return self.latestReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var senderId: ParticipantId?
	public var conversationId: ConversationId?
	public var latestReadTimestamp: UInt64?
}

public struct ConversationViewModification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "oldView", type: .prototype("ConversationView"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "newView", type: .prototype("ConversationView"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "oldView":
			guard value is ConversationView? else { throw ProtoError.typeMismatchError }
			self.oldView = value as! ConversationView?
		case "newView":
			guard value is ConversationView? else { throw ProtoError.typeMismatchError }
			self.newView = value as! ConversationView?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "oldView": return self.oldView
		case "newView": return self.newView
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var oldView: ConversationView?
	public var newView: ConversationView?
}

public struct EasterEggNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "senderId", type: .prototype("ParticipantId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "easterEgg", type: .prototype("EasterEgg"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "senderId":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "easterEgg":
			guard value is EasterEgg? else { throw ProtoError.typeMismatchError }
			self.easterEgg = value as! EasterEgg?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "senderId": return self.senderId
		case "conversationId": return self.conversationId
		case "easterEgg": return self.easterEgg
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var senderId: ParticipantId?
	public var conversationId: ConversationId?
	public var easterEgg: EasterEgg?
}

public struct SelfPresenceNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "clientPresenceState", type: .prototype("ClientPresenceState"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "doNotDisturbSetting", type: .prototype("DoNotDisturbSetting"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "desktopOffSetting", type: .prototype("DesktopOffSetting"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "desktopOffState", type: .prototype("DesktopOffState"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "moodState", type: .prototype("MoodState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "clientPresenceState":
			guard value is ClientPresenceState? else { throw ProtoError.typeMismatchError }
			self.clientPresenceState = value as! ClientPresenceState?
		case "doNotDisturbSetting":
			guard value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.doNotDisturbSetting = value as! DoNotDisturbSetting?
		case "desktopOffSetting":
			guard value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case "desktopOffState":
			guard value is DesktopOffState? else { throw ProtoError.typeMismatchError }
			self.desktopOffState = value as! DesktopOffState?
		case "moodState":
			guard value is MoodState? else { throw ProtoError.typeMismatchError }
			self.moodState = value as! MoodState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "clientPresenceState": return self.clientPresenceState
		case "doNotDisturbSetting": return self.doNotDisturbSetting
		case "desktopOffSetting": return self.desktopOffSetting
		case "desktopOffState": return self.desktopOffState
		case "moodState": return self.moodState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var clientPresenceState: ClientPresenceState?
	public var doNotDisturbSetting: DoNotDisturbSetting?
	public var desktopOffSetting: DesktopOffSetting?
	public var desktopOffState: DesktopOffState?
	public var moodState: MoodState?
}

public struct DeleteActionNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "deleteAction", type: .prototype("DeleteAction"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "deleteAction":
			guard value is DeleteAction? else { throw ProtoError.typeMismatchError }
			self.deleteAction = value as! DeleteAction?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		case "deleteAction": return self.deleteAction
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var deleteAction: DeleteAction?
}

public struct PresenceNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "presence", type: .prototype("PresenceResult"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "presence":
			guard value is [PresenceResult] else { throw ProtoError.typeMismatchError }
			self.presence = value as! [PresenceResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "presence": return self.presence
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var presence: [PresenceResult]
}

public struct BlockNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "blockStateChange", type: .prototype("BlockStateChange"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "blockStateChange":
			guard value is [BlockStateChange] else { throw ProtoError.typeMismatchError }
			self.blockStateChange = value as! [BlockStateChange]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "blockStateChange": return self.blockStateChange
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var blockStateChange: [BlockStateChange]
}

public struct SetNotificationSettingNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 2, name: "desktopSoundSetting", type: .prototype("DesktopSoundSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktopSoundSetting":
			guard value is DesktopSoundSetting? else { throw ProtoError.typeMismatchError }
			self.desktopSoundSetting = value as! DesktopSoundSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "desktopSoundSetting": return self.desktopSoundSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopSoundSetting: DesktopSoundSetting?
}

public struct RichPresenceEnabledStateNotification: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "richPresenceEnabledState", type: .prototype("RichPresenceEnabledState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "richPresenceEnabledState":
			guard value is [RichPresenceEnabledState] else { throw ProtoError.typeMismatchError }
			self.richPresenceEnabledState = value as! [RichPresenceEnabledState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "richPresenceEnabledState": return self.richPresenceEnabledState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var richPresenceEnabledState: [RichPresenceEnabledState]
}

public struct ConversationSpec: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversationId": return self.conversationId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
}

public struct OffnetworkAddress: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("OffnetworkAddressType"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "email", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is OffnetworkAddressType? else { throw ProtoError.typeMismatchError }
			self.type = value as! OffnetworkAddressType?
		case "email":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.email = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "email": return self.email
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: OffnetworkAddressType?
	public var email: String?
}

public struct EntityResult: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "lookupSpec", type: .prototype("EntityLookupSpec"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "lookupSpec":
			guard value is EntityLookupSpec? else { throw ProtoError.typeMismatchError }
			self.lookupSpec = value as! EntityLookupSpec?
		case "entity":
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "lookupSpec": return self.lookupSpec
		case "entity": return self.entity
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var lookupSpec: EntityLookupSpec?
	public var entity: [Entity]
}

public struct AddUserRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "inviteeId", type: .prototype("InviteeID"), label: .repeated),
		ProtoFieldDescriptor(id: 5, name: "eventRequestHeader", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "inviteeId":
			guard value is [InviteeID] else { throw ProtoError.typeMismatchError }
			self.inviteeId = value as! [InviteeID]
		case "eventRequestHeader":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "inviteeId": return self.inviteeId
		case "eventRequestHeader": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var inviteeId: [InviteeID]
	public var eventRequestHeader: EventRequestHeader?
}

public struct AddUserResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "createdEvent", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "createdEvent":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "createdEvent": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct CreateConversationRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ConversationType"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "clientGeneratedId", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "name", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "inviteeId", type: .prototype("InviteeID"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "type":
			guard value is ConversationType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ConversationType?
		case "clientGeneratedId":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! UInt64?
		case "name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case "inviteeId":
			guard value is [InviteeID] else { throw ProtoError.typeMismatchError }
			self.inviteeId = value as! [InviteeID]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "type": return self.type
		case "clientGeneratedId": return self.clientGeneratedId
		case "name": return self.name
		case "inviteeId": return self.inviteeId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var type: ConversationType?
	public var clientGeneratedId: UInt64?
	public var name: String?
	public var inviteeId: [InviteeID]
}

public struct CreateConversationResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversation", type: .prototype("Conversation"), label: .optional),
		ProtoFieldDescriptor(id: 7, name: "newConversationCreated", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "conversation":
			guard value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case "newConversationCreated":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.newConversationCreated = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "conversation": return self.conversation
		case "newConversationCreated": return self.newConversationCreated
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var conversation: Conversation?
	public var newConversationCreated: Bool?
}

public struct DeleteConversationRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "deleteUpperBoundTimestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "deleteUpperBoundTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteUpperBoundTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "conversationId": return self.conversationId
		case "deleteUpperBoundTimestamp": return self.deleteUpperBoundTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var deleteUpperBoundTimestamp: UInt64?
}

public struct DeleteConversationResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "deleteAction", type: .prototype("DeleteAction"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "deleteAction":
			guard value is DeleteAction? else { throw ProtoError.typeMismatchError }
			self.deleteAction = value as! DeleteAction?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "deleteAction": return self.deleteAction
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var deleteAction: DeleteAction?
}

public struct EasterEggRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "easterEgg", type: .prototype("EasterEgg"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "easterEgg":
			guard value is EasterEgg? else { throw ProtoError.typeMismatchError }
			self.easterEgg = value as! EasterEgg?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "conversationId": return self.conversationId
		case "easterEgg": return self.easterEgg
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var easterEgg: EasterEgg?
}

public struct EasterEggResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct GetConversationRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationSpec", type: .prototype("ConversationSpec"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "includeEvent", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 6, name: "maxEventsPerConversation", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 7, name: "eventContinuationToken", type: .prototype("EventContinuationToken"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversationSpec":
			guard value is ConversationSpec? else { throw ProtoError.typeMismatchError }
			self.conversationSpec = value as! ConversationSpec?
		case "includeEvent":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.includeEvent = value as! Bool?
		case "maxEventsPerConversation":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxEventsPerConversation = value as! UInt64?
		case "eventContinuationToken":
			guard value is EventContinuationToken? else { throw ProtoError.typeMismatchError }
			self.eventContinuationToken = value as! EventContinuationToken?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "conversationSpec": return self.conversationSpec
		case "includeEvent": return self.includeEvent
		case "maxEventsPerConversation": return self.maxEventsPerConversation
		case "eventContinuationToken": return self.eventContinuationToken
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationSpec: ConversationSpec?
	public var includeEvent: Bool?
	public var maxEventsPerConversation: UInt64?
	public var eventContinuationToken: EventContinuationToken?
}

public struct GetConversationResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationState", type: .prototype("ConversationState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "conversationState":
			guard value is ConversationState? else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! ConversationState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "conversationState": return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var conversationState: ConversationState?
}

public struct GetEntityByIdRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "batchLookupSpec", type: .prototype("EntityLookupSpec"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "batchLookupSpec":
			guard value is [EntityLookupSpec] else { throw ProtoError.typeMismatchError }
			self.batchLookupSpec = value as! [EntityLookupSpec]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "batchLookupSpec": return self.batchLookupSpec
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var batchLookupSpec: [EntityLookupSpec]
}

public struct GetEntityByIdResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
		ProtoFieldDescriptor(id: 3, name: "entityResult", type: .prototype("EntityResult"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "entity":
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		case "entityResult":
			guard value is [EntityResult] else { throw ProtoError.typeMismatchError }
			self.entityResult = value as! [EntityResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "entity": return self.entity
		case "entityResult": return self.entityResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity]
	public var entityResult: [EntityResult]
}

public struct GetSuggestedEntitiesRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "maxCount", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 8, name: "favorites", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		ProtoFieldDescriptor(id: 9, name: "contactsYouHangoutWith", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		ProtoFieldDescriptor(id: 10, name: "otherContactsOnHangouts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		ProtoFieldDescriptor(id: 11, name: "otherContacts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		ProtoFieldDescriptor(id: 12, name: "dismissedContacts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		ProtoFieldDescriptor(id: 13, name: "pinnedFavorites", type: .prototype("SuggestedContactGroupHash"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "maxCount":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxCount = value as! UInt64?
		case "favorites":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.favorites = value as! SuggestedContactGroupHash?
		case "contactsYouHangoutWith":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.contactsYouHangoutWith = value as! SuggestedContactGroupHash?
		case "otherContactsOnHangouts":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.otherContactsOnHangouts = value as! SuggestedContactGroupHash?
		case "otherContacts":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.otherContacts = value as! SuggestedContactGroupHash?
		case "dismissedContacts":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.dismissedContacts = value as! SuggestedContactGroupHash?
		case "pinnedFavorites":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.pinnedFavorites = value as! SuggestedContactGroupHash?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "maxCount": return self.maxCount
		case "favorites": return self.favorites
		case "contactsYouHangoutWith": return self.contactsYouHangoutWith
		case "otherContactsOnHangouts": return self.otherContactsOnHangouts
		case "otherContacts": return self.otherContacts
		case "dismissedContacts": return self.dismissedContacts
		case "pinnedFavorites": return self.pinnedFavorites
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var maxCount: UInt64?
	public var favorites: SuggestedContactGroupHash?
	public var contactsYouHangoutWith: SuggestedContactGroupHash?
	public var otherContactsOnHangouts: SuggestedContactGroupHash?
	public var otherContacts: SuggestedContactGroupHash?
	public var dismissedContacts: SuggestedContactGroupHash?
	public var pinnedFavorites: SuggestedContactGroupHash?
}

public struct GetSuggestedEntitiesResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
		ProtoFieldDescriptor(id: 4, name: "favorites", type: .prototype("SuggestedContactGroup"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "contactsYouHangoutWith", type: .prototype("SuggestedContactGroup"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "otherContactsOnHangouts", type: .prototype("SuggestedContactGroup"), label: .optional),
		ProtoFieldDescriptor(id: 7, name: "otherContacts", type: .prototype("SuggestedContactGroup"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "dismissedContacts", type: .prototype("SuggestedContactGroup"), label: .optional),
		ProtoFieldDescriptor(id: 9, name: "pinnedFavorites", type: .prototype("SuggestedContactGroup"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "entity":
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		case "favorites":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.favorites = value as! SuggestedContactGroup?
		case "contactsYouHangoutWith":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.contactsYouHangoutWith = value as! SuggestedContactGroup?
		case "otherContactsOnHangouts":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.otherContactsOnHangouts = value as! SuggestedContactGroup?
		case "otherContacts":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.otherContacts = value as! SuggestedContactGroup?
		case "dismissedContacts":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.dismissedContacts = value as! SuggestedContactGroup?
		case "pinnedFavorites":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.pinnedFavorites = value as! SuggestedContactGroup?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "entity": return self.entity
		case "favorites": return self.favorites
		case "contactsYouHangoutWith": return self.contactsYouHangoutWith
		case "otherContactsOnHangouts": return self.otherContactsOnHangouts
		case "otherContacts": return self.otherContacts
		case "dismissedContacts": return self.dismissedContacts
		case "pinnedFavorites": return self.pinnedFavorites
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity]
	public var favorites: SuggestedContactGroup?
	public var contactsYouHangoutWith: SuggestedContactGroup?
	public var otherContactsOnHangouts: SuggestedContactGroup?
	public var otherContacts: SuggestedContactGroup?
	public var dismissedContacts: SuggestedContactGroup?
	public var pinnedFavorites: SuggestedContactGroup?
}

public struct GetSelfInfoRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
}

public struct GetSelfInfoResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "selfEntity", type: .prototype("Entity"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "isKnownMinor", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "dndState", type: .prototype("DoNotDisturbSetting"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "desktopOffSetting", type: .prototype("DesktopOffSetting"), label: .optional),
		ProtoFieldDescriptor(id: 7, name: "phoneData", type: .prototype("PhoneData"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "configurationBit", type: .prototype("ConfigurationBit"), label: .repeated),
		ProtoFieldDescriptor(id: 9, name: "desktopOffState", type: .prototype("DesktopOffState"), label: .optional),
		ProtoFieldDescriptor(id: 10, name: "googlePlusUser", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 11, name: "desktopSoundSetting", type: .prototype("DesktopSoundSetting"), label: .optional),
		ProtoFieldDescriptor(id: 12, name: "richPresenceState", type: .prototype("RichPresenceState"), label: .optional),
		ProtoFieldDescriptor(id: 19, name: "defaultCountry", type: .prototype("Country"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "selfEntity":
			guard value is Entity? else { throw ProtoError.typeMismatchError }
			self.selfEntity = value as! Entity?
		case "isKnownMinor":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isKnownMinor = value as! Bool?
		case "dndState":
			guard value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.dndState = value as! DoNotDisturbSetting?
		case "desktopOffSetting":
			guard value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case "phoneData":
			guard value is PhoneData? else { throw ProtoError.typeMismatchError }
			self.phoneData = value as! PhoneData?
		case "configurationBit":
			guard value is [ConfigurationBit] else { throw ProtoError.typeMismatchError }
			self.configurationBit = value as! [ConfigurationBit]
		case "desktopOffState":
			guard value is DesktopOffState? else { throw ProtoError.typeMismatchError }
			self.desktopOffState = value as! DesktopOffState?
		case "googlePlusUser":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.googlePlusUser = value as! Bool?
		case "desktopSoundSetting":
			guard value is DesktopSoundSetting? else { throw ProtoError.typeMismatchError }
			self.desktopSoundSetting = value as! DesktopSoundSetting?
		case "richPresenceState":
			guard value is RichPresenceState? else { throw ProtoError.typeMismatchError }
			self.richPresenceState = value as! RichPresenceState?
		case "defaultCountry":
			guard value is Country? else { throw ProtoError.typeMismatchError }
			self.defaultCountry = value as! Country?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "selfEntity": return self.selfEntity
		case "isKnownMinor": return self.isKnownMinor
		case "dndState": return self.dndState
		case "desktopOffSetting": return self.desktopOffSetting
		case "phoneData": return self.phoneData
		case "configurationBit": return self.configurationBit
		case "desktopOffState": return self.desktopOffState
		case "googlePlusUser": return self.googlePlusUser
		case "desktopSoundSetting": return self.desktopSoundSetting
		case "richPresenceState": return self.richPresenceState
		case "defaultCountry": return self.defaultCountry
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var selfEntity: Entity?
	public var isKnownMinor: Bool?
	public var dndState: DoNotDisturbSetting?
	public var desktopOffSetting: DesktopOffSetting?
	public var phoneData: PhoneData?
	public var configurationBit: [ConfigurationBit]
	public var desktopOffState: DesktopOffState?
	public var googlePlusUser: Bool?
	public var desktopSoundSetting: DesktopSoundSetting?
	public var richPresenceState: RichPresenceState?
	public var defaultCountry: Country?
}

public struct QueryPresenceRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "participantId", type: .prototype("ParticipantId"), label: .repeated),
		ProtoFieldDescriptor(id: 3, name: "fieldMask", type: .prototype("FieldMask"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "participantId":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantId = value as! [ParticipantId]
		case "fieldMask":
			guard value is [FieldMask] else { throw ProtoError.typeMismatchError }
			self.fieldMask = value as! [FieldMask]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "participantId": return self.participantId
		case "fieldMask": return self.fieldMask
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var participantId: [ParticipantId]
	public var fieldMask: [FieldMask]
}

public struct QueryPresenceResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "presenceResult", type: .prototype("PresenceResult"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "presenceResult":
			guard value is [PresenceResult] else { throw ProtoError.typeMismatchError }
			self.presenceResult = value as! [PresenceResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "presenceResult": return self.presenceResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var presenceResult: [PresenceResult]
}

public struct RemoveUserRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "eventRequestHeader", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "eventRequestHeader":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "eventRequestHeader": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var eventRequestHeader: EventRequestHeader?
}

public struct RemoveUserResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "createdEvent", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "createdEvent":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "createdEvent": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct RenameConversationRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "newName", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "eventRequestHeader", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "newName":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.newName = value as! String?
		case "eventRequestHeader":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "newName": return self.newName
		case "eventRequestHeader": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var newName: String?
	public var eventRequestHeader: EventRequestHeader?
}

public struct RenameConversationResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "createdEvent", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "createdEvent":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "createdEvent": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct SearchEntitiesRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "query", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "maxCount", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "query":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.query = value as! String?
		case "maxCount":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxCount = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "query": return self.query
		case "maxCount": return self.maxCount
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var query: String?
	public var maxCount: UInt64?
}

public struct SearchEntitiesResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "entity":
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "entity": return self.entity
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity]
}

public struct SendChatMessageRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "annotation", type: .prototype("EventAnnotation"), label: .repeated),
		ProtoFieldDescriptor(id: 6, name: "messageContent", type: .prototype("MessageContent"), label: .optional),
		ProtoFieldDescriptor(id: 7, name: "existingMedia", type: .prototype("ExistingMedia"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "eventRequestHeader", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "annotation":
			guard value is [EventAnnotation] else { throw ProtoError.typeMismatchError }
			self.annotation = value as! [EventAnnotation]
		case "messageContent":
			guard value is MessageContent? else { throw ProtoError.typeMismatchError }
			self.messageContent = value as! MessageContent?
		case "existingMedia":
			guard value is ExistingMedia? else { throw ProtoError.typeMismatchError }
			self.existingMedia = value as! ExistingMedia?
		case "eventRequestHeader":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "annotation": return self.annotation
		case "messageContent": return self.messageContent
		case "existingMedia": return self.existingMedia
		case "eventRequestHeader": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var annotation: [EventAnnotation]
	public var messageContent: MessageContent?
	public var existingMedia: ExistingMedia?
	public var eventRequestHeader: EventRequestHeader?
}

public struct SendChatMessageResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 6, name: "createdEvent", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "createdEvent":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "createdEvent": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct SendOffnetworkInvitationRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "inviteeAddress", type: .prototype("OffnetworkAddress"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "inviteeAddress":
			guard value is OffnetworkAddress? else { throw ProtoError.typeMismatchError }
			self.inviteeAddress = value as! OffnetworkAddress?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "inviteeAddress": return self.inviteeAddress
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var inviteeAddress: OffnetworkAddress?
}

public struct SendOffnetworkInvitationResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetActiveClientRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "isActive", type: .bool, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "fullJid", type: .string, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "timeoutSecs", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "isActive":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isActive = value as! Bool?
		case "fullJid":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.fullJid = value as! String?
		case "timeoutSecs":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "isActive": return self.isActive
		case "fullJid": return self.fullJid
		case "timeoutSecs": return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var isActive: Bool?
	public var fullJid: String?
	public var timeoutSecs: UInt64?
}

public struct SetActiveClientResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetConversationLevelRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
}

public struct SetConversationLevelResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetConversationNotificationLevelRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "level", type: .prototype("NotificationLevel"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "level":
			guard value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.level = value as! NotificationLevel?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "conversationId": return self.conversationId
		case "level": return self.level
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var level: NotificationLevel?
}

public struct SetConversationNotificationLevelResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SetFocusRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "type", type: .prototype("FocusType"), label: .optional),
		ProtoFieldDescriptor(id: 4, name: "timeoutSecs", type: .uint32, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "type":
			guard value is FocusType? else { throw ProtoError.typeMismatchError }
			self.type = value as! FocusType?
		case "timeoutSecs":
			guard value is UInt32? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt32?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "conversationId": return self.conversationId
		case "type": return self.type
		case "timeoutSecs": return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var type: FocusType?
	public var timeoutSecs: UInt32?
}

public struct SetFocusResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SetPresenceRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "presenceStateSetting", type: .prototype("PresenceStateSetting"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "dndSetting", type: .prototype("DndSetting"), label: .optional),
		ProtoFieldDescriptor(id: 5, name: "desktopOffSetting", type: .prototype("DesktopOffSetting"), label: .optional),
		ProtoFieldDescriptor(id: 8, name: "moodSetting", type: .prototype("MoodSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "presenceStateSetting":
			guard value is PresenceStateSetting? else { throw ProtoError.typeMismatchError }
			self.presenceStateSetting = value as! PresenceStateSetting?
		case "dndSetting":
			guard value is DndSetting? else { throw ProtoError.typeMismatchError }
			self.dndSetting = value as! DndSetting?
		case "desktopOffSetting":
			guard value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case "moodSetting":
			guard value is MoodSetting? else { throw ProtoError.typeMismatchError }
			self.moodSetting = value as! MoodSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "presenceStateSetting": return self.presenceStateSetting
		case "dndSetting": return self.dndSetting
		case "desktopOffSetting": return self.desktopOffSetting
		case "moodSetting": return self.moodSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var presenceStateSetting: PresenceStateSetting?
	public var dndSetting: DndSetting?
	public var desktopOffSetting: DesktopOffSetting?
	public var moodSetting: MoodSetting?
}

public struct SetPresenceResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetTypingRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "type", type: .prototype("TypingType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "type":
			guard value is TypingType? else { throw ProtoError.typeMismatchError }
			self.type = value as! TypingType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "conversationId": return self.conversationId
		case "type": return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var type: TypingType?
}

public struct SetTypingResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SyncAllNewEventsRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "lastSyncTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 8, name: "maxResponseSizeBytes", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "lastSyncTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastSyncTimestamp = value as! UInt64?
		case "maxResponseSizeBytes":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxResponseSizeBytes = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "lastSyncTimestamp": return self.lastSyncTimestamp
		case "maxResponseSizeBytes": return self.maxResponseSizeBytes
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var lastSyncTimestamp: UInt64?
	public var maxResponseSizeBytes: UInt64?
}

public struct SyncAllNewEventsResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "syncTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "conversationState", type: .prototype("ConversationState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "syncTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.syncTimestamp = value as! UInt64?
		case "conversationState":
			guard value is [ConversationState] else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! [ConversationState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "syncTimestamp": return self.syncTimestamp
		case "conversationState": return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var syncTimestamp: UInt64?
	public var conversationState: [ConversationState]
}

public struct SyncRecentConversationsRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "maxConversations", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 4, name: "maxEventsPerConversation", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 5, name: "syncFilter", type: .prototype("SyncFilter"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "maxConversations":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxConversations = value as! UInt64?
		case "maxEventsPerConversation":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxEventsPerConversation = value as! UInt64?
		case "syncFilter":
			guard value is [SyncFilter] else { throw ProtoError.typeMismatchError }
			self.syncFilter = value as! [SyncFilter]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "maxConversations": return self.maxConversations
		case "maxEventsPerConversation": return self.maxEventsPerConversation
		case "syncFilter": return self.syncFilter
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var maxConversations: UInt64?
	public var maxEventsPerConversation: UInt64?
	public var syncFilter: [SyncFilter]
}

public struct SyncRecentConversationsResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "syncTimestamp", type: .uint64, label: .optional),
		ProtoFieldDescriptor(id: 3, name: "conversationState", type: .prototype("ConversationState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "syncTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.syncTimestamp = value as! UInt64?
		case "conversationState":
			guard value is [ConversationState] else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! [ConversationState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		case "syncTimestamp": return self.syncTimestamp
		case "conversationState": return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var syncTimestamp: UInt64?
	public var conversationState: [ConversationState]
}

public struct UpdateWatermarkRequest: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "requestHeader", type: .prototype("RequestHeader"), label: .optional),
		ProtoFieldDescriptor(id: 2, name: "conversationId", type: .prototype("ConversationId"), label: .optional),
		ProtoFieldDescriptor(id: 3, name: "lastReadTimestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "requestHeader":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversationId":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "lastReadTimestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "requestHeader": return self.requestHeader
		case "conversationId": return self.conversationId
		case "lastReadTimestamp": return self.lastReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var lastReadTimestamp: UInt64?
}

public struct UpdateWatermarkResponse: ProtoMessage {

	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		ProtoFieldDescriptor(id: 1, name: "responseHeader", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "responseHeader":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "responseHeader": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public enum ActiveClientState: Int, ProtoEnum {
	case NoActive = 0
	case IsActive = 1
	case OtherActive = 2
}

public enum FocusType: Int, ProtoEnum {
	case Unknown = 0
	case Focused = 1
	case Unfocused = 2
}

public enum FocusDevice: Int, ProtoEnum {
	case Unspecified = 0
	case Desktop = 20
	case Mobile = 300
}

public enum TypingType: Int, ProtoEnum {
	case Unknown = 0
	case Started = 1
	case Paused = 2
	case Stopped = 3
}

public enum ClientPresenceStateType: Int, ProtoEnum {
	case ClientPresenceStateUnknown = 0
	case ClientPresenceStateNone = 1
	case ClientPresenceStateDesktopIdle = 30
	case ClientPresenceStateDesktopActive = 40
}

public enum NotificationLevel: Int, ProtoEnum {
	case Unknown = 0
	case Quiet = 10
	case Ring = 30
}

public enum SegmentType: Int, ProtoEnum {
	case Text = 0
	case LineBreak = 1
	case Link = 2
}

public enum ItemType: Int, ProtoEnum {
	case Thing = 0
	case PlusPhoto = 249
	case Place = 335
	case PlaceV2 = 340
}

public enum MediaType: Int, ProtoEnum {
	case Unknown = 0
	case Photo = 1
	case AnimatedPhoto = 4
}

public enum MembershipChangeType: Int, ProtoEnum {
	case Join = 1
	case Leave = 2
}

public enum HangoutEventType: Int, ProtoEnum {
	case Unknown = 0
	case Start = 1
	case End = 2
	case Join = 3
	case Leave = 4
	case ComingSoon = 5
	case Ongoing = 6
}

public enum OffTheRecordToggle: Int, ProtoEnum {
	case Unknown = 0
	case Enabled = 1
	case Disabled = 2
}

public enum OffTheRecordStatus: Int, ProtoEnum {
	case Unknown = 0
	case OffTheRecord = 1
	case OnTheRecord = 2
}

public enum SourceType: Int, ProtoEnum {
	case Unknown = 0
}

public enum EventType: Int, ProtoEnum {
	case Unknown = 0
	case RegularChatMessage = 1
	case Sms = 2
	case Voicemail = 3
	case AddUser = 4
	case RemoveUser = 5
	case ConversationRename = 6
	case Hangout = 7
	case PhoneCall = 8
	case OtrModification = 9
	case PlanMutation = 10
	case Mms = 11
	case Deprecated12 = 12
}

public enum ConversationType: Int, ProtoEnum {
	case Unknown = 0
	case OneToOne = 1
	case Group = 2
}

public enum ConversationStatus: Int, ProtoEnum {
	case Unknown = 0
	case Invited = 1
	case Active = 2
	case Left = 3
}

public enum ConversationView: Int, ProtoEnum {
	case Unknown = 0
	case Inbox = 1
	case Archived = 2
}

public enum DeliveryMediumType: Int, ProtoEnum {
	case DeliveryMediumUnknown = 0
	case DeliveryMediumBabel = 1
	case DeliveryMediumGoogleVoice = 2
	case DeliveryMediumLocalSms = 3
}

public enum InvitationAffinity: Int, ProtoEnum {
	case InviteAffinityUnknown = 0
	case InviteAffinityHigh = 1
	case InviteAffinityLow = 2
}

public enum ParticipantType: Int, ProtoEnum {
	case Unknown = 0
	case Gaia = 2
	case GoogleVoice = 3
}

public enum InvitationStatus: Int, ProtoEnum {
	case Unknown = 0
	case Pending = 1
	case Accepted = 2
}

public enum ForceHistory: Int, ProtoEnum {
	case Unknown = 0
	case No = 1
}

public enum NetworkType: Int, ProtoEnum {
	case Unknown = 0
	case Babel = 1
	case GoogleVoice = 2
}

public enum BlockState: Int, ProtoEnum {
	case Unknown = 0
	case Block = 1
	case Unblock = 2
}

public enum ReplyToInviteType: Int, ProtoEnum {
	case Unknown = 0
	case Accept = 1
	case Decline = 2
}

public enum ClientId: Int, ProtoEnum {
	case Unknown = 0
	case Android = 1
	case Ios = 2
	case Chrome = 3
	case WebGplus = 5
	case WebGmail = 6
	case Ultraviolet = 13
}

public enum ClientBuildType: Int, ProtoEnum {
	case BuildTypeUnknown = 0
	case BuildTypeProductionWeb = 1
	case BuildTypeProductionApp = 3
}

public enum ResponseStatus: Int, ProtoEnum {
	case Unknown = 0
	case Ok = 1
	case UnexpectedError = 3
	case InvalidRequest = 4
}

public enum PastHangoutState: Int, ProtoEnum {
	case Unknown = 0
	case HadPastHangout = 1
	case NoPastHangout = 2
}

public enum PhotoUrlStatus: Int, ProtoEnum {
	case Unknown = 0
	case Placeholder = 1
	case UserPhoto = 2
}

public enum Gender: Int, ProtoEnum {
	case Unknown = 0
	case Male = 1
	case Female = 2
}

public enum ProfileType: Int, ProtoEnum {
	case None = 0
	case EsUser = 1
}

public enum ConfigurationBitType: Int, ProtoEnum {
	case Unknown = 0
	case Unknown1 = 1
	case Unknown2 = 2
	case Unknown3 = 3
	case Unknown4 = 4
	case Unknown5 = 5
	case Unknown6 = 6
	case Unknown7 = 7
	case Unknown8 = 8
	case Unknown9 = 9
	case Unknown10 = 10
	case Unknown11 = 11
	case Unknown12 = 12
	case Unknown13 = 13
	case Unknown14 = 14
	case Unknown15 = 15
	case Unknown16 = 16
	case Unknown17 = 17
	case Unknown18 = 18
	case Unknown19 = 19
	case Unknown20 = 20
	case Unknown21 = 21
	case Unknown22 = 22
	case Unknown23 = 23
	case Unknown24 = 24
	case Unknown25 = 25
	case Unknown26 = 26
	case Unknown27 = 27
	case Unknown28 = 28
	case Unknown29 = 29
	case Unknown30 = 30
	case Unknown31 = 31
	case Unknown32 = 32
	case Unknown33 = 33
	case Unknown34 = 34
	case Unknown35 = 35
	case Unknown36 = 36
}

public enum RichPresenceType: Int, ProtoEnum {
	case Unknown = 0
	case InCallState = 1
	case Device = 2
	case Unknown3 = 3
	case Unknown4 = 4
	case Unknown5 = 5
	case LastSeen = 6
}

public enum FieldMask: Int, ProtoEnum {
	case Reachable = 1
	case Available = 2
	case Mood = 3
	case InCall = 6
	case Device = 7
	case LastSeen = 10
}

public enum DeleteType: Int, ProtoEnum {
	case Unknown = 0
	case UpperBound = 1
}

public enum SyncFilter: Int, ProtoEnum {
	case Unknown = 0
	case Inbox = 1
	case Archived = 2
}

public enum SoundState: Int, ProtoEnum {
	case Unknown = 0
	case On = 1
	case Off = 2
}

public enum CallerIdSettingsMask: Int, ProtoEnum {
	case Unknown = 0
	case Provided = 1
}

public enum PhoneVerificationStatus: Int, ProtoEnum {
	case Unknown = 0
	case Verified = 1
}

public enum PhoneDiscoverabilityStatus: Int, ProtoEnum {
	case Unknown = 0
	case OptedInButNotDiscoverable = 2
}

public enum PhoneValidationResult: Int, ProtoEnum {
	case IsPossible = 0
}

public enum OffnetworkAddressType: Int, ProtoEnum {
	case Unknown = 0
	case Email = 1
}

