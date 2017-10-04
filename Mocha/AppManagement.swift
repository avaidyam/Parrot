import Foundation

/* TODO: Finish Semver comparison and handle app update mechanism. */

/// Describes a single release of an application hosted on GitHub.
public struct AppRelease {
    
    /// Describes a semantic version of an App.
    /// This should reflect what is stored in the Info.plist file.
    public struct Version: LosslessStringConvertible, Equatable, Comparable {
        
        private static let REGEX = "\\bv?(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(?:\\.(0|[1-9][0-9]*))?-?([\\da-z\\-.]+(?:\\.[\\da-z\\-]+)*)?\\+?([\\da-z\\-]+(?:\\.[\\da-z\\-]+)*)?\\b"
        
        // X.Y.Z
        public let x: UInt
        public let y: UInt
        public let z: UInt
        // X.Y.Z-prerelease
        public let p: String
        // X.Y.Z+metadata
        public let m: String
        
        public init(x: UInt = 0, y: UInt = 0, z: UInt = 0, p: String = "", m: String = "") {
            self.x = x
            self.y = y
            self.z = z
            self.p = p
            self.m = m
        }
        
        public init(_ string: String) {
            let g = string.captureGroups(from: Version.REGEX)
            if g.count <= 0 {
                self.init(); return
            }
            self.init(x: UInt(g[0][1]) ?? 0, y: UInt(g[0][2]) ?? 0, z: UInt(g[0][3]) ?? 0,
                      p: g[0][4], m: g[0][5])
        }
        
        // TODO: this is bad, don't use string funcs
        private static func num(_ str: String) -> Int {
            if str == "" { return 10 } /* no str = not pre-release */
            if str.contains("alpha") { return 1 }
            if str.contains("beta") { return 2 }
            if str.contains("rc") { return 3 }
            return 0
        }
        
        public var description: String {
            var base = "\(self.x).\(self.y).\(self.z)"
            if !p.isEmpty { base += "-\(self.p)" }
            if !m.isEmpty { base += "+\(self.m)" }
            return base
        }
        
        public static func ==(_ lhs: Version, _ rhs: Version) -> Bool {
            let lp = Version.num(lhs.p), rp = Version.num(rhs.p)
            return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lp == rp
        }
        
        public static func <(_ lhs: Version, _ rhs: Version) -> Bool {
            let lp = Version.num(lhs.p), rp = Version.num(rhs.p)
            if lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z && lp >= rp {
                return false
            }
            return true
        }
    }
    
	public let releaseName: String
	public let buildTag: Version
	public let releaseNotes: String
	public let appUpdateURL: URL
	public let githubURL: URL
	
	/// Must have the "GithubRepository" Info.plist key set to "owner/repo" format!
	/// Uses the CFBuildVersion key to check against the build tag.
	///
	/// Note: This could be prone to malware if the key is modified later by malicious
	/// tools, but also can be updated manually in case your GitHub repo changes.
	public static func latest(prerelease: Bool = false) -> AppRelease? {
		func _url(repo: String, latest: Bool = true) -> URL {
			return URL(string: "https://api.github.com/repos/\(repo)/releases" + (latest ? "/latest" : ""))!
		}
		
		func _get(_ url: URL, method: String = "GET") -> (Data?, URLResponse?, Error?) {
			return URLSession.shared.synchronousRequest(url, method: method)
		}
		
		guard let repo = Bundle.main.infoDictionary?["GithubRepository"] as? String else { return nil }
		let url = _url(repo: repo, latest: !prerelease)
		
		// Ensure we can both download and deserialize the response.
		guard	let data = _get(url).0,
				var json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
		else { return nil }
		
		// If we're in pre-release mode, ensure we have at least one entry.
		if let js = json as? [Any], prerelease {
			json = js[0]
		} else if prerelease { return nil }
		
		guard   let _json = json as? [String: Any],
                let releaseName = _json["name"] as? String,
				let buildTag = _json["tag_name"] as? String,
				let releaseNotes = _json["body"] as? String,
				let appUpdate = _json["zipball_url"] as? String,
				let githubURL = _json["html_url"] as? String
		else { return nil }
        
		return AppRelease(releaseName: releaseName, buildTag: Version(buildTag),
		                  releaseNotes: releaseNotes, appUpdateURL: URL(string: appUpdate)!,
		                  githubURL: URL(string: githubURL)!)
	}
    
    // For initial release alerts.
    public static func checkForUpdates(prerelease: Bool = false) -> AppRelease? {
        guard let buildTag = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return nil }
        guard let release = AppRelease.latest(prerelease: prerelease) else { return nil }
        guard release.buildTag > AppRelease.Version(buildTag) else { return nil }
        return release
    }
}
