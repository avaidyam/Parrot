import Foundation

public extension NSDate {
	public func shortFormat() -> String {
		let dateFmt = NSDateFormatter()
		if self.isToday {
			dateFmt.dateFormat = "h:mm a"
		} else if self.isYesterday {
			return "Yesterday"
		} else {
			dateFmt.dateFormat = "MM/dd/YY"
		}
		return dateFmt.stringFromDate(self)
	}
	
	public func isSameDayAs(other: NSDate) -> Bool {
		let calendar = NSCalendar.currentCalendar()
		let comparisonComponents: NSCalendarUnit = [
			NSCalendarUnit.Day,
			NSCalendarUnit.Month,
			NSCalendarUnit.Year,
			NSCalendarUnit.Era
		]
		let otherComponents = calendar.components(comparisonComponents, fromDate: other)
		let selfComponents = calendar.components(comparisonComponents, fromDate: self)
		return otherComponents == selfComponents
	}
	
	public var isToday: Bool {
		get {
			return self.isSameDayAs(NSDate())
		}
	}
	
	public var isYesterday: Bool {
		get {
			return isSameDayAs(NSDate().dateByAddingTimeInterval(-1 * 60 * 60 * 24))
		}
	}
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