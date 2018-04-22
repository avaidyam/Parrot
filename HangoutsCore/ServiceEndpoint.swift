extension ClientAddUserResponse: ServiceResponse {}
extension ClientAddUserRequest: ServiceRequest {
    public typealias Response = ClientAddUserResponse
    public static let location: String = "conversations/adduser"
}

extension ClientCreateConversationResponse: ServiceResponse {}
extension ClientCreateConversationRequest: ServiceRequest {
    public typealias Response = ClientCreateConversationResponse
    public static let location: String = "conversations/createconversation"
}

extension ClientDeleteConversationResponse: ServiceResponse {}
extension ClientDeleteConversationRequest: ServiceRequest {
    public typealias Response = ClientDeleteConversationResponse
    public static let location: String = "conversations/deleteconversation"
}

extension ClientEasterEggResponse: ServiceResponse {}
extension ClientEasterEggRequest: ServiceRequest {
    public typealias Response = ClientEasterEggResponse
    public static let location: String = "conversations/easteregg"
}

extension ClientGetConversationResponse: ServiceResponse {}
extension ClientGetConversationRequest: ServiceRequest {
    public typealias Response = ClientGetConversationResponse
    public static let location: String = "conversations/getconversation"
}

extension ClientGetEntityByIdResponse: ServiceResponse {}
extension ClientGetEntityByIdRequest: ServiceRequest {
    public typealias Response = ClientGetEntityByIdResponse
    public static let location: String = "contacts/getentitybyid"
}

extension ClientGetSuggestedEntitiesResponse: ServiceResponse {}
extension ClientGetSuggestedEntitiesRequest: ServiceRequest {
    public typealias Response = ClientGetSuggestedEntitiesResponse
    public static let location: String = "contacts/getsuggestedentities"
}

extension ClientQueryPresenceResponse: ServiceResponse {}
extension ClientQueryPresenceRequest: ServiceRequest {
    public typealias Response = ClientQueryPresenceResponse
    public static let location: String = "presence/querypresence"
}

extension ClientRemoveUserResponse: ServiceResponse {}
extension ClientRemoveUserRequest: ServiceRequest {
    public typealias Response = ClientRemoveUserResponse
    public static let location: String = "conversations/removeuser"
}

extension ClientRenameConversationResponse: ServiceResponse {}
extension ClientRenameConversationRequest: ServiceRequest {
    public typealias Response = ClientRenameConversationResponse
    public static let location: String = "conversations/renameconversation"
}

extension ClientSearchEntitiesResponse: ServiceResponse {}
extension ClientSearchEntitiesRequest: ServiceRequest {
    public typealias Response = ClientSearchEntitiesResponse
    public static let location: String = "contacts/searchentities"
}

extension ClientSendChatMessageResponse: ServiceResponse {}
extension ClientSendChatMessageRequest: ServiceRequest {
    public typealias Response = ClientSendChatMessageResponse
    public static let location: String = "conversations/sendchatmessage"
}

extension ClientSetActiveClientResponse: ServiceResponse {}
extension ClientSetActiveClientRequest: ServiceRequest {
    public typealias Response = ClientSetActiveClientResponse
    public static let location: String = "clients/setactiveclient"
}

extension ClientSetConversationNotificationLevelResponse: ServiceResponse {}
extension ClientSetConversationNotificationLevelRequest: ServiceRequest {
    public typealias Response = ClientSetConversationNotificationLevelResponse
    public static let location: String = "conversations/setconversationnotificationlevel"
}

extension ClientSetFocusResponse: ServiceResponse {}
extension ClientSetFocusRequest: ServiceRequest {
    public typealias Response = ClientSetFocusResponse
    public static let location: String = "conversations/setfocus"
}

extension ClientGetSelfInfoResponse: ServiceResponse {}
extension ClientGetSelfInfoRequest: ServiceRequest {
    public typealias Response = ClientGetSelfInfoResponse
    public static let location: String = "contacts/getselfinfo"
}

extension ClientSetPresenceResponse: ServiceResponse {}
extension ClientSetPresenceRequest: ServiceRequest {
    public typealias Response = ClientSetPresenceResponse
    public static let location: String = "presence/setpresence"
}

extension ClientSetTypingResponse: ServiceResponse {}
extension ClientSetTypingRequest: ServiceRequest {
    public typealias Response = ClientSetTypingResponse
    public static let location: String = "conversations/settyping"
}

extension ClientSyncAllNewEventsResponse: ServiceResponse {}
extension ClientSyncAllNewEventsRequest: ServiceRequest {
    public typealias Response = ClientSyncAllNewEventsResponse
    public static let location: String = "conversations/syncallnewevents"
}

extension ClientSyncRecentConversationsResponse: ServiceResponse {}
extension ClientSyncRecentConversationsRequest: ServiceRequest {
    public typealias Response = ClientSyncRecentConversationsResponse
    public static let location: String = "conversations/syncrecentconversations"
}

extension ClientUpdateWatermarkResponse: ServiceResponse {}
extension ClientUpdateWatermarkRequest: ServiceRequest {
    public typealias Response = ClientUpdateWatermarkResponse
    public static let location: String = "conversations/updatewatermark"
}

extension ClientGetGroupConversationUrlResponse: ServiceResponse {}
extension ClientGetGroupConversationUrlRequest: ServiceRequest {
    public typealias Response = ClientGetGroupConversationUrlResponse
    public static let location: String = "conversations/getgroupconversationurl"
}

extension ClientModifyConversationViewResponse: ServiceResponse {}
extension ClientModifyConversationViewRequest: ServiceRequest {
    public typealias Response = ClientModifyConversationViewResponse
    public static let location: String = "conversations/modifyconversationview"
}

extension ClientOpenGroupConversationFromUrlResponse: ServiceResponse {}
extension ClientOpenGroupConversationFromUrlRequest: ServiceRequest {
    public typealias Response = ClientOpenGroupConversationFromUrlResponse
    public static let location: String = "conversations/opengroupconversationfromurl"
}

extension ClientSendOffnetworkInvitationResponse: ServiceResponse {}
extension ClientSendOffnetworkInvitationRequest: ServiceRequest {
    public typealias Response = ClientSendOffnetworkInvitationResponse
    public static let location: String = "devices/sendoffnetworkinvitation"
}

extension ClientModifyOtrStatusResponse: ServiceResponse {}
extension ClientModifyOtrStatusRequest: ServiceRequest {
    public typealias Response = ClientModifyOtrStatusResponse
    public static let location: String = "conversations/modifyotrstatus"
}

/*
extension ClientSetConversationLevelResponse: ServiceResponse {}
extension ClientSetConversationLevelRequest: ServiceRequest {
    public typealias Response = ClientSetConversationLevelResponse
    public static let location: String = "conversations/setconversationlevel"
}
*/

extension ClientSetGroupLinkSharingEnabledResponse: ServiceResponse {}
extension ClientSetGroupLinkSharingEnabledRequest: ServiceRequest {
    public typealias Response = ClientSetGroupLinkSharingEnabledResponse
    public static let location: String = "conversations/setgrouplinksharingenabled"
}
