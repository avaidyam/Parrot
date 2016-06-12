import Foundation

/* TODO: Localization support for timeAgo. */

/// from @jack205: https://gist.github.com/jacks205/4a77fb1703632eb9ae79
private let _units: NSCalendarUnit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
public extension NSDate {
	public func relativeString(numeric: Bool = false) -> String {
		
		// Setup for calendar components.
		let date = self, now = NSDate()
		let calendar = NSCalendar.current()
		let earliest = now.earlierDate(date)
		let latest = (earliest == now) ? date : now
		let components = calendar.components(_units, from: earliest, to: latest, options: NSCalendarOptions())
		
		// Format calendar components into string.
		if (components.year >= 2) {
			return "\(components.year) years ago"
		} else if (components.year >= 1) {
			return numeric ? "1 year ago" : "last year"
		} else if (components.month >= 2) {
			return "\(components.month) months ago"
		} else if (components.month >= 1) {
			return numeric ? "1 month ago" : "last month"
		} else if (components.weekOfYear >= 2) {
			return "\(components.weekOfYear) weeks ago"
		} else if (components.weekOfYear >= 1) {
			return numeric ? "1 week ago" : "last week"
		} else if (components.day >= 2) {
			return "\(components.day) days ago"
		} else if (components.day >= 1) {
			return numeric ? "1 day ago" : "a day ago"
		} else if (components.hour >= 2) {
			return "\(components.hour) hours ago"
		} else if (components.hour >= 1){
			return numeric ? "1 hour ago" : "an hour ago"
		} else if (components.minute >= 2) {
			return "\(components.minute) minutes ago"
		} else if (components.minute >= 1) {
			return numeric ? "1 minute ago" : "a minute ago"
		//} else if (components.second >= 3) {
		//	return "\(components.second) seconds ago"
		} else {
			return "just now"
		}
	}
}

public extension NSTimer {
	
	/// Trigger a notification every minute, starting from the next minute.
	public class func scheduledWallclock(target: AnyObject, selector: Selector) -> NSTimer {
		let comps = NSCalendar.current().components(_units, from: NSDate())
		comps.minute += 1; comps.second = 0
		let date = NSCalendar.current().date(from: comps)!
		let timer = NSTimer(fireAt: date, interval: 60, target: target,
		                    selector: selector, userInfo: nil, repeats: true)
		NSRunLoop.main().add(timer, forMode: NSDefaultRunLoopMode)
		return timer
	}
}
