import Foundation

// Provides equality and comparison operators for NSDate
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

// Microseconds
public let MicrosecondsPerSecond = 1000000.0
public func from_timestamp(microsecond_timestamp: NSNumber?) -> NSDate? {
	if microsecond_timestamp == nil {
		return nil
	}
	let date = from_timestamp(microsecond_timestamp!)
	return date
}

// Convert a microsecond timestamp to an NSDate instance.
public func from_timestamp(microsecond_timestamp: NSNumber) -> NSDate {
	return NSDate(timeIntervalSince1970: microsecond_timestamp.doubleValue / MicrosecondsPerSecond)
}

// Convert UTC datetime to microsecond timestamp used by Hangouts.
public func to_timestamp(date: NSDate) -> NSNumber {
	return date.timeIntervalSince1970 * MicrosecondsPerSecond
}
