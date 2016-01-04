import Foundation

// Converts an NSRange to a Range for String indices.
private func NSRangeToRange(s: String, r: NSRange) -> Range<String.Index> {
	let a  = (s as NSString).substringToIndex(r.location)
	let b  = (s as NSString).substringWithRange(r)
	let n1 = a.startIndex.distanceTo(a.endIndex)
	let n2 = b.startIndex.distanceTo(b.endIndex)
	let i1 = s.startIndex.advancedBy(n1)
	let i2 = i1.advancedBy(n2)
	return  Range<String.Index>(start: i1, end: i2)
}

public typealias Regex = NSRegularExpression
public extension NSRegularExpression {
	
	// Easier/more convenient initializer.
	public convenience init(_ pattern: String, options: NSRegularExpressionOptions = .CaseInsensitive) {
		try! self.init(pattern: pattern, options: options)
	}
	
	// Match the given input string, and optionally find ALL matches.
	public func match(input: String, all: Bool = false) -> [String] {
		let results = self.matchesInString(input, options:[],
			range:NSMakeRange(0, input.characters.count))
		
		if all {
			return results.map {
				input.substringWithRange(NSRangeToRange(input, r: $0.range))
			}
		} else {
			return results.map {
				input.substringWithRange(NSRangeToRange(input, r: $0.rangeAtIndex(1)))
			}
		}
	}
}
