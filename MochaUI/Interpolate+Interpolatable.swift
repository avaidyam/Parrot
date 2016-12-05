import Foundation
import AppKit
import QuartzCore

/**
 Supported interpolatable types.
 */
public enum InterpolatableType {
    /// CATransform3D type.
    case caTransform3D
    /// CGAffineTransform type.
    case cgAffineTransform
    /// CGFloat type.
    case cgFloat
    /// CGPoint type.
    case cgPoint
    /// CGRect type.
    case cgRect
    /// CGSize type.
    case cgSize
    /// ColorCYMK type.
    case colorCYMK
    /// ColorMonochrome type.
    case colorMonochrome
    /// ColorRGB type.
    case colorRGB
    /// Double type.
    case double
    /// Int type.
    case int
    /// UIEdgeInsets type.
    case uiEdgeInsets
}

// MARK: Extensions

/// CATransform3D Interpolatable extension.
extension CATransform3D: Interpolatable {
    /**
     Vectorize CATransform3D.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .caTransform3D, vectors: [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44])
    }
}

/// CGAffineTransform Interpolatable extension.
extension CGAffineTransform: Interpolatable {
    /**
     Vectorize CGAffineTransform.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgAffineTransform, vectors: [a, b, c, d, tx, ty])
    }
}

/// CGFloat Interpolatable extension.
extension CGFloat: Interpolatable {
    /**
     Vectorize CGFloat.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgFloat, vectors: [self])
    }
}

/// CGPoint Interpolatable extension.
extension CGPoint: Interpolatable {
    /**
     Vectorize CGPoint.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgPoint, vectors: [x, y])
    }
}

/// CGRect Interpolatable extension.
extension CGRect: Interpolatable {
    /**
     Vectorize CGRect.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgRect, vectors: [origin.x, origin.y, size.width, size.height])
    }
}

/// CGSize Interpolatable extension.
extension CGSize: Interpolatable {
    /**
     Vectorize CGSize.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .cgSize, vectors: [width, height])
    }
}

/// Double Interpolatable extension.
extension Double: Interpolatable {
    /**
     Vectorize Double.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .double, vectors: [CGFloat(self)])
    }
}

/// Int Interpolatable extension.
extension Int: Interpolatable {
    /**
     Vectorize Int.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .int, vectors: [CGFloat(self)])
    }
}

/// UIColor Interpolatable extension.
extension NSColor: Interpolatable {
    /**
     Vectorize UIColor.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if [NSCalibratedRGBColorSpace, NSDeviceRGBColorSpace].contains(colorSpaceName) {
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return IPValue(type: .colorRGB, vectors: [red, green, blue, alpha])
        }
        
        var white: CGFloat = 0
        if [NSCalibratedWhiteColorSpace, NSDeviceWhiteColorSpace].contains(colorSpaceName) {
            getWhite(&white, alpha: &alpha)
            return IPValue(type: .colorMonochrome, vectors: [white, alpha])
        }
        
        var cyan: CGFloat = 0, magenta: CGFloat = 0, yellow: CGFloat = 0, black: CGFloat = 0
        if [NSDeviceCMYKColorSpace].contains(colorSpaceName) {
            getCyan(&cyan, magenta: &magenta, yellow: &yellow, black: &black, alpha: &alpha)
            return IPValue(type: .colorCYMK, vectors: [cyan, magenta, yellow, black, alpha])
        }
        
        // Error case.
        return IPValue(type: .colorMonochrome, vectors: [0, 0])
    }
}

/// UIEdgeInsets Interpolatable extension.
extension EdgeInsets: Interpolatable {
    /**
     Vectorize UIEdgeInsets.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .uiEdgeInsets, vectors: [top, left, bottom, right])
    }
}

/// IPValue class. Contains a vectorized version of an Interpolatable type.
open class IPValue {
    
    let type: InterpolatableType
    var vectors: [CGFloat]
    
    init(value: IPValue) {
        self.vectors = value.vectors
        self.type = value.type
    }
    
    init (type: InterpolatableType, vectors: [CGFloat]) {
        self.vectors = vectors
        self.type = type
    }
    
    func toInterpolatable() -> Interpolatable {
        switch type {
        case .caTransform3D:
            return CATransform3D(m11: vectors[0], m12: vectors[1], m13: vectors[2], m14: vectors[3], m21: vectors[4], m22: vectors[5], m23: vectors[6], m24: vectors[7], m31: vectors[8], m32: vectors[9], m33: vectors[10], m34: vectors[11], m41: vectors[12], m42: vectors[13], m43: vectors[14], m44: vectors[15])
        case .cgAffineTransform:
            return CGAffineTransform(a: vectors[0], b: vectors[1], c: vectors[2], d: vectors[3], tx: vectors[4], ty: vectors[5])
        case .cgFloat:
            return vectors[0]
        case .cgPoint:
            return CGPoint(x: vectors[0], y: vectors[1])
        case .cgRect:
            return CGRect(x: vectors[0], y: vectors[1], width: vectors[2], height: vectors[3])
        case .cgSize:
            return CGSize(width: vectors[0], height: vectors[1])
        case .colorRGB:
            return NSColor(red: vectors[0], green: vectors[1], blue: vectors[2], alpha: vectors[3])
        case .colorMonochrome:
            return NSColor(white: vectors[0], alpha: vectors[1])
        case .colorCYMK:
            return NSColor(deviceCyan: vectors[0], magenta: vectors[1], yellow: vectors[2], black: vectors[3], alpha: vectors[4])
        case .double:
            return Double(vectors[0])
        case .int:
            return Int(vectors[0])
        case .uiEdgeInsets:
            return NSEdgeInsetsMake(vectors[0], vectors[1], vectors[2], vectors[3]) as EdgeInsets
        }
    }
    
}
