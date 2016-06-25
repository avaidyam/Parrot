import AppKit

private var _systemSoundsCache = [String: String]()
private var _alertToneCache = [String: String]()
private var _ringToneCache = [String: String]()
private var _scannedToneLibrary = false

public extension NSSound {
	public typealias Path = String
	
	/// Access all pre-installed system sounds as a dictionary of sound names 
	/// to their on-disk file URLs.
	public class func systemSounds() -> [String: Path] {
		guard _systemSoundsCache.count == 0 else { return _systemSoundsCache }
		_scanSystemSounds()
		return _systemSoundsCache
	}
	
	/// Access all pre-installed ToneLibrary alerts as a dictionary of tone
	/// names to their on-disk file URLs.
	///
	/// Note: ToneLibrary is a private iOS/macOS framework and apps using this code
	/// will not be allowed on either App Store, and is subject to failure in 
	/// later releases.
	public class func alertTones() -> [String: Path] {
		guard _alertToneCache.count == 0 else { return _alertToneCache }
		_scanToneLibrary()
		return _alertToneCache
	}
	
	/// Access all pre-installed ToneLibrary ringtones as a dictionary of ringtone
	/// names to their on-disk file URLs.
	///
	/// Note: ToneLibrary is a private iOS/macOS framework and apps using this code
	/// will not be allowed on either App Store, and is subject to failure in
	/// later releases.
	public class func ringTones() -> [String: Path] {
		guard _ringToneCache.count == 0 else { return _ringToneCache }
		_scanToneLibrary()
		return _ringToneCache
	}
	
	
	///					///
	///		PRIVATE		///
	///					///
	
	
	/// Peform the scanning process for system builtin sounds.
	private class func _scanSystemSounds() {
		let systemLibrary = "/System/Library/Sounds"
		let sounds = FileManager.default().deepSearch(path: systemLibrary)
			.filter { $0.conformsToUTI(kUTTypeAudio) }
		for s in sounds {
			let name = ((s as NSString).deletingPathExtension as NSString).lastPathComponent
			_systemSoundsCache[name] = s
		}
	}
	
	/// Perform the scanning and separation process for the ToneLibrary.framework tones.
	private class func _scanToneLibrary() {
		let toneLibrary = "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources"
		let tones = FileManager.default().deepSearch(path: toneLibrary)
			.filter { $0.conformsToUTI(kUTTypeAudio) }
		for t in tones {
			var name = ((t as NSString).deletingPathExtension as NSString).lastPathComponent
			if t.contains("AlertTones") {
				// We need to strip the prefix: "sms_alert_" and "calendar_alert_"
				name = name.replacingOccurrences(of: "sms_alert_", with: "")
				name = name.replacingOccurrences(of: "calendar_alert_", with: "")
				
				// We need to de-mangle these names; this is not perfect but does the job.
				let comps = name.components(separatedBy: CharacterSet(charactersIn: "_-"))
				name = comps.dropFirst()
					.map { $0.capitalized }
					.reduce(comps.first!.capitalized) { $0 + " " + $1 }
				
				_alertToneCache[name] = t
			} else if t.contains("Ringtones") {
				_ringToneCache[name] = t
			}
		}
	}
}

public extension String {
	
	/// Verify that the path extension of @{path} matches the UTI provided.
	/// Note that this is actually a terrible idea and should be replaced by
	/// a separate UTI class wrapper.
	public func conformsToUTI(_ UTI: CFString) -> Bool {
		let ext = (self as NSString).pathExtension
		let fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil)!.takeRetainedValue()
		return UTTypeConformsTo(fileUTI, UTI)
	}
}

public extension FileManager {
	
	/// Deep search a directory and return a set of files only, contained within
	/// itself or any subdirectories (and down the rabbit hole).
	public func deepSearch(path: String) -> [String] {
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
			.map { _fileFix(path, $0) }
			.flatMap { _fileIsDir($0) ? deepSearch(path: $0) : [$0] }
	}
}
