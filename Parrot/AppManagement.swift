import Foundation

public struct GithubRelease {
	public let releaseName: String
	public let buildTag: String
	public let releaseNotes: String
	public let appUpdateURL: URL
	public let githubURL: URL
}

private func _githubReleaseURL(repo: String, latest: Bool = true) -> URL {
	return URL(string: "https://api.github.com/repos/\(repo)/releases" + (latest ? "/latest" : ""))!
}

private func _getDocument(_ url: URL, method: String = "GET") -> (Data?, URLResponse?, NSError?) {
	var data: Data?, response: URLResponse?, error: NSError?
	let semaphore = DispatchSemaphore(value: 0)
	
	var request = URLRequest(url: url)
	request.httpMethod = method
	URLSession.shared().dataTask(with: request) {
		data = $0; response = $1; error = $2
		semaphore.signal()
		}.resume()
	
	_ = semaphore.wait(timeout: DispatchTime.distantFuture)
	return (data, response, error)
}

// Must have the "GithubRepository" Info.plist key set to "owner/repo" format!
// Uses the CFBuildVersion key to check against the build tag.
public func _checkLatestRelease(prerelease: Bool = false) {
	guard let repo = Bundle.main().infoDictionary?["GithubRepository"] as? String else { return }
	let url = _githubReleaseURL(repo: repo, latest: !prerelease)
	
	// Ensure we can both download and deserialize the response.
	guard	let data = _getDocument(url).0,
			var json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
	else { return }
	
	// If we're in pre-release mode, ensure we have at least one entry.
	if prerelease && json[0] != nil {
		json = json[0]!
	} else { return }
	
	guard	let releaseName = json["name"] as? String,
			let buildTag = json["tag_name"] as? String,
			let releaseNotes = json["body"] as? String,
			let appUpdate = json["zipball_url"] as? String,
			let githubURL = json["url"] as? String
	else { return }
	
	let release = GithubRelease(releaseName: releaseName, buildTag: buildTag,
	                            releaseNotes: releaseNotes, appUpdateURL: URL(string: appUpdate)!,
	                            githubURL: URL(string: githubURL)!)
	
	print("\(release)")
}

