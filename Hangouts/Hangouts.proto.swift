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

public struct CallType: ProtoEnum {
    public static let None: CallType = 0
    public static let Pstn: CallType = 1
    public static let Hangout: CallType = 2
    
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
    public static let Mobile: ClientPresenceStateType = 10
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
    public static let Ding: NotificationLevel = 20
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
    public static let Video: MediaType = 2
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

public struct HangoutMediaType: ProtoEnum {
    public static let Unknown: HangoutMediaType = 0
    public static let AudioVideo: HangoutMediaType = 1
    public static let AudioOnly: HangoutMediaType = 2
    
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
    public static let Mobile: SourceType = 1
    public static let Web: SourceType = 2
    
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
    public static let ObservedEvent: EventType = 13
    public static let GroupLinkSharingModification: EventType = 14
    
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
    public static let OffNetworkPhone: ParticipantType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct InvitationStatus: ProtoEnum {
    public static let Unknown: InvitationStatus = 0
    public static let Pending: InvitationStatus = 1
    public static let Accepted: InvitationStatus = 2
    public static let Needed: InvitationStatus = 3
    
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
    public static let Phone: NetworkType = 2
    
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
    public static let Bot: ClientId = 7
    public static let GlassServer: ClientId = 9
    public static let PstnBot: ClientId = 10
    public static let Tee: ClientId = 11
    public static let Ultraviolet: ClientId = 13
    public static let RoomServer: ClientId = 14
    public static let Speakeasy: ClientId = 16
    public static let GoogleVoice: ClientId = 17
    public static let Prober: ClientId = 18
    public static let AndroidPstnOnly: ClientId = 27
    public static let Something: ClientId = 34
    public static let TestClient: ClientId = 35
    public static let WebHangouts: ClientId = 44
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientBuildType: ProtoEnum {
    public static let Unknown: ClientBuildType = 0
    public static let ProductionWeb: ClientBuildType = 1
    public static let Dogfood: ClientBuildType = 2
    public static let ProductionApp: ClientBuildType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct Device: ProtoEnum {
    public static let Unknown: Device = 0
    public static let AndroidPhone: Device = 2
    public static let AndroidTablet: Device = 3
    public static let IosPhone: Device = 4
    public static let IosTablet: Device = 5
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct Application: ProtoEnum {
    public static let Babel: Application = 407
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct Platform: ProtoEnum {
    public static let Unknown: Platform = 0
    public static let Native: Platform = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ResponseStatus: ProtoEnum {
    public static let Unknown: ResponseStatus = 0
    public static let Ok: ResponseStatus = 1
    public static let Busy: ResponseStatus = 2
    public static let UnexpectedError: ResponseStatus = 3
    public static let InvalidRequest: ResponseStatus = 4
    public static let ErrorRetryLimit: ResponseStatus = 5
    public static let ErrorForwarded: ResponseStatus = 6
    public static let ErrorQuotaExceeded: ResponseStatus = 7
    public static let ErrorInvalidConversation: ResponseStatus = 8
    public static let ErrorVersionMismatch: ResponseStatus = 9
    public static let ErrorAccessCheckFailed: ResponseStatus = 10
    public static let ErrorNotFound: ResponseStatus = 11
    
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
    public static let Page: ProfileType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ConfigurationBitType: ProtoEnum {
    public static let Unknown: ConfigurationBitType = 0
    public static let QuasarMarketingPromoDismissed: ConfigurationBitType = 1
    public static let GplusSignupPromoDismissed: ConfigurationBitType = 2
    public static let ChatWithCirclesAccepted: ConfigurationBitType = 3
    public static let ChatWithCirclesPromoDismissed: ConfigurationBitType = 4
    public static let AllowedForDomain: ConfigurationBitType = 5
    public static let GmailChatArchiveEnabled: ConfigurationBitType = 6
    public static let GplusUpgradeAllowedForDomain: ConfigurationBitType = 7
    public static let RichPresenceActivityPromoShown: ConfigurationBitType = 8
    public static let RichPresenceDevicePromoShown: ConfigurationBitType = 9
    public static let RichPresenceInCallStatePromoShown: ConfigurationBitType = 10
    public static let RichPresenceMoodPromoShown: ConfigurationBitType = 11
    public static let CanOptIntoGvSmsIntegration: ConfigurationBitType = 12
    public static let GvSmsIntegrationEnabled: ConfigurationBitType = 13
    public static let GvSmsIntegrationPromoShown: ConfigurationBitType = 14
    public static let BusinessFeaturesEligible: ConfigurationBitType = 15
    public static let BusinessFeaturesPromoDismissed: ConfigurationBitType = 16
    public static let BusinessFeaturesEnabled: ConfigurationBitType = 17
    public static let Unknown18: ConfigurationBitType = 18
    public static let RichPresenceLastSeenMobilePromoShown: ConfigurationBitType = 19
    public static let RichPresenceLastSeenDesktopPromptShown: ConfigurationBitType = 20
    public static let Unknown21: ConfigurationBitType = 21
    public static let RichPresenceLastSeenDesktopPromoShown: ConfigurationBitType = 22
    public static let ConversationInviteSettingsSetToCustom: ConfigurationBitType = 23
    public static let ReportAbuseNoticeAcknowledged: ConfigurationBitType = 24
    public static let Unknown25: ConfigurationBitType = 25
    public static let Unknown26: ConfigurationBitType = 26
    public static let PhoneVerificationMobilePromptShown: ConfigurationBitType = 27
    public static let CanUseGvCallerIdFeature: ConfigurationBitType = 28
    public static let PhotoServiceRegistered: ConfigurationBitType = 29
    public static let GvCallerIdWabelFirstTimeDialogShown: ConfigurationBitType = 30
    public static let HangoutP2PNoticeNeedsAcknowledgement: ConfigurationBitType = 31
    public static let Unknown32: ConfigurationBitType = 32
    public static let InviteNotificationsEnabled: ConfigurationBitType = 33
    public static let DesktopAutoEmojiConversionEnabled: ConfigurationBitType = 34
    public static let WarmWelcomeSeen: ConfigurationBitType = 35
    public static let InviteHappyStatePromoSeen: ConfigurationBitType = 36
    public static let DesktopHostDensitySettingsEnabled: ConfigurationBitType = 37
    public static let DesktopCompactModeEnabled: ConfigurationBitType = 38
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct RichPresenceType: ProtoEnum {
    public static let Unknown: RichPresenceType = 0
    public static let InCallState: RichPresenceType = 1
    public static let Device: RichPresenceType = 2
    public static let Mood: RichPresenceType = 3
    public static let Activity: RichPresenceType = 4
    public static let GloballyEnabled: RichPresenceType = 5
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
    public static let Location: FieldMask = 4
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
    public static let Active: SyncFilter = 3
    public static let Invited: SyncFilter = 4
    public static let InvitedLowAffinity: SyncFilter = 5
    
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

public struct GroupLinkSharingStatus: ProtoEnum {
    public static let Unknown: GroupLinkSharingStatus = 0
    public static let On: GroupLinkSharingStatus = 1
    public static let Off: GroupLinkSharingStatus = 2
    public static let NotAvailable: GroupLinkSharingStatus = 3
    
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
    
    public var do_not_disturb: Bool? = nil
    public var expiration_timestamp: UInt64? = nil
    public var version: UInt64? = nil
    
    public init(do_not_disturb: Bool? = nil, expiration_timestamp: UInt64? = nil, version: UInt64? = nil) {
        self.do_not_disturb = do_not_disturb
        self.expiration_timestamp = expiration_timestamp
        self.version = version
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.do_not_disturb.hash(), self.expiration_timestamp.hash(), self.version.hash()])
    }
}

public struct NotificationSettings: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case dnd_settings = 1
    }
    
    public var dnd_settings: DoNotDisturbSetting? = nil
    
    public init(dnd_settings: DoNotDisturbSetting? = nil) {
        self.dnd_settings = dnd_settings
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.dnd_settings.hash()])
    }
}

public struct ConversationId: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 1
    }
    
    public var id: String? = nil
    
    public init(id: String? = nil) {
        self.id = id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.id.hash()])
    }
}

public struct ParticipantId: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case gaia_id = 1
        case chat_id = 2
    }
    
    public var gaia_id: String? = nil
    public var chat_id: String? = nil
    
    public init(gaia_id: String? = nil, chat_id: String? = nil) {
        self.gaia_id = gaia_id
        self.chat_id = chat_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.gaia_id.hash(), self.chat_id.hash()])
    }
}

public struct DeviceStatus: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case mobile = 1
        case desktop = 2
        case tablet = 3
    }
    
    public var mobile: Bool? = nil
    public var desktop: Bool? = nil
    public var tablet: Bool? = nil
    
    public init(mobile: Bool? = nil, desktop: Bool? = nil, tablet: Bool? = nil) {
        self.mobile = mobile
        self.desktop = desktop
        self.tablet = tablet
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.mobile.hash(), self.desktop.hash(), self.tablet.hash()])
    }
}

public struct LastSeen: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case last_seen_timestamp = 1
        case usec_since_last_seen = 2
    }
    
    public var last_seen_timestamp: UInt64!
    public var usec_since_last_seen: UInt64? = nil
    
    public init(last_seen_timestamp: UInt64!, usec_since_last_seen: UInt64? = nil) {
        self.last_seen_timestamp = last_seen_timestamp
        self.usec_since_last_seen = usec_since_last_seen
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.last_seen_timestamp.hash(), self.usec_since_last_seen.hash()])
    }
}

public struct Location: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case lat = 2
        case lng = 3
        case timestamp_msec = 4
        case accuracy_meters = 5
        case display_name = 6
    }
    
    public var type: UInt64? = nil
    public var lat: Double? = nil
    public var lng: Double? = nil
    public var timestamp_msec: UInt64? = nil
    public var accuracy_meters: UInt64? = nil
    public var display_name: String? = nil
    
    public init(type: UInt64? = nil, lat: Double? = nil, lng: Double? = nil, timestamp_msec: UInt64? = nil, accuracy_meters: UInt64? = nil, display_name: String? = nil) {
        self.type = type
        self.lat = lat
        self.lng = lng
        self.timestamp_msec = timestamp_msec
        self.accuracy_meters = accuracy_meters
        self.display_name = display_name
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.lat.hash(), self.lng.hash(), self.timestamp_msec.hash(), self.accuracy_meters.hash(), self.display_name.hash()])
    }
}

public struct InCall: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case call_type = 1
    }
    
    public var call_type: CallType? = nil
    
    public init(call_type: CallType? = nil) {
        self.call_type = call_type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.call_type.hash()])
    }
}

public struct Presence: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case reachable = 1
        case available = 2
        case device_location = 3
        case in_call = 5
        case device_status = 6
        case mood_setting = 9
        case last_seen = 10
    }
    
    public var reachable: Bool? = nil
    public var available: Bool? = nil
    public var device_location: [Location] = []
    public var in_call: InCall? = nil
    public var device_status: DeviceStatus? = nil
    public var mood_setting: MoodSetting? = nil
    public var last_seen: LastSeen? = nil
    
    public init(reachable: Bool? = nil, available: Bool? = nil, device_location: [Location] = [], in_call: InCall? = nil, device_status: DeviceStatus? = nil, mood_setting: MoodSetting? = nil, last_seen: LastSeen? = nil) {
        self.reachable = reachable
        self.available = available
        self.device_location = device_location
        self.in_call = in_call
        self.device_status = device_status
        self.mood_setting = mood_setting
        self.last_seen = last_seen
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.reachable.hash(), self.available.hash(), self.device_location.hash(), self.in_call.hash(), self.device_status.hash(), self.mood_setting.hash(), self.last_seen.hash()])
    }
}

public struct PresenceResult: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case user_id = 1
        case presence = 2
    }
    
    public var user_id: ParticipantId? = nil
    public var presence: Presence? = nil
    
    public init(user_id: ParticipantId? = nil, presence: Presence? = nil) {
        self.user_id = user_id
        self.presence = presence
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.user_id.hash(), self.presence.hash()])
    }
}

public struct ClientIdentifier: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case resource = 1
        case client_id = 2
        case participant_log_id = 4
    }
    
    public var resource: String? = nil
    public var client_id: String? = nil
    public var participant_log_id: String? = nil
    
    public init(resource: String? = nil, client_id: String? = nil, participant_log_id: String? = nil) {
        self.resource = resource
        self.client_id = client_id
        self.participant_log_id = participant_log_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.resource.hash(), self.client_id.hash(), self.participant_log_id.hash()])
    }
}

public struct ClientPresenceState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case identifier = 1
        case state = 2
        case expiration_timestamp = 3
    }
    
    public var identifier: ClientIdentifier? = nil
    public var state: ClientPresenceStateType? = nil
    public var expiration_timestamp: UInt64? = nil
    
    public init(identifier: ClientIdentifier? = nil, state: ClientPresenceStateType? = nil, expiration_timestamp: UInt64? = nil) {
        self.identifier = identifier
        self.state = state
        self.expiration_timestamp = expiration_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.identifier.hash(), self.state.hash(), self.expiration_timestamp.hash()])
    }
}

public struct UserEventState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case user_id = 1
        case client_generated_id = 2
        case notification_level = 3
    }
    
    public var user_id: ParticipantId? = nil
    public var client_generated_id: String? = nil
    public var notification_level: NotificationLevel? = nil
    
    public init(user_id: ParticipantId? = nil, client_generated_id: String? = nil, notification_level: NotificationLevel? = nil) {
        self.user_id = user_id
        self.client_generated_id = client_generated_id
        self.notification_level = notification_level
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.user_id.hash(), self.client_generated_id.hash(), self.notification_level.hash()])
    }
}

public struct Formatting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case bold = 1
        case italics = 2
        case strikethrough = 3
        case underline = 4
    }
    
    public var bold: Bool? = nil
    public var italics: Bool? = nil
    public var strikethrough: Bool? = nil
    public var underline: Bool? = nil
    
    public init(bold: Bool? = nil, italics: Bool? = nil, strikethrough: Bool? = nil, underline: Bool? = nil) {
        self.bold = bold
        self.italics = italics
        self.strikethrough = strikethrough
        self.underline = underline
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.bold.hash(), self.italics.hash(), self.strikethrough.hash(), self.underline.hash()])
    }
}

public struct LinkData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case link_target = 1
    }
    
    public var link_target: String? = nil
    
    public init(link_target: String? = nil) {
        self.link_target = link_target
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.link_target.hash()])
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
    public var text: String? = nil
    public var formatting: Formatting? = nil
    public var link_data: LinkData? = nil
    
    public init(type: SegmentType!, text: String? = nil, formatting: Formatting? = nil, link_data: LinkData? = nil) {
        self.type = type
        self.text = text
        self.formatting = formatting
        self.link_data = link_data
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.text.hash(), self.formatting.hash(), self.link_data.hash()])
    }
}

public struct Thumbnail: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case url = 1
        case image_url = 4
        case width_px = 10
        case height_px = 11
    }
    
    public var url: String? = nil
    public var image_url: String? = nil
    public var width_px: UInt64? = nil
    public var height_px: UInt64? = nil
    
    public init(url: String? = nil, image_url: String? = nil, width_px: UInt64? = nil, height_px: UInt64? = nil) {
        self.url = url
        self.image_url = image_url
        self.width_px = width_px
        self.height_px = height_px
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash(), self.image_url.hash(), self.width_px.hash(), self.height_px.hash()])
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
        case download_url = 20
    }
    
    public var thumbnail: Thumbnail? = nil
    public var owner_obfuscated_id: String? = nil
    public var album_id: String? = nil
    public var photo_id: String? = nil
    public var url: String? = nil
    public var original_content_url: String? = nil
    public var media_type: MediaType? = nil
    public var stream_id: [String] = []
    public var download_url: String? = nil
    
    public init(thumbnail: Thumbnail? = nil, owner_obfuscated_id: String? = nil, album_id: String? = nil, photo_id: String? = nil, url: String? = nil, original_content_url: String? = nil, media_type: MediaType? = nil, stream_id: [String] = [], download_url: String? = nil) {
        self.thumbnail = thumbnail
        self.owner_obfuscated_id = owner_obfuscated_id
        self.album_id = album_id
        self.photo_id = photo_id
        self.url = url
        self.original_content_url = original_content_url
        self.media_type = media_type
        self.stream_id = stream_id
        self.download_url = download_url
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.thumbnail.hash(), self.owner_obfuscated_id.hash(), self.album_id.hash(), self.photo_id.hash(), self.url.hash(), self.original_content_url.hash(), self.media_type.hash(), self.stream_id.hash(), self.download_url.hash()])
    }
}

public struct RepresentativeImage: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case url = 2
    }
    
    public var url: String? = nil
    
    public init(url: String? = nil) {
        self.url = url
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash()])
    }
}

public struct Place: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case url = 1
        case name = 3
        case representative_image = 185
    }
    
    public var url: String? = nil
    public var name: String? = nil
    public var representative_image: RepresentativeImage? = nil
    
    public init(url: String? = nil, name: String? = nil, representative_image: RepresentativeImage? = nil) {
        self.url = url
        self.name = name
        self.representative_image = representative_image
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash(), self.name.hash(), self.representative_image.hash()])
    }
}

public struct VoicePhoto: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case url = 1
    }
    
    public var url: String? = nil
    
    public init(url: String? = nil) {
        self.url = url
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.url.hash()])
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
    public var id: String? = nil
    public var plus_photo: PlusPhoto? = nil
    public var place: Place? = nil
    public var voice_photo: VoicePhoto? = nil
    
    public init(type: [ItemType] = [], id: String? = nil, plus_photo: PlusPhoto? = nil, place: Place? = nil, voice_photo: VoicePhoto? = nil) {
        self.type = type
        self.id = id
        self.plus_photo = plus_photo
        self.place = place
        self.voice_photo = voice_photo
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.id.hash(), self.plus_photo.hash(), self.place.hash(), self.voice_photo.hash()])
    }
}

public struct Attachment: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case embed_item = 1
    }
    
    public var embed_item: EmbedItem? = nil
    
    public init(embed_item: EmbedItem? = nil) {
        self.embed_item = embed_item
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.embed_item.hash()])
    }
}

public struct MessageContent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case segment = 1
        case attachment = 2
    }
    
    public var segment: [Segment] = []
    public var attachment: [Attachment] = []
    
    public init(segment: [Segment] = [], attachment: [Attachment] = []) {
        self.segment = segment
        self.attachment = attachment
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.segment.hash(), self.attachment.hash()])
    }
}

public struct EventAnnotation: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case value = 2
    }
    
    public var type: Int32? = nil
    public var value: String? = nil
    
    public init(type: Int32? = nil, value: String? = nil) {
        self.type = type
        self.value = value
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.value.hash()])
    }
}

public struct ChatMessage: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case annotation = 2
        case message_content = 3
    }
    
    public var annotation: [EventAnnotation] = []
    public var message_content: MessageContent? = nil
    
    public init(annotation: [EventAnnotation] = [], message_content: MessageContent? = nil) {
        self.annotation = annotation
        self.message_content = message_content
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.annotation.hash(), self.message_content.hash()])
    }
}

public struct Participant: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 1
        case first_name = 2
        case full_name = 3
        case profile_photo_url = 4
    }
    
    public var id: ParticipantId? = nil
    public var first_name: String? = nil
    public var full_name: String? = nil
    public var profile_photo_url: String? = nil
    
    public init(id: ParticipantId? = nil, first_name: String? = nil, full_name: String? = nil, profile_photo_url: String? = nil) {
        self.id = id
        self.first_name = first_name
        self.full_name = full_name
        self.profile_photo_url = profile_photo_url
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.id.hash(), self.first_name.hash(), self.full_name.hash(), self.profile_photo_url.hash()])
    }
}

public struct MembershipChange: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case participant = 2
        case participant_ids = 3
    }
    
    public var type: MembershipChangeType? = nil
    public var participant: [Participant] = []
    public var participant_ids: [ParticipantId] = []
    
    public init(type: MembershipChangeType? = nil, participant: [Participant] = [], participant_ids: [ParticipantId] = []) {
        self.type = type
        self.participant = participant
        self.participant_ids = participant_ids
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.participant.hash(), self.participant_ids.hash()])
    }
}

public struct ConversationRename: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case new_name = 1
        case old_name = 2
    }
    
    public var new_name: String? = nil
    public var old_name: String? = nil
    
    public init(new_name: String? = nil, old_name: String? = nil) {
        self.new_name = new_name
        self.old_name = old_name
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.new_name.hash(), self.old_name.hash()])
    }
}

public struct HangoutEvent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case event_type = 1
        case participant_id = 2
        case hangout_duration_secs = 3
        case transferred_conversation_id = 4
        case refresh_timeout_secs = 5
        case is_peridoic_refresh = 6
        case media_type = 7
    }
    
    public var event_type: HangoutEventType? = nil
    public var participant_id: [ParticipantId] = []
    public var hangout_duration_secs: UInt64? = nil
    public var transferred_conversation_id: ConversationId? = nil
    public var refresh_timeout_secs: UInt64? = nil
    public var is_peridoic_refresh: Bool? = nil
    public var media_type: HangoutMediaType? = nil
    
    public init(event_type: HangoutEventType? = nil, participant_id: [ParticipantId] = [], hangout_duration_secs: UInt64? = nil, transferred_conversation_id: ConversationId? = nil, refresh_timeout_secs: UInt64? = nil, is_peridoic_refresh: Bool? = nil, media_type: HangoutMediaType? = nil) {
        self.event_type = event_type
        self.participant_id = participant_id
        self.hangout_duration_secs = hangout_duration_secs
        self.transferred_conversation_id = transferred_conversation_id
        self.refresh_timeout_secs = refresh_timeout_secs
        self.is_peridoic_refresh = is_peridoic_refresh
        self.media_type = media_type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.event_type.hash(), self.participant_id.hash(), self.hangout_duration_secs.hash(), self.transferred_conversation_id.hash(), self.refresh_timeout_secs.hash(), self.is_peridoic_refresh.hash(), self.media_type.hash()])
    }
}

public struct OTRModification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case old_otr_status = 1
        case new_otr_status = 2
        case old_otr_toggle = 3
        case new_otr_toggle = 4
    }
    
    public var old_otr_status: OffTheRecordStatus? = nil
    public var new_otr_status: OffTheRecordStatus? = nil
    public var old_otr_toggle: OffTheRecordToggle? = nil
    public var new_otr_toggle: OffTheRecordToggle? = nil
    
    public init(old_otr_status: OffTheRecordStatus? = nil, new_otr_status: OffTheRecordStatus? = nil, old_otr_toggle: OffTheRecordToggle? = nil, new_otr_toggle: OffTheRecordToggle? = nil) {
        self.old_otr_status = old_otr_status
        self.new_otr_status = new_otr_status
        self.old_otr_toggle = old_otr_toggle
        self.new_otr_toggle = new_otr_toggle
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.old_otr_status.hash(), self.new_otr_status.hash(), self.old_otr_toggle.hash(), self.new_otr_toggle.hash()])
    }
}

public struct HashModifier: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case update_id = 1
        case hash_diff = 2
        case version = 4
    }
    
    public var update_id: String? = nil
    public var hash_diff: UInt64? = nil
    public var version: UInt64? = nil
    
    public init(update_id: String? = nil, hash_diff: UInt64? = nil, version: UInt64? = nil) {
        self.update_id = update_id
        self.hash_diff = hash_diff
        self.version = version
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.update_id.hash(), self.hash_diff.hash(), self.version.hash()])
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
        case event_otr = 16
        case persisted = 17
        case delivery_medium = 20
        case event_type = 23
        case event_version = 24
        case hash_modifier = 26
        case group_link_sharing_modification = 31
    }
    
    public var conversation_id: ConversationId? = nil
    public var sender_id: ParticipantId? = nil
    public var timestamp: UInt64? = nil
    public var self_event_state: UserEventState? = nil
    public var source_type: SourceType? = nil
    public var chat_message: ChatMessage? = nil
    public var membership_change: MembershipChange? = nil
    public var conversation_rename: ConversationRename? = nil
    public var hangout_event: HangoutEvent? = nil
    public var event_id: String? = nil
    public var expiration_timestamp: UInt64? = nil
    public var otr_modification: OTRModification? = nil
    public var advances_sort_timestamp: Bool? = nil
    public var event_otr: OffTheRecordStatus? = nil
    public var persisted: Bool? = nil
    public var delivery_medium: DeliveryMedium? = nil
    public var event_type: EventType? = nil
    public var event_version: UInt64? = nil
    public var hash_modifier: HashModifier? = nil
    public var group_link_sharing_modification: GroupLinkSharingModification? = nil
    
    public init(conversation_id: ConversationId? = nil, sender_id: ParticipantId? = nil, timestamp: UInt64? = nil, self_event_state: UserEventState? = nil, source_type: SourceType? = nil, chat_message: ChatMessage? = nil, membership_change: MembershipChange? = nil, conversation_rename: ConversationRename? = nil, hangout_event: HangoutEvent? = nil, event_id: String? = nil, expiration_timestamp: UInt64? = nil, otr_modification: OTRModification? = nil, advances_sort_timestamp: Bool? = nil, event_otr: OffTheRecordStatus? = nil, persisted: Bool? = nil, delivery_medium: DeliveryMedium? = nil, event_type: EventType? = nil, event_version: UInt64? = nil, hash_modifier: HashModifier? = nil, group_link_sharing_modification: GroupLinkSharingModification? = nil) {
        self.conversation_id = conversation_id
        self.sender_id = sender_id
        self.timestamp = timestamp
        self.self_event_state = self_event_state
        self.source_type = source_type
        self.chat_message = chat_message
        self.membership_change = membership_change
        self.conversation_rename = conversation_rename
        self.hangout_event = hangout_event
        self.event_id = event_id
        self.expiration_timestamp = expiration_timestamp
        self.otr_modification = otr_modification
        self.advances_sort_timestamp = advances_sort_timestamp
        self.event_otr = event_otr
        self.persisted = persisted
        self.delivery_medium = delivery_medium
        self.event_type = event_type
        self.event_version = event_version
        self.hash_modifier = hash_modifier
        self.group_link_sharing_modification = group_link_sharing_modification
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.sender_id.hash(), self.timestamp.hash(), self.self_event_state.hash(), self.source_type.hash(), self.chat_message.hash(), self.membership_change.hash(), self.conversation_rename.hash(), self.hangout_event.hash(), self.event_id.hash(), self.expiration_timestamp.hash(), self.otr_modification.hash(), self.advances_sort_timestamp.hash(), self.event_otr.hash(), self.persisted.hash(), self.delivery_medium.hash(), self.event_type.hash(), self.event_version.hash(), self.hash_modifier.hash(), self.group_link_sharing_modification.hash()])
    }
}

public struct UserReadState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case participant_id = 1
        case latest_read_timestamp = 2
    }
    
    public var participant_id: ParticipantId? = nil
    public var latest_read_timestamp: UInt64? = nil
    
    public init(participant_id: ParticipantId? = nil, latest_read_timestamp: UInt64? = nil) {
        self.participant_id = participant_id
        self.latest_read_timestamp = latest_read_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.participant_id.hash(), self.latest_read_timestamp.hash()])
    }
}

public struct DeliveryMedium: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case medium_type = 1
        case self_phone = 2
    }
    
    public var medium_type: DeliveryMediumType? = nil
    public var self_phone: PhoneNumber? = nil
    
    public init(medium_type: DeliveryMediumType? = nil, self_phone: PhoneNumber? = nil) {
        self.medium_type = medium_type
        self.self_phone = self_phone
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.medium_type.hash(), self.self_phone.hash()])
    }
}

public struct DeliveryMediumOption: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case delivery_medium = 1
        case current_default = 2
        case primary = 3
    }
    
    public var delivery_medium: DeliveryMedium? = nil
    public var current_default: Bool? = nil
    public var primary: Bool? = nil
    
    public init(delivery_medium: DeliveryMedium? = nil, current_default: Bool? = nil, primary: Bool? = nil) {
        self.delivery_medium = delivery_medium
        self.current_default = current_default
        self.primary = primary
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.delivery_medium.hash(), self.current_default.hash(), self.primary.hash()])
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
    
    public var client_generated_id: String? = nil
    public var self_read_state: UserReadState? = nil
    public var status: ConversationStatus? = nil
    public var notification_level: NotificationLevel? = nil
    public var view: [ConversationView] = []
    public var inviter_id: ParticipantId? = nil
    public var invite_timestamp: UInt64? = nil
    public var sort_timestamp: UInt64? = nil
    public var active_timestamp: UInt64? = nil
    public var invite_affinity: InvitationAffinity? = nil
    public var delivery_medium_option: [DeliveryMediumOption] = []
    
    public init(client_generated_id: String? = nil, self_read_state: UserReadState? = nil, status: ConversationStatus? = nil, notification_level: NotificationLevel? = nil, view: [ConversationView] = [], inviter_id: ParticipantId? = nil, invite_timestamp: UInt64? = nil, sort_timestamp: UInt64? = nil, active_timestamp: UInt64? = nil, invite_affinity: InvitationAffinity? = nil, delivery_medium_option: [DeliveryMediumOption] = []) {
        self.client_generated_id = client_generated_id
        self.self_read_state = self_read_state
        self.status = status
        self.notification_level = notification_level
        self.view = view
        self.inviter_id = inviter_id
        self.invite_timestamp = invite_timestamp
        self.sort_timestamp = sort_timestamp
        self.active_timestamp = active_timestamp
        self.invite_affinity = invite_affinity
        self.delivery_medium_option = delivery_medium_option
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.client_generated_id.hash(), self.self_read_state.hash(), self.status.hash(), self.notification_level.hash(), self.view.hash(), self.inviter_id.hash(), self.invite_timestamp.hash(), self.sort_timestamp.hash(), self.active_timestamp.hash(), self.invite_affinity.hash(), self.delivery_medium_option.hash()])
    }
}

public struct ConversationParticipantData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 1
        case fallback_name = 2
        case invitation_status = 3
        case phone_number = 4
        case participant_type = 5
        case new_invitation_status = 6
    }
    
    public var id: ParticipantId? = nil
    public var fallback_name: String? = nil
    public var invitation_status: InvitationStatus? = nil
    public var phone_number: PhoneNumber? = nil
    public var participant_type: ParticipantType? = nil
    public var new_invitation_status: InvitationStatus? = nil
    
    public init(id: ParticipantId? = nil, fallback_name: String? = nil, invitation_status: InvitationStatus? = nil, phone_number: PhoneNumber? = nil, participant_type: ParticipantType? = nil, new_invitation_status: InvitationStatus? = nil) {
        self.id = id
        self.fallback_name = fallback_name
        self.invitation_status = invitation_status
        self.phone_number = phone_number
        self.participant_type = participant_type
        self.new_invitation_status = new_invitation_status
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.id.hash(), self.fallback_name.hash(), self.invitation_status.hash(), self.phone_number.hash(), self.participant_type.hash(), self.new_invitation_status.hash()])
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
        case fork_on_external_invite = 16
        case network_type = 18
        case force_history_state = 19
        case is_group_link_sharing_enabled = 21
        case group_link_sharing_status = 22
    }
    
    public var conversation_id: ConversationId? = nil
    public var type: ConversationType? = nil
    public var name: String? = nil
    public var self_conversation_state: UserConversationState? = nil
    public var read_state: [UserReadState] = []
    public var has_active_hangout: Bool? = nil
    public var otr_status: OffTheRecordStatus? = nil
    public var otr_toggle: OffTheRecordToggle? = nil
    public var conversation_history_supported: Bool? = nil
    public var current_participant: [ParticipantId] = []
    public var participant_data: [ConversationParticipantData] = []
    public var fork_on_external_invite: Bool? = nil
    public var network_type: [NetworkType] = []
    public var force_history_state: ForceHistory? = nil
    public var is_group_link_sharing_enabled: Bool? = nil
    public var group_link_sharing_status: GroupLinkSharingStatus? = nil
    
    public init(conversation_id: ConversationId? = nil, type: ConversationType? = nil, name: String? = nil, self_conversation_state: UserConversationState? = nil, read_state: [UserReadState] = [], has_active_hangout: Bool? = nil, otr_status: OffTheRecordStatus? = nil, otr_toggle: OffTheRecordToggle? = nil, conversation_history_supported: Bool? = nil, current_participant: [ParticipantId] = [], participant_data: [ConversationParticipantData] = [], fork_on_external_invite: Bool? = nil, network_type: [NetworkType] = [], force_history_state: ForceHistory? = nil, is_group_link_sharing_enabled: Bool? = nil, group_link_sharing_status: GroupLinkSharingStatus? = nil) {
        self.conversation_id = conversation_id
        self.type = type
        self.name = name
        self.self_conversation_state = self_conversation_state
        self.read_state = read_state
        self.has_active_hangout = has_active_hangout
        self.otr_status = otr_status
        self.otr_toggle = otr_toggle
        self.conversation_history_supported = conversation_history_supported
        self.current_participant = current_participant
        self.participant_data = participant_data
        self.fork_on_external_invite = fork_on_external_invite
        self.network_type = network_type
        self.force_history_state = force_history_state
        self.is_group_link_sharing_enabled = is_group_link_sharing_enabled
        self.group_link_sharing_status = group_link_sharing_status
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.type.hash(), self.name.hash(), self.self_conversation_state.hash(), self.read_state.hash(), self.has_active_hangout.hash(), self.otr_status.hash(), self.otr_toggle.hash(), self.conversation_history_supported.hash(), self.current_participant.hash(), self.participant_data.hash(), self.fork_on_external_invite.hash(), self.network_type.hash(), self.force_history_state.hash(), self.is_group_link_sharing_enabled.hash(), self.group_link_sharing_status.hash()])
    }
}

public struct EasterEgg: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case message = 1
    }
    
    public var message: String? = nil
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.message.hash()])
    }
}

public struct BlockStateChange: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case participant_id = 1
        case new_block_state = 2
    }
    
    public var participant_id: ParticipantId? = nil
    public var new_block_state: BlockState? = nil
    
    public init(participant_id: ParticipantId? = nil, new_block_state: BlockState? = nil) {
        self.participant_id = participant_id
        self.new_block_state = new_block_state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.participant_id.hash(), self.new_block_state.hash()])
    }
}

public struct InvitationState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case unread_invite_count = 1
        case latest_read_timestamp = 2
    }
    
    public var unread_invite_count: UInt64? = nil
    public var latest_read_timestamp: UInt64? = nil
    
    public init(unread_invite_count: UInt64? = nil, latest_read_timestamp: UInt64? = nil) {
        self.unread_invite_count = unread_invite_count
        self.latest_read_timestamp = latest_read_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.unread_invite_count.hash(), self.latest_read_timestamp.hash()])
    }
}

public struct Photo: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case photo_id = 1
        case delete_albumless_source_photo = 2
        case user_id = 3
        case is_custom_user_id = 4
    }
    
    public var photo_id: String? = nil
    public var delete_albumless_source_photo: Bool? = nil
    public var user_id: String? = nil
    public var is_custom_user_id: Bool? = nil
    
    public init(photo_id: String? = nil, delete_albumless_source_photo: Bool? = nil, user_id: String? = nil, is_custom_user_id: Bool? = nil) {
        self.photo_id = photo_id
        self.delete_albumless_source_photo = delete_albumless_source_photo
        self.user_id = user_id
        self.is_custom_user_id = is_custom_user_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.photo_id.hash(), self.delete_albumless_source_photo.hash(), self.user_id.hash(), self.is_custom_user_id.hash()])
    }
}

public struct ExistingMedia: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case photo = 1
    }
    
    public var photo: Photo? = nil
    
    public init(photo: Photo? = nil) {
        self.photo = photo
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.photo.hash()])
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
    
    public var conversation_id: ConversationId? = nil
    public var client_generated_id: UInt64? = nil
    public var expected_otr: OffTheRecordStatus? = nil
    public var delivery_medium: DeliveryMedium? = nil
    public var event_type: EventType? = nil
    
    public init(conversation_id: ConversationId? = nil, client_generated_id: UInt64? = nil, expected_otr: OffTheRecordStatus? = nil, delivery_medium: DeliveryMedium? = nil, event_type: EventType? = nil) {
        self.conversation_id = conversation_id
        self.client_generated_id = client_generated_id
        self.expected_otr = expected_otr
        self.delivery_medium = delivery_medium
        self.event_type = event_type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.client_generated_id.hash(), self.expected_otr.hash(), self.delivery_medium.hash(), self.event_type.hash()])
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
    
    public var client_id: ClientId? = nil
    public var build_type: ClientBuildType? = nil
    public var major_version: String? = nil
    public var version_timestamp: UInt64? = nil
    public var device_os_version: String? = nil
    public var device_hardware: String? = nil
    
    public init(client_id: ClientId? = nil, build_type: ClientBuildType? = nil, major_version: String? = nil, version_timestamp: UInt64? = nil, device_os_version: String? = nil, device_hardware: String? = nil) {
        self.client_id = client_id
        self.build_type = build_type
        self.major_version = major_version
        self.version_timestamp = version_timestamp
        self.device_os_version = device_os_version
        self.device_hardware = device_hardware
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.client_id.hash(), self.build_type.hash(), self.major_version.hash(), self.version_timestamp.hash(), self.device_os_version.hash(), self.device_hardware.hash()])
    }
}

public struct RtcClient: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case device = 1
        case application = 2
        case platform = 3
    }
    
    public var device: Device? = nil
    public var application: Application? = nil
    public var platform: Platform? = nil
    
    public init(device: Device? = nil, application: Application? = nil, platform: Platform? = nil) {
        self.device = device
        self.application = application
        self.platform = platform
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.device.hash(), self.application.hash(), self.platform.hash()])
    }
}

public struct RequestHeader: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case client_version = 1
        case client_identifier = 2
        case language_code = 4
        case include_updated_conversation = 5
        case retry_attempt = 6
        case rtc_client = 7
    }
    
    public var client_version: ClientVersion? = nil
    public var client_identifier: ClientIdentifier? = nil
    public var language_code: String? = nil
    public var include_updated_conversation: Bool? = nil
    public var retry_attempt: UInt32? = nil
    public var rtc_client: RtcClient? = nil
    
    public init(client_version: ClientVersion? = nil, client_identifier: ClientIdentifier? = nil, language_code: String? = nil, include_updated_conversation: Bool? = nil, retry_attempt: UInt32? = nil, rtc_client: RtcClient? = nil) {
        self.client_version = client_version
        self.client_identifier = client_identifier
        self.language_code = language_code
        self.include_updated_conversation = include_updated_conversation
        self.retry_attempt = retry_attempt
        self.rtc_client = rtc_client
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.client_version.hash(), self.client_identifier.hash(), self.language_code.hash(), self.include_updated_conversation.hash(), self.retry_attempt.hash(), self.rtc_client.hash()])
    }
}

public struct ResponseHeader: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case status = 1
        case error_description = 2
        case debug_url = 3
        case request_trace_id = 4
        case current_server_time = 5
        case backoff_duration_millis = 6
        case localized_user_visible_error_message = 8
    }
    
    public var status: ResponseStatus? = nil
    public var error_description: String? = nil
    public var debug_url: String? = nil
    public var request_trace_id: String? = nil
    public var current_server_time: UInt64? = nil
    public var backoff_duration_millis: UInt64? = nil
    public var localized_user_visible_error_message: String? = nil
    
    public init(status: ResponseStatus? = nil, error_description: String? = nil, debug_url: String? = nil, request_trace_id: String? = nil, current_server_time: UInt64? = nil, backoff_duration_millis: UInt64? = nil, localized_user_visible_error_message: String? = nil) {
        self.status = status
        self.error_description = error_description
        self.debug_url = debug_url
        self.request_trace_id = request_trace_id
        self.current_server_time = current_server_time
        self.backoff_duration_millis = backoff_duration_millis
        self.localized_user_visible_error_message = localized_user_visible_error_message
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.status.hash(), self.error_description.hash(), self.debug_url.hash(), self.request_trace_id.hash(), self.current_server_time.hash(), self.backoff_duration_millis.hash(), self.localized_user_visible_error_message.hash()])
    }
}

public struct Entity: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 9
        case presence = 8
        case invalid = 7
        case properties = 10
        case blocked = 11
        case entity_type = 13
        case had_past_hangout_state = 16
    }
    
    public var id: ParticipantId? = nil
    public var presence: Presence? = nil
    public var invalid: Bool? = nil
    public var properties: EntityProperties? = nil
    public var blocked: Bool? = nil
    public var entity_type: ParticipantType? = nil
    public var had_past_hangout_state: PastHangoutState? = nil
    
    public init(id: ParticipantId? = nil, presence: Presence? = nil, invalid: Bool? = nil, properties: EntityProperties? = nil, blocked: Bool? = nil, entity_type: ParticipantType? = nil, had_past_hangout_state: PastHangoutState? = nil) {
        self.id = id
        self.presence = presence
        self.invalid = invalid
        self.properties = properties
        self.blocked = blocked
        self.entity_type = entity_type
        self.had_past_hangout_state = had_past_hangout_state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.id.hash(), self.presence.hash(), self.invalid.hash(), self.properties.hash(), self.blocked.hash(), self.entity_type.hash(), self.had_past_hangout_state.hash()])
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
        case location = 7
        case organization = 8
        case role = 9
        case in_users_domain = 10
        case gender = 11
        case photo_url_status = 12
        case phones = 14
        case canonical_email = 15
    }
    
    public var type: ProfileType? = nil
    public var display_name: String? = nil
    public var first_name: String? = nil
    public var photo_url: String? = nil
    public var email: [String] = []
    public var phone: [String] = []
    public var location: String? = nil
    public var organization: String? = nil
    public var role: String? = nil
    public var in_users_domain: Bool? = nil
    public var gender: Gender? = nil
    public var photo_url_status: PhotoUrlStatus? = nil
    public var phones: [Phone] = []
    public var canonical_email: String? = nil
    
    public init(type: ProfileType? = nil, display_name: String? = nil, first_name: String? = nil, photo_url: String? = nil, email: [String] = [], phone: [String] = [], location: String? = nil, organization: String? = nil, role: String? = nil, in_users_domain: Bool? = nil, gender: Gender? = nil, photo_url_status: PhotoUrlStatus? = nil, phones: [Phone] = [], canonical_email: String? = nil) {
        self.type = type
        self.display_name = display_name
        self.first_name = first_name
        self.photo_url = photo_url
        self.email = email
        self.phone = phone
        self.location = location
        self.organization = organization
        self.role = role
        self.in_users_domain = in_users_domain
        self.gender = gender
        self.photo_url_status = photo_url_status
        self.phones = phones
        self.canonical_email = canonical_email
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.display_name.hash(), self.first_name.hash(), self.photo_url.hash(), self.email.hash(), self.phone.hash(), self.location.hash(), self.organization.hash(), self.role.hash(), self.in_users_domain.hash(), self.gender.hash(), self.photo_url_status.hash(), self.phones.hash(), self.canonical_email.hash()])
    }
}

public struct ConversationState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case conversation = 2
        case event = 3
        case event_continuation_token = 5
    }
    
    public var conversation_id: ConversationId? = nil
    public var conversation: Conversation? = nil
    public var event: [Event] = []
    public var event_continuation_token: EventContinuationToken? = nil
    
    public init(conversation_id: ConversationId? = nil, conversation: Conversation? = nil, event: [Event] = [], event_continuation_token: EventContinuationToken? = nil) {
        self.conversation_id = conversation_id
        self.conversation = conversation
        self.event = event
        self.event_continuation_token = event_continuation_token
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.conversation.hash(), self.event.hash(), self.event_continuation_token.hash()])
    }
}

public struct EventContinuationToken: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case event_id = 1
        case storage_continuation_token = 2
        case event_timestamp = 3
    }
    
    public var event_id: String? = nil
    public var storage_continuation_token: String? = nil
    public var event_timestamp: UInt64? = nil
    
    public init(event_id: String? = nil, storage_continuation_token: String? = nil, event_timestamp: UInt64? = nil) {
        self.event_id = event_id
        self.storage_continuation_token = storage_continuation_token
        self.event_timestamp = event_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.event_id.hash(), self.storage_continuation_token.hash(), self.event_timestamp.hash()])
    }
}

public struct EntityLookupSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case gaia_id = 1
        case jid = 2
        case email = 3
        case phone = 4
        case chat_id = 5
        case create_offnetwork_gaia = 6
    }
    
    public var gaia_id: String? = nil
    public var jid: String? = nil
    public var email: String? = nil
    public var phone: String? = nil
    public var chat_id: String? = nil
    public var create_offnetwork_gaia: Bool? = nil
    
    public init(gaia_id: String? = nil, jid: String? = nil, email: String? = nil, phone: String? = nil, chat_id: String? = nil, create_offnetwork_gaia: Bool? = nil) {
        self.gaia_id = gaia_id
        self.jid = jid
        self.email = email
        self.phone = phone
        self.chat_id = chat_id
        self.create_offnetwork_gaia = create_offnetwork_gaia
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.gaia_id.hash(), self.jid.hash(), self.email.hash(), self.phone.hash(), self.chat_id.hash(), self.create_offnetwork_gaia.hash()])
    }
}

public struct ConfigurationBit: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case configuration_bit_type = 1
        case value = 2
    }
    
    public var configuration_bit_type: ConfigurationBitType? = nil
    public var value: Bool? = nil
    
    public init(configuration_bit_type: ConfigurationBitType? = nil, value: Bool? = nil) {
        self.configuration_bit_type = configuration_bit_type
        self.value = value
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.configuration_bit_type.hash(), self.value.hash()])
    }
}

public struct RichPresenceState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case get_rich_presence_enabled_state = 3
    }
    
    public var get_rich_presence_enabled_state: [RichPresenceEnabledState] = []
    
    public init(get_rich_presence_enabled_state: [RichPresenceEnabledState] = []) {
        self.get_rich_presence_enabled_state = get_rich_presence_enabled_state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.get_rich_presence_enabled_state.hash()])
    }
}

public struct RichPresenceEnabledState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case enabled = 2
    }
    
    public var type: RichPresenceType? = nil
    public var enabled: Bool? = nil
    
    public init(type: RichPresenceType? = nil, enabled: Bool? = nil) {
        self.type = type
        self.enabled = enabled
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.enabled.hash()])
    }
}

public struct DesktopOffSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case desktop_off = 1
    }
    
    public var desktop_off: Bool? = nil
    
    public init(desktop_off: Bool? = nil) {
        self.desktop_off = desktop_off
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.desktop_off.hash()])
    }
}

public struct DesktopOffState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case desktop_off = 1
        case version = 2
    }
    
    public var desktop_off: Bool? = nil
    public var version: UInt64? = nil
    
    public init(desktop_off: Bool? = nil, version: UInt64? = nil) {
        self.desktop_off = desktop_off
        self.version = version
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.desktop_off.hash(), self.version.hash()])
    }
}

public struct DndSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case do_not_disturb = 1
        case timeout_secs = 2
    }
    
    public var do_not_disturb: Bool? = nil
    public var timeout_secs: UInt64? = nil
    
    public init(do_not_disturb: Bool? = nil, timeout_secs: UInt64? = nil) {
        self.do_not_disturb = do_not_disturb
        self.timeout_secs = timeout_secs
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.do_not_disturb.hash(), self.timeout_secs.hash()])
    }
}

public struct PresenceStateSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case timeout_secs = 1
        case type = 2
    }
    
    public var timeout_secs: UInt64? = nil
    public var type: ClientPresenceStateType? = nil
    
    public init(timeout_secs: UInt64? = nil, type: ClientPresenceStateType? = nil) {
        self.timeout_secs = timeout_secs
        self.type = type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.timeout_secs.hash(), self.type.hash()])
    }
}

public struct MoodMessage: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case mood_content = 1
    }
    
    public var mood_content: MoodContent? = nil
    
    public init(mood_content: MoodContent? = nil) {
        self.mood_content = mood_content
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.mood_content.hash()])
    }
}

public struct MoodContent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case segment = 1
    }
    
    public var segment: [Segment] = []
    
    public init(segment: [Segment] = []) {
        self.segment = segment
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.segment.hash()])
    }
}

public struct MoodSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case mood_message = 1
    }
    
    public var mood_message: MoodMessage? = nil
    
    public init(mood_message: MoodMessage? = nil) {
        self.mood_message = mood_message
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.mood_message.hash()])
    }
}

public struct MoodState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case mood_setting = 4
    }
    
    public var mood_setting: MoodSetting? = nil
    
    public init(mood_setting: MoodSetting? = nil) {
        self.mood_setting = mood_setting
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.mood_setting.hash()])
    }
}

public struct DeleteAction: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case delete_action_timestamp = 1
        case delete_upper_bound_timestamp = 2
        case delete_type = 3
    }
    
    public var delete_action_timestamp: UInt64? = nil
    public var delete_upper_bound_timestamp: UInt64? = nil
    public var delete_type: DeleteType? = nil
    
    public init(delete_action_timestamp: UInt64? = nil, delete_upper_bound_timestamp: UInt64? = nil, delete_type: DeleteType? = nil) {
        self.delete_action_timestamp = delete_action_timestamp
        self.delete_upper_bound_timestamp = delete_upper_bound_timestamp
        self.delete_type = delete_type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.delete_action_timestamp.hash(), self.delete_upper_bound_timestamp.hash(), self.delete_type.hash()])
    }
}

public struct InviteeID: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case gaia_id = 1
        case circle_id = 2
        case chat_id = 3
        case fallback_name = 4
    }
    
    public var gaia_id: String? = nil
    public var circle_id: String? = nil
    public var chat_id: String? = nil
    public var fallback_name: String? = nil
    
    public init(gaia_id: String? = nil, circle_id: String? = nil, chat_id: String? = nil, fallback_name: String? = nil) {
        self.gaia_id = gaia_id
        self.circle_id = circle_id
        self.chat_id = chat_id
        self.fallback_name = fallback_name
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.gaia_id.hash(), self.circle_id.hash(), self.chat_id.hash(), self.fallback_name.hash()])
    }
}

public struct Country: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case region_code = 1
        case country_code = 2
    }
    
    public var region_code: String? = nil
    public var country_code: UInt64? = nil
    
    public init(region_code: String? = nil, country_code: UInt64? = nil) {
        self.region_code = region_code
        self.country_code = country_code
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.region_code.hash(), self.country_code.hash()])
    }
}

public struct DesktopSoundSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case desktop_sound_state = 1
        case desktop_ring_sound_state = 2
    }
    
    public var desktop_sound_state: SoundState? = nil
    public var desktop_ring_sound_state: SoundState? = nil
    
    public init(desktop_sound_state: SoundState? = nil, desktop_ring_sound_state: SoundState? = nil) {
        self.desktop_sound_state = desktop_sound_state
        self.desktop_ring_sound_state = desktop_ring_sound_state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.desktop_sound_state.hash(), self.desktop_ring_sound_state.hash()])
    }
}

public struct PhoneData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case phone = 1
        case caller_id_settings_mask = 3
    }
    
    public var phone: [Phone] = []
    public var caller_id_settings_mask: CallerIdSettingsMask? = nil
    
    public init(phone: [Phone] = [], caller_id_settings_mask: CallerIdSettingsMask? = nil) {
        self.phone = phone
        self.caller_id_settings_mask = caller_id_settings_mask
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.phone.hash(), self.caller_id_settings_mask.hash()])
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
    
    public var phone_number: PhoneNumber? = nil
    public var google_voice: Bool? = nil
    public var verification_status: PhoneVerificationStatus? = nil
    public var discoverable: Bool? = nil
    public var discoverability_status: PhoneDiscoverabilityStatus? = nil
    public var primary: Bool? = nil
    
    public init(phone_number: PhoneNumber? = nil, google_voice: Bool? = nil, verification_status: PhoneVerificationStatus? = nil, discoverable: Bool? = nil, discoverability_status: PhoneDiscoverabilityStatus? = nil, primary: Bool? = nil) {
        self.phone_number = phone_number
        self.google_voice = google_voice
        self.verification_status = verification_status
        self.discoverable = discoverable
        self.discoverability_status = discoverability_status
        self.primary = primary
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.phone_number.hash(), self.google_voice.hash(), self.verification_status.hash(), self.discoverable.hash(), self.discoverability_status.hash(), self.primary.hash()])
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
    
    public var national_number: String? = nil
    public var international_number: String? = nil
    public var country_code: UInt64? = nil
    public var region_code: String? = nil
    public var is_valid: Bool? = nil
    public var validation_result: PhoneValidationResult? = nil
    
    public init(national_number: String? = nil, international_number: String? = nil, country_code: UInt64? = nil, region_code: String? = nil, is_valid: Bool? = nil, validation_result: PhoneValidationResult? = nil) {
        self.national_number = national_number
        self.international_number = international_number
        self.country_code = country_code
        self.region_code = region_code
        self.is_valid = is_valid
        self.validation_result = validation_result
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.national_number.hash(), self.international_number.hash(), self.country_code.hash(), self.region_code.hash(), self.is_valid.hash(), self.validation_result.hash()])
    }
}

public struct PhoneNumber: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case e164 = 1
        case i18n_data = 2
    }
    
    public var e164: String? = nil
    public var i18n_data: I18nData? = nil
    
    public init(e164: String? = nil, i18n_data: I18nData? = nil) {
        self.e164 = e164
        self.i18n_data = i18n_data
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.e164.hash(), self.i18n_data.hash()])
    }
}

public struct SuggestedContactGroupHash: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case max_results = 1
        case hash = 2
    }
    
    public var max_results: UInt64? = nil
    public var hash: String? = nil
    
    public init(max_results: UInt64? = nil, hash: String? = nil) {
        self.max_results = max_results
        self.hash = hash
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.max_results.hash(), self.hash.hash()])
    }
}

public struct SuggestedContact: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case entity = 1
        case invitation_status = 2
    }
    
    public var entity: Entity? = nil
    public var invitation_status: InvitationStatus? = nil
    
    public init(entity: Entity? = nil, invitation_status: InvitationStatus? = nil) {
        self.entity = entity
        self.invitation_status = invitation_status
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.entity.hash(), self.invitation_status.hash()])
    }
}

public struct SuggestedContactGroup: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case hash_matched = 1
        case hash = 2
        case contact = 3
    }
    
    public var hash_matched: Bool? = nil
    public var hash: String? = nil
    public var contact: [SuggestedContact] = []
    
    public init(hash_matched: Bool? = nil, hash: String? = nil, contact: [SuggestedContact] = []) {
        self.hash_matched = hash_matched
        self.hash = hash
        self.contact = contact
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.hash_matched.hash(), self.hash.hash(), self.contact.hash()])
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
    
    public var state_update_header: StateUpdateHeader? = nil
    public var conversation: Conversation? = nil
    public var conversation_notification: ConversationNotification? = nil
    public var event_notification: EventNotification? = nil
    public var focus_notification: SetFocusNotification? = nil
    public var typing_notification: SetTypingNotification? = nil
    public var notification_level_notification: SetConversationNotificationLevelNotification? = nil
    public var reply_to_invite_notification: ReplyToInviteNotification? = nil
    public var watermark_notification: WatermarkNotification? = nil
    public var view_modification: ConversationViewModification? = nil
    public var easter_egg_notification: EasterEggNotification? = nil
    public var self_presence_notification: SelfPresenceNotification? = nil
    public var delete_notification: DeleteActionNotification? = nil
    public var presence_notification: PresenceNotification? = nil
    public var block_notification: BlockNotification? = nil
    public var notification_setting_notification: SetNotificationSettingNotification? = nil
    public var rich_presence_enabled_state_notification: RichPresenceEnabledStateNotification? = nil
    
    public init(state_update_header: StateUpdateHeader? = nil, conversation: Conversation? = nil, conversation_notification: ConversationNotification? = nil, event_notification: EventNotification? = nil, focus_notification: SetFocusNotification? = nil, typing_notification: SetTypingNotification? = nil, notification_level_notification: SetConversationNotificationLevelNotification? = nil, reply_to_invite_notification: ReplyToInviteNotification? = nil, watermark_notification: WatermarkNotification? = nil, view_modification: ConversationViewModification? = nil, easter_egg_notification: EasterEggNotification? = nil, self_presence_notification: SelfPresenceNotification? = nil, delete_notification: DeleteActionNotification? = nil, presence_notification: PresenceNotification? = nil, block_notification: BlockNotification? = nil, notification_setting_notification: SetNotificationSettingNotification? = nil, rich_presence_enabled_state_notification: RichPresenceEnabledStateNotification? = nil) {
        self.state_update_header = state_update_header
        self.conversation = conversation
        self.conversation_notification = conversation_notification
        self.event_notification = event_notification
        self.focus_notification = focus_notification
        self.typing_notification = typing_notification
        self.notification_level_notification = notification_level_notification
        self.reply_to_invite_notification = reply_to_invite_notification
        self.watermark_notification = watermark_notification
        self.view_modification = view_modification
        self.easter_egg_notification = easter_egg_notification
        self.self_presence_notification = self_presence_notification
        self.delete_notification = delete_notification
        self.presence_notification = presence_notification
        self.block_notification = block_notification
        self.notification_setting_notification = notification_setting_notification
        self.rich_presence_enabled_state_notification = rich_presence_enabled_state_notification
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.state_update_header.hash(), self.conversation.hash(), self.conversation_notification.hash(), self.event_notification.hash(), self.focus_notification.hash(), self.typing_notification.hash(), self.notification_level_notification.hash(), self.reply_to_invite_notification.hash(), self.watermark_notification.hash(), self.view_modification.hash(), self.easter_egg_notification.hash(), self.self_presence_notification.hash(), self.delete_notification.hash(), self.presence_notification.hash(), self.block_notification.hash(), self.notification_setting_notification.hash(), self.rich_presence_enabled_state_notification.hash()])
    }
}

public struct StateUpdateHeader: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case active_client_state = 1
        case request_trace_id = 3
        case notification_settings = 4
        case current_server_time = 5
    }
    
    public var active_client_state: ActiveClientState? = nil
    public var request_trace_id: String? = nil
    public var notification_settings: NotificationSettings? = nil
    public var current_server_time: UInt64? = nil
    
    public init(active_client_state: ActiveClientState? = nil, request_trace_id: String? = nil, notification_settings: NotificationSettings? = nil, current_server_time: UInt64? = nil) {
        self.active_client_state = active_client_state
        self.request_trace_id = request_trace_id
        self.notification_settings = notification_settings
        self.current_server_time = current_server_time
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.active_client_state.hash(), self.request_trace_id.hash(), self.notification_settings.hash(), self.current_server_time.hash()])
    }
}

public struct BatchUpdate: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case state_update = 1
    }
    
    public var state_update: [StateUpdate] = []
    
    public init(state_update: [StateUpdate] = []) {
        self.state_update = state_update
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.state_update.hash()])
    }
}

public struct ConversationNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation = 1
    }
    
    public var conversation: Conversation? = nil
    
    public init(conversation: Conversation? = nil) {
        self.conversation = conversation
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation.hash()])
    }
}

public struct EventNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case event = 1
    }
    
    public var event: Event? = nil
    
    public init(event: Event? = nil) {
        self.event = event
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.event.hash()])
    }
}

public struct SetFocusNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case sender_id = 2
        case timestamp = 3
        case type = 4
    }
    
    public var conversation_id: ConversationId? = nil
    public var sender_id: ParticipantId? = nil
    public var timestamp: UInt64? = nil
    public var type: FocusType? = nil
    
    public init(conversation_id: ConversationId? = nil, sender_id: ParticipantId? = nil, timestamp: UInt64? = nil, type: FocusType? = nil) {
        self.conversation_id = conversation_id
        self.sender_id = sender_id
        self.timestamp = timestamp
        self.type = type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.sender_id.hash(), self.timestamp.hash(), self.type.hash()])
    }
}

public struct SetTypingNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case sender_id = 2
        case timestamp = 3
        case type = 4
    }
    
    public var conversation_id: ConversationId? = nil
    public var sender_id: ParticipantId? = nil
    public var timestamp: UInt64? = nil
    public var type: TypingType? = nil
    
    public init(conversation_id: ConversationId? = nil, sender_id: ParticipantId? = nil, timestamp: UInt64? = nil, type: TypingType? = nil) {
        self.conversation_id = conversation_id
        self.sender_id = sender_id
        self.timestamp = timestamp
        self.type = type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.sender_id.hash(), self.timestamp.hash(), self.type.hash()])
    }
}

public struct SetConversationNotificationLevelNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case level = 2
        case revert_timeout_secs = 3
        case timestamp = 4
    }
    
    public var conversation_id: ConversationId? = nil
    public var level: NotificationLevel? = nil
    public var revert_timeout_secs: UInt32? = nil
    public var timestamp: UInt64? = nil
    
    public init(conversation_id: ConversationId? = nil, level: NotificationLevel? = nil, revert_timeout_secs: UInt32? = nil, timestamp: UInt64? = nil) {
        self.conversation_id = conversation_id
        self.level = level
        self.revert_timeout_secs = revert_timeout_secs
        self.timestamp = timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.level.hash(), self.revert_timeout_secs.hash(), self.timestamp.hash()])
    }
}

public struct ReplyToInviteNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case type = 2
    }
    
    public var conversation_id: ConversationId? = nil
    public var type: ReplyToInviteType? = nil
    
    public init(conversation_id: ConversationId? = nil, type: ReplyToInviteType? = nil) {
        self.conversation_id = conversation_id
        self.type = type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.type.hash()])
    }
}

public struct WatermarkNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case sender_id = 1
        case conversation_id = 2
        case latest_read_timestamp = 3
    }
    
    public var sender_id: ParticipantId? = nil
    public var conversation_id: ConversationId? = nil
    public var latest_read_timestamp: UInt64? = nil
    
    public init(sender_id: ParticipantId? = nil, conversation_id: ConversationId? = nil, latest_read_timestamp: UInt64? = nil) {
        self.sender_id = sender_id
        self.conversation_id = conversation_id
        self.latest_read_timestamp = latest_read_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.sender_id.hash(), self.conversation_id.hash(), self.latest_read_timestamp.hash()])
    }
}

public struct ConversationViewModification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case old_view = 2
        case new_view = 3
    }
    
    public var conversation_id: ConversationId? = nil
    public var old_view: ConversationView? = nil
    public var new_view: ConversationView? = nil
    
    public init(conversation_id: ConversationId? = nil, old_view: ConversationView? = nil, new_view: ConversationView? = nil) {
        self.conversation_id = conversation_id
        self.old_view = old_view
        self.new_view = new_view
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.old_view.hash(), self.new_view.hash()])
    }
}

public struct GroupLinkSharingModification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case new_status = 1
    }
    
    public var new_status: GroupLinkSharingStatus? = nil
    
    public init(new_status: GroupLinkSharingStatus? = nil) {
        self.new_status = new_status
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.new_status.hash()])
    }
}

public struct EasterEggNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case sender_id = 1
        case conversation_id = 2
        case easter_egg = 3
    }
    
    public var sender_id: ParticipantId? = nil
    public var conversation_id: ConversationId? = nil
    public var easter_egg: EasterEgg? = nil
    
    public init(sender_id: ParticipantId? = nil, conversation_id: ConversationId? = nil, easter_egg: EasterEgg? = nil) {
        self.sender_id = sender_id
        self.conversation_id = conversation_id
        self.easter_egg = easter_egg
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.sender_id.hash(), self.conversation_id.hash(), self.easter_egg.hash()])
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
    
    public var client_presence_state: ClientPresenceState? = nil
    public var do_not_disturb_setting: DoNotDisturbSetting? = nil
    public var desktop_off_setting: DesktopOffSetting? = nil
    public var desktop_off_state: DesktopOffState? = nil
    public var mood_state: MoodState? = nil
    
    public init(client_presence_state: ClientPresenceState? = nil, do_not_disturb_setting: DoNotDisturbSetting? = nil, desktop_off_setting: DesktopOffSetting? = nil, desktop_off_state: DesktopOffState? = nil, mood_state: MoodState? = nil) {
        self.client_presence_state = client_presence_state
        self.do_not_disturb_setting = do_not_disturb_setting
        self.desktop_off_setting = desktop_off_setting
        self.desktop_off_state = desktop_off_state
        self.mood_state = mood_state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.client_presence_state.hash(), self.do_not_disturb_setting.hash(), self.desktop_off_setting.hash(), self.desktop_off_state.hash(), self.mood_state.hash()])
    }
}

public struct DeleteActionNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case delete_action = 2
    }
    
    public var conversation_id: ConversationId? = nil
    public var delete_action: DeleteAction? = nil
    
    public init(conversation_id: ConversationId? = nil, delete_action: DeleteAction? = nil) {
        self.conversation_id = conversation_id
        self.delete_action = delete_action
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.delete_action.hash()])
    }
}

public struct PresenceNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case presence = 1
    }
    
    public var presence: [PresenceResult] = []
    
    public init(presence: [PresenceResult] = []) {
        self.presence = presence
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.presence.hash()])
    }
}

public struct BlockNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case block_state_change = 1
    }
    
    public var block_state_change: [BlockStateChange] = []
    
    public init(block_state_change: [BlockStateChange] = []) {
        self.block_state_change = block_state_change
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.block_state_change.hash()])
    }
}

public struct InvitationWatermarkNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case state = 1
    }
    
    public var state: InvitationState? = nil
    
    public init(state: InvitationState? = nil) {
        self.state = state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.state.hash()])
    }
}

public struct SetNotificationSettingNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case configuration_bit = 1
        case desktop_sound_setting = 2
    }
    
    public var configuration_bit: [ConfigurationBit] = []
    public var desktop_sound_setting: DesktopSoundSetting? = nil
    
    public init(configuration_bit: [ConfigurationBit] = [], desktop_sound_setting: DesktopSoundSetting? = nil) {
        self.configuration_bit = configuration_bit
        self.desktop_sound_setting = desktop_sound_setting
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.configuration_bit.hash(), self.desktop_sound_setting.hash()])
    }
}

public struct RichPresenceEnabledStateNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case rich_presence_enabled_state = 1
    }
    
    public var rich_presence_enabled_state: [RichPresenceEnabledState] = []
    
    public init(rich_presence_enabled_state: [RichPresenceEnabledState] = []) {
        self.rich_presence_enabled_state = rich_presence_enabled_state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.rich_presence_enabled_state.hash()])
    }
}

public struct ConversationSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case participant_id = 2
        case invitee_id = 3
    }
    
    public var conversation_id: ConversationId? = nil
    public var participant_id: ParticipantId? = nil
    public var invitee_id: InviteeID? = nil
    
    public init(conversation_id: ConversationId? = nil, participant_id: ParticipantId? = nil, invitee_id: InviteeID? = nil) {
        self.conversation_id = conversation_id
        self.participant_id = participant_id
        self.invitee_id = invitee_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.participant_id.hash(), self.invitee_id.hash()])
    }
}

public struct OffnetworkAddress: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case email = 3
    }
    
    public var type: OffnetworkAddressType? = nil
    public var email: String? = nil
    
    public init(type: OffnetworkAddressType? = nil, email: String? = nil) {
        self.type = type
        self.email = email
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.type.hash(), self.email.hash()])
    }
}

public struct AddUserRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case invitee_id = 3
        case event_request_header = 5
    }
    
    public var request_header: RequestHeader? = nil
    public var invitee_id: [InviteeID] = []
    public var event_request_header: EventRequestHeader? = nil
    
    public init(request_header: RequestHeader? = nil, invitee_id: [InviteeID] = [], event_request_header: EventRequestHeader? = nil) {
        self.request_header = request_header
        self.invitee_id = invitee_id
        self.event_request_header = event_request_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.invitee_id.hash(), self.event_request_header.hash()])
    }
}

public struct AddUserResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case created_event = 5
    }
    
    public var response_header: ResponseHeader? = nil
    public var created_event: Event? = nil
    
    public init(response_header: ResponseHeader? = nil, created_event: Event? = nil) {
        self.response_header = response_header
        self.created_event = created_event
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.created_event.hash()])
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
    
    public var request_header: RequestHeader? = nil
    public var type: ConversationType? = nil
    public var client_generated_id: UInt64? = nil
    public var name: String? = nil
    public var invitee_id: [InviteeID] = []
    
    public init(request_header: RequestHeader? = nil, type: ConversationType? = nil, client_generated_id: UInt64? = nil, name: String? = nil, invitee_id: [InviteeID] = []) {
        self.request_header = request_header
        self.type = type
        self.client_generated_id = client_generated_id
        self.name = name
        self.invitee_id = invitee_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.type.hash(), self.client_generated_id.hash(), self.name.hash(), self.invitee_id.hash()])
    }
}

public struct CreateConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case conversation = 2
        case new_conversation_created = 7
    }
    
    public var response_header: ResponseHeader? = nil
    public var conversation: Conversation? = nil
    public var new_conversation_created: Bool? = nil
    
    public init(response_header: ResponseHeader? = nil, conversation: Conversation? = nil, new_conversation_created: Bool? = nil) {
        self.response_header = response_header
        self.conversation = conversation
        self.new_conversation_created = new_conversation_created
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.conversation.hash(), self.new_conversation_created.hash()])
    }
}

public struct DeleteConversationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case delete_upper_bound_timestamp = 3
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var delete_upper_bound_timestamp: UInt64? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, delete_upper_bound_timestamp: UInt64? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.delete_upper_bound_timestamp = delete_upper_bound_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.delete_upper_bound_timestamp.hash()])
    }
}

public struct DeleteConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case delete_action = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var delete_action: DeleteAction? = nil
    
    public init(response_header: ResponseHeader? = nil, delete_action: DeleteAction? = nil) {
        self.response_header = response_header
        self.delete_action = delete_action
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.delete_action.hash()])
    }
}

public struct EasterEggRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case easter_egg = 3
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var easter_egg: EasterEgg? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, easter_egg: EasterEgg? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.easter_egg = easter_egg
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.easter_egg.hash()])
    }
}

public struct EasterEggResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash()])
    }
}

public struct GetConversationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_spec = 2
        case include_conversation_metadata = 3
        case include_event = 4
        case max_events_per_conversation = 6
        case event_continuation_token = 7
        case include_presence = 8
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_spec: ConversationSpec? = nil
    public var include_conversation_metadata: Bool? = nil
    public var include_event: Bool? = nil
    public var max_events_per_conversation: UInt64? = nil
    public var event_continuation_token: EventContinuationToken? = nil
    public var include_presence: Bool? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_spec: ConversationSpec? = nil, include_conversation_metadata: Bool? = nil, include_event: Bool? = nil, max_events_per_conversation: UInt64? = nil, event_continuation_token: EventContinuationToken? = nil, include_presence: Bool? = nil) {
        self.request_header = request_header
        self.conversation_spec = conversation_spec
        self.include_conversation_metadata = include_conversation_metadata
        self.include_event = include_event
        self.max_events_per_conversation = max_events_per_conversation
        self.event_continuation_token = event_continuation_token
        self.include_presence = include_presence
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_spec.hash(), self.include_conversation_metadata.hash(), self.include_event.hash(), self.max_events_per_conversation.hash(), self.event_continuation_token.hash(), self.include_presence.hash()])
    }
}

public struct GetConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case conversation_state = 2
        case presence = 4
    }
    
    public var response_header: ResponseHeader? = nil
    public var conversation_state: ConversationState? = nil
    public var presence: PresenceResult? = nil
    
    public init(response_header: ResponseHeader? = nil, conversation_state: ConversationState? = nil, presence: PresenceResult? = nil) {
        self.response_header = response_header
        self.conversation_state = conversation_state
        self.presence = presence
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.conversation_state.hash(), self.presence.hash()])
    }
}

public struct GetEntityByIdRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case lookup_spec = 2
        case batch_lookup_spec = 3
        case field_mask = 4
    }
    
    public var request_header: RequestHeader? = nil
    public var lookup_spec: EntityLookupSpec? = nil
    public var batch_lookup_spec: [EntityLookupSpec] = []
    public var field_mask: [FieldMask] = []
    
    public init(request_header: RequestHeader? = nil, lookup_spec: EntityLookupSpec? = nil, batch_lookup_spec: [EntityLookupSpec] = [], field_mask: [FieldMask] = []) {
        self.request_header = request_header
        self.lookup_spec = lookup_spec
        self.batch_lookup_spec = batch_lookup_spec
        self.field_mask = field_mask
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.lookup_spec.hash(), self.batch_lookup_spec.hash(), self.field_mask.hash()])
    }
}

public struct GetEntityByIdResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case entity = 2
        case entity_result = 3
    }
    
    public var response_header: ResponseHeader? = nil
    public var entity: [Entity] = []
    public var entity_result: [EntityResult] = []
    
    public init(response_header: ResponseHeader? = nil, entity: [Entity] = [], entity_result: [EntityResult] = []) {
        self.response_header = response_header
        self.entity = entity
        self.entity_result = entity_result
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.entity.hash(), self.entity_result.hash()])
    }
}

public struct EntityResult: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case lookup_spec = 1
        case entity = 2
    }
    
    public var lookup_spec: EntityLookupSpec? = nil
    public var entity: [Entity] = []
    
    public init(lookup_spec: EntityLookupSpec? = nil, entity: [Entity] = []) {
        self.lookup_spec = lookup_spec
        self.entity = entity
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.lookup_spec.hash(), self.entity.hash()])
    }
}

public struct GetGroupConversationUrlRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash()])
    }
}

public struct GetGroupConversationUrlResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case group_conversation_url = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var group_conversation_url: String? = nil
    
    public init(response_header: ResponseHeader? = nil, group_conversation_url: String? = nil) {
        self.response_header = response_header
        self.group_conversation_url = group_conversation_url
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.group_conversation_url.hash()])
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
    
    public var request_header: RequestHeader? = nil
    public var max_count: UInt64? = nil
    public var favorites: SuggestedContactGroupHash? = nil
    public var contacts_you_hangout_with: SuggestedContactGroupHash? = nil
    public var other_contacts_on_hangouts: SuggestedContactGroupHash? = nil
    public var other_contacts: SuggestedContactGroupHash? = nil
    public var dismissed_contacts: SuggestedContactGroupHash? = nil
    public var pinned_favorites: SuggestedContactGroupHash? = nil
    
    public init(request_header: RequestHeader? = nil, max_count: UInt64? = nil, favorites: SuggestedContactGroupHash? = nil, contacts_you_hangout_with: SuggestedContactGroupHash? = nil, other_contacts_on_hangouts: SuggestedContactGroupHash? = nil, other_contacts: SuggestedContactGroupHash? = nil, dismissed_contacts: SuggestedContactGroupHash? = nil, pinned_favorites: SuggestedContactGroupHash? = nil) {
        self.request_header = request_header
        self.max_count = max_count
        self.favorites = favorites
        self.contacts_you_hangout_with = contacts_you_hangout_with
        self.other_contacts_on_hangouts = other_contacts_on_hangouts
        self.other_contacts = other_contacts
        self.dismissed_contacts = dismissed_contacts
        self.pinned_favorites = pinned_favorites
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.max_count.hash(), self.favorites.hash(), self.contacts_you_hangout_with.hash(), self.other_contacts_on_hangouts.hash(), self.other_contacts.hash(), self.dismissed_contacts.hash(), self.pinned_favorites.hash()])
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
    
    public var response_header: ResponseHeader? = nil
    public var entity: [Entity] = []
    public var favorites: SuggestedContactGroup? = nil
    public var contacts_you_hangout_with: SuggestedContactGroup? = nil
    public var other_contacts_on_hangouts: SuggestedContactGroup? = nil
    public var other_contacts: SuggestedContactGroup? = nil
    public var dismissed_contacts: SuggestedContactGroup? = nil
    public var pinned_favorites: SuggestedContactGroup? = nil
    
    public init(response_header: ResponseHeader? = nil, entity: [Entity] = [], favorites: SuggestedContactGroup? = nil, contacts_you_hangout_with: SuggestedContactGroup? = nil, other_contacts_on_hangouts: SuggestedContactGroup? = nil, other_contacts: SuggestedContactGroup? = nil, dismissed_contacts: SuggestedContactGroup? = nil, pinned_favorites: SuggestedContactGroup? = nil) {
        self.response_header = response_header
        self.entity = entity
        self.favorites = favorites
        self.contacts_you_hangout_with = contacts_you_hangout_with
        self.other_contacts_on_hangouts = other_contacts_on_hangouts
        self.other_contacts = other_contacts
        self.dismissed_contacts = dismissed_contacts
        self.pinned_favorites = pinned_favorites
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.entity.hash(), self.favorites.hash(), self.contacts_you_hangout_with.hash(), self.other_contacts_on_hangouts.hash(), self.other_contacts.hash(), self.dismissed_contacts.hash(), self.pinned_favorites.hash()])
    }
}

public struct GetSelfInfoRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
    }
    
    public var request_header: RequestHeader? = nil
    
    public init(request_header: RequestHeader? = nil) {
        self.request_header = request_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash()])
    }
}

public struct GetSelfInfoResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case self_entity = 2
        case is_known_minor = 3
        case client_presence = 4
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
    
    public var response_header: ResponseHeader? = nil
    public var self_entity: Entity? = nil
    public var is_known_minor: Bool? = nil
    public var client_presence: [ClientPresenceState] = []
    public var dnd_state: DoNotDisturbSetting? = nil
    public var desktop_off_setting: DesktopOffSetting? = nil
    public var phone_data: PhoneData? = nil
    public var configuration_bit: [ConfigurationBit] = []
    public var desktop_off_state: DesktopOffState? = nil
    public var google_plus_user: Bool? = nil
    public var desktop_sound_setting: DesktopSoundSetting? = nil
    public var rich_presence_state: RichPresenceState? = nil
    public var default_country: Country? = nil
    
    public init(response_header: ResponseHeader? = nil, self_entity: Entity? = nil, is_known_minor: Bool? = nil, client_presence: [ClientPresenceState] = [], dnd_state: DoNotDisturbSetting? = nil, desktop_off_setting: DesktopOffSetting? = nil, phone_data: PhoneData? = nil, configuration_bit: [ConfigurationBit] = [], desktop_off_state: DesktopOffState? = nil, google_plus_user: Bool? = nil, desktop_sound_setting: DesktopSoundSetting? = nil, rich_presence_state: RichPresenceState? = nil, default_country: Country? = nil) {
        self.response_header = response_header
        self.self_entity = self_entity
        self.is_known_minor = is_known_minor
        self.client_presence = client_presence
        self.dnd_state = dnd_state
        self.desktop_off_setting = desktop_off_setting
        self.phone_data = phone_data
        self.configuration_bit = configuration_bit
        self.desktop_off_state = desktop_off_state
        self.google_plus_user = google_plus_user
        self.desktop_sound_setting = desktop_sound_setting
        self.rich_presence_state = rich_presence_state
        self.default_country = default_country
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.self_entity.hash(), self.is_known_minor.hash(), self.client_presence.hash(), self.dnd_state.hash(), self.desktop_off_setting.hash(), self.phone_data.hash(), self.configuration_bit.hash(), self.desktop_off_state.hash(), self.google_plus_user.hash(), self.desktop_sound_setting.hash(), self.rich_presence_state.hash(), self.default_country.hash()])
    }
}

public struct ModifyConversationViewRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case new_view = 3
        case last_event_timestamp = 4
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var new_view: ConversationView? = nil
    public var last_event_timestamp: UInt64? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, new_view: ConversationView? = nil, last_event_timestamp: UInt64? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.new_view = new_view
        self.last_event_timestamp = last_event_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.new_view.hash(), self.last_event_timestamp.hash()])
    }
}

public struct ModifyConversationViewResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader? = nil
    
    public init(response_header: ResponseHeader? = nil) {
        self.response_header = response_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash()])
    }
}

public struct OpenGroupConversationFromUrlRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case url = 3
    }
    
    public var request_header: RequestHeader? = nil
    public var url: String? = nil
    
    public init(request_header: RequestHeader? = nil, url: String? = nil) {
        self.request_header = request_header
        self.url = url
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.url.hash()])
    }
}

public struct OpenGroupConversationFromUrlResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case conversation_id = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var conversation_id: ConversationId? = nil
    
    public init(response_header: ResponseHeader? = nil, conversation_id: ConversationId? = nil) {
        self.response_header = response_header
        self.conversation_id = conversation_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.conversation_id.hash()])
    }
}

public struct QueryPresenceRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case participant_id = 2
        case field_mask = 3
    }
    
    public var request_header: RequestHeader? = nil
    public var participant_id: [ParticipantId] = []
    public var field_mask: [FieldMask] = []
    
    public init(request_header: RequestHeader? = nil, participant_id: [ParticipantId] = [], field_mask: [FieldMask] = []) {
        self.request_header = request_header
        self.participant_id = participant_id
        self.field_mask = field_mask
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.participant_id.hash(), self.field_mask.hash()])
    }
}

public struct QueryPresenceResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case presence_result = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var presence_result: [PresenceResult] = []
    
    public init(response_header: ResponseHeader? = nil, presence_result: [PresenceResult] = []) {
        self.response_header = response_header
        self.presence_result = presence_result
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.presence_result.hash()])
    }
}

public struct RemoveUserRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case participant_id = 3
        case client_generated_id = 4
        case event_request_header = 5
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var participant_id: ParticipantId? = nil
    public var client_generated_id: UInt64? = nil
    public var event_request_header: EventRequestHeader? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, participant_id: ParticipantId? = nil, client_generated_id: UInt64? = nil, event_request_header: EventRequestHeader? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.participant_id = participant_id
        self.client_generated_id = client_generated_id
        self.event_request_header = event_request_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.participant_id.hash(), self.client_generated_id.hash(), self.event_request_header.hash()])
    }
}

public struct RemoveUserResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
        case event_id = 3
        case created_event = 4
        case updated_conversation = 5
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    public var event_id: String? = nil
    public var created_event: Event? = nil
    public var updated_conversation: Conversation? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil, event_id: String? = nil, created_event: Event? = nil, updated_conversation: Conversation? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
        self.event_id = event_id
        self.created_event = created_event
        self.updated_conversation = updated_conversation
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash(), self.event_id.hash(), self.created_event.hash(), self.updated_conversation.hash()])
    }
}

public struct RenameConversationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case new_name = 3
        case client_generated_id = 4
        case event_request_header = 5
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var new_name: String? = nil
    public var client_generated_id: UInt64? = nil
    public var event_request_header: EventRequestHeader? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, new_name: String? = nil, client_generated_id: UInt64? = nil, event_request_header: EventRequestHeader? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.new_name = new_name
        self.client_generated_id = client_generated_id
        self.event_request_header = event_request_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.new_name.hash(), self.client_generated_id.hash(), self.event_request_header.hash()])
    }
}

public struct RenameConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
        case event_id = 3
        case created_event = 4
        case updated_conversation = 5
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    public var event_id: String? = nil
    public var created_event: Event? = nil
    public var updated_conversation: Conversation? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil, event_id: String? = nil, created_event: Event? = nil, updated_conversation: Conversation? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
        self.event_id = event_id
        self.created_event = created_event
        self.updated_conversation = updated_conversation
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash(), self.event_id.hash(), self.created_event.hash(), self.updated_conversation.hash()])
    }
}

public struct SearchEntitiesRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case query = 3
        case max_count = 4
    }
    
    public var request_header: RequestHeader? = nil
    public var query: String? = nil
    public var max_count: UInt64? = nil
    
    public init(request_header: RequestHeader? = nil, query: String? = nil, max_count: UInt64? = nil) {
        self.request_header = request_header
        self.query = query
        self.max_count = max_count
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.query.hash(), self.max_count.hash()])
    }
}

public struct SearchEntitiesResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case entity = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var entity: [Entity] = []
    
    public init(response_header: ResponseHeader? = nil, entity: [Entity] = []) {
        self.response_header = response_header
        self.entity = entity
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.entity.hash()])
    }
}

public struct SendChatMessageRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case client_generated_id = 3
        case annotation = 5
        case message_content = 6
        case existing_media = 7
        case event_request_header = 8
        case other_invitee_id = 9
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var client_generated_id: UInt64? = nil
    public var annotation: [EventAnnotation] = []
    public var message_content: MessageContent? = nil
    public var existing_media: ExistingMedia? = nil
    public var event_request_header: EventRequestHeader? = nil
    public var other_invitee_id: InviteeID? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, client_generated_id: UInt64? = nil, annotation: [EventAnnotation] = [], message_content: MessageContent? = nil, existing_media: ExistingMedia? = nil, event_request_header: EventRequestHeader? = nil, other_invitee_id: InviteeID? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.client_generated_id = client_generated_id
        self.annotation = annotation
        self.message_content = message_content
        self.existing_media = existing_media
        self.event_request_header = event_request_header
        self.other_invitee_id = other_invitee_id
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.client_generated_id.hash(), self.annotation.hash(), self.message_content.hash(), self.existing_media.hash(), self.event_request_header.hash(), self.other_invitee_id.hash()])
    }
}

public struct SendChatMessageResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
        case event_id = 3
        case created_event = 6
        case updated_conversation = 7
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    public var event_id: String? = nil
    public var created_event: Event? = nil
    public var updated_conversation: Conversation? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil, event_id: String? = nil, created_event: Event? = nil, updated_conversation: Conversation? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
        self.event_id = event_id
        self.created_event = created_event
        self.updated_conversation = updated_conversation
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash(), self.event_id.hash(), self.created_event.hash(), self.updated_conversation.hash()])
    }
}

public struct ModifyOTRStatusRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case otr_status = 3
        case event_request_header = 5
    }
    
    public var request_header: RequestHeader? = nil
    public var otr_status: OffTheRecordStatus? = nil
    public var event_request_header: EventRequestHeader? = nil
    
    public init(request_header: RequestHeader? = nil, otr_status: OffTheRecordStatus? = nil, event_request_header: EventRequestHeader? = nil) {
        self.request_header = request_header
        self.otr_status = otr_status
        self.event_request_header = event_request_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.otr_status.hash(), self.event_request_header.hash()])
    }
}

public struct ModifyOTRStatusResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case created_event = 4
    }
    
    public var response_header: ResponseHeader? = nil
    public var created_event: Event? = nil
    
    public init(response_header: ResponseHeader? = nil, created_event: Event? = nil) {
        self.response_header = response_header
        self.created_event = created_event
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.created_event.hash()])
    }
}

public struct SendOffnetworkInvitationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case invitee_address = 2
    }
    
    public var request_header: RequestHeader? = nil
    public var invitee_address: OffnetworkAddress? = nil
    
    public init(request_header: RequestHeader? = nil, invitee_address: OffnetworkAddress? = nil) {
        self.request_header = request_header
        self.invitee_address = invitee_address
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.invitee_address.hash()])
    }
}

public struct SendOffnetworkInvitationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader? = nil
    
    public init(response_header: ResponseHeader? = nil) {
        self.response_header = response_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash()])
    }
}

public struct SetActiveClientRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case is_active = 2
        case full_jid = 3
        case timeout_secs = 4
    }
    
    public var request_header: RequestHeader? = nil
    public var is_active: Bool? = nil
    public var full_jid: String? = nil
    public var timeout_secs: UInt64? = nil
    
    public init(request_header: RequestHeader? = nil, is_active: Bool? = nil, full_jid: String? = nil, timeout_secs: UInt64? = nil) {
        self.request_header = request_header
        self.is_active = is_active
        self.full_jid = full_jid
        self.timeout_secs = timeout_secs
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.is_active.hash(), self.full_jid.hash(), self.timeout_secs.hash()])
    }
}

public struct SetActiveClientResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case client_last_seen_timestamp_usec = 3
        case last_seen_delta_usec = 4
    }
    
    public var response_header: ResponseHeader? = nil
    public var client_last_seen_timestamp_usec: UInt64? = nil
    public var last_seen_delta_usec: UInt64? = nil
    
    public init(response_header: ResponseHeader? = nil, client_last_seen_timestamp_usec: UInt64? = nil, last_seen_delta_usec: UInt64? = nil) {
        self.response_header = response_header
        self.client_last_seen_timestamp_usec = client_last_seen_timestamp_usec
        self.last_seen_delta_usec = last_seen_delta_usec
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.client_last_seen_timestamp_usec.hash(), self.last_seen_delta_usec.hash()])
    }
}

public struct SetConversationLevelRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case level = 3
        case revert_timeout_secs = 4
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var level: NotificationLevel? = nil
    public var revert_timeout_secs: UInt32? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, level: NotificationLevel? = nil, revert_timeout_secs: UInt32? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.level = level
        self.revert_timeout_secs = revert_timeout_secs
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.level.hash(), self.revert_timeout_secs.hash()])
    }
}

public struct SetConversationLevelResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash()])
    }
}

public struct SetConversationNotificationLevelRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case level = 3
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var level: NotificationLevel? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, level: NotificationLevel? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.level = level
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.level.hash()])
    }
}

public struct SetConversationNotificationLevelResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash()])
    }
}

public struct SetFocusRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case type = 3
        case timeout_secs = 4
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var type: FocusType? = nil
    public var timeout_secs: UInt32? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, type: FocusType? = nil, timeout_secs: UInt32? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.type = type
        self.timeout_secs = timeout_secs
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.type.hash(), self.timeout_secs.hash()])
    }
}

public struct SetFocusResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash()])
    }
}

public struct SetGroupLinkSharingEnabledRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case event_request_header = 2
        case group_link_sharing_status = 4
    }
    
    public var request_header: RequestHeader? = nil
    public var event_request_header: EventRequestHeader? = nil
    public var group_link_sharing_status: GroupLinkSharingStatus? = nil
    
    public init(request_header: RequestHeader? = nil, event_request_header: EventRequestHeader? = nil, group_link_sharing_status: GroupLinkSharingStatus? = nil) {
        self.request_header = request_header
        self.event_request_header = event_request_header
        self.group_link_sharing_status = group_link_sharing_status
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.event_request_header.hash(), self.group_link_sharing_status.hash()])
    }
}

public struct SetGroupLinkSharingEnabledResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case created_event = 2
        case updated_conversation = 3
    }
    
    public var response_header: ResponseHeader? = nil
    public var created_event: Event? = nil
    public var updated_conversation: Conversation? = nil
    
    public init(response_header: ResponseHeader? = nil, created_event: Event? = nil, updated_conversation: Conversation? = nil) {
        self.response_header = response_header
        self.created_event = created_event
        self.updated_conversation = updated_conversation
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.created_event.hash(), self.updated_conversation.hash()])
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
    
    public var request_header: RequestHeader? = nil
    public var presence_state_setting: PresenceStateSetting? = nil
    public var dnd_setting: DndSetting? = nil
    public var desktop_off_setting: DesktopOffSetting? = nil
    public var mood_setting: MoodSetting? = nil
    
    public init(request_header: RequestHeader? = nil, presence_state_setting: PresenceStateSetting? = nil, dnd_setting: DndSetting? = nil, desktop_off_setting: DesktopOffSetting? = nil, mood_setting: MoodSetting? = nil) {
        self.request_header = request_header
        self.presence_state_setting = presence_state_setting
        self.dnd_setting = dnd_setting
        self.desktop_off_setting = desktop_off_setting
        self.mood_setting = mood_setting
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.presence_state_setting.hash(), self.dnd_setting.hash(), self.desktop_off_setting.hash(), self.mood_setting.hash()])
    }
}

public struct SetPresenceResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader? = nil
    
    public init(response_header: ResponseHeader? = nil) {
        self.response_header = response_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash()])
    }
}

public struct SetTypingRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case type = 3
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var type: TypingType? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, type: TypingType? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.type = type
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.type.hash()])
    }
}

public struct SetTypingResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case timestamp = 2
    }
    
    public var response_header: ResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(response_header: ResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.response_header = response_header
        self.timestamp = timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.timestamp.hash()])
    }
}

public struct UnreadConversationState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation_id = 1
        case timestamp = 2
    }
    
    public var conversation_id: ConversationId? = nil
    public var timestamp: UInt64? = nil
    
    public init(conversation_id: ConversationId? = nil, timestamp: UInt64? = nil) {
        self.conversation_id = conversation_id
        self.timestamp = timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.conversation_id.hash(), self.timestamp.hash()])
    }
}

public struct SyncAllNewEventsRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case last_sync_timestamp = 2
        case max_total_events = 4
        case sync_filter = 5
        case no_missed_events_expected = 6
        case unread_state = 7
        case max_response_size_bytes = 8
    }
    
    public var request_header: RequestHeader? = nil
    public var last_sync_timestamp: UInt64? = nil
    public var max_total_events: UInt64? = nil
    public var sync_filter: [SyncFilter] = []
    public var no_missed_events_expected: Bool? = nil
    public var unread_state: UnreadConversationState? = nil
    public var max_response_size_bytes: UInt64? = nil
    
    public init(request_header: RequestHeader? = nil, last_sync_timestamp: UInt64? = nil, max_total_events: UInt64? = nil, sync_filter: [SyncFilter] = [], no_missed_events_expected: Bool? = nil, unread_state: UnreadConversationState? = nil, max_response_size_bytes: UInt64? = nil) {
        self.request_header = request_header
        self.last_sync_timestamp = last_sync_timestamp
        self.max_total_events = max_total_events
        self.sync_filter = sync_filter
        self.no_missed_events_expected = no_missed_events_expected
        self.unread_state = unread_state
        self.max_response_size_bytes = max_response_size_bytes
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.last_sync_timestamp.hash(), self.max_total_events.hash(), self.sync_filter.hash(), self.no_missed_events_expected.hash(), self.unread_state.hash(), self.max_response_size_bytes.hash()])
    }
}

public struct SyncAllNewEventsResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case sync_timestamp = 2
        case conversation_state = 3
        case conversation_ids_only = 4
        case invitation_state = 5
        case clear_cache_and_resync = 6
    }
    
    public var response_header: ResponseHeader? = nil
    public var sync_timestamp: UInt64? = nil
    public var conversation_state: [ConversationState] = []
    public var conversation_ids_only: Bool? = nil
    public var invitation_state: InvitationState? = nil
    public var clear_cache_and_resync: Bool? = nil
    
    public init(response_header: ResponseHeader? = nil, sync_timestamp: UInt64? = nil, conversation_state: [ConversationState] = [], conversation_ids_only: Bool? = nil, invitation_state: InvitationState? = nil, clear_cache_and_resync: Bool? = nil) {
        self.response_header = response_header
        self.sync_timestamp = sync_timestamp
        self.conversation_state = conversation_state
        self.conversation_ids_only = conversation_ids_only
        self.invitation_state = invitation_state
        self.clear_cache_and_resync = clear_cache_and_resync
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.sync_timestamp.hash(), self.conversation_state.hash(), self.conversation_ids_only.hash(), self.invitation_state.hash(), self.clear_cache_and_resync.hash()])
    }
}

public struct SyncRecentConversationsRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case end_timestamp = 2
        case max_conversations = 3
        case max_events_per_conversation = 4
        case sync_filter = 5
    }
    
    public var request_header: RequestHeader? = nil
    public var end_timestamp: UInt64? = nil
    public var max_conversations: UInt64? = nil
    public var max_events_per_conversation: UInt64? = nil
    public var sync_filter: [SyncFilter] = []
    
    public init(request_header: RequestHeader? = nil, end_timestamp: UInt64? = nil, max_conversations: UInt64? = nil, max_events_per_conversation: UInt64? = nil, sync_filter: [SyncFilter] = []) {
        self.request_header = request_header
        self.end_timestamp = end_timestamp
        self.max_conversations = max_conversations
        self.max_events_per_conversation = max_events_per_conversation
        self.sync_filter = sync_filter
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.end_timestamp.hash(), self.max_conversations.hash(), self.max_events_per_conversation.hash(), self.sync_filter.hash()])
    }
}

public struct SyncRecentConversationsResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
        case sync_timestamp = 2
        case conversation_state = 3
        case continuation_end_timestamp = 4
        case invitation_state = 5
    }
    
    public var response_header: ResponseHeader? = nil
    public var sync_timestamp: UInt64? = nil
    public var conversation_state: [ConversationState] = []
    public var continuation_end_timestamp: UInt64? = nil
    public var invitation_state: InvitationState? = nil
    
    public init(response_header: ResponseHeader? = nil, sync_timestamp: UInt64? = nil, conversation_state: [ConversationState] = [], continuation_end_timestamp: UInt64? = nil, invitation_state: InvitationState? = nil) {
        self.response_header = response_header
        self.sync_timestamp = sync_timestamp
        self.conversation_state = conversation_state
        self.continuation_end_timestamp = continuation_end_timestamp
        self.invitation_state = invitation_state
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash(), self.sync_timestamp.hash(), self.conversation_state.hash(), self.continuation_end_timestamp.hash(), self.invitation_state.hash()])
    }
}

public struct UpdateWatermarkRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case request_header = 1
        case conversation_id = 2
        case last_read_timestamp = 3
    }
    
    public var request_header: RequestHeader? = nil
    public var conversation_id: ConversationId? = nil
    public var last_read_timestamp: UInt64? = nil
    
    public init(request_header: RequestHeader? = nil, conversation_id: ConversationId? = nil, last_read_timestamp: UInt64? = nil) {
        self.request_header = request_header
        self.conversation_id = conversation_id
        self.last_read_timestamp = last_read_timestamp
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.request_header.hash(), self.conversation_id.hash(), self.last_read_timestamp.hash()])
    }
}

public struct UpdateWatermarkResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case response_header = 1
    }
    
    public var response_header: ResponseHeader? = nil
    
    public init(response_header: ResponseHeader? = nil) {
        self.response_header = response_header
    }
    
    public var hashValue: Int {
        return combine(hashes: [self.response_header.hash()])
    }
}

let _protoEnums: [String: _ProtoEnum.Type] = [
    "ActiveClientState": ActiveClientState.self,
    "FocusType": FocusType.self,
    "FocusDevice": FocusDevice.self,
    "CallType": CallType.self,
    "TypingType": TypingType.self,
    "ClientPresenceStateType": ClientPresenceStateType.self,
    "NotificationLevel": NotificationLevel.self,
    "SegmentType": SegmentType.self,
    "ItemType": ItemType.self,
    "MediaType": MediaType.self,
    "MembershipChangeType": MembershipChangeType.self,
    "HangoutEventType": HangoutEventType.self,
    "HangoutMediaType": HangoutMediaType.self,
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
    "Device": Device.self,
    "Application": Application.self,
    "Platform": Platform.self,
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
    "GroupLinkSharingStatus": GroupLinkSharingStatus.self,
]

let _protoMessages: [String: _ProtoMessage.Type] = [
    "DoNotDisturbSetting": DoNotDisturbSetting.self,
    "NotificationSettings": NotificationSettings.self,
    "ConversationId": ConversationId.self,
    "ParticipantId": ParticipantId.self,
    "DeviceStatus": DeviceStatus.self,
    "LastSeen": LastSeen.self,
    "Location": Location.self,
    "InCall": InCall.self,
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
    "VoicePhoto": VoicePhoto.self,
    "EmbedItem": EmbedItem.self,
    "Attachment": Attachment.self,
    "MessageContent": MessageContent.self,
    "EventAnnotation": EventAnnotation.self,
    "ChatMessage": ChatMessage.self,
    "Participant": Participant.self,
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
    "InvitationState": InvitationState.self,
    "Photo": Photo.self,
    "ExistingMedia": ExistingMedia.self,
    "EventRequestHeader": EventRequestHeader.self,
    "ClientVersion": ClientVersion.self,
    "RtcClient": RtcClient.self,
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
    "GroupLinkSharingModification": GroupLinkSharingModification.self,
    "EasterEggNotification": EasterEggNotification.self,
    "SelfPresenceNotification": SelfPresenceNotification.self,
    "DeleteActionNotification": DeleteActionNotification.self,
    "PresenceNotification": PresenceNotification.self,
    "BlockNotification": BlockNotification.self,
    "InvitationWatermarkNotification": InvitationWatermarkNotification.self,
    "SetNotificationSettingNotification": SetNotificationSettingNotification.self,
    "RichPresenceEnabledStateNotification": RichPresenceEnabledStateNotification.self,
    "ConversationSpec": ConversationSpec.self,
    "OffnetworkAddress": OffnetworkAddress.self,
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
    "EntityResult": EntityResult.self,
    "GetGroupConversationUrlRequest": GetGroupConversationUrlRequest.self,
    "GetGroupConversationUrlResponse": GetGroupConversationUrlResponse.self,
    "GetSuggestedEntitiesRequest": GetSuggestedEntitiesRequest.self,
    "GetSuggestedEntitiesResponse": GetSuggestedEntitiesResponse.self,
    "GetSelfInfoRequest": GetSelfInfoRequest.self,
    "GetSelfInfoResponse": GetSelfInfoResponse.self,
    "ModifyConversationViewRequest": ModifyConversationViewRequest.self,
    "ModifyConversationViewResponse": ModifyConversationViewResponse.self,
    "OpenGroupConversationFromUrlRequest": OpenGroupConversationFromUrlRequest.self,
    "OpenGroupConversationFromUrlResponse": OpenGroupConversationFromUrlResponse.self,
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
    "ModifyOTRStatusRequest": ModifyOTRStatusRequest.self,
    "ModifyOTRStatusResponse": ModifyOTRStatusResponse.self,
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
    "SetGroupLinkSharingEnabledRequest": SetGroupLinkSharingEnabledRequest.self,
    "SetGroupLinkSharingEnabledResponse": SetGroupLinkSharingEnabledResponse.self,
    "SetPresenceRequest": SetPresenceRequest.self,
    "SetPresenceResponse": SetPresenceResponse.self,
    "SetTypingRequest": SetTypingRequest.self,
    "SetTypingResponse": SetTypingResponse.self,
    "UnreadConversationState": UnreadConversationState.self,
    "SyncAllNewEventsRequest": SyncAllNewEventsRequest.self,
    "SyncAllNewEventsResponse": SyncAllNewEventsResponse.self,
    "SyncRecentConversationsRequest": SyncRecentConversationsRequest.self,
    "SyncRecentConversationsResponse": SyncRecentConversationsResponse.self,
    "UpdateWatermarkRequest": UpdateWatermarkRequest.self,
    "UpdateWatermarkResponse": UpdateWatermarkResponse.self,
]
