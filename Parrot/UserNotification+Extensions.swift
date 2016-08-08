import AppKit

/* TODO: Support pattern-based haptic feedback. */
/* TODO: Support NSApp.dockTileBadge better, as the number of outstanding notifications. */

public typealias UserNotification = NSUserNotification

/// Customized NSUserNotificationCenter with easier access.
private let UserNotificationCenter: NSUserNotificationCenter = {
	let s = NSUserNotificationCenter.default()
	s.delegate = s; return s
}()

public extension NSUserNotification {
	
	/// Provide a key below in the userInfo of an NSUserNotification when used with the
	/// NotificationManager, regardless of the value, and that feature will be enabled.
	public enum AuxOptions: String {
		case alwaysShow
		case customSoundPath
		case vibrateForceTouch
		case requestUserAttention
		case speakContents
	}
	
	public func set(option: AuxOptions, value: AnyObject) {
		if self.userInfo == nil { self.userInfo = [:] }
		self.userInfo?[option.rawValue] = value
	}
	
	public func get(option: AuxOptions) -> AnyObject? {
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
	
	/// If `badgeCount` is set, the notification will trigger the badge count to be set.
	public var badgeCount: Int {
		get { return self.value(forKey: "_badgeCount") as? Int ?? 0 }
		set { self.setValue(newValue, forKey: "_badgeCount") }
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

private var _appProgress: Double?
public extension NSApplication {
	public var badgeCount: Int? {
		get { return Int(NSApp.dockTile.badgeLabel ?? "") }
		set { NSApp.dockTile.badgeLabel = newValue != nil ? "\(newValue!)" : nil }
	}
	public var appProgress: Double? {
		get { return _appProgress }
		set { _appProgress = (newValue >= 0.0 && newValue <= 1.0 ? newValue : nil) ;
			
			let progress = _appProgress != nil ? _appProgress! : -1.0
			NSApp.perform(Selector(("_displayProgressNotification:isIndeterminate:")),
			              with: progress, with: false)
		}
	}
}

extension NSUserNotificationCenter: NSUserNotificationCenterDelegate {
	public func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
		NotificationCenter.default().post(name: UserNotification.didDeliverNotification, object: notification)
		guard notification.isPresented else { return }
		
		if let alert = notification.get(option: .customSoundPath) as? String {
			guard alert.conformsToUTI(kUTTypeAudio) else { return }
			NSSound(contentsOfFile: alert, byReference: true)?.play()
		}
		
		if let s = notification.get(option: .vibrateForceTouch) as? Bool where s {
			let vibrate = Settings[Parrot.VibrateForceTouch] as? Bool ?? false
			let interval = Settings[Parrot.VibrateInterval] as? Int ?? 10
			let length = Settings[Parrot.VibrateLength] as? Int ?? 1000
			if vibrate { NSHapticFeedbackManager.vibrate(length: length, interval: interval) }
		}
		
		if let r = notification.get(option: .requestUserAttention) as? NSRequestUserAttentionType {
			NSApp.requestUserAttention(r)
		}
		
		if let s = notification.get(option: .speakContents) as? Bool where s {
			let text = (notification.title ?? "") + (notification.subtitle ?? "") + (notification.informativeText ?? "")
			NSApp.perform(Selector(("speakString:")), with: text)
		}
	}
	
	public func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
		NotificationCenter.default().post(name: UserNotification.didActivateNotification, object: notification)
	}
	
	public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
		return notification.get(option: .alwaysShow) != nil
	}
}

public extension NSHapticFeedbackManager {
	public static func vibrate(length: Int = 1000, interval: Int = 10) {
		let hp = NSHapticFeedbackManager.defaultPerformer()
		for _ in 1...(length/interval) {
			hp.perform(.generic, performanceTime: .now)
			usleep(UInt32(interval * 1000))
		}
	}
}
