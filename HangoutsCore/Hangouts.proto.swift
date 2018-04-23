public struct ClientNotificationLevel: ProtoEnum {
    public static let off: ClientNotificationLevel = 10
    public static let ding: ClientNotificationLevel = 20
    public static let importantOnly: ClientNotificationLevel = 25
    public static let allEvents: ClientNotificationLevel = 30
    public static let useGlobalDefault: ClientNotificationLevel = 100
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientCallerIdSetting_ClientIneligibilityCause: ProtoEnum {
    public static let unknownIneligibility: ClientCallerIdSetting_ClientIneligibilityCause = 0
    public static let disabledByPhoneStaleness: ClientCallerIdSetting_ClientIneligibilityCause = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientExperimentValue_LogAction: ProtoEnum {
    public static let unknownLogAction: ClientExperimentValue_LogAction = 0
    public static let dontLog: ClientExperimentValue_LogAction = 1
    public static let log: ClientExperimentValue_LogAction = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDeviceType: ProtoEnum {
    public static let android: ClientDeviceType = 1
    public static let ios: ClientDeviceType = 2
    public static let glass: ClientDeviceType = 3
    public static let pstn: ClientDeviceType = 4
    public static let chrome: ClientDeviceType = 5
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientConversation_ClientUserConversationState_InvitationAffinity: ProtoEnum {
    public static let unknownAffinity: ClientConversation_ClientUserConversationState_InvitationAffinity = 0
    public static let high: ClientConversation_ClientUserConversationState_InvitationAffinity = 1
    public static let low: ClientConversation_ClientUserConversationState_InvitationAffinity = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientEasterEggSuggestionInfo_ClientGemHorizontalAlignment: ProtoEnum {
    public static let unknown: ClientEasterEggSuggestionInfo_ClientGemHorizontalAlignment = 1
    public static let left: ClientEasterEggSuggestionInfo_ClientGemHorizontalAlignment = 2
    public static let center: ClientEasterEggSuggestionInfo_ClientGemHorizontalAlignment = 3
    public static let right: ClientEasterEggSuggestionInfo_ClientGemHorizontalAlignment = 4
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientCallerIdState: ProtoEnum {
    public static let uknownCallerIdState: ClientCallerIdState = 0
    public static let callerIdEnabled: ClientCallerIdState = 1
    public static let callerIdDisabled: ClientCallerIdState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientEntity_BabelUserState: ProtoEnum {
    public static let unknownUserState: ClientEntity_BabelUserState = 0
    public static let babel: ClientEntity_BabelUserState = 1
    public static let nonBabel: ClientEntity_BabelUserState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientSyncFilter: ProtoEnum {
    public static let unknownSyncFilter: ClientSyncFilter = 0
    public static let inboxSyncFilter: ClientSyncFilter = 1
    public static let archiveSyncFilter: ClientSyncFilter = 2
    public static let activeSyncFilter: ClientSyncFilter = 3
    public static let invitedSyncFilter: ClientSyncFilter = 4
    public static let invitedLowAffinitySyncFilter: ClientSyncFilter = 5
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientConversationView: ProtoEnum {
    public static let unknownConversationView: ClientConversationView = 0
    public static let inboxView: ClientConversationView = 1
    public static let archivedView: ClientConversationView = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientCallerIdSettingsMask: ProtoEnum {
    public static let unknownCallerIdSettingsMask: ClientCallerIdSettingsMask = 0
    public static let callerIdSettingsProvided: ClientCallerIdSettingsMask = 1
    public static let callerIdSettingsNotProvided: ClientCallerIdSettingsMask = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientRichPresenceType: ProtoEnum {
    public static let rpUnknown: ClientRichPresenceType = 0
    public static let rpInCallState: ClientRichPresenceType = 1
    public static let rpDevice: ClientRichPresenceType = 2
    public static let rpMood: ClientRichPresenceType = 3
    public static let rpActivity: ClientRichPresenceType = 4
    public static let rpGloballyEnabled: ClientRichPresenceType = 5
    public static let rpLastSeen: ClientRichPresenceType = 6
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientUrlRedirectResult_ClientRedirectError: ProtoEnum {
    public static let unknownRedirectError: ClientUrlRedirectResult_ClientRedirectError = 0
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientBlockState: ProtoEnum {
    public static let unknownBlockState: ClientBlockState = 0
    public static let block: ClientBlockState = 1
    public static let unblock: ClientBlockState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientSourceType: ProtoEnum {
    public static let unknownSourceType: ClientSourceType = 0
    public static let mobile: ClientSourceType = 1
    public static let web: ClientSourceType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientGroupLinkSharingStatus: ProtoEnum {
    public static let unknownLinkSharingStatus: ClientGroupLinkSharingStatus = 0
    public static let linkSharingOn: ClientGroupLinkSharingStatus = 1
    public static let linkSharingOff: ClientGroupLinkSharingStatus = 2
    public static let notAvailable: ClientGroupLinkSharingStatus = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ActiveClientState: ProtoEnum {
    public static let noActiveClient: ActiveClientState = 0
    public static let isActiveClient: ActiveClientState = 1
    public static let otherClientIsActive: ActiveClientState = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientAnalyticsEvent_EventType: ProtoEnum {
    public static let received: ClientAnalyticsEvent_EventType = 1
    public static let forwarded: ClientAnalyticsEvent_EventType = 2
    public static let deprecated3: ClientAnalyticsEvent_EventType = 3
    public static let delivered: ClientAnalyticsEvent_EventType = 4
    public static let dropped: ClientAnalyticsEvent_EventType = 5
    public static let discarded: ClientAnalyticsEvent_EventType = 6
    public static let invalidationDelivered: ClientAnalyticsEvent_EventType = 7
    public static let invalidationForwarded: ClientAnalyticsEvent_EventType = 8
    public static let invalidationDiscarded: ClientAnalyticsEvent_EventType = 9
    public static let checkpoint: ClientAnalyticsEvent_EventType = 10
    public static let created: ClientAnalyticsEvent_EventType = 11
    public static let responseReceived: ClientAnalyticsEvent_EventType = 12
    public static let responseRendered: ClientAnalyticsEvent_EventType = 13
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientConversationStatus: ProtoEnum {
    public static let unknownConversationStatus: ClientConversationStatus = 0
    public static let invited: ClientConversationStatus = 1
    public static let active: ClientConversationStatus = 2
    public static let left: ClientConversationStatus = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientRegistrationType: ProtoEnum {
    public static let register: ClientRegistrationType = 1
    public static let unregister: ClientRegistrationType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientSuggestion_ClientSuggestionType: ProtoEnum {
    public static let unknownType: ClientSuggestion_ClientSuggestionType = 0
    public static let whereYouAt: ClientSuggestion_ClientSuggestionType = 3
    public static let location: ClientSuggestion_ClientSuggestionType = 4
    public static let happyThanksgiving: ClientSuggestion_ClientSuggestionType = 5
    public static let happyHanukkah: ClientSuggestion_ClientSuggestionType = 6
    public static let happyBirthday: ClientSuggestion_ClientSuggestionType = 7
    public static let happyHolidays: ClientSuggestion_ClientSuggestionType = 8
    public static let merryChristmas: ClientSuggestion_ClientSuggestionType = 9
    public static let happyNewYear: ClientSuggestion_ClientSuggestionType = 10
    public static let loveYou: ClientSuggestion_ClientSuggestionType = 11
    public static let lgtm: ClientSuggestion_ClientSuggestionType = 12
    public static let sgtm: ClientSuggestion_ClientSuggestionType = 13
    public static let laughterExpression: ClientSuggestion_ClientSuggestionType = 14
    public static let excitementExpression: ClientSuggestion_ClientSuggestionType = 15
    public static let disappointmentExpression: ClientSuggestion_ClientSuggestionType = 16
    public static let gem: ClientSuggestion_ClientSuggestionType = 17
    public static let dateTime: ClientSuggestion_ClientSuggestionType = 18
    public static let whereAmI: ClientSuggestion_ClientSuggestionType = 19
    public static let smartReply: ClientSuggestion_ClientSuggestionType = 20
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDomainProperties_ClientDomainDefaultOtrSetting: ProtoEnum {
    public static let unknownDomainOtrSetting: ClientDomainProperties_ClientDomainDefaultOtrSetting = 0
    public static let defaultHistoryOff: ClientDomainProperties_ClientDomainDefaultOtrSetting = 1
    public static let defaultHistoryOn: ClientDomainProperties_ClientDomainDefaultOtrSetting = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientGetConversationResponse_ClientGetConversationError: ProtoEnum {
    public static let invalidContinuationToken: ClientGetConversationResponse_ClientGetConversationError = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientQueryPresenceRequest_ClientFieldMask: ProtoEnum {
    public static let reachability: ClientQueryPresenceRequest_ClientFieldMask = 1
    public static let availability: ClientQueryPresenceRequest_ClientFieldMask = 2
    public static let statusMessage: ClientQueryPresenceRequest_ClientFieldMask = 3
    public static let location: ClientQueryPresenceRequest_ClientFieldMask = 4
    public static let mood: ClientQueryPresenceRequest_ClientFieldMask = 5
    public static let inCall: ClientQueryPresenceRequest_ClientFieldMask = 6
    public static let deviceStatus: ClientQueryPresenceRequest_ClientFieldMask = 7
    public static let activity: ClientQueryPresenceRequest_ClientFieldMask = 8
    public static let calendarPresence: ClientQueryPresenceRequest_ClientFieldMask = 9
    public static let lastSeen: ClientQueryPresenceRequest_ClientFieldMask = 10
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientAdditionalEntityData: ProtoEnum {
    public static let unknownAdditionalData: ClientAdditionalEntityData = 0
    public static let isBabelUser: ClientAdditionalEntityData = 1
    public static let hasHadPastHangout: ClientAdditionalEntityData = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientAnalyticsEvent_ChatAction: ProtoEnum {
    public static let unknownAction: ClientAnalyticsEvent_ChatAction = 0
    public static let createConversation: ClientAnalyticsEvent_ChatAction = 100
    public static let sendChatMessage: ClientAnalyticsEvent_ChatAction = 101
    public static let hangoutComingSoon: ClientAnalyticsEvent_ChatAction = 701
    public static let hangoutStarted: ClientAnalyticsEvent_ChatAction = 702
    public static let hangoutJoin: ClientAnalyticsEvent_ChatAction = 703
    public static let hangoutLeave: ClientAnalyticsEvent_ChatAction = 704
    public static let hangoutEnded: ClientAnalyticsEvent_ChatAction = 705
    public static let hangoutOngoing: ClientAnalyticsEvent_ChatAction = 706
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientPresenceStateSetting_ClientPresenceState: ProtoEnum {
    public static let none: ClientPresenceStateSetting_ClientPresenceState = 1
    public static let mobile: ClientPresenceStateSetting_ClientPresenceState = 10
    public static let mobileActive: ClientPresenceStateSetting_ClientPresenceState = 20
    public static let desktopIdle: ClientPresenceStateSetting_ClientPresenceState = 30
    public static let desktopActive: ClientPresenceStateSetting_ClientPresenceState = 40
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LNodeDefs_NodeType: ProtoEnum {
    public static let cs: LNodeDefs_NodeType = 1
    public static let wcs: LNodeDefs_NodeType = 2
    public static let mcs: LNodeDefs_NodeType = 3
    public static let gmail: LNodeDefs_NodeType = 4
    public static let fs: LNodeDefs_NodeType = 5
    public static let ro: LNodeDefs_NodeType = 6
    public static let ss: LNodeDefs_NodeType = 7
    public static let gcm: LNodeDefs_NodeType = 8
    public static let apns: LNodeDefs_NodeType = 9
    public static let conserver: LNodeDefs_NodeType = 10
    public static let apiary: LNodeDefs_NodeType = 11
    public static let papyrus: LNodeDefs_NodeType = 12
    public static let wcsClient: LNodeDefs_NodeType = 13
    public static let xmppInterop: LNodeDefs_NodeType = 14
    public static let gti: LNodeDefs_NodeType = 15
    public static let glass: LNodeDefs_NodeType = 16
    public static let bot: LNodeDefs_NodeType = 17
    public static let androidClient: LNodeDefs_NodeType = 18
    public static let iosClient: LNodeDefs_NodeType = 19
    public static let rooms: LNodeDefs_NodeType = 20
    public static let fanserver: LNodeDefs_NodeType = 21
    public static let mesi: LNodeDefs_NodeType = 22
    public static let broadcastbell: LNodeDefs_NodeType = 23
    public static let megastore: LNodeDefs_NodeType = 24
    public static let focus: LNodeDefs_NodeType = 25
    public static let lcs: LNodeDefs_NodeType = 26
    public static let lcsClient: LNodeDefs_NodeType = 27
    public static let tinkerbell: LNodeDefs_NodeType = 28
    public static let guss: LNodeDefs_NodeType = 29
    public static let lens: LNodeDefs_NodeType = 30
    public static let viewfinder: LNodeDefs_NodeType = 31
    public static let reflector: LNodeDefs_NodeType = 32
    public static let diffractor: LNodeDefs_NodeType = 33
    public static let platform: LNodeDefs_NodeType = 34
    public static let calendar: LNodeDefs_NodeType = 35
    public static let party: LNodeDefs_NodeType = 36
    public static let hangoutsPusher: LNodeDefs_NodeType = 37
    public static let abuseiam: LNodeDefs_NodeType = 38
    public static let mesiSpanner: LNodeDefs_NodeType = 39
    public static let chatExpunger: LNodeDefs_NodeType = 40
    public static let drivePublisher: LNodeDefs_NodeType = 41
    public static let ccs: LNodeDefs_NodeType = 42
    public static let speakeasy: LNodeDefs_NodeType = 43
    public static let transcriptionbell: LNodeDefs_NodeType = 44
    public static let guns: LNodeDefs_NodeType = 45
    public static let botguard: LNodeDefs_NodeType = 46
    public static let prefstore: LNodeDefs_NodeType = 47
    public static let pushkit: LNodeDefs_NodeType = 48
    public static let hangoutsUserPusher: LNodeDefs_NodeType = 49
    public static let meetings: LNodeDefs_NodeType = 50
    public static let jidLookup: LNodeDefs_NodeType = 51
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientStartPhoneNumberVerificationRequest_ClientPhoneNumberVerificationMethod: ProtoEnum {
    public static let unknownVerificationMethod: ClientStartPhoneNumberVerificationRequest_ClientPhoneNumberVerificationMethod = 0
    public static let smsToApp: ClientStartPhoneNumberVerificationRequest_ClientPhoneNumberVerificationMethod = 1
    public static let smsToHuman: ClientStartPhoneNumberVerificationRequest_ClientPhoneNumberVerificationMethod = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LChatDefs_ActiveClientState: ProtoEnum {
    public static let unknown: LChatDefs_ActiveClientState = 0
    public static let noActiveClient: LChatDefs_ActiveClientState = 1
    public static let isActiveClient: LChatDefs_ActiveClientState = 2
    public static let otherClientIsActive: LChatDefs_ActiveClientState = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientConfigurationBitType: ProtoEnum {
    public static let quasarMarketingPromoDismissed: ClientConfigurationBitType = 1
    public static let gplusSignupPromoDismissed: ClientConfigurationBitType = 2
    public static let chatWithCirclesAccepted: ClientConfigurationBitType = 3
    public static let chatWithCirclesPromoDismissed: ClientConfigurationBitType = 4
    public static let allowedForDomain: ClientConfigurationBitType = 5
    public static let gmailChatArchiveEnabled: ClientConfigurationBitType = 6
    public static let gplusUpgradeAllowedForDomain: ClientConfigurationBitType = 7
    public static let richPresenceActivityPromoShown: ClientConfigurationBitType = 8
    public static let richPresenceDevicePromoShown: ClientConfigurationBitType = 9
    public static let richPresenceInCallStatePromoShown: ClientConfigurationBitType = 10
    public static let richPresenceMoodPromoShown: ClientConfigurationBitType = 11
    public static let canOptIntoGvSmsIntegration: ClientConfigurationBitType = 12
    public static let gvSmsIntegrationEnabled: ClientConfigurationBitType = 13
    public static let gvSmsIntegrationPromoShown: ClientConfigurationBitType = 14
    public static let businessFeaturesEligible: ClientConfigurationBitType = 15
    public static let businessFeaturesPromoDismissed: ClientConfigurationBitType = 16
    public static let businessFeaturesEnabled: ClientConfigurationBitType = 17
    public static let richPresenceLastSeenMobilePromoShown: ClientConfigurationBitType = 19
    public static let richPresenceLastSeenDesktopPromptShown: ClientConfigurationBitType = 20
    public static let richPresenceLastSeenMobilePromptShown: ClientConfigurationBitType = 21
    public static let richPresenceLastSeenDesktopPromoShown: ClientConfigurationBitType = 22
    public static let conversationInviteSettingsSetToCustom: ClientConfigurationBitType = 23
    public static let reportAbuseNoticeAcknowledged: ClientConfigurationBitType = 24
    public static let unicornUseChildProduct: ClientConfigurationBitType = 25
    public static let unicornFullyDisabledByParent: ClientConfigurationBitType = 26
    public static let phoneVerificationMobilePromptShown: ClientConfigurationBitType = 27
    public static let canUseGvCallerIdFeature: ClientConfigurationBitType = 28
    public static let photoServiceRegistered: ClientConfigurationBitType = 29
    public static let gvCallerIdWabelFirstTimeDialogShown: ClientConfigurationBitType = 30
    public static let hangoutP2PNoticeNeedsAcknowledgement: ClientConfigurationBitType = 31
    public static let hangoutP2PEnabled: ClientConfigurationBitType = 32
    public static let inviteNotificationsEnabled: ClientConfigurationBitType = 33
    public static let desktopAutoEmojiConversionEnabled: ClientConfigurationBitType = 34
    public static let warmWelcomeSeen: ClientConfigurationBitType = 35
    public static let inviteHappyStatePromoSeen: ClientConfigurationBitType = 36
    public static let desktopHostDensitySettingsEnabled: ClientConfigurationBitType = 37
    public static let desktopCompactModeEnabled: ClientConfigurationBitType = 38
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientUserType: ProtoEnum {
    public static let unknownUserType: ClientUserType = 0
    public static let invalid: ClientUserType = 1
    public static let gaia: ClientUserType = 2
    public static let offNetworkPhone: ClientUserType = 3
    public static let malformedPhoneNumber: ClientUserType = 4
    public static let unknownPhoneNumber: ClientUserType = 5
    public static let anonymousPhoneNumber: ClientUserType = 6
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientInCall_ClientCallType: ProtoEnum {
    public static let none: ClientInCall_ClientCallType = 0
    public static let pstn: ClientInCall_ClientCallType = 100
    public static let hangout: ClientInCall_ClientCallType = 200
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientEntityProperties_ClientAffinity_ClientAffinityType: ProtoEnum {
    public static let affinityTypeUnknown: ClientEntityProperties_ClientAffinity_ClientAffinityType = 0
    public static let emailAutocomplete: ClientEntityProperties_ClientAffinity_ClientAffinityType = 1
    public static let contactsPlusFrequentlyContacted: ClientEntityProperties_ClientAffinity_ClientAffinityType = 2
    public static let chatAutocomplete: ClientEntityProperties_ClientAffinity_ClientAffinityType = 3
    public static let gplusAutocomplete: ClientEntityProperties_ClientAffinity_ClientAffinityType = 4
    public static let glassAffinity: ClientEntityProperties_ClientAffinity_ClientAffinityType = 5
    public static let gplusStreamYouMayKnow: ClientEntityProperties_ClientAffinity_ClientAffinityType = 6
    public static let peopleAutocompleteSocial: ClientEntityProperties_ClientAffinity_ClientAffinityType = 7
    public static let fieldAutocompleteSocial: ClientEntityProperties_ClientAffinity_ClientAffinityType = 8
    public static let contactsPlusEmail: ClientEntityProperties_ClientAffinity_ClientAffinityType = 9
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientResponseStatus: ProtoEnum {
    public static let unknown: ClientResponseStatus = 0
    public static let ok: ClientResponseStatus = 1
    public static let errorBusy: ClientResponseStatus = 2
    public static let errorUnexpected: ClientResponseStatus = 3
    public static let errorInvalidRequest: ClientResponseStatus = 4
    public static let errorRetryLimit: ClientResponseStatus = 5
    public static let errorForwarded: ClientResponseStatus = 6
    public static let errorQuotaExceeded: ClientResponseStatus = 7
    public static let errorInvalidConversation: ClientResponseStatus = 8
    public static let errorVersionMismatch: ClientResponseStatus = 9
    public static let errorAccessCheckFailed: ClientResponseStatus = 10
    public static let errorNotFound: ClientResponseStatus = 11
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientInvitationStatus: ProtoEnum {
    public static let unknownInvitationStatus: ClientInvitationStatus = 0
    public static let pendingInvitation: ClientInvitationStatus = 1
    public static let acceptedInvitation: ClientInvitationStatus = 2
    public static let invitationNeeded: ClientInvitationStatus = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientInviteSettings_NotificationLevel: ProtoEnum {
    public static let unknownNotificationLevel: ClientInviteSettings_NotificationLevel = 0
    public static let disable: ClientInviteSettings_NotificationLevel = 1
    public static let invite: ClientInviteSettings_NotificationLevel = 2
    public static let ring: ClientInviteSettings_NotificationLevel = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LChatDefs_NotificationLevel: ProtoEnum {
    public static let off: LChatDefs_NotificationLevel = 10
    public static let ding: LChatDefs_NotificationLevel = 20
    public static let importantOnly: LChatDefs_NotificationLevel = 25
    public static let allEvents: LChatDefs_NotificationLevel = 30
    public static let useGlobalDefault: LChatDefs_NotificationLevel = 100
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientClientVersion_ClientId: ProtoEnum {
    public static let unknownClientId: ClientClientVersion_ClientId = 0
    public static let android: ClientClientVersion_ClientId = 1
    public static let ios: ClientClientVersion_ClientId = 2
    public static let quasar: ClientClientVersion_ClientId = 3
    public static let webSupermoles: ClientClientVersion_ClientId = 4
    public static let webSupermolesOz: ClientClientVersion_ClientId = 5
    public static let webSupermolesGmail: ClientClientVersion_ClientId = 6
    public static let bot: ClientClientVersion_ClientId = 7
    public static let webVideoCall: ClientClientVersion_ClientId = 8
    public static let glassServer: ClientClientVersion_ClientId = 9
    public static let pstnBot: ClientClientVersion_ClientId = 10
    public static let tee: ClientClientVersion_ClientId = 11
    public static let webSupermolesBigtop: ClientClientVersion_ClientId = 12
    public static let webSupermolesChromeApp: ClientClientVersion_ClientId = 13
    public static let roomServer: ClientClientVersion_ClientId = 14
    public static let webStandaloneApp: ClientClientVersion_ClientId = 15
    public static let speakeasy: ClientClientVersion_ClientId = 16
    public static let googleVoice: ClientClientVersion_ClientId = 17
    public static let prober: ClientClientVersion_ClientId = 18
    public static let external: ClientClientVersion_ClientId = 19
    public static let bbBot: ClientClientVersion_ClientId = 23
    public static let powwow: ClientClientVersion_ClientId = 24
    public static let ozServer: ClientClientVersion_ClientId = 25
    public static let hangoutsPusher: ClientClientVersion_ClientId = 26
    public static let androidNova: ClientClientVersion_ClientId = 27
    public static let realtimeSupport: ClientClientVersion_ClientId = 28
    public static let chatExpunger: ClientClientVersion_ClientId = 29
    public static let captionsBot: ClientClientVersion_ClientId = 30
    public static let mesi: ClientClientVersion_ClientId = 31
    public static let realtimeMediaJs: ClientClientVersion_ClientId = 32
    public static let wabelMediacall: ClientClientVersion_ClientId = 33
    public static let expresslane: ClientClientVersion_ClientId = 34
    public static let testClient: ClientClientVersion_ClientId = 35
    public static let webSupermolesContacts: ClientClientVersion_ClientId = 36
    public static let webSupermolesCallmemaybe: ClientClientVersion_ClientId = 37
    public static let gmail: ClientClientVersion_ClientId = 38
    public static let castouts: ClientClientVersion_ClientId = 39
    public static let ironmanWeb: ClientClientVersion_ClientId = 40
    public static let ironmanAndroid: ClientClientVersion_ClientId = 41
    public static let ironmanIos: ClientClientVersion_ClientId = 42
    public static let anonymousWebVideoCall: ClientClientVersion_ClientId = 43
    public static let hangoutsStartPage: ClientClientVersion_ClientId = 44
    public static let webSupermolesShortlink: ClientClientVersion_ClientId = 45
    public static let hotlane: ClientClientVersion_ClientId = 46
    public static let iosShare: ClientClientVersion_ClientId = 47
    public static let rigel: ClientClientVersion_ClientId = 48
    public static let porthole: ClientClientVersion_ClientId = 49
    public static let boqExpresslane: ClientClientVersion_ClientId = 50
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientInviteeError_ClientInviteeErrorDetail: ProtoEnum {
    public static let unknownInviteeError: ClientInviteeError_ClientInviteeErrorDetail = 0
    public static let inviteeBlocked: ClientInviteeError_ClientInviteeErrorDetail = 1
    public static let notAuthorized: ClientInviteeError_ClientInviteeErrorDetail = 2
    public static let forceHistoryConflict: ClientInviteeError_ClientInviteeErrorDetail = 3
    public static let forceHistoryStateChangeUseFork: ClientInviteeError_ClientInviteeErrorDetail = 4
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LTransportEvent_EventType: ProtoEnum {
    public static let received: LTransportEvent_EventType = 1
    public static let forwarded: LTransportEvent_EventType = 2
    public static let branched: LTransportEvent_EventType = 3
    public static let delivered: LTransportEvent_EventType = 4
    public static let dropped: LTransportEvent_EventType = 5
    public static let discarded: LTransportEvent_EventType = 6
    public static let invalidationDelivered: LTransportEvent_EventType = 7
    public static let invalidationForwarded: LTransportEvent_EventType = 8
    public static let invalidationDiscarded: LTransportEvent_EventType = 9
    public static let checkpoint: LTransportEvent_EventType = 10
    public static let created: LTransportEvent_EventType = 11
    public static let responseReceived: LTransportEvent_EventType = 12
    public static let responseRendered: LTransportEvent_EventType = 13
    public static let queueStatus: LTransportEvent_EventType = 14
    public static let rpcSent: LTransportEvent_EventType = 15
    public static let databaseSizeKb: LTransportEvent_EventType = 16
    public static let latency: LTransportEvent_EventType = 17
    public static let database: LTransportEvent_EventType = 18
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientHangoutEventType: ProtoEnum {
    public static let startHangout: ClientHangoutEventType = 1
    public static let endHangout: ClientHangoutEventType = 2
    public static let joinHangout: ClientHangoutEventType = 3
    public static let leaveHangout: ClientHangoutEventType = 4
    public static let hangoutComingSoon: ClientHangoutEventType = 5
    public static let ongoingHangout: ClientHangoutEventType = 6
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LTransportEvent_EventDeliveryMechanism: ProtoEnum {
    public static let unknown: LTransportEvent_EventDeliveryMechanism = 0
    public static let chatMessageFanOut: LTransportEvent_EventDeliveryMechanism = 1
    public static let chatMessageWarmSync: LTransportEvent_EventDeliveryMechanism = 2
    public static let chatMessageColdSync: LTransportEvent_EventDeliveryMechanism = 3
    public static let chatMessageUserScrollBack: LTransportEvent_EventDeliveryMechanism = 4
    public static let chatMessageConversationRequest: LTransportEvent_EventDeliveryMechanism = 5
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LTransportEvent_MessageType: ProtoEnum {
    public static let chat: LTransportEvent_MessageType = 1
    public static let video: LTransportEvent_MessageType = 2
    public static let control: LTransportEvent_MessageType = 3
    public static let hangoutStarted: LTransportEvent_MessageType = 701
    public static let hangoutJoin: LTransportEvent_MessageType = 702
    public static let hangoutLeave: LTransportEvent_MessageType = 703
    public static let hangoutEnded: LTransportEvent_MessageType = 704
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDeliveryMediumType: ProtoEnum {
    public static let unknownMedium: ClientDeliveryMediumType = 0
    public static let babelMedium: ClientDeliveryMediumType = 1
    public static let googleVoiceMedium: ClientDeliveryMediumType = 2
    public static let localSmsMedium: ClientDeliveryMediumType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientFocusType: ProtoEnum {
    public static let focus: ClientFocusType = 1
    public static let unfocus: ClientFocusType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientMembershipChangeType: ProtoEnum {
    public static let join: ClientMembershipChangeType = 1
    public static let leave: ClientMembershipChangeType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientUpdateFavoritesError: ProtoEnum {
    public static let unknownModifyFavoritesError: ClientUpdateFavoritesError = 0
    public static let staleVersion: ClientUpdateFavoritesError = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LXsDefs_ClientType: ProtoEnum {
    public static let unknownClientId: LXsDefs_ClientType = 0
    public static let android: LXsDefs_ClientType = 1
    public static let ios: LXsDefs_ClientType = 2
    public static let quasar: LXsDefs_ClientType = 3
    public static let webSupermoles: LXsDefs_ClientType = 4
    public static let webSupermolesOz: LXsDefs_ClientType = 5
    public static let webSupermolesGmail: LXsDefs_ClientType = 6
    public static let roomServer: LXsDefs_ClientType = 7
    public static let sessionServer: LXsDefs_ClientType = 8
    public static let bot: LXsDefs_ClientType = 9
    public static let ozServer: LXsDefs_ClientType = 10
    public static let gtiSms: LXsDefs_ClientType = 11
    public static let webVideoCall: LXsDefs_ClientType = 12
    public static let glassServer: LXsDefs_ClientType = 13
    public static let pstnBot: LXsDefs_ClientType = 14
    public static let tee: LXsDefs_ClientType = 15
    public static let webSupermolesBigtop: LXsDefs_ClientType = 16
    public static let webSupermolesChromeApp: LXsDefs_ClientType = 17
    public static let webStandaloneApp: LXsDefs_ClientType = 18
    public static let speakeasy: LXsDefs_ClientType = 19
    public static let googleVoice: LXsDefs_ClientType = 20
    public static let prober: LXsDefs_ClientType = 21
    public static let external: LXsDefs_ClientType = 22
    public static let bbBot: LXsDefs_ClientType = 23
    public static let powwow: LXsDefs_ClientType = 24
    public static let hangoutsPusher: LXsDefs_ClientType = 26
    public static let androidNova: LXsDefs_ClientType = 27
    public static let realtimeSupport: LXsDefs_ClientType = 28
    public static let chatExpunger: LXsDefs_ClientType = 29
    public static let captionsBot: LXsDefs_ClientType = 30
    public static let mesi: LXsDefs_ClientType = 31
    public static let realtimeMediaJs: LXsDefs_ClientType = 32
    public static let wabelMediacall: LXsDefs_ClientType = 33
    public static let expresslane: LXsDefs_ClientType = 34
    public static let testClient: LXsDefs_ClientType = 35
    public static let webSupermolesContacts: LXsDefs_ClientType = 36
    public static let webSupermolesCallmemaybe: LXsDefs_ClientType = 37
    public static let gmail: LXsDefs_ClientType = 38
    public static let castouts: LXsDefs_ClientType = 39
    public static let ironmanWeb: LXsDefs_ClientType = 40
    public static let ironmanAndroid: LXsDefs_ClientType = 41
    public static let ironmanIos: LXsDefs_ClientType = 42
    public static let anonymousWebVideoCall: LXsDefs_ClientType = 43
    public static let hangoutsStartPage: LXsDefs_ClientType = 44
    public static let webSupermolesShortlink: LXsDefs_ClientType = 45
    public static let hotlane: LXsDefs_ClientType = 46
    public static let iosShare: LXsDefs_ClientType = 47
    public static let rigel: LXsDefs_ClientType = 48
    public static let porthole: LXsDefs_ClientType = 49
    public static let boqExpresslane: LXsDefs_ClientType = 50
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientInvitationAffinity: ProtoEnum {
    public static let unknownAffinity: ClientInvitationAffinity = 0
    public static let high: ClientInvitationAffinity = 1
    public static let low: ClientInvitationAffinity = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientOffnetworkAddress_Type: ProtoEnum {
    public static let phone: ClientOffnetworkAddress_Type = 0
    public static let email: ClientOffnetworkAddress_Type = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientSetActiveClientResponse_ClientSetActiveClientError: ProtoEnum {
    public static let invalidClient: ClientSetActiveClientResponse_ClientSetActiveClientError = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientReplyToInviteType: ProtoEnum {
    public static let unknownReplyToInviteType: ClientReplyToInviteType = 0
    public static let accept: ClientReplyToInviteType = 1
    public static let decline: ClientReplyToInviteType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct RealtimeNotificationSettings_Level: ProtoEnum {
    public static let `default`: RealtimeNotificationSettings_Level = 0
    public static let disable: RealtimeNotificationSettings_Level = 10
    public static let invite: RealtimeNotificationSettings_Level = 20
    public static let deliver: RealtimeNotificationSettings_Level = 30
    public static let ping: RealtimeNotificationSettings_Level = 40
    public static let ring: RealtimeNotificationSettings_Level = 50
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientClientVersion_ClientBuildType: ProtoEnum {
    public static let unknownClientBuildType: ClientClientVersion_ClientBuildType = 0
    public static let developer: ClientClientVersion_ClientBuildType = 1
    public static let dogfood: ClientClientVersion_ClientBuildType = 2
    public static let production: ClientClientVersion_ClientBuildType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientLeaveReason: ProtoEnum {
    public static let leaveReasonUnknown: ClientLeaveReason = 0
    public static let forceHistoryPolicyChange: ClientLeaveReason = 1
    public static let userInitiated: ClientLeaveReason = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientOffTheRecordToggle: ProtoEnum {
    public static let enabled: ClientOffTheRecordToggle = 1
    public static let disabled: ClientOffTheRecordToggle = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientOffTheRecordStatus: ProtoEnum {
    public static let offTheRecord: ClientOffTheRecordStatus = 1
    public static let onTheRecord: ClientOffTheRecordStatus = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientUpgradeType: ProtoEnum {
    public static let suggest: ClientUpgradeType = 1
    public static let force: ClientUpgradeType = 2
    public static let deprecatedClient: ClientUpgradeType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDeleteType: ProtoEnum {
    public static let unknownDelete: ClientDeleteType = 0
    public static let upperBoundDelete: ClientDeleteType = 1
    public static let perEventDelete: ClientDeleteType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientVerificationStatus: ProtoEnum {
    public static let unknownVerificationStatus: ClientVerificationStatus = 0
    public static let verified: ClientVerificationStatus = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientEventType: ProtoEnum {
    public static let unknownEventType: ClientEventType = 0
    public static let regularChatMessage: ClientEventType = 1
    public static let sms: ClientEventType = 2
    public static let voicemail: ClientEventType = 3
    public static let addUser: ClientEventType = 4
    public static let removeUser: ClientEventType = 5
    public static let renameConversation: ClientEventType = 6
    public static let hangoutEvent: ClientEventType = 7
    public static let phoneCall: ClientEventType = 8
    public static let otrModification: ClientEventType = 9
    public static let deprecated10: ClientEventType = 10
    public static let mms: ClientEventType = 11
    public static let deprecated12: ClientEventType = 12
    public static let observedEvent: ClientEventType = 13
    public static let groupLinkSharingModification: ClientEventType = 14
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientConversationType: ProtoEnum {
    public static let unknownConversationType: ClientConversationType = 0
    public static let stickyOneToOne: ClientConversationType = 1
    public static let group: ClientConversationType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDomainProperties_ClientChatRestricted: ProtoEnum {
    public static let unknownChatRestricted: ClientDomainProperties_ClientChatRestricted = 0
    public static let chatNotRestricted: ClientDomainProperties_ClientChatRestricted = 1
    public static let chatRestrictedToDomain: ClientDomainProperties_ClientChatRestricted = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LXsDefs_ChatAction: ProtoEnum {
    public static let unknownAction: LXsDefs_ChatAction = 0
    public static let createConversation: LXsDefs_ChatAction = 100
    public static let sendChatMessage: LXsDefs_ChatAction = 101
    public static let addUser: LXsDefs_ChatAction = 102
    public static let removeUser: LXsDefs_ChatAction = 103
    public static let rename: LXsDefs_ChatAction = 104
    public static let syncRecent: LXsDefs_ChatAction = 105
    public static let syncAllNewEvents: LXsDefs_ChatAction = 106
    public static let getConversation: LXsDefs_ChatAction = 107
    public static let setConversationNotificationLevel: LXsDefs_ChatAction = 108
    public static let replyToInvite: LXsDefs_ChatAction = 109
    public static let modifyOtr: LXsDefs_ChatAction = 110
    public static let modifyConversationView: LXsDefs_ChatAction = 111
    public static let setHangoutNotificationStatus: LXsDefs_ChatAction = 112
    public static let setFocus: LXsDefs_ChatAction = 113
    public static let setTyping: LXsDefs_ChatAction = 114
    public static let updateWatermark: LXsDefs_ChatAction = 115
    public static let deleteConversation: LXsDefs_ChatAction = 116
    public static let getUnreadCount: LXsDefs_ChatAction = 117
    public static let recordAnalyticEvents: LXsDefs_ChatAction = 118
    public static let getUserBadgeCount: LXsDefs_ChatAction = 119
    public static let markEventObserved: LXsDefs_ChatAction = 120
    public static let openConversationFromURL: LXsDefs_ChatAction = 121
    public static let modifyGroupLinkSharingStatus: LXsDefs_ChatAction = 122
    public static let queryAvailability: LXsDefs_ChatAction = 300
    public static let getSuggestedEntities: LXsDefs_ChatAction = 301
    public static let getSelfInfo: LXsDefs_ChatAction = 302
    public static let searchEntities: LXsDefs_ChatAction = 303
    public static let getEntityById: LXsDefs_ChatAction = 304
    public static let setConfigurationBit: LXsDefs_ChatAction = 305
    public static let registerDevice: LXsDefs_ChatAction = 501
    public static let setActiveClient: LXsDefs_ChatAction = 502
    public static let setAvailability: LXsDefs_ChatAction = 503
    public static let setSettings: LXsDefs_ChatAction = 504
    public static let getSettings: LXsDefs_ChatAction = 505
    public static let startSmsToAppVerification: LXsDefs_ChatAction = 506
    public static let finishSmsToAppVerification: LXsDefs_ChatAction = 507
    public static let hangoutComingSoon: LXsDefs_ChatAction = 701
    public static let hangoutStarted: LXsDefs_ChatAction = 702
    public static let hangoutJoin: LXsDefs_ChatAction = 703
    public static let hangoutLeave: LXsDefs_ChatAction = 704
    public static let hangoutEnded: LXsDefs_ChatAction = 705
    public static let hangoutOngoing: LXsDefs_ChatAction = 706
    public static let queryPresence: LXsDefs_ChatAction = 801
    public static let setPresence: LXsDefs_ChatAction = 802
    public static let setRichPresenceEnabledState: LXsDefs_ChatAction = 803
    public static let sendOffnetworkInvitation: LXsDefs_ChatAction = 901
    public static let acceptOffnetworkInvitation: LXsDefs_ChatAction = 902
    public static let stopOffnetworkInvitation: LXsDefs_ChatAction = 903
    public static let setSmsEnablingState: LXsDefs_ChatAction = 904
    public static let getSmsEnablingState: LXsDefs_ChatAction = 905
    public static let hangoutResolve: LXsDefs_ChatAction = 1001
    public static let hangoutQuery: LXsDefs_ChatAction = 1002
    public static let hangoutParticipantSearch: LXsDefs_ChatAction = 1003
    public static let mediaSessionLog: LXsDefs_ChatAction = 1004
    public static let manifoldExecuteBabelArchiving: LXsDefs_ChatAction = 1100
    public static let manifoldExecuteBabelCentBlacklist: LXsDefs_ChatAction = 1101
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDeclineSignal: ProtoEnum {
    public static let reportAbuse: ClientDeclineSignal = 1
    public static let blockInviter: ClientDeclineSignal = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientConversation_ClientNetworkType: ProtoEnum {
    public static let unknownNetworkType: ClientConversation_ClientNetworkType = 0
    public static let babel: ClientConversation_ClientNetworkType = 1
    public static let phone: ClientConversation_ClientNetworkType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientGetSelfInfoResponse_AccountAgeGroup: ProtoEnum {
    public static let unknownAgeGroup: ClientGetSelfInfoResponse_AccountAgeGroup = 0
    public static let adult: ClientGetSelfInfoResponse_AccountAgeGroup = 1
    public static let minor: ClientGetSelfInfoResponse_AccountAgeGroup = 2
    public static let child: ClientGetSelfInfoResponse_AccountAgeGroup = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientEventObservedStatus: ProtoEnum {
    public static let unknownObservedStatus: ClientEventObservedStatus = 0
    public static let observed: ClientEventObservedStatus = 1
    public static let unobserved: ClientEventObservedStatus = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientExperimentValue_FlagType: ProtoEnum {
    public static let boolean: ClientExperimentValue_FlagType = 1
    public static let long: ClientExperimentValue_FlagType = 2
    public static let double: ClientExperimentValue_FlagType = 3
    public static let string: ClientExperimentValue_FlagType = 4
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDeviceActivity_Type: ProtoEnum {
    public static let inVehicle: ClientDeviceActivity_Type = 0
    public static let onBicycle: ClientDeviceActivity_Type = 1
    public static let onFoot: ClientDeviceActivity_Type = 2
    public static let still: ClientDeviceActivity_Type = 3
    public static let unknown: ClientDeviceActivity_Type = 4
    public static let tilting: ClientDeviceActivity_Type = 5
    public static let exitingVehicle: ClientDeviceActivity_Type = 6
    public static let walking: ClientDeviceActivity_Type = 7
    public static let running: ClientDeviceActivity_Type = 8
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LUmaEventData_HistogramType: ProtoEnum {
    public static let histogram: LUmaEventData_HistogramType = 0
    public static let linear: LUmaEventData_HistogramType = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct LClientState_EventState_ClientEventObservedStatus: ProtoEnum {
    public static let unknownObservedStatus: LClientState_EventState_ClientEventObservedStatus = 0
    public static let observed: LClientState_EventState_ClientEventObservedStatus = 1
    public static let unobserved: LClientState_EventState_ClientEventObservedStatus = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientEntityProperties_ProfileType: ProtoEnum {
    public static let none: ClientEntityProperties_ProfileType = 0
    public static let esUser: ClientEntityProperties_ProfileType = 1
    public static let page: ClientEntityProperties_ProfileType = 2
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientTypingType: ProtoEnum {
    public static let start: ClientTypingType = 1
    public static let pause: ClientTypingType = 2
    public static let clear: ClientTypingType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientForceHistoryState: ProtoEnum {
    public static let forceHistoryUnknown: ClientForceHistoryState = 0
    public static let noForce: ClientForceHistoryState = 1
    public static let forceOn: ClientForceHistoryState = 2
    public static let forceOff: ClientForceHistoryState = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientDiscoverabilityStatus: ProtoEnum {
    public static let unknownDiscoverabilityStatus: ClientDiscoverabilityStatus = 0
    public static let optedInAndDiscoverable: ClientDiscoverabilityStatus = 1
    public static let optedInButNotDiscoverable: ClientDiscoverabilityStatus = 2
    public static let optedOut: ClientDiscoverabilityStatus = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientGetSelfInfoRequest_ClientRequestedFieldMask: ProtoEnum {
    public static let selfEntity: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 1
    public static let isKnownMinor: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 2
    public static let clientPresence: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 3
    public static let dndState: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 4
    public static let desktopOffState: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 5
    public static let phoneData: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 6
    public static let configurationBit: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 7
    public static let googlePlusUser: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 8
    public static let desktopSoundSetting: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 9
    public static let richClientPresenceMood: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 10
    public static let richClientPresenceInCallState: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 11
    public static let richPresenceEnabledState: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 12
    public static let babelUser: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 13
    public static let desktopAvailabilitySharingState: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 14
    public static let googlePlusMobileUser: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 15
    public static let desktopHtml5Notifications: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 16
    public static let managedPlusPages: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 17
    public static let richClientPresenceStatusMessage: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 18
    public static let accountAgeGroup: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 19
    public static let mobileExperiments: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 20
    public static let talkSharedInvisible: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 21
    public static let callerIdSettings: ClientGetSelfInfoRequest_ClientRequestedFieldMask = 22
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientUrlRedirectSpec_ClientRedirectType: ProtoEnum {
    public static let unknownRedirectType: ClientUrlRedirectSpec_ClientRedirectType = 0
    public static let fife: ClientUrlRedirectSpec_ClientRedirectType = 1
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ClientHangoutMediaType: ProtoEnum {
    public static let audioVideo: ClientHangoutMediaType = 1
    public static let audioOnly: ClientHangoutMediaType = 2
    public static let pushToTalk: ClientHangoutMediaType = 3
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct HEligibleCallerIdToken: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case callerIdPhoneNumber = 1
        case signature = 2
        case signatureTtlUsec = 3
    }
    
    public var callerIdPhoneNumber: GCVPhoneNumber? = nil
    public var signature: String? = nil
    public var signatureTtlUsec: UInt64? = nil
    
    public init(callerIdPhoneNumber: GCVPhoneNumber? = nil, signature: String? = nil, signatureTtlUsec: UInt64? = nil) {
        self.callerIdPhoneNumber = callerIdPhoneNumber
        self.signature = signature
        self.signatureTtlUsec = signatureTtlUsec
    }
}

public struct GCVContactPhoneNumber: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case phoneNumber = 1
        case type = 3
        case formattedType = 4
    }
    
    public var phoneNumber: GCVPhoneNumber? = nil
    public var type: String? = nil
    public var formattedType: String? = nil
    
    public init(phoneNumber: GCVPhoneNumber? = nil, type: String? = nil, formattedType: String? = nil) {
        self.phoneNumber = phoneNumber
        self.type = type
        self.formattedType = formattedType
    }
}

public struct GCVPhoneNumber_I18nData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case nationalNumber = 1
        case internationalNumber = 2
        case countryCode = 3
        case regionCode = 4
        case isValid = 5
    }
    
    public var nationalNumber: String? = nil
    public var internationalNumber: String? = nil
    public var countryCode: Int32? = nil
    public var regionCode: String? = nil
    public var isValid: Bool? = nil
    
    public init(nationalNumber: String? = nil, internationalNumber: String? = nil, countryCode: Int32? = nil, regionCode: String? = nil, isValid: Bool? = nil) {
        self.nationalNumber = nationalNumber
        self.internationalNumber = internationalNumber
        self.countryCode = countryCode
        self.regionCode = regionCode
        self.isValid = isValid
    }
}

public struct GCVPhoneNumber: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case e164 = 1
        case i18NData = 2
    }
    
    public var e164: String? = nil
    public var i18NData: GCVPhoneNumber_I18nData? = nil
    
    public init(e164: String? = nil, i18NData: GCVPhoneNumber_I18nData? = nil) {
        self.e164 = e164
        self.i18NData = i18NData
    }
}

public struct Attachment: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case embedItem = 1
        case id_p = 3
    }
    
    public var embedItem: EMEmbedClientItem? = nil
    public var id_p: String? = nil
    
    public init(embedItem: EMEmbedClientItem? = nil, id_p: String? = nil) {
        self.embedItem = embedItem
        self.id_p = id_p
    }
}

public struct SocialHashtagData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case searchText = 1
    }
    
    public var searchText: String? = nil
    
    public init(searchText: String? = nil) {
        self.searchText = searchText
    }
}

public struct SocialUserMentionData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case userGaiaId = 1
        case userId = 2
        case email = 3
    }
    
    public var userGaiaId: Int64? = nil
    public var userId: String? = nil
    public var email: String? = nil
    
    public init(userGaiaId: Int64? = nil, userId: String? = nil, email: String? = nil) {
        self.userGaiaId = userGaiaId
        self.userId = userId
        self.email = email
    }
}

public struct SocialLinkData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case linkTarget = 1
        case displayURL = 2
        case attachment = 3
        case title = 4
    }
    
    public var linkTarget: String? = nil
    public var displayURL: String? = nil
    public var attachment: Attachment? = nil
    public var title: String? = nil
    
    public init(linkTarget: String? = nil, displayURL: String? = nil, attachment: Attachment? = nil, title: String? = nil) {
        self.linkTarget = linkTarget
        self.displayURL = displayURL
        self.attachment = attachment
        self.title = title
    }
}

public struct SocialFormatting: ProtoMessage {
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
}

public struct SocialSegmentType_SegmentTypeEnum: ProtoEnum {
    public static let text: SocialSegmentType_SegmentTypeEnum = 0
    public static let lineBreak: SocialSegmentType_SegmentTypeEnum = 1
    public static let link: SocialSegmentType_SegmentTypeEnum = 2
    public static let userMention: SocialSegmentType_SegmentTypeEnum = 3
    public static let hashtag: SocialSegmentType_SegmentTypeEnum = 4
    public static let allUserMention: SocialSegmentType_SegmentTypeEnum = 5
    
    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct SocialSegment: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case text = 2
        case formatting = 3
        case linkData = 4
        case userMentionData = 5
        case hashtagData = 6
    }
    
    public var type: SocialSegmentType_SegmentTypeEnum? = nil
    public var text: String? = nil
    public var formatting: SocialFormatting? = nil
    public var linkData: SocialLinkData? = nil
    public var userMentionData: SocialUserMentionData? = nil
    public var hashtagData: SocialHashtagData? = nil
    
    public init(type: SocialSegmentType_SegmentTypeEnum? = nil, text: String? = nil, formatting: SocialFormatting? = nil, linkData: SocialLinkData? = nil, userMentionData: SocialUserMentionData? = nil, hashtagData: SocialHashtagData? = nil) {
        self.type = type
        self.text = text
        self.formatting = formatting
        self.linkData = linkData
        self.userMentionData = userMentionData
        self.hashtagData = hashtagData
    }
}

public struct SocialSegmentType: ProtoMessage {
    /*
    public enum CodingKeys: Int, CodingKey {
    }
    */
    
    public init() {
    }
}

public struct SocialSegments: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case segmentsArray = 1
    }
    
    public var segmentsArray: [SocialSegment] = []
    
    public init(segmentsArray: [SocialSegment] = []) {
        self.segmentsArray = segmentsArray
    }
}

public struct ClientGroupLinkSharingModification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case newStatus = 1
    }
    
    public var newStatus: ClientGroupLinkSharingStatus? = nil
    
    public init(newStatus: ClientGroupLinkSharingStatus? = nil) {
        self.newStatus = newStatus
    }
}

public struct ClientSetGroupLinkSharingEnabledResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case createdEvent = 2
        case updatedConversation = 3
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var createdEvent: ClientEvent? = nil
    public var updatedConversation: ClientConversation? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, createdEvent: ClientEvent? = nil, updatedConversation: ClientConversation? = nil) {
        self.responseHeader = responseHeader
        self.createdEvent = createdEvent
        self.updatedConversation = updatedConversation
    }
}

public struct ClientSetGroupLinkSharingEnabledRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case eventRequestHeader = 2
        case groupLinkSharingStatus = 4
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var eventRequestHeader: ClientEventRequestHeader? = nil
    public var groupLinkSharingStatus: ClientGroupLinkSharingStatus? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, eventRequestHeader: ClientEventRequestHeader? = nil, groupLinkSharingStatus: ClientGroupLinkSharingStatus? = nil) {
        self.requestHeader = requestHeader
        self.eventRequestHeader = eventRequestHeader
        self.groupLinkSharingStatus = groupLinkSharingStatus
    }
}

public struct ClientStateUpdate: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case stateUpdateHeader = 1
        case conversationNotification = 2
        case eventNotification = 3
        case focusNotification = 4
        case typingNotification = 5
        case notificationLevelNotification = 6
        case replyToInviteNotification = 7
        case watermarkNotification = 8
        case deprecated10 = 10
        case viewModification = 11
        case easterEggNotification = 12
        case clientConversation = 13
        case selfPresenceNotification = 14
        case deleteNotification = 15
        case presenceNotification = 16
        case blockNotification = 17
        case invitationWatermarkNotification = 18
        case configurationNotification = 19
        case richPresenceEnabledStateNotification = 20
        case contactsNotification = 21
        case deliveryMediumModification = 23
        case callerIdConfigNotification = 28
        case markEventObservedNotification = 30
        case globalNotificationLevelNotification = 31
    }
    
    public var stateUpdateHeader: ClientStateUpdateHeader? = nil
    public var conversationNotification: ClientConversationNotification? = nil
    public var eventNotification: ClientEventNotification? = nil
    public var focusNotification: ClientSetFocusNotification? = nil
    public var typingNotification: ClientSetTypingNotification? = nil
    public var notificationLevelNotification: ClientSetConversationNotificationLevelNotification? = nil
    public var replyToInviteNotification: ClientReplyToInviteNotification? = nil
    public var watermarkNotification: ClientWatermarkNotification? = nil
    public var deprecated10: String? = nil
    public var viewModification: ClientConversationViewModification? = nil
    public var easterEggNotification: ClientEasterEggNotification? = nil
    public var clientConversation: ClientConversation? = nil
    public var selfPresenceNotification: ClientSelfPresenceNotification? = nil
    public var deleteNotification: ClientDeleteActionNotification? = nil
    public var presenceNotification: ClientPresenceNotification? = nil
    public var blockNotification: ClientBlockNotification? = nil
    public var invitationWatermarkNotification: ClientInvitationWatermarkNotification? = nil
    public var configurationNotification: ClientConfigurationNotification? = nil
    public var richPresenceEnabledStateNotification: ClientRichPresenceEnabledStateNotification? = nil
    public var contactsNotification: ClientContactsNotification? = nil
    public var deliveryMediumModification: ClientConversationDeliveryMediumModification? = nil
    public var callerIdConfigNotification: ClientCallerIdConfigNotification? = nil
    public var markEventObservedNotification: ClientMarkEventObservedNotification? = nil
    public var globalNotificationLevelNotification: ClientGlobalNotificationLevelNotification? = nil
    
    public init(stateUpdateHeader: ClientStateUpdateHeader? = nil, conversationNotification: ClientConversationNotification? = nil, eventNotification: ClientEventNotification? = nil, focusNotification: ClientSetFocusNotification? = nil, typingNotification: ClientSetTypingNotification? = nil, notificationLevelNotification: ClientSetConversationNotificationLevelNotification? = nil, replyToInviteNotification: ClientReplyToInviteNotification? = nil, watermarkNotification: ClientWatermarkNotification? = nil, deprecated10: String? = nil, viewModification: ClientConversationViewModification? = nil, easterEggNotification: ClientEasterEggNotification? = nil, clientConversation: ClientConversation? = nil, selfPresenceNotification: ClientSelfPresenceNotification? = nil, deleteNotification: ClientDeleteActionNotification? = nil, presenceNotification: ClientPresenceNotification? = nil, blockNotification: ClientBlockNotification? = nil, invitationWatermarkNotification: ClientInvitationWatermarkNotification? = nil, configurationNotification: ClientConfigurationNotification? = nil, richPresenceEnabledStateNotification: ClientRichPresenceEnabledStateNotification? = nil, contactsNotification: ClientContactsNotification? = nil, deliveryMediumModification: ClientConversationDeliveryMediumModification? = nil, callerIdConfigNotification: ClientCallerIdConfigNotification? = nil, markEventObservedNotification: ClientMarkEventObservedNotification? = nil, globalNotificationLevelNotification: ClientGlobalNotificationLevelNotification? = nil) {
        self.stateUpdateHeader = stateUpdateHeader
        self.conversationNotification = conversationNotification
        self.eventNotification = eventNotification
        self.focusNotification = focusNotification
        self.typingNotification = typingNotification
        self.notificationLevelNotification = notificationLevelNotification
        self.replyToInviteNotification = replyToInviteNotification
        self.watermarkNotification = watermarkNotification
        self.deprecated10 = deprecated10
        self.viewModification = viewModification
        self.easterEggNotification = easterEggNotification
        self.clientConversation = clientConversation
        self.selfPresenceNotification = selfPresenceNotification
        self.deleteNotification = deleteNotification
        self.presenceNotification = presenceNotification
        self.blockNotification = blockNotification
        self.invitationWatermarkNotification = invitationWatermarkNotification
        self.configurationNotification = configurationNotification
        self.richPresenceEnabledStateNotification = richPresenceEnabledStateNotification
        self.contactsNotification = contactsNotification
        self.deliveryMediumModification = deliveryMediumModification
        self.callerIdConfigNotification = callerIdConfigNotification
        self.markEventObservedNotification = markEventObservedNotification
        self.globalNotificationLevelNotification = globalNotificationLevelNotification
    }
}

public struct ClientSetInviteSettingsResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case consistencyToken = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var consistencyToken: String? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, consistencyToken: String? = nil) {
        self.responseHeader = responseHeader
        self.consistencyToken = consistencyToken
    }
}

public struct ClientSetInviteSettingsRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case settingsToSet = 2
        case consistencyToken = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var settingsToSet: ClientInviteSettings? = nil
    public var consistencyToken: String? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, settingsToSet: ClientInviteSettings? = nil, consistencyToken: String? = nil) {
        self.requestHeader = requestHeader
        self.settingsToSet = settingsToSet
        self.consistencyToken = consistencyToken
    }
}

public struct ClientGetInviteSettingsResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case settings = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var settings: ClientInviteSettings? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, settings: ClientInviteSettings? = nil) {
        self.responseHeader = responseHeader
        self.settings = settings
    }
}

public struct ClientGetInviteSettingsRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case consistencyToken = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var consistencyToken: String? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, consistencyToken: String? = nil) {
        self.requestHeader = requestHeader
        self.consistencyToken = consistencyToken
    }
}

public struct ClientInviteSettings_CircleLevel: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 1
        case name = 2
        case level = 3
    }
    
    public var id: Int64? = nil
    public var name: String? = nil
    public var level: ClientInviteSettings_NotificationLevel? = nil
    
    public init(id: Int64? = nil, name: String? = nil, level: ClientInviteSettings_NotificationLevel? = nil) {
        self.id = id
        self.name = name
        self.level = level
    }
}

public struct ClientInviteSettings: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case publicLevel = 1
        case emailLevel = 2
        case phoneLevel = 3
        case circleLevelArray = 4
    }
    
    public var publicLevel: ClientInviteSettings_NotificationLevel? = nil
    public var emailLevel: ClientInviteSettings_NotificationLevel? = nil
    public var phoneLevel: ClientInviteSettings_NotificationLevel? = nil
    public var circleLevelArray: [ClientInviteSettings_CircleLevel] = []
    
    public init(publicLevel: ClientInviteSettings_NotificationLevel? = nil, emailLevel: ClientInviteSettings_NotificationLevel? = nil, phoneLevel: ClientInviteSettings_NotificationLevel? = nil, circleLevelArray: [ClientInviteSettings_CircleLevel] = []) {
        self.publicLevel = publicLevel
        self.emailLevel = emailLevel
        self.phoneLevel = phoneLevel
        self.circleLevelArray = circleLevelArray
    }
}

public struct ClientOpenGroupConversationFromUrlResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case conversationId = 2
        case createdEvent = 3
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var createdEvent: ClientEvent? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, conversationId: ClientConversationId? = nil, createdEvent: ClientEvent? = nil) {
        self.responseHeader = responseHeader
        self.conversationId = conversationId
        self.createdEvent = createdEvent
    }
}

public struct ClientOpenGroupConversationFromUrlRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case eventRequestHeader = 2
        case conversationURL = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var eventRequestHeader: ClientEventRequestHeader? = nil
    public var conversationURL: String? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, eventRequestHeader: ClientEventRequestHeader? = nil, conversationURL: String? = nil) {
        self.requestHeader = requestHeader
        self.eventRequestHeader = eventRequestHeader
        self.conversationURL = conversationURL
    }
}

public struct ClientGetGroupConversationUrlResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case groupConversationURL = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var groupConversationURL: String? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, groupConversationURL: String? = nil) {
        self.responseHeader = responseHeader
        self.groupConversationURL = groupConversationURL
    }
}

public struct ClientGetGroupConversationUrlRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
    }
}

public struct ClientMarkEventObservedNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case observedConversationEventArray = 1
    }
    
    public var observedConversationEventArray: [ClientObservedConversationEvents] = []
    
    public init(observedConversationEventArray: [ClientObservedConversationEvents] = []) {
        self.observedConversationEventArray = observedConversationEventArray
    }
}

public struct ClientMarkEventObservedResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case observedConversationEventArray = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var observedConversationEventArray: [ClientObservedConversationEvents] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, observedConversationEventArray: [ClientObservedConversationEvents] = []) {
        self.responseHeader = responseHeader
        self.observedConversationEventArray = observedConversationEventArray
    }
}

public struct ClientObservedConversationEvents_ObservedEvent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case eventId = 1
        case lastObservedTimestamp = 2
        case observedStatus = 3
    }
    
    public var eventId: String? = nil
    public var lastObservedTimestamp: UInt64? = nil
    public var observedStatus: ClientEventObservedStatus? = nil
    
    public init(eventId: String? = nil, lastObservedTimestamp: UInt64? = nil, observedStatus: ClientEventObservedStatus? = nil) {
        self.eventId = eventId
        self.lastObservedTimestamp = lastObservedTimestamp
        self.observedStatus = observedStatus
    }
}

public struct ClientObservedConversationEvents: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case observedEventArray = 2
    }
    
    public var conversationId: ClientConversationId? = nil
    public var observedEventArray: [ClientObservedConversationEvents_ObservedEvent] = []
    
    public init(conversationId: ClientConversationId? = nil, observedEventArray: [ClientObservedConversationEvents_ObservedEvent] = []) {
        self.conversationId = conversationId
        self.observedEventArray = observedEventArray
    }
}

public struct ClientMarkEventObservedRequest_MarkConversationObserved: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case eventIdArray = 2
    }
    
    public var conversationId: ClientConversationId? = nil
    public var eventIdArray: [String] = []
    
    public init(conversationId: ClientConversationId? = nil, eventIdArray: [String] = []) {
        self.conversationId = conversationId
        self.eventIdArray = eventIdArray
    }
}

public struct ClientMarkEventObservedRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case observedConversationEventArray = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var observedConversationEventArray: [ClientMarkEventObservedRequest_MarkConversationObserved] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, observedConversationEventArray: [ClientMarkEventObservedRequest_MarkConversationObserved] = []) {
        self.requestHeader = requestHeader
        self.observedConversationEventArray = observedConversationEventArray
    }
}

public struct ClientCallerIdConfigNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case callerIdSettingArray = 1
    }
    
    public var callerIdSettingArray: [ClientCallerIdSetting] = []
    
    public init(callerIdSettingArray: [ClientCallerIdSetting] = []) {
        self.callerIdSettingArray = callerIdSettingArray
    }
}

public struct ClientSetCallerIdConfigResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case callerIdSettingArray = 1
        case responseHeader = 2
    }
    
    public var callerIdSettingArray: [ClientCallerIdSetting] = []
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(callerIdSettingArray: [ClientCallerIdSetting] = [], responseHeader: ClientResponseHeader? = nil) {
        self.callerIdSettingArray = callerIdSettingArray
        self.responseHeader = responseHeader
    }
}

public struct ClientSetCallerIdConfigRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case callerIdConfigArray = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var callerIdConfigArray: [ClientCallerIdConfig] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, callerIdConfigArray: [ClientCallerIdConfig] = []) {
        self.requestHeader = requestHeader
        self.callerIdConfigArray = callerIdConfigArray
    }
}

public struct ClientCallerIdConfig: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case callerIdPhoneNumber = 1
        case callerIdState = 2
    }
    
    public var callerIdPhoneNumber: GCVPhoneNumber? = nil
    public var callerIdState: ClientCallerIdState? = nil
    
    public init(callerIdPhoneNumber: GCVPhoneNumber? = nil, callerIdState: ClientCallerIdState? = nil) {
        self.callerIdPhoneNumber = callerIdPhoneNumber
        self.callerIdState = callerIdState
    }
}

public struct ClientContactsNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case dismissedParticipantIdArray = 1
        case undismissedParticipantIdArray = 2
        case updatedFavoriteArray = 3
        case favoritesModified = 4
    }
    
    public var dismissedParticipantIdArray: [ClientParticipantId] = []
    public var undismissedParticipantIdArray: [ClientParticipantId] = []
    public var updatedFavoriteArray: [ClientFavoriteUpdate] = []
    public var favoritesModified: ClientFavoritesNotification? = nil
    
    public init(dismissedParticipantIdArray: [ClientParticipantId] = [], undismissedParticipantIdArray: [ClientParticipantId] = [], updatedFavoriteArray: [ClientFavoriteUpdate] = [], favoritesModified: ClientFavoritesNotification? = nil) {
        self.dismissedParticipantIdArray = dismissedParticipantIdArray
        self.undismissedParticipantIdArray = undismissedParticipantIdArray
        self.updatedFavoriteArray = updatedFavoriteArray
        self.favoritesModified = favoritesModified
    }
}

public struct ClientFavoritesNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case currentVersion = 1
    }
    
    public var currentVersion: String? = nil
    
    public init(currentVersion: String? = nil) {
        self.currentVersion = currentVersion
    }
}

public struct ClientBlockNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case blockStateChangeArray = 1
    }
    
    public var blockStateChangeArray: [ClientBlockStateChange] = []
    
    public init(blockStateChangeArray: [ClientBlockStateChange] = []) {
        self.blockStateChangeArray = blockStateChangeArray
    }
}

public struct ClientBlockStateChange: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case participantId = 1
        case newBlockState = 2
    }
    
    public var participantId: ClientParticipantId? = nil
    public var newBlockState: ClientBlockState? = nil
    
    public init(participantId: ClientParticipantId? = nil, newBlockState: ClientBlockState? = nil) {
        self.participantId = participantId
        self.newBlockState = newBlockState
    }
}

public struct ClientEventNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case event = 1
    }
    
    public var event: ClientEvent? = nil
    
    public init(event: ClientEvent? = nil) {
        self.event = event
    }
}

public struct ClientConversationNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversation = 1
    }
    
    public var conversation: ClientConversation? = nil
    
    public init(conversation: ClientConversation? = nil) {
        self.conversation = conversation
    }
}

public struct ClientStateUpdateHeader: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case activeClientState = 1
        case deprecated2 = 2
        case requestTraceId = 3
        case currentServerTime = 5
        case clientGeneratedRequestId = 7
        case selfFanoutId = 8
    }
    
    public var activeClientState: ActiveClientState? = nil
    public var deprecated2: String? = nil
    public var requestTraceId: /*UInt64*/String? = nil
    public var currentServerTime: UInt64? = nil
    public var clientGeneratedRequestId: String? = nil
    public var selfFanoutId: String? = nil
    
    public init(activeClientState: ActiveClientState? = nil, deprecated2: String? = nil, requestTraceId: /*UInt64*/String? = nil, currentServerTime: UInt64? = nil, clientGeneratedRequestId: String? = nil, selfFanoutId: String? = nil) {
        self.activeClientState = activeClientState
        self.deprecated2 = deprecated2
        self.requestTraceId = requestTraceId
        self.currentServerTime = currentServerTime
        self.clientGeneratedRequestId = clientGeneratedRequestId
        self.selfFanoutId = selfFanoutId
    }
}

public struct ClientBatchUpdate: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case stateUpdateArray = 1
    }
    
    public var stateUpdateArray: [ClientStateUpdate] = []
    
    public init(stateUpdateArray: [ClientStateUpdate] = []) {
        self.stateUpdateArray = stateUpdateArray
    }
}

public struct ClientInviteToken: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case inviteTokenURL = 1
    }
    
    public var inviteTokenURL: String? = nil
    
    public init(inviteTokenURL: String? = nil) {
        self.inviteTokenURL = inviteTokenURL
    }
}

public struct ClientSuggestions: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case suggestionArray = 2
    }
    
    public var suggestionArray: [ClientSuggestion] = []
    
    public init(suggestionArray: [ClientSuggestion] = []) {
        self.suggestionArray = suggestionArray
    }
}

public struct ClientEasterEggSuggestionInfo: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case variationIndex = 1
        case animationDurationMsec = 2
        case animatedAssetURLWithoutSuffixArray = 3
        case horizontalAlignment = 4
    }
    
    public var variationIndex: Int32? = nil
    public var animationDurationMsec: Int32? = nil
    public var animatedAssetURLWithoutSuffixArray: [String] = []
    public var horizontalAlignment: ClientEasterEggSuggestionInfo_ClientGemHorizontalAlignment? = nil
    
    public init(variationIndex: Int32? = nil, animationDurationMsec: Int32? = nil, animatedAssetURLWithoutSuffixArray: [String] = [], horizontalAlignment: ClientEasterEggSuggestionInfo_ClientGemHorizontalAlignment? = nil) {
        self.variationIndex = variationIndex
        self.animationDurationMsec = animationDurationMsec
        self.animatedAssetURLWithoutSuffixArray = animatedAssetURLWithoutSuffixArray
        self.horizontalAlignment = horizontalAlignment
    }
}

public struct ClientSuggestion: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case suggestionId = 1
        case expirationTimeUsec = 2
        case type = 3
        case attachment = 6
        case easterEggSuggestionInfo = 7
        case matchedMessageSubstring = 8
        case smartReplyText = 9
    }
    
    public var suggestionId: String? = nil
    public var expirationTimeUsec: UInt64? = nil
    public var type: ClientSuggestion_ClientSuggestionType? = nil
    public var attachment: Attachment? = nil
    public var easterEggSuggestionInfo: ClientEasterEggSuggestionInfo? = nil
    public var matchedMessageSubstring: String? = nil
    public var smartReplyText: String? = nil
    
    public init(suggestionId: String? = nil, expirationTimeUsec: UInt64? = nil, type: ClientSuggestion_ClientSuggestionType? = nil, attachment: Attachment? = nil, easterEggSuggestionInfo: ClientEasterEggSuggestionInfo? = nil, matchedMessageSubstring: String? = nil, smartReplyText: String? = nil) {
        self.suggestionId = suggestionId
        self.expirationTimeUsec = expirationTimeUsec
        self.type = type
        self.attachment = attachment
        self.easterEggSuggestionInfo = easterEggSuggestionInfo
        self.matchedMessageSubstring = matchedMessageSubstring
        self.smartReplyText = smartReplyText
    }
}

public struct ClientUrlRedirectWrapperResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case redirectResultArray = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var redirectResultArray: [ClientUrlRedirectResult] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, redirectResultArray: [ClientUrlRedirectResult] = []) {
        self.responseHeader = responseHeader
        self.redirectResultArray = redirectResultArray
    }
}

public struct ClientUrlRedirectWrapperRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case URLRedirectSpecArray = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var URLRedirectSpecArray: [ClientUrlRedirectSpec] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, URLRedirectSpecArray: [ClientUrlRedirectSpec] = []) {
        self.requestHeader = requestHeader
        self.URLRedirectSpecArray = URLRedirectSpecArray
    }
}

public struct ClientUrlRedirectResult: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case redirectSpec = 1
        case redirectedURL = 2
        case redirectError = 3
    }
    
    public var redirectSpec: ClientUrlRedirectSpec? = nil
    public var redirectedURL: String? = nil
    public var redirectError: ClientUrlRedirectResult_ClientRedirectError? = nil
    
    public init(redirectSpec: ClientUrlRedirectSpec? = nil, redirectedURL: String? = nil, redirectError: ClientUrlRedirectResult_ClientRedirectError? = nil) {
        self.redirectSpec = redirectSpec
        self.redirectedURL = redirectedURL
        self.redirectError = redirectError
    }
}

public struct ClientUrlRedirectSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case redirectType = 1
        case originalURL = 2
    }
    
    public var redirectType: ClientUrlRedirectSpec_ClientRedirectType? = nil
    public var originalURL: String? = nil
    
    public init(redirectType: ClientUrlRedirectSpec_ClientRedirectType? = nil, originalURL: String? = nil) {
        self.redirectType = redirectType
        self.originalURL = originalURL
    }
}

public struct ClientConfigurationBitError: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case configurationBitType = 1
        case errorDescription = 2
    }
    
    public var configurationBitType: ClientConfigurationBitType? = nil
    public var errorDescription: String? = nil
    
    public init(configurationBitType: ClientConfigurationBitType? = nil, errorDescription: String? = nil) {
        self.configurationBitType = configurationBitType
        self.errorDescription = errorDescription
    }
}

public struct ClientConfigurationNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case configurationBitChangeArray = 1
        case desktopAvailabilitySharingEnabled = 3
    }
    
    public var configurationBitChangeArray: [ClientConfigurationBit] = []
    public var desktopAvailabilitySharingEnabled: Bool? = nil
    
    public init(configurationBitChangeArray: [ClientConfigurationBit] = [], desktopAvailabilitySharingEnabled: Bool? = nil) {
        self.configurationBitChangeArray = configurationBitChangeArray
        self.desktopAvailabilitySharingEnabled = desktopAvailabilitySharingEnabled
    }
}

public struct ClientConfigurationBit: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case configurationBitType = 1
        case value = 2
    }
    
    public var configurationBitType: ClientConfigurationBitType? = nil
    public var value: Bool? = nil
    
    public init(configurationBitType: ClientConfigurationBitType? = nil, value: Bool? = nil) {
        self.configurationBitType = configurationBitType
        self.value = value
    }
}

public struct ClientSetConfigurationBitResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case configurationBitErrorArray = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var configurationBitErrorArray: [ClientConfigurationBitError] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, configurationBitErrorArray: [ClientConfigurationBitError] = []) {
        self.responseHeader = responseHeader
        self.configurationBitErrorArray = configurationBitErrorArray
    }
}

public struct ClientSetConfigurationBitRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case configurationBitArray = 2
        case desktopAvailabilitySharingEnabled = 4
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var configurationBitArray: [ClientConfigurationBit] = []
    public var desktopAvailabilitySharingEnabled: Bool? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, configurationBitArray: [ClientConfigurationBit] = [], desktopAvailabilitySharingEnabled: Bool? = nil) {
        self.requestHeader = requestHeader
        self.configurationBitArray = configurationBitArray
        self.desktopAvailabilitySharingEnabled = desktopAvailabilitySharingEnabled
    }
}

public struct ClientFinishPhoneNumberVerificationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientFinishPhoneNumberVerificationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case phoneNumber = 2
        case code = 3
        case discoverable = 4
        case additionalDiscoverablePhoneNumberArray = 5
        case phoneNumberVerificationContext = 6
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var phoneNumber: GCVPhoneNumber? = nil
    public var code: String? = nil
    public var discoverable: Bool? = nil
    public var additionalDiscoverablePhoneNumberArray: [GCVPhoneNumber] = []
    public var phoneNumberVerificationContext: ClientPhoneNumberVerificationContext? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, phoneNumber: GCVPhoneNumber? = nil, code: String? = nil, discoverable: Bool? = nil, additionalDiscoverablePhoneNumberArray: [GCVPhoneNumber] = [], phoneNumberVerificationContext: ClientPhoneNumberVerificationContext? = nil) {
        self.requestHeader = requestHeader
        self.phoneNumber = phoneNumber
        self.code = code
        self.discoverable = discoverable
        self.additionalDiscoverablePhoneNumberArray = additionalDiscoverablePhoneNumberArray
        self.phoneNumberVerificationContext = phoneNumberVerificationContext
    }
}

public struct ClientStartPhoneNumberVerificationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case phoneNumberVerificationContext = 2
        case rateLimitExceeded = 3
        case smsToHumanCodeLength = 4
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var phoneNumberVerificationContext: ClientPhoneNumberVerificationContext? = nil
    public var rateLimitExceeded: Bool? = nil
    public var smsToHumanCodeLength: UInt32? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, phoneNumberVerificationContext: ClientPhoneNumberVerificationContext? = nil, rateLimitExceeded: Bool? = nil, smsToHumanCodeLength: UInt32? = nil) {
        self.responseHeader = responseHeader
        self.phoneNumberVerificationContext = phoneNumberVerificationContext
        self.rateLimitExceeded = rateLimitExceeded
        self.smsToHumanCodeLength = smsToHumanCodeLength
    }
}

public struct ClientStartPhoneNumberVerificationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case phoneNumber = 2
        case method = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var phoneNumber: GCVPhoneNumber? = nil
    public var method: ClientStartPhoneNumberVerificationRequest_ClientPhoneNumberVerificationMethod? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, phoneNumber: GCVPhoneNumber? = nil, method: ClientStartPhoneNumberVerificationRequest_ClientPhoneNumberVerificationMethod? = nil) {
        self.requestHeader = requestHeader
        self.phoneNumber = phoneNumber
        self.method = method
    }
}

public struct ClientPhoneNumberVerificationContext: ProtoMessage {
    /*
    public enum CodingKeys: Int, CodingKey {
    }
    */
    
    public init() {
    }
}

public struct ClientSendOffnetworkInvitationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientSendOffnetworkInvitationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case inviteeAddress = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var inviteeAddress: ClientOffnetworkAddress? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, inviteeAddress: ClientOffnetworkAddress? = nil) {
        self.requestHeader = requestHeader
        self.inviteeAddress = inviteeAddress
    }
}

public struct ClientOffnetworkAddress: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case phone = 2
        case email = 3
    }
    
    public var type: ClientOffnetworkAddress_Type? = nil
    public var phone: String? = nil
    public var email: String? = nil
    
    public init(type: ClientOffnetworkAddress_Type? = nil, phone: String? = nil, email: String? = nil) {
        self.type = type
        self.phone = phone
        self.email = email
    }
}

public struct ClientDeleteActionNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case deleteAction = 2
    }
    
    public var conversationId: ClientConversationId? = nil
    public var deleteAction: ClientDeleteAction? = nil
    
    public init(conversationId: ClientConversationId? = nil, deleteAction: ClientDeleteAction? = nil) {
        self.conversationId = conversationId
        self.deleteAction = deleteAction
    }
}

public struct ClientDeleteConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case deleteAction = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var deleteAction: ClientDeleteAction? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, deleteAction: ClientDeleteAction? = nil) {
        self.responseHeader = responseHeader
        self.deleteAction = deleteAction
    }
}

public struct ClientDeleteConversationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case deleteUpperBoundTimestamp = 3
        case deleteType = 4
        case deleteEventIdArray = 5
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var deleteUpperBoundTimestamp: UInt64? = nil
    public var deleteType: ClientDeleteType? = nil
    public var deleteEventIdArray: [String] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, deleteUpperBoundTimestamp: UInt64? = nil, deleteType: ClientDeleteType? = nil, deleteEventIdArray: [String] = []) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.deleteUpperBoundTimestamp = deleteUpperBoundTimestamp
        self.deleteType = deleteType
        self.deleteEventIdArray = deleteEventIdArray
    }
}

public struct ClientDeleteAction: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case deleteActionTimestamp = 1
        case deleteUpperBoundTimestamp = 2
        case deleteType = 3
        case deleteEventIdArray = 4
    }
    
    public var deleteActionTimestamp: UInt64? = nil
    public var deleteUpperBoundTimestamp: UInt64? = nil
    public var deleteType: ClientDeleteType? = nil
    public var deleteEventIdArray: [String] = []
    
    public init(deleteActionTimestamp: UInt64? = nil, deleteUpperBoundTimestamp: UInt64? = nil, deleteType: ClientDeleteType? = nil, deleteEventIdArray: [String] = []) {
        self.deleteActionTimestamp = deleteActionTimestamp
        self.deleteUpperBoundTimestamp = deleteUpperBoundTimestamp
        self.deleteType = deleteType
        self.deleteEventIdArray = deleteEventIdArray
    }
}

public struct ClientInvitationWatermarkNotification: ProtoMessage {
    /*
    public enum CodingKeys: Int, CodingKey {
    }
    */
    
    public init() {
    }
}

public struct ClientUpdateInvitationWatermarkResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientUpdateInvitationWatermarkRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case latestReadTimestamp = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var latestReadTimestamp: UInt64? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, latestReadTimestamp: UInt64? = nil) {
        self.requestHeader = requestHeader
        self.latestReadTimestamp = latestReadTimestamp
    }
}

public struct ClientWatermarkNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case participantId = 1
        case conversationId = 2
        case latestReadTimestamp = 3
    }
    
    public var participantId: ClientParticipantId? = nil
    public var conversationId: ClientConversationId? = nil
    public var latestReadTimestamp: UInt64? = nil
    
    public init(participantId: ClientParticipantId? = nil, conversationId: ClientConversationId? = nil, latestReadTimestamp: UInt64? = nil) {
        self.participantId = participantId
        self.conversationId = conversationId
        self.latestReadTimestamp = latestReadTimestamp
    }
}

public struct ClientUpdateWatermarkResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientUpdateWatermarkRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case latestReadTimestamp = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var latestReadTimestamp: UInt64? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, latestReadTimestamp: UInt64? = nil) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.latestReadTimestamp = latestReadTimestamp
    }
}

public struct ClientGetEntityByIdResponse_ClientEntityLookupResult: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case lookupSpec = 1
        case entityArray = 2
    }
    
    public var lookupSpec: ClientEntityLookupSpec? = nil
    public var entityArray: [ClientEntity] = []
    
    public init(lookupSpec: ClientEntityLookupSpec? = nil, entityArray: [ClientEntity] = []) {
        self.lookupSpec = lookupSpec
        self.entityArray = entityArray
    }
}

public struct ClientGetEntityByIdResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case entityArray = 2
        case entityResultArray = 3
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var entityArray: [ClientEntity] = []
    public var entityResultArray: [ClientGetEntityByIdResponse_ClientEntityLookupResult] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, entityArray: [ClientEntity] = [], entityResultArray: [ClientGetEntityByIdResponse_ClientEntityLookupResult] = []) {
        self.responseHeader = responseHeader
        self.entityArray = entityArray
        self.entityResultArray = entityResultArray
    }
}

public struct ClientGetEntityByIdRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2 = 2
        case batchLookupSpecArray = 3
        case additionalEntityDataArray = 4
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2: ClientEntityLookupSpec? = nil
    public var batchLookupSpecArray: [ClientEntityLookupSpec] = []
    public var additionalEntityDataArray: [ClientAdditionalEntityData] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2: ClientEntityLookupSpec? = nil, batchLookupSpecArray: [ClientEntityLookupSpec] = [], additionalEntityDataArray: [ClientAdditionalEntityData] = []) {
        self.requestHeader = requestHeader
        self.deprecated2 = deprecated2
        self.batchLookupSpecArray = batchLookupSpecArray
        self.additionalEntityDataArray = additionalEntityDataArray
    }
}

public struct ClientEntityLookupSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case gaiaId = 1
        case jid = 2
        case email = 3
        case phone = 4
        case chatId = 5
        case createOffnetworkGaia = 6
    }
    
    public var gaiaId: String? = nil
    public var jid: String? = nil
    public var email: String? = nil
    public var phone: String? = nil
    public var chatId: String? = nil
    public var createOffnetworkGaia: Bool? = nil
    
    public init(gaiaId: String? = nil, jid: String? = nil, email: String? = nil, phone: String? = nil, chatId: String? = nil, createOffnetworkGaia: Bool? = nil) {
        self.gaiaId = gaiaId
        self.jid = jid
        self.email = email
        self.phone = phone
        self.chatId = chatId
        self.createOffnetworkGaia = createOffnetworkGaia
    }
}

public struct ClientGetFavoritesResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case allFavoritesArray = 2
        case currentVersion = 3
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var allFavoritesArray: [ClientFavorite] = []
    public var currentVersion: String? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, allFavoritesArray: [ClientFavorite] = [], currentVersion: String? = nil) {
        self.responseHeader = responseHeader
        self.allFavoritesArray = allFavoritesArray
        self.currentVersion = currentVersion
    }
}

public struct ClientGetFavoritesRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil) {
        self.requestHeader = requestHeader
    }
}

public struct ClientUpdateFavoriteContactResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case error = 2
        case allFavoritesArray = 3
        case currentVersion = 4
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var error: ClientUpdateFavoritesError? = nil
    public var allFavoritesArray: [ClientFavorite] = []
    public var currentVersion: String? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, error: ClientUpdateFavoritesError? = nil, allFavoritesArray: [ClientFavorite] = [], currentVersion: String? = nil) {
        self.responseHeader = responseHeader
        self.error = error
        self.allFavoritesArray = allFavoritesArray
        self.currentVersion = currentVersion
    }
}

public struct ClientUpdateFavoriteContactRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case updateArray = 2
        case currentVersion = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var updateArray: [ClientFavoriteUpdate] = []
    public var currentVersion: String? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, updateArray: [ClientFavoriteUpdate] = [], currentVersion: String? = nil) {
        self.requestHeader = requestHeader
        self.updateArray = updateArray
        self.currentVersion = currentVersion
    }
}

public struct ClientFavoriteUpdate: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case favorite = 1
        case remove = 2
    }
    
    public var favorite: ClientFavorite? = nil
    public var remove: Bool? = nil
    
    public init(favorite: ClientFavorite? = nil, remove: Bool? = nil) {
        self.favorite = favorite
        self.remove = remove
    }
}

public struct ClientFavorite: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case participantId = 1
        case position = 2
        case conversationId = 3
    }
    
    public var participantId: ClientParticipantId? = nil
    public var position: Int32? = nil
    public var conversationId: ClientConversationId? = nil
    
    public init(participantId: ClientParticipantId? = nil, position: Int32? = nil, conversationId: ClientConversationId? = nil) {
        self.participantId = participantId
        self.position = position
        self.conversationId = conversationId
    }
}

public struct ClientSearchEntitiesResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case entityArray = 2
        case incomplete = 3
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var entityArray: [ClientEntity] = []
    public var incomplete: Bool? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, entityArray: [ClientEntity] = [], incomplete: Bool? = nil) {
        self.responseHeader = responseHeader
        self.entityArray = entityArray
        self.incomplete = incomplete
    }
}

public struct ClientSearchEntitiesRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2Array = 2
        case query = 3
        case maxCount = 4
        case deprecated5 = 5
        case includePages = 6
        case includeIsBabelUser = 7
        case additionalEntityDataArray = 8
        case maxConversationCount = 9
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2Array: [String] = []
    public var query: String? = nil
    public var maxCount: Int32? = nil
    public var deprecated5: Bool? = nil
    public var includePages: Bool? = nil
    public var includeIsBabelUser: Bool? = nil
    public var additionalEntityDataArray: [ClientAdditionalEntityData] = []
    public var maxConversationCount: Int32? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2Array: [String] = [], query: String? = nil, maxCount: Int32? = nil, deprecated5: Bool? = nil, includePages: Bool? = nil, includeIsBabelUser: Bool? = nil, additionalEntityDataArray: [ClientAdditionalEntityData] = [], maxConversationCount: Int32? = nil) {
        self.requestHeader = requestHeader
        self.deprecated2Array = deprecated2Array
        self.query = query
        self.maxCount = maxCount
        self.deprecated5 = deprecated5
        self.includePages = includePages
        self.includeIsBabelUser = includeIsBabelUser
        self.additionalEntityDataArray = additionalEntityDataArray
        self.maxConversationCount = maxConversationCount
    }
}

public struct ClientGetSuggestedEntitiesResponse_ClientContactResults: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case hashMatched = 1
        case hash = 2
        case contactArray = 3
    }
    
    public var hashMatched: Bool? = nil
    public var hash: String? = nil
    public var contactArray: [ClientGetSuggestedEntitiesResponse_ClientContactResult] = []
    
    public init(hashMatched: Bool? = nil, hash: String? = nil, contactArray: [ClientGetSuggestedEntitiesResponse_ClientContactResult] = []) {
        self.hashMatched = hashMatched
        self.hash = hash
        self.contactArray = contactArray
    }
}

public struct ClientGetSuggestedEntitiesResponse_ClientContactResult: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case entity = 1
        case invitationStatus = 2
        case conversationId = 3
    }
    
    public var entity: ClientEntity? = nil
    public var invitationStatus: ClientInvitationStatus? = nil
    public var conversationId: ClientConversationId? = nil
    
    public init(entity: ClientEntity? = nil, invitationStatus: ClientInvitationStatus? = nil, conversationId: ClientConversationId? = nil) {
        self.entity = entity
        self.invitationStatus = invitationStatus
        self.conversationId = conversationId
    }
}

public struct ClientGetSuggestedEntitiesResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case entityArray = 2
        case scoringFailed = 3
        case favorites = 4
        case contactsYouHangoutWith = 5
        case otherContactsOnHangouts = 6
        case otherContacts = 7
        case dismissedContacts = 8
        case pinnedFavorites = 9
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var entityArray: [ClientEntity] = []
    public var scoringFailed: Bool? = nil
    public var favorites: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil
    public var contactsYouHangoutWith: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil
    public var otherContactsOnHangouts: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil
    public var otherContacts: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil
    public var dismissedContacts: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil
    public var pinnedFavorites: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, entityArray: [ClientEntity] = [], scoringFailed: Bool? = nil, favorites: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil, contactsYouHangoutWith: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil, otherContactsOnHangouts: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil, otherContacts: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil, dismissedContacts: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil, pinnedFavorites: ClientGetSuggestedEntitiesResponse_ClientContactResults? = nil) {
        self.responseHeader = responseHeader
        self.entityArray = entityArray
        self.scoringFailed = scoringFailed
        self.favorites = favorites
        self.contactsYouHangoutWith = contactsYouHangoutWith
        self.otherContactsOnHangouts = otherContactsOnHangouts
        self.otherContacts = otherContacts
        self.dismissedContacts = dismissedContacts
        self.pinnedFavorites = pinnedFavorites
    }
}

public struct ClientEntity: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case deprecated1 = 1
        case deprecated2 = 2
        case deprecated3 = 3
        case deprecated4 = 4
        case deprecated5 = 5
        case invalid = 7
        case presence = 8
        case id = 9
        case properties = 10
        case blocked = 11
        case domainProperties = 12
        case entityType = 13
        case isBabelUser = 14
        case babelUserState = 15
        case invitationStatus = 17
        case isAnonymousPhone = 18
    }
    
    public var deprecated1: String? = nil
    public var deprecated2: String? = nil
    public var deprecated3: String? = nil
    public var deprecated4: String? = nil
    public var deprecated5: String? = nil
    public var invalid: Bool? = nil
    public var presence: ClientPresence? = nil
    public var id: ClientParticipantId? = nil
    public var properties: ClientEntityProperties? = nil
    public var blocked: Bool? = nil
    public var domainProperties: ClientDomainProperties? = nil
    public var entityType: ClientUserType? = nil
    public var isBabelUser: Bool? = nil
    public var babelUserState: ClientEntity_BabelUserState? = nil
    public var invitationStatus: ClientInvitationStatus? = nil
    public var isAnonymousPhone: Bool? = nil
    
    public init(deprecated1: String? = nil, deprecated2: String? = nil, deprecated3: String? = nil, deprecated4: String? = nil, deprecated5: String? = nil, invalid: Bool? = nil, presence: ClientPresence? = nil, id: ClientParticipantId? = nil, properties: ClientEntityProperties? = nil, blocked: Bool? = nil, domainProperties: ClientDomainProperties? = nil, entityType: ClientUserType? = nil, isBabelUser: Bool? = nil, babelUserState: ClientEntity_BabelUserState? = nil, invitationStatus: ClientInvitationStatus? = nil, isAnonymousPhone: Bool? = nil) {
        self.deprecated1 = deprecated1
        self.deprecated2 = deprecated2
        self.deprecated3 = deprecated3
        self.deprecated4 = deprecated4
        self.deprecated5 = deprecated5
        self.invalid = invalid
        self.presence = presence
        self.id = id
        self.properties = properties
        self.blocked = blocked
        self.domainProperties = domainProperties
        self.entityType = entityType
        self.isBabelUser = isBabelUser
        self.babelUserState = babelUserState
        self.invitationStatus = invitationStatus
        self.isAnonymousPhone = isAnonymousPhone
    }
}

public struct ClientDomainProperties: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case showChatWarning = 1
        case phoneCallingEnabled = 2
        case voiceCallingEnabled = 3
        case videoCallingEnabled = 4
        case domainName = 5
        case isPaidDasher = 6
        case forceHistoryState = 7
        case deprecated8 = 8
        case chatRestricted = 9
        case domainDefaultOtrSetting = 11
        case isRugbyUser = 12
    }
    
    public var showChatWarning: Bool? = nil
    public var phoneCallingEnabled: Bool? = nil
    public var voiceCallingEnabled: Bool? = nil
    public var videoCallingEnabled: Bool? = nil
    public var domainName: String? = nil
    public var isPaidDasher: Bool? = nil
    public var forceHistoryState: ClientForceHistoryState? = nil
    public var deprecated8: String? = nil
    public var chatRestricted: ClientDomainProperties_ClientChatRestricted? = nil
    public var domainDefaultOtrSetting: ClientDomainProperties_ClientDomainDefaultOtrSetting? = nil
    public var isRugbyUser: Bool? = nil
    
    public init(showChatWarning: Bool? = nil, phoneCallingEnabled: Bool? = nil, voiceCallingEnabled: Bool? = nil, videoCallingEnabled: Bool? = nil, domainName: String? = nil, isPaidDasher: Bool? = nil, forceHistoryState: ClientForceHistoryState? = nil, deprecated8: String? = nil, chatRestricted: ClientDomainProperties_ClientChatRestricted? = nil, domainDefaultOtrSetting: ClientDomainProperties_ClientDomainDefaultOtrSetting? = nil, isRugbyUser: Bool? = nil) {
        self.showChatWarning = showChatWarning
        self.phoneCallingEnabled = phoneCallingEnabled
        self.voiceCallingEnabled = voiceCallingEnabled
        self.videoCallingEnabled = videoCallingEnabled
        self.domainName = domainName
        self.isPaidDasher = isPaidDasher
        self.forceHistoryState = forceHistoryState
        self.deprecated8 = deprecated8
        self.chatRestricted = chatRestricted
        self.domainDefaultOtrSetting = domainDefaultOtrSetting
        self.isRugbyUser = isRugbyUser
    }
}

public struct ClientEntityProperties_ClientAffinity: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case affinityType = 1
        case value = 2
        case loggingId = 3
    }
    
    public var affinityType: ClientEntityProperties_ClientAffinity_ClientAffinityType? = nil
    public var value: Double? = nil
    public var loggingId: String? = nil
    
    public init(affinityType: ClientEntityProperties_ClientAffinity_ClientAffinityType? = nil, value: Double? = nil, loggingId: String? = nil) {
        self.affinityType = affinityType
        self.value = value
        self.loggingId = loggingId
    }
}

public struct ClientEntityProperties: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case displayName = 2
        case firstName = 3
        case photoURL = 4
        case emailArray = 5
        case phoneArray = 6
        case location = 7
        case organization = 8
        case role = 9
        case inUsersDomain = 10
        case circleIdArray = 13
        case phoneNumberArray = 14
        case canonicalEmail = 15
        case affinityArray = 16
    }
    
    public var type: ClientEntityProperties_ProfileType? = nil
    public var displayName: String? = nil
    public var firstName: String? = nil
    public var photoURL: String? = nil
    public var emailArray: [String] = []
    public var phoneArray: [String] = []
    public var location: String? = nil
    public var organization: String? = nil
    public var role: String? = nil
    public var inUsersDomain: Bool? = nil
    public var circleIdArray: [String] = []
    public var phoneNumberArray: [GCVContactPhoneNumber] = []
    public var canonicalEmail: String? = nil
    public var affinityArray: [ClientEntityProperties_ClientAffinity] = []
    
    public init(type: ClientEntityProperties_ProfileType? = nil, displayName: String? = nil, firstName: String? = nil, photoURL: String? = nil, emailArray: [String] = [], phoneArray: [String] = [], location: String? = nil, organization: String? = nil, role: String? = nil, inUsersDomain: Bool? = nil, circleIdArray: [String] = [], phoneNumberArray: [GCVContactPhoneNumber] = [], canonicalEmail: String? = nil, affinityArray: [ClientEntityProperties_ClientAffinity] = []) {
        self.type = type
        self.displayName = displayName
        self.firstName = firstName
        self.photoURL = photoURL
        self.emailArray = emailArray
        self.phoneArray = phoneArray
        self.location = location
        self.organization = organization
        self.role = role
        self.inUsersDomain = inUsersDomain
        self.circleIdArray = circleIdArray
        self.phoneNumberArray = phoneNumberArray
        self.canonicalEmail = canonicalEmail
        self.affinityArray = affinityArray
    }
}

public struct ClientGetSuggestedEntitiesRequest_ClientContactOptions: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case maxCount = 1
        case hash = 2
    }
    
    public var maxCount: Int32? = nil
    public var hash: String? = nil
    
    public init(maxCount: Int32? = nil, hash: String? = nil) {
        self.maxCount = maxCount
        self.hash = hash
    }
}

public struct ClientGetSuggestedEntitiesRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2Array = 2
        case deprecated3Array = 3
        case maxCount = 4
        case deprecated5 = 5
        case givenIdArray = 6
        case includeLegacy = 7
        case favoritesOptions = 8
        case contactsYouHangoutWithOptions = 9
        case otherContactsOnHangoutsOptions = 10
        case otherContactsOptions = 11
        case dismissedContactsOptions = 12
        case pinnedFavoritesOptions = 13
        case includeIsBabelUser = 14
        case additionalEntityDataArray = 15
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2Array: [String] = []
    public var deprecated3Array: [String] = []
    public var maxCount: Int32? = nil
    public var deprecated5: Bool? = nil
    public var givenIdArray: [ClientParticipantId] = []
    public var includeLegacy: Bool? = nil
    public var favoritesOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil
    public var contactsYouHangoutWithOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil
    public var otherContactsOnHangoutsOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil
    public var otherContactsOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil
    public var dismissedContactsOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil
    public var pinnedFavoritesOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil
    public var includeIsBabelUser: Bool? = nil
    public var additionalEntityDataArray: [ClientAdditionalEntityData] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2Array: [String] = [], deprecated3Array: [String] = [], maxCount: Int32? = nil, deprecated5: Bool? = nil, givenIdArray: [ClientParticipantId] = [], includeLegacy: Bool? = nil, favoritesOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil, contactsYouHangoutWithOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil, otherContactsOnHangoutsOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil, otherContactsOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil, dismissedContactsOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil, pinnedFavoritesOptions: ClientGetSuggestedEntitiesRequest_ClientContactOptions? = nil, includeIsBabelUser: Bool? = nil, additionalEntityDataArray: [ClientAdditionalEntityData] = []) {
        self.requestHeader = requestHeader
        self.deprecated2Array = deprecated2Array
        self.deprecated3Array = deprecated3Array
        self.maxCount = maxCount
        self.deprecated5 = deprecated5
        self.givenIdArray = givenIdArray
        self.includeLegacy = includeLegacy
        self.favoritesOptions = favoritesOptions
        self.contactsYouHangoutWithOptions = contactsYouHangoutWithOptions
        self.otherContactsOnHangoutsOptions = otherContactsOnHangoutsOptions
        self.otherContactsOptions = otherContactsOptions
        self.dismissedContactsOptions = dismissedContactsOptions
        self.pinnedFavoritesOptions = pinnedFavoritesOptions
        self.includeIsBabelUser = includeIsBabelUser
        self.additionalEntityDataArray = additionalEntityDataArray
    }
}

public struct ClientPhone: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case phoneNumber = 1
        case googleVoice = 2
        case verificationStatus = 3
        case discoverable = 4
        case discoverabilityStatus = 5
        case primary = 6
    }
    
    public var phoneNumber: GCVPhoneNumber? = nil
    public var googleVoice: Bool? = nil
    public var verificationStatus: ClientVerificationStatus? = nil
    public var discoverable: Bool? = nil
    public var discoverabilityStatus: ClientDiscoverabilityStatus? = nil
    public var primary: Bool? = nil
    
    public init(phoneNumber: GCVPhoneNumber? = nil, googleVoice: Bool? = nil, verificationStatus: ClientVerificationStatus? = nil, discoverable: Bool? = nil, discoverabilityStatus: ClientDiscoverabilityStatus? = nil, primary: Bool? = nil) {
        self.phoneNumber = phoneNumber
        self.googleVoice = googleVoice
        self.verificationStatus = verificationStatus
        self.discoverable = discoverable
        self.discoverabilityStatus = discoverabilityStatus
        self.primary = primary
    }
}

public struct ClientPhoneData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case phoneArray = 1
        case callerIdSettingArray = 2
        case callerIdSettingsMask = 3
    }
    
    public var phoneArray: [ClientPhone] = []
    public var callerIdSettingArray: [ClientCallerIdSetting] = []
    public var callerIdSettingsMask: ClientCallerIdSettingsMask? = nil
    
    public init(phoneArray: [ClientPhone] = [], callerIdSettingArray: [ClientCallerIdSetting] = [], callerIdSettingsMask: ClientCallerIdSettingsMask? = nil) {
        self.phoneArray = phoneArray
        self.callerIdSettingArray = callerIdSettingArray
        self.callerIdSettingsMask = callerIdSettingsMask
    }
}

public struct ClientExperimentValue_Value: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case longValue = 1
        case doubleValue = 2
        case stringValue = 3
        case boolValue = 4
    }
    
    public var longValue: Int64? = nil
    public var doubleValue: Double? = nil
    public var stringValue: String? = nil
    public var boolValue: Bool? = nil
    
    public init(longValue: Int64? = nil, doubleValue: Double? = nil, stringValue: String? = nil, boolValue: Bool? = nil) {
        self.longValue = longValue
        self.doubleValue = doubleValue
        self.stringValue = stringValue
        self.boolValue = boolValue
    }
}

public struct ClientExperimentValue: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case hexFlagId = 1
        case flagType = 2
        case value = 3
        case logAction = 4
    }
    
    public var hexFlagId: String? = nil
    public var flagType: ClientExperimentValue_FlagType? = nil
    public var value: ClientExperimentValue_Value? = nil
    public var logAction: ClientExperimentValue_LogAction? = nil
    
    public init(hexFlagId: String? = nil, flagType: ClientExperimentValue_FlagType? = nil, value: ClientExperimentValue_Value? = nil, logAction: ClientExperimentValue_LogAction? = nil) {
        self.hexFlagId = hexFlagId
        self.flagType = flagType
        self.value = value
        self.logAction = logAction
    }
}

public struct ClientCallerIdSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case callerIdPhoneNumber = 1
        case ineligibilityCause = 2
        case callerIdToken = 3
        case defaultCallerId = 4
    }
    
    public var callerIdPhoneNumber: GCVPhoneNumber? = nil
    public var ineligibilityCause: ClientCallerIdSetting_ClientIneligibilityCause? = nil
    public var callerIdToken: HEligibleCallerIdToken? = nil
    public var defaultCallerId: Bool? = nil
    
    public init(callerIdPhoneNumber: GCVPhoneNumber? = nil, ineligibilityCause: ClientCallerIdSetting_ClientIneligibilityCause? = nil, callerIdToken: HEligibleCallerIdToken? = nil, defaultCallerId: Bool? = nil) {
        self.callerIdPhoneNumber = callerIdPhoneNumber
        self.ineligibilityCause = ineligibilityCause
        self.callerIdToken = callerIdToken
        self.defaultCallerId = defaultCallerId
    }
}

public struct ClientGetSelfInfoResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case selfEntity = 2
        case isKnownMinor = 3
        case dndState = 5
        case phoneData = 7
        case configurationBitArray = 8
        case googlePlusUser = 10
        case richPresenceState = 12
        case babelUser = 13
        case desktopAvailabilitySharingEnabled = 14
        case googlePlusMobileUser = 15
        case managedPlusPageArray = 17
        case accountAgeGroup = 18
        case mobileExperimentArray = 20
        case defaultNotificationLevel = 24
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var selfEntity: ClientEntity? = nil
    public var isKnownMinor: Bool? = nil
    public var dndState: ClientDndState? = nil
    public var phoneData: ClientPhoneData? = nil
    public var configurationBitArray: [ClientConfigurationBit] = []
    public var googlePlusUser: Bool? = nil
    public var richPresenceState: ClientRichPresenceState? = nil
    public var babelUser: Bool? = nil
    public var desktopAvailabilitySharingEnabled: Bool? = nil
    public var googlePlusMobileUser: Bool? = nil
    public var managedPlusPageArray: [ClientParticipantId] = []
    public var accountAgeGroup: ClientGetSelfInfoResponse_AccountAgeGroup? = nil
    public var mobileExperimentArray: [ClientExperimentValue] = []
    public var defaultNotificationLevel: ClientNotificationLevel? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, selfEntity: ClientEntity? = nil, isKnownMinor: Bool? = nil, dndState: ClientDndState? = nil, phoneData: ClientPhoneData? = nil, configurationBitArray: [ClientConfigurationBit] = [], googlePlusUser: Bool? = nil, richPresenceState: ClientRichPresenceState? = nil, babelUser: Bool? = nil, desktopAvailabilitySharingEnabled: Bool? = nil, googlePlusMobileUser: Bool? = nil, managedPlusPageArray: [ClientParticipantId] = [], accountAgeGroup: ClientGetSelfInfoResponse_AccountAgeGroup? = nil, mobileExperimentArray: [ClientExperimentValue] = [], defaultNotificationLevel: ClientNotificationLevel? = nil) {
        self.responseHeader = responseHeader
        self.selfEntity = selfEntity
        self.isKnownMinor = isKnownMinor
        self.dndState = dndState
        self.phoneData = phoneData
        self.configurationBitArray = configurationBitArray
        self.googlePlusUser = googlePlusUser
        self.richPresenceState = richPresenceState
        self.babelUser = babelUser
        self.desktopAvailabilitySharingEnabled = desktopAvailabilitySharingEnabled
        self.googlePlusMobileUser = googlePlusMobileUser
        self.managedPlusPageArray = managedPlusPageArray
        self.accountAgeGroup = accountAgeGroup
        self.mobileExperimentArray = mobileExperimentArray
        self.defaultNotificationLevel = defaultNotificationLevel
    }
}

public struct ClientGetSelfInfoRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case requiredFieldsArray = 2
        case optionalFieldsArray = 3
        case upgradeToBabel = 4
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var requiredFieldsArray: [ClientGetSelfInfoRequest_ClientRequestedFieldMask] = []
    public var optionalFieldsArray: [ClientGetSelfInfoRequest_ClientRequestedFieldMask] = []
    public var upgradeToBabel: Bool? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, requiredFieldsArray: [ClientGetSelfInfoRequest_ClientRequestedFieldMask] = [], optionalFieldsArray: [ClientGetSelfInfoRequest_ClientRequestedFieldMask] = [], upgradeToBabel: Bool? = nil) {
        self.requestHeader = requestHeader
        self.requiredFieldsArray = requiredFieldsArray
        self.optionalFieldsArray = optionalFieldsArray
        self.upgradeToBabel = upgradeToBabel
    }
}

public struct ClientConversationDeliveryMediumModification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case newDeliveryMedium = 2
    }
    
    public var conversationId: ClientConversationId? = nil
    public var newDeliveryMedium: ClientDeliveryMedium? = nil
    
    public init(conversationId: ClientConversationId? = nil, newDeliveryMedium: ClientDeliveryMedium? = nil) {
        self.conversationId = conversationId
        self.newDeliveryMedium = newDeliveryMedium
    }
}

public struct ClientConversationViewModification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case oldView = 2
        case newView = 3
    }
    
    public var conversationId: ClientConversationId? = nil
    public var oldView: ClientConversationView? = nil
    public var newView: ClientConversationView? = nil
    
    public init(conversationId: ClientConversationId? = nil, oldView: ClientConversationView? = nil, newView: ClientConversationView? = nil) {
        self.conversationId = conversationId
        self.oldView = oldView
        self.newView = newView
    }
}

public struct ClientModifyConversationViewResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientModifyConversationViewRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case newView = 3
        case lastEventTimestamp = 4
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var newView: ClientConversationView? = nil
    public var lastEventTimestamp: UInt64? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, newView: ClientConversationView? = nil, lastEventTimestamp: UInt64? = nil) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.newView = newView
        self.lastEventTimestamp = lastEventTimestamp
    }
}

public struct ClientReplyToInviteNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case type = 2
    }
    
    public var conversationId: ClientConversationId? = nil
    public var type: ClientReplyToInviteType? = nil
    
    public init(conversationId: ClientConversationId? = nil, type: ClientReplyToInviteType? = nil) {
        self.conversationId = conversationId
        self.type = type
    }
}

public struct ClientReplyToInviteResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case updatedConversation = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var updatedConversation: ClientConversation? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, updatedConversation: ClientConversation? = nil) {
        self.responseHeader = responseHeader
        self.updatedConversation = updatedConversation
    }
}

public struct ClientReplyToInviteRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case type = 3
        case clientGeneratedId = 4
        case declineSignalArray = 5
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var type: ClientReplyToInviteType? = nil
    public var clientGeneratedId: UInt64? = nil
    public var declineSignalArray: [ClientDeclineSignal] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, type: ClientReplyToInviteType? = nil, clientGeneratedId: UInt64? = nil, declineSignalArray: [ClientDeclineSignal] = []) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.type = type
        self.clientGeneratedId = clientGeneratedId
        self.declineSignalArray = declineSignalArray
    }
}

public struct ClientDeclineAllInvitesResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientDeclineAllInvitesRequest_ClientDeclineAllInvitesWatermarkSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case upToTimestamp = 1
        case affinity = 2
    }
    
    public var upToTimestamp: UInt64? = nil
    public var affinity: ClientInvitationAffinity? = nil
    
    public init(upToTimestamp: UInt64? = nil, affinity: ClientInvitationAffinity? = nil) {
        self.upToTimestamp = upToTimestamp
        self.affinity = affinity
    }
}

public struct ClientDeclineAllInvitesRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case declineAllWatermarkArray = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var declineAllWatermarkArray: [ClientDeclineAllInvitesRequest_ClientDeclineAllInvitesWatermarkSpec] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, declineAllWatermarkArray: [ClientDeclineAllInvitesRequest_ClientDeclineAllInvitesWatermarkSpec] = []) {
        self.requestHeader = requestHeader
        self.declineAllWatermarkArray = declineAllWatermarkArray
    }
}

public struct ClientSelfPresenceNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case presence = 2
        case dndState = 3
        case richPresenceState = 6
    }
    
    public var presence: ClientPresence? = nil
    public var dndState: ClientDndState? = nil
    public var richPresenceState: ClientRichPresenceState? = nil
    
    public init(presence: ClientPresence? = nil, dndState: ClientDndState? = nil, richPresenceState: ClientRichPresenceState? = nil) {
        self.presence = presence
        self.dndState = dndState
        self.richPresenceState = richPresenceState
    }
}

public struct ClientInCallState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case clientIdentifier = 1
        case callType = 2
        case expirationTimestamp = 3
    }
    
    public var clientIdentifier: ClientClientIdentifier? = nil
    public var callType: ClientInCall_ClientCallType? = nil
    public var expirationTimestamp: UInt64? = nil
    
    public init(clientIdentifier: ClientClientIdentifier? = nil, callType: ClientInCall_ClientCallType? = nil, expirationTimestamp: UInt64? = nil) {
        self.clientIdentifier = clientIdentifier
        self.callType = callType
        self.expirationTimestamp = expirationTimestamp
    }
}

public struct ClientStatusMessageState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case statusMessageArray = 1
        case expirationTimestamp = 2
    }
    
    public var statusMessageArray: [ClientMessageContent] = []
    public var expirationTimestamp: UInt64? = nil
    
    public init(statusMessageArray: [ClientMessageContent] = [], expirationTimestamp: UInt64? = nil) {
        self.statusMessageArray = statusMessageArray
        self.expirationTimestamp = expirationTimestamp
    }
}

public struct ClientRichPresenceState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case inCallArray = 2
        case richPresenceEnabledStateArray = 3
        case statusMessage = 4
    }
    
    public var inCallArray: [ClientInCallState] = []
    public var richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []
    public var statusMessage: ClientStatusMessageState? = nil
    
    public init(inCallArray: [ClientInCallState] = [], richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = [], statusMessage: ClientStatusMessageState? = nil) {
        self.inCallArray = inCallArray
        self.richPresenceEnabledStateArray = richPresenceEnabledStateArray
        self.statusMessage = statusMessage
    }
}

public struct ClientDndState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case doNotDisturb = 1
        case expirationTimestamp = 2
        case version = 3
    }
    
    public var doNotDisturb: Bool? = nil
    public var expirationTimestamp: Int64? = nil
    public var version: Int64? = nil
    
    public init(doNotDisturb: Bool? = nil, expirationTimestamp: Int64? = nil, version: Int64? = nil) {
        self.doNotDisturb = doNotDisturb
        self.expirationTimestamp = expirationTimestamp
        self.version = version
    }
}

public struct ClientInCallSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case callType = 1
        case timeoutSecs = 2
    }
    
    public var callType: ClientInCall_ClientCallType? = nil
    public var timeoutSecs: UInt64? = nil
    
    public init(callType: ClientInCall_ClientCallType? = nil, timeoutSecs: UInt64? = nil) {
        self.callType = callType
        self.timeoutSecs = timeoutSecs
    }
}

public struct ClientStatusMessageSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case statusMessageArray = 1
    }
    
    public var statusMessageArray: [ClientChatMessageSpec] = []
    
    public init(statusMessageArray: [ClientChatMessageSpec] = []) {
        self.statusMessageArray = statusMessageArray
    }
}

public struct ClientDndSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case doNotDisturb = 1
        case timeoutSecs = 2
    }
    
    public var doNotDisturb: Bool? = nil
    public var timeoutSecs: UInt64? = nil
    
    public init(doNotDisturb: Bool? = nil, timeoutSecs: UInt64? = nil) {
        self.doNotDisturb = doNotDisturb
        self.timeoutSecs = timeoutSecs
    }
}

public struct ClientRichPresenceEnabledStateNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case richPresenceEnabledStateArray = 1
    }
    
    public var richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []
    
    public init(richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []) {
        self.richPresenceEnabledStateArray = richPresenceEnabledStateArray
    }
}

public struct ClientGetRichPresenceEnabledStateResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case richPresenceEnabledStateArray = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []) {
        self.responseHeader = responseHeader
        self.richPresenceEnabledStateArray = richPresenceEnabledStateArray
    }
}

public struct ClientGetRichPresenceEnabledStateRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case requestedRichPresenceEnabledStateArray = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var requestedRichPresenceEnabledStateArray: [ClientRichPresenceType] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, requestedRichPresenceEnabledStateArray: [ClientRichPresenceType] = []) {
        self.requestHeader = requestHeader
        self.requestedRichPresenceEnabledStateArray = requestedRichPresenceEnabledStateArray
    }
}

public struct ClientSetRichPresenceEnabledStateResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case updatedRichPresenceEnabledStateArray = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var updatedRichPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, updatedRichPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []) {
        self.responseHeader = responseHeader
        self.updatedRichPresenceEnabledStateArray = updatedRichPresenceEnabledStateArray
    }
}

public struct ClientSetRichPresenceEnabledStateRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case richPresenceEnabledStateArray = 2
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []) {
        self.requestHeader = requestHeader
        self.richPresenceEnabledStateArray = richPresenceEnabledStateArray
    }
}

public struct ClientRichPresenceEnabledState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case enabled = 2
    }
    
    public var type: ClientRichPresenceType? = nil
    public var enabled: Bool? = nil
    
    public init(type: ClientRichPresenceType? = nil, enabled: Bool? = nil) {
        self.type = type
        self.enabled = enabled
    }
}

public struct ClientPresenceStateSetting: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case timeoutSecs = 1
        case presenceState = 2
    }
    
    public var timeoutSecs: UInt64? = nil
    public var presenceState: ClientPresenceStateSetting_ClientPresenceState? = nil
    
    public init(timeoutSecs: UInt64? = nil, presenceState: ClientPresenceStateSetting_ClientPresenceState? = nil) {
        self.timeoutSecs = timeoutSecs
        self.presenceState = presenceState
    }
}

public struct ClientSetPresenceResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientSetPresenceRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case presenceStateSetting = 2
        case dndSetting = 3
        case inCallSetting = 7
        case statusMessageSetting = 8
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var presenceStateSetting: ClientPresenceStateSetting? = nil
    public var dndSetting: ClientDndSetting? = nil
    public var inCallSetting: ClientInCallSetting? = nil
    public var statusMessageSetting: ClientStatusMessageSetting? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, presenceStateSetting: ClientPresenceStateSetting? = nil, dndSetting: ClientDndSetting? = nil, inCallSetting: ClientInCallSetting? = nil, statusMessageSetting: ClientStatusMessageSetting? = nil) {
        self.requestHeader = requestHeader
        self.presenceStateSetting = presenceStateSetting
        self.dndSetting = dndSetting
        self.inCallSetting = inCallSetting
        self.statusMessageSetting = statusMessageSetting
    }
}

public struct ClientDeviceStatus: ProtoMessage {
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
}

public struct ClientInCall: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case callType = 1
    }
    
    public var callType: ClientInCall_ClientCallType? = nil
    
    public init(callType: ClientInCall_ClientCallType? = nil) {
        self.callType = callType
    }
}

public struct ClientStatusMessage: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case statusMessageArray = 1
    }
    
    public var statusMessageArray: [ClientMessageContent] = []
    
    public init(statusMessageArray: [ClientMessageContent] = []) {
        self.statusMessageArray = statusMessageArray
    }
}

public struct ClientLastSeen: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case lastSeenTimestampUsec = 1
    }
    
    public var lastSeenTimestampUsec: UInt64? = nil
    
    public init(lastSeenTimestampUsec: UInt64? = nil) {
        self.lastSeenTimestampUsec = lastSeenTimestampUsec
    }
}

public struct ClientPresence: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case reachable = 1
        case available = 2
        case inCall = 5
        case deviceStatus = 6
        case deviceActivity = 7
        case statusMessage = 9
        case lastSeen = 10
    }
    
    public var reachable: Bool? = nil
    public var available: Bool? = nil
    public var inCall: ClientInCall? = nil
    public var deviceStatus: ClientDeviceStatus? = nil
    public var deviceActivity: ClientDeviceActivity? = nil
    public var statusMessage: ClientStatusMessage? = nil
    public var lastSeen: ClientLastSeen? = nil
    
    public init(reachable: Bool? = nil, available: Bool? = nil, inCall: ClientInCall? = nil, deviceStatus: ClientDeviceStatus? = nil, deviceActivity: ClientDeviceActivity? = nil, statusMessage: ClientStatusMessage? = nil, lastSeen: ClientLastSeen? = nil) {
        self.reachable = reachable
        self.available = available
        self.inCall = inCall
        self.deviceStatus = deviceStatus
        self.deviceActivity = deviceActivity
        self.statusMessage = statusMessage
        self.lastSeen = lastSeen
    }
}

public struct ClientQueryPresenceResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case presenceResultArray = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var presenceResultArray: [ClientPresenceResult] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, presenceResultArray: [ClientPresenceResult] = []) {
        self.responseHeader = responseHeader
        self.presenceResultArray = presenceResultArray
    }
}

public struct ClientQueryPresenceRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case participantIdArray = 2
        case fieldMaskArray = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var participantIdArray: [ClientParticipantId] = []
    public var fieldMaskArray: [ClientQueryPresenceRequest_ClientFieldMask] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, participantIdArray: [ClientParticipantId] = [], fieldMaskArray: [ClientQueryPresenceRequest_ClientFieldMask] = []) {
        self.requestHeader = requestHeader
        self.participantIdArray = participantIdArray
        self.fieldMaskArray = fieldMaskArray
    }
}

public struct ClientPresenceNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case presenceArray = 1
    }
    
    public var presenceArray: [ClientPresenceResult] = []
    
    public init(presenceArray: [ClientPresenceResult] = []) {
        self.presenceArray = presenceArray
    }
}

public struct ClientPresenceResult: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case userId = 1
        case presence = 2
    }
    
    public var userId: ClientParticipantId? = nil
    public var presence: ClientPresence? = nil
    
    public init(userId: ClientParticipantId? = nil, presence: ClientPresence? = nil) {
        self.userId = userId
        self.presence = presence
    }
}

public struct ClientDeviceActivity: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case confidence = 2
    }
    
    public var type: ClientDeviceActivity_Type? = nil
    public var confidence: Int32? = nil
    
    public init(type: ClientDeviceActivity_Type? = nil, confidence: Int32? = nil) {
        self.type = type
        self.confidence = confidence
    }
}

public struct ClientSetActiveClientResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case error = 2
        case clientLastSeenTimestampUsec = 3
        case lastSeenDeltaUsec = 4
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var error: ClientSetActiveClientResponse_ClientSetActiveClientError? = nil
    public var clientLastSeenTimestampUsec: UInt64? = nil
    public var lastSeenDeltaUsec: UInt64? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, error: ClientSetActiveClientResponse_ClientSetActiveClientError? = nil, clientLastSeenTimestampUsec: UInt64? = nil, lastSeenDeltaUsec: UInt64? = nil) {
        self.responseHeader = responseHeader
        self.error = error
        self.clientLastSeenTimestampUsec = clientLastSeenTimestampUsec
        self.lastSeenDeltaUsec = lastSeenDeltaUsec
    }
}

public struct ClientSetActiveClientRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case isActive = 2
        case fullJid = 3
        case timeoutSecs = 4
        case updateLastSeenTimestamp = 5
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var isActive: Bool? = nil
    public var fullJid: String? = nil
    public var timeoutSecs: UInt32? = nil
    public var updateLastSeenTimestamp: Bool? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, isActive: Bool? = nil, fullJid: String? = nil, timeoutSecs: UInt32? = nil, updateLastSeenTimestamp: Bool? = nil) {
        self.requestHeader = requestHeader
        self.isActive = isActive
        self.fullJid = fullJid
        self.timeoutSecs = timeoutSecs
        self.updateLastSeenTimestamp = updateLastSeenTimestamp
    }
}

public struct ClientRegisterDeviceResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case upgradeType = 2
        case upgradeExplanationURL = 3
        case fullJid = 5
        case iosBadgeCount = 6
        case clientResource = 7
        case learnMoreURL = 8
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var upgradeType: ClientUpgradeType? = nil
    public var upgradeExplanationURL: String? = nil
    public var fullJid: String? = nil
    public var iosBadgeCount: Int32? = nil
    public var clientResource: String? = nil
    public var learnMoreURL: String? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, upgradeType: ClientUpgradeType? = nil, upgradeExplanationURL: String? = nil, fullJid: String? = nil, iosBadgeCount: Int32? = nil, clientResource: String? = nil, learnMoreURL: String? = nil) {
        self.responseHeader = responseHeader
        self.upgradeType = upgradeType
        self.upgradeExplanationURL = upgradeExplanationURL
        self.fullJid = fullJid
        self.iosBadgeCount = iosBadgeCount
        self.clientResource = clientResource
        self.learnMoreURL = learnMoreURL
    }
}

public struct ClientRegisterDeviceRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deviceType = 2
        case registrationType = 3
        case locale = 4
        case stateUpdateVersion = 5
        case iosAppId = 7
        case iosToken = 8
        case androidId = 9
        case androidRegistrationId = 10
        case iosCapabilityArray = 11
        case androidCapabilityArray = 12
        case pstnNumber = 13
        case pstnCapabilityArray = 14
        case name = 15
        case androidAppId = 16
        case androidDeveloperAccount = 17
        case iosDeviceId = 18
        case glassCapabilityArray = 19
        case pstnAppId = 20
        case unregisterOnBehalfOfGaiaId = 21
        case iosScreenSizeDps = 22
        case androidScreenSizeDps = 23
        case iosMcsRegistrationId = 24
        case iosMcsAppId = 25
        case iosMcsDeveloperAccount = 26
        case pstnCarrierMcc = 27
        case pstnCarrierMnc = 28
        case iosPushOauthToken = 29
        case deviceAvailabilitySharingEnabled = 30
        case iosOauthTokensForParticipantsOnDeviceArray = 31
        case iosPushkitToken = 33
        case iosUploadedContactsPrivateKey = 34
        case androidInstanceId = 35
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deviceType: ClientDeviceType? = nil
    public var registrationType: ClientRegistrationType? = nil
    public var locale: String? = nil
    public var stateUpdateVersion: String? = nil
    public var iosAppId: String? = nil
    public var iosToken: String? = nil
    public var androidId: Int64? = nil
    public var androidRegistrationId: String? = nil
    public var iosCapabilityArray: [String] = []
    public var androidCapabilityArray: [String] = []
    public var pstnNumber: String? = nil
    public var pstnCapabilityArray: [String] = []
    public var name: String? = nil
    public var androidAppId: String? = nil
    public var androidDeveloperAccount: String? = nil
    public var iosDeviceId: String? = nil
    public var glassCapabilityArray: [String] = []
    public var pstnAppId: String? = nil
    public var unregisterOnBehalfOfGaiaId: String? = nil
    public var iosScreenSizeDps: Int32? = nil
    public var androidScreenSizeDps: Int32? = nil
    public var iosMcsRegistrationId: String? = nil
    public var iosMcsAppId: String? = nil
    public var iosMcsDeveloperAccount: String? = nil
    public var pstnCarrierMcc: Int32? = nil
    public var pstnCarrierMnc: Int32? = nil
    public var iosPushOauthToken: String? = nil
    public var deviceAvailabilitySharingEnabled: Bool? = nil
    public var iosOauthTokensForParticipantsOnDeviceArray: [String] = []
    public var iosPushkitToken: String? = nil
    public var iosUploadedContactsPrivateKey: String? = nil
    public var androidInstanceId: String? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, deviceType: ClientDeviceType? = nil, registrationType: ClientRegistrationType? = nil, locale: String? = nil, stateUpdateVersion: String? = nil, iosAppId: String? = nil, iosToken: String? = nil, androidId: Int64? = nil, androidRegistrationId: String? = nil, iosCapabilityArray: [String] = [], androidCapabilityArray: [String] = [], pstnNumber: String? = nil, pstnCapabilityArray: [String] = [], name: String? = nil, androidAppId: String? = nil, androidDeveloperAccount: String? = nil, iosDeviceId: String? = nil, glassCapabilityArray: [String] = [], pstnAppId: String? = nil, unregisterOnBehalfOfGaiaId: String? = nil, iosScreenSizeDps: Int32? = nil, androidScreenSizeDps: Int32? = nil, iosMcsRegistrationId: String? = nil, iosMcsAppId: String? = nil, iosMcsDeveloperAccount: String? = nil, pstnCarrierMcc: Int32? = nil, pstnCarrierMnc: Int32? = nil, iosPushOauthToken: String? = nil, deviceAvailabilitySharingEnabled: Bool? = nil, iosOauthTokensForParticipantsOnDeviceArray: [String] = [], iosPushkitToken: String? = nil, iosUploadedContactsPrivateKey: String? = nil, androidInstanceId: String? = nil) {
        self.requestHeader = requestHeader
        self.deviceType = deviceType
        self.registrationType = registrationType
        self.locale = locale
        self.stateUpdateVersion = stateUpdateVersion
        self.iosAppId = iosAppId
        self.iosToken = iosToken
        self.androidId = androidId
        self.androidRegistrationId = androidRegistrationId
        self.iosCapabilityArray = iosCapabilityArray
        self.androidCapabilityArray = androidCapabilityArray
        self.pstnNumber = pstnNumber
        self.pstnCapabilityArray = pstnCapabilityArray
        self.name = name
        self.androidAppId = androidAppId
        self.androidDeveloperAccount = androidDeveloperAccount
        self.iosDeviceId = iosDeviceId
        self.glassCapabilityArray = glassCapabilityArray
        self.pstnAppId = pstnAppId
        self.unregisterOnBehalfOfGaiaId = unregisterOnBehalfOfGaiaId
        self.iosScreenSizeDps = iosScreenSizeDps
        self.androidScreenSizeDps = androidScreenSizeDps
        self.iosMcsRegistrationId = iosMcsRegistrationId
        self.iosMcsAppId = iosMcsAppId
        self.iosMcsDeveloperAccount = iosMcsDeveloperAccount
        self.pstnCarrierMcc = pstnCarrierMcc
        self.pstnCarrierMnc = pstnCarrierMnc
        self.iosPushOauthToken = iosPushOauthToken
        self.deviceAvailabilitySharingEnabled = deviceAvailabilitySharingEnabled
        self.iosOauthTokensForParticipantsOnDeviceArray = iosOauthTokensForParticipantsOnDeviceArray
        self.iosPushkitToken = iosPushkitToken
        self.iosUploadedContactsPrivateKey = iosUploadedContactsPrivateKey
        self.androidInstanceId = androidInstanceId
    }
}

public struct ClientGlobalNotificationLevelNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case level = 1
    }
    
    public var level: ClientNotificationLevel? = nil
    
    public init(level: ClientNotificationLevel? = nil) {
        self.level = level
    }
}

public struct ClientSetConversationNotificationLevelNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case level = 2
        case revertTimeoutSecs = 3
        case timestamp = 4
    }
    
    public var conversationId: ClientConversationId? = nil
    public var level: ClientNotificationLevel? = nil
    public var revertTimeoutSecs: Int32? = nil
    public var timestamp: UInt64? = nil
    
    public init(conversationId: ClientConversationId? = nil, level: ClientNotificationLevel? = nil, revertTimeoutSecs: Int32? = nil, timestamp: UInt64? = nil) {
        self.conversationId = conversationId
        self.level = level
        self.revertTimeoutSecs = revertTimeoutSecs
        self.timestamp = timestamp
    }
}

public struct ClientSetConversationNotificationLevelResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case timestamp = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.responseHeader = responseHeader
        self.timestamp = timestamp
    }
}

public struct ClientSetConversationNotificationLevelRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case level = 3
        case revertTimeoutSecs = 4
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var level: ClientNotificationLevel? = nil
    public var revertTimeoutSecs: Int32? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, level: ClientNotificationLevel? = nil, revertTimeoutSecs: Int32? = nil) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.level = level
        self.revertTimeoutSecs = revertTimeoutSecs
    }
}

public struct ClientEvent_ClientUserEventState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case userId = 1
        case clientGeneratedId = 2
        case notificationLevel = 3
        case suggestions = 4
    }
    
    public var userId: ClientParticipantId? = nil
    public var clientGeneratedId: /*UInt64*/String? = nil
    public var notificationLevel: ClientNotificationLevel? = nil
    public var suggestions: ClientSuggestions? = nil
    
    public init(userId: ClientParticipantId? = nil, clientGeneratedId: /*UInt64*/String? = nil, notificationLevel: ClientNotificationLevel? = nil, suggestions: ClientSuggestions? = nil) {
        self.userId = userId
        self.clientGeneratedId = clientGeneratedId
        self.notificationLevel = notificationLevel
        self.suggestions = suggestions
    }
}

public struct ClientEvent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case senderId = 2
        case timestamp = 3
        case selfEventState = 4
        case sourceType = 6
        case chatMessage = 7
        case membershipChange = 9
        case conversationRename = 10
        case hangoutEvent = 11
        case eventId = 12
        case expirationTimestamp = 13
        case otrModification = 14
        case advancesSortTimestamp = 15
        case eventOtr = 16
        case persisted = 17
        case deliveryMedium = 20
        case eventType = 23
        case eventVersion = 24
        case lastObservedTimestamp = 27
        case observedStatus = 28
        case observedEvent = 29
        case groupLinkSharingModification = 31
    }
    
    public var conversationId: ClientConversationId? = nil
    public var senderId: ClientParticipantId? = nil
    public var timestamp: UInt64? = nil
    public var selfEventState: ClientEvent_ClientUserEventState? = nil
    public var sourceType: ClientSourceType? = nil
    public var chatMessage: ClientChatMessage? = nil
    public var membershipChange: ClientMembershipChange? = nil
    public var conversationRename: ClientConversationRename? = nil
    public var hangoutEvent: ClientHangoutEvent? = nil
    public var eventId: String? = nil
    public var expirationTimestamp: Int64? = nil
    public var otrModification: ClientOtrModification? = nil
    public var advancesSortTimestamp: Bool? = nil
    public var eventOtr: ClientOffTheRecordStatus? = nil
    public var persisted: Bool? = nil
    public var deliveryMedium: ClientDeliveryMedium? = nil
    public var eventType: ClientEventType? = nil
    public var eventVersion: UInt64? = nil
    public var lastObservedTimestamp: Int64? = nil
    public var observedStatus: ClientEventObservedStatus? = nil
    public var observedEvent: ClientObservedEvent? = nil
    public var groupLinkSharingModification: ClientGroupLinkSharingModification? = nil
    
    public init(conversationId: ClientConversationId? = nil, senderId: ClientParticipantId? = nil, timestamp: UInt64? = nil, selfEventState: ClientEvent_ClientUserEventState? = nil, sourceType: ClientSourceType? = nil, chatMessage: ClientChatMessage? = nil, membershipChange: ClientMembershipChange? = nil, conversationRename: ClientConversationRename? = nil, hangoutEvent: ClientHangoutEvent? = nil, eventId: String? = nil, expirationTimestamp: Int64? = nil, otrModification: ClientOtrModification? = nil, advancesSortTimestamp: Bool? = nil, eventOtr: ClientOffTheRecordStatus? = nil, persisted: Bool? = nil, deliveryMedium: ClientDeliveryMedium? = nil, eventType: ClientEventType? = nil, eventVersion: UInt64? = nil, lastObservedTimestamp: Int64? = nil, observedStatus: ClientEventObservedStatus? = nil, observedEvent: ClientObservedEvent? = nil, groupLinkSharingModification: ClientGroupLinkSharingModification? = nil) {
        self.conversationId = conversationId
        self.senderId = senderId
        self.timestamp = timestamp
        self.selfEventState = selfEventState
        self.sourceType = sourceType
        self.chatMessage = chatMessage
        self.membershipChange = membershipChange
        self.conversationRename = conversationRename
        self.hangoutEvent = hangoutEvent
        self.eventId = eventId
        self.expirationTimestamp = expirationTimestamp
        self.otrModification = otrModification
        self.advancesSortTimestamp = advancesSortTimestamp
        self.eventOtr = eventOtr
        self.persisted = persisted
        self.deliveryMedium = deliveryMedium
        self.eventType = eventType
        self.eventVersion = eventVersion
        self.lastObservedTimestamp = lastObservedTimestamp
        self.observedStatus = observedStatus
        self.observedEvent = observedEvent
        self.groupLinkSharingModification = groupLinkSharingModification
    }
}

public struct ClientObservedEvent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case observedEventId = 1
    }
    
    public var observedEventId: String? = nil
    
    public init(observedEventId: String? = nil) {
        self.observedEventId = observedEventId
    }
}

public struct ClientOtrModification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case oldOtrStatus = 1
        case newOtrStatus = 2
        case oldOtrToggle = 3
        case newOtrToggle = 4
    }
    
    public var oldOtrStatus: ClientOffTheRecordStatus? = nil
    public var newOtrStatus: ClientOffTheRecordStatus? = nil
    public var oldOtrToggle: ClientOffTheRecordToggle? = nil
    public var newOtrToggle: ClientOffTheRecordToggle? = nil
    
    public init(oldOtrStatus: ClientOffTheRecordStatus? = nil, newOtrStatus: ClientOffTheRecordStatus? = nil, oldOtrToggle: ClientOffTheRecordToggle? = nil, newOtrToggle: ClientOffTheRecordToggle? = nil) {
        self.oldOtrStatus = oldOtrStatus
        self.newOtrStatus = newOtrStatus
        self.oldOtrToggle = oldOtrToggle
        self.newOtrToggle = newOtrToggle
    }
}

public struct ClientModifyOtrStatusResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case deprecated2 = 2
        case deprecated3 = 3
        case createdEvent = 4
        case updatedConversation = 5
        case otrUnmodified = 6
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var deprecated2: UInt64? = nil
    public var deprecated3: String? = nil
    public var createdEvent: ClientEvent? = nil
    public var updatedConversation: ClientConversation? = nil
    public var otrUnmodified: Bool? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, deprecated2: UInt64? = nil, deprecated3: String? = nil, createdEvent: ClientEvent? = nil, updatedConversation: ClientConversation? = nil, otrUnmodified: Bool? = nil) {
        self.responseHeader = responseHeader
        self.deprecated2 = deprecated2
        self.deprecated3 = deprecated3
        self.createdEvent = createdEvent
        self.updatedConversation = updatedConversation
        self.otrUnmodified = otrUnmodified
    }
}

public struct ClientModifyOtrStatusRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2 = 2
        case otrStatus = 3
        case deprecated4 = 4
        case eventRequestHeader = 5
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2: String? = nil
    public var otrStatus: ClientOffTheRecordStatus? = nil
    public var deprecated4: UInt64? = nil
    public var eventRequestHeader: ClientEventRequestHeader? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2: String? = nil, otrStatus: ClientOffTheRecordStatus? = nil, deprecated4: UInt64? = nil, eventRequestHeader: ClientEventRequestHeader? = nil) {
        self.requestHeader = requestHeader
        self.deprecated2 = deprecated2
        self.otrStatus = otrStatus
        self.deprecated4 = deprecated4
        self.eventRequestHeader = eventRequestHeader
    }
}

public struct ClientGetConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case conversationState = 2
        case error = 3
        case deprecated4 = 4
        case richPresenceEnabledStateArray = 5
        case entityArray = 7
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var conversationState: ClientConversationState? = nil
    public var error: ClientGetConversationResponse_ClientGetConversationError? = nil
    public var deprecated4: ClientPresenceResult? = nil
    public var richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = []
    public var entityArray: [ClientEntity] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, conversationState: ClientConversationState? = nil, error: ClientGetConversationResponse_ClientGetConversationError? = nil, deprecated4: ClientPresenceResult? = nil, richPresenceEnabledStateArray: [ClientRichPresenceEnabledState] = [], entityArray: [ClientEntity] = []) {
        self.responseHeader = responseHeader
        self.conversationState = conversationState
        self.error = error
        self.deprecated4 = deprecated4
        self.richPresenceEnabledStateArray = richPresenceEnabledStateArray
        self.entityArray = entityArray
    }
}

public struct ClientGetConversationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationSpec = 2
        case includeConversationMetadata = 3
        case includeEvents = 4
        case maxEventsPerConversation = 6
        case eventContinuationToken = 7
        case deprecated8 = 8
        case forwardContinuationToken = 11
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationSpec: ClientConversationSpec? = nil
    public var includeConversationMetadata: Bool? = nil
    public var includeEvents: Bool? = nil
    public var maxEventsPerConversation: Int32? = nil
    public var eventContinuationToken: ClientEventContinuationToken? = nil
    public var deprecated8: Bool? = nil
    public var forwardContinuationToken: ClientEventContinuationToken? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationSpec: ClientConversationSpec? = nil, includeConversationMetadata: Bool? = nil, includeEvents: Bool? = nil, maxEventsPerConversation: Int32? = nil, eventContinuationToken: ClientEventContinuationToken? = nil, deprecated8: Bool? = nil, forwardContinuationToken: ClientEventContinuationToken? = nil) {
        self.requestHeader = requestHeader
        self.conversationSpec = conversationSpec
        self.includeConversationMetadata = includeConversationMetadata
        self.includeEvents = includeEvents
        self.maxEventsPerConversation = maxEventsPerConversation
        self.eventContinuationToken = eventContinuationToken
        self.deprecated8 = deprecated8
        self.forwardContinuationToken = forwardContinuationToken
    }
}

public struct ClientConversationSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case deprecated2Array = 2
        case inviteeIdArray = 3
        case requestedType = 4
        case eventId = 5
    }
    
    public var conversationId: ClientConversationId? = nil
    public var deprecated2Array: [String] = []
    public var inviteeIdArray: [ClientInviteeId] = []
    public var requestedType: ClientConversationType? = nil
    public var eventId: String? = nil
    
    public init(conversationId: ClientConversationId? = nil, deprecated2Array: [String] = [], inviteeIdArray: [ClientInviteeId] = [], requestedType: ClientConversationType? = nil, eventId: String? = nil) {
        self.conversationId = conversationId
        self.deprecated2Array = deprecated2Array
        self.inviteeIdArray = inviteeIdArray
        self.requestedType = requestedType
        self.eventId = eventId
    }
}

public struct ClientSyncAllNewEventsResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case syncTimestamp = 2
        case conversationStateArray = 3
        case conversationIdsOnly = 4
        case clearCacheAndResync = 6
        case entityArray = 7
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var syncTimestamp: UInt64? = nil
    public var conversationStateArray: [ClientConversationState] = []
    public var conversationIdsOnly: Bool? = nil
    public var clearCacheAndResync: Bool? = nil
    public var entityArray: [ClientEntity] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, syncTimestamp: UInt64? = nil, conversationStateArray: [ClientConversationState] = [], conversationIdsOnly: Bool? = nil, clearCacheAndResync: Bool? = nil, entityArray: [ClientEntity] = []) {
        self.responseHeader = responseHeader
        self.syncTimestamp = syncTimestamp
        self.conversationStateArray = conversationStateArray
        self.conversationIdsOnly = conversationIdsOnly
        self.clearCacheAndResync = clearCacheAndResync
        self.entityArray = entityArray
    }
}

public struct ClientSyncAllNewEventsRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case lastSyncTimestamp = 2
        case localStateArray = 3
        case deprecated4 = 4
        case deprecated5Array = 5
        case noMissedEventsExpected = 6
        case unreadStateArray = 7
        case maxResponseSizeBytes = 8
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var lastSyncTimestamp: UInt64? = nil
    public var localStateArray: [ClientLocalConversationState] = []
    public var deprecated4: Int32? = nil
    public var deprecated5Array: [String] = []
    public var noMissedEventsExpected: Bool? = nil
    public var unreadStateArray: [ClientUnreadConversationState] = []
    public var maxResponseSizeBytes: Int32? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, lastSyncTimestamp: UInt64? = nil, localStateArray: [ClientLocalConversationState] = [], deprecated4: Int32? = nil, deprecated5Array: [String] = [], noMissedEventsExpected: Bool? = nil, unreadStateArray: [ClientUnreadConversationState] = [], maxResponseSizeBytes: Int32? = nil) {
        self.requestHeader = requestHeader
        self.lastSyncTimestamp = lastSyncTimestamp
        self.localStateArray = localStateArray
        self.deprecated4 = deprecated4
        self.deprecated5Array = deprecated5Array
        self.noMissedEventsExpected = noMissedEventsExpected
        self.unreadStateArray = unreadStateArray
        self.maxResponseSizeBytes = maxResponseSizeBytes
    }
}

public struct ClientUnreadConversationState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case latestReadTimestamp = 2
    }
    
    public var conversationId: ClientConversationId? = nil
    public var latestReadTimestamp: UInt64? = nil
    
    public init(conversationId: ClientConversationId? = nil, latestReadTimestamp: UInt64? = nil) {
        self.conversationId = conversationId
        self.latestReadTimestamp = latestReadTimestamp
    }
}

public struct ClientLocalConversationState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 2
        case recentEventIdArray = 4
    }
    
    public var conversationId: ClientConversationId? = nil
    public var recentEventIdArray: [String] = []
    
    public init(conversationId: ClientConversationId? = nil, recentEventIdArray: [String] = []) {
        self.conversationId = conversationId
        self.recentEventIdArray = recentEventIdArray
    }
}

public struct ClientSyncRecentConversationsResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case syncTimestamp = 2
        case conversationStateArray = 3
        case continuationEndTimestamp = 4
        case entityArray = 6
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var syncTimestamp: UInt64? = nil
    public var conversationStateArray: [ClientConversationState] = []
    public var continuationEndTimestamp: UInt64? = nil
    public var entityArray: [ClientEntity] = []
    
    public init(responseHeader: ClientResponseHeader? = nil, syncTimestamp: UInt64? = nil, conversationStateArray: [ClientConversationState] = [], continuationEndTimestamp: UInt64? = nil, entityArray: [ClientEntity] = []) {
        self.responseHeader = responseHeader
        self.syncTimestamp = syncTimestamp
        self.conversationStateArray = conversationStateArray
        self.continuationEndTimestamp = continuationEndTimestamp
        self.entityArray = entityArray
    }
}

public struct ClientConversationState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case conversation = 2
        case eventArray = 3
        case mustQuerySeparately = 4
        case eventContinuationToken = 5
        case leaveTimestamp = 6
        case deleteActionArray = 7
        case forwardContinuationToken = 8
    }
    
    public var conversationId: ClientConversationId? = nil
    public var conversation: ClientConversation? = nil
    public var eventArray: [ClientEvent] = []
    public var mustQuerySeparately: Bool? = nil
    public var eventContinuationToken: ClientEventContinuationToken? = nil
    public var leaveTimestamp: UInt64? = nil
    public var deleteActionArray: [ClientDeleteAction] = []
    public var forwardContinuationToken: ClientEventContinuationToken? = nil
    
    public init(conversationId: ClientConversationId? = nil, conversation: ClientConversation? = nil, eventArray: [ClientEvent] = [], mustQuerySeparately: Bool? = nil, eventContinuationToken: ClientEventContinuationToken? = nil, leaveTimestamp: UInt64? = nil, deleteActionArray: [ClientDeleteAction] = [], forwardContinuationToken: ClientEventContinuationToken? = nil) {
        self.conversationId = conversationId
        self.conversation = conversation
        self.eventArray = eventArray
        self.mustQuerySeparately = mustQuerySeparately
        self.eventContinuationToken = eventContinuationToken
        self.leaveTimestamp = leaveTimestamp
        self.deleteActionArray = deleteActionArray
        self.forwardContinuationToken = forwardContinuationToken
    }
}

public struct ClientEventContinuationToken: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case deprecated1 = 1
        case storageContinuationToken = 2
        case eventTimestamp = 3
    }
    
    public var deprecated1: String? = nil
    public var storageContinuationToken: String? = nil
    public var eventTimestamp: UInt64? = nil
    
    public init(deprecated1: String? = nil, storageContinuationToken: String? = nil, eventTimestamp: UInt64? = nil) {
        self.deprecated1 = deprecated1
        self.storageContinuationToken = storageContinuationToken
        self.eventTimestamp = eventTimestamp
    }
}

public struct ClientSyncRecentConversationsRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case endTimestamp = 2
        case maxConversations = 3
        case maxEventsPerConversation = 4
        case syncFilterArray = 5
        case includeEmptyActiveConversations = 7
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var endTimestamp: Int64? = nil
    public var maxConversations: Int32? = nil
    public var maxEventsPerConversation: Int32? = nil
    public var syncFilterArray: [ClientSyncFilter] = []
    public var includeEmptyActiveConversations: Bool? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, endTimestamp: Int64? = nil, maxConversations: Int32? = nil, maxEventsPerConversation: Int32? = nil, syncFilterArray: [ClientSyncFilter] = [], includeEmptyActiveConversations: Bool? = nil) {
        self.requestHeader = requestHeader
        self.endTimestamp = endTimestamp
        self.maxConversations = maxConversations
        self.maxEventsPerConversation = maxEventsPerConversation
        self.syncFilterArray = syncFilterArray
        self.includeEmptyActiveConversations = includeEmptyActiveConversations
    }
}

public struct ClientSetTypingNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case senderId = 2
        case timestamp = 3
        case type = 4
    }
    
    public var conversationId: ClientConversationId? = nil
    public var senderId: ClientParticipantId? = nil
    public var timestamp: UInt64? = nil
    public var type: ClientTypingType? = nil
    
    public init(conversationId: ClientConversationId? = nil, senderId: ClientParticipantId? = nil, timestamp: UInt64? = nil, type: ClientTypingType? = nil) {
        self.conversationId = conversationId
        self.senderId = senderId
        self.timestamp = timestamp
        self.type = type
    }
}

public struct ClientSetTypingResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case timestamp = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.responseHeader = responseHeader
        self.timestamp = timestamp
    }
}

public struct ClientSetTypingRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case type = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var type: ClientTypingType? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, type: ClientTypingType? = nil) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.type = type
    }
}

public struct ClientRecordAnalyticsEventsResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil) {
        self.responseHeader = responseHeader
    }
}

public struct ClientRecordAnalyticsEventsRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case analyticsEventArray = 2
        case localTimestamp = 4
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var analyticsEventArray: [ClientAnalyticsEvent] = []
    public var localTimestamp: UInt64? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, analyticsEventArray: [ClientAnalyticsEvent] = [], localTimestamp: UInt64? = nil) {
        self.requestHeader = requestHeader
        self.analyticsEventArray = analyticsEventArray
        self.localTimestamp = localTimestamp
    }
}

public struct ClientAnalyticsEvent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case eventType = 1
        case rpcGlobalId = 2
        case eventDetail = 3
        case notified = 4
        case wasNewest = 5
        case pastWatermark = 6
        case userDnd = 7
        case inFocusedConversation = 8
        case activeClientState = 9
        case notificationLevel = 10
        case deviceTimestampReceived = 11
        case eventId = 12
        case clientGeneratedId = 13
        case chatAction = 14
        case retryCount = 15
    }
    
    public var eventType: ClientAnalyticsEvent_EventType? = nil
    public var rpcGlobalId: Int64? = nil
    public var eventDetail: String? = nil
    public var notified: Bool? = nil
    public var wasNewest: Bool? = nil
    public var pastWatermark: Bool? = nil
    public var userDnd: Bool? = nil
    public var inFocusedConversation: Bool? = nil
    public var activeClientState: ActiveClientState? = nil
    public var notificationLevel: ClientNotificationLevel? = nil
    public var deviceTimestampReceived: UInt64? = nil
    public var eventId: String? = nil
    public var clientGeneratedId: UInt64? = nil
    public var chatAction: ClientAnalyticsEvent_ChatAction? = nil
    public var retryCount: Int32? = nil
    
    public init(eventType: ClientAnalyticsEvent_EventType? = nil, rpcGlobalId: Int64? = nil, eventDetail: String? = nil, notified: Bool? = nil, wasNewest: Bool? = nil, pastWatermark: Bool? = nil, userDnd: Bool? = nil, inFocusedConversation: Bool? = nil, activeClientState: ActiveClientState? = nil, notificationLevel: ClientNotificationLevel? = nil, deviceTimestampReceived: UInt64? = nil, eventId: String? = nil, clientGeneratedId: UInt64? = nil, chatAction: ClientAnalyticsEvent_ChatAction? = nil, retryCount: Int32? = nil) {
        self.eventType = eventType
        self.rpcGlobalId = rpcGlobalId
        self.eventDetail = eventDetail
        self.notified = notified
        self.wasNewest = wasNewest
        self.pastWatermark = pastWatermark
        self.userDnd = userDnd
        self.inFocusedConversation = inFocusedConversation
        self.activeClientState = activeClientState
        self.notificationLevel = notificationLevel
        self.deviceTimestampReceived = deviceTimestampReceived
        self.eventId = eventId
        self.clientGeneratedId = clientGeneratedId
        self.chatAction = chatAction
        self.retryCount = retryCount
    }
}

public struct ClientEasterEggNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case senderId = 1
        case conversationId = 2
        case easterEgg = 3
    }
    
    public var senderId: ClientParticipantId? = nil
    public var conversationId: ClientConversationId? = nil
    public var easterEgg: ClientEasterEgg? = nil
    
    public init(senderId: ClientParticipantId? = nil, conversationId: ClientConversationId? = nil, easterEgg: ClientEasterEgg? = nil) {
        self.senderId = senderId
        self.conversationId = conversationId
        self.easterEgg = easterEgg
    }
}

public struct ClientEasterEggResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case timestamp = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.responseHeader = responseHeader
        self.timestamp = timestamp
    }
}

public struct ClientEasterEggRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case easterEgg = 3
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var easterEgg: ClientEasterEgg? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, easterEgg: ClientEasterEgg? = nil) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.easterEgg = easterEgg
    }
}

public struct ClientEasterEgg: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case message = 1
        case payload = 2
    }
    
    public var message: String? = nil
    public var payload: String? = nil
    
    public init(message: String? = nil, payload: String? = nil) {
        self.message = message
        self.payload = payload
    }
}

public struct ClientSetFocusNotification: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case senderId = 2
        case timestamp = 3
        case type = 4
        case timeoutSecs = 5
    }
    
    public var conversationId: ClientConversationId? = nil
    public var senderId: ClientParticipantId? = nil
    public var timestamp: UInt64? = nil
    public var type: ClientFocusType? = nil
    public var timeoutSecs: UInt32? = nil
    
    public init(conversationId: ClientConversationId? = nil, senderId: ClientParticipantId? = nil, timestamp: UInt64? = nil, type: ClientFocusType? = nil, timeoutSecs: UInt32? = nil) {
        self.conversationId = conversationId
        self.senderId = senderId
        self.timestamp = timestamp
        self.type = type
        self.timeoutSecs = timeoutSecs
    }
}

public struct ClientSetFocusResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case timestamp = 2
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var timestamp: UInt64? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, timestamp: UInt64? = nil) {
        self.responseHeader = responseHeader
        self.timestamp = timestamp
    }
}

public struct ClientSetFocusRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case conversationId = 2
        case type = 3
        case timeoutSecs = 4
        case queryFocus = 6
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var conversationId: ClientConversationId? = nil
    public var type: ClientFocusType? = nil
    public var timeoutSecs: UInt32? = nil
    public var queryFocus: Bool? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, conversationId: ClientConversationId? = nil, type: ClientFocusType? = nil, timeoutSecs: UInt32? = nil, queryFocus: Bool? = nil) {
        self.requestHeader = requestHeader
        self.conversationId = conversationId
        self.type = type
        self.timeoutSecs = timeoutSecs
        self.queryFocus = queryFocus
    }
}

public struct ClientHangoutEvent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case eventType = 1
        case participantIdArray = 2
        case hangoutDurationSecs = 3
        case transferredConversationId = 4
        case refreshTimeoutSecs = 5
        case isPeriodicRefresh = 6
        case mediaType = 7
    }
    
    public var eventType: ClientHangoutEventType? = nil
    public var participantIdArray: [ClientParticipantId] = []
    public var hangoutDurationSecs: Int64? = nil
    public var transferredConversationId: ClientConversationId? = nil
    public var refreshTimeoutSecs: Int64? = nil
    public var isPeriodicRefresh: Bool? = nil
    public var mediaType: ClientHangoutMediaType? = nil
    
    public init(eventType: ClientHangoutEventType? = nil, participantIdArray: [ClientParticipantId] = [], hangoutDurationSecs: Int64? = nil, transferredConversationId: ClientConversationId? = nil, refreshTimeoutSecs: Int64? = nil, isPeriodicRefresh: Bool? = nil, mediaType: ClientHangoutMediaType? = nil) {
        self.eventType = eventType
        self.participantIdArray = participantIdArray
        self.hangoutDurationSecs = hangoutDurationSecs
        self.transferredConversationId = transferredConversationId
        self.refreshTimeoutSecs = refreshTimeoutSecs
        self.isPeriodicRefresh = isPeriodicRefresh
        self.mediaType = mediaType
    }
}

public struct ClientConversationRename: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case newName = 1
        case oldName = 2
    }
    
    public var newName: String? = nil
    public var oldName: String? = nil
    
    public init(newName: String? = nil, oldName: String? = nil) {
        self.newName = newName
        self.oldName = oldName
    }
}

public struct ClientRenameConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case deprecated2 = 2
        case deprecated3 = 3
        case createdEvent = 4
        case updatedConversation = 5
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var deprecated2: UInt64? = nil
    public var deprecated3: String? = nil
    public var createdEvent: ClientEvent? = nil
    public var updatedConversation: ClientConversation? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, deprecated2: UInt64? = nil, deprecated3: String? = nil, createdEvent: ClientEvent? = nil, updatedConversation: ClientConversation? = nil) {
        self.responseHeader = responseHeader
        self.deprecated2 = deprecated2
        self.deprecated3 = deprecated3
        self.createdEvent = createdEvent
        self.updatedConversation = updatedConversation
    }
}

public struct ClientRenameConversationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2 = 2
        case newName = 3
        case deprecated4 = 4
        case eventRequestHeader = 5
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2: String? = nil
    public var newName: String? = nil
    public var deprecated4: UInt64? = nil
    public var eventRequestHeader: ClientEventRequestHeader? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2: String? = nil, newName: String? = nil, deprecated4: UInt64? = nil, eventRequestHeader: ClientEventRequestHeader? = nil) {
        self.requestHeader = requestHeader
        self.deprecated2 = deprecated2
        self.newName = newName
        self.deprecated4 = deprecated4
        self.eventRequestHeader = eventRequestHeader
    }
}

public struct ClientRemoveUserResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case deprecated2 = 2
        case deprecated3 = 3
        case createdEvent = 4
        case updatedConversation = 5
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var deprecated2: UInt64? = nil
    public var deprecated3: String? = nil
    public var createdEvent: ClientEvent? = nil
    public var updatedConversation: ClientConversation? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, deprecated2: UInt64? = nil, deprecated3: String? = nil, createdEvent: ClientEvent? = nil, updatedConversation: ClientConversation? = nil) {
        self.responseHeader = responseHeader
        self.deprecated2 = deprecated2
        self.deprecated3 = deprecated3
        self.createdEvent = createdEvent
        self.updatedConversation = updatedConversation
    }
}

public struct ClientRemoveUserRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2 = 2
        case participantId = 3
        case deprecated4 = 4
        case eventRequestHeader = 5
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2: String? = nil
    public var participantId: ClientParticipantId? = nil
    public var deprecated4: UInt64? = nil
    public var eventRequestHeader: ClientEventRequestHeader? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2: String? = nil, participantId: ClientParticipantId? = nil, deprecated4: UInt64? = nil, eventRequestHeader: ClientEventRequestHeader? = nil) {
        self.requestHeader = requestHeader
        self.deprecated2 = deprecated2
        self.participantId = participantId
        self.deprecated4 = deprecated4
        self.eventRequestHeader = eventRequestHeader
    }
}

public struct ClientMembershipChange: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case type = 1
        case deprecated2Array = 2
        case participantIdArray = 3
        case leaveReason = 4
    }
    
    public var type: ClientMembershipChangeType? = nil
    public var deprecated2Array: [String] = []
    public var participantIdArray: [ClientParticipantId] = []
    public var leaveReason: ClientLeaveReason? = nil
    
    public init(type: ClientMembershipChangeType? = nil, deprecated2Array: [String] = [], participantIdArray: [ClientParticipantId] = [], leaveReason: ClientLeaveReason? = nil) {
        self.type = type
        self.deprecated2Array = deprecated2Array
        self.participantIdArray = participantIdArray
        self.leaveReason = leaveReason
    }
}

public struct ClientAddUserResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case inviteeErrorArray = 2
        case deprecated3 = 3
        case deprecated4 = 4
        case createdEvent = 5
        case updatedConversation = 6
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var inviteeErrorArray: [ClientInviteeError] = []
    public var deprecated3: UInt64? = nil
    public var deprecated4: String? = nil
    public var createdEvent: ClientEvent? = nil
    public var updatedConversation: ClientConversation? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, inviteeErrorArray: [ClientInviteeError] = [], deprecated3: UInt64? = nil, deprecated4: String? = nil, createdEvent: ClientEvent? = nil, updatedConversation: ClientConversation? = nil) {
        self.responseHeader = responseHeader
        self.inviteeErrorArray = inviteeErrorArray
        self.deprecated3 = deprecated3
        self.deprecated4 = deprecated4
        self.createdEvent = createdEvent
        self.updatedConversation = updatedConversation
    }
}

public struct ClientAddUserRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2 = 2
        case inviteeIdArray = 3
        case deprecated4 = 4
        case eventRequestHeader = 5
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2: String? = nil
    public var inviteeIdArray: [ClientInviteeId] = []
    public var deprecated4: UInt64? = nil
    public var eventRequestHeader: ClientEventRequestHeader? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2: String? = nil, inviteeIdArray: [ClientInviteeId] = [], deprecated4: UInt64? = nil, eventRequestHeader: ClientEventRequestHeader? = nil) {
        self.requestHeader = requestHeader
        self.deprecated2 = deprecated2
        self.inviteeIdArray = inviteeIdArray
        self.deprecated4 = deprecated4
        self.eventRequestHeader = eventRequestHeader
    }
}

public struct ClientChatMessage: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case messageContent = 3
    }
    
    public var messageContent: ClientMessageContent? = nil
    
    public init(messageContent: ClientMessageContent? = nil) {
        self.messageContent = messageContent
    }
}

public struct ClientSendChatMessageResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case deprecated2 = 2
        case deprecated3 = 3
        case mediaUploadInfoArray = 4
        case deprecated5 = 5
        case createdEvent = 6
        case updatedConversation = 7
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var deprecated2: UInt64? = nil
    public var deprecated3: String? = nil
    public var mediaUploadInfoArray: [ClientMediaUploadInfo] = []
    public var deprecated5: String? = nil
    public var createdEvent: ClientEvent? = nil
    public var updatedConversation: ClientConversation? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, deprecated2: UInt64? = nil, deprecated3: String? = nil, mediaUploadInfoArray: [ClientMediaUploadInfo] = [], deprecated5: String? = nil, createdEvent: ClientEvent? = nil, updatedConversation: ClientConversation? = nil) {
        self.responseHeader = responseHeader
        self.deprecated2 = deprecated2
        self.deprecated3 = deprecated3
        self.mediaUploadInfoArray = mediaUploadInfoArray
        self.deprecated5 = deprecated5
        self.createdEvent = createdEvent
        self.updatedConversation = updatedConversation
    }
}

public struct ClientSendChatMessageRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case deprecated2 = 2
        case deprecated3 = 3
        case messageContent = 6
        case existingMedia = 7
        case eventRequestHeader = 8
        case otherInviteeId = 9
        case attachLocation = 10
        case externalImageSpec = 11
        case chatMessageSpecArray = 12
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var deprecated2: String? = nil
    public var deprecated3: UInt64? = nil
    public var messageContent: ClientMessageContent? = nil
    public var existingMedia: ClientExistingMedia? = nil
    public var eventRequestHeader: ClientEventRequestHeader? = nil
    public var otherInviteeId: ClientInviteeId? = nil
    public var attachLocation: ClientLocationSpec? = nil
    public var externalImageSpec: ClientExternalImageSpec? = nil
    public var chatMessageSpecArray: [ClientChatMessageSpec] = []
    
    public init(requestHeader: ClientRequestHeader? = nil, deprecated2: String? = nil, deprecated3: UInt64? = nil, messageContent: ClientMessageContent? = nil, existingMedia: ClientExistingMedia? = nil, eventRequestHeader: ClientEventRequestHeader? = nil, otherInviteeId: ClientInviteeId? = nil, attachLocation: ClientLocationSpec? = nil, externalImageSpec: ClientExternalImageSpec? = nil, chatMessageSpecArray: [ClientChatMessageSpec] = []) {
        self.requestHeader = requestHeader
        self.deprecated2 = deprecated2
        self.deprecated3 = deprecated3
        self.messageContent = messageContent
        self.existingMedia = existingMedia
        self.eventRequestHeader = eventRequestHeader
        self.otherInviteeId = otherInviteeId
        self.attachLocation = attachLocation
        self.externalImageSpec = externalImageSpec
        self.chatMessageSpecArray = chatMessageSpecArray
    }
}

public struct ClientChatMessageSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case segmentArray = 1
        case attachLocation = 3
        case externalImageSpec = 4
    }
    
    public var segmentArray: [SocialSegment] = []
    public var attachLocation: ClientLocationSpec? = nil
    public var externalImageSpec: ClientExternalImageSpec? = nil
    
    public init(segmentArray: [SocialSegment] = [], attachLocation: ClientLocationSpec? = nil, externalImageSpec: ClientExternalImageSpec? = nil) {
        self.segmentArray = segmentArray
        self.attachLocation = attachLocation
        self.externalImageSpec = externalImageSpec
    }
}

public struct ClientExternalImageSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case imageURL = 1
        case width = 2
        case height = 3
        case containingWebpageURL = 4
        case containingWebpageTitle = 5
        case description = 6
    }
    
    public var imageURL: String? = nil
    public var width: Int32? = nil
    public var height: Int32? = nil
    public var containingWebpageURL: String? = nil
    public var containingWebpageTitle: String? = nil
    public var description: String? = nil
    
    public init(imageURL: String? = nil, width: Int32? = nil, height: Int32? = nil, containingWebpageURL: String? = nil, containingWebpageTitle: String? = nil, description: String? = nil) {
        self.imageURL = imageURL
        self.width = width
        self.height = height
        self.containingWebpageURL = containingWebpageURL
        self.containingWebpageTitle = containingWebpageTitle
        self.description = description
    }
}

public struct ClientLocationSpec: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case place = 1
        case deprecated2 = 2
    }
    
    public var place: EMPlaceV2? = nil
    public var deprecated2: String? = nil
    
    public init(place: EMPlaceV2? = nil, deprecated2: String? = nil) {
        self.place = place
        self.deprecated2 = deprecated2
    }
}

public struct ClientConversation_ClientUserConversationState_ClientDeliveryMediumOption: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case deliveryMedium = 1
        case currentDefault = 2
        case primary = 3
    }
    
    public var deliveryMedium: ClientDeliveryMedium? = nil
    public var currentDefault: Bool? = nil
    public var primary: Bool? = nil
    
    public init(deliveryMedium: ClientDeliveryMedium? = nil, currentDefault: Bool? = nil, primary: Bool? = nil) {
        self.deliveryMedium = deliveryMedium
        self.currentDefault = currentDefault
        self.primary = primary
    }
}

public struct ClientConversation_ClientUserConversationState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case clientGeneratedId = 2
        case selfReadState = 7
        case status = 8
        case notificationLevel = 9
        case viewArray = 10
        case inviterId = 11
        case inviteTimestamp = 12
        case sortTimestamp = 13
        case activeTimestamp = 14
        case inviteAffinity = 15
        case hasNoPersistentEvents = 16
        case deliveryMediumOptionArray = 17
        case isGuest = 21
    }
    
    public var clientGeneratedId: UInt64? = nil
    public var selfReadState: ClientUserReadState? = nil
    public var status: ClientConversationStatus? = nil
    public var notificationLevel: ClientNotificationLevel? = nil
    public var viewArray: [ClientConversationView] = []
    public var inviterId: ClientParticipantId? = nil
    public var inviteTimestamp: UInt64? = nil
    public var sortTimestamp: UInt64? = nil
    public var activeTimestamp: UInt64? = nil
    public var inviteAffinity: ClientConversation_ClientUserConversationState_InvitationAffinity? = nil
    public var hasNoPersistentEvents: Bool? = nil
    public var deliveryMediumOptionArray: [ClientConversation_ClientUserConversationState_ClientDeliveryMediumOption] = []
    public var isGuest: Bool? = nil
    
    public init(clientGeneratedId: UInt64? = nil, selfReadState: ClientUserReadState? = nil, status: ClientConversationStatus? = nil, notificationLevel: ClientNotificationLevel? = nil, viewArray: [ClientConversationView] = [], inviterId: ClientParticipantId? = nil, inviteTimestamp: UInt64? = nil, sortTimestamp: UInt64? = nil, activeTimestamp: UInt64? = nil, inviteAffinity: ClientConversation_ClientUserConversationState_InvitationAffinity? = nil, hasNoPersistentEvents: Bool? = nil, deliveryMediumOptionArray: [ClientConversation_ClientUserConversationState_ClientDeliveryMediumOption] = [], isGuest: Bool? = nil) {
        self.clientGeneratedId = clientGeneratedId
        self.selfReadState = selfReadState
        self.status = status
        self.notificationLevel = notificationLevel
        self.viewArray = viewArray
        self.inviterId = inviterId
        self.inviteTimestamp = inviteTimestamp
        self.sortTimestamp = sortTimestamp
        self.activeTimestamp = activeTimestamp
        self.inviteAffinity = inviteAffinity
        self.hasNoPersistentEvents = hasNoPersistentEvents
        self.deliveryMediumOptionArray = deliveryMediumOptionArray
        self.isGuest = isGuest
    }
}

public struct ClientConversation: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 1
        case type = 2
        case name = 3
        case selfConversationState = 4
        case deprecated5Array = 5
        case deprecated6Array = 6
        case readStateArray = 8
        case hasActiveHangout = 9
        case otrStatus = 10
        case otrToggle = 11
        case deprecated12 = 12
        case currentParticipantArray = 13
        case participantDataArray = 14
        case isTemporary = 15
        case forkOnExternalInvite = 16
        case networkTypeArray = 18
        case forceHistoryState = 19
        case conversationAvatarMediaKey = 20
        case groupLinkSharingStatus = 22
    }
    
    public var id: ClientConversationId? = nil
    public var type: ClientConversationType? = nil
    public var name: String? = nil
    public var selfConversationState: ClientConversation_ClientUserConversationState? = nil
    public var deprecated5Array: [String] = []
    public var deprecated6Array: [String] = []
    public var readStateArray: [ClientUserReadState] = []
    public var hasActiveHangout: Bool? = nil
    public var otrStatus: ClientOffTheRecordStatus? = nil
    public var otrToggle: ClientOffTheRecordToggle? = nil
    public var deprecated12: Bool? = nil
    public var currentParticipantArray: [ClientParticipantId] = []
    public var participantDataArray: [ClientConversationParticipantData] = []
    public var isTemporary: Bool? = nil
    public var forkOnExternalInvite: Bool? = nil
    public var networkTypeArray: [ClientConversation_ClientNetworkType] = []
    public var forceHistoryState: ClientForceHistoryState? = nil
    public var conversationAvatarMediaKey: String? = nil
    public var groupLinkSharingStatus: ClientGroupLinkSharingStatus? = nil
    
    public init(id: ClientConversationId? = nil, type: ClientConversationType? = nil, name: String? = nil, selfConversationState: ClientConversation_ClientUserConversationState? = nil, deprecated5Array: [String] = [], deprecated6Array: [String] = [], readStateArray: [ClientUserReadState] = [], hasActiveHangout: Bool? = nil, otrStatus: ClientOffTheRecordStatus? = nil, otrToggle: ClientOffTheRecordToggle? = nil, deprecated12: Bool? = nil, currentParticipantArray: [ClientParticipantId] = [], participantDataArray: [ClientConversationParticipantData] = [], isTemporary: Bool? = nil, forkOnExternalInvite: Bool? = nil, networkTypeArray: [ClientConversation_ClientNetworkType] = [], forceHistoryState: ClientForceHistoryState? = nil, conversationAvatarMediaKey: String? = nil, groupLinkSharingStatus: ClientGroupLinkSharingStatus? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.selfConversationState = selfConversationState
        self.deprecated5Array = deprecated5Array
        self.deprecated6Array = deprecated6Array
        self.readStateArray = readStateArray
        self.hasActiveHangout = hasActiveHangout
        self.otrStatus = otrStatus
        self.otrToggle = otrToggle
        self.deprecated12 = deprecated12
        self.currentParticipantArray = currentParticipantArray
        self.participantDataArray = participantDataArray
        self.isTemporary = isTemporary
        self.forkOnExternalInvite = forkOnExternalInvite
        self.networkTypeArray = networkTypeArray
        self.forceHistoryState = forceHistoryState
        self.conversationAvatarMediaKey = conversationAvatarMediaKey
        self.groupLinkSharingStatus = groupLinkSharingStatus
    }
}

public struct ClientUserReadState: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case participantId = 1
        case latestReadTimestamp = 2
    }
    
    public var participantId: ClientParticipantId? = nil
    public var latestReadTimestamp: UInt64? = nil
    
    public init(participantId: ClientParticipantId? = nil, latestReadTimestamp: UInt64? = nil) {
        self.participantId = participantId
        self.latestReadTimestamp = latestReadTimestamp
    }
}

public struct ClientCreateConversationResponse: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case responseHeader = 1
        case conversation = 2
        case inviteeErrorArray = 3
        case deprecated4 = 4
        case deprecated5 = 5
        case deprecated6Array = 6
        case newConversationCreated = 7
    }
    
    public var responseHeader: ClientResponseHeader? = nil
    public var conversation: ClientConversation? = nil
    public var inviteeErrorArray: [ClientInviteeError] = []
    public var deprecated4: UInt64? = nil
    public var deprecated5: String? = nil
    public var deprecated6Array: [String] = []
    public var newConversationCreated: Bool? = nil
    
    public init(responseHeader: ClientResponseHeader? = nil, conversation: ClientConversation? = nil, inviteeErrorArray: [ClientInviteeError] = [], deprecated4: UInt64? = nil, deprecated5: String? = nil, deprecated6Array: [String] = [], newConversationCreated: Bool? = nil) {
        self.responseHeader = responseHeader
        self.conversation = conversation
        self.inviteeErrorArray = inviteeErrorArray
        self.deprecated4 = deprecated4
        self.deprecated5 = deprecated5
        self.deprecated6Array = deprecated6Array
        self.newConversationCreated = newConversationCreated
    }
}

public struct ClientCreateConversationRequest: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case requestHeader = 1
        case type = 2
        case clientGeneratedId = 3
        case name = 4
        case inviteeIdArray = 5
        case deliveryMedium = 11
        case inviteToken = 12
        case conversationAvatarMediaKey = 14
    }
    
    public var requestHeader: ClientRequestHeader? = nil
    public var type: ClientConversationType? = nil
    public var clientGeneratedId: UInt64? = nil
    public var name: String? = nil
    public var inviteeIdArray: [ClientInviteeId] = []
    public var deliveryMedium: ClientDeliveryMedium? = nil
    public var inviteToken: ClientInviteToken? = nil
    public var conversationAvatarMediaKey: String? = nil
    
    public init(requestHeader: ClientRequestHeader? = nil, type: ClientConversationType? = nil, clientGeneratedId: UInt64? = nil, name: String? = nil, inviteeIdArray: [ClientInviteeId] = [], deliveryMedium: ClientDeliveryMedium? = nil, inviteToken: ClientInviteToken? = nil, conversationAvatarMediaKey: String? = nil) {
        self.requestHeader = requestHeader
        self.type = type
        self.clientGeneratedId = clientGeneratedId
        self.name = name
        self.inviteeIdArray = inviteeIdArray
        self.deliveryMedium = deliveryMedium
        self.inviteToken = inviteToken
        self.conversationAvatarMediaKey = conversationAvatarMediaKey
    }
}

public struct ClientExistingMedia_Photo: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case photoId = 1
        case deleteAlbumlessSourcePhoto = 2
        case ownerGaiaId = 3
        case referenceOriginalPhoto = 4
    }
    
    public var photoId: String? = nil
    public var deleteAlbumlessSourcePhoto: Bool? = nil
    public var ownerGaiaId: String? = nil
    public var referenceOriginalPhoto: Bool? = nil
    
    public init(photoId: String? = nil, deleteAlbumlessSourcePhoto: Bool? = nil, ownerGaiaId: String? = nil, referenceOriginalPhoto: Bool? = nil) {
        self.photoId = photoId
        self.deleteAlbumlessSourcePhoto = deleteAlbumlessSourcePhoto
        self.ownerGaiaId = ownerGaiaId
        self.referenceOriginalPhoto = referenceOriginalPhoto
    }
}

public struct ClientExistingMedia: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case photo = 1
    }
    
    public var photo: ClientExistingMedia_Photo? = nil
    
    public init(photo: ClientExistingMedia_Photo? = nil) {
        self.photo = photo
    }
}

public struct ClientMediaUploadInfo: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case attachment = 1
    }
    
    public var attachment: Attachment? = nil
    
    public init(attachment: Attachment? = nil) {
        self.attachment = attachment
    }
}

public struct ClientMessageContent: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case segmentArray = 1
        case attachmentArray = 2
    }
    
    public var segmentArray: [SocialSegment] = []
    public var attachmentArray: [Attachment] = []
    
    public init(segmentArray: [SocialSegment] = [], attachmentArray: [Attachment] = []) {
        self.segmentArray = segmentArray
        self.attachmentArray = attachmentArray
    }
}

public struct ClientDeliveryMedium: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case mediumType = 1
        case selfPhone = 2
    }
    
    public var mediumType: ClientDeliveryMediumType? = nil
    public var selfPhone: GCVPhoneNumber? = nil
    
    public init(mediumType: ClientDeliveryMediumType? = nil, selfPhone: GCVPhoneNumber? = nil) {
        self.mediumType = mediumType
        self.selfPhone = selfPhone
    }
}

public struct ClientInviteeError: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case inviteeId = 1
        case deprecated2 = 2
        case deprecated3 = 3
        case deprecated4 = 4
        case errorDescription = 5
        case detail = 6
    }
    
    public var inviteeId: ClientInviteeId? = nil
    public var deprecated2: String? = nil
    public var deprecated3: String? = nil
    public var deprecated4: String? = nil
    public var errorDescription: String? = nil
    public var detail: ClientInviteeError_ClientInviteeErrorDetail? = nil
    
    public init(inviteeId: ClientInviteeId? = nil, deprecated2: String? = nil, deprecated3: String? = nil, deprecated4: String? = nil, errorDescription: String? = nil, detail: ClientInviteeError_ClientInviteeErrorDetail? = nil) {
        self.inviteeId = inviteeId
        self.deprecated2 = deprecated2
        self.deprecated3 = deprecated3
        self.deprecated4 = deprecated4
        self.errorDescription = errorDescription
        self.detail = detail
    }
}

public struct ClientConversationParticipantData: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 1
        case fallbackName = 2
        case invitationStatus = 3
        case phoneNumber = 4
        case participantType = 5
        case newInvitationStatus = 6
        case isAnonymousPhone = 7
    }
    
    public var id: ClientParticipantId? = nil
    public var fallbackName: String? = nil
    public var invitationStatus: ClientInvitationStatus? = nil
    public var phoneNumber: GCVPhoneNumber? = nil
    public var participantType: ClientUserType? = nil
    public var newInvitationStatus: ClientInvitationStatus? = nil
    public var isAnonymousPhone: Bool? = nil
    
    public init(id: ClientParticipantId? = nil, fallbackName: String? = nil, invitationStatus: ClientInvitationStatus? = nil, phoneNumber: GCVPhoneNumber? = nil, participantType: ClientUserType? = nil, newInvitationStatus: ClientInvitationStatus? = nil, isAnonymousPhone: Bool? = nil) {
        self.id = id
        self.fallbackName = fallbackName
        self.invitationStatus = invitationStatus
        self.phoneNumber = phoneNumber
        self.participantType = participantType
        self.newInvitationStatus = newInvitationStatus
        self.isAnonymousPhone = isAnonymousPhone
    }
}

public struct ClientConversationId: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case id = 1
    }
    
    public var id: String? = nil
    
    public init(id: String? = nil) {
        self.id = id
    }
}

public struct ClientParticipantId: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case gaiaId = 1
        case chatId = 2
    }
    
    public var gaiaId: String? = nil
    public var chatId: String? = nil
    
    public init(gaiaId: String? = nil, chatId: String? = nil) {
        self.gaiaId = gaiaId
        self.chatId = chatId
    }
}

public struct ClientInviteeId_ClientLookupMethod_ClientEmailLookup: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case email = 1
    }
    
    public var email: String? = nil
    
    public init(email: String? = nil) {
        self.email = email
    }
}

public struct ClientInviteeId_ClientLookupMethod_ClientPhoneLookup: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case phoneNumber = 1
    }
    
    public var phoneNumber: GCVPhoneNumber? = nil
    
    public init(phoneNumber: GCVPhoneNumber? = nil) {
        self.phoneNumber = phoneNumber
    }
}

public struct ClientInviteeId_ClientLookupMethod: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case phoneLookup = 1
        case emailLookup = 2
    }
    
    public var phoneLookup: ClientInviteeId_ClientLookupMethod_ClientPhoneLookup? = nil
    public var emailLookup: ClientInviteeId_ClientLookupMethod_ClientEmailLookup? = nil
    
    public init(phoneLookup: ClientInviteeId_ClientLookupMethod_ClientPhoneLookup? = nil, emailLookup: ClientInviteeId_ClientLookupMethod_ClientEmailLookup? = nil) {
        self.phoneLookup = phoneLookup
        self.emailLookup = emailLookup
    }
}

public struct ClientInviteeId: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case gaiaId = 1
        case circleId = 2
        case chatId = 3
        case fallbackName = 4
        case deprecated5 = 5
        case lookupMethodArray = 6
        case phone = 7
    }
    
    public var gaiaId: String? = nil
    public var circleId: String? = nil
    public var chatId: String? = nil
    public var fallbackName: String? = nil
    public var deprecated5: String? = nil
    public var lookupMethodArray: [ClientInviteeId_ClientLookupMethod] = []
    public var phone: GCVPhoneNumber? = nil
    
    public init(gaiaId: String? = nil, circleId: String? = nil, chatId: String? = nil, fallbackName: String? = nil, deprecated5: String? = nil, lookupMethodArray: [ClientInviteeId_ClientLookupMethod] = [], phone: GCVPhoneNumber? = nil) {
        self.gaiaId = gaiaId
        self.circleId = circleId
        self.chatId = chatId
        self.fallbackName = fallbackName
        self.deprecated5 = deprecated5
        self.lookupMethodArray = lookupMethodArray
        self.phone = phone
    }
}

public struct ClientResponseHeader: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case status = 1
        case errorDescription = 2
        case debugURL = 3
        case requestTraceId = 4
        case currentServerTime = 5
        case backoffDurationMillis = 6
        case clientGeneratedRequestId = 7
        case localizedUserVisibleErrorMessage = 8
        case buildLabel = 10
        case changelistNumber = 11
    }
    
    public var status: ClientResponseStatus? = nil
    public var errorDescription: String? = nil
    public var debugURL: String? = nil
    public var requestTraceId: /*UInt64*/String? = nil
    public var currentServerTime: UInt64? = nil
    public var backoffDurationMillis: UInt64? = nil
    public var clientGeneratedRequestId: String? = nil
    public var localizedUserVisibleErrorMessage: String? = nil
    public var buildLabel: String? = nil
    public var changelistNumber: Int32? = nil
    
    public init(status: ClientResponseStatus? = nil, errorDescription: String? = nil, debugURL: String? = nil, requestTraceId: /*UInt64*/String? = nil, currentServerTime: UInt64? = nil, backoffDurationMillis: UInt64? = nil, clientGeneratedRequestId: String? = nil, localizedUserVisibleErrorMessage: String? = nil, buildLabel: String? = nil, changelistNumber: Int32? = nil) {
        self.status = status
        self.errorDescription = errorDescription
        self.debugURL = debugURL
        self.requestTraceId = requestTraceId
        self.currentServerTime = currentServerTime
        self.backoffDurationMillis = backoffDurationMillis
        self.clientGeneratedRequestId = clientGeneratedRequestId
        self.localizedUserVisibleErrorMessage = localizedUserVisibleErrorMessage
        self.buildLabel = buildLabel
        self.changelistNumber = changelistNumber
    }
}

public struct ClientEventRequestHeader: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case conversationId = 1
        case clientGeneratedId = 2
        case expectedOtr = 3
        case deliveryMedium = 4
        case eventType = 5
    }
    
    public var conversationId: ClientConversationId? = nil
    public var clientGeneratedId: UInt64? = nil
    public var expectedOtr: ClientOffTheRecordStatus? = nil
    public var deliveryMedium: ClientDeliveryMedium? = nil
    public var eventType: ClientEventType? = nil
    
    public init(conversationId: ClientConversationId? = nil, clientGeneratedId: UInt64? = nil, expectedOtr: ClientOffTheRecordStatus? = nil, deliveryMedium: ClientDeliveryMedium? = nil, eventType: ClientEventType? = nil) {
        self.conversationId = conversationId
        self.clientGeneratedId = clientGeneratedId
        self.expectedOtr = expectedOtr
        self.deliveryMedium = deliveryMedium
        self.eventType = eventType
    }
}

public struct ClientRequestHeader: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case clientVersion = 1
        case clientIdentifier = 2
        case clientInstrumentationInfo = 3
        case languageCode = 4
        case includeUpdatedConversation = 5
        case retryAttempt = 6
        case rtcClient = 7
        case clientGeneratedRequestId = 8
    }
    
    public var clientVersion: ClientClientVersion? = nil
    public var clientIdentifier: ClientClientIdentifier? = nil
    public var clientInstrumentationInfo: ClientClientInstrumentationInfo? = nil
    public var languageCode: String? = nil
    public var includeUpdatedConversation: Bool? = nil
    public var retryAttempt: UInt32? = nil
    public var rtcClient: String? = nil
    public var clientGeneratedRequestId: String? = nil
    
    public init(clientVersion: ClientClientVersion? = nil, clientIdentifier: ClientClientIdentifier? = nil, clientInstrumentationInfo: ClientClientInstrumentationInfo? = nil, languageCode: String? = nil, includeUpdatedConversation: Bool? = nil, retryAttempt: UInt32? = nil, rtcClient: String? = nil, clientGeneratedRequestId: String? = nil) {
        self.clientVersion = clientVersion
        self.clientIdentifier = clientIdentifier
        self.clientInstrumentationInfo = clientInstrumentationInfo
        self.languageCode = languageCode
        self.includeUpdatedConversation = includeUpdatedConversation
        self.retryAttempt = retryAttempt
        self.rtcClient = rtcClient
        self.clientGeneratedRequestId = clientGeneratedRequestId
    }
}

public struct ClientClientInstrumentationInfo: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case chatMessageSequenceNumber = 1
    }
    
    public var chatMessageSequenceNumber: Int64? = nil
    
    public init(chatMessageSequenceNumber: Int64? = nil) {
        self.chatMessageSequenceNumber = chatMessageSequenceNumber
    }
}

public struct ClientClientIdentifier: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case resource = 1
        case clientId = 2
        case selfFanoutId = 3
        case participantLogId = 4
    }
    
    public var resource: String? = nil
    public var clientId: String? = nil
    public var selfFanoutId: String? = nil
    public var participantLogId: String? = nil
    
    public init(resource: String? = nil, clientId: String? = nil, selfFanoutId: String? = nil, participantLogId: String? = nil) {
        self.resource = resource
        self.clientId = clientId
        self.selfFanoutId = selfFanoutId
        self.participantLogId = participantLogId
    }
}

public struct ClientClientVersion: ProtoMessage {
    public enum CodingKeys: Int, CodingKey {
        case clientId = 1
        case buildType = 2
        case majorVersion = 3
        case version = 4
        case deviceOsVersion = 5
        case deviceHardware = 6
    }
    
    public var clientId: ClientClientVersion_ClientId? = nil
    public var buildType: ClientClientVersion_ClientBuildType? = nil
    public var majorVersion: String? = nil
    public var version: Int64? = nil
    public var deviceOsVersion: String? = nil
    public var deviceHardware: String? = nil
    
    public init(clientId: ClientClientVersion_ClientId? = nil, buildType: ClientClientVersion_ClientBuildType? = nil, majorVersion: String? = nil, version: Int64? = nil, deviceOsVersion: String? = nil, deviceHardware: String? = nil) {
        self.clientId = clientId
        self.buildType = buildType
        self.majorVersion = majorVersion
        self.version = version
        self.deviceOsVersion = deviceOsVersion
        self.deviceHardware = deviceHardware
    }
}
