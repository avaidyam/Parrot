public struct ActiveClientState: ProtoEnum {
    public static let NoActive: ActiveClientState = 0
    public static let IsActive: ActiveClientState = 1
    public static let OtherActive: ActiveClientState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct FocusType: ProtoEnum {
    public static let Unknown: FocusType = 0
    public static let Focused: FocusType = 1
    public static let Unfocused: FocusType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct FocusDevice: ProtoEnum {
    public static let Unspecified: FocusDevice = 0
    public static let Desktop: FocusDevice = 20
    public static let Mobile: FocusDevice = 300
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct TypingType: ProtoEnum {
    public static let Unknown: TypingType = 0
    public static let Started: TypingType = 1
    public static let Paused: TypingType = 2
    public static let Stopped: TypingType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientPresenceStateType: ProtoEnum {
    public static let Unknown: ClientPresenceStateType = 0
    public static let None: ClientPresenceStateType = 1
    public static let DesktopIdle: ClientPresenceStateType = 30
    public static let DesktopActive: ClientPresenceStateType = 40
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct NotificationLevel: ProtoEnum {
    public static let Unknown: NotificationLevel = 0
    public static let Quiet: NotificationLevel = 10
    public static let Ring: NotificationLevel = 30
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct SegmentType: ProtoEnum {
    public static let Text: SegmentType = 0
    public static let LineBreak: SegmentType = 1
    public static let Link: SegmentType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ItemType: ProtoEnum {
    public static let Thing: ItemType = 0
    public static let PlusPhoto: ItemType = 249
    public static let Place: ItemType = 335
    public static let PlaceV2: ItemType = 340
    public static let VoicePhoto: ItemType = 438
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct MediaType: ProtoEnum {
    public static let Unknown: MediaType = 0
    public static let Photo: MediaType = 1
    public static let AnimatedPhoto: MediaType = 4
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct MembershipChangeType: ProtoEnum {
    public static let Join: MembershipChangeType = 1
    public static let Leave: MembershipChangeType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct HangoutEventType: ProtoEnum {
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

public struct OffTheRecordToggle: ProtoEnum {
    public static let Unknown: OffTheRecordToggle = 0
    public static let Enabled: OffTheRecordToggle = 1
    public static let Disabled: OffTheRecordToggle = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct OffTheRecordStatus: ProtoEnum {
    public static let Unknown: OffTheRecordStatus = 0
    public static let OffTheRecord: OffTheRecordStatus = 1
    public static let OnTheRecord: OffTheRecordStatus = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct SourceType: ProtoEnum {
    public static let Unknown: SourceType = 0
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct EventType: ProtoEnum {
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

public struct ConversationType: ProtoEnum {
    public static let Unknown: ConversationType = 0
    public static let OneToOne: ConversationType = 1
    public static let Group: ConversationType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ConversationStatus: ProtoEnum {
    public static let Unknown: ConversationStatus = 0
    public static let Invited: ConversationStatus = 1
    public static let Active: ConversationStatus = 2
    public static let Left: ConversationStatus = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ConversationView: ProtoEnum {
    public static let Unknown: ConversationView = 0
    public static let Inbox: ConversationView = 1
    public static let Archived: ConversationView = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct DeliveryMediumType: ProtoEnum {
    public static let Unknown: DeliveryMediumType = 0
    public static let Babel: DeliveryMediumType = 1
    public static let GoogleVoice: DeliveryMediumType = 2
    public static let LocalSms: DeliveryMediumType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct InvitationAffinity: ProtoEnum {
    public static let Unknown: InvitationAffinity = 0
    public static let High: InvitationAffinity = 1
    public static let Low: InvitationAffinity = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ParticipantType: ProtoEnum {
    public static let Unknown: ParticipantType = 0
    public static let Gaia: ParticipantType = 2
    public static let GoogleVoice: ParticipantType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct InvitationStatus: ProtoEnum {
    public static let Unknown: InvitationStatus = 0
    public static let Pending: InvitationStatus = 1
    public static let Accepted: InvitationStatus = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ForceHistory: ProtoEnum {
    public static let Unknown: ForceHistory = 0
    public static let No: ForceHistory = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct NetworkType: ProtoEnum {
    public static let Unknown: NetworkType = 0
    public static let Babel: NetworkType = 1
    public static let GoogleVoice: NetworkType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct BlockState: ProtoEnum {
    public static let Unknown: BlockState = 0
    public static let Block: BlockState = 1
    public static let Unblock: BlockState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ReplyToInviteType: ProtoEnum {
    public static let Unknown: ReplyToInviteType = 0
    public static let Accept: ReplyToInviteType = 1
    public static let Decline: ReplyToInviteType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientId: ProtoEnum {
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

public struct ClientBuildType: ProtoEnum {
    public static let Unknown: ClientBuildType = 0
    public static let ProductionWeb: ClientBuildType = 1
    public static let ProductionApp: ClientBuildType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ResponseStatus: ProtoEnum {
    public static let Unknown: ResponseStatus = 0
    public static let Ok: ResponseStatus = 1
    public static let UnexpectedError: ResponseStatus = 3
    public static let InvalidRequest: ResponseStatus = 4
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct PastHangoutState: ProtoEnum {
    public static let Unknown: PastHangoutState = 0
    public static let HadPastHangout: PastHangoutState = 1
    public static let NoPastHangout: PastHangoutState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct PhotoUrlStatus: ProtoEnum {
    public static let Unknown: PhotoUrlStatus = 0
    public static let Placeholder: PhotoUrlStatus = 1
    public static let UserPhoto: PhotoUrlStatus = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct Gender: ProtoEnum {
    public static let Unknown: Gender = 0
    public static let Male: Gender = 1
    public static let Female: Gender = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ProfileType: ProtoEnum {
    public static let None: ProfileType = 0
    public static let EsUser: ProfileType = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ConfigurationBitType: ProtoEnum {
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

public struct RichPresenceType: ProtoEnum {
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

public struct FieldMask: ProtoEnum {
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

public struct DeleteType: ProtoEnum {
    public static let Unknown: DeleteType = 0
    public static let UpperBound: DeleteType = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct SyncFilter: ProtoEnum {
    public static let Unknown: SyncFilter = 0
    public static let Inbox: SyncFilter = 1
    public static let Archived: SyncFilter = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct SoundState: ProtoEnum {
    public static let Unknown: SoundState = 0
    public static let On: SoundState = 1
    public static let Off: SoundState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct CallerIdSettingsMask: ProtoEnum {
    public static let Unknown: CallerIdSettingsMask = 0
    public static let Provided: CallerIdSettingsMask = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct PhoneVerificationStatus: ProtoEnum {
    public static let Unknown: PhoneVerificationStatus = 0
    public static let Verified: PhoneVerificationStatus = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct PhoneDiscoverabilityStatus: ProtoEnum {
    public static let Unknown: PhoneDiscoverabilityStatus = 0
    public static let OptedInButNotDiscoverable: PhoneDiscoverabilityStatus = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct PhoneValidationResult: ProtoEnum {
    public static let IsPossible: PhoneValidationResult = 0
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct OffnetworkAddressType: ProtoEnum {
    public static let Unknown: OffnetworkAddressType = 0
    public static let Email: OffnetworkAddressType = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct DoNotDisturbSetting: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case do_not_disturb = 1
        case expiration_timestamp = 2
        case version = 3
    }
    
    public var do_not_disturb: Bool?
    public var expiration_timestamp: UInt64?
    public var version: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.do_not_disturb.hash(), self.expiration_timestamp.hash(), self.version.hash(), ])
    }
}

public struct NotificationSettings: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case dnd_settings = 1
    }
    
    public var dnd_settings: DoNotDisturbSetting?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.dnd_settings.hash(), ])
    }
}

public struct ConversationId: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case id = 1
    }
    
    public var id: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.id.hash(), ])
    }
}

public struct ParticipantId: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case gaia_id = 1
        case chat_id = 2
    }
    
    public var gaia_id: String?
    public var chat_id: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.gaia_id.hash(), self.chat_id.hash(), ])
    }
}

public struct DeviceStatus: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case mobile = 1
        case desktop = 2
        case tablet = 3
    }
    
    public var mobile: Bool?
    public var desktop: Bool?
    public var tablet: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.mobile.hash(), self.desktop.hash(), self.tablet.hash(), ])
    }
}

public struct LastSeen: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case last_seen_timestamp_usec = 1
    }
    
    public var last_seen_timestamp_usec: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.last_seen_timestamp_usec.hash(), ])
    }
}

public struct Presence: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case reachable = 1
        case available = 2
        case device_status = 6
        case mood_setting = 9
        case last_seen = 10
    }
    
    public var reachable: Bool?
    public var available: Bool?
    public var device_status: DeviceStatus?
    public var mood_setting: MoodSetting?
    public var last_seen: LastSeen?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.reachable.hash(), self.available.hash(), self.device_status.hash(), self.mood_setting.hash(), self.last_seen.hash(), ])
    }
}

public struct PresenceResult: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case user_id = 1
        case presence = 2
    }
    
    public var user_id: ParticipantId?
    public var presence: Presence?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.user_id.hash(), self.presence.hash(), ])
    }
}

public struct ClientIdentifier: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case resource = 1
        case header_id = 2
    }
    
    public var resource: String?
    public var header_id: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.resource.hash(), self.header_id.hash(), ])
    }
}

public struct ClientPresenceState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case identifier = 1
        case state = 2
    }
    
    public var identifier: ClientIdentifier?
    public var state: ClientPresenceStateType?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.identifier.hash(), self.state.hash(), ])
    }
}

public struct UserEventState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case user_id = 1
        case client_generated_id = 2
        case notification_level = 3
    }
    
    public var user_id: ParticipantId?
    public var client_generated_id: String?
    public var notification_level: NotificationLevel?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.user_id.hash(), self.client_generated_id.hash(), self.notification_level.hash(), ])
    }
}

public struct Formatting: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case bold = 1
        case italic = 2
        case strikethrough = 3
        case underline = 4
    }
    
    public var bold: Bool?
    public var italic: Bool?
    public var strikethrough: Bool?
    public var underline: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.bold.hash(), self.italic.hash(), self.strikethrough.hash(), self.underline.hash(), ])
    }
}

public struct LinkData: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case link_target = 1
    }
    
    public var link_target: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.link_target.hash(), ])
    }
}

public struct Segment: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case text = 2
        case formatting = 3
        case link_data = 4
    }
    
    public var type: SegmentType!
    public var text: String?
    public var formatting: Formatting?
    public var link_data: LinkData?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.text.hash(), self.formatting.hash(), self.link_data.hash(), ])
    }
}

public struct Thumbnail: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case url = 1
        case image_url = 4
        case width_px = 10
        case height_px = 11
    }
    
    public var url: String?
    public var image_url: String?
    public var width_px: UInt64?
    public var height_px: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash(), self.image_url.hash(), self.width_px.hash(), self.height_px.hash(), ])
    }
}

public struct PlusPhoto: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case thumbnail = 1
        case owner_obfuscated_id = 2
        case album_id = 3
        case photo_id = 4
        case url = 6
        case original_content_url = 10
        case media_type = 13
        case stream_id = 14
    }
    
    public var thumbnail: Thumbnail?
    public var owner_obfuscated_id: String?
    public var album_id: String?
    public var photo_id: String?
    public var url: String?
    public var original_content_url: String?
    public var media_type: MediaType?
    public var stream_id: [String] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.thumbnail.hash(), self.owner_obfuscated_id.hash(), self.album_id.hash(), self.photo_id.hash(), self.url.hash(), self.original_content_url.hash(), self.media_type.hash(), self.stream_id.hash(), ])
    }
}

public struct VoicePhoto: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case url = 1
    }
    
    public var url: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash(), ])
    }
}

public struct RepresentativeImage: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case url = 2
    }
    
    public var url: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash(), ])
    }
}

public struct Place: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case url = 1
        case name = 3
        case representative_image = 185
    }
    
    public var url: String?
    public var name: String?
    public var representative_image: RepresentativeImage?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash(), self.name.hash(), self.representative_image.hash(), ])
    }
}

public struct EmbedItem: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case id = 2
        case plus_photo = 27639957
        case place = 35825640
        case voice_photo = 62101782
    }
    
    public var type: [ItemType] = []
    public var id: String?
    public var plus_photo: PlusPhoto?
    public var place: Place?
    public var voice_photo: VoicePhoto?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.id.hash(), self.plus_photo.hash(), self.place.hash(), self.voice_photo.hash(), ])
    }
}

public struct Attachment: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case embed_item = 1
    }
    
    public var embed_item: EmbedItem?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.embed_item.hash(), ])
    }
}

public struct MessageContent: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case segment = 1
        case attachment = 2
    }
    
    public var segment: [Segment] = []
    public var attachment: [Attachment] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.segment.hash(), self.attachment.hash(), ])
    }
}

public struct EventAnnotation: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case value = 2
    }
    
    public var type: Int32?
    public var value: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.value.hash(), ])
    }
}

public struct ChatMessage: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case annotation = 2
        case message_content = 3
    }
    
    public var annotation: [EventAnnotation] = []
    public var message_content: MessageContent?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.annotation.hash(), self.message_content.hash(), ])
    }
}

public struct MembershipChange: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case participant_ids = 3
    }
    
    public var type: MembershipChangeType?
    public var participant_ids: [ParticipantId] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.participant_ids.hash(), ])
    }
}

public struct ConversationRename: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case new_name = 1
        case old_name = 2
    }
    
    public var new_name: String?
    public var old_name: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.new_name.hash(), self.old_name.hash(), ])
    }
}

public struct HangoutEvent: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case event_type = 1
        case participant_id = 2
    }
    
    public var event_type: HangoutEventType?
    public var participant_id: [ParticipantId] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.event_type.hash(), self.participant_id.hash(), ])
    }
}

public struct OTRModification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case old_otr_status = 1
        case new_otr_status = 2
        case old_otr_toggle = 3
        case new_otr_toggle = 4
    }
    
    public var old_otr_status: OffTheRecordStatus?
    public var new_otr_status: OffTheRecordStatus?
    public var old_otr_toggle: OffTheRecordToggle?
    public var new_otr_toggle: OffTheRecordToggle?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.old_otr_status.hash(), self.new_otr_status.hash(), self.old_otr_toggle.hash(), self.new_otr_toggle.hash(), ])
    }
}

public struct HashModifier: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case update_id = 1
        case hash_diff = 2
        case version = 4
    }
    
    public var update_id: String?
    public var hash_diff: UInt64?
    public var version: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.update_id.hash(), self.hash_diff.hash(), self.version.hash(), ])
    }
}

public struct Event: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case sender_id = 2
        case timestamp = 3
        case self_event_state = 4
        case source_type = 6
        case chat_message = 7
        case membership_change = 9
        case conversation_rename = 10
        case hangout_event = 11
        case event_id = 12
        case expiration_timestamp = 13
        case otr_modification = 14
        case advances_sort_timestamp = 15
        case otr_status = 16
        case persisted = 17
        case medium_type = 20
        case event_type = 23
        case event_version = 24
        case hash_modifier = 26
    }
    
    public var conversation_id: ConversationId?
    public var sender_id: ParticipantId?
    public var timestamp: UInt64?
    public var self_event_state: UserEventState?
    public var source_type: SourceType?
    public var chat_message: ChatMessage?
    public var membership_change: MembershipChange?
    public var conversation_rename: ConversationRename?
    public var hangout_event: HangoutEvent?
    public var event_id: String?
    public var expiration_timestamp: UInt64?
    public var otr_modification: OTRModification?
    public var advances_sort_timestamp: Bool?
    public var otr_status: OffTheRecordStatus?
    public var persisted: Bool?
    public var medium_type: DeliveryMedium?
    public var event_type: EventType?
    public var event_version: UInt64?
    public var hash_modifier: HashModifier?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.sender_id.hash(), self.timestamp.hash(), self.self_event_state.hash(), self.source_type.hash(), self.chat_message.hash(), self.membership_change.hash(), self.conversation_rename.hash(), self.hangout_event.hash(), self.event_id.hash(), self.expiration_timestamp.hash(), self.otr_modification.hash(), self.advances_sort_timestamp.hash(), self.otr_status.hash(), self.persisted.hash(), self.medium_type.hash(), self.event_type.hash(), self.event_version.hash(), self.hash_modifier.hash(), ])
    }
}

public struct UserReadState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case participant_id = 1
        case latest_read_timestamp = 2
    }
    
    public var participant_id: ParticipantId?
    public var latest_read_timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.participant_id.hash(), self.latest_read_timestamp.hash(), ])
    }
}

public struct DeliveryMedium: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case medium_type = 1
        case phone_number = 2
    }
    
    public var medium_type: DeliveryMediumType?
    public var phone_number: PhoneNumber?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.medium_type.hash(), self.phone_number.hash(), ])
    }
}

public struct DeliveryMediumOption: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case delivery_medium = 1
        case current_default = 2
    }
    
    public var delivery_medium: DeliveryMedium?
    public var current_default: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.delivery_medium.hash(), self.current_default.hash(), ])
    }
}

public struct UserConversationState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case client_generated_id = 2
        case self_read_state = 7
        case status = 8
        case notification_level = 9
        case view = 10
        case inviter_id = 11
        case invite_timestamp = 12
        case sort_timestamp = 13
        case active_timestamp = 14
        case invite_affinity = 15
        case delivery_medium_option = 17
    }
    
    public var client_generated_id: String?
    public var self_read_state: UserReadState?
    public var status: ConversationStatus?
    public var notification_level: NotificationLevel?
    public var view: [ConversationView] = []
    public var inviter_id: ParticipantId?
    public var invite_timestamp: UInt64?
    public var sort_timestamp: UInt64?
    public var active_timestamp: UInt64?
    public var invite_affinity: InvitationAffinity?
    public var delivery_medium_option: [DeliveryMediumOption] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.client_generated_id.hash(), self.self_read_state.hash(), self.status.hash(), self.notification_level.hash(), self.view.hash(), self.inviter_id.hash(), self.invite_timestamp.hash(), self.sort_timestamp.hash(), self.active_timestamp.hash(), self.invite_affinity.hash(), self.delivery_medium_option.hash(), ])
    }
}

public struct ConversationParticipantData: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case id = 1
        case fallback_name = 2
        case invitation_status = 3
        case participant_type = 5
        case new_invitation_status = 6
    }
    
    public var id: ParticipantId?
    public var fallback_name: String?
    public var invitation_status: InvitationStatus?
    public var participant_type: ParticipantType?
    public var new_invitation_status: InvitationStatus?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.id.hash(), self.fallback_name.hash(), self.invitation_status.hash(), self.participant_type.hash(), self.new_invitation_status.hash(), ])
    }
}

public struct Conversation: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case type = 2
        case name = 3
        case self_conversation_state = 4
        case read_state = 8
        case has_active_hangout = 9
        case otr_status = 10
        case otr_toggle = 11
        case conversation_history_supported = 12
        case current_participant = 13
        case participant_data = 14
        case network_type = 18
        case force_history_state = 19
    }
    
    public var conversation_id: ConversationId?
    public var type: ConversationType?
    public var name: String?
    public var self_conversation_state: UserConversationState?
    public var read_state: [UserReadState] = []
    public var has_active_hangout: Bool?
    public var otr_status: OffTheRecordStatus?
    public var otr_toggle: OffTheRecordToggle?
    public var conversation_history_supported: Bool?
    public var current_participant: [ParticipantId] = []
    public var participant_data: [ConversationParticipantData] = []
    public var network_type: [NetworkType] = []
    public var force_history_state: ForceHistory?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.type.hash(), self.name.hash(), self.self_conversation_state.hash(), self.read_state.hash(), self.has_active_hangout.hash(), self.otr_status.hash(), self.otr_toggle.hash(), self.conversation_history_supported.hash(), self.current_participant.hash(), self.participant_data.hash(), self.network_type.hash(), self.force_history_state.hash(), ])
    }
}

public struct EasterEgg: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case message = 1
    }
    
    public var message: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.message.hash(), ])
    }
}

public struct BlockStateChange: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case participant_id = 1
        case new_block_state = 2
    }
    
    public var participant_id: ParticipantId?
    public var new_block_state: BlockState?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.participant_id.hash(), self.new_block_state.hash(), ])
    }
}

public struct Photo: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case photo_id = 1
        case delete_albumless_source_photo = 2
        case user_id = 3
        case is_custom_user_id = 4
    }
    
    public var photo_id: String?
    public var delete_albumless_source_photo: Bool?
    public var user_id: String?
    public var is_custom_user_id: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.photo_id.hash(), self.delete_albumless_source_photo.hash(), self.user_id.hash(), self.is_custom_user_id.hash(), ])
    }
}

public struct ExistingMedia: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case photo = 1
    }
    
    public var photo: Photo?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.photo.hash(), ])
    }
}

public struct EventRequestHeader: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case client_generated_id = 2
        case expected_otr = 3
        case delivery_medium = 4
        case event_type = 5
    }
    
    public var conversation_id: ConversationId?
    public var client_generated_id: UInt64?
    public var expected_otr: OffTheRecordStatus?
    public var delivery_medium: DeliveryMedium?
    public var event_type: EventType?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.client_generated_id.hash(), self.expected_otr.hash(), self.delivery_medium.hash(), self.event_type.hash(), ])
    }
}

public struct ClientVersion: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case client_id = 1
        case build_type = 2
        case major_version = 3
        case version_timestamp = 4
        case device_os_version = 5
        case device_hardware = 6
    }
    
    public var client_id: ClientId?
    public var build_type: ClientBuildType?
    public var major_version: String?
    public var version_timestamp: UInt64?
    public var device_os_version: String?
    public var device_hardware: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.client_id.hash(), self.build_type.hash(), self.major_version.hash(), self.version_timestamp.hash(), self.device_os_version.hash(), self.device_hardware.hash(), ])
    }
}

public struct RequestHeader: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case client_version = 1
        case client_identifier = 2
        case language_code = 4
    }
    
    public var client_version: ClientVersion?
    public var client_identifier: ClientIdentifier?
    public var language_code: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.client_version.hash(), self.client_identifier.hash(), self.language_code.hash(), ])
    }
}

public struct ResponseHeader: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case status = 1
        case error_description = 2
        case debug_url = 3
        case request_trace_id = 4
        case current_server_time = 5
    }
    
    public var status: ResponseStatus?
    public var error_description: String?
    public var debug_url: String?
    public var request_trace_id: String?
    public var current_server_time: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.status.hash(), self.error_description.hash(), self.debug_url.hash(), self.request_trace_id.hash(), self.current_server_time.hash(), ])
    }
}

public struct Entity: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case id = 9
        case presence = 8
        case properties = 10
        case entity_type = 13
        case had_past_hangout_state = 16
    }
    
    public var id: ParticipantId?
    public var presence: Presence?
    public var properties: EntityProperties?
    public var entity_type: ParticipantType?
    public var had_past_hangout_state: PastHangoutState?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.id.hash(), self.presence.hash(), self.properties.hash(), self.entity_type.hash(), self.had_past_hangout_state.hash(), ])
    }
}

public struct EntityProperties: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case display_name = 2
        case first_name = 3
        case photo_url = 4
        case email = 5
        case phone = 6
        case in_users_domain = 10
        case gender = 11
        case photo_url_status = 12
        case phones = 14
        case canonical_email = 15
    }
    
    public var type: ProfileType?
    public var display_name: String?
    public var first_name: String?
    public var photo_url: String?
    public var email: [String] = []
    public var phone: [String] = []
    public var in_users_domain: Bool?
    public var gender: Gender?
    public var photo_url_status: PhotoUrlStatus?
    public var phones: [Phone] = []
    public var canonical_email: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.display_name.hash(), self.first_name.hash(), self.photo_url.hash(), self.email.hash(), self.phone.hash(), self.in_users_domain.hash(), self.gender.hash(), self.photo_url_status.hash(), self.phones.hash(), self.canonical_email.hash(), ])
    }
}

public struct ConversationState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case conversation = 2
        case event = 3
        case event_continuation_token = 5
    }
    
    public var conversation_id: ConversationId?
    public var conversation: Conversation?
    public var event: [Event] = []
    public var event_continuation_token: EventContinuationToken?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.conversation.hash(), self.event.hash(), self.event_continuation_token.hash(), ])
    }
}

public struct EventContinuationToken: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case event_id = 1
        case storage_continuation_token = 2
        case event_timestamp = 3
    }
    
    public var event_id: String?
    public var storage_continuation_token: String?
    public var event_timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.event_id.hash(), self.storage_continuation_token.hash(), self.event_timestamp.hash(), ])
    }
}

public struct EntityLookupSpec: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case gaia_id = 1
        case email = 3
        case phone = 4
        case create_offnetwork_gaia = 6
    }
    
    public var gaia_id: String?
    public var email: String?
    public var phone: String?
    public var create_offnetwork_gaia: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.gaia_id.hash(), self.email.hash(), self.phone.hash(), self.create_offnetwork_gaia.hash(), ])
    }
}

public struct ConfigurationBit: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case configuration_bit_type = 1
        case value = 2
    }
    
    public var configuration_bit_type: ConfigurationBitType?
    public var value: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.configuration_bit_type.hash(), self.value.hash(), ])
    }
}

public struct RichPresenceState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case get_rich_presence_enabled_state = 3
    }
    
    public var get_rich_presence_enabled_state: [RichPresenceEnabledState] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.get_rich_presence_enabled_state.hash(), ])
    }
}

public struct RichPresenceEnabledState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case enabled = 2
    }
    
    public var type: RichPresenceType?
    public var enabled: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.enabled.hash(), ])
    }
}

public struct DesktopOffSetting: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case desktop_off = 1
    }
    
    public var desktop_off: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.desktop_off.hash(), ])
    }
}

public struct DesktopOffState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case desktop_off = 1
        case version = 2
    }
    
    public var desktop_off: Bool?
    public var version: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.desktop_off.hash(), self.version.hash(), ])
    }
}

public struct DndSetting: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case do_not_disturb = 1
        case timeout_secs = 2
    }
    
    public var do_not_disturb: Bool?
    public var timeout_secs: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.do_not_disturb.hash(), self.timeout_secs.hash(), ])
    }
}

public struct PresenceStateSetting: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case timeout_secs = 1
        case type = 2
    }
    
    public var timeout_secs: UInt64?
    public var type: ClientPresenceStateType?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.timeout_secs.hash(), self.type.hash(), ])
    }
}

public struct MoodMessage: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case mood_content = 1
    }
    
    public var mood_content: MoodContent?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.mood_content.hash(), ])
    }
}

public struct MoodContent: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case segment = 1
    }
    
    public var segment: [Segment] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.segment.hash(), ])
    }
}

public struct MoodSetting: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case mood_message = 1
    }
    
    public var mood_message: MoodMessage?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.mood_message.hash(), ])
    }
}

public struct MoodState: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case mood_setting = 4
    }
    
    public var mood_setting: MoodSetting?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.mood_setting.hash(), ])
    }
}

public struct DeleteAction: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case delete_action_timestamp = 1
        case delete_upper_bound_timestamp = 2
        case delete_type = 3
    }
    
    public var delete_action_timestamp: UInt64?
    public var delete_upper_bound_timestamp: UInt64?
    public var delete_type: DeleteType?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.delete_action_timestamp.hash(), self.delete_upper_bound_timestamp.hash(), self.delete_type.hash(), ])
    }
}

public struct InviteeID: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case gaia_id = 1
        case fallback_name = 4
    }
    
    public var gaia_id: String?
    public var fallback_name: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.gaia_id.hash(), self.fallback_name.hash(), ])
    }
}

public struct Country: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case region_code = 1
        case country_code = 2
    }
    
    public var region_code: String?
    public var country_code: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.region_code.hash(), self.country_code.hash(), ])
    }
}

public struct DesktopSoundSetting: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case desktop_sound_state = 1
        case desktop_ring_sound_state = 2
    }
    
    public var desktop_sound_state: SoundState?
    public var desktop_ring_sound_state: SoundState?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.desktop_sound_state.hash(), self.desktop_ring_sound_state.hash(), ])
    }
}

public struct PhoneData: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case phone = 1
        case caller_id_settings_mask = 3
    }
    
    public var phone: [Phone] = []
    public var caller_id_settings_mask: CallerIdSettingsMask?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.phone.hash(), self.caller_id_settings_mask.hash(), ])
    }
}

public struct Phone: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case phone_number = 1
        case google_voice = 2
        case verification_status = 3
        case discoverable = 4
        case discoverability_status = 5
        case primary = 6
    }
    
    public var phone_number: PhoneNumber?
    public var google_voice: Bool?
    public var verification_status: PhoneVerificationStatus?
    public var discoverable: Bool?
    public var discoverability_status: PhoneDiscoverabilityStatus?
    public var primary: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.phone_number.hash(), self.google_voice.hash(), self.verification_status.hash(), self.discoverable.hash(), self.discoverability_status.hash(), self.primary.hash(), ])
    }
}

public struct I18nData: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case national_number = 1
        case international_number = 2
        case country_code = 3
        case region_code = 4
        case is_valid = 5
        case validation_result = 6
    }
    
    public var national_number: String?
    public var international_number: String?
    public var country_code: UInt64?
    public var region_code: String?
    public var is_valid: Bool?
    public var validation_result: PhoneValidationResult?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.national_number.hash(), self.international_number.hash(), self.country_code.hash(), self.region_code.hash(), self.is_valid.hash(), self.validation_result.hash(), ])
    }
}

public struct PhoneNumber: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case e164 = 1
        case i18n_data = 2
    }
    
    public var e164: String?
    public var i18n_data: I18nData?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.e164.hash(), self.i18n_data.hash(), ])
    }
}

public struct SuggestedContactGroupHash: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case max_results = 1
        case hash = 2
    }
    
    public var max_results: UInt64?
    public var hash: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.max_results.hash(), self.hash.hash(), ])
    }
}

public struct SuggestedContact: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case entity = 1
        case invitation_status = 2
    }
    
    public var entity: Entity?
    public var invitation_status: InvitationStatus?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.entity.hash(), self.invitation_status.hash(), ])
    }
}

public struct SuggestedContactGroup: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case hash_matched = 1
        case hash = 2
        case contact = 3
    }
    
    public var hash_matched: Bool?
    public var hash: String?
    public var contact: [SuggestedContact] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.hash_matched.hash(), self.hash.hash(), self.contact.hash(), ])
    }
}

public struct StateUpdate: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case state_update_header = 1
        case conversation = 13
        case conversation_notification = 2
        case event_notification = 3
        case focus_notification = 4
        case typing_notification = 5
        case notification_level_notification = 6
        case reply_to_invite_notification = 7
        case watermark_notification = 8
        case view_modification = 11
        case easter_egg_notification = 12
        case self_presence_notification = 14
        case delete_notification = 15
        case presence_notification = 16
        case block_notification = 17
        case notification_setting_notification = 19
        case rich_presence_enabled_state_notification = 20
    }
    
    public var state_update_header: StateUpdateHeader?
    public var conversation: Conversation?
    public var conversation_notification: ConversationNotification?
    public var event_notification: EventNotification?
    public var focus_notification: SetFocusNotification?
    public var typing_notification: SetTypingNotification?
    public var notification_level_notification: SetConversationNotificationLevelNotification?
    public var reply_to_invite_notification: ReplyToInviteNotification?
    public var watermark_notification: WatermarkNotification?
    public var view_modification: ConversationViewModification?
    public var easter_egg_notification: EasterEggNotification?
    public var self_presence_notification: SelfPresenceNotification?
    public var delete_notification: DeleteActionNotification?
    public var presence_notification: PresenceNotification?
    public var block_notification: BlockNotification?
    public var notification_setting_notification: SetNotificationSettingNotification?
    public var rich_presence_enabled_state_notification: RichPresenceEnabledStateNotification?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.state_update_header.hash(), self.conversation.hash(), self.conversation_notification.hash(), self.event_notification.hash(), self.focus_notification.hash(), self.typing_notification.hash(), self.notification_level_notification.hash(), self.reply_to_invite_notification.hash(), self.watermark_notification.hash(), self.view_modification.hash(), self.easter_egg_notification.hash(), self.self_presence_notification.hash(), self.delete_notification.hash(), self.presence_notification.hash(), self.block_notification.hash(), self.notification_setting_notification.hash(), self.rich_presence_enabled_state_notification.hash(), ])
    }
}

public struct StateUpdateHeader: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case active_client_state = 1
        case request_trace_id = 3
        case notification_settings = 4
        case current_server_time = 5
    }
    
    public var active_client_state: ActiveClientState?
    public var request_trace_id: String?
    public var notification_settings: NotificationSettings?
    public var current_server_time: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.active_client_state.hash(), self.request_trace_id.hash(), self.notification_settings.hash(), self.current_server_time.hash(), ])
    }
}

public struct BatchUpdate: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case state_update = 1
    }
    
    public var state_update: [StateUpdate] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.state_update.hash(), ])
    }
}

public struct ConversationNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation = 1
    }
    
    public var conversation: Conversation?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation.hash(), ])
    }
}

public struct EventNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case event = 1
    }
    
    public var event: Event?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.event.hash(), ])
    }
}

public struct SetFocusNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case sender_id = 2
        case timestamp = 3
        case type = 4
        case device = 5
    }
    
    public var conversation_id: ConversationId?
    public var sender_id: ParticipantId?
    public var timestamp: UInt64?
    public var type: FocusType?
    public var device: FocusDevice?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.sender_id.hash(), self.timestamp.hash(), self.type.hash(), self.device.hash(), ])
    }
}

public struct SetTypingNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case sender_id = 2
        case timestamp = 3
        case type = 4
    }
    
    public var conversation_id: ConversationId?
    public var sender_id: ParticipantId?
    public var timestamp: UInt64?
    public var type: TypingType?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.sender_id.hash(), self.timestamp.hash(), self.type.hash(), ])
    }
}

public struct SetConversationNotificationLevelNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case level = 2
        case timestamp = 4
    }
    
    public var conversation_id: ConversationId?
    public var level: NotificationLevel?
    public var timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.level.hash(), self.timestamp.hash(), ])
    }
}

public struct ReplyToInviteNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case type = 2
    }
    
    public var conversation_id: ConversationId?
    public var type: ReplyToInviteType?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.type.hash(), ])
    }
}

public struct WatermarkNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case sender_id = 1
        case conversation_id = 2
        case latest_read_timestamp = 3
    }
    
    public var sender_id: ParticipantId?
    public var conversation_id: ConversationId?
    public var latest_read_timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.sender_id.hash(), self.conversation_id.hash(), self.latest_read_timestamp.hash(), ])
    }
}

public struct ConversationViewModification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case old_view = 2
        case new_view = 3
    }
    
    public var conversation_id: ConversationId?
    public var old_view: ConversationView?
    public var new_view: ConversationView?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.old_view.hash(), self.new_view.hash(), ])
    }
}

public struct EasterEggNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case sender_id = 1
        case conversation_id = 2
        case easter_egg = 3
    }
    
    public var sender_id: ParticipantId?
    public var conversation_id: ConversationId?
    public var easter_egg: EasterEgg?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.sender_id.hash(), self.conversation_id.hash(), self.easter_egg.hash(), ])
    }
}

public struct SelfPresenceNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case client_presence_state = 1
        case do_not_disturb_setting = 3
        case desktop_off_setting = 4
        case desktop_off_state = 5
        case mood_state = 6
    }
    
    public var client_presence_state: ClientPresenceState?
    public var do_not_disturb_setting: DoNotDisturbSetting?
    public var desktop_off_setting: DesktopOffSetting?
    public var desktop_off_state: DesktopOffState?
    public var mood_state: MoodState?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.client_presence_state.hash(), self.do_not_disturb_setting.hash(), self.desktop_off_setting.hash(), self.desktop_off_state.hash(), self.mood_state.hash(), ])
    }
}

public struct DeleteActionNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case delete_action = 2
    }
    
    public var conversation_id: ConversationId?
    public var delete_action: DeleteAction?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.delete_action.hash(), ])
    }
}

public struct PresenceNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case presence = 1
    }
    
    public var presence: [PresenceResult] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.presence.hash(), ])
    }
}

public struct BlockNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case block_state_change = 1
    }
    
    public var block_state_change: [BlockStateChange] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.block_state_change.hash(), ])
    }
}

public struct SetNotificationSettingNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case desktop_sound_setting = 2
    }
    
    public var desktop_sound_setting: DesktopSoundSetting?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.desktop_sound_setting.hash(), ])
    }
}

public struct RichPresenceEnabledStateNotification: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case rich_presence_enabled_state = 1
    }
    
    public var rich_presence_enabled_state: [RichPresenceEnabledState] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.rich_presence_enabled_state.hash(), ])
    }
}

public struct ConversationSpec: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
    }
    
    public var conversation_id: ConversationId?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), ])
    }
}

public struct OffnetworkAddress: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case email = 3
    }
    
    public var type: OffnetworkAddressType?
    public var email: String?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.email.hash(), ])
    }
}

public struct EntityResult: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case lookup_spec = 1
        case entity = 2
    }
    
    public var lookup_spec: EntityLookupSpec?
    public var entity: [Entity] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.lookup_spec.hash(), self.entity.hash(), ])
    }
}

public struct AddUserRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case invitee_id = 3
        case event_request_header = 5
    }
    
    public var request_header: RequestHeader?
    public var invitee_id: [InviteeID] = []
    public var event_request_header: EventRequestHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.invitee_id.hash(), self.event_request_header.hash(), ])
    }
}

public struct AddUserResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case created_event = 5
    }
    
    public var response_header: ResponseHeader?
    public var created_event: Event?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.created_event.hash(), ])
    }
}

public struct CreateConversationRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case type = 2
        case client_generated_id = 3
        case name = 4
        case invitee_id = 5
    }
    
    public var request_header: RequestHeader?
    public var type: ConversationType?
    public var client_generated_id: UInt64?
    public var name: String?
    public var invitee_id: [InviteeID] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.type.hash(), self.client_generated_id.hash(), self.name.hash(), self.invitee_id.hash(), ])
    }
}

public struct CreateConversationResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case conversation = 2
        case new_conversation_created = 7
    }
    
    public var response_header: ResponseHeader?
    public var conversation: Conversation?
    public var new_conversation_created: Bool?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.conversation.hash(), self.new_conversation_created.hash(), ])
    }
}

public struct DeleteConversationRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case delete_upper_bound_timestamp = 3
    }
    
    public var request_header: RequestHeader?
    public var conversation_id: ConversationId?
    public var delete_upper_bound_timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.delete_upper_bound_timestamp.hash(), ])
    }
}

public struct DeleteConversationResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case delete_action = 2
    }
    
    public var response_header: ResponseHeader?
    public var delete_action: DeleteAction?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.delete_action.hash(), ])
    }
}

public struct EasterEggRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case easter_egg = 3
    }
    
    public var request_header: RequestHeader?
    public var conversation_id: ConversationId?
    public var easter_egg: EasterEgg?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.easter_egg.hash(), ])
    }
}

public struct EasterEggResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader?
    public var timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash(), ])
    }
}

public struct GetConversationRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_spec = 2
        case include_event = 4
        case max_events_per_conversation = 6
        case event_continuation_token = 7
    }
    
    public var request_header: RequestHeader?
    public var conversation_spec: ConversationSpec?
    public var include_event: Bool?
    public var max_events_per_conversation: UInt64?
    public var event_continuation_token: EventContinuationToken?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_spec.hash(), self.include_event.hash(), self.max_events_per_conversation.hash(), self.event_continuation_token.hash(), ])
    }
}

public struct GetConversationResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case conversation_state = 2
    }
    
    public var response_header: ResponseHeader?
    public var conversation_state: ConversationState?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.conversation_state.hash(), ])
    }
}

public struct GetEntityByIdRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case batch_lookup_spec = 3
    }
    
    public var request_header: RequestHeader?
    public var batch_lookup_spec: [EntityLookupSpec] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.batch_lookup_spec.hash(), ])
    }
}

public struct GetEntityByIdResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case entity = 2
        case entity_result = 3
    }
    
    public var response_header: ResponseHeader?
    public var entity: [Entity] = []
    public var entity_result: [EntityResult] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.entity.hash(), self.entity_result.hash(), ])
    }
}

public struct GetSuggestedEntitiesRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case max_count = 4
        case favorites = 8
        case contacts_you_hangout_with = 9
        case other_contacts_on_hangouts = 10
        case other_contacts = 11
        case dismissed_contacts = 12
        case pinned_favorites = 13
    }
    
    public var request_header: RequestHeader?
    public var max_count: UInt64?
    public var favorites: SuggestedContactGroupHash?
    public var contacts_you_hangout_with: SuggestedContactGroupHash?
    public var other_contacts_on_hangouts: SuggestedContactGroupHash?
    public var other_contacts: SuggestedContactGroupHash?
    public var dismissed_contacts: SuggestedContactGroupHash?
    public var pinned_favorites: SuggestedContactGroupHash?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.max_count.hash(), self.favorites.hash(), self.contacts_you_hangout_with.hash(), self.other_contacts_on_hangouts.hash(), self.other_contacts.hash(), self.dismissed_contacts.hash(), self.pinned_favorites.hash(), ])
    }
}

public struct GetSuggestedEntitiesResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case entity = 2
        case favorites = 4
        case contacts_you_hangout_with = 5
        case other_contacts_on_hangouts = 6
        case other_contacts = 7
        case dismissed_contacts = 8
        case pinned_favorites = 9
    }
    
    public var response_header: ResponseHeader?
    public var entity: [Entity] = []
    public var favorites: SuggestedContactGroup?
    public var contacts_you_hangout_with: SuggestedContactGroup?
    public var other_contacts_on_hangouts: SuggestedContactGroup?
    public var other_contacts: SuggestedContactGroup?
    public var dismissed_contacts: SuggestedContactGroup?
    public var pinned_favorites: SuggestedContactGroup?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.entity.hash(), self.favorites.hash(), self.contacts_you_hangout_with.hash(), self.other_contacts_on_hangouts.hash(), self.other_contacts.hash(), self.dismissed_contacts.hash(), self.pinned_favorites.hash(), ])
    }
}

public struct GetSelfInfoRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
    }
    
    public var request_header: RequestHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), ])
    }
}

public struct GetSelfInfoResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case self_entity = 2
        case is_known_minor = 3
        case dnd_state = 5
        case desktop_off_setting = 6
        case phone_data = 7
        case configuration_bit = 8
        case desktop_off_state = 9
        case google_plus_user = 10
        case desktop_sound_setting = 11
        case rich_presence_state = 12
        case default_country = 19
    }
    
    public var response_header: ResponseHeader?
    public var self_entity: Entity?
    public var is_known_minor: Bool?
    public var dnd_state: DoNotDisturbSetting?
    public var desktop_off_setting: DesktopOffSetting?
    public var phone_data: PhoneData?
    public var configuration_bit: [ConfigurationBit] = []
    public var desktop_off_state: DesktopOffState?
    public var google_plus_user: Bool?
    public var desktop_sound_setting: DesktopSoundSetting?
    public var rich_presence_state: RichPresenceState?
    public var default_country: Country?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.self_entity.hash(), self.is_known_minor.hash(), self.dnd_state.hash(), self.desktop_off_setting.hash(), self.phone_data.hash(), self.configuration_bit.hash(), self.desktop_off_state.hash(), self.google_plus_user.hash(), self.desktop_sound_setting.hash(), self.rich_presence_state.hash(), self.default_country.hash(), ])
    }
}

public struct QueryPresenceRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case participant_id = 2
        case field_mask = 3
    }
    
    public var request_header: RequestHeader?
    public var participant_id: [ParticipantId] = []
    public var field_mask: [FieldMask] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.participant_id.hash(), self.field_mask.hash(), ])
    }
}

public struct QueryPresenceResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case presence_result = 2
    }
    
    public var response_header: ResponseHeader?
    public var presence_result: [PresenceResult] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.presence_result.hash(), ])
    }
}

public struct RemoveUserRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case event_request_header = 5
    }
    
    public var request_header: RequestHeader?
    public var event_request_header: EventRequestHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.event_request_header.hash(), ])
    }
}

public struct RemoveUserResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case created_event = 4
    }
    
    public var response_header: ResponseHeader?
    public var created_event: Event?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.created_event.hash(), ])
    }
}

public struct RenameConversationRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case new_name = 3
        case event_request_header = 5
    }
    
    public var request_header: RequestHeader?
    public var new_name: String?
    public var event_request_header: EventRequestHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.new_name.hash(), self.event_request_header.hash(), ])
    }
}

public struct RenameConversationResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case created_event = 4
    }
    
    public var response_header: ResponseHeader?
    public var created_event: Event?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.created_event.hash(), ])
    }
}

public struct SearchEntitiesRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case query = 3
        case max_count = 4
    }
    
    public var request_header: RequestHeader?
    public var query: String?
    public var max_count: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.query.hash(), self.max_count.hash(), ])
    }
}

public struct SearchEntitiesResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case entity = 2
    }
    
    public var response_header: ResponseHeader?
    public var entity: [Entity] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.entity.hash(), ])
    }
}

public struct SendChatMessageRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case annotation = 5
        case message_content = 6
        case existing_media = 7
        case event_request_header = 8
    }
    
    public var request_header: RequestHeader?
    public var annotation: [EventAnnotation] = []
    public var message_content: MessageContent?
    public var existing_media: ExistingMedia?
    public var event_request_header: EventRequestHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.annotation.hash(), self.message_content.hash(), self.existing_media.hash(), self.event_request_header.hash(), ])
    }
}

public struct SendChatMessageResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case created_event = 6
    }
    
    public var response_header: ResponseHeader?
    public var created_event: Event?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.created_event.hash(), ])
    }
}

public struct SendOffnetworkInvitationRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case invitee_address = 2
    }
    
    public var request_header: RequestHeader?
    public var invitee_address: OffnetworkAddress?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.invitee_address.hash(), ])
    }
}

public struct SendOffnetworkInvitationResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), ])
    }
}

public struct SetActiveClientRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case is_active = 2
        case full_jid = 3
        case timeout_secs = 4
    }
    
    public var request_header: RequestHeader?
    public var is_active: Bool?
    public var full_jid: String?
    public var timeout_secs: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.is_active.hash(), self.full_jid.hash(), self.timeout_secs.hash(), ])
    }
}

public struct SetActiveClientResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), ])
    }
}

public struct SetConversationLevelRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
    }
    
    public var request_header: RequestHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), ])
    }
}

public struct SetConversationLevelResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), ])
    }
}

public struct SetConversationNotificationLevelRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case level = 3
    }
    
    public var request_header: RequestHeader?
    public var conversation_id: ConversationId?
    public var level: NotificationLevel?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.level.hash(), ])
    }
}

public struct SetConversationNotificationLevelResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader?
    public var timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash(), ])
    }
}

public struct SetFocusRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case type = 3
        case timeout_secs = 4
    }
    
    public var request_header: RequestHeader?
    public var conversation_id: ConversationId?
    public var type: FocusType?
    public var timeout_secs: UInt32?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.type.hash(), self.timeout_secs.hash(), ])
    }
}

public struct SetFocusResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader?
    public var timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash(), ])
    }
}

public struct SetPresenceRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case presence_state_setting = 2
        case dnd_setting = 3
        case desktop_off_setting = 5
        case mood_setting = 8
    }
    
    public var request_header: RequestHeader?
    public var presence_state_setting: PresenceStateSetting?
    public var dnd_setting: DndSetting?
    public var desktop_off_setting: DesktopOffSetting?
    public var mood_setting: MoodSetting?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.presence_state_setting.hash(), self.dnd_setting.hash(), self.desktop_off_setting.hash(), self.mood_setting.hash(), ])
    }
}

public struct SetPresenceResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), ])
    }
}

public struct SetTypingRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case type = 3
    }
    
    public var request_header: RequestHeader?
    public var conversation_id: ConversationId?
    public var type: TypingType?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.type.hash(), ])
    }
}

public struct SetTypingResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader?
    public var timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash(), ])
    }
}

public struct SyncAllNewEventsRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case last_sync_timestamp = 2
        case max_response_size_bytes = 8
    }
    
    public var request_header: RequestHeader?
    public var last_sync_timestamp: UInt64?
    public var max_response_size_bytes: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.last_sync_timestamp.hash(), self.max_response_size_bytes.hash(), ])
    }
}

public struct SyncAllNewEventsResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case sync_timestamp = 2
        case conversation_state = 3
    }
    
    public var response_header: ResponseHeader?
    public var sync_timestamp: UInt64?
    public var conversation_state: [ConversationState] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.sync_timestamp.hash(), self.conversation_state.hash(), ])
    }
}

public struct SyncRecentConversationsRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case max_conversations = 3
        case max_events_per_conversation = 4
        case sync_filter = 5
    }
    
    public var request_header: RequestHeader?
    public var max_conversations: UInt64?
    public var max_events_per_conversation: UInt64?
    public var sync_filter: [SyncFilter] = []
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.max_conversations.hash(), self.max_events_per_conversation.hash(), self.sync_filter.hash(), ])
    }
}

public struct SyncRecentConversationsResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case sync_timestamp = 2
        case conversation_state = 3
        case continuation_end_timestamp = 4
    }
    
    public var response_header: ResponseHeader?
    public var sync_timestamp: UInt64?
    public var conversation_state: [ConversationState] = []
    public var continuation_end_timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.sync_timestamp.hash(), self.conversation_state.hash(), self.continuation_end_timestamp.hash(), ])
    }
}

public struct UpdateWatermarkRequest: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case last_read_timestamp = 3
    }
    
    public var request_header: RequestHeader?
    public var conversation_id: ConversationId?
    public var last_read_timestamp: UInt64?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.last_read_timestamp.hash(), ])
    }
}

public struct UpdateWatermarkResponse: ProtoMessage {
    
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader?
    
    public init() {}
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), ])
    }
}

let _protoEnums: [String: _ProtoEnum.Type] = [
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

let _protoMessages: [String: _ProtoMessage.Type] = [
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

