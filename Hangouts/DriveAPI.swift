import Foundation

public struct DriveAPI {
    private init() {}
    
    private static let baseURL = "https://www.googleapis.com/upload/drive/v3/files"
    private static let viewURL = "https://docs.google.com/uc"
    
    private static func synchronousRequest(_ request: URLRequest) throws -> (Data?, URLResponse?) {
        var data: Data?, response: URLResponse?, error: Error?
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) {
            data = $0; response = $1; error = $2
            semaphore.signal()
            }.resume()
        
        _ = semaphore.wait()
        if let error = error {
            throw error
        }
        return (data, response)
    }
    
    private static func jsonRequest(_ method: String, _ location: String, _ body: [String: Any],
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
        let (a, b) = try DriveAPI.synchronousRequest(request)
        if let a = a, a.count > 0 {
            let json = try JSONSerialization.jsonObject(with: a, options: [.allowFragments]) as? [String: Any]
            return (json, b as? HTTPURLResponse)
        } else {
            return (nil, b as? HTTPURLResponse)
        }
    }
    
    private static func dataRequest(_ method: String, _ location: String, _ data: Data,
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
        let (a, b) = try DriveAPI.synchronousRequest(request)
        return (a, b as? HTTPURLResponse)
    }
    
    public func share(file url: URL, with email: String, auth: String) throws -> URL {
        let reach = try url.checkResourceIsReachable()
        guard url.isFileURL && reach else { throw URLError(.resourceUnavailable) }
        let data = try Data(contentsOf: url)
        
        let (_, response1) = try DriveAPI.jsonRequest("POST", DriveAPI.baseURL, [
            "name": url.lastPathComponent,
            "description": "Shared by Parrot."
            ], [
                "uploadType": "resumable"
            ], [
                "Authorization": "Bearer \(auth)",
                "X-Upload-Content-Length": "\(data.count)",
            ])
        
        guard let location = response1?.allHeaderFields["Location"] as? String else { throw NSError(domain: "noloc", code: 0) }
        let (data2, _) = try DriveAPI.dataRequest("POST", location, data, [:], [
            "Content-Range": "bytes 0-\(data.count - 1)/\(data.count)",
            ])
        
        let json2 = try JSONSerialization.jsonObject(with: data2!, options: [.allowFragments]) as? [String: Any]
        guard let fileID = json2?["id"] as? String else { throw URLError(.unsupportedURL) }
        let (_, _) = try DriveAPI.jsonRequest("POST", DriveAPI.baseURL + "/\(fileID)/permissions", [
            "role": "reader",
            "type": "user",
            "emailAddress": email
            ], [:], [
                "Authorization": "Bearer \(auth)"
            ])
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
