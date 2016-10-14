import Foundation
import class AppKit.NSAlert
import class AppKit.NSTextField

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

// For initial release alerts.
// FIXME: Don't hardcode things.
public func checkForUpdates(_ buildTag: String, _ updateHandler: (GithubRelease) -> Void = {_ in}) {
	guard let release = GithubRelease.latest(prerelease: true) else { return }
	guard release.buildTag == buildTag else { return }
	
	let a = NSAlert()
	a.alertStyle = .informational
	a.messageText = "\(release.releaseName) available"
	a.informativeText = release.releaseNotes
	a.addButton(withTitle: "Update")
	a.addButton(withTitle: "Ignore")
	a.showsSuppressionButton = true // FIXME
	
	a.layout()
	a.window.appearance = ParrotAppearance.interfaceStyle().appearance()
	a.window.enableRealTitlebarVibrancy(.behindWindow) // FIXME
	if a.runModal() == 1000 /*NSAlertFirstButtonReturn*/ {
		updateHandler(release)
	}
}
