import AppKit

/* TODO: Support pattern-based haptic feedback. */

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
		case automaticDockBadge
	}
	
	public func set(option: AuxOptions, value: AnyObject) {
		if self.userInfo == nil { self.userInfo = [:] }
		self.userInfo?[option.rawValue] = value
	}
	
	public func get(option: AuxOptions) -> AnyObject? {
		return self.userInfo?[option.rawValue]
	}
}

public extension NSUserNotificationCenter {
	
	public func updateDockBadge(_ count: Int) {
		NSApp.dockTile.badgeLabel = count > 0 ? "\(count)" : nil
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
				self.removeDeliveredNotification(n)
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
