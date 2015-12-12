import Cocoa
import Hangouts

extension NSView {
    public class func instantiateFromNib<T: NSView>(identifier identifier: String, owner: AnyObject?) -> T? {
        var objects: NSArray?
        let nibName = T.className().componentsSeparatedByString(".").last
        if NSBundle.mainBundle().loadNibNamed(nibName!, owner: owner, topLevelObjects: &objects) {
            if let objects = objects {
                let candidate = objects.filter { $0 is T }.map { $0 as! T }.filter { $0.identifier == identifier }.first
                assert(candidate != nil, "Could not find view with identifier \(identifier) in \(nibName).xib.")
                return candidate
            }
        }
        assert(false, "Could not find view with identifier \(identifier) in \(nibName).xib.")
        return nil
    }
}