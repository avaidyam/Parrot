
// All default Swift types:
//Boolean
//BinaryInteger
//BinaryFloatingPoint

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

public extension Comparable {
    public func clamped(from lowerBound: Self) -> Self {
        return max(self, lowerBound)
    }
    public func clamped(from range: PartialRangeFrom<Self>) -> Self {
        return max(self, range.lowerBound)
    }
    public func clamped(to lowerBound: Self) -> Self {
        return min(self, lowerBound)
    }
    public func clamped(to range: PartialRangeThrough<Self>) -> Self {
        return min(self, range.upperBound)
    }
}
public extension Strideable where Self.Stride: SignedInteger {
    public func clamped(from range: CountablePartialRangeFrom<Self>) -> Self {
        return max(self, range.lowerBound)
    }
}
