import Foundation
import XPCTransport
import class Mocha.Logger

public enum AuthenticationInvocation: RemoteMethod {
    //public typealias Service = XPCConnection
    public typealias Request = Void
    public typealias Response = [[String: String]]
    public typealias Error = Void
    
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

public enum SendLogInvocation: RemoteMethod {
    //public typealias Service = XPCConnection
    public typealias Request = Logger.LogUnit
    public typealias Response = Void
    public typealias Error = Void
}

public enum LogOutInvocation: RemoteMethod {
    //public typealias Service = XPCConnection
    public typealias Request = Void
    public typealias Response = Void
    public typealias Error = Void
}

/*
public struct GenericMethod: RemoteMethod, Codable, Error {
    //public typealias Service = XPCConnection
    public typealias Request = Void
    public typealias Response = Void
    public typealias Error = Void
    
    var value: [String: String]
}
*/
