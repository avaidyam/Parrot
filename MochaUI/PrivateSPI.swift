import AppKit
import Mocha

//
// NSPopover
//

@objc public protocol NSPopover_PrivateSPI: PrivateSPI {
    func _beginPredeepAnimationAgainstPoint(_ arg1: CGPoint, inView arg2: Any!)
    func _beginPredeepAnimationRelative(to arg1: CGRect, ofView arg2: Any!, preferredEdge arg3: UInt64)
    func _doPredeepAnimation(withProgress arg1: Double)
    func _cancelPredeepAnimation()
    func _completeDeepAnimation()
    func _releaseDeepAnimation()
}
extension NSPopover: PrivateSPIVendor {
    public typealias PrivateSPIType = NSPopover_PrivateSPI
}

//
// NSWindow
//

@objc public protocol NSWindow_PrivateSPI: PrivateSPI {
    func _setTransformForAnimation(_: CGAffineTransform, anchorPoint: CGPoint)
}
extension NSWindow: PrivateSPIVendor {
    public typealias PrivateSPIType = NSWindow_PrivateSPI
}
