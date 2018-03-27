import Foundation

/* TODO: In the future, more Analytics providers may be supported. */

/// portions from @ksmandersen: https://github.com/ksmandersen/GoogleReporter/blob/swift-4/GoogleReporter.swift
public struct AppProperties {
    private init() {}
    
    public static var uniqueUserIdentifier: String = {
        /*static*/ let identifierKey = "com.google.analytics.identifier"
        var value = CFPreferencesCopyValue(identifierKey as CFString,
                                           kCFPreferencesAnyApplication, kCFPreferencesCurrentUser,
                                           kCFPreferencesCurrentHost) as? String
        if value == nil {
            value = UUID().uuidString
            CFPreferencesSetValue(identifierKey as CFString,
                                  value! as CFString, kCFPreferencesAnyApplication,
                                  kCFPreferencesCurrentUser, kCFPreferencesCurrentHost)
            CFPreferencesSynchronize(kCFPreferencesAnyApplication, kCFPreferencesCurrentUser,
                                     kCFPreferencesCurrentHost)
        }
        return value!
    }()
    
    public static var userAgent: String = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let versionString = osVersion.replacingOccurrences(of: ".", with: "_")
        return "Mozilla/5.0 (Macintosh; Intel Mac OS X \(versionString)) AppleWebKit/603.2.4 (KHTML, like Gecko) \(AppProperties.appName)/\(AppProperties.appVersion)"
    }()
    
    public static var appName: String = {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "(unknown)"
    }()
    
    public static var appIdentifier: String = {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? "(unknown)"
    }()
    
    public static var appVersion: String = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "(unknown)"
    }()
    
    public static var appBuild: String = {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "(unknown)"
    }()
    
    public static var formattedVersion: String = {
        return "\(AppProperties.appVersion) (\(AppProperties.appBuild))"
    }()
    
    public static var userLanguage: String = {
        guard let locale = Locale.preferredLanguages.first, locale.count > 0
        else { return "(unknown)" }
        return locale
    }()
    
    /*
    public static var screenResolution: String = {
        let size = NSScreen.main?.frame.size ?? .zero
        return "\(size.width)x\(size.height)"
    }()
    */
}

/// GoogleAnalytics enables tracking events using the [Google Analytics Measurement
/// protocol](https://developers.google.com/analytics/devguides/collection/protocol/v1/reference).
/// - Note: A valid Google Analytics tracker ID must be set first.
public struct GoogleAnalytics {
    private init() {}
    
    public struct Screen: RawRepresentable, Equatable, Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        public init(_ rawValue: String) { self.rawValue = rawValue }
    }
    
    public struct Category: RawRepresentable, Equatable, Hashable {
        public let rawValue: String
        public init(rawValue: String) { self.rawValue = rawValue }
        public init(_ rawValue: String) { self.rawValue = rawValue }
    }
    
    /// Sent on session start and end.
    public static var sessionParameters: [String: String] = [:]
    
    /// A valid Google Analytics tracker ID of form UA-XXXXX-XX.
    /// Configures the reporter with a Google Analytics Identifier (Tracker ID).
    /// The token can be obtained from the admin page of the tracked Google Analytics entity.
    /// When setting to a non-nil value, a session is started, and it is ended
    /// when set to nil once again.
    public static var sessionTrackingIdentifier: String? {
        willSet {
            guard newValue == nil else { return } // end the session
            self.send(type: nil, parameters: sessionParameters.merging([
                "sc": "end",
                "dp": AppProperties.appName,
            ]){$1})
        }
        didSet {
            guard self.sessionTrackingIdentifier != nil else { return } // start the session
            self.send(type: nil, parameters: sessionParameters.merging([
                "sc": "start",
                "dp": AppProperties.appName,
            ]){$1})
        }
    }
    
    /// Tracks a screen view.
    public static func view(screen: Screen, parameters: [String: String] = [:]) {
        guard let _ = self.sessionTrackingIdentifier else { return }
        self.send(type: "screenView", parameters: parameters.merging([
            "cd": screen.rawValue
        ]){$1})
    }
    
    /// Tracks an event.
    public static func event(in category: Category, action: String, label: String = "",
                             parameters: [String: String] = [:]) {
        guard let _ = self.sessionTrackingIdentifier else { return }
        self.send(type: "event", parameters: parameters.merging([
            "ec": category.rawValue,
            "ea": action,
            "el": label
        ]){$1})
    }
    
    /// Tracks an error.
    public static func error<T: Error>(_ error: T, parameters: [String: String] = [:]) {
        self._error(error, false, parameters)
    }
    
    /// Tracks a fatal error.
    public static func fatalError<T: Error>(_ error: T, parameters: [String: String] = [:]) {
        self._error(error, true, parameters)
    }
    
    private static func _error<T: Error>(_ error: T, _ fatal: Bool, _ parameters: [String: String] = [:]) {
        guard let _ = self.sessionTrackingIdentifier else { return }
        
        var parameters = parameters
        if let error = error as? LocalizedError {
            parameters.merge([
                NSLocalizedDescriptionKey: error.errorDescription ?? "",
                NSLocalizedFailureReasonErrorKey: error.failureReason ?? "",
                ]){$1}
        }
        
        self.send(type: "exception", parameters: parameters.merging([
            "exd": error.localizedDescription,
            "exf": String(fatal)
        ]){$1})
    }
    
    private static func send(type: String?, parameters: [String: String]) {
        guard let sessionTrackingIdentifier = sessionTrackingIdentifier else { return }
        
        var arguments: [String: String] = [
            "tid": sessionTrackingIdentifier,
            "aid": AppProperties.appIdentifier,
            "cid": AppProperties.uniqueUserIdentifier,
            "an": AppProperties.appName,
            "av": AppProperties.formattedVersion,
            "ua": AppProperties.userAgent,
            "ul": AppProperties.userLanguage,
            //"sr": AppProperties.screenResolution,
            "v": "1"
        ]
        if let type = type, !type.isEmpty {
            arguments.updateValue(type, forKey: "t")
        }

        let path = arguments.merging(parameters){$1}.map {
            "\($0)=\($1.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)"
        }.joined(separator: "&")
        
        let baseURL = URL(string: "https://www.google-analytics.com/")!
        guard let url = URL(string: "collect?" + path, relativeTo: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { _, _, err in
            if err != nil {
                print("Failed to submit analytics event [\(err!)]: ", err!.localizedDescription)
            }
        }.resume()
    }
}

public typealias Analytics = GoogleAnalytics
