import Foundation

internal enum PeopleAPI {
    private static let baseURL = "https://people-pa.clients6.google.com/v2/people"
    private static let groupsURL = "https://hangoutssearch-pa.clients6.google.com/v1"
    private static let APIKey = "AIzaSyBokvzEPUrkgfws0OrFWkpKkVBVuhRfKpk"
    
    internal static func suggestions(on channel: Channel, completionHandler: @escaping (PeopleAPIData.SuggestionsResponse?, Error?) -> ()) {
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
    
    internal static func list(on channel: Channel, completionHandler: @escaping (PeopleAPIData.ListAllResponse?, Error?) -> ()) {
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
    
    internal static func lookup(on channel: Channel, ids: [String], completionHandler: @escaping (PeopleAPIData.GetByIdResponse?, Error?) -> ()) {
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
    
    internal static func lookup(on channel: Channel, phones: [String], completionHandler: @escaping (PeopleAPIData.LookupResponse?, Error?) -> ()) {
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
    
    internal static func lookup(on channel: Channel, emails: [String], completionHandler: @escaping (PeopleAPIData.LookupResponse?, Error?) -> ()) {
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
    
    internal static func autocomplete(on channel: Channel, person: String, length: UInt = 15,
                                    completionHandler: @escaping (PeopleAPIData.AutocompleteResponse?, Error?) -> ())
    {
        self._post(channel, PeopleAPI.baseURL + "/autocomplete", [
            "query": person,
            "client": "HANGOUTS_WITH_DATA",
            "pageSize": "\(length)",
            "key": PeopleAPI.APIKey
        ], nil, completionHandler)
    }
    
    internal static func autocomplete(on channel: Channel, group: String, length: UInt = 15,
                                          completionHandler: @escaping (PeopleAPIData.AutocompleteGroupResponse?, Error?) -> ())
    {
        self._post(channel, PeopleAPI.groupsURL + "/metadata:search", [
            "query": group,
            "pageSize": "\(length)",
            "includeMetadata": "true",
            "key": PeopleAPI.APIKey,
            "alt": "json"
        ], nil, completionHandler)
    }
    
    // Note: DictionaryLiteral accepts duplicate keys and preserves order.
    // Note: `prefix` is a silly hack for multiple `id`'s which are dynamic and cannot be in a literal.
    private static func _post<T: Codable>(_ channel: Channel, _ api: String, _ params: DictionaryLiteral<String, String>,
                              _ prefix: String? = nil, _ completionHandler: @escaping (T?, Error?) -> ())
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
            do {
                let res = try JSONDecoder().decode(T.self, from: data)
                completionHandler(res, nil)
            } catch(let error) {
                completionHandler(nil, error)
            }
        }.resume()
    }
}

internal enum PeopleAPIData {
    
    internal struct Metadata: Codable {
        internal var container: String? = nil
        internal var containerType: String? = nil
        internal var visibility: String? = nil
        internal var primary: Bool? = nil
        internal var writable: Bool? = nil
    }
    
    internal struct Address: Codable {
        internal var metadata: Metadata? = nil
        internal var formatted: String? = nil
        internal var type: String? = nil
    }
    
    internal struct Location: Codable {
        internal var metadata: Metadata? = nil
        internal var value: String? = nil
    }
    
    internal struct Birthday: Codable {
        internal var metadata: Metadata? = nil
        internal var dateMs: String? = nil
        internal var dateMsAsNumber: String? = nil
    }
    
    internal struct Organization: Codable {
        internal var metadata: Metadata? = nil
        internal var name: String? = nil
        internal var stringType: String? = nil
        internal var title: String? = nil
    }
    
    internal struct Tagline: Codable {
        internal var metadata: Metadata? = nil
        internal var value: String? = nil
    }
    
    internal struct Membership: Codable {
        internal var contactGroupId: String? = nil
        internal var systemContactGroupId: String? = nil
    }
    
    internal struct ProfileUrl: Codable {
        internal var url: String? = nil
    }
    
    internal struct Email: Codable {
        internal var metadata: Metadata? = nil
        internal var formattedType: String? = nil
        internal var type: String? = nil
        internal var value: String? = nil
    }
    
    internal struct Gender: Codable {
        internal var metadata: Metadata? = nil
        internal var formattedType: String? = nil
        internal var type: String? = nil
    }
    
    internal struct Name: Codable {
        internal var metadata: Metadata? = nil
        internal var displayName: String? = nil
        internal var displayNameLastFirst: String? = nil
        internal var familyName: String? = nil
        internal var givenName: String? = nil
        internal var unstructuredName: String? = nil
    }
    
    internal struct Photo: Codable {
        internal var metadata: Metadata? = nil
        internal var isDefault: Bool? = nil
        internal var isMonogram: Bool? = nil
        internal var monogramBackground: String? = nil
        internal var photoToken: String? = nil
        internal var url: String? = nil
    }
    
    internal struct CoverPhoto: Codable {
        internal var imageHeight: UInt? = nil
        internal var imageWidth: UInt? = nil
        internal var imageId: String? = nil
        internal var imageUrl: String? = nil
    }
    
    internal struct Phone: Codable {
        internal struct PhoneExtendedData: Codable {
            internal struct StructuredPhone: Codable {
                internal struct PhoneNumber: Codable {
                    internal struct I18nData: Codable {
                        internal var countryCode: UInt? = nil
                        internal var internationalNumber: String? = nil
                        internal var isValid: Bool = false
                        internal var nationalNumber: String? = nil
                        internal var regionCode: String? = nil
                        internal var validationResult: String? = nil
                    }
                    
                    internal var e164: String? = nil
                    internal var i18nData: I18nData? = nil
                }
                
                internal var phoneNumber: PhoneNumber? = nil
                internal var type: String? = nil
            }
            
            internal var structuredPhone: StructuredPhone? = nil
        }
        
        internal var metadata: Metadata? = nil
        internal var canonicalizedForm: String? = nil
        internal var extendedData: PhoneExtendedData? = nil
        internal var formattedType: String? = nil
        internal var type: String? = nil
        internal var uri: String? = nil
        internal var value: String? = nil
    }
    
    internal struct InAppReachability: Codable {
        internal struct ReachabilityKey: Codable {
            internal var keyType: String? = nil
            internal var keyValue: String? = nil
        }
        
        internal var appType: String? = nil
        internal var reachabilityKey: ReachabilityKey? = nil
        internal var status: String? = nil
    }
    
    internal struct ProfileInfo: Codable {
        internal struct AccountEmail: Codable {
            internal var email: String? = nil
        }
        
        internal var accountEmail: AccountEmail? = nil
        internal var objectType: String? = nil
    }
    
    
    internal struct ExtendedData: Codable {
        internal struct HangoutsExtendedData: Codable {
            internal var hadPastHangoutState: String? = nil
            internal var invitationStatus: String? = nil
            internal var isBot: Bool? = nil
            internal var isDismissed: Bool? = nil
            internal var isFavorite: Bool? = nil
            internal var isPinned: Bool? = nil
            internal var userType: String? = nil
        }
        
        internal var hangoutsExtendedData: HangoutsExtendedData? = nil
    }
    
    internal struct Person: Codable {
        internal var coverPhoto: CoverPhoto? = nil
        internal var email: [Email]? = nil
        internal var extendedData: ExtendedData? = nil
        internal var fingerprint: String? = nil
        internal var gender: [Gender]? = nil
        internal var inAppReachability: [InAppReachability]? = nil
        internal var name: [Name]? = nil
        internal var personId: String? = nil
        internal var phone: [Phone]? = nil
        internal var photo: [Photo]? = nil
        internal var address: [Address]? = nil
        internal var location: [Location]? = nil
        internal var birthday: [Birthday]? = nil
        internal var organization: [Organization]? = nil
        internal var tagline: [Tagline]? = nil
        internal var membership: [Membership]? = nil
        internal var readOnlyProfileInfo: [ProfileInfo]? = nil
        internal var profileUrlRepeated: [ProfileUrl]? = nil
    }
    
    internal struct Participant: Codable {
        internal struct Id: Codable {
            internal var profileId: String? = nil
        }
        
        internal var displayName: String? = nil
        internal var email: String? = nil
        internal var id: Id? = nil
        internal var invitationStatus: String? = nil
        internal var profilePictureUrl: String? = nil
    }
    
    internal struct ConversationResult: Codable {
        internal struct ConversationAndSelfState: Codable {
            internal struct ConversationMetadata: Codable {
                internal struct Id: Codable {
                    internal var id: String? = nil
                }
                
                internal var id: Id? = nil
                internal var otrStatus: String? = nil
                internal var participants: [Participant]? = nil
                internal var type: String? = nil
            }
            
            internal var conversationMetadata: ConversationMetadata? = nil
        }
        
        internal var conversationAndSelfState: ConversationAndSelfState? = nil
    }
    
    internal struct GetByIdResponse: Codable {
        internal struct Result: Codable {
            internal var person: Person? = nil
            internal var personId: String? = nil
            internal var status: String? = nil
        }
        
        internal var personResponse: [Result]? = nil
    }
    
    internal struct LookupResponse: Codable {
        internal struct Match: Codable {
            internal var lookupId: String? = nil
            internal var personId: [String]? = nil
        }
        
        internal var people: [String: Person]? = nil
        internal var matches: [Match]? = nil
    }
    
    internal struct ListAllResponse: Codable {
        internal var nextSyncToken: String? = nil
        internal var people: [Person]? = nil
        internal var totalItems: UInt? = nil
        internal var nextPageToken: String? = nil
    }
    
    internal struct SuggestionsResponse: Codable {
        internal var people: [Person]? = nil
    }
    
    internal struct AutocompleteResponse: Codable {
        internal struct Status: Codable {
            internal var personalResultsNotReady: Bool? = nil
        }
        
        internal struct Suggestion: Codable {
            internal var objectType: String? = nil
            internal var person: Person? = nil
            internal var suggestion: String? = nil
        }
        
        internal var status: Status? = nil
        internal var nextPageToken: String? = nil
        internal var results: [Suggestion]? = nil
    }
    
    internal struct AutocompleteGroupResponse: Codable {
        internal var results: [ConversationResult]? = nil
    }
    
    // Convenience for this crazy nesting.
    internal typealias PhoneNumber = Phone.PhoneExtendedData.StructuredPhone.PhoneNumber
    internal typealias I18nData = Phone.PhoneExtendedData.StructuredPhone.PhoneNumber.I18nData
    internal typealias HangoutsExtendedData = ExtendedData.HangoutsExtendedData
    internal typealias ConversationMetadata = ConversationResult.ConversationAndSelfState.ConversationMetadata
}

internal extension PeopleAPIData.HangoutsExtendedData {
    var userInterest: Bool { return (self.isFavorite ?? false || self.isPinned ?? false) }
}
