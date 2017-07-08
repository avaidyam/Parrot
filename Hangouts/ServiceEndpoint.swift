import Foundation

internal enum ServiceResult<T: ServiceResponse> {
    case success(T)
    case failure(Error)
}

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
    
    /*
    internal func execute<T: ServiceEndpoint>(_ endpoint: T.Type, with request: T.Request, handler: @escaping (ServiceResult<T.Response>) -> ()) {
        do {
            var request = request // shadow
            request.request_header = RequestHeader.header(for: self.client_id)
            let input: Any = try PBLiteEncoder().encode(request)
            self.channel?.request(endpoint: endpoint.location, body: input, use_json: false) { r in
                guard let response = r.data else {
                    return handler(.failure(r.error ?? NSError(domain: "", code: 0, userInfo: nil)))
                }
                
                do {
                    let output: T.Response = try PBLiteDecoder().decode(response)
                    handler(.success(output))
                } catch(let error) {
                    handler(.failure(error))
                }
            }
        } catch(let error) {
            handler(.failure(error))
        }
    }
    */
    
    internal func execute<T: ServiceEndpoint>(_ endpoint: T.Type, with request: T.Request,
                                              handler: @escaping (T.Response?, Error?) -> ()) {
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
                    let output: T.Response = try PBLiteDecoder().decode(response)
                    handler(output, nil)
                } catch(let error) {
                    handler(nil, error)
                }
            }
        } catch(let error) {
            handler(nil, error)
        }
    }
    
    internal func execute<T: ServiceEndpoint>(_ endpoint: T.Type, with request: T.Request) throws -> T.Response {
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
