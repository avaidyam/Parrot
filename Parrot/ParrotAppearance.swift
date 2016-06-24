import AppKit

/* TODO: Refactor this into four modes: [Classic, Light, Dark, System] */

/// ParrotAppearance controls all user interface constructs (style, theme,
/// mode, etc.) at runtime. It cannot be instantiated.
public struct ParrotAppearance {
	private init() {}
	private static var _cachedAppearance: String = ParrotAppearance.current()
	private static var _listeners = [AppearanceListener]()
	
	/// Trampolines the distributed notification sent when the user changes interface styles
	/// into a locally stored default that can be observed normally.
	private static let registerDarkModeActiveListener: NSObjectProtocol = {
		DistributedNotificationCenter.default().addObserver(forName: NSNotification.Name("AppleInterfaceThemeChangedNotification"), object: nil, queue: nil) { n in
			let style = UserDefaults.standard().persistentDomain(forName: UserDefaults.globalDomain)?["AppleInterfaceStyle"]
			let dark = (style != nil) && (style as? NSString != nil) && (style!.caseInsensitiveCompare("dark") == .orderedSame)
			Settings[Parrot.SystemInterfaceStyle] = dark
		}
	}()
	
	/// Trampolines the UserDefaults.didChangeNotification notification and triggers any
	/// registered listeners IFF the appearance has changed. [KVO doesn't work with UserDefaults.]
	private static let registerNotificationChangeListener: NSObjectProtocol = {
		NotificationCenter.default().addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil) { n in
			let current = ParrotAppearance.current()
			if _cachedAppearance != current {
				_cachedAppearance = current
				
				_listeners.filter { $0.object != nil }.forEach {
					$0.handler(NSAppearance(named: current)!)
				}
			}
		}
	}()
	
	/// Wraps the object and handler into a single container.
	private class AppearanceListener {
		weak var object: AnyObject?
		let handler: (NSAppearance) -> Void
		private required init(object: AnyObject, handler: (NSAppearance) -> Void) {
			self.object = object
			self.handler = handler
		}
	}
	
	/// Returns the currently indicated Parrot appearance based on user preference
	/// and if applicable, the global dark interface style preference (trampolined).
	public static func current() -> String {
		let dark = Settings[Parrot.DarkAppearance] as? Bool ?? false
		let auto = Settings[Parrot.AutomaticDarkAppearance] as? Bool ?? false
		let appleDark = Settings[Parrot.SystemInterfaceStyle] as? Bool ?? false
		
		guard dark else {
			return NSAppearanceNameVibrantLight
		}
		if auto {
			return (appleDark ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
		}
		return NSAppearanceNameVibrantDark
	}
	
	/// Register a listener to be invoked when the application appearance changes.
	/// Note: this should be done when a view appears on-screen.
	public static func registerAppearanceListener(observer: AnyObject, handler: (NSAppearance) -> Void) {
		_ = registerDarkModeActiveListener
		_ = registerNotificationChangeListener
		_listeners.append(AppearanceListener(object: observer, handler: handler))
	}
	
	/// Unregister a previously registered listener.
	/// Note: this should be done when a view disappears from the screen.
	public static func unregisterAppearanceListener(observer: AnyObject) {
		for (i, l) in _listeners.enumerated() {
			if l.object === observer {
				_listeners.remove(at: i)
				break;
			}
		}
	}
}
