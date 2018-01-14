import Foundation

public struct PeopleAPI {
    private init() {}
    
    private static let baseURL = "https://people-pa.clients6.google.com/v2/people"
    private static let APIKey = "AIzaSyBokvzEPUrkgfws0OrFWkpKkVBVuhRfKpk"
    
    public static func list(on channel: Channel, id: String..., completionHandler: @escaping ([String: Any]?, Error?) -> ()) {
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
            "extensionSet.extensionNames": "HANGOUTS_OFF_NETWORK_GAIA_GET",
            "extensionSet.extensionNames": "HANGOUTS_PHONE_DATA",
            "includedProfileStates": "ADMIN_BLOCKED",
            "includedProfileStates": "DELETED",
            "includedProfileStates": "PRIVATE_PROFILE",
            "mergedPersonSourceOptions.includeAffinity": "CHAT_AUTOCOMPLETE",
            "coreIdParams.useRealtimeNotificationExpandedAcls": "true",
            "key": PeopleAPI.APIKey
        ], id.map { "personId=" + $0 }.joined(separator: "&"), completionHandler)
    }
    
    public static func lookup(on channel: Channel, phone: String..., completionHandler: @escaping ([String: Any]?, Error?) -> ()) {
        self._post(channel, "/lookup", [
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
        ], phone.map { "id=" + $0 }.joined(separator: "&"), completionHandler)
    }
    
    public static func autocomplete(on channel: Channel, query: String, length: UInt = 15,
                                    completionHandler: @escaping ([String: Any]?, Error?) -> ())
    {
        self._post(channel, "/autocomplete", [
            "query": query,
            "client": "HANGOUTS_WITH_DATA",
            "pageSize": "\(length)",
            "key": PeopleAPI.APIKey
        ], nil, completionHandler)
    }
    
    // Note: DictionaryLiteral accepts duplicate keys and preserves order.
    // Note: `prefix` is a silly hack for multiple `id`'s which are dynamic and cannot be in a literal.
    private static func _post(_ channel: Channel, _ api: String, _ params: DictionaryLiteral<String, String>,
                              _ prefix: String? = nil, _ completionHandler: @escaping ([String: Any]?, Error?) -> ())
    {
        var merge = params.map { "\($0)=\($1)" }.joined(separator: "&")
        if let prefix2 = prefix {
            merge = prefix2 + "&" + merge
        }
        merge = merge.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            .replacingOccurrences(of: "+", with: "%2B") // since + is somehow allowed???
        
        var request = URLRequest(url: URL(string: PeopleAPI.baseURL + api)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = merge.data(using: .utf8)
        for (k, v) in Channel.getAuthorizationHeaders2(channel.cachedSAPISID) {
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
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                completionHandler(json, nil)
            } catch(let error) {
                completionHandler(nil, error)
            }
        }.resume()
    }
}
