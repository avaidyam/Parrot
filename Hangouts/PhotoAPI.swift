import Foundation

/// Google Photos Resumable Upload
public typealias GooglePhoto = PhotoAPI
public enum PhotoAPI {
    
    /// The photo is already uploaded and is referenced by its Google Photos ID.
    case existing(id: String, user: String)
    
    /// The photo is not yet uploaded.
    case new(data: Data, name: String)
}

internal extension PhotoAPI {
    private static let UPLOAD_URL = "https://docs.google.com/upload/photos/resumable"
    
// Google Photos Upload/Resumable FORMAT:
/*
{
  "protocolVersion": "0.8",
  "createSessionRequest": {
    "fields": [
      {
        "external": {
          "name": "file",
          "filename": "<FILENAME>",
          "put": {},
          "size": <FILESIZE>
        }
      },
      {
        "inlined": {
          "name": "use_upload_size_pref",
          "content": "true",
          "contentType": "text/plain"
        }
      },
      {
        "inlined": {
          "name": "album_mode",
          "content": "temporary",
          "contentType": "text/plain"
        }
      },
      {
        "inlined": {
          "name": "title",
          "content": "<FILENAME>",
          "contentType": "text/plain"
        }
      },
      {
        "inlined": {
          "name": "addtime",
          "content": "<TIMESTAMP (USEC)>",
          "contentType": "text/plain"
        }
      },
      {
        "inlined": {
          "name": "batchid",
          "content": "<TIMESTAMP (USEC)>",
          "contentType": "text/plain"
        }
      },
      {
        "inlined": {
          "name": "album_name",
          "content": "<MONTH DAY, YEAR>",
          "contentType": "text/plain"
        }
      },
      {
        "inlined": {
          "name": "album_abs_position",
          "content": "0",
          "contentType": "text/plain"
        }
      },
      {
        "inlined": {
          "name": "client",
          "content": "hangouts",
          "contentType": "text/plain"
        }
      }
    ]
  }
}
*/
    
    // Upload an image that can be later attached to a chat message.
    // The name of the uploaded file may be changed by specifying the filename argument.
    internal func uploadImage(on: Channel, data: Data, filename: String, cb: ((String) -> Void)? = nil) {
        let now = Date(), msec = Int64(now.timeIntervalSince1970 * 1000)
        let jst =
"""
{"protocolVersion":"0.8","createSessionRequest":{"fields":[{"external":{"name":"file","filename":"\(filename)","put":{},"size":\(data.count)}},{"inlined":{"name":"use_upload_size_pref","content":"true","contentType":"text/plain"}},{"inlined":{"name":"album_mode","content":"temporary","contentType":"text/plain"}},{"inlined":{"name":"title","content":"\(filename)","contentType":"text/plain"}},{"inlined":{"name":"addtime","content":"\(msec)","contentType":"text/plain"}},{"inlined":{"name":"batchid","content":"\(msec)","contentType":"text/plain"}},{"inlined":{"name":"album_name","content":"\(now.fullString(false))","contentType":"text/plain"}},{"inlined":{"name":"album_abs_position","content":"0","contentType":"text/plain"}},{"inlined":{"name":"client","content":"hangouts","contentType":"text/plain"}}]}}
"""
        
        on.base_request(path: GooglePhoto.UPLOAD_URL,
            content_type: "application/x-www-form-urlencoded;charset=UTF-8",
            data: jst.data(using: .utf8)!) { response in
                
            // Sift through JSON for a response with the upload URL.
                let _data: NSDictionary = try! JSONSerialization.jsonObject(with: response.data!,
                options: .allowFragments) as! NSDictionary
            let _a = _data["sessionStatus"] as! NSDictionary
            let _b = _a["externalFieldTransfers"] as! NSArray
            let _c = _b[0] as! NSDictionary
            let _d = _c["putInfo"] as! NSDictionary
            let upload = (_d["url"] as! NSString) as String
                
            on.base_request(path: upload, content_type: "application/octet-stream", data: data) { resp in
                
                // Sift through JSON for a response with the photo ID.
                let _data2: NSDictionary = try! JSONSerialization.jsonObject(with: resp.data!,
                    options: .allowFragments) as! NSDictionary
                let _a2 = _data2["sessionStatus"] as! NSDictionary
                let _b2 = _a2["additionalInfo"] as! NSDictionary
                let _c2 = _b2["uploader_service.GoogleRupioAdditionalInfo"] as! NSDictionary
                let _d2 = _c2["completionInfo"] as! NSDictionary
                let _e2 = _d2["customerSpecificInfo"] as! NSDictionary
                let photoid = (_e2["photoid"] as! NSString) as String
                
                cb?(photoid)
            }
        }
    }
}

internal extension Client {
    
    /// Uploads a photo if needed and returns its id.
    internal func uploadIfNeeded(photo: GooglePhoto, _ handler: @escaping (String, String?) -> ()) {
        switch photo {
        case .existing(let id, let user):
            handler(id, user)
        case .new(let data, let name):
            assert(self.channel != nil, "Cannot upload an GooglePhoto if Channel is nil!")
            photo.uploadImage(on: self.channel!, data: data, filename: name) {
                handler($0, nil)
            }
        }
    }
}
