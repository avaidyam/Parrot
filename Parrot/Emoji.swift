import Foundation

private var emojiDescriptors: [String: String] = {
	guard let url = Bundle.main().urlForResource("emoji_descriptors", withExtension: "plist") else { return [:] }
	return NSDictionary(contentsOf: url) as? [String: String] ?? [:]
}()

private var emoticonDescriptors: [String: String] = {
	guard let url = Bundle.main().urlForResource("emoticon_descriptors", withExtension: "plist") else { return [:] }
	return NSDictionary(contentsOf: url) as? [String: String] ?? [:]
}()

private let emojiDescriptorRegex = try! RegularExpression(pattern: "(?<=[\\s]|^)(:[a-z0-9-+_]+:)(?=[\\s]|$)",
                                                          options: .caseInsensitive)

public extension String {
	
	/// Replace a Unicode Emoji descriptor (:emoji_name:) with its pictographical representation.
	public func applyGithubEmoji() -> String {
		var resultText = self
		emojiDescriptorRegex.enumerateMatches(in: self, options: .reportCompletion,
		                                      range: NSMakeRange(0, self.characters.count)) { result, flags, stop in
				if ((result != nil) && (result!.resultType == .regularExpression)) {
					let range = result!.range
					if (range.location != NSNotFound) {
						let str2 = (self as NSString).substring(with: range).replacingOccurrences(of: ":", with: "")
						let code = str2, unicode = emojiDescriptors[code]
						if !unicode!.isEmpty {
							resultText = resultText.replacingOccurrences(of: code, with:unicode!, options: [], range: nil)
						}
					}
				}
		}
		return resultText
	}
	
	/// Replace a GMail-style emoticon (:D) with its pictographical representation.
	public func applyGoogleEmoji() -> String {
		return emoticonDescriptors.reduce(self) {
			($0 as NSString).replacingOccurrences(of: $1.0, with: $1.1)
		}
	}
}

public extension UnicodeScalar {
	
	/// Detect whether this particular UnicodeScalar represents a Unicode Emoji.
	public var isEmoji: Bool {
		switch self.value { case
		
		0x1F300...0x1F5FF, // Miscellaneous Symbols and Pictographs
		0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
		0x1F600...0x1F64F, // Emoticons
		0x1F680...0x1F6FF, // Transport and Map Symbols
		0x2600...0x26FF,   // Miscellaneous Symbols
		0x2700...0x27BF,   // Dingbats
		0xFE00...0xFE0F:   // Variation Selectors
			
			return true
		default: return false
		}
	}
}

public extension String {
	
	/// Detect whether this String contains UnicodeScalars that are Emoji.
	public var containsEmoji: Bool {
		return self.unicodeScalars.lazy.map { $0.isEmoji }.filter { $0 == true }.count > 0
	}
	
	/// Detect whether this String consists completely of UnicodeScalars that are Emoji.
	public var isEmoji: Bool {
		return self.unicodeScalars.lazy.map { $0.isEmoji }.filter { $0 == false }.count == 0
	}
}
