import AppKit

private var _systemSoundsCache = [String]()

/// Access all pre-installed system sounds as a [String].
public extension NSSound {
	public class func systemSounds() -> [String] {
		guard _systemSoundsCache.count > 0 else { return _systemSoundsCache }
		
		let urls = FileManager.default().urlsForDirectory(.libraryDirectory, inDomains: .allDomainsMask)
		for sourcePath in urls {
			let sp = try? sourcePath.appendingPathComponent("Sounds")
			let st = FileManager.default().enumerator(at: sp!, includingPropertiesForKeys: nil, options: [], errorHandler: nil)
			guard let enumerator = st else { continue }
			
			for soundFile in enumerator {
				if	let s1 = soundFile as? URL,
					let s2 = try? s1.deletingPathExtension(),
					let sound = s2.lastPathComponent
					where NSSound(named: sound) != nil {
					_systemSoundsCache.append(sound)
				}
			}
		}
		return _systemSoundsCache
	}
}
