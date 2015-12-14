import Foundation

/* TODO: Refactor back into plain NSRegularExpression. */

public class Regex {
	let internalExpression: NSRegularExpression
	let pattern: String
	
	public init(_ pattern: String, options: NSRegularExpressionOptions = .CaseInsensitive) {
		self.pattern = pattern
		self.internalExpression = try! NSRegularExpression(pattern: pattern, options: options)
	}
	
	private class func _convertRangeFromNSRange(str: String, r: NSRange) -> Range<String.Index> {
		let a  = (str as NSString).substringToIndex(r.location)
		let b  = (str as NSString).substringWithRange(r)
		let n1 = a.startIndex.distanceTo(a.endIndex)
		let n2 = b.startIndex.distanceTo(b.endIndex)
		let i1 = str.startIndex.advancedBy(n1)
		let i2 = i1.advancedBy(n2)
		return  Range<String.Index>(start: i1, end: i2)
	}
	
	public func findall(input: String) -> [String] {
		let results: [NSTextCheckingResult] = self.internalExpression.matchesInString(
			input, options:[], range:NSMakeRange(0, input.characters.count)
			) as [NSTextCheckingResult]
		return results.map {
			input.substringWithRange(Regex._convertRangeFromNSRange(input, r: $0.range))
		}
	}
	
	public func matches(input: String) -> [String] {
		let results: [NSTextCheckingResult] = self.internalExpression.matchesInString(
			input, options:[], range:NSMakeRange(0, input.characters.count)
			) as [NSTextCheckingResult]
		return results.map {
			input.substringWithRange(Regex._convertRangeFromNSRange(input, r: $0.rangeAtIndex(1)))
		}
	}
}
