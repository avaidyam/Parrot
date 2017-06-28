import AppKit
import Mocha
import MochaUI

/* TODO: Remove NSAppearance from ParrotAppearance and add an extension for it. */

/// ParrotAppearance controls all user interface constructs (style, theme,
/// mode, etc.) at runtime. It cannot be instantiated.
public struct ParrotAppearance {
	private init() {}
	
	private static var _cachedInterfaceStyle = ParrotAppearance.interfaceStyle()
	private static var _interfaceStyleListeners = [InterfaceStyleListener]()
	
	private static var _cachedVibrancyStyle = ParrotAppearance.vibrancyStyle()
	private static var _vibrancyStyleListeners = [VibrancyStyleListener]()
	
	/// Trampolines the distributed notification sent when the user changes interface styles
	/// into a locally stored default that can be observed normally.
	private static let registerDarkModeActiveListener: NSObjectProtocol = {
		NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.menuBarAppearanceDidChangeNotification, object: nil, queue: nil) { _ in
			Settings.systemInterfaceStyle = NSAppearance.darkInterfaceTheme
		}
	}()
	
	/// Trampolines the UserDefaults.didChangeNotification notification and triggers any
	/// registered listeners IFF the appearance has changed. [KVO doesn't work with UserDefaults.]
	private static let registerNotificationChangeListener: NSObjectProtocol = {
		NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil) { n in
			
			// Detect InterfaceStyle changes.
			let currentInterfaceStyle = ParrotAppearance.interfaceStyle()
			if _cachedInterfaceStyle != currentInterfaceStyle {
				_cachedInterfaceStyle = currentInterfaceStyle
				
				_interfaceStyleListeners.filter { $0.object != nil }.forEach {
					$0.handler(currentInterfaceStyle)
				}
			}
			
			// Detect VibrancyStyle changes.
			let currentVibrancyStyle = ParrotAppearance.vibrancyStyle()
			if _cachedVibrancyStyle != currentVibrancyStyle {
				_cachedVibrancyStyle = currentVibrancyStyle
				
				_vibrancyStyleListeners.filter { $0.object != nil }.forEach {
					$0.handler(currentVibrancyStyle)
				}
			}
		}
	}()
	
	/// Wraps the object and handler into a single container.
	private class InterfaceStyleListener {
		weak var object: AnyObject?
		let handler: (InterfaceStyle) -> Void
		fileprivate required init(object: AnyObject, handler: @escaping (InterfaceStyle) -> Void) {
			self.object = object
			self.handler = handler
		}
	}
	
	/// Wraps the object and handler into a single container.
	private class VibrancyStyleListener {
		weak var object: AnyObject?
		let handler: (VibrancyStyle) -> Void
		fileprivate required init(object: AnyObject, handler: @escaping (VibrancyStyle) -> Void) {
			self.object = object
			self.handler = handler
		}
	}
	
	///
	/// PUBLIC:
	///
	
	
	/// Returns the current user preferential InterfaceStyle (light, dark, system).
	public static func interfaceStyle() -> InterfaceStyle {
		return InterfaceStyle(rawValue: Settings.interfaceStyle) ?? .System
	}
	
	/// Returns the current user preferential VibrancyStyle (always, never, automatic).
	public static func vibrancyStyle() -> VibrancyStyle {
		return VibrancyStyle(rawValue: Settings.vibrancyStyle) ?? .Automatic
	}
	
	/// Register a listener to be invoked when the application appearance changes.
	/// If invokeImmediately is true, the handler will be invoked immediately.
	/// This is useful in case appearance update logic is unified and can be streamlined.
	/// Note: this should be done when a view appears on-screen.
	public static func registerInterfaceStyleListener(observer: AnyObject, invokeImmediately: Bool = false, handler: @escaping (InterfaceStyle) -> Void) {
		_ = registerDarkModeActiveListener; _ = registerNotificationChangeListener // SETUP
		_interfaceStyleListeners.append(InterfaceStyleListener(object: observer, handler: handler))
		if invokeImmediately {
			handler(ParrotAppearance.interfaceStyle())
		}
	}
	
	/// Unregister a previously registered listener.
	/// Note: this should be done when a view disappears from the screen.
	public static func unregisterInterfaceStyleListener(observer: AnyObject) {
		for (i, l) in _interfaceStyleListeners.enumerated() {
			if l.object === observer {
				_interfaceStyleListeners.remove(at: i)
				break;
			}
		}
	}
	
	/// Register a listener to be invoked when the application appearance changes.
	/// If invokeImmediately is true, the handler will be invoked immediately.
	/// This is useful in case appearance update logic is unified and can be streamlined.
	/// Note: this should be done when a view appears on-screen.
	public static func registerVibrancyStyleListener(observer: AnyObject, invokeImmediately: Bool = false, handler: @escaping (VibrancyStyle) -> Void) {
		_ = registerDarkModeActiveListener; _ = registerNotificationChangeListener // SETUP
		_vibrancyStyleListeners.append(VibrancyStyleListener(object: observer, handler: handler))
		if invokeImmediately {
			handler(ParrotAppearance.vibrancyStyle())
		}
	}
	
	/// Unregister a previously registered listener.
	/// Note: this should be done when a view disappears from the screen.
	public static func unregisterVibrancyStyleListener(observer: AnyObject) {
		for (i, l) in _vibrancyStyleListeners.enumerated() {
			if l.object === observer {
				_vibrancyStyleListeners.remove(at: i)
				break;
			}
		}
	}
}

public extension NSWindow {
    public func enableRealTitlebarVibrancy(_ blendingMode: NSVisualEffectView.BlendingMode = .withinWindow) {
		let t = self.standardWindowButton(.closeButton)?.superview as? NSVisualEffectView
		t?.material = .appearanceBased
		t?.blendingMode = blendingMode
	}
}

public extension NSControl {
    
    /// Sigh. More AppKit "magic" to defeat. When placed in the titlebarview of a window,
    /// views are given a semanticContext of 0x5 and marked explicit. Setting an explicit
    /// value of 0x0 disables that. Not sure what the thing is used for...
    public func disableToolbarLook() {
        self.perform(Selector(("_setSemanticContext:")), with: 0)
    }
}
