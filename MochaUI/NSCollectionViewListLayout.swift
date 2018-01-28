import AppKit
import Mocha

// TODO: sticky headers
// TODO: section/item collapse
// TODO: separators
// TODO: section index
// TODO: inverted layout
//
// TODO: type select
// TODO: swipe actions
// TODO: static contents
// TODO: support autolayout
// TODO: refresh control/prefetch
// TODO: editing mode (none, delete, insert)
// TODO: cell accessory buttons (none, disclosure, checkmark, detail)

/// A layout that organizes items into a vertical or horizontal list arrangement.
/// In a list layout, the first item is positioned in the top-left corner and
/// other items are laid out either horizontally or vertically based on the
/// layout direction, which is configurable.
///
/// Items may be the same size or different sizes, and you may use the list layout
/// object or the collection view’s delegate object to specify the size of items
/// and the spacing around them. The list layout also lets you specify custom
/// header and footer views for each section.
public class NSCollectionViewListLayout: NSCollectionViewLayout {
    
    /// Describes the animations used by the ListLayout when inserting or removing
    /// elements.
    public typealias AnimationEffect = NSTableView.AnimationOptions
    
    /// Describes the look&feel of the separators between elements.
    public struct SeparatorStyle {
        
        /// Determines whether the separators are drawn or not.
        public let visible: Bool = false
        
        /// Determines the color of the separator.
        public let color: NSColor = NSColor.black
        
        /// Determines the inset at which the separator is drawn from the element.
        public let inset: NSEdgeInsets = NSEdgeInsetsZero
        
        /// When set true, the separator appears vibrant when contained within
        /// an NSVisualEffectView; otherwise, it draws as the color provided.
        public let vibrant: Bool = false
        
        /// When set true, the values in the inset property are interpreted
        /// as offsets from the default insets provided by the layout. The layout
        /// normally uses its layout margins as the default cell inset value.
        public let coalesce: Bool = false
    }
    
    /// Describes the look&feel of the section index that lines the side of
    /// all the elements, providing a scrubber.
    /// i.e. Atom or Sublime Text's minimap.
    public struct SectionIndexStyle {
        
        /// Determines the section index is visible or not.
        public let visible: Bool = false
        
        /// Determines the foreground color of the index guide.
        public let foregroundColor: NSColor = NSColor.black
        
        /// Determines the background color of the index guide.
        public let backgroundColor: NSColor = NSColor.black
        
        /// Determines the color of the index track.
        public let trackingColor: NSColor = NSColor.black
    }
    
    /// Describes the method by which the ListLayout calculates its elements' frames.
    public enum LayoutDefinition {
        
        /// Describes a section's (or the whole list's) static heights.
        public struct SizeMetrics {
            public let header: CGSize?
            public let item: CGSize?
            public let footer: CGSize?
            
            public init(header: CGSize? = nil, item: CGSize? = nil, footer: CGSize? = nil) {
                self.header = header
                self.item = item
                self.footer = footer
            }
        }
        
        /// `global` implies that all sections follow one set of metrics
        case global(SizeMetrics)
        
        /// `perSection` implies that each section has its own metrics
        case perSection([SizeMetrics])
        
        /// `custom` implies that the delegate will be queried for each element's metrics.
        case custom
    }
    
    ///
    ///
    ///
    
    /// The internal cache manages all layout calculations.
    private var cache = DynamicCache()
    fileprivate var metricsProvider: MetricsProvider = DelegateMetricsProvider()
    
    private var sections = [Section]()
    private var globalSection: (NSCollectionViewLayoutAttributes?, NSCollectionViewLayoutAttributes?) = (nil, nil)
    private var flattenedSections = [NSCollectionViewLayoutAttributes]()
    
    public var appearEffect: AnimationEffect = []
    public var disappearEffect: AnimationEffect = []
    public var separatorStyle = SeparatorStyle()
    
    /// Provides the `(header, footer)` for the whole list, regardless of the
    /// number of sections, or any headers or footers in those sections.
    /// Note: the corresponding IndexPath is (0, 0) and meaningless.
    public var globalSections: (CGFloat?, CGFloat?) = (nil, nil)
    
    public var layoutDefinition: LayoutDefinition = .custom {
        didSet {
            //guard oldValue != self.layoutDefinition else { return }
            switch self.layoutDefinition {
            case .global(_): self.metricsProvider = GlobalMetricsProvider()
            case .perSection(_): self.metricsProvider = PerSectionMetricsProvider()
            case .custom: self.metricsProvider = DelegateMetricsProvider()
            }
            self.invalidateLayout()
        }
    }
    
    ///
    ///
    ///
    
    private func willCompute(_ s: [Int]) {
        self.flattenedSections = []
        self.sections = s.map {
            var s = Section()
            s.index = $0
            return s
        }
    }
    
    private func didCompute(_ i: DynamicCache.ItemType, _ idx: IndexPath, _ m: NSRect) {
        var attributes: NSCollectionViewLayoutAttributes? = nil
        switch i {
        case .header:
            attributes = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: .sectionHeader, with: idx)
            attributes!.frame = m//self.cache.frame(for: m)
            self.sections[idx.section].header = attributes!
        case .item:
            attributes = NSCollectionViewLayoutAttributes(forItemWith: idx)
            attributes!.frame = m//self.cache.frame(for: m)
            self.sections[idx.section].items.insert(attributes!, at: idx.item)
        case .footer:
            attributes = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: .sectionFooter, with: idx)
            attributes!.frame = m//self.cache.frame(for: m)
            self.sections[idx.section].footer = attributes!
        }
        self.flattenedSections.append(attributes!)
    }
    
    private func didGlobalCompute(_ footer: Bool, _ m: NSRect) {
        if !footer {
            let attributes = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: .globalHeader, with: .zero)
            attributes.frame = m//self.cache.frame(for: m)
            self.globalSection.0 = attributes
            self.flattenedSections.append(attributes)
        } else {
            let attributes = NSCollectionViewLayoutAttributes(forSupplementaryViewOfKind: .globalFooter, with: .zero)
            attributes.frame = m//self.cache.frame(for: m)
            self.globalSection.1 = attributes
            self.flattenedSections.append(attributes)
        }
    }
    
    //
    // MARK: CollectionView Vendor
    //
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        return self.cache.update(from: newBounds.size)
    }
    
    public override func prepare() {
        self.cache.recomputeCache(from: self.collectionView!)
    }
    
    public override var collectionViewContentSize: NSSize {
        return self.cache.size()
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return self.sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        switch elementKind {
        case NSCollectionView.SupplementaryElementKind.sectionHeader:
            return self.sections[safe: indexPath.section]?.header
        case NSCollectionView.SupplementaryElementKind.sectionFooter:
            return self.sections[safe: indexPath.section]?.footer
        default: return nil
        }
    }
    
    public override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return self.flattenedSections
    }
    
    //
    // MARK: Animations
    //
    
    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        guard !self.appearEffect.isEmpty else { return nil }
        let x = self.layoutAttributesForItem(at: itemIndexPath)
        if self.appearEffect.contains(.effectFade) {
            x?.alpha = 0.0
        }
        if self.appearEffect.contains(.slideUp) {
            x?.frame.origin.y -= x!.frame.height
        } else if self.appearEffect.contains(.slideDown) {
            x?.frame.origin.y += x!.frame.height
        } else if self.appearEffect.contains(.slideLeft) {
            x?.frame.origin.x += x!.frame.width
        } else if self.appearEffect.contains(.slideRight) {
            x?.frame.origin.x -= x!.frame.width
        }
        return x
    }
    
    public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        guard !self.disappearEffect.isEmpty else { return nil }
        let x = self.layoutAttributesForItem(at: itemIndexPath)
        if self.disappearEffect.contains(.effectFade) {
            x?.alpha = 0.0
        }
        if self.disappearEffect.contains(.slideUp) {
            x?.frame.origin.y -= x!.frame.height
        } else if self.disappearEffect.contains(.slideDown) {
            x?.frame.origin.y += x!.frame.height
        } else if self.disappearEffect.contains(.slideLeft) {
            x?.frame.origin.x += x!.frame.width
        } else if self.disappearEffect.contains(.slideRight) {
            x?.frame.origin.x -= x!.frame.width
        }
        return x
    }
    
    //
    //
    //
    
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
    
    ///
    private struct GlobalMetricsProvider: MetricsProvider {
        func size(for itemType: DynamicCache.ItemType, at idx: IndexPath, in collectionView: NSCollectionView) -> CGSize? {
            guard let layout = collectionView.collectionViewLayout as? NSCollectionViewListLayout
                else { return .zero }
            switch layout.layoutDefinition {
            case .global(let def):
                switch itemType {
                case .header:
                    return def.header
                case .item:
                    return def.item
                case .footer:
                    return def.footer
                }
            default: return .zero
            }
        }
    }
    
    ///
    private struct PerSectionMetricsProvider: MetricsProvider {
        func size(for itemType: DynamicCache.ItemType, at idx: IndexPath, in collectionView: NSCollectionView) -> CGSize? {
            guard let layout = collectionView.collectionViewLayout as? NSCollectionViewListLayout
                else { return .zero }
            switch layout.layoutDefinition {
            case .perSection(let sections):
                switch itemType {
                case .header:
                    return sections[idx.section].header
                case .item:
                    return sections[idx.section].item
                case .footer:
                    return sections[idx.section].footer
                }
            default: return .zero
            }
        }
    }
    
    ///
    private struct DelegateMetricsProvider: MetricsProvider {
        func size(for itemType: DynamicCache.ItemType, at idx: IndexPath, in collectionView: NSCollectionView) -> CGSize? {
            guard let layout = collectionView.collectionViewLayout as? NSCollectionViewListLayout
                else { return .zero }
            guard let delegate = collectionView.delegate as? NSCollectionViewDelegateFlowLayout
                else { return .zero }
            
            switch itemType {
            case .header:
                let header = delegate.collectionView(_:layout:referenceSizeForHeaderInSection:)
                return header?(collectionView, layout, idx.section)
            case .item:
                let item = delegate.collectionView(_:layout:sizeForItemAt:)
                return item?(collectionView, layout, idx)
            case .footer:
                let footer = delegate.collectionView(_:layout:referenceSizeForFooterInSection:)
                return footer?(collectionView, layout, idx.section)
            }
        }
    }
    
    ///
    ///
    ///
    
    /// The cache is encapsulated in its own structure to avoid mixing things up.
    /// It maps all the heights and y-locations of each cell, and maintains
    /// the expected overall height of the layout, recomputing at will.
    fileprivate struct DynamicCache {
        
        fileprivate enum ItemType {
            case header, footer, item
        }
        
        /// Describes layout for an item on a single axis.
        fileprivate struct MeasuredItem {
            fileprivate var origin: CGFloat = 0
            fileprivate var size: CGFloat = 0
            
            fileprivate func asRect(onAxis axis: NSLayoutConstraint.Orientation,
                                    _ other: MeasuredItem = MeasuredItem(origin: 0, size: 0)) -> NSRect {
                var rect = NSRect(value: (origin: self.origin, size: self.size), forAxis: axis)
                rect.origin.setValue(other.origin, forAxis: !axis)
                rect.size.setValue(other.size, forAxis: !axis)
                return rect
            }
        }
        
        /// Describes layout of an individual section.
        fileprivate struct MeasuredSection {
            fileprivate var index: Int
            fileprivate var count: Int
            
            fileprivate var header: MeasuredItem?
            fileprivate var footer: MeasuredItem?
            fileprivate var items: [MeasuredItem]
            
            fileprivate init(index: Int = 0, header: MeasuredItem? = nil,
                             footer: MeasuredItem? = nil, items: [MeasuredItem] = []) {
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
        
        fileprivate var sections = [MeasuredSection]()
        fileprivate var axis: NSLayoutConstraint.Orientation = .vertical
        
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
            let metricsProvider = layout.metricsProvider
            let counts = (0..<collectionView.numberOfSections).map {
                collectionView.numberOfItems(inSection: $0)
            }
            layout.willCompute(counts)
            
            // List Header
            if let listHeaderMetric = layout.globalSections.0 {
                let m = MeasuredItem(origin: currentOrigin, size: listHeaderMetric)
                currentOrigin += listHeaderMetric
                layout.didGlobalCompute(false, self.frame(for: m))
            }
            
            // List Contents
            for i in 0..<counts.count {
                var currentSection = MeasuredSection(index: i)
                
                // Section Header
                if let headerMetric = metricsProvider.size(for: .header, at: IndexPath(item: 0, section: i), in: collectionView) {
                    let headerSize = headerMetric.value(forAxis: self.axis)
                    currentSection.header = MeasuredItem(origin: currentOrigin, size: headerSize)
                    currentOrigin += headerSize
                    layout.didCompute(.header, IndexPath(item: 0, section: i), self.frame(for: currentSection.header!))
                }
                
                // Section Contents
                var sectionItems = [MeasuredItem]()
                for j in 0..<counts[i] {
                    
                    // Cell
                    let itemSize = metricsProvider.size(for: .item, at: IndexPath(item: j, section: i), in: collectionView)!.value(forAxis: self.axis)
                    let itemMeasure = MeasuredItem(origin: currentOrigin, size: itemSize)
                    sectionItems.insert(itemMeasure, at: j)
                    currentOrigin += itemSize
                    layout.didCompute(.item, IndexPath(item: j, section: i), self.frame(for: itemMeasure))
                }
                currentSection.items = sectionItems
                currentSection.count = counts[i]
                
                // Section Footer
                if let footerMetric = metricsProvider.size(for: .footer, at: IndexPath(item: 0, section: i), in: collectionView) {
                    let footerSize = footerMetric.value(forAxis: self.axis)
                    currentSection.footer = MeasuredItem(origin: currentOrigin, size: footerSize)
                    currentOrigin += footerSize
                    layout.didCompute(.footer, IndexPath(item: 0, section: i), self.frame(for: currentSection.footer!))
                }
                
                self.sections.insert(currentSection, at: i)
            }
            
            // List Footer
            if let listFooterMetric = layout.globalSections.1 {
                let m = MeasuredItem(origin: currentOrigin, size: listFooterMetric)
                currentOrigin += listFooterMetric
                layout.didGlobalCompute(true, self.frame(for: m))
            }
            
            // Aggregate
            self.axisSize = currentOrigin
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
            if self.axis == .vertical {
                guard self.otherAxisSize != from.width else { return false }
                self.otherAxisSize = from.width
            } else if self.axis == .horizontal {
                guard self.otherAxisSize != from.height else { return false }
                self.otherAxisSize = from.height
            }
            return true
        }
    }
}

public typealias SizeMetrics = NSCollectionViewListLayout.LayoutDefinition.SizeMetrics
fileprivate protocol MetricsProvider {
    func size(for: NSCollectionViewListLayout.DynamicCache.ItemType, at: IndexPath, in: NSCollectionView) -> CGSize?
}

///
/// AxisSizable
///

public protocol AxisSizable {
    typealias Axis = NSLayoutConstraint.Orientation
    
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

prefix func !(_ lhs: NSLayoutConstraint.Orientation) -> NSLayoutConstraint.Orientation {
    switch lhs {
    case .vertical: return .horizontal
    case .horizontal: return .vertical
    }
}

public extension IndexPath {
    public static let zero = IndexPath(item: 0, section: 0)
}

public extension NSCollectionView.SupplementaryElementKind {
    public static let globalHeader = NSCollectionView.SupplementaryElementKind(rawValue: "NSCollectionView.SupplementaryElementKind.GlobalHeader")
    public static let globalFooter = NSCollectionView.SupplementaryElementKind(rawValue: "NSCollectionView.SupplementaryElementKind.GlobalFooter")
}
