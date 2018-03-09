import AppKit
import Mocha

/*
DispatchQueue.main.async {
    var perspective = CATransform3DIdentity
    perspective.m34 = 1 / 500
    perspective = CATransform3DRotate(perspective, .pi * 0.4, 1, 0, 0)
    window.transform = perspective
}
*/
public extension NSWindow {
    public var transform: CATransform3D {
        get { return CATransform3DIdentity }
        set {
            let t = CATransform3DConcat(newValue, CATransform3DMakeScale(1, -1, 1))
            let f = self.frame
            let p = CGPoint(x: self.frame.minX, y: self.screen!.frame.height - self.frame.maxY)
            let w = Float(f.width), h = Float(f.height)
            
            let bl = CGSWarpPoint(local: CGSMeshPoint(x: 0, y: 0),
                                  global: CAMesh(CGSMeshPoint(x: 0, y: h), f, p, t))
            let br = CGSWarpPoint(local: CGSMeshPoint(x: w, y: 0),
                                  global: CAMesh(CGSMeshPoint(x: w, y: h), f, p, t))
            let tl = CGSWarpPoint(local: CGSMeshPoint(x: 0, y: h),
                                  global: CAMesh(CGSMeshPoint(x: 0, y: 0), f, p, t))
            let tr = CGSWarpPoint(local: CGSMeshPoint(x: w, y: h),
                                  global: CAMesh(CGSMeshPoint(x: w, y: 0), f, p, t))
            
            let warps = [bl, br, tl, tr]
            let ptr: UnsafeMutablePointer<CGSWarpPoint> = UnsafeMutablePointer(mutating: warps)
            _ = ptr.withMemoryRebound(to: CGSWarpPoint.self, capacity: 4) {
                CGSSetWindowWarp(NSApp.value(forKey: "contextID") as! Int32,
                                 CGWindowID(self.windowNumber), 2, 2, $0)
            }
        }
    }
}

/// CGError CGSSetWindowWarp(CGSConnectionID cid, CGWindowID wid, int width, int height, const CGSWarpPoint *warp);
@_silgen_name("CGSSetWindowWarp")
private func CGSSetWindowWarp(_ cid: Int32, _ wid: CGWindowID, _ width: Int, _ height: Int, _ warp: UnsafeRawPointer) -> Int32
private typealias CGSMeshPoint = (x: Float, y: Float)
private typealias CGSWarpPoint = (local: CGSMeshPoint, global: CGSMeshPoint)
private let _layers: (parent: CALayer, child: CALayer) = {
    let layer = CALayer()
    let sublayer = CALayer()
    layer.addSublayer(sublayer)
    return (layer, sublayer)
}()
private func CAPointApplyCATransform3D(_ transform: CATransform3D, _ frame: CGRect, _ point: CGPoint) -> CGPoint {
    objc_sync_enter(_layers.parent)
    defer { objc_sync_exit(_layers.parent) }
    
    //_layers.parent.anchorPoint = .zero
    //_layers.child.anchorPoint = .zero
    _layers.parent.frame = frame
    _layers.parent.sublayerTransform = transform
    return _layers.child.convert(point, to: _layers.parent)
}
private func CAMesh(_ m: CGSMeshPoint, _ f: CGRect, _ o: CGPoint, _ t: CATransform3D) -> CGSMeshPoint {
    let n = CAPointApplyCATransform3D(t, f, CGPoint(x: Double(m.x), y: Double(m.y)))
    return CGSMeshPoint(x: Float(n.x + o.x), y: Float(n.y + o.y))
}

/// Small Spaces API wrapper.
public final class CGSSpace {
    private let identifier: CGSSpaceID
    
    public var windows: Set<NSWindow> = [] {
        didSet {
            let remove = oldValue.subtracting(self.windows)
            let add = self.windows.subtracting(oldValue)
            
            CGSRemoveWindowsFromSpaces(_CGSDefaultConnection(),
                                       remove.map { $0.windowNumber } as NSArray,
                                       [self.identifier])
            CGSAddWindowsToSpaces(_CGSDefaultConnection(),
                                  add.map { $0.windowNumber } as NSArray,
                                  [self.identifier])
        }
    }
    
    public init(level: Int = 0) {
        let flag = 0x1 // this value MUST be 1, otherwise, Finder decides to draw desktop icons
        self.identifier = CGSSpaceCreate(_CGSDefaultConnection(), flag, nil)
        CGSSpaceSetAbsoluteLevel(_CGSDefaultConnection(), self.identifier, level/*400=facetime?*/)
        CGSShowSpaces(_CGSDefaultConnection(), [self.identifier])
    }
    
    deinit {
        CGSHideSpaces(_CGSDefaultConnection(), [self.identifier])
        CGSSpaceDestroy(_CGSDefaultConnection(), self.identifier)
    }
}

// CGSSpace stuff:
fileprivate typealias CGSConnectionID = UInt
fileprivate typealias CGSSpaceID = UInt64
@_silgen_name("_CGSDefaultConnection")
fileprivate func _CGSDefaultConnection() -> CGSConnectionID
@_silgen_name("CGSSpaceCreate")
fileprivate func CGSSpaceCreate(_ cid: CGSConnectionID, _ unknown: Int, _ options: NSDictionary?) -> CGSSpaceID
@_silgen_name("CGSSpaceDestroy")
fileprivate func CGSSpaceDestroy(_ cid: CGSConnectionID, _ space: CGSSpaceID)
@_silgen_name("CGSSpaceSetAbsoluteLevel")
fileprivate func CGSSpaceSetAbsoluteLevel(_ cid: CGSConnectionID, _ space: CGSSpaceID, _ level: Int)
@_silgen_name("CGSAddWindowsToSpaces")
fileprivate func CGSAddWindowsToSpaces(_ cid: CGSConnectionID, _ windows: NSArray, _ spaces: NSArray)
@_silgen_name("CGSRemoveWindowsFromSpaces")
fileprivate func CGSRemoveWindowsFromSpaces(_ cid: CGSConnectionID, _ windows: NSArray, _ spaces: NSArray)
@_silgen_name("CGSHideSpaces")
fileprivate func CGSHideSpaces(_ cid: CGSConnectionID, _ spaces: NSArray)
@_silgen_name("CGSShowSpaces")
fileprivate func CGSShowSpaces(_ cid: CGSConnectionID, _ spaces: NSArray)
