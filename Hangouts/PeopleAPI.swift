import Foundation

public struct PeopleAPI {
    private init() {}
    
    private static let baseURL = "https://people-pa.clients6.google.com/v2/people"
    private static let APIKey = "AIzaSyBokvzEPUrkgfws0OrFWkpKkVBVuhRfKpk"
    
    public static func list(on channel: Channel, ids: String...) {
        self._post(channel, "", [
            "requestMask.includeField.paths": "person.email",
            "requestMask.includeField.paths": "person.gender",
            "requestMask.includeField.paths": "person.in_app_reachability",
            "requestMask.includeField.paths": "person.metadata",
            "requestMask.includeField.paths": "person.name",
            "requestMask.includeField.paths": "person.phone",
            "requestMask.includeField.paths": "person.photo",
            "requestMask.includeField.paths": "person.read_only_profile_info",
            "requestMask.includeField.paths": "person.organization",
            "requestMask.includeField.paths": "person.location",
            "requestMask.includeField.paths": "person.cover_photo",
            "extensionSet.extensionNames": "HANGOUTS_ADDITIONAL_DATA",
            "extensionSet.extensionNames": "HANGOUTS_OFF_NETWORK_GAIA_LOOKUP",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "includedProfileStates": "ADMIN_BLOCKED",
            "includedProfileStates": "DELETED",
            "includedProfileStates": "PRIVATE_PROFILE",
            "mergedPersonSourceOptions.includeAffinity": "CHAT_AUTOCOMPLETE",
            "coreIdParams.useRealtimeNotificationExpandedAcls": "true",
            "key": PeopleAPI.APIKey
        ], ids.map { "personId=" + $0 }.joined(separator: "&"))
    }
    
    public static func lookup(on channel: Channel, phone: String...) {
        self._post(channel, "/lookup", [
            "type": "PHONE",
            "matchType": "LENIENT",
            "requestMask.includeField.paths": "person.email",
            "requestMask.includeField.paths": "person.gender",
            "requestMask.includeField.paths": "person.in_app_reachability",
            "requestMask.includeField.paths": "person.metadata",
            "requestMask.includeField.paths": "person.name",
            "requestMask.includeField.paths": "person.phone",
            "requestMask.includeField.paths": "person.read_only_profile_info",
            "extensionSet.extensionNames": "HANGOUTS_ADDITIONAL_DATA",
            "extensionSet.extensionNames": "HANGOUTS_OFF_NETWORK_GAIA_LOOKUP",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "coreIdParams.useRealtimeNotificationExpandedAcls": "true",
            "quotaFilterType": "PHONE",
            "key": PeopleAPI.APIKey
        ], phone.map { "id=" + $0 }.joined(separator: "&"))
    }
    
    public static func autocomplete(on channel: Channel, query: String, length: UInt = 15) {
        self._post(channel, "/autocomplete", [
            "query": query,
            "client": "HANGOUTS_WITH_DATA",
            "pageSize": "\(length)",
            "key": PeopleAPI.APIKey
        ])
    }
    
    // Note: DictionaryLiteral accepts duplicate keys and preserves order.
    // Note: `prefix` is a silly hack for multiple `id`'s which are dynamic and cannot be in a literal.
    private static func _post(_ channel: Channel, _ api: String, _ params: DictionaryLiteral<String, String>, _ prefix: String? = nil) {
        var merge = params.map { "\($0)=\($1)" }.joined(separator: "&")
        if let prefix2 = prefix {
            merge = prefix2 + "&" + merge
        }
        
        var request = URLRequest(url: URL(string: PeopleAPI.baseURL + api)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = merge.data(using: .utf8)
        for (k, v) in Channel.getAuthorizationHeaders2(channel.cachedSAPISID) {
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        channel.session.dataTask(with: request) { data, response, error in
            print("\n\n--------------------------------\n\n")
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))"); return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)\nresponse = \(String(describing: response))")
            }
            print("responseString = \(String(describing: String(data: data, encoding: .utf8)))")
        }.resume()
    }
}
