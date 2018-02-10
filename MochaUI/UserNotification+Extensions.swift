import AppKit
import Mocha

/* TODO: Support pattern-based haptic feedback. */
/* TODO: Support NSApp.dockTileBadge better, as the number of outstanding notifications. */

public typealias UserNotification = NSUserNotification

/// Customized NSUserNotificationCenter with easier access.
private let UserNotificationCenter: NSUserNotificationCenter = {
	let s = NSUserNotificationCenter.default
	s.delegate = s; return s
}()

public extension NSUserNotification {
	
	/// Provide a key below in the userInfo of an NSUserNotification when used with the
	/// NotificationManager, regardless of the value, and that feature will be enabled.
	public enum Options: String {
		
		/// If this option is set, the notification will always be shown regardless of
		/// whether the application is frontmost or not.
		/// Note: the value of this option must be `true`.
		case alwaysShow
		
		/// If this option is set, the notification will trigger a custom sound to be
		/// played (in addition to the `soundName` property) but locally, from the app.
		/// Note: the value of this option must be the path of the sound as a String.
		case customSoundPath
		
		/// If this option is set, the notification will trigger a haptic feedback response.
		/// Note: the value of this option must be `true`.
		case vibrateForceTouch
		
		/// If this option is set, the notification will cause the app icon to bounce
		/// in the dock, for a limited amount of time.
		/// Note: the value of this option must be `true`.
		case requestUserAttention
		
		/// If this option is set, the contents of the notification (title, subtitle, 
		/// and informational text) will be spoken alound when the notification is presented.
		/// Note: the value of this option must be `true`.
		case speakContents
		
		/// If this option is set, the notification will trigger the execution of
		/// a provided AppleScript file in the app's context.
		/// Note: the value of this option must be the path of the script as a String.
		case runAppleScript
	}
	
	/// Sets the provided option as explained in `NSUserNotification.Options` directly.
	public func set(option: Options, value: Any?) {
		if self.userInfo == nil { self.userInfo = [String: Any]() }
		self.userInfo?[option.rawValue] = value
	}
	
	/// Gets the provided option as explained in `NSUserNotification.Options` directly.
	public func get(option: Options) -> Any? {
		return self.userInfo?[option.rawValue]
	}
}

/// Expose the private NSUserNotification API for identity images, a la iTunes.
public extension NSUserNotification {
	
	/// Describes how the identity image will be styled in the banner.
	public enum IdentityStyle: Int {
		
		/// The image will be drawn with a hairline border.
		case bordered = 0
		
		/// The image will be drawn as is, with no modification.
		case none = 1
		
		/// The image will be cropped to fit a circle.
		case circle = 2
	}
	
	/// The `identityImage` describes the identity of the sender of this notification.
	/// It is displayed where the app icon normally is, if set.
	public var identityImage: NSImage? {
		get { return self.value(forKey: "_identityImage") as? NSImage }
		set { self.setValue(newValue, forKey: "_identityImage") }
	}
	
	/// The `identityStyle` describes how the identityImage will be styled, if set.
	public var identityStyle: IdentityStyle? {
		get { return IdentityStyle(rawValue: self.value(forKey: "_identityImageStyle") as? Int ?? -1) }
		set { self.setValue(newValue?.rawValue, forKey: "_identityImageStyle") }
	}
	
	/// If `alwaysShowsActions` is true, the action buttons will be shown if the app's
	/// notification style is `Banner` if the user hovers over the banner.
	public var alwaysShowsActions: Bool {
		get { return self.value(forKey: "_showsButtons") as? Bool ?? false }
		set { self.setValue(newValue, forKey: "_showsButtons") }
	}
	
	/// If `ignoresDoNotDisturb` is true, the notification will show even if in DND.
	public var ignoresDoNotDisturb: Bool {
		get { return self.value(forKey: "_ignoresDoNotDisturb") as? Bool ?? false }
		set { self.setValue(newValue, forKey: "_ignoresDoNotDisturb") }
	}
	
	/// If `lockscreenOnly` is true, this notification is only shown on the lockscreen.
	public var lockscreenOnly: Bool {
		get { return self.value(forKey: "_lockscreenOnly") as? Bool ?? false }
		set { self.setValue(newValue, forKey: "_lockscreenOnly") }
	}
}

public extension NSUserNotification {
	
	@nonobjc public static let didDeliverNotification = Notification.Name("NSUserNotification.didDeliverNotification")
	@nonobjc public static let didActivateNotification = Notification.Name("NSUserNotification.didActivateNotification")
	
	/// Posts the notification to the user immediately or schedules it.
	public func post(schedule: Bool = false) {
		if schedule {
			UserNotificationCenter.scheduleNotification(self)
		} else {
			UserNotificationCenter.deliver(self)
		}
	}
	
	/// Removes the notification from delivery or scheduling lists entirely.
	public func remove() {
		UserNotificationCenter.removeScheduledNotification(self)
		UserNotificationCenter.removeDeliveredNotification(self)
	}
	
	/// Returns the set of notifications from the delivered or scheduled lists.
	public static func notifications(includeDelivered: Bool = true, includeScheduled: Bool = false) -> [NSUserNotification] {
		var notes = [NSUserNotification]()
		if includeDelivered {
			notes += UserNotificationCenter.deliveredNotifications
		}
		if includeScheduled {
			notes += UserNotificationCenter.scheduledNotifications
		}
		return notes
	}
}

public extension Array where Element == NSUserNotification {
    
    /// Convenience for removing any notifications with a matching identifier.
    public func remove(identifier id: String) {
        self.filter { $0.identifier == id }.forEach { $0.remove() }
    }
}

public extension NSUserNotification {
    
    /// Convenience constructor for a pretty standard notification.
    /// Note: identifier is required in this initializer for notification replacement.
    public convenience init(identifier: String, title: String, subtitle: String? = nil,
                            informativeText: String? = nil, contentImage: NSImage? = nil) {
        self.init()
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.informativeText = informativeText
        self.contentImage = contentImage
    }
}

private var _appProgress: Double?
public extension NSApplication {
    private static var displayProgressNotificationKey = SelectorKey<NSApplication, Double, Bool, Void>("_displayProgressNotification:isIndeterminate:")
    private static var speakKey = SelectorKey<NSApplication, String, Void, Void>("speakString:")
	
	/// Displays a badge count for the app in the Dock with the provided count.
	/// The acceptable range is [1, inf], and anything outside removes the badge.
	public var badgeCount: UInt? {
		get { return UInt(NSApp.dockTile.badgeLabel ?? "") }
		set { NSApp.dockTile.badgeLabel = newValue != nil && newValue! > 1 ? "\(newValue!)" : nil }
	}
	
	/// Displays a progress bar for the app in the Dock with the provided progress
	/// value. Accepts the range [0.0, 1.0], and anything outside removes the bar.
	public var appProgress: Double? {
		get { return _appProgress }
		set { _appProgress = (newValue != nil && (newValue! >= 0.0 && newValue! <= 1.0) ? newValue : nil);
			
			let progress = _appProgress != nil ? _appProgress! : -1.0
            _ = NSApplication.displayProgressNotificationKey[NSApp, with: progress, with: false]
		}
	}
    
    public func say(_ string: String) {
        _ = NSApplication.speakKey[NSApp, with: string, with: nil]
    }
}

extension NSUserNotificationCenter: NSUserNotificationCenterDelegate {
	public func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
		NotificationCenter.default.post(name: UserNotification.didDeliverNotification, object: notification)
		guard notification.isPresented else { return }
		
		if let alert = notification.get(option: .customSoundPath) as? String , alert.conformsToUTI(kUTTypeAudio) {
			NSSound(contentsOfFile: alert, byReference: true)?.play()
		}
		
		if let s = notification.get(option: .vibrateForceTouch) as? Bool , s {
			//let vibrate = Settings["Parrot.VibrateForceTouch"] as? Bool ?? false
			//let interval = Settings["Parrot.VibrateInterval"] as? Int ?? 10
			//let length = Settings["Parrot.VibrateLength"] as? Int ?? 1000
			NSHapticFeedbackManager.vibrate(length: 1000, interval: 10)
		}
		
		if let a = notification.get(option: .runAppleScript) as? String, let url = URL(string: a) {
			_ = try? NSUserAppleScriptTask(url: url).execute(withAppleEvent: nil, completionHandler: nil)
		}
		
        if let r = notification.get(option: .requestUserAttention) as? NSApplication.RequestUserAttentionType {
			NSApp.requestUserAttention(r)
		}
		
		if let s = notification.get(option: .speakContents) as? Bool , s {
			let text = (notification.title ?? "") + (notification.subtitle ?? "") + (notification.informativeText ?? "")
			NSApp.say(text)
		}
	}
	
	public func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
		NotificationCenter.default.post(name: UserNotification.didActivateNotification, object: notification)
	}
	
	public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
		return notification.get(option: .alwaysShow) != nil
	}
}
