import Foundation

internal protocol ServiceRequest: ProtoMessage {
    var request_header: RequestHeader? { get set }
}
internal protocol ServiceResponse: ProtoMessage {
    var response_header: ResponseHeader? { get set }
}
internal protocol ServiceEndpoint {
    associatedtype Request: ServiceRequest
    associatedtype Response: ServiceResponse
    static var location: String { get }
}

internal extension Client {
    
    /// Asynchronously execute the API transaction with the service endpoint.
    /// - `request`: The request to send the service endpoint.
    /// - `handler`: The response from executing the operation, or any error that occurred.
    internal func execute<T: ServiceEndpoint>(_ endpoint: T.Type, with request: T.Request,
                                              handler: @escaping (T.Response?, Error?) -> ()) {
        self.opQueue.async {
            do {
                var request = request // shadow
                request.request_header = RequestHeader.header(for: self.client_id)
                let input: Any = try PBLiteEncoder().encode(request)
                // use opQueue?
                self.channel?.request(endpoint: endpoint.location, body: input, use_json: false) { r in
                    guard let response = r.data else {
                        return handler(nil, r.error ?? NSError(domain: "", code: 0, userInfo: nil))
                    }
                    
                    do {
                        let output: T.Response = try PBLiteDecoder().decode(data: response)!
                        handler(output, nil)
                    } catch(let error) {
                        handler(nil, error)
                    }
                }
            } catch(let error) {
                handler(nil, error)
            }
        }
    }
    
    /// Synchronously execute the API transaction with the service endpoint.
    /// - `request`: The request to send the service endpoint.
    /// - `handler`: The response from executing the operation, or any error that occurred.
    internal func execute<T: ServiceEndpoint>(_ endpoint: T.Type, with request: T.Request) throws -> T.Response {
        return try self.opQueue.sync {
            var request = request // shadow
            request.request_header = RequestHeader.header(for: self.client_id)
            let input: Any = try PBLiteEncoder().encode(request)
            
            var result: Result? = nil
            let sem =  DispatchSemaphore(value: 0)
            // use opQueue?
            self.channel?.request(endpoint: endpoint.location, body: input, use_json: false) { r in
                result = r
                sem.signal()
            }
            sem.wait()
            
            guard let response = result?.data else {
                throw result?.error ?? NSError(domain: "", code: 0, userInfo: nil)
            }
            let output: T.Response = try PBLiteDecoder().decode(data: response)!
            return output
        }
    }
}
