import AppKit
import Mocha
import CoreGraphics

/// Receives system events. See `CGEventTap`.
public final class SystemEventListener {
    
    /// The underlying port.
    fileprivate private(set) var port: CFMachPort? = nil
    
    /// The underlying runloop source.
    fileprivate private(set) var source: CFRunLoopSource? = nil
    
    /// The events the `SystemEventListener` will receive.
    public let events: [CGEventType]
    
    /// The actions the `SystemEventListener` will invoke upon event receipt.
    public let action: @convention(block) (NSEvent) -> ()
    
    /// Whether the listener will receive system events from the specified mask.
    public var isEnabled: Bool = true {
        didSet {
            CGEvent.tapEnable(tap: self.port!, enable: self.isEnabled)
        }
    }
    
    /// Create a new `SystemEventListener` at the directed point.
    /// Create a notification center observer to handle the received events.
    public init(for events: CGEventType..., action: @escaping @convention(block) (NSEvent) -> ()) {
        self.events = events
        self.action = action
        let mask: CGEventMask = events.map { 1 << $0.rawValue }.reduce(0, |)
        
        let callback: CGEventTapCallBack = { _, type, _cg, info in
            let this = unsafeBitCast(info!, to: SystemEventListener.self)
            
            switch type {
            case .tapDisabledByTimeout: fallthrough
            case .tapDisabledByUserInput: // auto-reenabled
                CGEvent.tapEnable(tap: this.port!, enable: this.isEnabled)
                break
            default:
                guard let event = NSEvent(cgEvent: _cg) else { break }
                this.action(event)
            }
            return nil
        }
        
        self.port = CGEvent.tapCreate(tap: .cgAnnotatedSessionEventTap,
                                      place: .tailAppendEventTap,
                                      options: .listenOnly, /*.defaultTap*/
            eventsOfInterest: mask,
            callback: callback,
            userInfo: unsafeBitCast(self, to: UnsafeMutableRawPointer.self))!
        self.source = CFMachPortCreateRunLoopSource(nil, self.port, 0)
    }
}

public extension RunLoop {
    
    ///
    public func add(_ listener: SystemEventListener, to modes: RunLoopMode...) {
        let cf = self.getCFRunLoop()
        for mode in modes {
            CFRunLoopAddSource(cf, listener.source, CFRunLoopMode(mode.rawValue as CFString))
        }
    }
    
    ///
    public func remove(_ listener: SystemEventListener, from modes: RunLoopMode...) {
        let cf = self.getCFRunLoop()
        for mode in modes {
            CFRunLoopRemoveSource(cf, listener.source, CFRunLoopMode(mode.rawValue as CFString))
        }
    }
}

public extension CGEventType {
    
    /// All touches are recieved for this event type.
    public static let touches = CGEventType(rawValue: 29)!
    
    /// The Mission Control up/down swipe.
    public static let fluidGestureSwipe = CGEventType(rawValue: 30)!
    
    /// The Notification Center edge swipe.
    public static let fluidEdgeSwipe = CGEventType(rawValue: 31)!
}


public extension RunLoopMode {
    
    /// The AppKit event tracking `RunLoopMode`.
    public static let eventTrackingMode = RunLoopMode("NSEventTrackingRunLoopMode")
}
