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

public struct DoNotDisturbSetting: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "do_not_disturb", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "expiration_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "version", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "do_not_disturb":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.doNotDisturb = value as! Bool?
		case "expiration_timestamp":
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
		case "do_not_disturb": return self.doNotDisturb
		case "expiration_timestamp": return self.expirationTimestamp
		case "version": return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var doNotDisturb: Bool?
	public var expirationTimestamp: UInt64?
	public var version: UInt64?
}

public struct NotificationSettings: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "dnd_settings", type: .prototype("DoNotDisturbSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "dnd_settings":
			guard value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.dndSettings = value as! DoNotDisturbSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "dnd_settings": return self.dndSettings
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var dndSettings: DoNotDisturbSetting?
}

public struct ConversationId: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "id", type: .string, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "gaia_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "chat_id", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "gaia_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case "chat_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.chatId = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "gaia_id": return self.gaiaId
		case "chat_id": return self.chatId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var gaiaId: String?
	public var chatId: String?
}

public struct DeviceStatus: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "mobile", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "desktop", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "tablet", type: .bool, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "last_seen_timestamp_usec", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "last_seen_timestamp_usec":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastSeenTimestampUsec = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "last_seen_timestamp_usec": return self.lastSeenTimestampUsec
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var lastSeenTimestampUsec: UInt64?
}

public struct Presence: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "reachable", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "available", type: .bool, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "device_status", type: .prototype("DeviceStatus"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "mood_message", type: .prototype("MoodMessage"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "last_seen", type: .prototype("LastSeen"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "reachable":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.reachable = value as! Bool?
		case "available":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.available = value as! Bool?
		case "device_status":
			guard value is DeviceStatus? else { throw ProtoError.typeMismatchError }
			self.deviceStatus = value as! DeviceStatus?
		case "mood_message":
			guard value is MoodMessage? else { throw ProtoError.typeMismatchError }
			self.moodMessage = value as! MoodMessage?
		case "last_seen":
			guard value is LastSeen? else { throw ProtoError.typeMismatchError }
			self.lastSeen = value as! LastSeen?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "reachable": return self.reachable
		case "available": return self.available
		case "device_status": return self.deviceStatus
		case "mood_message": return self.moodMessage
		case "last_seen": return self.lastSeen
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "user_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "presence", type: .prototype("Presence"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "user_id":
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
		case "user_id": return self.userId
		case "presence": return self.presence
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var userId: ParticipantId?
	public var presence: Presence?
}

public struct ClientIdentifier: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "resource", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "header_id", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "resource":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.resource = value as! String?
		case "header_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.headerId = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "resource": return self.resource
		case "header_id": return self.headerId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var resource: String?
	public var headerId: String?
}

public struct ClientPresenceState: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "identifier", type: .prototype("ClientIdentifier"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "state", type: .prototype("ClientPresenceStateType"), label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "user_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "client_generated_id", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "notification_level", type: .prototype("NotificationLevel"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "user_id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.userId = value as! ParticipantId?
		case "client_generated_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! String?
		case "notification_level":
			guard value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.notificationLevel = value as! NotificationLevel?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "user_id": return self.userId
		case "client_generated_id": return self.clientGeneratedId
		case "notification_level": return self.notificationLevel
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var userId: ParticipantId?
	public var clientGeneratedId: String?
	public var notificationLevel: NotificationLevel?
}

public struct Formatting: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "bold", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "italic", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "strikethrough", type: .bool, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "underline", type: .bool, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "link_target", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "link_target":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.linkTarget = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "link_target": return self.linkTarget
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var linkTarget: String?
}

public struct Segment: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("SegmentType"), label: .required),
		2: ProtoFieldDescriptor(id: 2, name: "text", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "formatting", type: .prototype("Formatting"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "link_data", type: .prototype("LinkData"), label: .optional),
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
		case "link_data":
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
		case "link_data": return self.linkData
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: SegmentType!
	public var text: String?
	public var formatting: Formatting?
	public var linkData: LinkData?
}

public struct Thumbnail: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "url", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "image_url", type: .string, label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "width_px", type: .uint64, label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "height_px", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case "image_url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.imageUrl = value as! String?
		case "width_px":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.widthPx = value as! UInt64?
		case "height_px":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.heightPx = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "url": return self.url
		case "image_url": return self.imageUrl
		case "width_px": return self.widthPx
		case "height_px": return self.heightPx
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var url: String?
	public var imageUrl: String?
	public var widthPx: UInt64?
	public var heightPx: UInt64?
}

public struct PlusPhoto: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "thumbnail", type: .prototype("Thumbnail"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "owner_obfuscated_id", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "album_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "photo_id", type: .string, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "url", type: .string, label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "original_content_url", type: .string, label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "media_type", type: .prototype("MediaType"), label: .optional),
		14: ProtoFieldDescriptor(id: 14, name: "stream_id", type: .string, label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "thumbnail":
			guard value is Thumbnail? else { throw ProtoError.typeMismatchError }
			self.thumbnail = value as! Thumbnail?
		case "owner_obfuscated_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.ownerObfuscatedId = value as! String?
		case "album_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.albumId = value as! String?
		case "photo_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.photoId = value as! String?
		case "url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case "original_content_url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.originalContentUrl = value as! String?
		case "media_type":
			guard value is MediaType? else { throw ProtoError.typeMismatchError }
			self.mediaType = value as! MediaType?
		case "stream_id":
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.streamId = value as! [String]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "thumbnail": return self.thumbnail
		case "owner_obfuscated_id": return self.ownerObfuscatedId
		case "album_id": return self.albumId
		case "photo_id": return self.photoId
		case "url": return self.url
		case "original_content_url": return self.originalContentUrl
		case "media_type": return self.mediaType
		case "stream_id": return self.streamId
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
	public var streamId: [String] = []
}

public struct RepresentativeImage: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		2: ProtoFieldDescriptor(id: 2, name: "url", type: .string, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "url", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "name", type: .string, label: .optional),
		185: ProtoFieldDescriptor(id: 185, name: "representative_image", type: .prototype("RepresentativeImage"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case "name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case "representative_image":
			guard value is RepresentativeImage? else { throw ProtoError.typeMismatchError }
			self.representativeImage = value as! RepresentativeImage?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "url": return self.url
		case "name": return self.name
		case "representative_image": return self.representativeImage
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var url: String?
	public var name: String?
	public var representativeImage: RepresentativeImage?
}

public struct EmbedItem: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("ItemType"), label: .repeated),
		2: ProtoFieldDescriptor(id: 2, name: "id", type: .string, label: .optional),
		27639957: ProtoFieldDescriptor(id: 27639957, name: "plus_photo", type: .prototype("PlusPhoto"), label: .optional),
		35825640: ProtoFieldDescriptor(id: 35825640, name: "place", type: .prototype("Place"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is [ItemType] else { throw ProtoError.typeMismatchError }
			self.type = value as! [ItemType]
		case "id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.id = value as! String?
		case "plus_photo":
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
		case "plus_photo": return self.plusPhoto
		case "place": return self.place
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: [ItemType] = []
	public var id: String?
	public var plusPhoto: PlusPhoto?
	public var place: Place?
}

public struct Attachment: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "embed_item", type: .prototype("EmbedItem"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "embed_item":
			guard value is EmbedItem? else { throw ProtoError.typeMismatchError }
			self.embedItem = value as! EmbedItem?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "embed_item": return self.embedItem
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var embedItem: EmbedItem?
}

public struct MessageContent: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "segment", type: .prototype("Segment"), label: .repeated),
		2: ProtoFieldDescriptor(id: 2, name: "attachment", type: .prototype("Attachment"), label: .repeated),
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

	public var segment: [Segment] = []
	public var attachment: [Attachment] = []
}

public struct EventAnnotation: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .int32, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "value", type: .string, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		2: ProtoFieldDescriptor(id: 2, name: "annotation", type: .prototype("EventAnnotation"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "message_content", type: .prototype("MessageContent"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "annotation":
			guard value is [EventAnnotation] else { throw ProtoError.typeMismatchError }
			self.annotation = value as! [EventAnnotation]
		case "message_content":
			guard value is MessageContent? else { throw ProtoError.typeMismatchError }
			self.messageContent = value as! MessageContent?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "annotation": return self.annotation
		case "message_content": return self.messageContent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var annotation: [EventAnnotation] = []
	public var messageContent: MessageContent?
}

public struct MembershipChange: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("MembershipChangeType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "participant_ids", type: .prototype("ParticipantId"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is MembershipChangeType? else { throw ProtoError.typeMismatchError }
			self.type = value as! MembershipChangeType?
		case "participant_ids":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantIds = value as! [ParticipantId]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "participant_ids": return self.participantIds
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: MembershipChangeType?
	public var participantIds: [ParticipantId] = []
}

public struct ConversationRename: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "new_name", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "old_name", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "new_name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.newName = value as! String?
		case "old_name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.oldName = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "new_name": return self.newName
		case "old_name": return self.oldName
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var newName: String?
	public var oldName: String?
}

public struct HangoutEvent: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "event_type", type: .prototype("HangoutEventType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "participant_id", type: .prototype("ParticipantId"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "event_type":
			guard value is HangoutEventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! HangoutEventType?
		case "participant_id":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantId = value as! [ParticipantId]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "event_type": return self.eventType
		case "participant_id": return self.participantId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var eventType: HangoutEventType?
	public var participantId: [ParticipantId] = []
}

public struct OTRModification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "old_otr_status", type: .prototype("OffTheRecordStatus"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "new_otr_status", type: .prototype("OffTheRecordStatus"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "old_otr_toggle", type: .prototype("OffTheRecordToggle"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "new_otr_toggle", type: .prototype("OffTheRecordToggle"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "old_otr_status":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.oldOtrStatus = value as! OffTheRecordStatus?
		case "new_otr_status":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.newOtrStatus = value as! OffTheRecordStatus?
		case "old_otr_toggle":
			guard value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.oldOtrToggle = value as! OffTheRecordToggle?
		case "new_otr_toggle":
			guard value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.newOtrToggle = value as! OffTheRecordToggle?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "old_otr_status": return self.oldOtrStatus
		case "new_otr_status": return self.newOtrStatus
		case "old_otr_toggle": return self.oldOtrToggle
		case "new_otr_toggle": return self.newOtrToggle
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var oldOtrStatus: OffTheRecordStatus?
	public var newOtrStatus: OffTheRecordStatus?
	public var oldOtrToggle: OffTheRecordToggle?
	public var newOtrToggle: OffTheRecordToggle?
}

public struct HashModifier: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "update_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "hash_diff", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "version", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "update_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.updateId = value as! String?
		case "hash_diff":
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
		case "update_id": return self.updateId
		case "hash_diff": return self.hashDiff
		case "version": return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var updateId: String?
	public var hashDiff: UInt64?
	public var version: UInt64?
}

public struct Event: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "self_event_state", type: .prototype("UserEventState"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "source_type", type: .prototype("SourceType"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "chat_message", type: .prototype("ChatMessage"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "membership_change", type: .prototype("MembershipChange"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "conversation_rename", type: .prototype("ConversationRename"), label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "hangout_event", type: .prototype("HangoutEvent"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "event_id", type: .string, label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "expiration_timestamp", type: .uint64, label: .optional),
		14: ProtoFieldDescriptor(id: 14, name: "otr_modification", type: .prototype("OTRModification"), label: .optional),
		15: ProtoFieldDescriptor(id: 15, name: "advances_sort_timestamp", type: .bool, label: .optional),
		16: ProtoFieldDescriptor(id: 16, name: "otr_status", type: .prototype("OffTheRecordStatus"), label: .optional),
		17: ProtoFieldDescriptor(id: 17, name: "persisted", type: .bool, label: .optional),
		20: ProtoFieldDescriptor(id: 20, name: "medium_type", type: .prototype("DeliveryMedium"), label: .optional),
		23: ProtoFieldDescriptor(id: 23, name: "event_type", type: .prototype("EventType"), label: .optional),
		24: ProtoFieldDescriptor(id: 24, name: "event_version", type: .uint64, label: .optional),
		26: ProtoFieldDescriptor(id: 26, name: "hash_modifier", type: .prototype("HashModifier"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "sender_id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		case "self_event_state":
			guard value is UserEventState? else { throw ProtoError.typeMismatchError }
			self.selfEventState = value as! UserEventState?
		case "source_type":
			guard value is SourceType? else { throw ProtoError.typeMismatchError }
			self.sourceType = value as! SourceType?
		case "chat_message":
			guard value is ChatMessage? else { throw ProtoError.typeMismatchError }
			self.chatMessage = value as! ChatMessage?
		case "membership_change":
			guard value is MembershipChange? else { throw ProtoError.typeMismatchError }
			self.membershipChange = value as! MembershipChange?
		case "conversation_rename":
			guard value is ConversationRename? else { throw ProtoError.typeMismatchError }
			self.conversationRename = value as! ConversationRename?
		case "hangout_event":
			guard value is HangoutEvent? else { throw ProtoError.typeMismatchError }
			self.hangoutEvent = value as! HangoutEvent?
		case "event_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.eventId = value as! String?
		case "expiration_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.expirationTimestamp = value as! UInt64?
		case "otr_modification":
			guard value is OTRModification? else { throw ProtoError.typeMismatchError }
			self.otrModification = value as! OTRModification?
		case "advances_sort_timestamp":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.advancesSortTimestamp = value as! Bool?
		case "otr_status":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.otrStatus = value as! OffTheRecordStatus?
		case "persisted":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.persisted = value as! Bool?
		case "medium_type":
			guard value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.mediumType = value as! DeliveryMedium?
		case "event_type":
			guard value is EventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! EventType?
		case "event_version":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.eventVersion = value as! UInt64?
		case "hash_modifier":
			guard value is HashModifier? else { throw ProtoError.typeMismatchError }
			self.hashModifier = value as! HashModifier?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation_id": return self.conversationId
		case "sender_id": return self.senderId
		case "timestamp": return self.timestamp
		case "self_event_state": return self.selfEventState
		case "source_type": return self.sourceType
		case "chat_message": return self.chatMessage
		case "membership_change": return self.membershipChange
		case "conversation_rename": return self.conversationRename
		case "hangout_event": return self.hangoutEvent
		case "event_id": return self.eventId
		case "expiration_timestamp": return self.expirationTimestamp
		case "otr_modification": return self.otrModification
		case "advances_sort_timestamp": return self.advancesSortTimestamp
		case "otr_status": return self.otrStatus
		case "persisted": return self.persisted
		case "medium_type": return self.mediumType
		case "event_type": return self.eventType
		case "event_version": return self.eventVersion
		case "hash_modifier": return self.hashModifier
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "participant_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "latest_read_timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "participant_id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.participantId = value as! ParticipantId?
		case "latest_read_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.latestReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "participant_id": return self.participantId
		case "latest_read_timestamp": return self.latestReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var participantId: ParticipantId?
	public var latestReadTimestamp: UInt64?
}

public struct DeliveryMedium: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "medium_type", type: .prototype("DeliveryMediumType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "phone_number", type: .prototype("PhoneNumber"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "medium_type":
			guard value is DeliveryMediumType? else { throw ProtoError.typeMismatchError }
			self.mediumType = value as! DeliveryMediumType?
		case "phone_number":
			guard value is PhoneNumber? else { throw ProtoError.typeMismatchError }
			self.phoneNumber = value as! PhoneNumber?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "medium_type": return self.mediumType
		case "phone_number": return self.phoneNumber
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var mediumType: DeliveryMediumType?
	public var phoneNumber: PhoneNumber?
}

public struct DeliveryMediumOption: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "delivery_medium", type: .prototype("DeliveryMedium"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "current_default", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "delivery_medium":
			guard value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.deliveryMedium = value as! DeliveryMedium?
		case "current_default":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.currentDefault = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "delivery_medium": return self.deliveryMedium
		case "current_default": return self.currentDefault
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var deliveryMedium: DeliveryMedium?
	public var currentDefault: Bool?
}

public struct UserConversationState: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		2: ProtoFieldDescriptor(id: 2, name: "client_generated_id", type: .string, label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "self_read_state", type: .prototype("UserReadState"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "status", type: .prototype("ConversationStatus"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "notification_level", type: .prototype("NotificationLevel"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "view", type: .prototype("ConversationView"), label: .repeated),
		11: ProtoFieldDescriptor(id: 11, name: "inviter_id", type: .prototype("ParticipantId"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "invite_timestamp", type: .uint64, label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "sort_timestamp", type: .uint64, label: .optional),
		14: ProtoFieldDescriptor(id: 14, name: "active_timestamp", type: .uint64, label: .optional),
		15: ProtoFieldDescriptor(id: 15, name: "invite_affinity", type: .prototype("InvitationAffinity"), label: .optional),
		17: ProtoFieldDescriptor(id: 17, name: "delivery_medium_option", type: .prototype("DeliveryMediumOption"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "client_generated_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! String?
		case "self_read_state":
			guard value is UserReadState? else { throw ProtoError.typeMismatchError }
			self.selfReadState = value as! UserReadState?
		case "status":
			guard value is ConversationStatus? else { throw ProtoError.typeMismatchError }
			self.status = value as! ConversationStatus?
		case "notification_level":
			guard value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.notificationLevel = value as! NotificationLevel?
		case "view":
			guard value is [ConversationView] else { throw ProtoError.typeMismatchError }
			self.view = value as! [ConversationView]
		case "inviter_id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.inviterId = value as! ParticipantId?
		case "invite_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.inviteTimestamp = value as! UInt64?
		case "sort_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.sortTimestamp = value as! UInt64?
		case "active_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.activeTimestamp = value as! UInt64?
		case "invite_affinity":
			guard value is InvitationAffinity? else { throw ProtoError.typeMismatchError }
			self.inviteAffinity = value as! InvitationAffinity?
		case "delivery_medium_option":
			guard value is [DeliveryMediumOption] else { throw ProtoError.typeMismatchError }
			self.deliveryMediumOption = value as! [DeliveryMediumOption]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "client_generated_id": return self.clientGeneratedId
		case "self_read_state": return self.selfReadState
		case "status": return self.status
		case "notification_level": return self.notificationLevel
		case "view": return self.view
		case "inviter_id": return self.inviterId
		case "invite_timestamp": return self.inviteTimestamp
		case "sort_timestamp": return self.sortTimestamp
		case "active_timestamp": return self.activeTimestamp
		case "invite_affinity": return self.inviteAffinity
		case "delivery_medium_option": return self.deliveryMediumOption
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var clientGeneratedId: String?
	public var selfReadState: UserReadState?
	public var status: ConversationStatus?
	public var notificationLevel: NotificationLevel?
	public var view: [ConversationView] = []
	public var inviterId: ParticipantId?
	public var inviteTimestamp: UInt64?
	public var sortTimestamp: UInt64?
	public var activeTimestamp: UInt64?
	public var inviteAffinity: InvitationAffinity?
	public var deliveryMediumOption: [DeliveryMediumOption] = []
}

public struct ConversationParticipantData: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "fallback_name", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "invitation_status", type: .prototype("InvitationStatus"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "participant_type", type: .prototype("ParticipantType"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "new_invitation_status", type: .prototype("InvitationStatus"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.id = value as! ParticipantId?
		case "fallback_name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.fallbackName = value as! String?
		case "invitation_status":
			guard value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.invitationStatus = value as! InvitationStatus?
		case "participant_type":
			guard value is ParticipantType? else { throw ProtoError.typeMismatchError }
			self.participantType = value as! ParticipantType?
		case "new_invitation_status":
			guard value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.newInvitationStatus = value as! InvitationStatus?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "id": return self.id
		case "fallback_name": return self.fallbackName
		case "invitation_status": return self.invitationStatus
		case "participant_type": return self.participantType
		case "new_invitation_status": return self.newInvitationStatus
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ConversationType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "name", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "self_conversation_state", type: .prototype("UserConversationState"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "read_state", type: .prototype("UserReadState"), label: .repeated),
		9: ProtoFieldDescriptor(id: 9, name: "has_active_hangout", type: .bool, label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "otr_status", type: .prototype("OffTheRecordStatus"), label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "otr_toggle", type: .prototype("OffTheRecordToggle"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "conversation_history_supported", type: .bool, label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "current_participant", type: .prototype("ParticipantId"), label: .repeated),
		14: ProtoFieldDescriptor(id: 14, name: "participant_data", type: .prototype("ConversationParticipantData"), label: .repeated),
		18: ProtoFieldDescriptor(id: 18, name: "network_type", type: .prototype("NetworkType"), label: .repeated),
		19: ProtoFieldDescriptor(id: 19, name: "force_history_state", type: .prototype("ForceHistory"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "type":
			guard value is ConversationType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ConversationType?
		case "name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case "self_conversation_state":
			guard value is UserConversationState? else { throw ProtoError.typeMismatchError }
			self.selfConversationState = value as! UserConversationState?
		case "read_state":
			guard value is [UserReadState] else { throw ProtoError.typeMismatchError }
			self.readState = value as! [UserReadState]
		case "has_active_hangout":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.hasActiveHangout = value as! Bool?
		case "otr_status":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.otrStatus = value as! OffTheRecordStatus?
		case "otr_toggle":
			guard value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.otrToggle = value as! OffTheRecordToggle?
		case "conversation_history_supported":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.conversationHistorySupported = value as! Bool?
		case "current_participant":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.currentParticipant = value as! [ParticipantId]
		case "participant_data":
			guard value is [ConversationParticipantData] else { throw ProtoError.typeMismatchError }
			self.participantData = value as! [ConversationParticipantData]
		case "network_type":
			guard value is [NetworkType] else { throw ProtoError.typeMismatchError }
			self.networkType = value as! [NetworkType]
		case "force_history_state":
			guard value is ForceHistory? else { throw ProtoError.typeMismatchError }
			self.forceHistoryState = value as! ForceHistory?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation_id": return self.conversationId
		case "type": return self.type
		case "name": return self.name
		case "self_conversation_state": return self.selfConversationState
		case "read_state": return self.readState
		case "has_active_hangout": return self.hasActiveHangout
		case "otr_status": return self.otrStatus
		case "otr_toggle": return self.otrToggle
		case "conversation_history_supported": return self.conversationHistorySupported
		case "current_participant": return self.currentParticipant
		case "participant_data": return self.participantData
		case "network_type": return self.networkType
		case "force_history_state": return self.forceHistoryState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var type: ConversationType?
	public var name: String?
	public var selfConversationState: UserConversationState?
	public var readState: [UserReadState] = []
	public var hasActiveHangout: Bool?
	public var otrStatus: OffTheRecordStatus?
	public var otrToggle: OffTheRecordToggle?
	public var conversationHistorySupported: Bool?
	public var currentParticipant: [ParticipantId] = []
	public var participantData: [ConversationParticipantData] = []
	public var networkType: [NetworkType] = []
	public var forceHistoryState: ForceHistory?
}

public struct EasterEgg: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "message", type: .string, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "participant_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "new_block_state", type: .prototype("BlockState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "participant_id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.participantId = value as! ParticipantId?
		case "new_block_state":
			guard value is BlockState? else { throw ProtoError.typeMismatchError }
			self.newBlockState = value as! BlockState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "participant_id": return self.participantId
		case "new_block_state": return self.newBlockState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var participantId: ParticipantId?
	public var newBlockState: BlockState?
}

public struct Photo: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "photo_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_albumless_source_photo", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "user_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "is_custom_user_id", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "photo_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.photoId = value as! String?
		case "delete_albumless_source_photo":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.deleteAlbumlessSourcePhoto = value as! Bool?
		case "user_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.userId = value as! String?
		case "is_custom_user_id":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isCustomUserId = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "photo_id": return self.photoId
		case "delete_albumless_source_photo": return self.deleteAlbumlessSourcePhoto
		case "user_id": return self.userId
		case "is_custom_user_id": return self.isCustomUserId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var photoId: String?
	public var deleteAlbumlessSourcePhoto: Bool?
	public var userId: String?
	public var isCustomUserId: Bool?
}

public struct ExistingMedia: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "photo", type: .prototype("Photo"), label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "client_generated_id", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "expected_otr", type: .prototype("OffTheRecordStatus"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "delivery_medium", type: .prototype("DeliveryMedium"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "event_type", type: .prototype("EventType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "client_generated_id":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! UInt64?
		case "expected_otr":
			guard value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.expectedOtr = value as! OffTheRecordStatus?
		case "delivery_medium":
			guard value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.deliveryMedium = value as! DeliveryMedium?
		case "event_type":
			guard value is EventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! EventType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation_id": return self.conversationId
		case "client_generated_id": return self.clientGeneratedId
		case "expected_otr": return self.expectedOtr
		case "delivery_medium": return self.deliveryMedium
		case "event_type": return self.eventType
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "client_id", type: .prototype("ClientId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "build_type", type: .prototype("ClientBuildType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "major_version", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "version_timestamp", type: .uint64, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "device_os_version", type: .string, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "device_hardware", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "client_id":
			guard value is ClientId? else { throw ProtoError.typeMismatchError }
			self.clientId = value as! ClientId?
		case "build_type":
			guard value is ClientBuildType? else { throw ProtoError.typeMismatchError }
			self.buildType = value as! ClientBuildType?
		case "major_version":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.majorVersion = value as! String?
		case "version_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.versionTimestamp = value as! UInt64?
		case "device_os_version":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.deviceOsVersion = value as! String?
		case "device_hardware":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.deviceHardware = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "client_id": return self.clientId
		case "build_type": return self.buildType
		case "major_version": return self.majorVersion
		case "version_timestamp": return self.versionTimestamp
		case "device_os_version": return self.deviceOsVersion
		case "device_hardware": return self.deviceHardware
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "client_version", type: .prototype("ClientVersion"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "client_identifier", type: .prototype("ClientIdentifier"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "language_code", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "client_version":
			guard value is ClientVersion? else { throw ProtoError.typeMismatchError }
			self.clientVersion = value as! ClientVersion?
		case "client_identifier":
			guard value is ClientIdentifier? else { throw ProtoError.typeMismatchError }
			self.clientIdentifier = value as! ClientIdentifier?
		case "language_code":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.languageCode = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "client_version": return self.clientVersion
		case "client_identifier": return self.clientIdentifier
		case "language_code": return self.languageCode
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var clientVersion: ClientVersion?
	public var clientIdentifier: ClientIdentifier?
	public var languageCode: String?
}

public struct ResponseHeader: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "status", type: .prototype("ResponseStatus"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "error_description", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "debug_url", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "request_trace_id", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "current_server_time", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "status":
			guard value is ResponseStatus? else { throw ProtoError.typeMismatchError }
			self.status = value as! ResponseStatus?
		case "error_description":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.errorDescription = value as! String?
		case "debug_url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.debugUrl = value as! String?
		case "request_trace_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.requestTraceId = value as! String?
		case "current_server_time":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.currentServerTime = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "status": return self.status
		case "error_description": return self.errorDescription
		case "debug_url": return self.debugUrl
		case "request_trace_id": return self.requestTraceId
		case "current_server_time": return self.currentServerTime
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		9: ProtoFieldDescriptor(id: 9, name: "id", type: .prototype("ParticipantId"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "presence", type: .prototype("Presence"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "properties", type: .prototype("EntityProperties"), label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "entity_type", type: .prototype("ParticipantType"), label: .optional),
		16: ProtoFieldDescriptor(id: 16, name: "had_past_hangout_state", type: .prototype("PastHangoutState"), label: .optional),
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
		case "entity_type":
			guard value is ParticipantType? else { throw ProtoError.typeMismatchError }
			self.entityType = value as! ParticipantType?
		case "had_past_hangout_state":
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
		case "entity_type": return self.entityType
		case "had_past_hangout_state": return self.hadPastHangoutState
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("ProfileType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "display_name", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "first_name", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "photo_url", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "email", type: .string, label: .repeated),
		6: ProtoFieldDescriptor(id: 6, name: "phone", type: .string, label: .repeated),
		10: ProtoFieldDescriptor(id: 10, name: "in_users_domain", type: .bool, label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "gender", type: .prototype("Gender"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "photo_url_status", type: .prototype("PhotoUrlStatus"), label: .optional),
		15: ProtoFieldDescriptor(id: 15, name: "canonical_email", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "type":
			guard value is ProfileType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ProfileType?
		case "display_name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.displayName = value as! String?
		case "first_name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.firstName = value as! String?
		case "photo_url":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.photoUrl = value as! String?
		case "email":
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.email = value as! [String]
		case "phone":
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.phone = value as! [String]
		case "in_users_domain":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.inUsersDomain = value as! Bool?
		case "gender":
			guard value is Gender? else { throw ProtoError.typeMismatchError }
			self.gender = value as! Gender?
		case "photo_url_status":
			guard value is PhotoUrlStatus? else { throw ProtoError.typeMismatchError }
			self.photoUrlStatus = value as! PhotoUrlStatus?
		case "canonical_email":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.canonicalEmail = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "type": return self.type
		case "display_name": return self.displayName
		case "first_name": return self.firstName
		case "photo_url": return self.photoUrl
		case "email": return self.email
		case "phone": return self.phone
		case "in_users_domain": return self.inUsersDomain
		case "gender": return self.gender
		case "photo_url_status": return self.photoUrlStatus
		case "canonical_email": return self.canonicalEmail
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var type: ProfileType?
	public var displayName: String?
	public var firstName: String?
	public var photoUrl: String?
	public var email: [String] = []
	public var phone: [String] = []
	public var inUsersDomain: Bool?
	public var gender: Gender?
	public var photoUrlStatus: PhotoUrlStatus?
	public var canonicalEmail: String?
}

public struct ConversationState: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation", type: .prototype("Conversation"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "event", type: .prototype("Event"), label: .repeated),
		5: ProtoFieldDescriptor(id: 5, name: "event_continuation_token", type: .prototype("EventContinuationToken"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "conversation":
			guard value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case "event":
			guard value is [Event] else { throw ProtoError.typeMismatchError }
			self.event = value as! [Event]
		case "event_continuation_token":
			guard value is EventContinuationToken? else { throw ProtoError.typeMismatchError }
			self.eventContinuationToken = value as! EventContinuationToken?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation_id": return self.conversationId
		case "conversation": return self.conversation
		case "event": return self.event
		case "event_continuation_token": return self.eventContinuationToken
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var conversation: Conversation?
	public var event: [Event] = []
	public var eventContinuationToken: EventContinuationToken?
}

public struct EventContinuationToken: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "event_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "storage_continuation_token", type: .bytes, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "event_timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "event_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.eventId = value as! String?
		case "storage_continuation_token":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.storageContinuationToken = value as! String?
		case "event_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.eventTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "event_id": return self.eventId
		case "storage_continuation_token": return self.storageContinuationToken
		case "event_timestamp": return self.eventTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var eventId: String?
	public var storageContinuationToken: String?
	public var eventTimestamp: UInt64?
}

public struct EntityLookupSpec: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "gaia_id", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "email", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "phone", type: .string, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "create_offnetwork_gaia", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "gaia_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case "email":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.email = value as! String?
		case "phone":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.phone = value as! String?
		case "create_offnetwork_gaia":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.createOffnetworkGaia = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "gaia_id": return self.gaiaId
		case "email": return self.email
		case "phone": return self.phone
		case "create_offnetwork_gaia": return self.createOffnetworkGaia
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var gaiaId: String?
	public var email: String?
	public var phone: String?
	public var createOffnetworkGaia: Bool?
}

public struct ConfigurationBit: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "configuration_bit_type", type: .prototype("ConfigurationBitType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "value", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "configuration_bit_type":
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
		case "configuration_bit_type": return self.configurationBitType
		case "value": return self.value
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var configurationBitType: ConfigurationBitType?
	public var value: Bool?
}

public struct RichPresenceState: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		3: ProtoFieldDescriptor(id: 3, name: "get_rich_presence_enabled_state", type: .prototype("RichPresenceEnabledState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "get_rich_presence_enabled_state":
			guard value is [RichPresenceEnabledState] else { throw ProtoError.typeMismatchError }
			self.getRichPresenceEnabledState = value as! [RichPresenceEnabledState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "get_rich_presence_enabled_state": return self.getRichPresenceEnabledState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var getRichPresenceEnabledState: [RichPresenceEnabledState] = []
}

public struct RichPresenceEnabledState: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("RichPresenceType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "enabled", type: .bool, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "desktop_off", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktop_off":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.desktopOff = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "desktop_off": return self.desktopOff
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopOff: Bool?
}

public struct DesktopOffState: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "desktop_off", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "version", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktop_off":
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
		case "desktop_off": return self.desktopOff
		case "version": return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopOff: Bool?
	public var version: UInt64?
}

public struct DndSetting: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "do_not_disturb", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timeout_secs", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "do_not_disturb":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.doNotDisturb = value as! Bool?
		case "timeout_secs":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "do_not_disturb": return self.doNotDisturb
		case "timeout_secs": return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var doNotDisturb: Bool?
	public var timeoutSecs: UInt64?
}

public struct PresenceStateSetting: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "timeout_secs", type: .uint64, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ClientPresenceStateType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "timeout_secs":
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
		case "timeout_secs": return self.timeoutSecs
		case "type": return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var timeoutSecs: UInt64?
	public var type: ClientPresenceStateType?
}

public struct MoodMessage: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "mood_content", type: .prototype("MoodContent"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "mood_content":
			guard value is MoodContent? else { throw ProtoError.typeMismatchError }
			self.moodContent = value as! MoodContent?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "mood_content": return self.moodContent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var moodContent: MoodContent?
}

public struct MoodContent: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "segment", type: .prototype("Segment"), label: .repeated),
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

	public var segment: [Segment] = []
}

public struct MoodSetting: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "mood_message", type: .prototype("MoodMessage"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "mood_message":
			guard value is MoodMessage? else { throw ProtoError.typeMismatchError }
			self.moodMessage = value as! MoodMessage?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "mood_message": return self.moodMessage
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var moodMessage: MoodMessage?
}

public struct MoodState: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		4: ProtoFieldDescriptor(id: 4, name: "mood_setting", type: .prototype("MoodSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "mood_setting":
			guard value is MoodSetting? else { throw ProtoError.typeMismatchError }
			self.moodSetting = value as! MoodSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "mood_setting": return self.moodSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var moodSetting: MoodSetting?
}

public struct DeleteAction: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "delete_action_timestamp", type: .uint64, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_upper_bound_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "delete_type", type: .prototype("DeleteType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "delete_action_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteActionTimestamp = value as! UInt64?
		case "delete_upper_bound_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteUpperBoundTimestamp = value as! UInt64?
		case "delete_type":
			guard value is DeleteType? else { throw ProtoError.typeMismatchError }
			self.deleteType = value as! DeleteType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "delete_action_timestamp": return self.deleteActionTimestamp
		case "delete_upper_bound_timestamp": return self.deleteUpperBoundTimestamp
		case "delete_type": return self.deleteType
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var deleteActionTimestamp: UInt64?
	public var deleteUpperBoundTimestamp: UInt64?
	public var deleteType: DeleteType?
}

public struct InviteeID: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "gaia_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "fallback_name", type: .string, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "gaia_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case "fallback_name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.fallbackName = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "gaia_id": return self.gaiaId
		case "fallback_name": return self.fallbackName
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var gaiaId: String?
	public var fallbackName: String?
}

public struct Country: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "region_code", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "country_code", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "region_code":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.regionCode = value as! String?
		case "country_code":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.countryCode = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "region_code": return self.regionCode
		case "country_code": return self.countryCode
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var regionCode: String?
	public var countryCode: UInt64?
}

public struct DesktopSoundSetting: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "desktop_sound_state", type: .prototype("SoundState"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "desktop_ring_sound_state", type: .prototype("SoundState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktop_sound_state":
			guard value is SoundState? else { throw ProtoError.typeMismatchError }
			self.desktopSoundState = value as! SoundState?
		case "desktop_ring_sound_state":
			guard value is SoundState? else { throw ProtoError.typeMismatchError }
			self.desktopRingSoundState = value as! SoundState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "desktop_sound_state": return self.desktopSoundState
		case "desktop_ring_sound_state": return self.desktopRingSoundState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopSoundState: SoundState?
	public var desktopRingSoundState: SoundState?
}

public struct PhoneData: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "phone", type: .prototype("Phone"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "caller_id_settings_mask", type: .prototype("CallerIdSettingsMask"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "phone":
			guard value is [Phone] else { throw ProtoError.typeMismatchError }
			self.phone = value as! [Phone]
		case "caller_id_settings_mask":
			guard value is CallerIdSettingsMask? else { throw ProtoError.typeMismatchError }
			self.callerIdSettingsMask = value as! CallerIdSettingsMask?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "phone": return self.phone
		case "caller_id_settings_mask": return self.callerIdSettingsMask
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var phone: [Phone] = []
	public var callerIdSettingsMask: CallerIdSettingsMask?
}

public struct Phone: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "phone_number", type: .prototype("PhoneNumber"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "google_voice", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "verification_status", type: .prototype("PhoneVerificationStatus"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "discoverable", type: .bool, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "discoverability_status", type: .prototype("PhoneDiscoverabilityStatus"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "primary", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "phone_number":
			guard value is PhoneNumber? else { throw ProtoError.typeMismatchError }
			self.phoneNumber = value as! PhoneNumber?
		case "google_voice":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.googleVoice = value as! Bool?
		case "verification_status":
			guard value is PhoneVerificationStatus? else { throw ProtoError.typeMismatchError }
			self.verificationStatus = value as! PhoneVerificationStatus?
		case "discoverable":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.discoverable = value as! Bool?
		case "discoverability_status":
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
		case "phone_number": return self.phoneNumber
		case "google_voice": return self.googleVoice
		case "verification_status": return self.verificationStatus
		case "discoverable": return self.discoverable
		case "discoverability_status": return self.discoverabilityStatus
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "national_number", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "international_number", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "country_code", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "region_code", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "is_valid", type: .bool, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "validation_result", type: .prototype("PhoneValidationResult"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "national_number":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.nationalNumber = value as! String?
		case "international_number":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.internationalNumber = value as! String?
		case "country_code":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.countryCode = value as! UInt64?
		case "region_code":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.regionCode = value as! String?
		case "is_valid":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isValid = value as! Bool?
		case "validation_result":
			guard value is PhoneValidationResult? else { throw ProtoError.typeMismatchError }
			self.validationResult = value as! PhoneValidationResult?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "national_number": return self.nationalNumber
		case "international_number": return self.internationalNumber
		case "country_code": return self.countryCode
		case "region_code": return self.regionCode
		case "is_valid": return self.isValid
		case "validation_result": return self.validationResult
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "e164", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "i18n_data", type: .prototype("I18nData"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "e164":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.e164 = value as! String?
		case "i18n_data":
			guard value is I18nData? else { throw ProtoError.typeMismatchError }
			self.i18nData = value as! I18nData?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "e164": return self.e164
		case "i18n_data": return self.i18nData
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var e164: String?
	public var i18nData: I18nData?
}

public struct SuggestedContactGroupHash: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "max_results", type: .uint64, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "hash", type: .bytes, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "max_results":
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
		case "max_results": return self.maxResults
		case "hash": return self.hash
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var maxResults: UInt64?
	public var hash: String?
}

public struct SuggestedContact: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "entity", type: .prototype("Entity"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "invitation_status", type: .prototype("InvitationStatus"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "entity":
			guard value is Entity? else { throw ProtoError.typeMismatchError }
			self.entity = value as! Entity?
		case "invitation_status":
			guard value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.invitationStatus = value as! InvitationStatus?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "entity": return self.entity
		case "invitation_status": return self.invitationStatus
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var entity: Entity?
	public var invitationStatus: InvitationStatus?
}

public struct SuggestedContactGroup: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "hash_matched", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "hash", type: .bytes, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "contact", type: .prototype("SuggestedContact"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "hash_matched":
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
		case "hash_matched": return self.hashMatched
		case "hash": return self.hash
		case "contact": return self.contact
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashMatched: Bool?
	public var hash: String?
	public var contact: [SuggestedContact] = []
}

public struct StateUpdate: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "state_update_header", type: .prototype("StateUpdateHeader"), label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "conversation", type: .prototype("Conversation"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_notification", type: .prototype("ConversationNotification"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "event_notification", type: .prototype("EventNotification"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "focus_notification", type: .prototype("SetFocusNotification"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "typing_notification", type: .prototype("SetTypingNotification"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "notification_level_notification", type: .prototype("SetConversationNotificationLevelNotification"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "reply_to_invite_notification", type: .prototype("ReplyToInviteNotification"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "watermark_notification", type: .prototype("WatermarkNotification"), label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "view_modification", type: .prototype("ConversationViewModification"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "easter_egg_notification", type: .prototype("EasterEggNotification"), label: .optional),
		14: ProtoFieldDescriptor(id: 14, name: "self_presence_notification", type: .prototype("SelfPresenceNotification"), label: .optional),
		15: ProtoFieldDescriptor(id: 15, name: "delete_notification", type: .prototype("DeleteActionNotification"), label: .optional),
		16: ProtoFieldDescriptor(id: 16, name: "presence_notification", type: .prototype("PresenceNotification"), label: .optional),
		17: ProtoFieldDescriptor(id: 17, name: "block_notification", type: .prototype("BlockNotification"), label: .optional),
		19: ProtoFieldDescriptor(id: 19, name: "notification_setting_notification", type: .prototype("SetNotificationSettingNotification"), label: .optional),
		20: ProtoFieldDescriptor(id: 20, name: "rich_presence_enabled_state_notification", type: .prototype("RichPresenceEnabledStateNotification"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "state_update_header":
			guard value is StateUpdateHeader? else { throw ProtoError.typeMismatchError }
			self.stateUpdateHeader = value as! StateUpdateHeader?
		case "conversation":
			guard value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case "conversation_notification":
			guard value is ConversationNotification? else { throw ProtoError.typeMismatchError }
			self.conversationNotification = value as! ConversationNotification?
		case "event_notification":
			guard value is EventNotification? else { throw ProtoError.typeMismatchError }
			self.eventNotification = value as! EventNotification?
		case "focus_notification":
			guard value is SetFocusNotification? else { throw ProtoError.typeMismatchError }
			self.focusNotification = value as! SetFocusNotification?
		case "typing_notification":
			guard value is SetTypingNotification? else { throw ProtoError.typeMismatchError }
			self.typingNotification = value as! SetTypingNotification?
		case "notification_level_notification":
			guard value is SetConversationNotificationLevelNotification? else { throw ProtoError.typeMismatchError }
			self.notificationLevelNotification = value as! SetConversationNotificationLevelNotification?
		case "reply_to_invite_notification":
			guard value is ReplyToInviteNotification? else { throw ProtoError.typeMismatchError }
			self.replyToInviteNotification = value as! ReplyToInviteNotification?
		case "watermark_notification":
			guard value is WatermarkNotification? else { throw ProtoError.typeMismatchError }
			self.watermarkNotification = value as! WatermarkNotification?
		case "view_modification":
			guard value is ConversationViewModification? else { throw ProtoError.typeMismatchError }
			self.viewModification = value as! ConversationViewModification?
		case "easter_egg_notification":
			guard value is EasterEggNotification? else { throw ProtoError.typeMismatchError }
			self.easterEggNotification = value as! EasterEggNotification?
		case "self_presence_notification":
			guard value is SelfPresenceNotification? else { throw ProtoError.typeMismatchError }
			self.selfPresenceNotification = value as! SelfPresenceNotification?
		case "delete_notification":
			guard value is DeleteActionNotification? else { throw ProtoError.typeMismatchError }
			self.deleteNotification = value as! DeleteActionNotification?
		case "presence_notification":
			guard value is PresenceNotification? else { throw ProtoError.typeMismatchError }
			self.presenceNotification = value as! PresenceNotification?
		case "block_notification":
			guard value is BlockNotification? else { throw ProtoError.typeMismatchError }
			self.blockNotification = value as! BlockNotification?
		case "notification_setting_notification":
			guard value is SetNotificationSettingNotification? else { throw ProtoError.typeMismatchError }
			self.notificationSettingNotification = value as! SetNotificationSettingNotification?
		case "rich_presence_enabled_state_notification":
			guard value is RichPresenceEnabledStateNotification? else { throw ProtoError.typeMismatchError }
			self.richPresenceEnabledStateNotification = value as! RichPresenceEnabledStateNotification?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "state_update_header": return self.stateUpdateHeader
		case "conversation": return self.conversation
		case "conversation_notification": return self.conversationNotification
		case "event_notification": return self.eventNotification
		case "focus_notification": return self.focusNotification
		case "typing_notification": return self.typingNotification
		case "notification_level_notification": return self.notificationLevelNotification
		case "reply_to_invite_notification": return self.replyToInviteNotification
		case "watermark_notification": return self.watermarkNotification
		case "view_modification": return self.viewModification
		case "easter_egg_notification": return self.easterEggNotification
		case "self_presence_notification": return self.selfPresenceNotification
		case "delete_notification": return self.deleteNotification
		case "presence_notification": return self.presenceNotification
		case "block_notification": return self.blockNotification
		case "notification_setting_notification": return self.notificationSettingNotification
		case "rich_presence_enabled_state_notification": return self.richPresenceEnabledStateNotification
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "active_client_state", type: .prototype("ActiveClientState"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "request_trace_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "notification_settings", type: .prototype("NotificationSettings"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "current_server_time", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "active_client_state":
			guard value is ActiveClientState? else { throw ProtoError.typeMismatchError }
			self.activeClientState = value as! ActiveClientState?
		case "request_trace_id":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.requestTraceId = value as! String?
		case "notification_settings":
			guard value is NotificationSettings? else { throw ProtoError.typeMismatchError }
			self.notificationSettings = value as! NotificationSettings?
		case "current_server_time":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.currentServerTime = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "active_client_state": return self.activeClientState
		case "request_trace_id": return self.requestTraceId
		case "notification_settings": return self.notificationSettings
		case "current_server_time": return self.currentServerTime
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var activeClientState: ActiveClientState?
	public var requestTraceId: String?
	public var notificationSettings: NotificationSettings?
	public var currentServerTime: UInt64?
}

public struct BatchUpdate: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "state_update", type: .prototype("StateUpdate"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "state_update":
			guard value is [StateUpdate] else { throw ProtoError.typeMismatchError }
			self.stateUpdate = value as! [StateUpdate]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "state_update": return self.stateUpdate
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var stateUpdate: [StateUpdate] = []
}

public struct ConversationNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation", type: .prototype("Conversation"), label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "event", type: .prototype("Event"), label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "type", type: .prototype("FocusType"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "device", type: .prototype("FocusDevice"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "sender_id":
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
		case "conversation_id": return self.conversationId
		case "sender_id": return self.senderId
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "type", type: .prototype("TypingType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "sender_id":
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
		case "conversation_id": return self.conversationId
		case "sender_id": return self.senderId
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "level", type: .prototype("NotificationLevel"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
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
		case "conversation_id": return self.conversationId
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ReplyToInviteType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
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
		case "conversation_id": return self.conversationId
		case "type": return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var type: ReplyToInviteType?
}

public struct WatermarkNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "latest_read_timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "sender_id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "latest_read_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.latestReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "sender_id": return self.senderId
		case "conversation_id": return self.conversationId
		case "latest_read_timestamp": return self.latestReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var senderId: ParticipantId?
	public var conversationId: ConversationId?
	public var latestReadTimestamp: UInt64?
}

public struct ConversationViewModification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "old_view", type: .prototype("ConversationView"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "new_view", type: .prototype("ConversationView"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "old_view":
			guard value is ConversationView? else { throw ProtoError.typeMismatchError }
			self.oldView = value as! ConversationView?
		case "new_view":
			guard value is ConversationView? else { throw ProtoError.typeMismatchError }
			self.newView = value as! ConversationView?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation_id": return self.conversationId
		case "old_view": return self.oldView
		case "new_view": return self.newView
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var oldView: ConversationView?
	public var newView: ConversationView?
}

public struct EasterEggNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "easter_egg", type: .prototype("EasterEgg"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "sender_id":
			guard value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "easter_egg":
			guard value is EasterEgg? else { throw ProtoError.typeMismatchError }
			self.easterEgg = value as! EasterEgg?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "sender_id": return self.senderId
		case "conversation_id": return self.conversationId
		case "easter_egg": return self.easterEgg
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var senderId: ParticipantId?
	public var conversationId: ConversationId?
	public var easterEgg: EasterEgg?
}

public struct SelfPresenceNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "client_presence_state", type: .prototype("ClientPresenceState"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "do_not_disturb_setting", type: .prototype("DoNotDisturbSetting"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "desktop_off_setting", type: .prototype("DesktopOffSetting"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "desktop_off_state", type: .prototype("DesktopOffState"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "mood_state", type: .prototype("MoodState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "client_presence_state":
			guard value is ClientPresenceState? else { throw ProtoError.typeMismatchError }
			self.clientPresenceState = value as! ClientPresenceState?
		case "do_not_disturb_setting":
			guard value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.doNotDisturbSetting = value as! DoNotDisturbSetting?
		case "desktop_off_setting":
			guard value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case "desktop_off_state":
			guard value is DesktopOffState? else { throw ProtoError.typeMismatchError }
			self.desktopOffState = value as! DesktopOffState?
		case "mood_state":
			guard value is MoodState? else { throw ProtoError.typeMismatchError }
			self.moodState = value as! MoodState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "client_presence_state": return self.clientPresenceState
		case "do_not_disturb_setting": return self.doNotDisturbSetting
		case "desktop_off_setting": return self.desktopOffSetting
		case "desktop_off_state": return self.desktopOffState
		case "mood_state": return self.moodState
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_action", type: .prototype("DeleteAction"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "delete_action":
			guard value is DeleteAction? else { throw ProtoError.typeMismatchError }
			self.deleteAction = value as! DeleteAction?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation_id": return self.conversationId
		case "delete_action": return self.deleteAction
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
	public var deleteAction: DeleteAction?
}

public struct PresenceNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "presence", type: .prototype("PresenceResult"), label: .repeated),
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

	public var presence: [PresenceResult] = []
}

public struct BlockNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "block_state_change", type: .prototype("BlockStateChange"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "block_state_change":
			guard value is [BlockStateChange] else { throw ProtoError.typeMismatchError }
			self.blockStateChange = value as! [BlockStateChange]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "block_state_change": return self.blockStateChange
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var blockStateChange: [BlockStateChange] = []
}

public struct SetNotificationSettingNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		2: ProtoFieldDescriptor(id: 2, name: "desktop_sound_setting", type: .prototype("DesktopSoundSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "desktop_sound_setting":
			guard value is DesktopSoundSetting? else { throw ProtoError.typeMismatchError }
			self.desktopSoundSetting = value as! DesktopSoundSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "desktop_sound_setting": return self.desktopSoundSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var desktopSoundSetting: DesktopSoundSetting?
}

public struct RichPresenceEnabledStateNotification: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "rich_presence_enabled_state", type: .prototype("RichPresenceEnabledState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "rich_presence_enabled_state":
			guard value is [RichPresenceEnabledState] else { throw ProtoError.typeMismatchError }
			self.richPresenceEnabledState = value as! [RichPresenceEnabledState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "rich_presence_enabled_state": return self.richPresenceEnabledState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var richPresenceEnabledState: [RichPresenceEnabledState] = []
}

public struct ConversationSpec: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "conversation_id": return self.conversationId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var conversationId: ConversationId?
}

public struct OffnetworkAddress: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("OffnetworkAddressType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "email", type: .string, label: .optional),
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "lookup_spec", type: .prototype("EntityLookupSpec"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "lookup_spec":
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
		case "lookup_spec": return self.lookupSpec
		case "entity": return self.entity
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var lookupSpec: EntityLookupSpec?
	public var entity: [Entity] = []
}

public struct AddUserRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "invitee_id", type: .prototype("InviteeID"), label: .repeated),
		5: ProtoFieldDescriptor(id: 5, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "invitee_id":
			guard value is [InviteeID] else { throw ProtoError.typeMismatchError }
			self.inviteeId = value as! [InviteeID]
		case "event_request_header":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "invitee_id": return self.inviteeId
		case "event_request_header": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var inviteeId: [InviteeID] = []
	public var eventRequestHeader: EventRequestHeader?
}

public struct AddUserResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "created_event", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "created_event":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "created_event": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct CreateConversationRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ConversationType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "client_generated_id", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "name", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "invitee_id", type: .prototype("InviteeID"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "type":
			guard value is ConversationType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ConversationType?
		case "client_generated_id":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! UInt64?
		case "name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case "invitee_id":
			guard value is [InviteeID] else { throw ProtoError.typeMismatchError }
			self.inviteeId = value as! [InviteeID]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "type": return self.type
		case "client_generated_id": return self.clientGeneratedId
		case "name": return self.name
		case "invitee_id": return self.inviteeId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var type: ConversationType?
	public var clientGeneratedId: UInt64?
	public var name: String?
	public var inviteeId: [InviteeID] = []
}

public struct CreateConversationResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation", type: .prototype("Conversation"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "new_conversation_created", type: .bool, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "conversation":
			guard value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case "new_conversation_created":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.newConversationCreated = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "conversation": return self.conversation
		case "new_conversation_created": return self.newConversationCreated
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var conversation: Conversation?
	public var newConversationCreated: Bool?
}

public struct DeleteConversationRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "delete_upper_bound_timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "delete_upper_bound_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteUpperBoundTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "conversation_id": return self.conversationId
		case "delete_upper_bound_timestamp": return self.deleteUpperBoundTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var deleteUpperBoundTimestamp: UInt64?
}

public struct DeleteConversationResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_action", type: .prototype("DeleteAction"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "delete_action":
			guard value is DeleteAction? else { throw ProtoError.typeMismatchError }
			self.deleteAction = value as! DeleteAction?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "delete_action": return self.deleteAction
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var deleteAction: DeleteAction?
}

public struct EasterEggRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "easter_egg", type: .prototype("EasterEgg"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "easter_egg":
			guard value is EasterEgg? else { throw ProtoError.typeMismatchError }
			self.easterEgg = value as! EasterEgg?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "conversation_id": return self.conversationId
		case "easter_egg": return self.easterEgg
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var easterEgg: EasterEgg?
}

public struct EasterEggResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
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
		case "response_header": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct GetConversationRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_spec", type: .prototype("ConversationSpec"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "include_event", type: .bool, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "max_events_per_conversation", type: .uint64, label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "event_continuation_token", type: .prototype("EventContinuationToken"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversation_spec":
			guard value is ConversationSpec? else { throw ProtoError.typeMismatchError }
			self.conversationSpec = value as! ConversationSpec?
		case "include_event":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.includeEvent = value as! Bool?
		case "max_events_per_conversation":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxEventsPerConversation = value as! UInt64?
		case "event_continuation_token":
			guard value is EventContinuationToken? else { throw ProtoError.typeMismatchError }
			self.eventContinuationToken = value as! EventContinuationToken?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "conversation_spec": return self.conversationSpec
		case "include_event": return self.includeEvent
		case "max_events_per_conversation": return self.maxEventsPerConversation
		case "event_continuation_token": return self.eventContinuationToken
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_state", type: .prototype("ConversationState"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "conversation_state":
			guard value is ConversationState? else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! ConversationState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "conversation_state": return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var conversationState: ConversationState?
}

public struct GetEntityByIdRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "batch_lookup_spec", type: .prototype("EntityLookupSpec"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "batch_lookup_spec":
			guard value is [EntityLookupSpec] else { throw ProtoError.typeMismatchError }
			self.batchLookupSpec = value as! [EntityLookupSpec]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "batch_lookup_spec": return self.batchLookupSpec
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var batchLookupSpec: [EntityLookupSpec] = []
}

public struct GetEntityByIdResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "entity_result", type: .prototype("EntityResult"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "entity":
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		case "entity_result":
			guard value is [EntityResult] else { throw ProtoError.typeMismatchError }
			self.entityResult = value as! [EntityResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "entity": return self.entity
		case "entity_result": return self.entityResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity] = []
	public var entityResult: [EntityResult] = []
}

public struct GetSuggestedEntitiesRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "max_count", type: .uint64, label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "favorites", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "contacts_you_hangout_with", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "other_contacts_on_hangouts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "other_contacts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "dismissed_contacts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "pinned_favorites", type: .prototype("SuggestedContactGroupHash"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "max_count":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxCount = value as! UInt64?
		case "favorites":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.favorites = value as! SuggestedContactGroupHash?
		case "contacts_you_hangout_with":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.contactsYouHangoutWith = value as! SuggestedContactGroupHash?
		case "other_contacts_on_hangouts":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.otherContactsOnHangouts = value as! SuggestedContactGroupHash?
		case "other_contacts":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.otherContacts = value as! SuggestedContactGroupHash?
		case "dismissed_contacts":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.dismissedContacts = value as! SuggestedContactGroupHash?
		case "pinned_favorites":
			guard value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.pinnedFavorites = value as! SuggestedContactGroupHash?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "max_count": return self.maxCount
		case "favorites": return self.favorites
		case "contacts_you_hangout_with": return self.contactsYouHangoutWith
		case "other_contacts_on_hangouts": return self.otherContactsOnHangouts
		case "other_contacts": return self.otherContacts
		case "dismissed_contacts": return self.dismissedContacts
		case "pinned_favorites": return self.pinnedFavorites
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
		4: ProtoFieldDescriptor(id: 4, name: "favorites", type: .prototype("SuggestedContactGroup"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "contacts_you_hangout_with", type: .prototype("SuggestedContactGroup"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "other_contacts_on_hangouts", type: .prototype("SuggestedContactGroup"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "other_contacts", type: .prototype("SuggestedContactGroup"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "dismissed_contacts", type: .prototype("SuggestedContactGroup"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "pinned_favorites", type: .prototype("SuggestedContactGroup"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "entity":
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		case "favorites":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.favorites = value as! SuggestedContactGroup?
		case "contacts_you_hangout_with":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.contactsYouHangoutWith = value as! SuggestedContactGroup?
		case "other_contacts_on_hangouts":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.otherContactsOnHangouts = value as! SuggestedContactGroup?
		case "other_contacts":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.otherContacts = value as! SuggestedContactGroup?
		case "dismissed_contacts":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.dismissedContacts = value as! SuggestedContactGroup?
		case "pinned_favorites":
			guard value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.pinnedFavorites = value as! SuggestedContactGroup?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "entity": return self.entity
		case "favorites": return self.favorites
		case "contacts_you_hangout_with": return self.contactsYouHangoutWith
		case "other_contacts_on_hangouts": return self.otherContactsOnHangouts
		case "other_contacts": return self.otherContacts
		case "dismissed_contacts": return self.dismissedContacts
		case "pinned_favorites": return self.pinnedFavorites
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity] = []
	public var favorites: SuggestedContactGroup?
	public var contactsYouHangoutWith: SuggestedContactGroup?
	public var otherContactsOnHangouts: SuggestedContactGroup?
	public var otherContacts: SuggestedContactGroup?
	public var dismissedContacts: SuggestedContactGroup?
	public var pinnedFavorites: SuggestedContactGroup?
}

public struct GetSelfInfoRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
}

public struct GetSelfInfoResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "self_entity", type: .prototype("Entity"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "is_known_minor", type: .bool, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "dnd_state", type: .prototype("DoNotDisturbSetting"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "desktop_off_setting", type: .prototype("DesktopOffSetting"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "phone_data", type: .prototype("PhoneData"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "configuration_bit", type: .prototype("ConfigurationBit"), label: .repeated),
		9: ProtoFieldDescriptor(id: 9, name: "desktop_off_state", type: .prototype("DesktopOffState"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "google_plus_user", type: .bool, label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "desktop_sound_setting", type: .prototype("DesktopSoundSetting"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "rich_presence_state", type: .prototype("RichPresenceState"), label: .optional),
		19: ProtoFieldDescriptor(id: 19, name: "default_country", type: .prototype("Country"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "self_entity":
			guard value is Entity? else { throw ProtoError.typeMismatchError }
			self.selfEntity = value as! Entity?
		case "is_known_minor":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isKnownMinor = value as! Bool?
		case "dnd_state":
			guard value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.dndState = value as! DoNotDisturbSetting?
		case "desktop_off_setting":
			guard value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case "phone_data":
			guard value is PhoneData? else { throw ProtoError.typeMismatchError }
			self.phoneData = value as! PhoneData?
		case "configuration_bit":
			guard value is [ConfigurationBit] else { throw ProtoError.typeMismatchError }
			self.configurationBit = value as! [ConfigurationBit]
		case "desktop_off_state":
			guard value is DesktopOffState? else { throw ProtoError.typeMismatchError }
			self.desktopOffState = value as! DesktopOffState?
		case "google_plus_user":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.googlePlusUser = value as! Bool?
		case "desktop_sound_setting":
			guard value is DesktopSoundSetting? else { throw ProtoError.typeMismatchError }
			self.desktopSoundSetting = value as! DesktopSoundSetting?
		case "rich_presence_state":
			guard value is RichPresenceState? else { throw ProtoError.typeMismatchError }
			self.richPresenceState = value as! RichPresenceState?
		case "default_country":
			guard value is Country? else { throw ProtoError.typeMismatchError }
			self.defaultCountry = value as! Country?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "self_entity": return self.selfEntity
		case "is_known_minor": return self.isKnownMinor
		case "dnd_state": return self.dndState
		case "desktop_off_setting": return self.desktopOffSetting
		case "phone_data": return self.phoneData
		case "configuration_bit": return self.configurationBit
		case "desktop_off_state": return self.desktopOffState
		case "google_plus_user": return self.googlePlusUser
		case "desktop_sound_setting": return self.desktopSoundSetting
		case "rich_presence_state": return self.richPresenceState
		case "default_country": return self.defaultCountry
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var selfEntity: Entity?
	public var isKnownMinor: Bool?
	public var dndState: DoNotDisturbSetting?
	public var desktopOffSetting: DesktopOffSetting?
	public var phoneData: PhoneData?
	public var configurationBit: [ConfigurationBit] = []
	public var desktopOffState: DesktopOffState?
	public var googlePlusUser: Bool?
	public var desktopSoundSetting: DesktopSoundSetting?
	public var richPresenceState: RichPresenceState?
	public var defaultCountry: Country?
}

public struct QueryPresenceRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "participant_id", type: .prototype("ParticipantId"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "field_mask", type: .prototype("FieldMask"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "participant_id":
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantId = value as! [ParticipantId]
		case "field_mask":
			guard value is [FieldMask] else { throw ProtoError.typeMismatchError }
			self.fieldMask = value as! [FieldMask]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "participant_id": return self.participantId
		case "field_mask": return self.fieldMask
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var participantId: [ParticipantId] = []
	public var fieldMask: [FieldMask] = []
}

public struct QueryPresenceResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "presence_result", type: .prototype("PresenceResult"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "presence_result":
			guard value is [PresenceResult] else { throw ProtoError.typeMismatchError }
			self.presenceResult = value as! [PresenceResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "presence_result": return self.presenceResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var presenceResult: [PresenceResult] = []
}

public struct RemoveUserRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "event_request_header":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "event_request_header": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var eventRequestHeader: EventRequestHeader?
}

public struct RemoveUserResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "created_event", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "created_event":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "created_event": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct RenameConversationRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "new_name", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "new_name":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.newName = value as! String?
		case "event_request_header":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "new_name": return self.newName
		case "event_request_header": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var newName: String?
	public var eventRequestHeader: EventRequestHeader?
}

public struct RenameConversationResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "created_event", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "created_event":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "created_event": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct SearchEntitiesRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "query", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "max_count", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "query":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.query = value as! String?
		case "max_count":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxCount = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "query": return self.query
		case "max_count": return self.maxCount
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var query: String?
	public var maxCount: UInt64?
}

public struct SearchEntitiesResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
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
		case "response_header": return self.responseHeader
		case "entity": return self.entity
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity] = []
}

public struct SendChatMessageRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "annotation", type: .prototype("EventAnnotation"), label: .repeated),
		6: ProtoFieldDescriptor(id: 6, name: "message_content", type: .prototype("MessageContent"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "existing_media", type: .prototype("ExistingMedia"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "annotation":
			guard value is [EventAnnotation] else { throw ProtoError.typeMismatchError }
			self.annotation = value as! [EventAnnotation]
		case "message_content":
			guard value is MessageContent? else { throw ProtoError.typeMismatchError }
			self.messageContent = value as! MessageContent?
		case "existing_media":
			guard value is ExistingMedia? else { throw ProtoError.typeMismatchError }
			self.existingMedia = value as! ExistingMedia?
		case "event_request_header":
			guard value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "annotation": return self.annotation
		case "message_content": return self.messageContent
		case "existing_media": return self.existingMedia
		case "event_request_header": return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var annotation: [EventAnnotation] = []
	public var messageContent: MessageContent?
	public var existingMedia: ExistingMedia?
	public var eventRequestHeader: EventRequestHeader?
}

public struct SendChatMessageResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "created_event", type: .prototype("Event"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "created_event":
			guard value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "created_event": return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct SendOffnetworkInvitationRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "invitee_address", type: .prototype("OffnetworkAddress"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "invitee_address":
			guard value is OffnetworkAddress? else { throw ProtoError.typeMismatchError }
			self.inviteeAddress = value as! OffnetworkAddress?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "invitee_address": return self.inviteeAddress
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var inviteeAddress: OffnetworkAddress?
}

public struct SendOffnetworkInvitationResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetActiveClientRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "is_active", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "full_jid", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "timeout_secs", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "is_active":
			guard value is Bool? else { throw ProtoError.typeMismatchError }
			self.isActive = value as! Bool?
		case "full_jid":
			guard value is String? else { throw ProtoError.typeMismatchError }
			self.fullJid = value as! String?
		case "timeout_secs":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "is_active": return self.isActive
		case "full_jid": return self.fullJid
		case "timeout_secs": return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var isActive: Bool?
	public var fullJid: String?
	public var timeoutSecs: UInt64?
}

public struct SetActiveClientResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetConversationLevelRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
}

public struct SetConversationLevelResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetConversationNotificationLevelRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "level", type: .prototype("NotificationLevel"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversation_id":
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
		case "request_header": return self.requestHeader
		case "conversation_id": return self.conversationId
		case "level": return self.level
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var level: NotificationLevel?
}

public struct SetConversationNotificationLevelResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
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
		case "response_header": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SetFocusRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "type", type: .prototype("FocusType"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "timeout_secs", type: .uint32, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "type":
			guard value is FocusType? else { throw ProtoError.typeMismatchError }
			self.type = value as! FocusType?
		case "timeout_secs":
			guard value is UInt32? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt32?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "conversation_id": return self.conversationId
		case "type": return self.type
		case "timeout_secs": return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var type: FocusType?
	public var timeoutSecs: UInt32?
}

public struct SetFocusResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
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
		case "response_header": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SetPresenceRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "presence_state_setting", type: .prototype("PresenceStateSetting"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "dnd_setting", type: .prototype("DndSetting"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "desktop_off_setting", type: .prototype("DesktopOffSetting"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "mood_setting", type: .prototype("MoodSetting"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "presence_state_setting":
			guard value is PresenceStateSetting? else { throw ProtoError.typeMismatchError }
			self.presenceStateSetting = value as! PresenceStateSetting?
		case "dnd_setting":
			guard value is DndSetting? else { throw ProtoError.typeMismatchError }
			self.dndSetting = value as! DndSetting?
		case "desktop_off_setting":
			guard value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case "mood_setting":
			guard value is MoodSetting? else { throw ProtoError.typeMismatchError }
			self.moodSetting = value as! MoodSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "presence_state_setting": return self.presenceStateSetting
		case "dnd_setting": return self.dndSetting
		case "desktop_off_setting": return self.desktopOffSetting
		case "mood_setting": return self.moodSetting
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

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

public struct SetTypingRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "type", type: .prototype("TypingType"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversation_id":
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
		case "request_header": return self.requestHeader
		case "conversation_id": return self.conversationId
		case "type": return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var type: TypingType?
}

public struct SetTypingResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
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
		case "response_header": return self.responseHeader
		case "timestamp": return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SyncAllNewEventsRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "last_sync_timestamp", type: .uint64, label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "max_response_size_bytes", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "last_sync_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastSyncTimestamp = value as! UInt64?
		case "max_response_size_bytes":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxResponseSizeBytes = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "last_sync_timestamp": return self.lastSyncTimestamp
		case "max_response_size_bytes": return self.maxResponseSizeBytes
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var lastSyncTimestamp: UInt64?
	public var maxResponseSizeBytes: UInt64?
}

public struct SyncAllNewEventsResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sync_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "conversation_state", type: .prototype("ConversationState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "sync_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.syncTimestamp = value as! UInt64?
		case "conversation_state":
			guard value is [ConversationState] else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! [ConversationState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "sync_timestamp": return self.syncTimestamp
		case "conversation_state": return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var syncTimestamp: UInt64?
	public var conversationState: [ConversationState] = []
}

public struct SyncRecentConversationsRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "max_conversations", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "max_events_per_conversation", type: .uint64, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "sync_filter", type: .prototype("SyncFilter"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "max_conversations":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxConversations = value as! UInt64?
		case "max_events_per_conversation":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxEventsPerConversation = value as! UInt64?
		case "sync_filter":
			guard value is [SyncFilter] else { throw ProtoError.typeMismatchError }
			self.syncFilter = value as! [SyncFilter]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "max_conversations": return self.maxConversations
		case "max_events_per_conversation": return self.maxEventsPerConversation
		case "sync_filter": return self.syncFilter
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var maxConversations: UInt64?
	public var maxEventsPerConversation: UInt64?
	public var syncFilter: [SyncFilter] = []
}

public struct SyncRecentConversationsResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sync_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "conversation_state", type: .prototype("ConversationState"), label: .repeated),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case "sync_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.syncTimestamp = value as! UInt64?
		case "conversation_state":
			guard value is [ConversationState] else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! [ConversationState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		case "sync_timestamp": return self.syncTimestamp
		case "conversation_state": return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
	public var syncTimestamp: UInt64?
	public var conversationState: [ConversationState] = []
}

public struct UpdateWatermarkRequest: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "last_read_timestamp", type: .uint64, label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "request_header":
			guard value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case "conversation_id":
			guard value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case "last_read_timestamp":
			guard value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "request_header": return self.requestHeader
		case "conversation_id": return self.conversationId
		case "last_read_timestamp": return self.lastReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var lastReadTimestamp: UInt64?
}

public struct UpdateWatermarkResponse: ProtoMessage {

	public init() {}
	public let _unknownFields = [Int: Any]()
	public static let _protoFields = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]

	public mutating func set(name: String, value: Any?) throws {
		switch name {
		case "response_header":
			guard value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(name: String) throws -> Any? {
		switch name {
		case "response_header": return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var responseHeader: ResponseHeader?
}

