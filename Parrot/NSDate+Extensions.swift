import Foundation

/// from @jack205: https://gist.github.com/jacks205/4a77fb1703632eb9ae79
public extension NSDate {
	func timeAgo(numericDates: Bool = false) -> String {
		let date = self, now = NSDate()
		let calendar = NSCalendar.currentCalendar()
		let earliest = now.earlierDate(date)
		let latest = (earliest == now) ? date : now
		let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
		
		if (components.year >= 2) {
			return "\(components.year) years ago"
		} else if (components.year >= 1){
			if (numericDates){
				return "1 year ago"
			} else {
				return "last year"
			}
		} else if (components.month >= 2) {
			return "\(components.month) months ago"
		} else if (components.month >= 1){
			if (numericDates){
				return "1 month ago"
			} else {
				return "last month"
			}
		} else if (components.weekOfYear >= 2) {
			return "\(components.weekOfYear) weeks ago"
		} else if (components.weekOfYear >= 1){
			if (numericDates){
				return "1 week ago"
			} else {
				return "last week"
			}
		} else if (components.day >= 2) {
			return "\(components.day) days ago"
		} else if (components.day >= 1){
			if (numericDates){
				return "1 day ago"
			} else {
				return "yesterday"
			}
		} else if (components.hour >= 2) {
			return "\(components.hour) hours ago"
		} else if (components.hour >= 1){
			if (numericDates){
				return "1 hour ago"
			} else {
				return "an hour ago"
			}
		} else if (components.minute >= 2) {
			return "\(components.minute) minutes ago"
		} else if (components.minute >= 1){
			if (numericDates){
				return "1 minute ago"
			} else {
				return "a minute ago"
			}
		} else if (components.second >= 3) {
			return "\(components.second) seconds ago"
		} else {
			return "just now"
		}
	}
}
