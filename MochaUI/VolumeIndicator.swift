//
//  VolumeIndicator.swift
//  AirVolume
//
//  Created by Matt Prowse on 5/08/2014.
//  Copyright © 2014 Cordless Dog. All rights reserved.
//
import Cocoa

// adapted from @mattprowse: https://github.com/mattprowse/SystemBezelWindowController
public class VolumeIndicator: NSView {
    
    private enum ColorKeys {
        case background, segment
    }
    
    //
    //
    //

    private let drawColors: [SystemBezel.ColorMode: [ColorKeys: NSColor]] = [
        .light: [.background: NSColor(deviceWhite: 0, alpha: 0.6), .segment: .controlBackgroundColor],
        .lightReducedTransparency: [.background: NSColor(deviceWhite: 0.50, alpha: 1.0), .segment: .white],
        .lightIncreasedContrast: [.background: NSColor(deviceWhite: 0.01, alpha: 1.0), .segment: .white],
        .dark: [.background: NSColor(deviceWhite: 0, alpha: 0.6), .segment: NSColor(deviceWhite: 1, alpha: 0.8)],
        .darkReducedTransparency: [.background: NSColor(deviceWhite: 0.01, alpha: 1.0), .segment: NSColor(deviceWhite: 0.49, alpha: 1.0)],
        .darkIncreasedContrast: [.background: NSColor(deviceWhite: 0.01, alpha: 1.0), .segment: NSColor(deviceWhite: 0.76, alpha: 1.0)],
    ]
    
    private let maxLevel: Int = 16
    private let segmentSize = NSSize(width: 9, height: 6)
    private let segmentSpacing: CGFloat = 1
    
    private var backgroundColor: NSColor {
        return self.drawColors[self.colorMode]![.background]!
    }

    private var segmentColor: NSColor {
        return self.drawColors[self.colorMode]![.segment]!
    }
    
    public var level: Int = 0 {
        willSet {
            self.level = self.level.clamped(to: 0...maxLevel)
        }
        didSet {
            self.needsDisplay = true
        }
    }
    
    // Note that the color is inverted from the root appearance to stand out.
    private var colorMode: SystemBezel.ColorMode {
        let a = self.appearance?.name ?? NSAppearanceNameVibrantLight
        if NSAppearance.increaseContrastEnabled {
            return a == NSAppearanceNameVibrantDark ? .lightIncreasedContrast : .darkIncreasedContrast
        }
        if NSAppearance.reduceTransparencyEnabled {
            return a == NSAppearanceNameVibrantDark ? .lightReducedTransparency : .darkReducedTransparency
        }
        return a == NSAppearanceNameVibrantDark ? .light : .dark
    }
    
    //
    //
    //
    
    public override var allowsVibrancy: Bool {
        return false
    }
    public override var intrinsicContentSize: NSSize {
        return NSSize(width: NSViewNoIntrinsicMetric, height: 8.0)
    }
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.backgroundColor.set()
        NSRectFill(dirtyRect)

        var segmentIndex = 0
        var segmentXOffset: CGFloat = self.segmentSpacing

        self.segmentColor.set()
        while segmentIndex < self.level {
            let segmentRect = NSRect(x: segmentXOffset, y: 1, width: self.segmentSize.width, height: self.segmentSize.height)
            NSRectFill(segmentRect)
            segmentIndex += 1
            segmentXOffset += self.segmentSize.width + self.segmentSpacing
        }
    }
}

/// from @full-descent: https://stackoverflow.com/questions/31943797/extending-generic-integer-types-in-swift/43769799#43769799
public extension Comparable {
    public func clamped(from lowerBound: Self, to upperBound: Self) -> Self {
        return min(max(self, lowerBound), upperBound)
    }
    public func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
public extension Strideable where Self.Stride: SignedInteger {
    public func clamped(to range: CountableClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

