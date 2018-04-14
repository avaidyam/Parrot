import Foundation


//
// MARK: - ShortcutRecognizer Root Protocol
//


/// Defines a shortcut recognition mechanism that operates globally.
/// It executes a subclass-defined action upon its activation.
/// Think, similar to `NSGestureRecognizer`, but not `NSWindow` or `NSApp`-bound.
public protocol ShortcutRecognizer: class {
    
    /// Invoke this when the shortcut key is pressed.
    func keyDown()
    
    /// Invoke this when the shortcut key is released.
    func keyUp()
}


//
// MARK: - Simple Press Recognizer
//


/// Simple press recognizer that executes its `handler`.
public final class PressShortcutRecognizer: ShortcutRecognizer {
    
    /// The handler is invoked when the shortcut is pressed.
    public let handler: () -> ()
    
    /// Create a new tracker with the given handler.
    public init(_ handler: @escaping () -> ()) {
        self.handler = handler
    }
    
    public func keyDown() {
        /// ignored!
    }
    
    public func keyUp() {
        self.handler()
    }
}


//
// MARK: - Complex Tap & Hold Recognizer
//


/// Naive double tap & hold mechanism that executes its `handler`.
public final class TapHoldShortcutRecognizer: ShortcutRecognizer {
    private var timeReference: CFAbsoluteTime = 0.0
    private var inDoubleTap = false
    private var timeInterval = DispatchTimeInterval.seconds(0)
    
    /// The handler is invoked when the criteria for this recognizer are met:
    /// tap the shortcut twice (< 1s gap) and keep it pressed (> 2s hold).
    public let handler: () -> ()
    
    /// Create a new tracker with the given handler.
    public init(for t: DispatchTimeInterval = .seconds(2), _ handler: @escaping () -> ()) {
        self.timeInterval = t
        self.handler = handler
    }
    
    public func keyDown() {
        defer { self.timeReference = CFAbsoluteTimeGetCurrent() }
        guard CFAbsoluteTimeGetCurrent() - self.timeReference < 1.0 else { return } // double-tapped
        
        self.inDoubleTap = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval) {
            guard self.inDoubleTap else { return }
            self.inDoubleTap = false
            DispatchQueue.main.async(execute: self.handler)
        }
    }
    
    public func keyUp() {
        guard self.inDoubleTap else { return }
        self.inDoubleTap = false
        print("shortcut recognizer failed because hold duration was \(CFAbsoluteTimeGetCurrent() - self.timeReference)s")
    }
}


//
// MARK: - Shortcut <-> Recognizer Binding
//


public extension ShortcutRecognizer {
    
    /// Bind a recognizer to a shortcut. Retain the returned object to ensure the binding.
    public func bind(to shortcut: CGSKeyboardShortcut) -> Any {
        let x = NotificationCenter.default.addObserver(forName: CGSKeyboardShortcut.pressedNotification, object: shortcut, queue: nil) { _ in
            self.keyDown()
        }
        let y = NotificationCenter.default.addObserver(forName: CGSKeyboardShortcut.releasedNotification, object: shortcut, queue: nil) { _ in
            self.keyUp()
        }
        return _Holder([x, y])
    }
}

// Implementation Detail:
class _Holder {
    private let observers: [Any]
    public init(_ observers: [Any]) {
        self.observers = observers
    }
}

// MARK: -
