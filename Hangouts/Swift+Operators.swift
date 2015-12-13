import Foundation

public func == <A:Equatable, B:Equatable> (tuple1:(A,B),tuple2:(A,B)) -> Bool {
	return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}

public func == <A:Equatable, B:Equatable, C:Equatable, D:Equatable> (tuple1:(A,B,C,D),tuple2:(A,B,C,D)) -> Bool {
	return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1) && (tuple1.2 == tuple2.2) && (tuple1.3 == tuple2.3)
}

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

infix operator +| {}
public func +| <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
	var map = Dictionary<K,V>()
	for (k, v) in left {
		map[k] = v
	}
	for (k, v) in right {
		map[k] = v
	}
	return map
}

// from @matt http://stackoverflow.com/a/24318861/679081
public func delay(delay: Double, closure: ()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}
