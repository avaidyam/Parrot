import Foundation

private var githubEmoji: [String: String] = {
	guard let url = Bundle.main().urlForResource("github_emoji", withExtension: "plist") else { return [:] }
	return NSDictionary(contentsOf: url) as? [String: String] ?? [:]
}()

private var googleEmoji: [String: String] = {
	guard let url = Bundle.main().urlForResource("google_emoji", withExtension: "plist") else { return [:] }
	return NSDictionary(contentsOf: url) as? [String: String] ?? [:]
}()

public extension String {
	
	public func applyGithubEmoji() -> String {
		let regex = try! RegularExpression(pattern: "(?<=[\\s]|^)(:[a-z0-9-+_]+:)(?=[\\s]|$)",
			options: RegularExpression.Options.caseInsensitive)
		var resultText = self
		let matchingRange = NSMakeRange(0, resultText.lengthOfBytes(using: String.Encoding.utf8))
		regex.enumerateMatches(in: resultText,
			options: .reportCompletion, range: matchingRange) { result, flags, stop in
				if ((result != nil) && (result!.resultType == .regularExpression)) {
					let range = result!.range
					if (range.location != NSNotFound) {
						let str2 = (self as NSString).substring(with: range)
								.replacingOccurrences(of: ":", with: "")
						let code = str2, unicode = githubEmoji[code]
						if !unicode!.isEmpty {
							resultText = resultText.replacingOccurrences(of: code,
								with:unicode!, options: NSString.CompareOptions(rawValue: 0), range: nil)
						}
					}
				}
		}
		return resultText
	}
	
	public func applyGoogleEmoji() -> String {
		return googleEmoji.reduce(self) {
			($0 as NSString).replacingOccurrences(of: $1.0, with: $1.1)
		}
	}
}
