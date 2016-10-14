import AppKit

/* TODO: Create a dictionary mapping of names --> disk URLs for TLToneManager. */
/* TODO: Migrate framework resources into our bundle if requested. */

public extension NSSound {
	public typealias Path = String
	
	/// Access all pre-installed system sounds as a dictionary of sound names
	/// to their on-disk file URLs.
	@nonobjc
	public static var systemSounds: [String: Path] = {
		var _systemSoundsCache = [String: Path]()
		let library = "/System/Library/Sounds"
		let sounds = FileManager.default.deepSearch(path: library).filter { $0.conformsToUTI(kUTTypeAudio) }
		for s in sounds {
			let name = ((s as NSString).deletingPathExtension as NSString).lastPathComponent
			_systemSoundsCache[name] = s
		}
		return _systemSoundsCache
	}()
	
	/// Access all pre-installed ToneLibrary alert tones as a dictionary of tone
	/// names to their on-disk file URLs.
	///
	/// Note: ToneLibrary is a private iOS/macOS framework and apps using this code
	/// will not be allowed on either App Store, and is subject to failure in 
	/// later releases.
	@nonobjc
	public static var alertTones: [String: Path] = {
		var _alertToneCache = [String: Path]()
		let library = "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources"
		let tones = FileManager.default.deepSearch(path: library).filter { $0.conformsToUTI(kUTTypeAudio) }
		for t in tones {
			let name = ((t as NSString).deletingPathExtension as NSString).lastPathComponent
			if t.contains("AlertTones") {
				_alertToneCache[name] = t
			}
		}
		return _alertToneCache
	}()
	
	/// Access all pre-installed ToneLibrary ringtones as a dictionary of ringtone
	/// names to their on-disk file URLs.
	///
	/// Note: ToneLibrary is a private iOS/macOS framework and apps using this code
	/// will not be allowed on either App Store, and is subject to failure in
	/// later releases.
	@nonobjc
	public static var ringTones: [String: Path] = {
		var _ringToneCache = [String: Path]()
		let library = "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources"
		let tones = FileManager.default.deepSearch(path: library).filter { $0.conformsToUTI(kUTTypeAudio) }
		for t in tones {
			let name = ((t as NSString).deletingPathExtension as NSString).lastPathComponent
			if t.contains("Ringtones") {
				_ringToneCache[name] = t
			}
		}
		return _ringToneCache
	}()
}

public extension String {
	
	/// Verify that the path extension of @{path} matches the UTI provided.
	/// Note that this is actually a terrible idea and should be replaced by
	/// a separate UTI class wrapper.
	public func conformsToUTI(_ UTI: CFString) -> Bool {
		let ext = (self as NSString).pathExtension
		let fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext as CFString, nil)!.takeRetainedValue()
		return UTTypeConformsTo(fileUTI, UTI)
	}
}

public extension FileManager {
	
	/// Deep search a directory and return a set of files only, contained within
	/// itself or any subdirectories (and down the rabbit hole).
	public func deepSearch(path: String) -> [String] {
		func _fileIsDir(_ file: String) -> Bool {
			var isDir: ObjCBool = false;
			FileManager.default.fileExists(atPath: file, isDirectory: &isDir)
			return isDir.boolValue
		}
		func _fileFix(_ path: String, _ file: String) -> String {
			return (path as NSString).appendingPathComponent(file) as String
		}
		
		let _files = try? FileManager.default.contentsOfDirectory(atPath: path)
		guard let files = _files else { return [] }
		return files
			.map { _fileFix(path, $0) }
			.flatMap { _fileIsDir($0) ? deepSearch(path: $0) : [$0] }
	}
}
