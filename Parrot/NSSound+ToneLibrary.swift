import AppKit

private var _systemSoundsCache = [String]()
private var _toneLibraryCache = [URL]()

/// Access all pre-installed system sounds as a [String].
public extension NSSound {
	public class func systemSounds() -> [String] {
		guard _systemSoundsCache.count == 0 else { return _systemSoundsCache }
		
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
	
	public class func toneLibrarySounds() -> [URL] {
		guard _toneLibraryCache.count == 0 else { return _toneLibraryCache }
		
		let toneLibrary = "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources"
		let tones = _deepSearch(path: toneLibrary)
			.filter { _conformsToUTI(path: $0, UTI: kUTTypeAudio) }
		
		print("\(tones.map { ($0 as NSString).lastPathComponent })")
		return _toneLibraryCache
	}
}

/// Verify that the path extension of @{path} matches the UTI provided.
internal func _conformsToUTI(path: String, UTI: CFString) -> Bool {
	let ext = (path as NSString).pathExtension
	let fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil)!.takeRetainedValue()
	return UTTypeConformsTo(fileUTI, UTI)
}

/// Deep search a directory and return a set of files only, contained within
/// itself or any subdirectories (and down the rabbit hole).
internal func _deepSearch(path: String) -> [String] {
	func _fileIsDir(_ file: String) -> Bool {
		var isDir: ObjCBool = false;
		FileManager.default().fileExists(atPath: file, isDirectory: &isDir)
		return Bool(isDir);
	}
	
	func _fileFix(_ path: String, _ file: String) -> String {
		return (path as NSString).appendingPathComponent(file) as String
	}
	
	let _files = try? FileManager.default().contentsOfDirectory(atPath: path)
	guard let files = _files else { return [] }
	return files
		.filter { !$0.hasSuffix(".lproj") } // eh, could be removed...
		.map { _fileFix(path, $0) }
		.flatMap { _fileIsDir($0) ? _deepSearch(path: $0) : [$0] }
}

