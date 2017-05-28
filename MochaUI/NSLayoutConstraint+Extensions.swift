//  Copyright (c) 2016 Indragie Karunaratne. All rights reserved.
//  Licensed under the MIT license, see LICENSE file for more info.

/* TODO: Just add as extension of anchors -- no new properties. */

import AppKit
import Mocha

public typealias View = NSView
public typealias LayoutPriority = NSLayoutPriority
public typealias LayoutGuide = NSLayoutGuide
public protocol LayoutRegion: AnyObject {}
extension View: LayoutRegion {}
extension LayoutGuide: LayoutRegion {}
public struct XAxis {}
public struct YAxis {}
public struct Dimension {}

public struct LayoutItem<C> {
    public let item: AnyObject
    public let attribute: NSLayoutAttribute
    public let multiplier: CGFloat
    public let constant: CGFloat
    
    fileprivate func constrain(_ secondItem: LayoutItem, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: secondItem.item, attribute: secondItem.attribute, multiplier: secondItem.multiplier, constant: secondItem.constant)
    }
    
    fileprivate func constrain(_ constant: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }
    
    fileprivate func itemWithMultiplier(_ multiplier: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: multiplier, constant: self.constant)
    }
    
    fileprivate func itemWithConstant(_ constant: CGFloat) -> LayoutItem {
        return LayoutItem(item: self.item, attribute: self.attribute, multiplier: self.multiplier, constant: constant)
    }
}

public func *<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithMultiplier(lhs.multiplier * rhs)
}

public func /<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithMultiplier(lhs.multiplier / rhs)
}

public func +<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithConstant(lhs.constant + rhs)
}

public func -<C>(lhs: LayoutItem<C>, rhs: CGFloat) -> LayoutItem<C> {
    return lhs.itemWithConstant(lhs.constant - rhs)
}

@discardableResult
public func ==<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    let x = lhs.constrain(rhs, relation: .equal)
    x.isActive = true
    return x
}

@discardableResult
public func ==(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    let x = lhs.constrain(rhs, relation: .equal)
    x.isActive = true
    return x
}

@discardableResult
public func >=<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    let x = lhs.constrain(rhs, relation: .greaterThanOrEqual)
    x.isActive = true
    return x
}

@discardableResult
public func >=(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    let x = lhs.constrain(rhs, relation: .greaterThanOrEqual)
    x.isActive = true
    return x
}

@discardableResult
public func <=<C>(lhs: LayoutItem<C>, rhs: LayoutItem<C>) -> NSLayoutConstraint {
    let x = lhs.constrain(rhs, relation: .lessThanOrEqual)
    x.isActive = true
    return x
}

@discardableResult
public func <=(lhs: LayoutItem<Dimension>, rhs: CGFloat) -> NSLayoutConstraint {
    let x = lhs.constrain(rhs, relation: .lessThanOrEqual)
    x.isActive = true
    return x
}

private func layoutItem<C>(_ item: AnyObject, _ attribute: NSLayoutAttribute) -> LayoutItem<C> {
    return LayoutItem(item: item, attribute: attribute, multiplier: 1.0, constant: 0.0)
}

public extension LayoutRegion {
    public var left: LayoutItem<XAxis> { return layoutItem(self, .left) }
    public var right: LayoutItem<XAxis> { return layoutItem(self, .right) }
    public var top: LayoutItem<YAxis> { return layoutItem(self, .top) }
    public var bottom: LayoutItem<YAxis> { return layoutItem(self, .bottom) }
    public var leading: LayoutItem<XAxis> { return layoutItem(self, .leading) }
    public var trailing: LayoutItem<XAxis> { return layoutItem(self, .trailing) }
    public var width: LayoutItem<Dimension> { return layoutItem(self, .width) }
    public var height: LayoutItem<Dimension> { return layoutItem(self, .height) }
    public var centerX: LayoutItem<XAxis> { return layoutItem(self, .centerX) }
    public var centerY: LayoutItem<YAxis> { return layoutItem(self, .centerY) }
}

public extension View {
    public var baseline: LayoutItem<YAxis> { return layoutItem(self, .lastBaseline) }
    
    @available(iOS 8.0, OSX 10.11, *)
    public var firstBaseline: LayoutItem<YAxis> { return layoutItem(self, .firstBaseline) }
    public var lastBaseline: LayoutItem<YAxis> { return layoutItem(self, .lastBaseline) }
}

precedencegroup PriorityPrecedence {
    lowerThan: ComparisonPrecedence
    higherThan: AssignmentPrecedence
}
infix operator ~ : PriorityPrecedence

public func ~(lhs: NSLayoutConstraint, rhs: LayoutPriority) -> NSLayoutConstraint {
    let newConstraint = NSLayoutConstraint(item: lhs.firstItem as Any, attribute: lhs.firstAttribute, relatedBy: lhs.relation, toItem: lhs.secondItem, attribute: lhs.secondAttribute, multiplier: lhs.multiplier, constant: lhs.constant)
    newConstraint.priority = rhs
    return newConstraint
}

public extension CALayer {
    
    /// Provides an optional NSLayoutGuide for use in a containing NSView.
    /// This allows CALayers to be laid out by the NSLayoutConstraint engine.
    ///
    /// Note: this does not happen automatically; in your NSView, override
    /// layout() while invoking super, and call syncLayout() manually.
    public fileprivate(set) var layout: NSLayoutGuide {
        get {
            if let _l = _layoutProp.get(self) {
                return _l
            } else {
                let guide = NSLayoutGuide()
                _layoutProp.set(self, value: guide)
                return guide
            }
        }
        set { _layoutProp.set(self, value: newValue) }
    }
    
    /// Allows the CALayer to reconcile the frame calculated by the NSLayoutConstraint
    /// engine, if applicable; not animatable (yet).
    public func syncLayout() {
        guard self.layout.owningView != nil else { return }
        self.frame = self.layout.frame
    }
}

public extension NSView {
    
    /// The preferred method of adding a sublayer to a view. Allows the CALayer
    /// to use an NSLayoutGuide and participate in the NSLayoutConstraint cycle.
    ///
    /// Note: does not do anything if the view is not layer-backed.
    public func add(sublayer layer: CALayer) {
        layer.removeFromSuperlayer()
        guard let superlayer = self.layer else { return }
        superlayer.addSublayer(layer)
        self.addLayoutGuide(layer.layout)
    }
    
    /// The preferred method of removing a sublayer from a view. Allows the CALayer
    /// to unregister its NSLayoutGuide from the NSView.
    public func remove(sublayer layer: CALayer) {
        guard let superlayer = self.layer, layer.superlayer == superlayer else { return }
        layer.removeFromSuperlayer()
        guard layer.layout.owningView == self else { return }
        self.removeLayoutGuide(layer.layout)
    }
}

fileprivate var _layoutProp = AssociatedProperty<CALayer, NSLayoutGuide>(.strong)
