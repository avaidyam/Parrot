extension ClientAddUserResponse: ServiceResponse {}
extension ClientAddUserRequest: ServiceRequest {
    typealias Response = ClientAddUserResponse
    static let location: String = "conversations/adduser"
}

extension ClientCreateConversationResponse: ServiceResponse {}
extension ClientCreateConversationRequest: ServiceRequest {
    typealias Response = ClientCreateConversationResponse
    static let location: String = "conversations/createconversation"
}

extension ClientDeleteConversationResponse: ServiceResponse {}
extension ClientDeleteConversationRequest: ServiceRequest {
    typealias Response = ClientDeleteConversationResponse
    static let location: String = "conversations/deleteconversation"
}

extension ClientEasterEggResponse: ServiceResponse {}
extension ClientEasterEggRequest: ServiceRequest {
    typealias Response = ClientEasterEggResponse
    static let location: String = "conversations/easteregg"
}

extension ClientGetConversationResponse: ServiceResponse {}
extension ClientGetConversationRequest: ServiceRequest {
    typealias Response = ClientGetConversationResponse
    static let location: String = "conversations/getconversation"
}

extension ClientGetEntityByIdResponse: ServiceResponse {}
extension ClientGetEntityByIdRequest: ServiceRequest {
    typealias Response = ClientGetEntityByIdResponse
    static let location: String = "contacts/getentitybyid"
}

extension ClientGetSuggestedEntitiesResponse: ServiceResponse {}
extension ClientGetSuggestedEntitiesRequest: ServiceRequest {
    typealias Response = ClientGetSuggestedEntitiesResponse
    static let location: String = "contacts/getsuggestedentities"
}

extension ClientQueryPresenceResponse: ServiceResponse {}
extension ClientQueryPresenceRequest: ServiceRequest {
    typealias Response = ClientQueryPresenceResponse
    static let location: String = "presence/querypresence"
}

extension ClientRemoveUserResponse: ServiceResponse {}
extension ClientRemoveUserRequest: ServiceRequest {
    typealias Response = ClientRemoveUserResponse
    static let location: String = "conversations/removeuser"
}

extension ClientRenameConversationResponse: ServiceResponse {}
extension ClientRenameConversationRequest: ServiceRequest {
    typealias Response = ClientRenameConversationResponse
    static let location: String = "conversations/renameconversation"
}

extension ClientSearchEntitiesResponse: ServiceResponse {}
extension ClientSearchEntitiesRequest: ServiceRequest {
    typealias Response = ClientSearchEntitiesResponse
    static let location: String = "contacts/searchentities"
}

extension ClientSendChatMessageResponse: ServiceResponse {}
extension ClientSendChatMessageRequest: ServiceRequest {
    typealias Response = ClientSendChatMessageResponse
    static let location: String = "conversations/sendchatmessage"
}

extension ClientSetActiveClientResponse: ServiceResponse {}
extension ClientSetActiveClientRequest: ServiceRequest {
    typealias Response = ClientSetActiveClientResponse
    static let location: String = "clients/setactiveclient"
}

extension ClientSetConversationNotificationLevelResponse: ServiceResponse {}
extension ClientSetConversationNotificationLevelRequest: ServiceRequest {
    typealias Response = ClientSetConversationNotificationLevelResponse
    static let location: String = "conversations/setconversationnotificationlevel"
}

extension ClientSetFocusResponse: ServiceResponse {}
extension ClientSetFocusRequest: ServiceRequest {
    typealias Response = ClientSetFocusResponse
    static let location: String = "conversations/setfocus"
}

extension ClientGetSelfInfoResponse: ServiceResponse {}
extension ClientGetSelfInfoRequest: ServiceRequest {
    typealias Response = ClientGetSelfInfoResponse
    static let location: String = "contacts/getselfinfo"
}

extension ClientSetPresenceResponse: ServiceResponse {}
extension ClientSetPresenceRequest: ServiceRequest {
    typealias Response = ClientSetPresenceResponse
    static let location: String = "presence/setpresence"
}

extension ClientSetTypingResponse: ServiceResponse {}
extension ClientSetTypingRequest: ServiceRequest {
    typealias Response = ClientSetTypingResponse
    static let location: String = "conversations/settyping"
}

extension ClientSyncAllNewEventsResponse: ServiceResponse {}
extension ClientSyncAllNewEventsRequest: ServiceRequest {
    typealias Response = ClientSyncAllNewEventsResponse
    static let location: String = "conversations/syncallnewevents"
}

extension ClientSyncRecentConversationsResponse: ServiceResponse {}
extension ClientSyncRecentConversationsRequest: ServiceRequest {
    typealias Response = ClientSyncRecentConversationsResponse
    static let location: String = "conversations/syncrecentconversations"
}

extension ClientUpdateWatermarkResponse: ServiceResponse {}
extension ClientUpdateWatermarkRequest: ServiceRequest {
    typealias Response = ClientUpdateWatermarkResponse
    static let location: String = "conversations/updatewatermark"
}

extension ClientGetGroupConversationUrlResponse: ServiceResponse {}
extension ClientGetGroupConversationUrlRequest: ServiceRequest {
    typealias Response = ClientGetGroupConversationUrlResponse
    static let location: String = "conversations/getgroupconversationurl"
}

extension ClientModifyConversationViewResponse: ServiceResponse {}
extension ClientModifyConversationViewRequest: ServiceRequest {
    typealias Response = ClientModifyConversationViewResponse
    static let location: String = "conversations/modifyconversationview"
}

extension ClientOpenGroupConversationFromUrlResponse: ServiceResponse {}
extension ClientOpenGroupConversationFromUrlRequest: ServiceRequest {
    typealias Response = ClientOpenGroupConversationFromUrlResponse
    static let location: String = "conversations/opengroupconversationfromurl"
}

extension ClientSendOffnetworkInvitationResponse: ServiceResponse {}
extension ClientSendOffnetworkInvitationRequest: ServiceRequest {
    typealias Response = ClientSendOffnetworkInvitationResponse
    static let location: String = "devices/sendoffnetworkinvitation"
}

extension ClientModifyOtrStatusResponse: ServiceResponse {}
extension ClientModifyOtrStatusRequest: ServiceRequest {
    typealias Response = ClientModifyOtrStatusResponse
    static let location: String = "conversations/modifyotrstatus"
}

/*
extension ClientSetConversationLevelResponse: ServiceResponse {}
extension ClientSetConversationLevelRequest: ServiceRequest {
    typealias Response = ClientSetConversationLevelResponse
    static let location: String = "conversations/setconversationlevel"
}
*/

extension ClientSetGroupLinkSharingEnabledResponse: ServiceResponse {}
extension ClientSetGroupLinkSharingEnabledRequest: ServiceRequest {
    typealias Response = ClientSetGroupLinkSharingEnabledResponse
    static let location: String = "conversations/setgrouplinksharingenabled"
}
