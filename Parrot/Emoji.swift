import Foundation

private var emojiDescriptors: [String: String] = {
	guard let url = Bundle.main.url(forResource: "emoji_descriptors",
	                                             withExtension: "plist")
		else { return [:] }
	return NSDictionary(contentsOf: url) as? [String: String] ?? [:]
}()

internal var emoticonDescriptors: [String: String] = {
	guard let url = Bundle.main.url(forResource: "emoji_emoticons",
	                                             withExtension: "plist",
	                                             subdirectory: "Emoji")
		else { return [:] }
	return NSDictionary(contentsOf: url) as? [String: String] ?? [:]
}()

private let emojiDescriptorRegex = try! NSRegularExpression(pattern: "(?<=[\\s]|^)(:[a-z0-9-+_]+:)(?=[\\s]|$)",
                                                            options: .caseInsensitive)

public extension String {
	
	/// Replace a Unicode Emoji descriptor (:emoji_name:) with its pictographical representation.
	public func applyGithubEmoji() -> String {
		let resultText = self
		/*emojiDescriptorRegex.enumerateMatches(in: self, options: .reportCompletion,
		                                      range: NSMakeRange(0, self.endIndex)) { result, flags, stop in
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
		}*/
		return resultText
	}
	
	/// Replace a GMail-style emoticon (:D) with its pictographical representation.
	public func applyGoogleEmoji() -> String {
		var str = self
		for (emoticon, emoji) in emoticonDescriptors {
			str = str.replacingOccurrences(of: " \(emoticon) ", with: " \(emoji) ")
		}
		return str
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

public extension CharacterSet {
	
	///
	public static var emojiCharacters: CharacterSet? {
		guard	let url = Bundle.main.url(forResource: "emoji_charset", withExtension: "bitmap"),
				let data = try? Data(contentsOf: url)
		else { return nil }
		return CharacterSet(bitmapRepresentation: data)
	}
	
	///
	public func unicodeScalars() -> [UnicodeScalar] {
		var chars = [UnicodeScalar]()
		for plane: UInt8 in 0...16 {
			if self.hasMember(inPlane: plane) {
				for c : UInt32 in UInt32(plane) << 16 ..< (UInt32(plane) + 1) << 16 {
					if (self as NSCharacterSet).longCharacterIsMember(c) {
						var c = c.littleEndian // for byte-order safety
						let e = String.Encoding.utf32LittleEndian.rawValue
						let s = NSString(bytes: &c, length: 4, encoding: e)!
						chars.append(contentsOf: (s as String).unicodeScalars)
					}
				}
			}
		}
		return chars
	}
}
