import Foundation

private func _githubReleaseURL(owner: String, repo: String, latest: Bool = true) -> URL {
	return URL(string: "https://api.github.com/repos/\(owner)/\(repo)/releases" + (latest ? "/latest" : ""))!
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

public func checkLatestRelease() {
	guard	let data = _getDocument(_githubReleaseURL(owner: "", repo: "")).0,
			let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
	else { return }
	
	print("Release Name: \(json[0]["name"])")
	print("Build Tag: \(json[0]["tag_name"])")
	print("Release Notes: \(json[0]["body"])")
	print("App Update: \(json[0]["zipball_url"])")
	print("GitHub URL: \(json[0]["url"])")
}

