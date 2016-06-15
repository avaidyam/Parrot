import Foundation

/* TODO: Localization support for timeAgo. */

/// from @jack205: https://gist.github.com/jacks205/4a77fb1703632eb9ae79
internal let _units: Calendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
public extension Date {
	public func relativeString(_ numeric: Bool = false) -> String {
		
		// Setup for calendar components.
		let date = self, now = Date()
		let calendar = Calendar.current()
		let earliest = (now as NSDate).earlierDate(date) as Date
		let latest = (earliest == now) ? date : now
		let components = calendar.components(_units, from: earliest, to: latest, options: Calendar.Options())
		
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

// TODO: not used yet, needs a bit more API work.
public extension DateComponentsFormatter {
	public class func localizedRelativeString(from interval: TimeInterval) -> String? {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .full
		formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
		formatter.maximumUnitCount = 1
		
		if interval < 60.0 {
			return "just now" // TODO: localize!
		}
		guard let str = formatter.string(from: interval) else {
			return nil
		}
		return str + " ago" // TODO: localize!
	}
}
