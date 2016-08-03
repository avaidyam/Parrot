import AppKit

/* TODO: Support pattern-based haptic feedback. */
/* TODO: Support NSApp.dockTileBadge better, as the number of outstanding notifications. */

public typealias UserNotification = NSUserNotification

/// Customized NSUserNotificationCenter with easier access.
public let UserNotificationCenter: NSUserNotificationCenter = {
	let s = NSUserNotificationCenter.default()
	s.delegate = s; return s
}()

public extension NSUserNotification {
	
	@nonobjc public static let didDeliverNotification = Notification.Name("NSUserNotification.didDeliverNotification")
	@nonobjc public static let didActivateNotification = Notification.Name("NSUserNotification.didActivateNotification")
	
	/// Provide a key below in the userInfo of an NSUserNotification when used with the
	/// NotificationManager, regardless of the value, and that feature will be enabled.
	public enum AuxOptions: String {
		case alwaysShow
		case customSoundPath
		case vibrateForceTouch
		case requestUserAttention
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
}

public extension NSUserNotificationCenter {
	
	public func updateDockBadge(_ count: Int) {
		NSApp.dockTile.badgeLabel = count > 0 ? "\(count)" : nil
	}
	
	public func notifications(includeDelivered: Bool = true, includeScheduled: Bool = false) -> [NSUserNotification] {
		var notes = [NSUserNotification]()
		if includeDelivered {
			notes += self.deliveredNotifications
		}
		if includeScheduled {
			notes += self.scheduledNotifications
		}
		return notes
	}
	
	public func indexedNotifications(includeDelivered d: Bool = true, includeScheduled s: Bool = false) -> [String: NSUserNotification] {
		let notes = self.notifications(includeDelivered: d, includeScheduled: s)
		var indexed = [String: NSUserNotification]()
		notes.forEach { indexed[$0.identifier ?? ""] = $0 }
		_ = indexed.removeValue(forKey: "") // remove unidentified notifications.
		return indexed
	}
	
	public func post(notification: NSUserNotification, schedule: Bool = false) {
		if schedule {
			self.scheduleNotification(notification)
		} else {
			self.deliver(notification)
		}
	}
	
	public func remove(notification: NSUserNotification, scheduled: Bool = false) {
		if scheduled {
			self.removeScheduledNotification(notification)
		} else {
			self.removeDeliveredNotification(notification)
		}
	}
	
	public func remove(byIdentifier id: String, scheduled: Bool = false) {
		for n in (scheduled ? self.scheduledNotifications : self.deliveredNotifications) {
			if n.identifier == id {
				self.remove(notification: n, scheduled: scheduled)
			}
		}
	}
	
	public func post(notifications: [NSUserNotification], schedule: Bool = false) {
		notifications.forEach { self.post(notification: $0, schedule: schedule) }
	}
	
	public func remove(notifications: [NSUserNotification], scheduled: Bool = false) {
		notifications.forEach { self.remove(notification: $0, scheduled: scheduled) }
	}
	
	public func remove(byIdentifiers ids: [String], scheduled: Bool = false) {
		ids.forEach { self.remove(byIdentifier: $0, scheduled: scheduled) }
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
