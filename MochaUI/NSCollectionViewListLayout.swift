import Cocoa

// TODO: static heights instead of delegate calls
// TODO: section collapse, row hide, sticky headers, swipe actions
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
        
        fileprivate enum ItemType {
            case header(IndexPath), footer(IndexPath), item(IndexPath)
        }
        
        /// Describes layout for an item on a single axis.
        fileprivate struct MeasuredItem {
            fileprivate var origin: CGFloat = 0
            fileprivate var size: CGFloat = 0
            
            fileprivate func asRect(onAxis axis: NSLayoutConstraintOrientation,
                                    _ other: MeasuredItem = MeasuredItem(origin: 0, size: 0)) -> NSRect {
                var rect = NSRect(value: (origin: self.origin, size: self.size), forAxis: axis)
                rect.origin.setValue(other.origin, forAxis: !axis)
                rect.size.setValue(other.size, forAxis: !axis)
                return rect
            }
        }
        
        /// Describes layout of an individual section.
        fileprivate struct Section {
            fileprivate var index: Int
            fileprivate var count: Int
            
            fileprivate var header: MeasuredItem
            fileprivate var footer: MeasuredItem
            fileprivate var items: [MeasuredItem]
            
            fileprivate init(index: Int = 0, header: MeasuredItem = MeasuredItem(),
                             footer: MeasuredItem = MeasuredItem(), items: [MeasuredItem] = []) {
                self.index = index
                self.header = header
                self.footer = footer
                self.items = items
                self.count = items.count
            }
        }
        
        ///
        ///
        ///
        
        fileprivate var sections = [Section]()
        fileprivate var computationPreparer: (([Int]) -> ())? = nil
        fileprivate var computationHandler: ((ItemType, MeasuredItem) -> ())? = nil
        fileprivate var axis: NSLayoutConstraintOrientation = .vertical
        
        /// Determines axis sizing, layout direction, and whatnot...
        private var axisSize: CGFloat = 0
        private var otherAxisSize: CGFloat = 0
        
        fileprivate mutating func reset() {
            self.sections = []
            self.axisSize = 0
            self.otherAxisSize = 0
        }
        
        ///
        ///
        ///
        
        fileprivate mutating func recomputeCache(from collectionView: NSCollectionView) {
            
            // Reset cache data.
            self.reset()
            var currentOrigin: CGFloat = 0
            self.otherAxisSize = collectionView.bounds.size.value(forAxis: !self.axis)
            let layout = collectionView.collectionViewLayout as! NSCollectionViewListLayout
            let counts = (0..<collectionView.numberOfSections).map {
                collectionView.numberOfItems(inSection: $0)
            }
            self.computationPreparer?(counts)
            
            // Prepare supported delegate calls.
            guard let d = collectionView.delegate as? NSCollectionViewDelegateFlowLayout else { return }
            guard let cell = d.collectionView(_:layout:sizeForItemAt:) else { return }
            let header = d.collectionView(_:layout:referenceSizeForHeaderInSection:)
            let footer = d.collectionView(_:layout:referenceSizeForFooterInSection:)
            
            // List Header
            //let globalHeaderSize = header?(collectionView, layout, -1).value(forAxis: self.axis) ?? 0
            //self.headers.insert(MeasuredItem(origin: currentY, size: globalHeaderSize), at: -1)
            //currentOrigin += globalHeaderSize
            
            // List Contents
            for i in 0..<counts.count {
                var currentSection = Section(index: i)
                
                // Section Header
                let headerSize = header?(collectionView, layout, i).value(forAxis: self.axis) ?? 0
                currentSection.header = MeasuredItem(origin: currentOrigin, size: headerSize)
                currentOrigin += headerSize
                
                // Ping Handler
                self.computationHandler?(.header(IndexPath(item: 0, section: i)), currentSection.header)
                
                // Section Contents
                var sectionItems = [MeasuredItem]()
                for j in 0..<counts[i] {
                    
                    // Cell
                    let itemSize = cell(collectionView, layout, IndexPath(item: j, section: i)).value(forAxis: self.axis)
                    let itemMeasure = MeasuredItem(origin: currentOrigin, size: itemSize)
                    sectionItems.insert(itemMeasure, at: j)
                    currentOrigin += itemSize
                    
                    // Ping Handler
                    self.computationHandler?(.item(IndexPath(item: j, section: i)), itemMeasure)
                }
                currentSection.items = sectionItems
                currentSection.count = counts[i]
                
                // Section Footer
                let footerSize = footer?(collectionView, layout, i).value(forAxis: self.axis) ?? 0
                currentSection.footer = MeasuredItem(origin: currentOrigin, size: footerSize)
                currentOrigin += footerSize
                
                // Ping Handler
                self.computationHandler?(.footer(IndexPath(item: 0, section: i)), currentSection.footer)
                
                self.sections.insert(currentSection, at: i)
            }
            
            // List Footer
            //let globalFooterSize = footer?(collectionView, layout, -1).value(forAxis: self.axis) ?? 0
            //self.footers.insert(MeasuredItem(origin: currentY, size: globalFooterSize), at: -1)
            //currentOrigin += globalFooterSize
            
            // Aggregate
            self.axisSize = currentOrigin
        }
        
        ///
        ///
        ///
        
        fileprivate func headerFrame(from section: Int) -> NSRect {
            guard let measure = self.sections[safe: section]?.header
                else { return .zero }
            return measure.asRect(onAxis: self.axis, MeasuredItem(origin: 0, size: self.otherAxisSize))
        }
        
        fileprivate func itemFrame(from indexPath: IndexPath) -> NSRect {
            guard let measure = self.sections[safe: indexPath.section]?.items[safe: indexPath.item]
                else { return .zero }
            return measure.asRect(onAxis: self.axis, MeasuredItem(origin: 0, size: self.otherAxisSize))
        }
        
        fileprivate func footerFrame(from section: Int) -> NSRect {
            guard let measure = self.sections[safe: section]?.footer
                else { return .zero }
            return measure.asRect(onAxis: self.axis, MeasuredItem(origin: 0, size: self.otherAxisSize))
        }
        
        ///
        ///
        ///
        
        fileprivate func size() -> NSSize {
            var size = NSSize(value: self.axisSize, forAxis: self.axis)
            size.setValue(self.otherAxisSize, forAxis: !self.axis)
            return size
        }
        
        fileprivate func frame(for measure: MeasuredItem) -> NSRect {
            return measure.asRect(onAxis: self.axis, MeasuredItem(origin: 0, size: self.otherAxisSize))
        }
        
        fileprivate mutating func update(from: NSSize) -> Bool {
            switch self.axis {
            case .vertical:
                guard self.otherAxisSize != from.width else { return false }
                self.otherAxisSize = from.width
            case .horizontal:
                guard self.otherAxisSize != from.height else { return false }
                self.otherAxisSize = from.height
            }
            return true
        }
    }
    
    /// Describes layout of an individual section.
    fileprivate struct Section {
        fileprivate var index: Int = 0
        
        fileprivate var header: NSCollectionViewLayoutAttributes? = nil
        fileprivate var footer: NSCollectionViewLayoutAttributes? = nil
        fileprivate var items = [NSCollectionViewLayoutAttributes]()
        /*
         subscript(_ lhs: Index, _ rhs: NSCollectionViewLayoutAttributes) {
         return indices.contains(index) ? self[index] : nil
         }*/
    }
    
    ///
    ///
    ///
    
    /// The internal cache manages all layout calculations.
    private var cache = CacheData()
    private var sections = [Section]()
    private var flattenedSections = [NSCollectionViewLayoutAttributes]()
    
    public var animationEffect = AnimationEffect()
    public var separatorStyle = SeparatorStyle()
    
    public override init() {
        super.init()
        self.setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    private func setup() {
        self.cache.computationPreparer = {
            self.sections = $0.map {
                var s = Section()
                s.index = $0
                return s
            }
            self.flattenedSections = []
        }
        
        self.cache.computationHandler = { i, m in
            var attributes: NSCollectionViewLayoutAttributes? = nil
            let frame = self.cache.frame(for: m)
            
            switch i {
            case .header(let idx):
                attributes = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: "header", with: idx)
                attributes!.frame = frame
                self.sections[idx.section].header = attributes!
            case .item(let idx):
                attributes = NSCollectionViewLayoutAttributes(forItemWith: idx)
                attributes!.frame = frame
                self.sections[idx.section].items.insert(attributes!, at: idx.item)
            case .footer(let idx):
                attributes = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: "footer", with: idx)
                attributes!.frame = frame
                self.sections[idx.section].header = attributes!
            }
            self.flattenedSections.append(attributes!)
        }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        return self.cache.update(from: newBounds.size)
    }
    
    public override func prepare() {
        //let t = CACurrentMediaTime()
        self.cache.recomputeCache(from: self.collectionView!)
        //print("layout pass: ", (CACurrentMediaTime() - t) * 1000, "ms")
    }
    
    public override var collectionViewContentSize: NSSize {
        return self.cache.size()
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return self.sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        switch elementKind {
        case "header":
            return self.sections[safe: indexPath.section]?.header
        case "footer":
            return self.sections[safe: indexPath.section]?.footer
        default: return nil
        }
    }
    
    public override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return self.flattenedSections
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

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

///
/// AxisSizable
///

public protocol AxisSizable {
    typealias Axis = NSLayoutConstraintOrientation
    
    associatedtype AxisValue
    func value(forAxis axis: Axis) -> AxisValue
    mutating func setValue(_ value: AxisValue, forAxis axis: Axis)
    init(value: AxisValue, forAxis axis: Axis)
}

extension NSPoint: AxisSizable {
    public typealias AxisValue = CGFloat
    public func value(forAxis axis: Axis) -> AxisValue {
        switch axis {
        case .vertical: return self.y
        case .horizontal: return self.x
        }
    }
    public mutating func setValue(_ value: AxisValue, forAxis axis: Axis) {
        switch axis {
        case .vertical: self.y = value
        case .horizontal: self.x = value
        }
    }
    public init(value: AxisValue, forAxis axis: Axis) {
        self.init(x: axis == .horizontal ? value : 0,
                  y: axis == .vertical ? value : 0)
    }
}

extension NSSize: AxisSizable {
    public typealias AxisValue = CGFloat
    public func value(forAxis axis: Axis) -> AxisValue {
        switch axis {
        case .vertical: return self.height
        case .horizontal: return self.width
        }
    }
    public mutating func setValue(_ value: AxisValue, forAxis axis: Axis) {
        switch axis {
        case .vertical: self.height = value
        case .horizontal: self.width = value
        }
    }
    public init(value: AxisValue, forAxis axis: Axis) {
        self.init(width: axis == .horizontal ? value : 0,
                  height: axis == .vertical ? value : 0)
    }
}

extension NSRect: AxisSizable {
    public typealias AxisValue = (origin: NSPoint.AxisValue, size: NSSize.AxisValue)
    public func value(forAxis axis: Axis) -> AxisValue {
        switch axis {
        case .vertical: return (origin: self.origin.y, size: self.size.height)
        case .horizontal: return (origin: self.origin.x, size: self.size.width)
        }
    }
    public mutating func setValue(_ value: AxisValue, forAxis axis: Axis) {
        self.origin.setValue(value.origin, forAxis: axis)
        self.size.setValue(value.size, forAxis: axis)
    }
    public init(value: AxisValue, forAxis axis: Axis) {
        self.init(origin: NSPoint(value: value.origin, forAxis: axis),
                  size: NSSize(value: value.size, forAxis: axis))
    }
}

prefix func !(_ lhs: NSLayoutConstraintOrientation) -> NSLayoutConstraintOrientation {
    switch lhs {
    case .vertical: return .horizontal
    case .horizontal: return .vertical
    }
}
