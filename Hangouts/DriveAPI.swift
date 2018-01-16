import Foundation

public struct DriveAPI {
    private init() {}
    
    private static let baseURL = "https://clients6.google.com/upload/drive/v2internal/files"
    private static let permsURL = "https://clients6.google.com/drive/v2internal/files"
    private static let APIKey = "AIzaSyAy9VVXHSpS2IJpptzYtGbLP3-3_l0aBk4"
    private static let viewURL = "https://docs.google.com/uc"
    
    private static func synchronousRequest(_ c: Channel, _ request: URLRequest) throws -> (Data?, URLResponse?) {
        var data: Data?, response: URLResponse?, error: Error?
        let semaphore = DispatchSemaphore(value: 0)
        
        var request = request
        for (k, v) in Channel.getAuthorizationHeaders(c.cachedSAPISID, origin: "https://drive.google.com") {
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        c.session.dataTask(with: request) {
            data = $0; response = $1; error = $2
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait()
        if let error = error {
            throw error
        }
        return (data, response)
    }
    
    private static func jsonRequest(_ c: Channel, _ method: String, _ location: String, _ body: [String: Any],
                                   _ query: [String: String] = [:], _ headers: [String: String] = [:])
        throws -> ([String: Any]?, HTTPURLResponse?)
    {
        let data = try JSONSerialization.data(withJSONObject: body, options: [])
        let querystr = query.map { $0.key + "=" + $0.value }.joined(separator: "&")
        var request = URLRequest(url: URL(string: location + (query.count > 0 ? "?" : "") + querystr)!)
        request.httpMethod = method
        request.httpBody = data
        request.allHTTPHeaderFields = headers
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (a, b) = try DriveAPI.synchronousRequest(c, request)
        if let a = a, a.count > 0 {
            let json = try JSONSerialization.jsonObject(with: a, options: [.allowFragments]) as? [String: Any]
            return (json, b as? HTTPURLResponse)
        } else {
            return (nil, b as? HTTPURLResponse)
        }
    }
    
    private static func dataRequest(_ c: Channel, _ method: String, _ location: String, _ data: Data,
                                   _ query: [String: String] = [:], _ headers: [String: String] = [:])
        throws -> (Data?, HTTPURLResponse?)
    {
        let querystr = query.map { $0.key + "=" + $0.value }.joined(separator: "&")
        var request = URLRequest(url: URL(string: location + (query.count > 0 ? "?" : "") + querystr)!)
        request.httpMethod = method
        request.httpBody = data
        request.allHTTPHeaderFields = headers
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        let (a, b) = try DriveAPI.synchronousRequest(c, request)
        return (a, b as? HTTPURLResponse)
    }
    
    public static func share(on c: Channel, file url: URL, with email: String) throws -> URL {
        let reach = try url.checkResourceIsReachable()
        guard url.isFileURL && reach else { throw URLError(.resourceUnavailable) }
        let data = try Data(contentsOf: url)
        
        let (_, response1) = try DriveAPI.jsonRequest(c, "POST", DriveAPI.baseURL, [
            "title": url.lastPathComponent,
            "description": "Shared by Parrot."
            ], [
                "uploadType": "resumable",
                "key": DriveAPI.APIKey
            ], [
                "X-Upload-Content-Length": "\(data.count)",
            ])
        
        /* supportsTeamDrives=true&pinned=true&convert=false&fields=kind,title,mimeType,createdDate,modifiedDate,modifiedByMeDate,lastViewedByMeDate,fileSize,owners(kind,permissionId,displayName,picture,emailAddress,domain),lastModifyingUser(kind,permissionId,displayName,picture,emailAddress),hasThumbnail,thumbnailVersion,iconLink,id,shared,sharedWithMeDate,userPermission(role),explicitlyTrashed,quotaBytesUsed,shareable,copyable,subscribed,folderColor,hasChildFolders,fileExtension,primarySyncParentId,sharingUser(kind,permissionId,displayName,picture,emailAddress),flaggedForAbuse,folderFeatures,spaces,sourceAppId,editable,recency,recencyReason,version,actionItems,teamDriveId,hasAugmentedPermissions,primaryDomainName,organizationDisplayName,passivelySubscribed,trashingUser(kind,permissionId,displayName,picture,emailAddress),trashedDate,hasVisitorPermissions,parents(id),labels(starred,hidden,trashed,restricted,viewed),capabilities(canCopy,canDownload,canEdit,canAddChildren,canDelete,canRemoveChildren,canShare,canTrash,canRename,canReadTeamDrive,canMoveTeamDriveItem,canMoveItemIntoTeamDrive)&openDrive=false&reason=202&syncType=0&errorRecovery=false
         */
        
        guard let location = response1?.allHeaderFields["Location"] as? String else { throw NSError(domain: "noloc", code: 0) }
        let (data2, _) = try DriveAPI.dataRequest(c, "POST", location, data, [:], [
            "Content-Range": "bytes 0-\(data.count - 1)/\(data.count)",
            ])
        
        let json2 = try JSONSerialization.jsonObject(with: data2!, options: [.allowFragments]) as? [String: Any]
        guard let fileID = json2?["id"] as? String else { throw URLError(.unsupportedURL) }
        let (_, _) = try DriveAPI.jsonRequest(c, "POST", DriveAPI.permsURL + "/\(fileID)/permissions", [
            "role": "reader",
            "type": "user",
            "value": "aditya.vaidyam@gmail.com",
            //"withLink": "true"
            ], [
                //"sendNotificationEmails": "false", // broken?
                "key": DriveAPI.APIKey
            ], [:])
        return URL(string: DriveAPI.viewURL + "?id=\(fileID)")!
    }
    
    /*
    public func TEST3() {
        let fileUrl = URL(string: "file://" + "/Users/USERNAME/Desktop/DECgHBrWsAAdd15.jpg")!
        do {
            let url = try share(file: fileUrl, with: "PERSON@gmail.com", auth: DriveAPI.APIKey)
            
            print(url)
        } catch(let error) {
            print(error)
        }
    }
    */
}
