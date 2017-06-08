import Cocoa

// TODO: global header/footer, section headers/footers
// TODO: row size style, hide/unhide, swipe actions
public class NSCollectionViewListLayout: NSCollectionViewLayout {
    
    public struct AnimationEffect {
        public let appear: NSTableViewAnimationOptions = []
        public let disappear: NSTableViewAnimationOptions = []
    }
    
    /// Separator theme definition.
    public struct SeparatorStyle {
        public let visible: Bool = false
        public let color: NSColor = NSColor.black
        public let inset: NSEdgeInsets = NSEdgeInsetsZero
        
        /// When set true, the separator appears vibrant when contained within
        /// an NSVisualEffectView; otherwise, it draws as the color provided.
        public let vibrant: Bool = false
        
        /// When set true, the values in the inset property are interpreted
        /// as offsets from the default insets provided by the layout. The layout
        /// normally uses its layout margins as the default cell inset value.
        public let coalesce: Bool = false
    }
    
    /// The cache is encapsulated in its own structure to avoid mixing things up.
    /// It maps all the heights and y-locations of each cell, and maintains
    /// the expected overall height of the layout, recomputing at will.
    ///
    /// Note: takes ~0.00115ms per indexPath.
    /// - 100x200 = ~23.0ms
    /// - 10x200 = ~2.4ms
    /// - 1x200 = ~0.26ms
    /// - 1x20 = ~0.06ms
    private struct CacheData {
        fileprivate var heights = [[CGFloat]]()
        fileprivate var yLocs = [[CGFloat]]()
        fileprivate var size: CGSize = .zero
        
        fileprivate mutating func recomputeCache(from collectionView: NSCollectionView,
                                                 using block: (IndexPath) -> (CGFloat)) {
            self.heights = []
            self.yLocs = []
            var currentY: CGFloat = 0
            for i in 0..<collectionView.numberOfSections {
                var heights = [CGFloat]()
                var yLocs = [CGFloat]()
                for j in 0..<collectionView.numberOfItems(inSection: i) {
                    let height = block(IndexPath(item: j, section: i))
                    heights.insert(height, at: j)
                    yLocs.insert(currentY, at: j)
                    currentY += height
                }
                self.heights.insert(heights, at: i)
                self.yLocs.insert(yLocs, at: i)
            }
            
            let h = self.heights.map { $0.reduce(0, +) }.reduce(0, +)
            let w = collectionView.frame.size.width
            self.size = NSSize(width: w, height: h)
        }
        
        fileprivate func frame(from indexPath: IndexPath) -> NSRect {
            let y = self.yLocs[indexPath.section][indexPath.item]
            let height = self.heights[indexPath.section][indexPath.item]
            return NSRect(x: 0, y: y, width: self.size.width, height: height)
        }
    }
    
    private var cache = CacheData()
    
    public var animationEffect = AnimationEffect()
    public var separatorStyle = SeparatorStyle()
    
    public var heightOfIndexPath: (IndexPath) -> (CGFloat) = { _ in 0 }
    
    public override func prepare() {
        self.cache.recomputeCache(from: self.collectionView!, using: self.heightOfIndexPath)
    }
    
    public override var collectionViewContentSize: NSSize {
        return self.cache.size
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let itemAttributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
        itemAttributes.frame = self.cache.frame(from: indexPath)
        return itemAttributes
    }
    
    public override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        var attributes = [NSCollectionViewLayoutAttributes]()
        for i in 0..<self.cache.heights.count {
            for j in 0..<self.cache.heights[i].count {
                let indexPath = IndexPath(item: j, section: i)
                if let itemAttributes = self.layoutAttributesForItem(at: indexPath) {
                    attributes.append(itemAttributes)
                }
            }
        }
        return attributes
    }
    
    private var cachedBoundsWidth: CGFloat = 0
    public override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        guard self.cachedBoundsWidth != newBounds.width else { return false }
        self.cachedBoundsWidth = newBounds.width
        return true
    }
    
    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let x = self.layoutAttributesForItem(at: itemIndexPath)
        if self.animationEffect.appear.contains(.effectFade) {
            x?.alpha = 0.0
        }
        if self.animationEffect.appear.contains(.slideUp) {
            x?.frame.origin.y -= x!.frame.height
        } else if self.animationEffect.appear.contains(.slideDown) {
            x?.frame.origin.y += x!.frame.height
        } else if self.animationEffect.appear.contains(.slideLeft) {
            x?.frame.origin.x += x!.frame.width
        } else if self.animationEffect.appear.contains(.slideRight) {
            x?.frame.origin.x -= x!.frame.width
        }
        return x
    }
    
    public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        let x = self.layoutAttributesForItem(at: itemIndexPath)
        if self.animationEffect.disappear.contains(.effectFade) {
            x?.alpha = 0.0
        }
        if self.animationEffect.disappear.contains(.slideUp) {
            x?.frame.origin.y -= x!.frame.height
        } else if self.animationEffect.disappear.contains(.slideDown) {
            x?.frame.origin.y += x!.frame.height
        } else if self.animationEffect.disappear.contains(.slideLeft) {
            x?.frame.origin.x += x!.frame.width
        } else if self.animationEffect.disappear.contains(.slideRight) {
            x?.frame.origin.x -= x!.frame.width
        }
        return x
    }
}

