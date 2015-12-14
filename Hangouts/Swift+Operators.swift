import Foundation

/* NSDate Comparison */

public func <=(lhs: NSDate, rhs: NSDate) -> Bool {
	let res = lhs.compare(rhs)
	return res == .OrderedAscending || res == .OrderedSame
}

public func >=(lhs: NSDate, rhs: NSDate) -> Bool {
	let res = lhs.compare(rhs)
	return res == .OrderedDescending || res == .OrderedSame
}

public func >(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedDescending
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedAscending
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedSame
}
