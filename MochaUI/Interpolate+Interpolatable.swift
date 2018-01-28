import Foundation
import AppKit
import QuartzCore

public protocol Interpolatable {
    //init?(components: [CGFloat]) // see below
    static func make(from: [CGFloat]) -> Self?
    var components: [CGFloat] { get }
}
public extension Interpolatable {
    public init?(components: [CGFloat]) {
        guard let value = Self.make(from: components) else { return nil }
        self = value
    }
}

/// Contains a vectorized version of an `Interpolatable`.
public final class IPValue<T: Interpolatable> {
    let type: T.Type
    var components: [CGFloat]
    
    public init(type: T.Type, components: [CGFloat]) {
        self.type = type
        self.components = components
    }
    
    public convenience init(value: T) {
        self.init(type: T.self, components: value.components)
    }
    
    public convenience init(from other: IPValue<T>) {
        self.init(type: other.type, components: other.components)
    }
    
    public var value: T {
        return self.type.init(components: self.components)!
    }
}

extension CGFloat: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> CGFloat? {
        assert(vectors.count == 1, "Invalid number of components provided!")
        return vectors[0]
    }
    public var components: [CGFloat] {
        return [self]
    }
}

extension Double: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> Double? {
        assert(vectors.count == 1, "Invalid number of components provided!")
        return Double(vectors[0])
    }
    public var components: [CGFloat] {
        return [CGFloat(self)]
    }
}

extension Int: Interpolatable { // TODO: Numeric? FloatingPoint?
    public static func make(from vectors: [CGFloat]) -> Int? {
        assert(vectors.count == 1, "Invalid number of components provided!")
        return Int(vectors[0])
    }
    public var components: [CGFloat] {
        return [CGFloat(self)]
    }
}

extension CATransform3D: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> CATransform3D? {
        assert(vectors.count == 16, "Invalid number of components provided!")
        return CATransform3D(m11: vectors[0], m12: vectors[1], m13: vectors[2], m14: vectors[3], m21: vectors[4], m22: vectors[5], m23: vectors[6], m24: vectors[7], m31: vectors[8], m32: vectors[9], m33: vectors[10], m34: vectors[11], m41: vectors[12], m42: vectors[13], m43: vectors[14], m44: vectors[15])
    }
    public var components: [CGFloat] {
        return [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44]
    }
}

extension CGAffineTransform: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> CGAffineTransform? {
        assert(vectors.count == 6, "Invalid number of components provided!")
        return CGAffineTransform(a: vectors[0], b: vectors[1], c: vectors[2], d: vectors[3], tx: vectors[4], ty: vectors[5])
    }
    public var components: [CGFloat] {
        return [a, b, c, d, tx, ty]
    }
}

extension CGPoint: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> CGPoint? {
        assert(vectors.count == 2, "Invalid number of components provided!")
        return CGPoint(x: vectors[0], y: vectors[1])
    }
    public var components: [CGFloat] {
        return [x, y]
    }
}

extension CGSize: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> CGSize? {
        assert(vectors.count == 2, "Invalid number of components provided!")
        return CGSize(width: vectors[0], height: vectors[1])
    }
    public var components: [CGFloat] {
        return [width, height]
    }
}

extension CGRect: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> CGRect? {
        assert(vectors.count == 4, "Invalid number of components provided!")
        return CGRect(x: vectors[0], y: vectors[1], width: vectors[2], height: vectors[3])
    }
    public var components: [CGFloat] {
        return [origin.x, origin.y, size.width, size.height]
    }
}

extension NSEdgeInsets: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> NSEdgeInsets? {
        assert(vectors.count == 4, "Invalid number of components provided!")
        return NSEdgeInsetsMake(vectors[0], vectors[1], vectors[2], vectors[3])
    }
    public var components: [CGFloat] {
        return [top, left, bottom, right]
    }
}

extension NSColor: Interpolatable {
    public static func make(from vectors: [CGFloat]) -> Self? {
        assert([2, 4, 5].contains(vectors.count), "Invalid number of components provided!")
        switch vectors.count {
        case 2: // calibratedWhite, deviceWhite
            return self.init(white: vectors[0], alpha: vectors[1])
        case 4: // calibratedRGB, deviceRGB
            return self.init(red: vectors[0], green: vectors[1], blue: vectors[2], alpha: vectors[3])
        case 5: // deviceCMYK
            return self.init(deviceCyan: vectors[0], magenta: vectors[1], yellow: vectors[2], black: vectors[3], alpha: vectors[4])
        default: return nil
        }
    }
    public var components: [CGFloat]  {
        var white: CGFloat = 0, alpha: CGFloat = 0 /* alpha is reused */
        if [NSColorSpaceName.calibratedWhite, NSColorSpaceName.deviceWhite].contains(colorSpaceName) {
            getWhite(&white, alpha: &alpha)
            return [white, alpha]
        }
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        if [NSColorSpaceName.calibratedRGB, NSColorSpaceName.deviceRGB].contains(colorSpaceName) {
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return [red, green, blue, alpha]
        }
        
        var cyan: CGFloat = 0, magenta: CGFloat = 0, yellow: CGFloat = 0, black: CGFloat = 0
        if [NSColorSpaceName.deviceCMYK].contains(colorSpaceName) {
            getCyan(&cyan, magenta: &magenta, yellow: &yellow, black: &black, alpha: &alpha)
            return [cyan, magenta, yellow, black, alpha]
        }
        
        // Error case.
        return [0, 0]
    }
}
