import Foundation

// Converts an NSRange to a Range for String indices.
// FIXME: Weird Range/Index mess happened here.
private func NSRangeToRange(s: String, r: NSRange) -> Range<String.Index> {
	let a  = (s as NSString).substring(to: r.location)
	let b  = (s as NSString).substring(with: r)
	let n1 = a.distance(from: a.startIndex, to: a.endIndex)
	let n2 = b.distance(from: b.startIndex, to: b.endIndex)
	let i1 = s.index(s.startIndex, offsetBy: n1)
	let i2 = s.index(i1, offsetBy: n2)
	return Range<String.Index>(uncheckedBounds: (lower: i1, upper: i2))
}

public typealias Regex = NSRegularExpression
public extension NSRegularExpression {
	
	// Easier/more convenient initializer.
	public convenience init(_ pattern: String, options: NSRegularExpressionOptions = .caseInsensitive) {
		try! self.init(pattern: pattern, options: options)
	}
	
	// Match the given input string, and optionally find ALL matches.
	public func match(input: String, all: Bool = false) -> [String] {
		let results = self.matches(in: input, options:[],
			range:NSMakeRange(0, input.characters.count))
		
		if all {
			return results.map {
				input.substring(with: NSRangeToRange(s: input, r: $0.range))
			}
		} else {
			return results.map {
				input.substring(with: NSRangeToRange(s: input, r: $0.range(at: 1)))
			}
		}
	}
}
