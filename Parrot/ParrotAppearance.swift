import AppKit

/// ParrotAppearance controls all user interface constructs (style, theme,
/// mode, etc.) at runtime. It cannot be instantiated.
public struct ParrotAppearance {
	private init() {}
	private static var _cachedAppearance: String = ParrotAppearance._current()
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
			let current = ParrotAppearance._current()
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
	
	///
	/// PUBLIC:
	///
	
	public enum InterfaceStyle: Int {
		/// Vibrant Light theme.
		case Light
		/// Vibrant Dark theme.
		case Dark
		/// System-defined vibrant theme.
		case System
	}
	
	public enum WindowInteraction: Int {
		/// App windows can be tabbed.
		case Tabbed
		/// App windows can be docked.
		case Docking
	}
	
	public enum InterfaceMode: Int {
		///
		case MasterDetail
		///
		case InlineExpansion
		/// Sidebar for all conversations, content has a single conversation.
		case SplitView
		///
		case PopoverDetail
		///
		case OverlayBubble
	}
	
	/// Returns the currently indicated Parrot appearance based on user preference
	/// and if applicable, the global dark interface style preference (trampolined).
	private static func _current() -> String {
		let style = InterfaceStyle(rawValue: Settings[Parrot.InterfaceStyle] as? Int ?? -1) ?? .Dark
		
		switch style {
		case .Light: return NSAppearanceNameVibrantLight
		case .Dark: return NSAppearanceNameVibrantDark
			
		case .System:
			let system = Settings[Parrot.SystemInterfaceStyle] as? Bool ?? false
			return (system ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight)
		}
	}
	
	public static func current() -> NSAppearance {
		return NSAppearance(named: _current())!
	}
	
	/// Register a listener to be invoked when the application appearance changes.
	/// If invokeImmediately is true, the handler will be invoked immediately.
	/// This is useful in case appearance update logic is unified and can be streamlined.
	/// Note: this should be done when a view appears on-screen.
	public static func registerAppearanceListener(observer: AnyObject, invokeImmediately: Bool = false, handler: (NSAppearance) -> Void) {
		_ = registerDarkModeActiveListener; _ = registerNotificationChangeListener // SETUP
		_listeners.append(AppearanceListener(object: observer, handler: handler))
		if invokeImmediately {
			handler(ParrotAppearance.current())
		}
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

public extension NSWindow {
	public func enableRealTitlebarVibrancy() {
		let t = self.standardWindowButton(.closeButton)?.superview as? NSVisualEffectView
		t?.material = .appearanceBased
	}
}
