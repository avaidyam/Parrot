import Foundation

class Regex {
	let internalExpression: NSRegularExpression
	let pattern: String
	
	init(_ pattern: String, options: NSRegularExpressionOptions = .CaseInsensitive) {
		self.pattern = pattern
		self.internalExpression = try! NSRegularExpression(pattern: pattern, options: options)
	}
	
	func test(input: String) -> Bool {
		let matches = self.internalExpression.matchesInString(input, options:[], range:NSMakeRange(0, input.characters.count))
		return matches.count > 0
	}
	
	func findall(input: String) -> [String] {
		let results: [NSTextCheckingResult] = self.internalExpression.matchesInString(
			input, options:[], range:NSMakeRange(0, input.characters.count)
			) as [NSTextCheckingResult]
		return results.map {
			input.substringWithRange(input.convertRangeFromNSRange($0.range))
		}
	}
	
	func matches(input: String) -> [String] {
		let results: [NSTextCheckingResult] = self.internalExpression.matchesInString(
			input, options:[], range:NSMakeRange(0, input.characters.count)
			) as [NSTextCheckingResult]
		return results.map {
			input.substringWithRange(input.convertRangeFromNSRange($0.rangeAtIndex(1)))
		}
	}
}

// from @matt http://stackoverflow.com/a/24318861/679081
func delay(delay: Double, closure: ()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}
