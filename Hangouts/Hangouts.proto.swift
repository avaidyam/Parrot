public struct ActiveClientState: ProtoEnumExtensor {
	public static let NoActive: ActiveClientState = 0
	public static let IsActive: ActiveClientState = 1
	public static let OtherActive: ActiveClientState = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct FocusType: ProtoEnumExtensor {
	public static let Unknown: FocusType = 0
	public static let Focused: FocusType = 1
	public static let Unfocused: FocusType = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct FocusDevice: ProtoEnumExtensor {
	public static let Unspecified: FocusDevice = 0
	public static let Desktop: FocusDevice = 20
	public static let Mobile: FocusDevice = 300

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct TypingType: ProtoEnumExtensor {
	public static let Unknown: TypingType = 0
	public static let Started: TypingType = 1
	public static let Paused: TypingType = 2
	public static let Stopped: TypingType = 3

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ClientPresenceStateType: ProtoEnumExtensor {
	public static let ClientPresenceStateUnknown: ClientPresenceStateType = 0
	public static let ClientPresenceStateNone: ClientPresenceStateType = 1
	public static let ClientPresenceStateDesktopIdle: ClientPresenceStateType = 30
	public static let ClientPresenceStateDesktopActive: ClientPresenceStateType = 40

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct NotificationLevel: ProtoEnumExtensor {
	public static let Unknown: NotificationLevel = 0
	public static let Quiet: NotificationLevel = 10
	public static let Ring: NotificationLevel = 30

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct SegmentType: ProtoEnumExtensor {
	public static let Text: SegmentType = 0
	public static let LineBreak: SegmentType = 1
	public static let Link: SegmentType = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ItemType: ProtoEnumExtensor {
	public static let Thing: ItemType = 0
	public static let PlusPhoto: ItemType = 249
	public static let Place: ItemType = 335
	public static let PlaceV2: ItemType = 340

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct MediaType: ProtoEnumExtensor {
	public static let Unknown: MediaType = 0
	public static let Photo: MediaType = 1
	public static let AnimatedPhoto: MediaType = 4

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct MembershipChangeType: ProtoEnumExtensor {
	public static let Join: MembershipChangeType = 1
	public static let Leave: MembershipChangeType = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct HangoutEventType: ProtoEnumExtensor {
	public static let Unknown: HangoutEventType = 0
	public static let Start: HangoutEventType = 1
	public static let End: HangoutEventType = 2
	public static let Join: HangoutEventType = 3
	public static let Leave: HangoutEventType = 4
	public static let ComingSoon: HangoutEventType = 5
	public static let Ongoing: HangoutEventType = 6

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct OffTheRecordToggle: ProtoEnumExtensor {
	public static let Unknown: OffTheRecordToggle = 0
	public static let Enabled: OffTheRecordToggle = 1
	public static let Disabled: OffTheRecordToggle = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct OffTheRecordStatus: ProtoEnumExtensor {
	public static let Unknown: OffTheRecordStatus = 0
	public static let OffTheRecord: OffTheRecordStatus = 1
	public static let OnTheRecord: OffTheRecordStatus = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct SourceType: ProtoEnumExtensor {
	public static let Unknown: SourceType = 0

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct EventType: ProtoEnumExtensor {
	public static let Unknown: EventType = 0
	public static let RegularChatMessage: EventType = 1
	public static let Sms: EventType = 2
	public static let Voicemail: EventType = 3
	public static let AddUser: EventType = 4
	public static let RemoveUser: EventType = 5
	public static let ConversationRename: EventType = 6
	public static let Hangout: EventType = 7
	public static let PhoneCall: EventType = 8
	public static let OtrModification: EventType = 9
	public static let PlanMutation: EventType = 10
	public static let Mms: EventType = 11
	public static let Deprecated12: EventType = 12

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ConversationType: ProtoEnumExtensor {
	public static let Unknown: ConversationType = 0
	public static let OneToOne: ConversationType = 1
	public static let Group: ConversationType = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ConversationStatus: ProtoEnumExtensor {
	public static let Unknown: ConversationStatus = 0
	public static let Invited: ConversationStatus = 1
	public static let Active: ConversationStatus = 2
	public static let Left: ConversationStatus = 3

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ConversationView: ProtoEnumExtensor {
	public static let Unknown: ConversationView = 0
	public static let Inbox: ConversationView = 1
	public static let Archived: ConversationView = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct DeliveryMediumType: ProtoEnumExtensor {
	public static let DeliveryMediumUnknown: DeliveryMediumType = 0
	public static let DeliveryMediumBabel: DeliveryMediumType = 1
	public static let DeliveryMediumGoogleVoice: DeliveryMediumType = 2
	public static let DeliveryMediumLocalSms: DeliveryMediumType = 3

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct InvitationAffinity: ProtoEnumExtensor {
	public static let InviteAffinityUnknown: InvitationAffinity = 0
	public static let InviteAffinityHigh: InvitationAffinity = 1
	public static let InviteAffinityLow: InvitationAffinity = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ParticipantType: ProtoEnumExtensor {
	public static let Unknown: ParticipantType = 0
	public static let Gaia: ParticipantType = 2
	public static let GoogleVoice: ParticipantType = 3

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct InvitationStatus: ProtoEnumExtensor {
	public static let Unknown: InvitationStatus = 0
	public static let Pending: InvitationStatus = 1
	public static let Accepted: InvitationStatus = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ForceHistory: ProtoEnumExtensor {
	public static let Unknown: ForceHistory = 0
	public static let No: ForceHistory = 1

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct NetworkType: ProtoEnumExtensor {
	public static let Unknown: NetworkType = 0
	public static let Babel: NetworkType = 1
	public static let GoogleVoice: NetworkType = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct BlockState: ProtoEnumExtensor {
	public static let Unknown: BlockState = 0
	public static let Block: BlockState = 1
	public static let Unblock: BlockState = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ReplyToInviteType: ProtoEnumExtensor {
	public static let Unknown: ReplyToInviteType = 0
	public static let Accept: ReplyToInviteType = 1
	public static let Decline: ReplyToInviteType = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ClientId: ProtoEnumExtensor {
	public static let Unknown: ClientId = 0
	public static let Android: ClientId = 1
	public static let Ios: ClientId = 2
	public static let Chrome: ClientId = 3
	public static let WebGplus: ClientId = 5
	public static let WebGmail: ClientId = 6
	public static let Ultraviolet: ClientId = 13

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ClientBuildType: ProtoEnumExtensor {
	public static let BuildTypeUnknown: ClientBuildType = 0
	public static let BuildTypeProductionWeb: ClientBuildType = 1
	public static let BuildTypeProductionApp: ClientBuildType = 3

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ResponseStatus: ProtoEnumExtensor {
	public static let Unknown: ResponseStatus = 0
	public static let Ok: ResponseStatus = 1
	public static let UnexpectedError: ResponseStatus = 3
	public static let InvalidRequest: ResponseStatus = 4

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct PastHangoutState: ProtoEnumExtensor {
	public static let Unknown: PastHangoutState = 0
	public static let HadPastHangout: PastHangoutState = 1
	public static let NoPastHangout: PastHangoutState = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct PhotoUrlStatus: ProtoEnumExtensor {
	public static let Unknown: PhotoUrlStatus = 0
	public static let Placeholder: PhotoUrlStatus = 1
	public static let UserPhoto: PhotoUrlStatus = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct Gender: ProtoEnumExtensor {
	public static let Unknown: Gender = 0
	public static let Male: Gender = 1
	public static let Female: Gender = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ProfileType: ProtoEnumExtensor {
	public static let None: ProfileType = 0
	public static let EsUser: ProfileType = 1

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct ConfigurationBitType: ProtoEnumExtensor {
	public static let Unknown: ConfigurationBitType = 0
	public static let Unknown1: ConfigurationBitType = 1
	public static let Unknown2: ConfigurationBitType = 2
	public static let Unknown3: ConfigurationBitType = 3
	public static let Unknown4: ConfigurationBitType = 4
	public static let Unknown5: ConfigurationBitType = 5
	public static let Unknown6: ConfigurationBitType = 6
	public static let Unknown7: ConfigurationBitType = 7
	public static let Unknown8: ConfigurationBitType = 8
	public static let Unknown9: ConfigurationBitType = 9
	public static let Unknown10: ConfigurationBitType = 10
	public static let Unknown11: ConfigurationBitType = 11
	public static let Unknown12: ConfigurationBitType = 12
	public static let Unknown13: ConfigurationBitType = 13
	public static let Unknown14: ConfigurationBitType = 14
	public static let Unknown15: ConfigurationBitType = 15
	public static let Unknown16: ConfigurationBitType = 16
	public static let Unknown17: ConfigurationBitType = 17
	public static let Unknown18: ConfigurationBitType = 18
	public static let Unknown19: ConfigurationBitType = 19
	public static let Unknown20: ConfigurationBitType = 20
	public static let Unknown21: ConfigurationBitType = 21
	public static let Unknown22: ConfigurationBitType = 22
	public static let Unknown23: ConfigurationBitType = 23
	public static let Unknown24: ConfigurationBitType = 24
	public static let Unknown25: ConfigurationBitType = 25
	public static let Unknown26: ConfigurationBitType = 26
	public static let Unknown27: ConfigurationBitType = 27
	public static let Unknown28: ConfigurationBitType = 28
	public static let Unknown29: ConfigurationBitType = 29
	public static let Unknown30: ConfigurationBitType = 30
	public static let Unknown31: ConfigurationBitType = 31
	public static let Unknown32: ConfigurationBitType = 32
	public static let Unknown33: ConfigurationBitType = 33
	public static let Unknown34: ConfigurationBitType = 34
	public static let Unknown35: ConfigurationBitType = 35
	public static let Unknown36: ConfigurationBitType = 36

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct RichPresenceType: ProtoEnumExtensor {
	public static let Unknown: RichPresenceType = 0
	public static let InCallState: RichPresenceType = 1
	public static let Device: RichPresenceType = 2
	public static let Unknown3: RichPresenceType = 3
	public static let Unknown4: RichPresenceType = 4
	public static let Unknown5: RichPresenceType = 5
	public static let LastSeen: RichPresenceType = 6

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct FieldMask: ProtoEnumExtensor {
	public static let Reachable: FieldMask = 1
	public static let Available: FieldMask = 2
	public static let Mood: FieldMask = 3
	public static let InCall: FieldMask = 6
	public static let Device: FieldMask = 7
	public static let LastSeen: FieldMask = 10

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct DeleteType: ProtoEnumExtensor {
	public static let Unknown: DeleteType = 0
	public static let UpperBound: DeleteType = 1

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct SyncFilter: ProtoEnumExtensor {
	public static let Unknown: SyncFilter = 0
	public static let Inbox: SyncFilter = 1
	public static let Archived: SyncFilter = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct SoundState: ProtoEnumExtensor {
	public static let Unknown: SoundState = 0
	public static let On: SoundState = 1
	public static let Off: SoundState = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct CallerIdSettingsMask: ProtoEnumExtensor {
	public static let Unknown: CallerIdSettingsMask = 0
	public static let Provided: CallerIdSettingsMask = 1

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct PhoneVerificationStatus: ProtoEnumExtensor {
	public static let Unknown: PhoneVerificationStatus = 0
	public static let Verified: PhoneVerificationStatus = 1

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct PhoneDiscoverabilityStatus: ProtoEnumExtensor {
	public static let Unknown: PhoneDiscoverabilityStatus = 0
	public static let OptedInButNotDiscoverable: PhoneDiscoverabilityStatus = 2

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct PhoneValidationResult: ProtoEnumExtensor {
	public static let IsPossible: PhoneValidationResult = 0

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct OffnetworkAddressType: ProtoEnumExtensor {
	public static let Unknown: OffnetworkAddressType = 0
	public static let Email: OffnetworkAddressType = 1

	public let rawValue: Int
	public init(_ rawValue: Int) {
		self.rawValue = rawValue
	}
}

public struct DoNotDisturbSetting: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "do_not_disturb", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "expiration_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "version", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DoNotDisturbSetting.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.doNotDisturb = value as! Bool?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.expirationTimestamp = value as! UInt64?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.version = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.doNotDisturb
		case 2: return self.expirationTimestamp
		case 3: return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.doNotDisturb._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.expirationTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.version._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var doNotDisturb: Bool?
	public var expirationTimestamp: UInt64?
	public var version: UInt64?
}

public struct NotificationSettings: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "dnd_settings", type: .prototype("DoNotDisturbSetting"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return NotificationSettings.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.dndSettings = value as! DoNotDisturbSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.dndSettings
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.dndSettings._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var dndSettings: DoNotDisturbSetting?
}

public struct ConversationId: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "id", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConversationId.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.id = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.id
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.id._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var id: String?
}

public struct ParticipantId: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "gaia_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "chat_id", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ParticipantId.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.chatId = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.gaiaId
		case 2: return self.chatId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.gaiaId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.chatId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var gaiaId: String?
	public var chatId: String?
}

public struct DeviceStatus: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "mobile", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "desktop", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "tablet", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DeviceStatus.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.mobile = value as! Bool?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.desktop = value as! Bool?
		case 3:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.tablet = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.mobile
		case 2: return self.desktop
		case 3: return self.tablet
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.mobile._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.desktop._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.tablet._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var mobile: Bool?
	public var desktop: Bool?
	public var tablet: Bool?
}

public struct LastSeen: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "last_seen_timestamp_usec", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return LastSeen.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastSeenTimestampUsec = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.lastSeenTimestampUsec
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.lastSeenTimestampUsec._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var lastSeenTimestampUsec: UInt64?
}

public struct Presence: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "reachable", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "available", type: .bool, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "device_status", type: .prototype("DeviceStatus"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "mood_message", type: .prototype("MoodMessage"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "last_seen", type: .prototype("LastSeen"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Presence.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.reachable = value as! Bool?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.available = value as! Bool?
		case 6:
			guard value == nil || value is DeviceStatus? else { throw ProtoError.typeMismatchError }
			self.deviceStatus = value as! DeviceStatus?
		case 9:
			guard value == nil || value is MoodMessage? else { throw ProtoError.typeMismatchError }
			self.moodMessage = value as! MoodMessage?
		case 10:
			guard value == nil || value is LastSeen? else { throw ProtoError.typeMismatchError }
			self.lastSeen = value as! LastSeen?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.reachable
		case 2: return self.available
		case 6: return self.deviceStatus
		case 9: return self.moodMessage
		case 10: return self.lastSeen
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.reachable._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.available._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deviceStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.moodMessage._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.lastSeen._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var reachable: Bool?
	public var available: Bool?
	public var deviceStatus: DeviceStatus?
	public var moodMessage: MoodMessage?
	public var lastSeen: LastSeen?
}

public struct PresenceResult: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "user_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "presence", type: .prototype("Presence"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return PresenceResult.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.userId = value as! ParticipantId?
		case 2:
			guard value == nil || value is Presence? else { throw ProtoError.typeMismatchError }
			self.presence = value as! Presence?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.userId
		case 2: return self.presence
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.userId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.presence._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var userId: ParticipantId?
	public var presence: Presence?
}

public struct ClientIdentifier: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "resource", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "header_id", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ClientIdentifier.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.resource = value as! String?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.headerId = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.resource
		case 2: return self.headerId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.resource._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.headerId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var resource: String?
	public var headerId: String?
}

public struct ClientPresenceState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "identifier", type: .prototype("ClientIdentifier"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "state", type: .prototype("ClientPresenceStateType"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ClientPresenceState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ClientIdentifier? else { throw ProtoError.typeMismatchError }
			self.identifier = value as! ClientIdentifier?
		case 2:
			guard value == nil || value is ClientPresenceStateType? else { throw ProtoError.typeMismatchError }
			self.state = value as! ClientPresenceStateType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.identifier
		case 2: return self.state
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.identifier._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.state._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var identifier: ClientIdentifier?
	public var state: ClientPresenceStateType?
}

public struct UserEventState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "user_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "client_generated_id", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "notification_level", type: .prototype("NotificationLevel"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return UserEventState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.userId = value as! ParticipantId?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! String?
		case 3:
			guard value == nil || value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.notificationLevel = value as! NotificationLevel?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.userId
		case 2: return self.clientGeneratedId
		case 3: return self.notificationLevel
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.userId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.clientGeneratedId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.notificationLevel._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var userId: ParticipantId?
	public var clientGeneratedId: String?
	public var notificationLevel: NotificationLevel?
}

public struct Formatting: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "bold", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "italic", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "strikethrough", type: .bool, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "underline", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Formatting.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.bold = value as! Bool?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.italic = value as! Bool?
		case 3:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.strikethrough = value as! Bool?
		case 4:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.underline = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.bold
		case 2: return self.italic
		case 3: return self.strikethrough
		case 4: return self.underline
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.bold._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.italic._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.strikethrough._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.underline._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var bold: Bool?
	public var italic: Bool?
	public var strikethrough: Bool?
	public var underline: Bool?
}

public struct LinkData: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "link_target", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return LinkData.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.linkTarget = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.linkTarget
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.linkTarget._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var linkTarget: String?
}

public struct Segment: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("SegmentType"), label: .required),
		2: ProtoFieldDescriptor(id: 2, name: "text", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "formatting", type: .prototype("Formatting"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "link_data", type: .prototype("LinkData"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Segment.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is SegmentType else { throw ProtoError.typeMismatchError }
			self.type = value as! SegmentType
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.text = value as! String?
		case 3:
			guard value == nil || value is Formatting? else { throw ProtoError.typeMismatchError }
			self.formatting = value as! Formatting?
		case 4:
			guard value == nil || value is LinkData? else { throw ProtoError.typeMismatchError }
			self.linkData = value as! LinkData?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.type
		case 2: return self.text
		case 3: return self.formatting
		case 4: return self.linkData
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		hash = (hash &* 31) &+ self.type.hashValue
		self.text._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.formatting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.linkData._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var type: SegmentType!
	public var text: String?
	public var formatting: Formatting?
	public var linkData: LinkData?
}

public struct Thumbnail: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "url", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "image_url", type: .string, label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "width_px", type: .uint64, label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "height_px", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Thumbnail.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.imageUrl = value as! String?
		case 10:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.widthPx = value as! UInt64?
		case 11:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.heightPx = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.url
		case 4: return self.imageUrl
		case 10: return self.widthPx
		case 11: return self.heightPx
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.url._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.imageUrl._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.widthPx._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.heightPx._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var url: String?
	public var imageUrl: String?
	public var widthPx: UInt64?
	public var heightPx: UInt64?
}

public struct PlusPhoto: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "thumbnail", type: .prototype("Thumbnail"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "owner_obfuscated_id", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "album_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "photo_id", type: .string, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "url", type: .string, label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "original_content_url", type: .string, label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "media_type", type: .prototype("MediaType"), label: .optional),
		14: ProtoFieldDescriptor(id: 14, name: "stream_id", type: .string, label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return PlusPhoto.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Thumbnail? else { throw ProtoError.typeMismatchError }
			self.thumbnail = value as! Thumbnail?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.ownerObfuscatedId = value as! String?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.albumId = value as! String?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.photoId = value as! String?
		case 6:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case 10:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.originalContentUrl = value as! String?
		case 13:
			guard value == nil || value is MediaType? else { throw ProtoError.typeMismatchError }
			self.mediaType = value as! MediaType?
		case 14:
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.streamId = value as! [String]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 14:
			if value is [String] {
				self.streamId.insert(contentsOf: value as! [String], at: index > 0 ? index : self.streamId.endIndex)
			} else if value is String {
				self.streamId.insert(value as! String, at: index > 0 ? index : self.streamId.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.thumbnail
		case 2: return self.ownerObfuscatedId
		case 3: return self.albumId
		case 4: return self.photoId
		case 6: return self.url
		case 10: return self.originalContentUrl
		case 13: return self.mediaType
		case 14: return self.streamId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 14:
			guard index > 0 && index < self.streamId.endIndex else { throw ProtoError.unknownError }
			return self.streamId[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.thumbnail._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.ownerObfuscatedId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.albumId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.photoId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.url._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.originalContentUrl._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.mediaType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.streamId.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct RepresentativeImage: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		2: ProtoFieldDescriptor(id: 2, name: "url", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RepresentativeImage.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 2: return self.url
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.url._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var url: String?
}

public struct Place: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "url", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "name", type: .string, label: .optional),
		185: ProtoFieldDescriptor(id: 185, name: "representative_image", type: .prototype("RepresentativeImage"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Place.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.url = value as! String?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case 185:
			guard value == nil || value is RepresentativeImage? else { throw ProtoError.typeMismatchError }
			self.representativeImage = value as! RepresentativeImage?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.url
		case 3: return self.name
		case 185: return self.representativeImage
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.url._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.name._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.representativeImage._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var url: String?
	public var name: String?
	public var representativeImage: RepresentativeImage?
}

public struct EmbedItem: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("ItemType"), label: .repeated),
		2: ProtoFieldDescriptor(id: 2, name: "id", type: .string, label: .optional),
		27639957: ProtoFieldDescriptor(id: 27639957, name: "plus_photo", type: .prototype("PlusPhoto"), label: .optional),
		35825640: ProtoFieldDescriptor(id: 35825640, name: "place", type: .prototype("Place"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EmbedItem.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [ItemType] else { throw ProtoError.typeMismatchError }
			self.type = value as! [ItemType]
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.id = value as! String?
		case 27639957:
			guard value == nil || value is PlusPhoto? else { throw ProtoError.typeMismatchError }
			self.plusPhoto = value as! PlusPhoto?
		case 35825640:
			guard value == nil || value is Place? else { throw ProtoError.typeMismatchError }
			self.place = value as! Place?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [ItemType] {
				self.type.insert(contentsOf: value as! [ItemType], at: index > 0 ? index : self.type.endIndex)
			} else if value is ItemType {
				self.type.insert(value as! ItemType, at: index > 0 ? index : self.type.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.type
		case 2: return self.id
		case 27639957: return self.plusPhoto
		case 35825640: return self.place
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.type.endIndex else { throw ProtoError.unknownError }
			return self.type[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.type.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.id._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.plusPhoto._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.place._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var type: [ItemType] = []
	public var id: String?
	public var plusPhoto: PlusPhoto?
	public var place: Place?
}

public struct Attachment: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "embed_item", type: .prototype("EmbedItem"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Attachment.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is EmbedItem? else { throw ProtoError.typeMismatchError }
			self.embedItem = value as! EmbedItem?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.embedItem
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.embedItem._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var embedItem: EmbedItem?
}

public struct MessageContent: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "segment", type: .prototype("Segment"), label: .repeated),
		2: ProtoFieldDescriptor(id: 2, name: "attachment", type: .prototype("Attachment"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return MessageContent.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [Segment] else { throw ProtoError.typeMismatchError }
			self.segment = value as! [Segment]
		case 2:
			guard value is [Attachment] else { throw ProtoError.typeMismatchError }
			self.attachment = value as! [Attachment]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [Segment] {
				self.segment.insert(contentsOf: value as! [Segment], at: index > 0 ? index : self.segment.endIndex)
			} else if value is Segment {
				self.segment.insert(value as! Segment, at: index > 0 ? index : self.segment.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 2:
			if value is [Attachment] {
				self.attachment.insert(contentsOf: value as! [Attachment], at: index > 0 ? index : self.attachment.endIndex)
			} else if value is Attachment {
				self.attachment.insert(value as! Attachment, at: index > 0 ? index : self.attachment.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.segment
		case 2: return self.attachment
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.segment.endIndex else { throw ProtoError.unknownError }
			return self.segment[index]
		case 2:
			guard index > 0 && index < self.attachment.endIndex else { throw ProtoError.unknownError }
			return self.attachment[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.segment.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.attachment.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var segment: [Segment] = []
	public var attachment: [Attachment] = []
}

public struct EventAnnotation: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .int32, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "value", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EventAnnotation.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Int32? else { throw ProtoError.typeMismatchError }
			self.type = value as! Int32?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.value = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.type
		case 2: return self.value
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.value._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var type: Int32?
	public var value: String?
}

public struct ChatMessage: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		2: ProtoFieldDescriptor(id: 2, name: "annotation", type: .prototype("EventAnnotation"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "message_content", type: .prototype("MessageContent"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ChatMessage.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 2:
			guard value is [EventAnnotation] else { throw ProtoError.typeMismatchError }
			self.annotation = value as! [EventAnnotation]
		case 3:
			guard value == nil || value is MessageContent? else { throw ProtoError.typeMismatchError }
			self.messageContent = value as! MessageContent?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [EventAnnotation] {
				self.annotation.insert(contentsOf: value as! [EventAnnotation], at: index > 0 ? index : self.annotation.endIndex)
			} else if value is EventAnnotation {
				self.annotation.insert(value as! EventAnnotation, at: index > 0 ? index : self.annotation.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 2: return self.annotation
		case 3: return self.messageContent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.annotation.endIndex else { throw ProtoError.unknownError }
			return self.annotation[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.annotation.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.messageContent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var annotation: [EventAnnotation] = []
	public var messageContent: MessageContent?
}

public struct MembershipChange: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("MembershipChangeType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "participant_ids", type: .prototype("ParticipantId"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return MembershipChange.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is MembershipChangeType? else { throw ProtoError.typeMismatchError }
			self.type = value as! MembershipChangeType?
		case 3:
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantIds = value as! [ParticipantId]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [ParticipantId] {
				self.participantIds.insert(contentsOf: value as! [ParticipantId], at: index > 0 ? index : self.participantIds.endIndex)
			} else if value is ParticipantId {
				self.participantIds.insert(value as! ParticipantId, at: index > 0 ? index : self.participantIds.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.type
		case 3: return self.participantIds
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.participantIds.endIndex else { throw ProtoError.unknownError }
			return self.participantIds[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.participantIds.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var type: MembershipChangeType?
	public var participantIds: [ParticipantId] = []
}

public struct ConversationRename: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "new_name", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "old_name", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConversationRename.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.newName = value as! String?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.oldName = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.newName
		case 2: return self.oldName
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.newName._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.oldName._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var newName: String?
	public var oldName: String?
}

public struct HangoutEvent: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "event_type", type: .prototype("HangoutEventType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "participant_id", type: .prototype("ParticipantId"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return HangoutEvent.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is HangoutEventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! HangoutEventType?
		case 2:
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantId = value as! [ParticipantId]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [ParticipantId] {
				self.participantId.insert(contentsOf: value as! [ParticipantId], at: index > 0 ? index : self.participantId.endIndex)
			} else if value is ParticipantId {
				self.participantId.insert(value as! ParticipantId, at: index > 0 ? index : self.participantId.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.eventType
		case 2: return self.participantId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.participantId.endIndex else { throw ProtoError.unknownError }
			return self.participantId[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.eventType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.participantId.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var eventType: HangoutEventType?
	public var participantId: [ParticipantId] = []
}

public struct OTRModification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "old_otr_status", type: .prototype("OffTheRecordStatus"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "new_otr_status", type: .prototype("OffTheRecordStatus"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "old_otr_toggle", type: .prototype("OffTheRecordToggle"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "new_otr_toggle", type: .prototype("OffTheRecordToggle"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return OTRModification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.oldOtrStatus = value as! OffTheRecordStatus?
		case 2:
			guard value == nil || value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.newOtrStatus = value as! OffTheRecordStatus?
		case 3:
			guard value == nil || value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.oldOtrToggle = value as! OffTheRecordToggle?
		case 4:
			guard value == nil || value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.newOtrToggle = value as! OffTheRecordToggle?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.oldOtrStatus
		case 2: return self.newOtrStatus
		case 3: return self.oldOtrToggle
		case 4: return self.newOtrToggle
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.oldOtrStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.newOtrStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.oldOtrToggle._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.newOtrToggle._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var oldOtrStatus: OffTheRecordStatus?
	public var newOtrStatus: OffTheRecordStatus?
	public var oldOtrToggle: OffTheRecordToggle?
	public var newOtrToggle: OffTheRecordToggle?
}

public struct HashModifier: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "update_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "hash_diff", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "version", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return HashModifier.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.updateId = value as! String?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.hashDiff = value as! UInt64?
		case 4:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.version = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.updateId
		case 2: return self.hashDiff
		case 4: return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.updateId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.hashDiff._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.version._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var updateId: String?
	public var hashDiff: UInt64?
	public var version: UInt64?
}

public struct Event: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
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
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Event.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		case 4:
			guard value == nil || value is UserEventState? else { throw ProtoError.typeMismatchError }
			self.selfEventState = value as! UserEventState?
		case 6:
			guard value == nil || value is SourceType? else { throw ProtoError.typeMismatchError }
			self.sourceType = value as! SourceType?
		case 7:
			guard value == nil || value is ChatMessage? else { throw ProtoError.typeMismatchError }
			self.chatMessage = value as! ChatMessage?
		case 9:
			guard value == nil || value is MembershipChange? else { throw ProtoError.typeMismatchError }
			self.membershipChange = value as! MembershipChange?
		case 10:
			guard value == nil || value is ConversationRename? else { throw ProtoError.typeMismatchError }
			self.conversationRename = value as! ConversationRename?
		case 11:
			guard value == nil || value is HangoutEvent? else { throw ProtoError.typeMismatchError }
			self.hangoutEvent = value as! HangoutEvent?
		case 12:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.eventId = value as! String?
		case 13:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.expirationTimestamp = value as! UInt64?
		case 14:
			guard value == nil || value is OTRModification? else { throw ProtoError.typeMismatchError }
			self.otrModification = value as! OTRModification?
		case 15:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.advancesSortTimestamp = value as! Bool?
		case 16:
			guard value == nil || value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.otrStatus = value as! OffTheRecordStatus?
		case 17:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.persisted = value as! Bool?
		case 20:
			guard value == nil || value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.mediumType = value as! DeliveryMedium?
		case 23:
			guard value == nil || value is EventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! EventType?
		case 24:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.eventVersion = value as! UInt64?
		case 26:
			guard value == nil || value is HashModifier? else { throw ProtoError.typeMismatchError }
			self.hashModifier = value as! HashModifier?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.senderId
		case 3: return self.timestamp
		case 4: return self.selfEventState
		case 6: return self.sourceType
		case 7: return self.chatMessage
		case 9: return self.membershipChange
		case 10: return self.conversationRename
		case 11: return self.hangoutEvent
		case 12: return self.eventId
		case 13: return self.expirationTimestamp
		case 14: return self.otrModification
		case 15: return self.advancesSortTimestamp
		case 16: return self.otrStatus
		case 17: return self.persisted
		case 20: return self.mediumType
		case 23: return self.eventType
		case 24: return self.eventVersion
		case 26: return self.hashModifier
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.senderId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.selfEventState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.sourceType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.chatMessage._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.membershipChange._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationRename._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.hangoutEvent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.expirationTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otrModification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.advancesSortTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otrStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.persisted._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.mediumType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventVersion._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.hashModifier._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct UserReadState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "participant_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "latest_read_timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return UserReadState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.participantId = value as! ParticipantId?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.latestReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.participantId
		case 2: return self.latestReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.participantId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.latestReadTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var participantId: ParticipantId?
	public var latestReadTimestamp: UInt64?
}

public struct DeliveryMedium: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "medium_type", type: .prototype("DeliveryMediumType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "phone_number", type: .prototype("PhoneNumber"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DeliveryMedium.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is DeliveryMediumType? else { throw ProtoError.typeMismatchError }
			self.mediumType = value as! DeliveryMediumType?
		case 2:
			guard value == nil || value is PhoneNumber? else { throw ProtoError.typeMismatchError }
			self.phoneNumber = value as! PhoneNumber?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.mediumType
		case 2: return self.phoneNumber
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.mediumType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.phoneNumber._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var mediumType: DeliveryMediumType?
	public var phoneNumber: PhoneNumber?
}

public struct DeliveryMediumOption: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "delivery_medium", type: .prototype("DeliveryMedium"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "current_default", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DeliveryMediumOption.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.deliveryMedium = value as! DeliveryMedium?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.currentDefault = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.deliveryMedium
		case 2: return self.currentDefault
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.deliveryMedium._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.currentDefault._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var deliveryMedium: DeliveryMedium?
	public var currentDefault: Bool?
}

public struct UserConversationState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
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
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return UserConversationState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! String?
		case 7:
			guard value == nil || value is UserReadState? else { throw ProtoError.typeMismatchError }
			self.selfReadState = value as! UserReadState?
		case 8:
			guard value == nil || value is ConversationStatus? else { throw ProtoError.typeMismatchError }
			self.status = value as! ConversationStatus?
		case 9:
			guard value == nil || value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.notificationLevel = value as! NotificationLevel?
		case 10:
			guard value is [ConversationView] else { throw ProtoError.typeMismatchError }
			self.view = value as! [ConversationView]
		case 11:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.inviterId = value as! ParticipantId?
		case 12:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.inviteTimestamp = value as! UInt64?
		case 13:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.sortTimestamp = value as! UInt64?
		case 14:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.activeTimestamp = value as! UInt64?
		case 15:
			guard value == nil || value is InvitationAffinity? else { throw ProtoError.typeMismatchError }
			self.inviteAffinity = value as! InvitationAffinity?
		case 17:
			guard value is [DeliveryMediumOption] else { throw ProtoError.typeMismatchError }
			self.deliveryMediumOption = value as! [DeliveryMediumOption]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 10:
			if value is [ConversationView] {
				self.view.insert(contentsOf: value as! [ConversationView], at: index > 0 ? index : self.view.endIndex)
			} else if value is ConversationView {
				self.view.insert(value as! ConversationView, at: index > 0 ? index : self.view.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 17:
			if value is [DeliveryMediumOption] {
				self.deliveryMediumOption.insert(contentsOf: value as! [DeliveryMediumOption], at: index > 0 ? index : self.deliveryMediumOption.endIndex)
			} else if value is DeliveryMediumOption {
				self.deliveryMediumOption.insert(value as! DeliveryMediumOption, at: index > 0 ? index : self.deliveryMediumOption.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 2: return self.clientGeneratedId
		case 7: return self.selfReadState
		case 8: return self.status
		case 9: return self.notificationLevel
		case 10: return self.view
		case 11: return self.inviterId
		case 12: return self.inviteTimestamp
		case 13: return self.sortTimestamp
		case 14: return self.activeTimestamp
		case 15: return self.inviteAffinity
		case 17: return self.deliveryMediumOption
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 10:
			guard index > 0 && index < self.view.endIndex else { throw ProtoError.unknownError }
			return self.view[index]
		case 17:
			guard index > 0 && index < self.deliveryMediumOption.endIndex else { throw ProtoError.unknownError }
			return self.deliveryMediumOption[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.clientGeneratedId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.selfReadState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.status._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.notificationLevel._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.view.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.inviterId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.inviteTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.sortTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.activeTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.inviteAffinity._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deliveryMediumOption.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct ConversationParticipantData: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "fallback_name", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "invitation_status", type: .prototype("InvitationStatus"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "participant_type", type: .prototype("ParticipantType"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "new_invitation_status", type: .prototype("InvitationStatus"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConversationParticipantData.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.id = value as! ParticipantId?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.fallbackName = value as! String?
		case 3:
			guard value == nil || value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.invitationStatus = value as! InvitationStatus?
		case 5:
			guard value == nil || value is ParticipantType? else { throw ProtoError.typeMismatchError }
			self.participantType = value as! ParticipantType?
		case 6:
			guard value == nil || value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.newInvitationStatus = value as! InvitationStatus?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.id
		case 2: return self.fallbackName
		case 3: return self.invitationStatus
		case 5: return self.participantType
		case 6: return self.newInvitationStatus
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.id._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.fallbackName._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.invitationStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.participantType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.newInvitationStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var id: ParticipantId?
	public var fallbackName: String?
	public var invitationStatus: InvitationStatus?
	public var participantType: ParticipantType?
	public var newInvitationStatus: InvitationStatus?
}

public struct Conversation: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
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
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Conversation.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is ConversationType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ConversationType?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case 4:
			guard value == nil || value is UserConversationState? else { throw ProtoError.typeMismatchError }
			self.selfConversationState = value as! UserConversationState?
		case 8:
			guard value is [UserReadState] else { throw ProtoError.typeMismatchError }
			self.readState = value as! [UserReadState]
		case 9:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.hasActiveHangout = value as! Bool?
		case 10:
			guard value == nil || value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.otrStatus = value as! OffTheRecordStatus?
		case 11:
			guard value == nil || value is OffTheRecordToggle? else { throw ProtoError.typeMismatchError }
			self.otrToggle = value as! OffTheRecordToggle?
		case 12:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.conversationHistorySupported = value as! Bool?
		case 13:
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.currentParticipant = value as! [ParticipantId]
		case 14:
			guard value is [ConversationParticipantData] else { throw ProtoError.typeMismatchError }
			self.participantData = value as! [ConversationParticipantData]
		case 18:
			guard value is [NetworkType] else { throw ProtoError.typeMismatchError }
			self.networkType = value as! [NetworkType]
		case 19:
			guard value == nil || value is ForceHistory? else { throw ProtoError.typeMismatchError }
			self.forceHistoryState = value as! ForceHistory?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 8:
			if value is [UserReadState] {
				self.readState.insert(contentsOf: value as! [UserReadState], at: index > 0 ? index : self.readState.endIndex)
			} else if value is UserReadState {
				self.readState.insert(value as! UserReadState, at: index > 0 ? index : self.readState.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 13:
			if value is [ParticipantId] {
				self.currentParticipant.insert(contentsOf: value as! [ParticipantId], at: index > 0 ? index : self.currentParticipant.endIndex)
			} else if value is ParticipantId {
				self.currentParticipant.insert(value as! ParticipantId, at: index > 0 ? index : self.currentParticipant.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 14:
			if value is [ConversationParticipantData] {
				self.participantData.insert(contentsOf: value as! [ConversationParticipantData], at: index > 0 ? index : self.participantData.endIndex)
			} else if value is ConversationParticipantData {
				self.participantData.insert(value as! ConversationParticipantData, at: index > 0 ? index : self.participantData.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 18:
			if value is [NetworkType] {
				self.networkType.insert(contentsOf: value as! [NetworkType], at: index > 0 ? index : self.networkType.endIndex)
			} else if value is NetworkType {
				self.networkType.insert(value as! NetworkType, at: index > 0 ? index : self.networkType.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.type
		case 3: return self.name
		case 4: return self.selfConversationState
		case 8: return self.readState
		case 9: return self.hasActiveHangout
		case 10: return self.otrStatus
		case 11: return self.otrToggle
		case 12: return self.conversationHistorySupported
		case 13: return self.currentParticipant
		case 14: return self.participantData
		case 18: return self.networkType
		case 19: return self.forceHistoryState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 8:
			guard index > 0 && index < self.readState.endIndex else { throw ProtoError.unknownError }
			return self.readState[index]
		case 13:
			guard index > 0 && index < self.currentParticipant.endIndex else { throw ProtoError.unknownError }
			return self.currentParticipant[index]
		case 14:
			guard index > 0 && index < self.participantData.endIndex else { throw ProtoError.unknownError }
			return self.participantData[index]
		case 18:
			guard index > 0 && index < self.networkType.endIndex else { throw ProtoError.unknownError }
			return self.networkType[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.name._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.selfConversationState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.readState.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.hasActiveHangout._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otrStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otrToggle._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationHistorySupported._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.currentParticipant.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.participantData.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.networkType.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.forceHistoryState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct EasterEgg: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "message", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EasterEgg.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.message = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.message
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.message._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var message: String?
}

public struct BlockStateChange: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "participant_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "new_block_state", type: .prototype("BlockState"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return BlockStateChange.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.participantId = value as! ParticipantId?
		case 2:
			guard value == nil || value is BlockState? else { throw ProtoError.typeMismatchError }
			self.newBlockState = value as! BlockState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.participantId
		case 2: return self.newBlockState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.participantId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.newBlockState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var participantId: ParticipantId?
	public var newBlockState: BlockState?
}

public struct Photo: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "photo_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_albumless_source_photo", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "user_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "is_custom_user_id", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Photo.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.photoId = value as! String?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.deleteAlbumlessSourcePhoto = value as! Bool?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.userId = value as! String?
		case 4:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.isCustomUserId = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.photoId
		case 2: return self.deleteAlbumlessSourcePhoto
		case 3: return self.userId
		case 4: return self.isCustomUserId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.photoId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deleteAlbumlessSourcePhoto._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.userId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.isCustomUserId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var photoId: String?
	public var deleteAlbumlessSourcePhoto: Bool?
	public var userId: String?
	public var isCustomUserId: Bool?
}

public struct ExistingMedia: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "photo", type: .prototype("Photo"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ExistingMedia.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Photo? else { throw ProtoError.typeMismatchError }
			self.photo = value as! Photo?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.photo
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.photo._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var photo: Photo?
}

public struct EventRequestHeader: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "client_generated_id", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "expected_otr", type: .prototype("OffTheRecordStatus"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "delivery_medium", type: .prototype("DeliveryMedium"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "event_type", type: .prototype("EventType"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EventRequestHeader.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! UInt64?
		case 3:
			guard value == nil || value is OffTheRecordStatus? else { throw ProtoError.typeMismatchError }
			self.expectedOtr = value as! OffTheRecordStatus?
		case 4:
			guard value == nil || value is DeliveryMedium? else { throw ProtoError.typeMismatchError }
			self.deliveryMedium = value as! DeliveryMedium?
		case 5:
			guard value == nil || value is EventType? else { throw ProtoError.typeMismatchError }
			self.eventType = value as! EventType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.clientGeneratedId
		case 3: return self.expectedOtr
		case 4: return self.deliveryMedium
		case 5: return self.eventType
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.clientGeneratedId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.expectedOtr._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deliveryMedium._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var clientGeneratedId: UInt64?
	public var expectedOtr: OffTheRecordStatus?
	public var deliveryMedium: DeliveryMedium?
	public var eventType: EventType?
}

public struct ClientVersion: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "client_id", type: .prototype("ClientId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "build_type", type: .prototype("ClientBuildType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "major_version", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "version_timestamp", type: .uint64, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "device_os_version", type: .string, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "device_hardware", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ClientVersion.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ClientId? else { throw ProtoError.typeMismatchError }
			self.clientId = value as! ClientId?
		case 2:
			guard value == nil || value is ClientBuildType? else { throw ProtoError.typeMismatchError }
			self.buildType = value as! ClientBuildType?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.majorVersion = value as! String?
		case 4:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.versionTimestamp = value as! UInt64?
		case 5:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.deviceOsVersion = value as! String?
		case 6:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.deviceHardware = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.clientId
		case 2: return self.buildType
		case 3: return self.majorVersion
		case 4: return self.versionTimestamp
		case 5: return self.deviceOsVersion
		case 6: return self.deviceHardware
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.clientId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.buildType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.majorVersion._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.versionTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deviceOsVersion._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deviceHardware._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var clientId: ClientId?
	public var buildType: ClientBuildType?
	public var majorVersion: String?
	public var versionTimestamp: UInt64?
	public var deviceOsVersion: String?
	public var deviceHardware: String?
}

public struct RequestHeader: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "client_version", type: .prototype("ClientVersion"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "client_identifier", type: .prototype("ClientIdentifier"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "language_code", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RequestHeader.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ClientVersion? else { throw ProtoError.typeMismatchError }
			self.clientVersion = value as! ClientVersion?
		case 2:
			guard value == nil || value is ClientIdentifier? else { throw ProtoError.typeMismatchError }
			self.clientIdentifier = value as! ClientIdentifier?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.languageCode = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.clientVersion
		case 2: return self.clientIdentifier
		case 4: return self.languageCode
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.clientVersion._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.clientIdentifier._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.languageCode._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var clientVersion: ClientVersion?
	public var clientIdentifier: ClientIdentifier?
	public var languageCode: String?
}

public struct ResponseHeader: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "status", type: .prototype("ResponseStatus"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "error_description", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "debug_url", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "request_trace_id", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "current_server_time", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ResponseHeader.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseStatus? else { throw ProtoError.typeMismatchError }
			self.status = value as! ResponseStatus?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.errorDescription = value as! String?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.debugUrl = value as! String?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.requestTraceId = value as! String?
		case 5:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.currentServerTime = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.status
		case 2: return self.errorDescription
		case 3: return self.debugUrl
		case 4: return self.requestTraceId
		case 5: return self.currentServerTime
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.status._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.errorDescription._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.debugUrl._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.requestTraceId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.currentServerTime._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var status: ResponseStatus?
	public var errorDescription: String?
	public var debugUrl: String?
	public var requestTraceId: String?
	public var currentServerTime: UInt64?
}

public struct Entity: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		9: ProtoFieldDescriptor(id: 9, name: "id", type: .prototype("ParticipantId"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "presence", type: .prototype("Presence"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "properties", type: .prototype("EntityProperties"), label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "entity_type", type: .prototype("ParticipantType"), label: .optional),
		16: ProtoFieldDescriptor(id: 16, name: "had_past_hangout_state", type: .prototype("PastHangoutState"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Entity.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 9:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.id = value as! ParticipantId?
		case 8:
			guard value == nil || value is Presence? else { throw ProtoError.typeMismatchError }
			self.presence = value as! Presence?
		case 10:
			guard value == nil || value is EntityProperties? else { throw ProtoError.typeMismatchError }
			self.properties = value as! EntityProperties?
		case 13:
			guard value == nil || value is ParticipantType? else { throw ProtoError.typeMismatchError }
			self.entityType = value as! ParticipantType?
		case 16:
			guard value == nil || value is PastHangoutState? else { throw ProtoError.typeMismatchError }
			self.hadPastHangoutState = value as! PastHangoutState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 9: return self.id
		case 8: return self.presence
		case 10: return self.properties
		case 13: return self.entityType
		case 16: return self.hadPastHangoutState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.id._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.presence._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.properties._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.entityType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.hadPastHangoutState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var id: ParticipantId?
	public var presence: Presence?
	public var properties: EntityProperties?
	public var entityType: ParticipantType?
	public var hadPastHangoutState: PastHangoutState?
}

public struct EntityProperties: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
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
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EntityProperties.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ProfileType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ProfileType?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.displayName = value as! String?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.firstName = value as! String?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.photoUrl = value as! String?
		case 5:
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.email = value as! [String]
		case 6:
			guard value is [String] else { throw ProtoError.typeMismatchError }
			self.phone = value as! [String]
		case 10:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.inUsersDomain = value as! Bool?
		case 11:
			guard value == nil || value is Gender? else { throw ProtoError.typeMismatchError }
			self.gender = value as! Gender?
		case 12:
			guard value == nil || value is PhotoUrlStatus? else { throw ProtoError.typeMismatchError }
			self.photoUrlStatus = value as! PhotoUrlStatus?
		case 15:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.canonicalEmail = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 5:
			if value is [String] {
				self.email.insert(contentsOf: value as! [String], at: index > 0 ? index : self.email.endIndex)
			} else if value is String {
				self.email.insert(value as! String, at: index > 0 ? index : self.email.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 6:
			if value is [String] {
				self.phone.insert(contentsOf: value as! [String], at: index > 0 ? index : self.phone.endIndex)
			} else if value is String {
				self.phone.insert(value as! String, at: index > 0 ? index : self.phone.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.type
		case 2: return self.displayName
		case 3: return self.firstName
		case 4: return self.photoUrl
		case 5: return self.email
		case 6: return self.phone
		case 10: return self.inUsersDomain
		case 11: return self.gender
		case 12: return self.photoUrlStatus
		case 15: return self.canonicalEmail
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 5:
			guard index > 0 && index < self.email.endIndex else { throw ProtoError.unknownError }
			return self.email[index]
		case 6:
			guard index > 0 && index < self.phone.endIndex else { throw ProtoError.unknownError }
			return self.phone[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.displayName._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.firstName._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.photoUrl._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.email.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.phone.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.inUsersDomain._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.gender._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.photoUrlStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.canonicalEmail._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct ConversationState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation", type: .prototype("Conversation"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "event", type: .prototype("Event"), label: .repeated),
		5: ProtoFieldDescriptor(id: 5, name: "event_continuation_token", type: .prototype("EventContinuationToken"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConversationState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case 3:
			guard value is [Event] else { throw ProtoError.typeMismatchError }
			self.event = value as! [Event]
		case 5:
			guard value == nil || value is EventContinuationToken? else { throw ProtoError.typeMismatchError }
			self.eventContinuationToken = value as! EventContinuationToken?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [Event] {
				self.event.insert(contentsOf: value as! [Event], at: index > 0 ? index : self.event.endIndex)
			} else if value is Event {
				self.event.insert(value as! Event, at: index > 0 ? index : self.event.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.conversation
		case 3: return self.event
		case 5: return self.eventContinuationToken
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.event.endIndex else { throw ProtoError.unknownError }
			return self.event[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversation._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.event.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.eventContinuationToken._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var conversation: Conversation?
	public var event: [Event] = []
	public var eventContinuationToken: EventContinuationToken?
}

public struct EventContinuationToken: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "event_id", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "storage_continuation_token", type: .bytes, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "event_timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EventContinuationToken.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.eventId = value as! String?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.storageContinuationToken = value as! String?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.eventTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.eventId
		case 2: return self.storageContinuationToken
		case 3: return self.eventTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.eventId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.storageContinuationToken._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var eventId: String?
	public var storageContinuationToken: String?
	public var eventTimestamp: UInt64?
}

public struct EntityLookupSpec: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "gaia_id", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "email", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "phone", type: .string, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "create_offnetwork_gaia", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EntityLookupSpec.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.email = value as! String?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.phone = value as! String?
		case 6:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.createOffnetworkGaia = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.gaiaId
		case 3: return self.email
		case 4: return self.phone
		case 6: return self.createOffnetworkGaia
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.gaiaId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.email._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.phone._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.createOffnetworkGaia._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var gaiaId: String?
	public var email: String?
	public var phone: String?
	public var createOffnetworkGaia: Bool?
}

public struct ConfigurationBit: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "configuration_bit_type", type: .prototype("ConfigurationBitType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "value", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConfigurationBit.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConfigurationBitType? else { throw ProtoError.typeMismatchError }
			self.configurationBitType = value as! ConfigurationBitType?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.value = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.configurationBitType
		case 2: return self.value
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.configurationBitType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.value._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var configurationBitType: ConfigurationBitType?
	public var value: Bool?
}

public struct RichPresenceState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		3: ProtoFieldDescriptor(id: 3, name: "get_rich_presence_enabled_state", type: .prototype("RichPresenceEnabledState"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RichPresenceState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 3:
			guard value is [RichPresenceEnabledState] else { throw ProtoError.typeMismatchError }
			self.getRichPresenceEnabledState = value as! [RichPresenceEnabledState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [RichPresenceEnabledState] {
				self.getRichPresenceEnabledState.insert(contentsOf: value as! [RichPresenceEnabledState], at: index > 0 ? index : self.getRichPresenceEnabledState.endIndex)
			} else if value is RichPresenceEnabledState {
				self.getRichPresenceEnabledState.insert(value as! RichPresenceEnabledState, at: index > 0 ? index : self.getRichPresenceEnabledState.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 3: return self.getRichPresenceEnabledState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.getRichPresenceEnabledState.endIndex else { throw ProtoError.unknownError }
			return self.getRichPresenceEnabledState[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.getRichPresenceEnabledState.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var getRichPresenceEnabledState: [RichPresenceEnabledState] = []
}

public struct RichPresenceEnabledState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("RichPresenceType"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "enabled", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RichPresenceEnabledState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RichPresenceType? else { throw ProtoError.typeMismatchError }
			self.type = value as! RichPresenceType?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.enabled = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.type
		case 2: return self.enabled
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.enabled._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var type: RichPresenceType?
	public var enabled: Bool?
}

public struct DesktopOffSetting: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "desktop_off", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DesktopOffSetting.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.desktopOff = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.desktopOff
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.desktopOff._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var desktopOff: Bool?
}

public struct DesktopOffState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "desktop_off", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "version", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DesktopOffState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.desktopOff = value as! Bool?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.version = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.desktopOff
		case 2: return self.version
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.desktopOff._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.version._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var desktopOff: Bool?
	public var version: UInt64?
}

public struct DndSetting: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "do_not_disturb", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timeout_secs", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DndSetting.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.doNotDisturb = value as! Bool?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.doNotDisturb
		case 2: return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.doNotDisturb._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timeoutSecs._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var doNotDisturb: Bool?
	public var timeoutSecs: UInt64?
}

public struct PresenceStateSetting: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "timeout_secs", type: .uint64, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ClientPresenceStateType"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return PresenceStateSetting.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		case 2:
			guard value == nil || value is ClientPresenceStateType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ClientPresenceStateType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.timeoutSecs
		case 2: return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.timeoutSecs._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var timeoutSecs: UInt64?
	public var type: ClientPresenceStateType?
}

public struct MoodMessage: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "mood_content", type: .prototype("MoodContent"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return MoodMessage.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is MoodContent? else { throw ProtoError.typeMismatchError }
			self.moodContent = value as! MoodContent?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.moodContent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.moodContent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var moodContent: MoodContent?
}

public struct MoodContent: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "segment", type: .prototype("Segment"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return MoodContent.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [Segment] else { throw ProtoError.typeMismatchError }
			self.segment = value as! [Segment]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [Segment] {
				self.segment.insert(contentsOf: value as! [Segment], at: index > 0 ? index : self.segment.endIndex)
			} else if value is Segment {
				self.segment.insert(value as! Segment, at: index > 0 ? index : self.segment.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.segment
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.segment.endIndex else { throw ProtoError.unknownError }
			return self.segment[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.segment.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var segment: [Segment] = []
}

public struct MoodSetting: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "mood_message", type: .prototype("MoodMessage"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return MoodSetting.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is MoodMessage? else { throw ProtoError.typeMismatchError }
			self.moodMessage = value as! MoodMessage?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.moodMessage
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.moodMessage._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var moodMessage: MoodMessage?
}

public struct MoodState: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		4: ProtoFieldDescriptor(id: 4, name: "mood_setting", type: .prototype("MoodSetting"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return MoodState.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 4:
			guard value == nil || value is MoodSetting? else { throw ProtoError.typeMismatchError }
			self.moodSetting = value as! MoodSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 4: return self.moodSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.moodSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var moodSetting: MoodSetting?
}

public struct DeleteAction: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "delete_action_timestamp", type: .uint64, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_upper_bound_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "delete_type", type: .prototype("DeleteType"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DeleteAction.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteActionTimestamp = value as! UInt64?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteUpperBoundTimestamp = value as! UInt64?
		case 3:
			guard value == nil || value is DeleteType? else { throw ProtoError.typeMismatchError }
			self.deleteType = value as! DeleteType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.deleteActionTimestamp
		case 2: return self.deleteUpperBoundTimestamp
		case 3: return self.deleteType
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.deleteActionTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deleteUpperBoundTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deleteType._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var deleteActionTimestamp: UInt64?
	public var deleteUpperBoundTimestamp: UInt64?
	public var deleteType: DeleteType?
}

public struct InviteeID: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "gaia_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "fallback_name", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return InviteeID.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.gaiaId = value as! String?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.fallbackName = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.gaiaId
		case 4: return self.fallbackName
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.gaiaId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.fallbackName._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var gaiaId: String?
	public var fallbackName: String?
}

public struct Country: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "region_code", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "country_code", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Country.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.regionCode = value as! String?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.countryCode = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.regionCode
		case 2: return self.countryCode
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.regionCode._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.countryCode._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var regionCode: String?
	public var countryCode: UInt64?
}

public struct DesktopSoundSetting: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "desktop_sound_state", type: .prototype("SoundState"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "desktop_ring_sound_state", type: .prototype("SoundState"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DesktopSoundSetting.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is SoundState? else { throw ProtoError.typeMismatchError }
			self.desktopSoundState = value as! SoundState?
		case 2:
			guard value == nil || value is SoundState? else { throw ProtoError.typeMismatchError }
			self.desktopRingSoundState = value as! SoundState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.desktopSoundState
		case 2: return self.desktopRingSoundState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.desktopSoundState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.desktopRingSoundState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var desktopSoundState: SoundState?
	public var desktopRingSoundState: SoundState?
}

public struct PhoneData: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "phone", type: .prototype("Phone"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "caller_id_settings_mask", type: .prototype("CallerIdSettingsMask"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return PhoneData.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [Phone] else { throw ProtoError.typeMismatchError }
			self.phone = value as! [Phone]
		case 3:
			guard value == nil || value is CallerIdSettingsMask? else { throw ProtoError.typeMismatchError }
			self.callerIdSettingsMask = value as! CallerIdSettingsMask?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [Phone] {
				self.phone.insert(contentsOf: value as! [Phone], at: index > 0 ? index : self.phone.endIndex)
			} else if value is Phone {
				self.phone.insert(value as! Phone, at: index > 0 ? index : self.phone.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.phone
		case 3: return self.callerIdSettingsMask
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.phone.endIndex else { throw ProtoError.unknownError }
			return self.phone[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.phone.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.callerIdSettingsMask._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var phone: [Phone] = []
	public var callerIdSettingsMask: CallerIdSettingsMask?
}

public struct Phone: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "phone_number", type: .prototype("PhoneNumber"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "google_voice", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "verification_status", type: .prototype("PhoneVerificationStatus"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "discoverable", type: .bool, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "discoverability_status", type: .prototype("PhoneDiscoverabilityStatus"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "primary", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return Phone.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is PhoneNumber? else { throw ProtoError.typeMismatchError }
			self.phoneNumber = value as! PhoneNumber?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.googleVoice = value as! Bool?
		case 3:
			guard value == nil || value is PhoneVerificationStatus? else { throw ProtoError.typeMismatchError }
			self.verificationStatus = value as! PhoneVerificationStatus?
		case 4:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.discoverable = value as! Bool?
		case 5:
			guard value == nil || value is PhoneDiscoverabilityStatus? else { throw ProtoError.typeMismatchError }
			self.discoverabilityStatus = value as! PhoneDiscoverabilityStatus?
		case 6:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.primary = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.phoneNumber
		case 2: return self.googleVoice
		case 3: return self.verificationStatus
		case 4: return self.discoverable
		case 5: return self.discoverabilityStatus
		case 6: return self.primary
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.phoneNumber._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.googleVoice._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.verificationStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.discoverable._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.discoverabilityStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.primary._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var phoneNumber: PhoneNumber?
	public var googleVoice: Bool?
	public var verificationStatus: PhoneVerificationStatus?
	public var discoverable: Bool?
	public var discoverabilityStatus: PhoneDiscoverabilityStatus?
	public var primary: Bool?
}

public struct I18nData: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "national_number", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "international_number", type: .string, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "country_code", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "region_code", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "is_valid", type: .bool, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "validation_result", type: .prototype("PhoneValidationResult"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return I18nData.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.nationalNumber = value as! String?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.internationalNumber = value as! String?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.countryCode = value as! UInt64?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.regionCode = value as! String?
		case 5:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.isValid = value as! Bool?
		case 6:
			guard value == nil || value is PhoneValidationResult? else { throw ProtoError.typeMismatchError }
			self.validationResult = value as! PhoneValidationResult?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.nationalNumber
		case 2: return self.internationalNumber
		case 3: return self.countryCode
		case 4: return self.regionCode
		case 5: return self.isValid
		case 6: return self.validationResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.nationalNumber._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.internationalNumber._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.countryCode._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.regionCode._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.isValid._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.validationResult._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var nationalNumber: String?
	public var internationalNumber: String?
	public var countryCode: UInt64?
	public var regionCode: String?
	public var isValid: Bool?
	public var validationResult: PhoneValidationResult?
}

public struct PhoneNumber: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "e164", type: .string, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "i18n_data", type: .prototype("I18nData"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return PhoneNumber.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.e164 = value as! String?
		case 2:
			guard value == nil || value is I18nData? else { throw ProtoError.typeMismatchError }
			self.i18nData = value as! I18nData?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.e164
		case 2: return self.i18nData
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.e164._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.i18nData._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var e164: String?
	public var i18nData: I18nData?
}

public struct SuggestedContactGroupHash: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "max_results", type: .uint64, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "hash", type: .bytes, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SuggestedContactGroupHash.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxResults = value as! UInt64?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.hash = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.maxResults
		case 2: return self.hash
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.maxResults._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.hash._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var maxResults: UInt64?
	public var hash: String?
}

public struct SuggestedContact: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "entity", type: .prototype("Entity"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "invitation_status", type: .prototype("InvitationStatus"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SuggestedContact.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Entity? else { throw ProtoError.typeMismatchError }
			self.entity = value as! Entity?
		case 2:
			guard value == nil || value is InvitationStatus? else { throw ProtoError.typeMismatchError }
			self.invitationStatus = value as! InvitationStatus?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.entity
		case 2: return self.invitationStatus
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.entity._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.invitationStatus._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var entity: Entity?
	public var invitationStatus: InvitationStatus?
}

public struct SuggestedContactGroup: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "hash_matched", type: .bool, label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "hash", type: .bytes, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "contact", type: .prototype("SuggestedContact"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SuggestedContactGroup.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.hashMatched = value as! Bool?
		case 2:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.hash = value as! String?
		case 3:
			guard value is [SuggestedContact] else { throw ProtoError.typeMismatchError }
			self.contact = value as! [SuggestedContact]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [SuggestedContact] {
				self.contact.insert(contentsOf: value as! [SuggestedContact], at: index > 0 ? index : self.contact.endIndex)
			} else if value is SuggestedContact {
				self.contact.insert(value as! SuggestedContact, at: index > 0 ? index : self.contact.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.hashMatched
		case 2: return self.hash
		case 3: return self.contact
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.contact.endIndex else { throw ProtoError.unknownError }
			return self.contact[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.hashMatched._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.hash._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.contact.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var hashMatched: Bool?
	public var hash: String?
	public var contact: [SuggestedContact] = []
}

public struct StateUpdate: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
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
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return StateUpdate.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is StateUpdateHeader? else { throw ProtoError.typeMismatchError }
			self.stateUpdateHeader = value as! StateUpdateHeader?
		case 13:
			guard value == nil || value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case 2:
			guard value == nil || value is ConversationNotification? else { throw ProtoError.typeMismatchError }
			self.conversationNotification = value as! ConversationNotification?
		case 3:
			guard value == nil || value is EventNotification? else { throw ProtoError.typeMismatchError }
			self.eventNotification = value as! EventNotification?
		case 4:
			guard value == nil || value is SetFocusNotification? else { throw ProtoError.typeMismatchError }
			self.focusNotification = value as! SetFocusNotification?
		case 5:
			guard value == nil || value is SetTypingNotification? else { throw ProtoError.typeMismatchError }
			self.typingNotification = value as! SetTypingNotification?
		case 6:
			guard value == nil || value is SetConversationNotificationLevelNotification? else { throw ProtoError.typeMismatchError }
			self.notificationLevelNotification = value as! SetConversationNotificationLevelNotification?
		case 7:
			guard value == nil || value is ReplyToInviteNotification? else { throw ProtoError.typeMismatchError }
			self.replyToInviteNotification = value as! ReplyToInviteNotification?
		case 8:
			guard value == nil || value is WatermarkNotification? else { throw ProtoError.typeMismatchError }
			self.watermarkNotification = value as! WatermarkNotification?
		case 11:
			guard value == nil || value is ConversationViewModification? else { throw ProtoError.typeMismatchError }
			self.viewModification = value as! ConversationViewModification?
		case 12:
			guard value == nil || value is EasterEggNotification? else { throw ProtoError.typeMismatchError }
			self.easterEggNotification = value as! EasterEggNotification?
		case 14:
			guard value == nil || value is SelfPresenceNotification? else { throw ProtoError.typeMismatchError }
			self.selfPresenceNotification = value as! SelfPresenceNotification?
		case 15:
			guard value == nil || value is DeleteActionNotification? else { throw ProtoError.typeMismatchError }
			self.deleteNotification = value as! DeleteActionNotification?
		case 16:
			guard value == nil || value is PresenceNotification? else { throw ProtoError.typeMismatchError }
			self.presenceNotification = value as! PresenceNotification?
		case 17:
			guard value == nil || value is BlockNotification? else { throw ProtoError.typeMismatchError }
			self.blockNotification = value as! BlockNotification?
		case 19:
			guard value == nil || value is SetNotificationSettingNotification? else { throw ProtoError.typeMismatchError }
			self.notificationSettingNotification = value as! SetNotificationSettingNotification?
		case 20:
			guard value == nil || value is RichPresenceEnabledStateNotification? else { throw ProtoError.typeMismatchError }
			self.richPresenceEnabledStateNotification = value as! RichPresenceEnabledStateNotification?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.stateUpdateHeader
		case 13: return self.conversation
		case 2: return self.conversationNotification
		case 3: return self.eventNotification
		case 4: return self.focusNotification
		case 5: return self.typingNotification
		case 6: return self.notificationLevelNotification
		case 7: return self.replyToInviteNotification
		case 8: return self.watermarkNotification
		case 11: return self.viewModification
		case 12: return self.easterEggNotification
		case 14: return self.selfPresenceNotification
		case 15: return self.deleteNotification
		case 16: return self.presenceNotification
		case 17: return self.blockNotification
		case 19: return self.notificationSettingNotification
		case 20: return self.richPresenceEnabledStateNotification
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.stateUpdateHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversation._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.focusNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.typingNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.notificationLevelNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.replyToInviteNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.watermarkNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.viewModification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.easterEggNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.selfPresenceNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deleteNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.presenceNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.blockNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.notificationSettingNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.richPresenceEnabledStateNotification._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct StateUpdateHeader: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "active_client_state", type: .prototype("ActiveClientState"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "request_trace_id", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "notification_settings", type: .prototype("NotificationSettings"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "current_server_time", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return StateUpdateHeader.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ActiveClientState? else { throw ProtoError.typeMismatchError }
			self.activeClientState = value as! ActiveClientState?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.requestTraceId = value as! String?
		case 4:
			guard value == nil || value is NotificationSettings? else { throw ProtoError.typeMismatchError }
			self.notificationSettings = value as! NotificationSettings?
		case 5:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.currentServerTime = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.activeClientState
		case 3: return self.requestTraceId
		case 4: return self.notificationSettings
		case 5: return self.currentServerTime
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.activeClientState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.requestTraceId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.notificationSettings._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.currentServerTime._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var activeClientState: ActiveClientState?
	public var requestTraceId: String?
	public var notificationSettings: NotificationSettings?
	public var currentServerTime: UInt64?
}

public struct BatchUpdate: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "state_update", type: .prototype("StateUpdate"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return BatchUpdate.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [StateUpdate] else { throw ProtoError.typeMismatchError }
			self.stateUpdate = value as! [StateUpdate]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [StateUpdate] {
				self.stateUpdate.insert(contentsOf: value as! [StateUpdate], at: index > 0 ? index : self.stateUpdate.endIndex)
			} else if value is StateUpdate {
				self.stateUpdate.insert(value as! StateUpdate, at: index > 0 ? index : self.stateUpdate.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.stateUpdate
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.stateUpdate.endIndex else { throw ProtoError.unknownError }
			return self.stateUpdate[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.stateUpdate.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var stateUpdate: [StateUpdate] = []
}

public struct ConversationNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation", type: .prototype("Conversation"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConversationNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversation
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversation._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversation: Conversation?
}

public struct EventNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "event", type: .prototype("Event"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EventNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is Event? else { throw ProtoError.typeMismatchError }
			self.event = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.event
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.event._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var event: Event?
}

public struct SetFocusNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "type", type: .prototype("FocusType"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "device", type: .prototype("FocusDevice"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetFocusNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		case 4:
			guard value == nil || value is FocusType? else { throw ProtoError.typeMismatchError }
			self.type = value as! FocusType?
		case 5:
			guard value == nil || value is FocusDevice? else { throw ProtoError.typeMismatchError }
			self.device = value as! FocusDevice?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.senderId
		case 3: return self.timestamp
		case 4: return self.type
		case 5: return self.device
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.senderId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.device._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var senderId: ParticipantId?
	public var timestamp: UInt64?
	public var type: FocusType?
	public var device: FocusDevice?
}

public struct SetTypingNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "timestamp", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "type", type: .prototype("TypingType"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetTypingNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		case 4:
			guard value == nil || value is TypingType? else { throw ProtoError.typeMismatchError }
			self.type = value as! TypingType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.senderId
		case 3: return self.timestamp
		case 4: return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.senderId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var senderId: ParticipantId?
	public var timestamp: UInt64?
	public var type: TypingType?
}

public struct SetConversationNotificationLevelNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "level", type: .prototype("NotificationLevel"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetConversationNotificationLevelNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.level = value as! NotificationLevel?
		case 4:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.level
		case 4: return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.level._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var level: NotificationLevel?
	public var timestamp: UInt64?
}

public struct ReplyToInviteNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ReplyToInviteType"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ReplyToInviteNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is ReplyToInviteType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ReplyToInviteType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var type: ReplyToInviteType?
}

public struct WatermarkNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "latest_read_timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return WatermarkNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.latestReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.senderId
		case 2: return self.conversationId
		case 3: return self.latestReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.senderId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.latestReadTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var senderId: ParticipantId?
	public var conversationId: ConversationId?
	public var latestReadTimestamp: UInt64?
}

public struct ConversationViewModification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "old_view", type: .prototype("ConversationView"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "new_view", type: .prototype("ConversationView"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConversationViewModification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is ConversationView? else { throw ProtoError.typeMismatchError }
			self.oldView = value as! ConversationView?
		case 3:
			guard value == nil || value is ConversationView? else { throw ProtoError.typeMismatchError }
			self.newView = value as! ConversationView?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.oldView
		case 3: return self.newView
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.oldView._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.newView._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var oldView: ConversationView?
	public var newView: ConversationView?
}

public struct EasterEggNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "sender_id", type: .prototype("ParticipantId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "easter_egg", type: .prototype("EasterEgg"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EasterEggNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ParticipantId? else { throw ProtoError.typeMismatchError }
			self.senderId = value as! ParticipantId?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is EasterEgg? else { throw ProtoError.typeMismatchError }
			self.easterEgg = value as! EasterEgg?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.senderId
		case 2: return self.conversationId
		case 3: return self.easterEgg
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.senderId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.easterEgg._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var senderId: ParticipantId?
	public var conversationId: ConversationId?
	public var easterEgg: EasterEgg?
}

public struct SelfPresenceNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "client_presence_state", type: .prototype("ClientPresenceState"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "do_not_disturb_setting", type: .prototype("DoNotDisturbSetting"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "desktop_off_setting", type: .prototype("DesktopOffSetting"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "desktop_off_state", type: .prototype("DesktopOffState"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "mood_state", type: .prototype("MoodState"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SelfPresenceNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ClientPresenceState? else { throw ProtoError.typeMismatchError }
			self.clientPresenceState = value as! ClientPresenceState?
		case 3:
			guard value == nil || value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.doNotDisturbSetting = value as! DoNotDisturbSetting?
		case 4:
			guard value == nil || value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case 5:
			guard value == nil || value is DesktopOffState? else { throw ProtoError.typeMismatchError }
			self.desktopOffState = value as! DesktopOffState?
		case 6:
			guard value == nil || value is MoodState? else { throw ProtoError.typeMismatchError }
			self.moodState = value as! MoodState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.clientPresenceState
		case 3: return self.doNotDisturbSetting
		case 4: return self.desktopOffSetting
		case 5: return self.desktopOffState
		case 6: return self.moodState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.clientPresenceState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.doNotDisturbSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.desktopOffSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.desktopOffState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.moodState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var clientPresenceState: ClientPresenceState?
	public var doNotDisturbSetting: DoNotDisturbSetting?
	public var desktopOffSetting: DesktopOffSetting?
	public var desktopOffState: DesktopOffState?
	public var moodState: MoodState?
}

public struct DeleteActionNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_action", type: .prototype("DeleteAction"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DeleteActionNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 2:
			guard value == nil || value is DeleteAction? else { throw ProtoError.typeMismatchError }
			self.deleteAction = value as! DeleteAction?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		case 2: return self.deleteAction
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deleteAction._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
	public var deleteAction: DeleteAction?
}

public struct PresenceNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "presence", type: .prototype("PresenceResult"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return PresenceNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [PresenceResult] else { throw ProtoError.typeMismatchError }
			self.presence = value as! [PresenceResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [PresenceResult] {
				self.presence.insert(contentsOf: value as! [PresenceResult], at: index > 0 ? index : self.presence.endIndex)
			} else if value is PresenceResult {
				self.presence.insert(value as! PresenceResult, at: index > 0 ? index : self.presence.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.presence
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.presence.endIndex else { throw ProtoError.unknownError }
			return self.presence[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.presence.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var presence: [PresenceResult] = []
}

public struct BlockNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "block_state_change", type: .prototype("BlockStateChange"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return BlockNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [BlockStateChange] else { throw ProtoError.typeMismatchError }
			self.blockStateChange = value as! [BlockStateChange]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [BlockStateChange] {
				self.blockStateChange.insert(contentsOf: value as! [BlockStateChange], at: index > 0 ? index : self.blockStateChange.endIndex)
			} else if value is BlockStateChange {
				self.blockStateChange.insert(value as! BlockStateChange, at: index > 0 ? index : self.blockStateChange.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.blockStateChange
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.blockStateChange.endIndex else { throw ProtoError.unknownError }
			return self.blockStateChange[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.blockStateChange.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var blockStateChange: [BlockStateChange] = []
}

public struct SetNotificationSettingNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		2: ProtoFieldDescriptor(id: 2, name: "desktop_sound_setting", type: .prototype("DesktopSoundSetting"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetNotificationSettingNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 2:
			guard value == nil || value is DesktopSoundSetting? else { throw ProtoError.typeMismatchError }
			self.desktopSoundSetting = value as! DesktopSoundSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 2: return self.desktopSoundSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.desktopSoundSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var desktopSoundSetting: DesktopSoundSetting?
}

public struct RichPresenceEnabledStateNotification: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "rich_presence_enabled_state", type: .prototype("RichPresenceEnabledState"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RichPresenceEnabledStateNotification.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value is [RichPresenceEnabledState] else { throw ProtoError.typeMismatchError }
			self.richPresenceEnabledState = value as! [RichPresenceEnabledState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 1:
			if value is [RichPresenceEnabledState] {
				self.richPresenceEnabledState.insert(contentsOf: value as! [RichPresenceEnabledState], at: index > 0 ? index : self.richPresenceEnabledState.endIndex)
			} else if value is RichPresenceEnabledState {
				self.richPresenceEnabledState.insert(value as! RichPresenceEnabledState, at: index > 0 ? index : self.richPresenceEnabledState.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.richPresenceEnabledState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 1:
			guard index > 0 && index < self.richPresenceEnabledState.endIndex else { throw ProtoError.unknownError }
			return self.richPresenceEnabledState[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.richPresenceEnabledState.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var richPresenceEnabledState: [RichPresenceEnabledState] = []
}

public struct ConversationSpec: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return ConversationSpec.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.conversationId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var conversationId: ConversationId?
}

public struct OffnetworkAddress: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "type", type: .prototype("OffnetworkAddressType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "email", type: .string, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return OffnetworkAddress.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is OffnetworkAddressType? else { throw ProtoError.typeMismatchError }
			self.type = value as! OffnetworkAddressType?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.email = value as! String?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.type
		case 3: return self.email
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.email._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var type: OffnetworkAddressType?
	public var email: String?
}

public struct EntityResult: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "lookup_spec", type: .prototype("EntityLookupSpec"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EntityResult.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is EntityLookupSpec? else { throw ProtoError.typeMismatchError }
			self.lookupSpec = value as! EntityLookupSpec?
		case 2:
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [Entity] {
				self.entity.insert(contentsOf: value as! [Entity], at: index > 0 ? index : self.entity.endIndex)
			} else if value is Entity {
				self.entity.insert(value as! Entity, at: index > 0 ? index : self.entity.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.lookupSpec
		case 2: return self.entity
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.entity.endIndex else { throw ProtoError.unknownError }
			return self.entity[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.lookupSpec._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.entity.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var lookupSpec: EntityLookupSpec?
	public var entity: [Entity] = []
}

public struct AddUserRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "invitee_id", type: .prototype("InviteeID"), label: .repeated),
		5: ProtoFieldDescriptor(id: 5, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return AddUserRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 3:
			guard value is [InviteeID] else { throw ProtoError.typeMismatchError }
			self.inviteeId = value as! [InviteeID]
		case 5:
			guard value == nil || value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [InviteeID] {
				self.inviteeId.insert(contentsOf: value as! [InviteeID], at: index > 0 ? index : self.inviteeId.endIndex)
			} else if value is InviteeID {
				self.inviteeId.insert(value as! InviteeID, at: index > 0 ? index : self.inviteeId.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 3: return self.inviteeId
		case 5: return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.inviteeId.endIndex else { throw ProtoError.unknownError }
			return self.inviteeId[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.inviteeId.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.eventRequestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var inviteeId: [InviteeID] = []
	public var eventRequestHeader: EventRequestHeader?
}

public struct AddUserResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "created_event", type: .prototype("Event"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return AddUserResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 5:
			guard value == nil || value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 5: return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.createdEvent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct CreateConversationRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "type", type: .prototype("ConversationType"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "client_generated_id", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "name", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "invitee_id", type: .prototype("InviteeID"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return CreateConversationRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationType? else { throw ProtoError.typeMismatchError }
			self.type = value as! ConversationType?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.clientGeneratedId = value as! UInt64?
		case 4:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.name = value as! String?
		case 5:
			guard value is [InviteeID] else { throw ProtoError.typeMismatchError }
			self.inviteeId = value as! [InviteeID]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 5:
			if value is [InviteeID] {
				self.inviteeId.insert(contentsOf: value as! [InviteeID], at: index > 0 ? index : self.inviteeId.endIndex)
			} else if value is InviteeID {
				self.inviteeId.insert(value as! InviteeID, at: index > 0 ? index : self.inviteeId.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.type
		case 3: return self.clientGeneratedId
		case 4: return self.name
		case 5: return self.inviteeId
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 5:
			guard index > 0 && index < self.inviteeId.endIndex else { throw ProtoError.unknownError }
			return self.inviteeId[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.clientGeneratedId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.name._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.inviteeId.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var type: ConversationType?
	public var clientGeneratedId: UInt64?
	public var name: String?
	public var inviteeId: [InviteeID] = []
}

public struct CreateConversationResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation", type: .prototype("Conversation"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "new_conversation_created", type: .bool, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return CreateConversationResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is Conversation? else { throw ProtoError.typeMismatchError }
			self.conversation = value as! Conversation?
		case 7:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.newConversationCreated = value as! Bool?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.conversation
		case 7: return self.newConversationCreated
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversation._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.newConversationCreated._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var conversation: Conversation?
	public var newConversationCreated: Bool?
}

public struct DeleteConversationRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "delete_upper_bound_timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DeleteConversationRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.deleteUpperBoundTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.conversationId
		case 3: return self.deleteUpperBoundTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deleteUpperBoundTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var deleteUpperBoundTimestamp: UInt64?
}

public struct DeleteConversationResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "delete_action", type: .prototype("DeleteAction"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return DeleteConversationResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is DeleteAction? else { throw ProtoError.typeMismatchError }
			self.deleteAction = value as! DeleteAction?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.deleteAction
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.deleteAction._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var deleteAction: DeleteAction?
}

public struct EasterEggRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "easter_egg", type: .prototype("EasterEgg"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EasterEggRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is EasterEgg? else { throw ProtoError.typeMismatchError }
			self.easterEgg = value as! EasterEgg?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.conversationId
		case 3: return self.easterEgg
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.easterEgg._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var easterEgg: EasterEgg?
}

public struct EasterEggResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return EasterEggResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct GetConversationRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_spec", type: .prototype("ConversationSpec"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "include_event", type: .bool, label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "max_events_per_conversation", type: .uint64, label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "event_continuation_token", type: .prototype("EventContinuationToken"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetConversationRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationSpec? else { throw ProtoError.typeMismatchError }
			self.conversationSpec = value as! ConversationSpec?
		case 4:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.includeEvent = value as! Bool?
		case 6:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxEventsPerConversation = value as! UInt64?
		case 7:
			guard value == nil || value is EventContinuationToken? else { throw ProtoError.typeMismatchError }
			self.eventContinuationToken = value as! EventContinuationToken?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.conversationSpec
		case 4: return self.includeEvent
		case 6: return self.maxEventsPerConversation
		case 7: return self.eventContinuationToken
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationSpec._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.includeEvent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.maxEventsPerConversation._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventContinuationToken._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var conversationSpec: ConversationSpec?
	public var includeEvent: Bool?
	public var maxEventsPerConversation: UInt64?
	public var eventContinuationToken: EventContinuationToken?
}

public struct GetConversationResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_state", type: .prototype("ConversationState"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetConversationResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is ConversationState? else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! ConversationState?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var conversationState: ConversationState?
}

public struct GetEntityByIdRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "batch_lookup_spec", type: .prototype("EntityLookupSpec"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetEntityByIdRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 3:
			guard value is [EntityLookupSpec] else { throw ProtoError.typeMismatchError }
			self.batchLookupSpec = value as! [EntityLookupSpec]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [EntityLookupSpec] {
				self.batchLookupSpec.insert(contentsOf: value as! [EntityLookupSpec], at: index > 0 ? index : self.batchLookupSpec.endIndex)
			} else if value is EntityLookupSpec {
				self.batchLookupSpec.insert(value as! EntityLookupSpec, at: index > 0 ? index : self.batchLookupSpec.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 3: return self.batchLookupSpec
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.batchLookupSpec.endIndex else { throw ProtoError.unknownError }
			return self.batchLookupSpec[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.batchLookupSpec.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var batchLookupSpec: [EntityLookupSpec] = []
}

public struct GetEntityByIdResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "entity_result", type: .prototype("EntityResult"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetEntityByIdResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		case 3:
			guard value is [EntityResult] else { throw ProtoError.typeMismatchError }
			self.entityResult = value as! [EntityResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [Entity] {
				self.entity.insert(contentsOf: value as! [Entity], at: index > 0 ? index : self.entity.endIndex)
			} else if value is Entity {
				self.entity.insert(value as! Entity, at: index > 0 ? index : self.entity.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 3:
			if value is [EntityResult] {
				self.entityResult.insert(contentsOf: value as! [EntityResult], at: index > 0 ? index : self.entityResult.endIndex)
			} else if value is EntityResult {
				self.entityResult.insert(value as! EntityResult, at: index > 0 ? index : self.entityResult.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.entity
		case 3: return self.entityResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.entity.endIndex else { throw ProtoError.unknownError }
			return self.entity[index]
		case 3:
			guard index > 0 && index < self.entityResult.endIndex else { throw ProtoError.unknownError }
			return self.entityResult[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.entity.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.entityResult.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity] = []
	public var entityResult: [EntityResult] = []
}

public struct GetSuggestedEntitiesRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "max_count", type: .uint64, label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "favorites", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "contacts_you_hangout_with", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		10: ProtoFieldDescriptor(id: 10, name: "other_contacts_on_hangouts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		11: ProtoFieldDescriptor(id: 11, name: "other_contacts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		12: ProtoFieldDescriptor(id: 12, name: "dismissed_contacts", type: .prototype("SuggestedContactGroupHash"), label: .optional),
		13: ProtoFieldDescriptor(id: 13, name: "pinned_favorites", type: .prototype("SuggestedContactGroupHash"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetSuggestedEntitiesRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 4:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxCount = value as! UInt64?
		case 8:
			guard value == nil || value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.favorites = value as! SuggestedContactGroupHash?
		case 9:
			guard value == nil || value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.contactsYouHangoutWith = value as! SuggestedContactGroupHash?
		case 10:
			guard value == nil || value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.otherContactsOnHangouts = value as! SuggestedContactGroupHash?
		case 11:
			guard value == nil || value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.otherContacts = value as! SuggestedContactGroupHash?
		case 12:
			guard value == nil || value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.dismissedContacts = value as! SuggestedContactGroupHash?
		case 13:
			guard value == nil || value is SuggestedContactGroupHash? else { throw ProtoError.typeMismatchError }
			self.pinnedFavorites = value as! SuggestedContactGroupHash?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 4: return self.maxCount
		case 8: return self.favorites
		case 9: return self.contactsYouHangoutWith
		case 10: return self.otherContactsOnHangouts
		case 11: return self.otherContacts
		case 12: return self.dismissedContacts
		case 13: return self.pinnedFavorites
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.maxCount._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.favorites._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.contactsYouHangoutWith._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otherContactsOnHangouts._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otherContacts._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.dismissedContacts._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.pinnedFavorites._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct GetSuggestedEntitiesResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
		4: ProtoFieldDescriptor(id: 4, name: "favorites", type: .prototype("SuggestedContactGroup"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "contacts_you_hangout_with", type: .prototype("SuggestedContactGroup"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "other_contacts_on_hangouts", type: .prototype("SuggestedContactGroup"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "other_contacts", type: .prototype("SuggestedContactGroup"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "dismissed_contacts", type: .prototype("SuggestedContactGroup"), label: .optional),
		9: ProtoFieldDescriptor(id: 9, name: "pinned_favorites", type: .prototype("SuggestedContactGroup"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetSuggestedEntitiesResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		case 4:
			guard value == nil || value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.favorites = value as! SuggestedContactGroup?
		case 5:
			guard value == nil || value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.contactsYouHangoutWith = value as! SuggestedContactGroup?
		case 6:
			guard value == nil || value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.otherContactsOnHangouts = value as! SuggestedContactGroup?
		case 7:
			guard value == nil || value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.otherContacts = value as! SuggestedContactGroup?
		case 8:
			guard value == nil || value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.dismissedContacts = value as! SuggestedContactGroup?
		case 9:
			guard value == nil || value is SuggestedContactGroup? else { throw ProtoError.typeMismatchError }
			self.pinnedFavorites = value as! SuggestedContactGroup?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [Entity] {
				self.entity.insert(contentsOf: value as! [Entity], at: index > 0 ? index : self.entity.endIndex)
			} else if value is Entity {
				self.entity.insert(value as! Entity, at: index > 0 ? index : self.entity.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.entity
		case 4: return self.favorites
		case 5: return self.contactsYouHangoutWith
		case 6: return self.otherContactsOnHangouts
		case 7: return self.otherContacts
		case 8: return self.dismissedContacts
		case 9: return self.pinnedFavorites
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.entity.endIndex else { throw ProtoError.unknownError }
			return self.entity[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.entity.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.favorites._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.contactsYouHangoutWith._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otherContactsOnHangouts._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.otherContacts._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.dismissedContacts._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.pinnedFavorites._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct GetSelfInfoRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetSelfInfoRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
}

public struct GetSelfInfoResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
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
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return GetSelfInfoResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is Entity? else { throw ProtoError.typeMismatchError }
			self.selfEntity = value as! Entity?
		case 3:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.isKnownMinor = value as! Bool?
		case 5:
			guard value == nil || value is DoNotDisturbSetting? else { throw ProtoError.typeMismatchError }
			self.dndState = value as! DoNotDisturbSetting?
		case 6:
			guard value == nil || value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case 7:
			guard value == nil || value is PhoneData? else { throw ProtoError.typeMismatchError }
			self.phoneData = value as! PhoneData?
		case 8:
			guard value is [ConfigurationBit] else { throw ProtoError.typeMismatchError }
			self.configurationBit = value as! [ConfigurationBit]
		case 9:
			guard value == nil || value is DesktopOffState? else { throw ProtoError.typeMismatchError }
			self.desktopOffState = value as! DesktopOffState?
		case 10:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.googlePlusUser = value as! Bool?
		case 11:
			guard value == nil || value is DesktopSoundSetting? else { throw ProtoError.typeMismatchError }
			self.desktopSoundSetting = value as! DesktopSoundSetting?
		case 12:
			guard value == nil || value is RichPresenceState? else { throw ProtoError.typeMismatchError }
			self.richPresenceState = value as! RichPresenceState?
		case 19:
			guard value == nil || value is Country? else { throw ProtoError.typeMismatchError }
			self.defaultCountry = value as! Country?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 8:
			if value is [ConfigurationBit] {
				self.configurationBit.insert(contentsOf: value as! [ConfigurationBit], at: index > 0 ? index : self.configurationBit.endIndex)
			} else if value is ConfigurationBit {
				self.configurationBit.insert(value as! ConfigurationBit, at: index > 0 ? index : self.configurationBit.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.selfEntity
		case 3: return self.isKnownMinor
		case 5: return self.dndState
		case 6: return self.desktopOffSetting
		case 7: return self.phoneData
		case 8: return self.configurationBit
		case 9: return self.desktopOffState
		case 10: return self.googlePlusUser
		case 11: return self.desktopSoundSetting
		case 12: return self.richPresenceState
		case 19: return self.defaultCountry
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 8:
			guard index > 0 && index < self.configurationBit.endIndex else { throw ProtoError.unknownError }
			return self.configurationBit[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.selfEntity._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.isKnownMinor._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.dndState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.desktopOffSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.phoneData._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.configurationBit.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.desktopOffState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.googlePlusUser._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.desktopSoundSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.richPresenceState._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.defaultCountry._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
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

public struct QueryPresenceRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "participant_id", type: .prototype("ParticipantId"), label: .repeated),
		3: ProtoFieldDescriptor(id: 3, name: "field_mask", type: .prototype("FieldMask"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return QueryPresenceRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value is [ParticipantId] else { throw ProtoError.typeMismatchError }
			self.participantId = value as! [ParticipantId]
		case 3:
			guard value is [FieldMask] else { throw ProtoError.typeMismatchError }
			self.fieldMask = value as! [FieldMask]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [ParticipantId] {
				self.participantId.insert(contentsOf: value as! [ParticipantId], at: index > 0 ? index : self.participantId.endIndex)
			} else if value is ParticipantId {
				self.participantId.insert(value as! ParticipantId, at: index > 0 ? index : self.participantId.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		case 3:
			if value is [FieldMask] {
				self.fieldMask.insert(contentsOf: value as! [FieldMask], at: index > 0 ? index : self.fieldMask.endIndex)
			} else if value is FieldMask {
				self.fieldMask.insert(value as! FieldMask, at: index > 0 ? index : self.fieldMask.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.participantId
		case 3: return self.fieldMask
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.participantId.endIndex else { throw ProtoError.unknownError }
			return self.participantId[index]
		case 3:
			guard index > 0 && index < self.fieldMask.endIndex else { throw ProtoError.unknownError }
			return self.fieldMask[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.participantId.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.fieldMask.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var participantId: [ParticipantId] = []
	public var fieldMask: [FieldMask] = []
}

public struct QueryPresenceResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "presence_result", type: .prototype("PresenceResult"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return QueryPresenceResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value is [PresenceResult] else { throw ProtoError.typeMismatchError }
			self.presenceResult = value as! [PresenceResult]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [PresenceResult] {
				self.presenceResult.insert(contentsOf: value as! [PresenceResult], at: index > 0 ? index : self.presenceResult.endIndex)
			} else if value is PresenceResult {
				self.presenceResult.insert(value as! PresenceResult, at: index > 0 ? index : self.presenceResult.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.presenceResult
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.presenceResult.endIndex else { throw ProtoError.unknownError }
			return self.presenceResult[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.presenceResult.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var presenceResult: [PresenceResult] = []
}

public struct RemoveUserRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RemoveUserRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 5:
			guard value == nil || value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 5: return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventRequestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var eventRequestHeader: EventRequestHeader?
}

public struct RemoveUserResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "created_event", type: .prototype("Event"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RemoveUserResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 4:
			guard value == nil || value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 4: return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.createdEvent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct RenameConversationRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "new_name", type: .string, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RenameConversationRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.newName = value as! String?
		case 5:
			guard value == nil || value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 3: return self.newName
		case 5: return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.newName._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventRequestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var newName: String?
	public var eventRequestHeader: EventRequestHeader?
}

public struct RenameConversationResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "created_event", type: .prototype("Event"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return RenameConversationResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 4:
			guard value == nil || value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 4: return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.createdEvent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct SearchEntitiesRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "query", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "max_count", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SearchEntitiesRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.query = value as! String?
		case 4:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxCount = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 3: return self.query
		case 4: return self.maxCount
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.query._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.maxCount._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var query: String?
	public var maxCount: UInt64?
}

public struct SearchEntitiesResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "entity", type: .prototype("Entity"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SearchEntitiesResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value is [Entity] else { throw ProtoError.typeMismatchError }
			self.entity = value as! [Entity]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 2:
			if value is [Entity] {
				self.entity.insert(contentsOf: value as! [Entity], at: index > 0 ? index : self.entity.endIndex)
			} else if value is Entity {
				self.entity.insert(value as! Entity, at: index > 0 ? index : self.entity.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.entity
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 2:
			guard index > 0 && index < self.entity.endIndex else { throw ProtoError.unknownError }
			return self.entity[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.entity.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var entity: [Entity] = []
}

public struct SendChatMessageRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "annotation", type: .prototype("EventAnnotation"), label: .repeated),
		6: ProtoFieldDescriptor(id: 6, name: "message_content", type: .prototype("MessageContent"), label: .optional),
		7: ProtoFieldDescriptor(id: 7, name: "existing_media", type: .prototype("ExistingMedia"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "event_request_header", type: .prototype("EventRequestHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SendChatMessageRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 5:
			guard value is [EventAnnotation] else { throw ProtoError.typeMismatchError }
			self.annotation = value as! [EventAnnotation]
		case 6:
			guard value == nil || value is MessageContent? else { throw ProtoError.typeMismatchError }
			self.messageContent = value as! MessageContent?
		case 7:
			guard value == nil || value is ExistingMedia? else { throw ProtoError.typeMismatchError }
			self.existingMedia = value as! ExistingMedia?
		case 8:
			guard value == nil || value is EventRequestHeader? else { throw ProtoError.typeMismatchError }
			self.eventRequestHeader = value as! EventRequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 5:
			if value is [EventAnnotation] {
				self.annotation.insert(contentsOf: value as! [EventAnnotation], at: index > 0 ? index : self.annotation.endIndex)
			} else if value is EventAnnotation {
				self.annotation.insert(value as! EventAnnotation, at: index > 0 ? index : self.annotation.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 5: return self.annotation
		case 6: return self.messageContent
		case 7: return self.existingMedia
		case 8: return self.eventRequestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 5:
			guard index > 0 && index < self.annotation.endIndex else { throw ProtoError.unknownError }
			return self.annotation[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.annotation.forEach { hash = (hash &* 31) &+ $0.hashValue }
		self.messageContent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.existingMedia._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.eventRequestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var annotation: [EventAnnotation] = []
	public var messageContent: MessageContent?
	public var existingMedia: ExistingMedia?
	public var eventRequestHeader: EventRequestHeader?
}

public struct SendChatMessageResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		6: ProtoFieldDescriptor(id: 6, name: "created_event", type: .prototype("Event"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SendChatMessageResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 6:
			guard value == nil || value is Event? else { throw ProtoError.typeMismatchError }
			self.createdEvent = value as! Event?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 6: return self.createdEvent
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.createdEvent._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var createdEvent: Event?
}

public struct SendOffnetworkInvitationRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "invitee_address", type: .prototype("OffnetworkAddress"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SendOffnetworkInvitationRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is OffnetworkAddress? else { throw ProtoError.typeMismatchError }
			self.inviteeAddress = value as! OffnetworkAddress?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.inviteeAddress
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.inviteeAddress._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var inviteeAddress: OffnetworkAddress?
}

public struct SendOffnetworkInvitationResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SendOffnetworkInvitationResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
}

public struct SetActiveClientRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "is_active", type: .bool, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "full_jid", type: .string, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "timeout_secs", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetActiveClientRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is Bool? else { throw ProtoError.typeMismatchError }
			self.isActive = value as! Bool?
		case 3:
			guard value == nil || value is String? else { throw ProtoError.typeMismatchError }
			self.fullJid = value as! String?
		case 4:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.isActive
		case 3: return self.fullJid
		case 4: return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.isActive._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.fullJid._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timeoutSecs._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var isActive: Bool?
	public var fullJid: String?
	public var timeoutSecs: UInt64?
}

public struct SetActiveClientResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetActiveClientResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
}

public struct SetConversationLevelRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetConversationLevelRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
}

public struct SetConversationLevelResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetConversationLevelResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
}

public struct SetConversationNotificationLevelRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "level", type: .prototype("NotificationLevel"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetConversationNotificationLevelRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is NotificationLevel? else { throw ProtoError.typeMismatchError }
			self.level = value as! NotificationLevel?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.conversationId
		case 3: return self.level
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.level._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var level: NotificationLevel?
}

public struct SetConversationNotificationLevelResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetConversationNotificationLevelResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SetFocusRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "type", type: .prototype("FocusType"), label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "timeout_secs", type: .uint32, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetFocusRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is FocusType? else { throw ProtoError.typeMismatchError }
			self.type = value as! FocusType?
		case 4:
			guard value == nil || value is UInt32? else { throw ProtoError.typeMismatchError }
			self.timeoutSecs = value as! UInt32?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.conversationId
		case 3: return self.type
		case 4: return self.timeoutSecs
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timeoutSecs._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var type: FocusType?
	public var timeoutSecs: UInt32?
}

public struct SetFocusResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetFocusResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SetPresenceRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "presence_state_setting", type: .prototype("PresenceStateSetting"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "dnd_setting", type: .prototype("DndSetting"), label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "desktop_off_setting", type: .prototype("DesktopOffSetting"), label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "mood_setting", type: .prototype("MoodSetting"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetPresenceRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is PresenceStateSetting? else { throw ProtoError.typeMismatchError }
			self.presenceStateSetting = value as! PresenceStateSetting?
		case 3:
			guard value == nil || value is DndSetting? else { throw ProtoError.typeMismatchError }
			self.dndSetting = value as! DndSetting?
		case 5:
			guard value == nil || value is DesktopOffSetting? else { throw ProtoError.typeMismatchError }
			self.desktopOffSetting = value as! DesktopOffSetting?
		case 8:
			guard value == nil || value is MoodSetting? else { throw ProtoError.typeMismatchError }
			self.moodSetting = value as! MoodSetting?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.presenceStateSetting
		case 3: return self.dndSetting
		case 5: return self.desktopOffSetting
		case 8: return self.moodSetting
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.presenceStateSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.dndSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.desktopOffSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.moodSetting._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var presenceStateSetting: PresenceStateSetting?
	public var dndSetting: DndSetting?
	public var desktopOffSetting: DesktopOffSetting?
	public var moodSetting: MoodSetting?
}

public struct SetPresenceResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetPresenceResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
}

public struct SetTypingRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "type", type: .prototype("TypingType"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetTypingRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is TypingType? else { throw ProtoError.typeMismatchError }
			self.type = value as! TypingType?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.conversationId
		case 3: return self.type
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.type._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var type: TypingType?
}

public struct SetTypingResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SetTypingResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.timestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.timestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.timestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var timestamp: UInt64?
}

public struct SyncAllNewEventsRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "last_sync_timestamp", type: .uint64, label: .optional),
		8: ProtoFieldDescriptor(id: 8, name: "max_response_size_bytes", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SyncAllNewEventsRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastSyncTimestamp = value as! UInt64?
		case 8:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxResponseSizeBytes = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.lastSyncTimestamp
		case 8: return self.maxResponseSizeBytes
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.lastSyncTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.maxResponseSizeBytes._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var lastSyncTimestamp: UInt64?
	public var maxResponseSizeBytes: UInt64?
}

public struct SyncAllNewEventsResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sync_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "conversation_state", type: .prototype("ConversationState"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SyncAllNewEventsResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.syncTimestamp = value as! UInt64?
		case 3:
			guard value is [ConversationState] else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! [ConversationState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [ConversationState] {
				self.conversationState.insert(contentsOf: value as! [ConversationState], at: index > 0 ? index : self.conversationState.endIndex)
			} else if value is ConversationState {
				self.conversationState.insert(value as! ConversationState, at: index > 0 ? index : self.conversationState.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.syncTimestamp
		case 3: return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.conversationState.endIndex else { throw ProtoError.unknownError }
			return self.conversationState[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.syncTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationState.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var syncTimestamp: UInt64?
	public var conversationState: [ConversationState] = []
}

public struct SyncRecentConversationsRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "max_conversations", type: .uint64, label: .optional),
		4: ProtoFieldDescriptor(id: 4, name: "max_events_per_conversation", type: .uint64, label: .optional),
		5: ProtoFieldDescriptor(id: 5, name: "sync_filter", type: .prototype("SyncFilter"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SyncRecentConversationsRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxConversations = value as! UInt64?
		case 4:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.maxEventsPerConversation = value as! UInt64?
		case 5:
			guard value is [SyncFilter] else { throw ProtoError.typeMismatchError }
			self.syncFilter = value as! [SyncFilter]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 5:
			if value is [SyncFilter] {
				self.syncFilter.insert(contentsOf: value as! [SyncFilter], at: index > 0 ? index : self.syncFilter.endIndex)
			} else if value is SyncFilter {
				self.syncFilter.insert(value as! SyncFilter, at: index > 0 ? index : self.syncFilter.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 3: return self.maxConversations
		case 4: return self.maxEventsPerConversation
		case 5: return self.syncFilter
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 5:
			guard index > 0 && index < self.syncFilter.endIndex else { throw ProtoError.unknownError }
			return self.syncFilter[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.maxConversations._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.maxEventsPerConversation._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.syncFilter.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var maxConversations: UInt64?
	public var maxEventsPerConversation: UInt64?
	public var syncFilter: [SyncFilter] = []
}

public struct SyncRecentConversationsResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "sync_timestamp", type: .uint64, label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "conversation_state", type: .prototype("ConversationState"), label: .repeated),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return SyncRecentConversationsResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		case 2:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.syncTimestamp = value as! UInt64?
		case 3:
			guard value is [ConversationState] else { throw ProtoError.typeMismatchError }
			self.conversationState = value as! [ConversationState]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		case 3:
			if value is [ConversationState] {
				self.conversationState.insert(contentsOf: value as! [ConversationState], at: index > 0 ? index : self.conversationState.endIndex)
			} else if value is ConversationState {
				self.conversationState.insert(value as! ConversationState, at: index > 0 ? index : self.conversationState.endIndex)
			} else {
				throw ProtoError.typeMismatchError
			}
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		case 2: return self.syncTimestamp
		case 3: return self.conversationState
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		case 3:
			guard index > 0 && index < self.conversationState.endIndex else { throw ProtoError.unknownError }
			return self.conversationState[index]
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.syncTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationState.forEach { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
	public var syncTimestamp: UInt64?
	public var conversationState: [ConversationState] = []
}

public struct UpdateWatermarkRequest: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "request_header", type: .prototype("RequestHeader"), label: .optional),
		2: ProtoFieldDescriptor(id: 2, name: "conversation_id", type: .prototype("ConversationId"), label: .optional),
		3: ProtoFieldDescriptor(id: 3, name: "last_read_timestamp", type: .uint64, label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return UpdateWatermarkRequest.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is RequestHeader? else { throw ProtoError.typeMismatchError }
			self.requestHeader = value as! RequestHeader?
		case 2:
			guard value == nil || value is ConversationId? else { throw ProtoError.typeMismatchError }
			self.conversationId = value as! ConversationId?
		case 3:
			guard value == nil || value is UInt64? else { throw ProtoError.typeMismatchError }
			self.lastReadTimestamp = value as! UInt64?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.requestHeader
		case 2: return self.conversationId
		case 3: return self.lastReadTimestamp
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.requestHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.conversationId._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		self.lastReadTimestamp._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var requestHeader: RequestHeader?
	public var conversationId: ConversationId?
	public var lastReadTimestamp: UInt64?
}

public struct UpdateWatermarkResponse: ProtoMessageExtensor {

	public init() {}
	public var _unknownFields = [Int: Any]()

	public static let __declaredFields: [Int: ProtoFieldDescriptor] = [
		1: ProtoFieldDescriptor(id: 1, name: "response_header", type: .prototype("ResponseHeader"), label: .optional),
	]
	public var _declaredFields: [Int: ProtoFieldDescriptor] {
		return UpdateWatermarkResponse.__declaredFields
	}

	public mutating func set(id: Int, value: Any?) throws {
		switch id {
		case 1:
			guard value == nil || value is ResponseHeader? else { throw ProtoError.typeMismatchError }
			self.responseHeader = value as! ResponseHeader?
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public mutating func set(id: Int, value: Any?, at index: Int) throws {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int) throws -> Any? {
		switch id {
		case 1: return self.responseHeader
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public func get(id: Int, at index: Int) throws -> Any? {
		switch id {
		default: throw ProtoError.fieldNameNotFoundError
		}
	}

	public var hashValue: Int {
		var hash = 7
		self.responseHeader._flatMap { hash = (hash &* 31) &+ $0.hashValue }
		return hash
	}

	public var responseHeader: ResponseHeader?
}

let _protoEnums: [String: ProtoEnum.Type] = [
	"ActiveClientState": ActiveClientState.self,
	"FocusType": FocusType.self,
	"FocusDevice": FocusDevice.self,
	"TypingType": TypingType.self,
	"ClientPresenceStateType": ClientPresenceStateType.self,
	"NotificationLevel": NotificationLevel.self,
	"SegmentType": SegmentType.self,
	"ItemType": ItemType.self,
	"MediaType": MediaType.self,
	"MembershipChangeType": MembershipChangeType.self,
	"HangoutEventType": HangoutEventType.self,
	"OffTheRecordToggle": OffTheRecordToggle.self,
	"OffTheRecordStatus": OffTheRecordStatus.self,
	"SourceType": SourceType.self,
	"EventType": EventType.self,
	"ConversationType": ConversationType.self,
	"ConversationStatus": ConversationStatus.self,
	"ConversationView": ConversationView.self,
	"DeliveryMediumType": DeliveryMediumType.self,
	"InvitationAffinity": InvitationAffinity.self,
	"ParticipantType": ParticipantType.self,
	"InvitationStatus": InvitationStatus.self,
	"ForceHistory": ForceHistory.self,
	"NetworkType": NetworkType.self,
	"BlockState": BlockState.self,
	"ReplyToInviteType": ReplyToInviteType.self,
	"ClientId": ClientId.self,
	"ClientBuildType": ClientBuildType.self,
	"ResponseStatus": ResponseStatus.self,
	"PastHangoutState": PastHangoutState.self,
	"PhotoUrlStatus": PhotoUrlStatus.self,
	"Gender": Gender.self,
	"ProfileType": ProfileType.self,
	"ConfigurationBitType": ConfigurationBitType.self,
	"RichPresenceType": RichPresenceType.self,
	"FieldMask": FieldMask.self,
	"DeleteType": DeleteType.self,
	"SyncFilter": SyncFilter.self,
	"SoundState": SoundState.self,
	"CallerIdSettingsMask": CallerIdSettingsMask.self,
	"PhoneVerificationStatus": PhoneVerificationStatus.self,
	"PhoneDiscoverabilityStatus": PhoneDiscoverabilityStatus.self,
	"PhoneValidationResult": PhoneValidationResult.self,
	"OffnetworkAddressType": OffnetworkAddressType.self,
]

let _protoMessages: [String: ProtoMessage.Type] = [
	"DoNotDisturbSetting": DoNotDisturbSetting.self,
	"NotificationSettings": NotificationSettings.self,
	"ConversationId": ConversationId.self,
	"ParticipantId": ParticipantId.self,
	"DeviceStatus": DeviceStatus.self,
	"LastSeen": LastSeen.self,
	"Presence": Presence.self,
	"PresenceResult": PresenceResult.self,
	"ClientIdentifier": ClientIdentifier.self,
	"ClientPresenceState": ClientPresenceState.self,
	"UserEventState": UserEventState.self,
	"Formatting": Formatting.self,
	"LinkData": LinkData.self,
	"Segment": Segment.self,
	"Thumbnail": Thumbnail.self,
	"PlusPhoto": PlusPhoto.self,
	"RepresentativeImage": RepresentativeImage.self,
	"Place": Place.self,
	"EmbedItem": EmbedItem.self,
	"Attachment": Attachment.self,
	"MessageContent": MessageContent.self,
	"EventAnnotation": EventAnnotation.self,
	"ChatMessage": ChatMessage.self,
	"MembershipChange": MembershipChange.self,
	"ConversationRename": ConversationRename.self,
	"HangoutEvent": HangoutEvent.self,
	"OTRModification": OTRModification.self,
	"HashModifier": HashModifier.self,
	"Event": Event.self,
	"UserReadState": UserReadState.self,
	"DeliveryMedium": DeliveryMedium.self,
	"DeliveryMediumOption": DeliveryMediumOption.self,
	"UserConversationState": UserConversationState.self,
	"ConversationParticipantData": ConversationParticipantData.self,
	"Conversation": Conversation.self,
	"EasterEgg": EasterEgg.self,
	"BlockStateChange": BlockStateChange.self,
	"Photo": Photo.self,
	"ExistingMedia": ExistingMedia.self,
	"EventRequestHeader": EventRequestHeader.self,
	"ClientVersion": ClientVersion.self,
	"RequestHeader": RequestHeader.self,
	"ResponseHeader": ResponseHeader.self,
	"Entity": Entity.self,
	"EntityProperties": EntityProperties.self,
	"ConversationState": ConversationState.self,
	"EventContinuationToken": EventContinuationToken.self,
	"EntityLookupSpec": EntityLookupSpec.self,
	"ConfigurationBit": ConfigurationBit.self,
	"RichPresenceState": RichPresenceState.self,
	"RichPresenceEnabledState": RichPresenceEnabledState.self,
	"DesktopOffSetting": DesktopOffSetting.self,
	"DesktopOffState": DesktopOffState.self,
	"DndSetting": DndSetting.self,
	"PresenceStateSetting": PresenceStateSetting.self,
	"MoodMessage": MoodMessage.self,
	"MoodContent": MoodContent.self,
	"MoodSetting": MoodSetting.self,
	"MoodState": MoodState.self,
	"DeleteAction": DeleteAction.self,
	"InviteeID": InviteeID.self,
	"Country": Country.self,
	"DesktopSoundSetting": DesktopSoundSetting.self,
	"PhoneData": PhoneData.self,
	"Phone": Phone.self,
	"I18nData": I18nData.self,
	"PhoneNumber": PhoneNumber.self,
	"SuggestedContactGroupHash": SuggestedContactGroupHash.self,
	"SuggestedContact": SuggestedContact.self,
	"SuggestedContactGroup": SuggestedContactGroup.self,
	"StateUpdate": StateUpdate.self,
	"StateUpdateHeader": StateUpdateHeader.self,
	"BatchUpdate": BatchUpdate.self,
	"ConversationNotification": ConversationNotification.self,
	"EventNotification": EventNotification.self,
	"SetFocusNotification": SetFocusNotification.self,
	"SetTypingNotification": SetTypingNotification.self,
	"SetConversationNotificationLevelNotification": SetConversationNotificationLevelNotification.self,
	"ReplyToInviteNotification": ReplyToInviteNotification.self,
	"WatermarkNotification": WatermarkNotification.self,
	"ConversationViewModification": ConversationViewModification.self,
	"EasterEggNotification": EasterEggNotification.self,
	"SelfPresenceNotification": SelfPresenceNotification.self,
	"DeleteActionNotification": DeleteActionNotification.self,
	"PresenceNotification": PresenceNotification.self,
	"BlockNotification": BlockNotification.self,
	"SetNotificationSettingNotification": SetNotificationSettingNotification.self,
	"RichPresenceEnabledStateNotification": RichPresenceEnabledStateNotification.self,
	"ConversationSpec": ConversationSpec.self,
	"OffnetworkAddress": OffnetworkAddress.self,
	"EntityResult": EntityResult.self,
	"AddUserRequest": AddUserRequest.self,
	"AddUserResponse": AddUserResponse.self,
	"CreateConversationRequest": CreateConversationRequest.self,
	"CreateConversationResponse": CreateConversationResponse.self,
	"DeleteConversationRequest": DeleteConversationRequest.self,
	"DeleteConversationResponse": DeleteConversationResponse.self,
	"EasterEggRequest": EasterEggRequest.self,
	"EasterEggResponse": EasterEggResponse.self,
	"GetConversationRequest": GetConversationRequest.self,
	"GetConversationResponse": GetConversationResponse.self,
	"GetEntityByIdRequest": GetEntityByIdRequest.self,
	"GetEntityByIdResponse": GetEntityByIdResponse.self,
	"GetSuggestedEntitiesRequest": GetSuggestedEntitiesRequest.self,
	"GetSuggestedEntitiesResponse": GetSuggestedEntitiesResponse.self,
	"GetSelfInfoRequest": GetSelfInfoRequest.self,
	"GetSelfInfoResponse": GetSelfInfoResponse.self,
	"QueryPresenceRequest": QueryPresenceRequest.self,
	"QueryPresenceResponse": QueryPresenceResponse.self,
	"RemoveUserRequest": RemoveUserRequest.self,
	"RemoveUserResponse": RemoveUserResponse.self,
	"RenameConversationRequest": RenameConversationRequest.self,
	"RenameConversationResponse": RenameConversationResponse.self,
	"SearchEntitiesRequest": SearchEntitiesRequest.self,
	"SearchEntitiesResponse": SearchEntitiesResponse.self,
	"SendChatMessageRequest": SendChatMessageRequest.self,
	"SendChatMessageResponse": SendChatMessageResponse.self,
	"SendOffnetworkInvitationRequest": SendOffnetworkInvitationRequest.self,
	"SendOffnetworkInvitationResponse": SendOffnetworkInvitationResponse.self,
	"SetActiveClientRequest": SetActiveClientRequest.self,
	"SetActiveClientResponse": SetActiveClientResponse.self,
	"SetConversationLevelRequest": SetConversationLevelRequest.self,
	"SetConversationLevelResponse": SetConversationLevelResponse.self,
	"SetConversationNotificationLevelRequest": SetConversationNotificationLevelRequest.self,
	"SetConversationNotificationLevelResponse": SetConversationNotificationLevelResponse.self,
	"SetFocusRequest": SetFocusRequest.self,
	"SetFocusResponse": SetFocusResponse.self,
	"SetPresenceRequest": SetPresenceRequest.self,
	"SetPresenceResponse": SetPresenceResponse.self,
	"SetTypingRequest": SetTypingRequest.self,
	"SetTypingResponse": SetTypingResponse.self,
	"SyncAllNewEventsRequest": SyncAllNewEventsRequest.self,
	"SyncAllNewEventsResponse": SyncAllNewEventsResponse.self,
	"SyncRecentConversationsRequest": SyncRecentConversationsRequest.self,
	"SyncRecentConversationsResponse": SyncRecentConversationsResponse.self,
	"UpdateWatermarkRequest": UpdateWatermarkRequest.self,
	"UpdateWatermarkResponse": UpdateWatermarkResponse.self,
]