import Foundation
import XPCTransport
import class Mocha.Logger

public enum AuthenticationInvocation: RespondingMethod {
    public typealias Service = XPCConnection
    public typealias Response = [[String: String]]
    
    public static func package(_ cookies: [HTTPCookie]) -> Response {
        return cookies.map {
            var d = [String: String]()
            for c in ($0.properties ?? [:]) {
                if let str = c.value as? String {
                    d[c.key.rawValue] = str
                } else if let url = c.value as? URL {
                    d[c.key.rawValue] = url.absoluteString
                } else if let date = c.value as? Date {
                    d[c.key.rawValue] = date.description
                }
            }
            return d
        }
    }
    
    public static func unpackage(_ cookies: [[String: String]]) -> [HTTPCookie] {
        return cookies.flatMap {
            let d = $0.map { (HTTPCookiePropertyKey(rawValue: $0.key), $0.value) }
            return HTTPCookie(properties: Dictionary(uniqueKeysWithValues: d))
        }
    }
}

public enum SendLogInvocation: RequestingMethod {
    public typealias Service = XPCConnection
    public typealias Request = Logger.LogUnit
}

/*
public struct GenericMethod: RequestingRespondingThrowingMethod, Codable, Error {
    public typealias Service = XPCConnection
    public typealias Request = UntypedMethod
    public typealias Response = UntypedMethod
    public typealias Error = UntypedMethod
    
    var value: [String: String]
}
*/
