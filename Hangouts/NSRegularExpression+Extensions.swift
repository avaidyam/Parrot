import Foundation

public class Regex {
	let internalExpression: NSRegularExpression
	let pattern: String
	
	public init(_ pattern: String, options: NSRegularExpressionOptions = .CaseInsensitive) {
		self.pattern = pattern
		self.internalExpression = try! NSRegularExpression(pattern: pattern, options: options)
	}
	
	public func test(input: String) -> Bool {
		let matches = self.internalExpression.matchesInString(input, options:[], range:NSMakeRange(0, input.characters.count))
		return matches.count > 0
	}
	
	public func findall(input: String) -> [String] {
		let results: [NSTextCheckingResult] = self.internalExpression.matchesInString(
			input, options:[], range:NSMakeRange(0, input.characters.count)
			) as [NSTextCheckingResult]
		return results.map {
			input.substringWithRange(input.convertRangeFromNSRange($0.range))
		}
	}
	
	public func matches(input: String) -> [String] {
		let results: [NSTextCheckingResult] = self.internalExpression.matchesInString(
			input, options:[], range:NSMakeRange(0, input.characters.count)
			) as [NSTextCheckingResult]
		return results.map {
			input.substringWithRange(input.convertRangeFromNSRange($0.rangeAtIndex(1)))
		}
	}
}
