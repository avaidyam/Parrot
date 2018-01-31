import Foundation

public struct PeopleAPI {
    private init() {}
    
    private static let baseURL = "https://people-pa.clients6.google.com/v2/people"
    private static let groupsURL = "https://hangoutssearch-pa.clients6.google.com/v1"
    private static let APIKey = "AIzaSyBokvzEPUrkgfws0OrFWkpKkVBVuhRfKpk"
    
    public static func suggestions(on channel: Channel, completionHandler: @escaping (Data?, Error?) -> ()) {
        self._post(channel, PeopleAPI.baseURL + "/me/allPeople", [
            "requestMask.includeField.paths": "person.email",
            "requestMask.includeField.paths": "person.gender",
            "requestMask.includeField.paths": "person.in_app_reachability",
            "requestMask.includeField.paths": "person.metadata",
            "requestMask.includeField.paths": "person.name",
            "requestMask.includeField.paths": "person.phone",
            "requestMask.includeField.paths": "person.photo",
            "requestMask.includeField.paths": "person.read_only_profile_info",
            "extensionSet.extensionNames": "HANGOUTS_ADDITIONAL_DATA",
            "extensionSet.extensionNames": "HANGOUTS_SUGGESTED_PEOPLE",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "key": PeopleAPI.APIKey
        ], nil, completionHandler)
    }
    
    public static func phoneSuggestions(on channel: Channel, completionHandler: @escaping (Data?, Error?) -> ()) {
        self._post(channel, PeopleAPI.baseURL + "/me/allPeople", [
            "requestMask.includeField.paths": "person.email",
            "requestMask.includeField.paths": "person.gender",
            "requestMask.includeField.paths": "person.in_app_reachability",
            "requestMask.includeField.paths": "person.metadata",
            "requestMask.includeField.paths": "person.name",
            "requestMask.includeField.paths": "person.phone",
            "requestMask.includeField.paths": "person.photo",
            "requestMask.includeField.paths": "person.read_only_profile_info",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "fieldFilter.field": "PHONE",
            "key": PeopleAPI.APIKey
        ], nil, completionHandler)
    }
    
    public static func list(on channel: Channel, ids: [String], completionHandler: @escaping (Data?, Error?) -> ()) {
        guard ids.count > 0 else { return }
        self._post(channel, PeopleAPI.baseURL + "", [
            "requestMask.includeField.paths": "person.email",
            "requestMask.includeField.paths": "person.gender",
            "requestMask.includeField.paths": "person.in_app_reachability",
            "requestMask.includeField.paths": "person.metadata",
            "requestMask.includeField.paths": "person.name",
            "requestMask.includeField.paths": "person.phone",
            "requestMask.includeField.paths": "person.photo",
            "requestMask.includeField.paths": "person.read_only_profile_info",
            "requestMask.includeField.paths": "person.organization", // extra
            "requestMask.includeField.paths": "person.location", // extra
            "requestMask.includeField.paths": "person.cover_photo", // extra
            "extensionSet.extensionNames": "HANGOUTS_ADDITIONAL_DATA",
            "extensionSet.extensionNames": "HANGOUTS_OFF_NETWORK_GAIA_GET",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "includedProfileStates": "ADMIN_BLOCKED",
            "includedProfileStates": "DELETED",
            "includedProfileStates": "PRIVATE_PROFILE",
            "mergedPersonSourceOptions.includeAffinity": "CHAT_AUTOCOMPLETE",
            "coreIdParams.useRealtimeNotificationExpandedAcls": "true",
            "key": PeopleAPI.APIKey
        ], ids.map { "personId=" + $0 }.joined(separator: "&"), completionHandler)
    }
    
    public static func lookup(on channel: Channel, phones: [String], completionHandler: @escaping (Data?, Error?) -> ()) {
        guard phones.count > 0 else { return }
        self._post(channel, PeopleAPI.baseURL + "/lookup", [
            "type": "PHONE",
            "matchType": "LENIENT",
            "requestMask.includeField.paths": "person.email",
            "requestMask.includeField.paths": "person.gender",
            "requestMask.includeField.paths": "person.in_app_reachability",
            "requestMask.includeField.paths": "person.metadata",
            "requestMask.includeField.paths": "person.name",
            "requestMask.includeField.paths": "person.phone",
            "requestMask.includeField.paths": "person.photo",
            "requestMask.includeField.paths": "person.read_only_profile_info",
            "extensionSet.extensionNames": "HANGOUTS_ADDITIONAL_DATA",
            "extensionSet.extensionNames": "HANGOUTS_OFF_NETWORK_GAIA_LOOKUP",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "coreIdParams.useRealtimeNotificationExpandedAcls": "true",
            "quotaFilterType": "PHONE",
            "key": PeopleAPI.APIKey
        ], phones.map { "id=" + $0 }.joined(separator: "&"), completionHandler)
    }
    
    public static func lookup(on channel: Channel, emails: [String], completionHandler: @escaping (Data?, Error?) -> ()) {
        guard emails.count > 0 else { return }
        self._post(channel, PeopleAPI.baseURL + "/lookup", [
            "type": "EMAIL",
            "matchType": "EXACT",
            "requestMask.includeField.paths": "person.email",
            "requestMask.includeField.paths": "person.gender",
            "requestMask.includeField.paths": "person.in_app_reachability",
            "requestMask.includeField.paths": "person.metadata",
            "requestMask.includeField.paths": "person.name",
            "requestMask.includeField.paths": "person.phone",
            "requestMask.includeField.paths": "person.photo",
            "requestMask.includeField.paths": "person.read_only_profile_info",
            "extensionSet.extensionNames": "HANGOUTS_ADDITIONAL_DATA",
            "extensionSet.extensionNames": "HANGOUTS_OFF_NETWORK_GAIA_LOOKUP",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "coreIdParams.useRealtimeNotificationExpandedAcls": "true",
            "key": PeopleAPI.APIKey
        ], emails.map { "id=" + $0 }.joined(separator: "&"), completionHandler)
    }
    
    public static func autocomplete(on channel: Channel, query: String, length: UInt = 15,
                                    completionHandler: @escaping (Data?, Error?) -> ())
    {
        self._post(channel, PeopleAPI.baseURL + "/autocomplete", [
            "query": query,
            "client": "HANGOUTS_WITH_DATA",
            "pageSize": "\(length)",
            "key": PeopleAPI.APIKey
        ], nil, completionHandler)
    }
    
    public static func autocompleteGroups(on channel: Channel, query: String, length: UInt = 15, meta: Bool = true,
                                          completionHandler: @escaping (Data?, Error?) -> ())
    {
        self._post(channel, PeopleAPI.groupsURL + "/metadata:search", [
            "query": query,
            "pageSize": "\(length)",
            "includeMetadata": "\(meta)",
            "key": PeopleAPI.APIKey,
            "alt": "json"
        ], nil, completionHandler)
    }
    
    // Note: DictionaryLiteral accepts duplicate keys and preserves order.
    // Note: `prefix` is a silly hack for multiple `id`'s which are dynamic and cannot be in a literal.
    private static func _post(_ channel: Channel, _ api: String, _ params: DictionaryLiteral<String, String>,
                              _ prefix: String? = nil, _ completionHandler: @escaping (Data?, Error?) -> ())
    {
        var merge = params.map { "\($0)=\($1)" }.joined(separator: "&")
        if let prefix2 = prefix {
            merge = prefix2 + "&" + merge
        }
        merge = merge.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            .replacingOccurrences(of: "+", with: "%2B") // since + is somehow allowed???
        
        var request = URLRequest(url: URL(string: api)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = merge.data(using: .utf8)
        for (k, v) in Channel.getAuthorizationHeaders(channel.cachedSAPISID,
                                                      origin: "https://hangouts.google.com",
                                                      extras: ["X-HTTP-Method-Override": "GET"]) {
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        channel.session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, error); return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completionHandler(nil, NSError(domain: NSURLErrorDomain, code: httpStatus.statusCode, userInfo: [
                    "status": httpStatus,
                    "response": data
                ]))
            }
            completionHandler(data, nil)
            /*
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                completionHandler(json, nil)
            } catch(let error) {
                completionHandler(nil, error)
            }
            */
        }.resume()
    }
}

public struct PeopleAPIData {
    private init() {}
    
    public struct Address: Codable {
        public var formatted: String? = nil
        public var type: String? = nil
    }
    
    public struct Location: Codable {
        public var value: String? = nil
    }
    
    public struct Birthday: Codable {
        public var dateMs: String? = nil
        public var dateMsAsNumber: String? = nil
    }
    
    public struct Organization: Codable {
        public var name: String? = nil
        public var stringType: String? = nil
        public var title: String? = nil
    }
    
    public struct Tagline: Codable {
        public var value: String? = nil
    }
    
    public struct Membership: Codable {
        public var contactGroupId: String? = nil
        public var systemContactGroupId: String? = nil
    }
    
    public struct ProfileUrl: Codable {
        public var url: String? = nil
    }
    
    public struct Email: Codable {
        public var formattedType: String? = nil
        public var type: String? = nil
        public var value: String? = nil
    }
    
    public struct HangoutsExtendedData: Codable {
        public var hadPastHangoutState: String? = nil
        public var invitationStatus: String? = nil
        public var isBot: Bool? = nil
        public var isDismissed: Bool? = nil
        public var isFavorite: Bool? = nil
        public var isPinned: Bool? = nil
        public var userType: String? = nil
    }
    
    public struct ExtendedData: Codable {
        public var hangoutsExtendedData: HangoutsExtendedData? = nil
    }
    
    public struct Gender: Codable {
        public var formattedType: String? = nil
        public var type: String? = nil
    }
    
    public struct ReachabilityKey: Codable {
        public var keyType: String? = nil
        public var keyValue: String? = nil
    }
    
    public struct InAppReachability: Codable {
        public var appType: String? = nil
        public var reachabilityKey: ReachabilityKey? = nil
        public var status: String? = nil
    }
    
    public struct Name: Codable {
        public var displayName: String? = nil
        public var displayNameLastFirst: String? = nil
        public var familyName: String? = nil
        public var givenName: String? = nil
        public var unstructuredName: String? = nil
    }
    
    public struct I18nData: Codable {
        public var countryCode: UInt? = nil
        public var internationalNumber: String? = nil
        public var isValid: Bool = false
        public var nationalNumber: String? = nil
        public var regionCode: String? = nil
        public var validationResult: String? = nil
    }
    
    public struct PhoneNumber: Codable {
        public var e164: String? = nil
        public var i18nData: I18nData? = nil
    }
    
    public struct StructuredPhone: Codable {
        public var phoneNumber: PhoneNumber? = nil
        public var type: String? = nil
    }
    
    public struct PhoneExtendedData: Codable {
        public var structuredPhone: StructuredPhone? = nil
    }
    
    public struct Phone: Codable {
        public var canonicalizedForm: String? = nil
        public var extendedData: PhoneExtendedData? = nil
        public var formattedType: String? = nil
        public var type: String? = nil
        public var uri: String? = nil
        public var value: String? = nil
    }
    
    public struct Photo: Codable {
        public var isDefault: Bool? = nil
        public var isMonogram: Bool? = nil
        public var monogramBackground: String? = nil
        public var photoToken: String? = nil
        public var url: String? = nil
    }
    
    public struct CoverPhoto: Codable {
        public var imageHeight: UInt? = nil
        public var imageWidth: UInt? = nil
        public var imageId: String? = nil
        public var imageUrl: String? = nil
    }
    
    public struct AccountEmail: Codable {
        public var email: String? = nil
    }
    
    public struct ProfileInfo: Codable {
        public var accountEmail: AccountEmail? = nil
        public var objectType: String? = nil
    }
    
    public struct Person: Codable {
        public var coverPhoto: CoverPhoto? = nil
        public var email: [Email]? = nil
        public var extendedData: ExtendedData? = nil
        public var fingerprint: String? = nil
        public var gender: [Gender]? = nil
        public var inAppReachability: [InAppReachability]? = nil
        public var name: [Name]? = nil
        public var personId: String? = nil
        public var phone: [Phone]? = nil
        public var photo: [Photo]? = nil
        public var address: [Address]? = nil
        public var location: [Location]? = nil
        public var birthday: [Birthday]? = nil
        public var organization: [Organization]? = nil
        public var tagline: [Tagline]? = nil
        public var membership: [Membership]? = nil
        public var readOnlyProfileInfo: [ProfileInfo]? = nil
        public var profileUrlRepeated: [ProfileUrl]? = nil
    }
    
    public struct ConversationId: Codable {
        public var id: String? = nil
    }
    
    public struct ParticipantId: Codable {
        public var profileId: String? = nil
    }
    
    public struct Participant: Codable {
        public var displayName: String? = nil
        public var email: String? = nil
        public var id: ParticipantId? = nil
        public var invitationStatus: String? = nil
        public var profilePictureUrl: String? = nil
    }
    
    public struct ConversationMetadata: Codable {
        public var id: ConversationId? = nil
        public var otrStatus: String? = nil
        public var participants: [Participant]? = nil
        public var type: String? = nil
    }
    
    public struct ConversationAndSelfState: Codable {
        public var conversationMetadata: ConversationMetadata? = nil
    }
    
    public struct ConversationResult: Codable {
        public var conversationAndSelfState: ConversationAndSelfState? = nil
    }
    
    public struct AutocompleteStatus: Codable {
        public var personalResultsNotReady: Bool? = nil
    }
    
    public struct Match: Codable {
        public var lookupId: String? = nil
        public var personId: [String]? = nil
    }
    
    public struct Suggestion: Codable {
        public var objectType: String? = nil
        public var person: Person? = nil
        public var suggestion: String? = nil
    }
    
    public struct PersonResponse: Codable {
        public var person: Person? = nil
        public var personId: String? = nil
        public var status: String? = nil
    }
    
    public struct GetByIdResponse: Codable {
        public var personResponse: [PersonResponse]? = nil
    }
    
    public struct LookupResponse: Codable {
        public var people: [String: Person]? = nil
        public var matches: [Match]? = nil
    }
    
    public struct ListAllResponse: Codable {
        public var nextSyncToken: String? = nil
        public var people: [Person]? = nil
        public var totalItems: UInt? = nil
        public var nextPageToken: String? = nil
    }
    
    public struct SuggestionsResponse: Codable {
        public var people: [Person]? = nil
    }
    
    public struct AutocompleteResponse: Codable {
        public var status: AutocompleteStatus? = nil
        public var nextPageToken: String? = nil
        public var results: [Suggestion]? = nil
    }
    
    public struct AutocompleteGroupResponse: Codable {
        public var results: [ConversationResult]? = nil
    }
}
