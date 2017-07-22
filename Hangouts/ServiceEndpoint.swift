extension AddUserResponse: ServiceResponse {}
extension AddUserRequest: ServiceRequest {
    typealias Response = AddUserResponse
    static let location: String = "conversations/adduser"
}

extension CreateConversationResponse: ServiceResponse {}
extension CreateConversationRequest: ServiceRequest {
    typealias Response = CreateConversationResponse
    static let location: String = "conversations/createconversation"
}

extension DeleteConversationResponse: ServiceResponse {}
extension DeleteConversationRequest: ServiceRequest {
    typealias Response = DeleteConversationResponse
    static let location: String = "conversations/deleteconversation"
}

extension EasterEggResponse: ServiceResponse {}
extension EasterEggRequest: ServiceRequest {
    typealias Response = EasterEggResponse
    static let location: String = "conversations/easteregg"
}

extension GetConversationResponse: ServiceResponse {}
extension GetConversationRequest: ServiceRequest {
    typealias Response = GetConversationResponse
    static let location: String = "conversations/getconversation"
}

extension GetEntityByIdResponse: ServiceResponse {}
extension GetEntityByIdRequest: ServiceRequest {
    typealias Response = GetEntityByIdResponse
    static let location: String = "contacts/getentitybyid"
}

extension GetSuggestedEntitiesResponse: ServiceResponse {}
extension GetSuggestedEntitiesRequest: ServiceRequest {
    typealias Response = GetSuggestedEntitiesResponse
    static let location: String = "contacts/getsuggestedentities"
}

extension QueryPresenceResponse: ServiceResponse {}
extension QueryPresenceRequest: ServiceRequest {
    typealias Response = QueryPresenceResponse
    static let location: String = "presence/querypresence"
}

extension RemoveUserResponse: ServiceResponse {}
extension RemoveUserRequest: ServiceRequest {
    typealias Response = RemoveUserResponse
    static let location: String = "conversations/removeuser"
}

extension RenameConversationResponse: ServiceResponse {}
extension RenameConversationRequest: ServiceRequest {
    typealias Response = RenameConversationResponse
    static let location: String = "conversations/renameconversation"
}

extension SearchEntitiesResponse: ServiceResponse {}
extension SearchEntitiesRequest: ServiceRequest {
    typealias Response = SearchEntitiesResponse
    static let location: String = "contacts/searchentities"
}

extension SendChatMessageResponse: ServiceResponse {}
extension SendChatMessageRequest: ServiceRequest {
    typealias Response = SendChatMessageResponse
    static let location: String = "conversations/sendchatmessage"
}

extension SetActiveClientResponse: ServiceResponse {}
extension SetActiveClientRequest: ServiceRequest {
    typealias Response = SetActiveClientResponse
    static let location: String = "clients/setactiveclient"
}

extension SetConversationNotificationLevelResponse: ServiceResponse {}
extension SetConversationNotificationLevelRequest: ServiceRequest {
    typealias Response = SetConversationNotificationLevelResponse
    static let location: String = "conversations/setconversationnotificationlevel"
}

extension SetFocusResponse: ServiceResponse {}
extension SetFocusRequest: ServiceRequest {
    typealias Response = SetFocusResponse
    static let location: String = "conversations/setfocus"
}

extension GetSelfInfoResponse: ServiceResponse {}
extension GetSelfInfoRequest: ServiceRequest {
    typealias Response = GetSelfInfoResponse
    static let location: String = "contacts/getselfinfo"
}

extension SetPresenceResponse: ServiceResponse {}
extension SetPresenceRequest: ServiceRequest {
    typealias Response = SetPresenceResponse
    static let location: String = "presence/setpresence"
}

extension SetTypingResponse: ServiceResponse {}
extension SetTypingRequest: ServiceRequest {
    typealias Response = SetTypingResponse
    static let location: String = "conversations/settyping"
}

extension SyncAllNewEventsResponse: ServiceResponse {}
extension SyncAllNewEventsRequest: ServiceRequest {
    typealias Response = SyncAllNewEventsResponse
    static let location: String = "conversations/syncallnewevents"
}

extension SyncRecentConversationsResponse: ServiceResponse {}
extension SyncRecentConversationsRequest: ServiceRequest {
    typealias Response = SyncRecentConversationsResponse
    static let location: String = "conversations/syncrecentconversations"
}

extension UpdateWatermarkResponse: ServiceResponse {}
extension UpdateWatermarkRequest: ServiceRequest {
    typealias Response = UpdateWatermarkResponse
    static let location: String = "conversations/updatewatermark"
}

extension GetGroupConversationUrlResponse: ServiceResponse {}
extension GetGroupConversationUrlRequest: ServiceRequest {
    typealias Response = GetGroupConversationUrlResponse
    static let location: String = "conversations/getgroupconversationurl"
}

extension ModifyConversationViewResponse: ServiceResponse {}
extension ModifyConversationViewRequest: ServiceRequest {
    typealias Response = ModifyConversationViewResponse
    static let location: String = "conversations/modifyconversationview"
}

extension OpenGroupConversationFromUrlResponse: ServiceResponse {}
extension OpenGroupConversationFromUrlRequest: ServiceRequest {
    typealias Response = OpenGroupConversationFromUrlResponse
    static let location: String = "conversations/opengroupconversationfromurl"
}

extension SendOffnetworkInvitationResponse: ServiceResponse {}
extension SendOffnetworkInvitationRequest: ServiceRequest {
    typealias Response = SendOffnetworkInvitationResponse
    static let location: String = "devices/sendoffnetworkinvitation"
}

extension ModifyOTRStatusResponse: ServiceResponse {}
extension ModifyOTRStatusRequest: ServiceRequest {
    typealias Response = ModifyOTRStatusResponse
    static let location: String = "conversations/modifyotrstatus"
}

extension SetConversationLevelResponse: ServiceResponse {}
extension SetConversationLevelRequest: ServiceRequest {
    typealias Response = SetConversationLevelResponse
    static let location: String = "conversations/setconversationlevel"
}

extension SetGroupLinkSharingEnabledResponse: ServiceResponse {}
extension SetGroupLinkSharingEnabledRequest: ServiceRequest {
    typealias Response = SetGroupLinkSharingEnabledResponse
    static let location: String = "conversations/setgrouplinksharingenabled"
}
