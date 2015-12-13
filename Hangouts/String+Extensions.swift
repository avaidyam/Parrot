import Foundation
import CommonCrypto

public extension String {
	public func convertRangeFromNSRange(r: NSRange) -> Range<String.Index> {
		let a  = (self as NSString).substringToIndex(r.location)
		let b  = (self as NSString).substringWithRange(r)
		let n1 = a.startIndex.distanceTo(a.endIndex)
		let n2 = b.startIndex.distanceTo(b.endIndex)
		let i1 = startIndex.advancedBy(n1)
		let i2 = i1.advancedBy(n2)
		return  Range<String.Index>(start: i1, end: i2)
	}
	
	public func contains(find: String) -> Bool{
		return self.rangeOfString(find) != nil
	}
	
	public func urlEncodedStringWithEncoding(encoding: NSStringEncoding) -> String {
		let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFStringRef
		let charactersToLeaveUnescaped = "[]." as CFStringRef
		let str = self as NSString
		let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
			str as CFString, charactersToLeaveUnescaped, charactersToBeEscaped,
			CFStringConvertNSStringEncodingToEncoding(encoding)) as NSString
		return result as String
	}
	
	public func SHA1() -> String {
		let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
		var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
		CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
		let hexBytes = digest.map {
			String(format: "%02hhx", $0)
		}
		return hexBytes.joinWithSeparator("")
	}
}
