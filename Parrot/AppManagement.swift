import Foundation

/* TODO: Finish Semver comparison and handle app update mechanism. */
let SEMVER_REGEX = "\\bv?(?:0|[1-9][0-9]*)\\.(?:0|[1-9][0-9]*)\\.(?:0|[1-9][0-9]*)(?:-[\\da-z\\-]+(?:\\.[\\da-z\\-]+)*)?(?:\\+[\\da-z\\-]+(?:\\.[\\da-z\\-]+)*)?\\b"

public struct GithubRelease {
	public let releaseName: String
	public let buildTag: String
	public let releaseNotes: String
	public let appUpdateURL: URL
	public let githubURL: URL
	
	/// Must have the "GithubRepository" Info.plist key set to "owner/repo" format!
	/// Uses the CFBuildVersion key to check against the build tag.
	///
	/// Note: This could be prone to malware if the key is modified later by malicious
	/// tools, but also can be updated manually in case your GitHub repo changes.
	public static func latest(prerelease: Bool = false) -> GithubRelease? {
		func _url(repo: String, latest: Bool = true) -> URL {
			return URL(string: "https://api.github.com/repos/\(repo)/releases" + (latest ? "/latest" : ""))!
		}
		
		func _get(_ url: URL, method: String = "GET") -> (Data?, URLResponse?, NSError?) {
			return URLSession.shared().synchronousRequest(url, method: method)
		}
		
		guard let repo = Bundle.main().infoDictionary?["GithubRepository"] as? String else { return nil }
		let url = _url(repo: repo, latest: !prerelease)
		
		// Ensure we can both download and deserialize the response.
		guard	let data = _get(url).0,
				var json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
		else { return nil }
		
		// If we're in pre-release mode, ensure we have at least one entry.
		if prerelease && json[0] != nil {
			json = json[0]!
		} else { return nil }
		
		guard	let releaseName = json["name"] as? String,
				let buildTag = json["tag_name"] as? String,
				let releaseNotes = json["body"] as? String,
				let appUpdate = json["zipball_url"] as? String,
				let githubURL = json["url"] as? String
		else { return nil }
		
		return GithubRelease(releaseName: releaseName, buildTag: buildTag,
		                     releaseNotes: releaseNotes, appUpdateURL: URL(string: appUpdate)!,
		                     githubURL: URL(string: githubURL)!)
	}
}

public struct Semver {
	// X.Y.Z
	public let x: UInt
	public let y: UInt
	public let z: UInt
	// X.Y.Z-prerelease
	public let p: String
	// X.Y.Z+metadata
	public let m: String
	
	public static func compare(_ lhs: Semver, _ rhs: Semver) -> ComparisonResult {
		if lhs.x > rhs.x {
			return .orderedAscending
		} else if lhs.y > rhs.y {
			return .orderedAscending
		} else if lhs.z > rhs.z {
			return .orderedAscending
		}
		// handle .orderedDescending
		return .orderedSame
	}
}

// For testing UI updates later.
public func __test() {
	let release = GithubRelease.latest(prerelease: true)
	let n = NSUserNotification()
	n.hasActionButton = true
	n.title = "Parrot \(release!.releaseName) available"
	n.actionButtonTitle = "Update"
	n.identifier = "com.avaidyam.Parrot.UpdateNotification"
	n.informativeText = release!.releaseNotes
	UserNotificationCenter.deliver(n)
	print(release)
}
