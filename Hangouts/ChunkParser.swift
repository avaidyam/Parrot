import Foundation

// Parse data from the backward channel into chunks.
// Responses from the backward channel consist of a sequence of chunks which
// are streamed to the client. Each chunk is prefixed with its length,
// followed by a newline. The length allows the client to identify when the
// entire chunk has been received.
public class ChunkParser {
	
	public var buf = NSMutableData()
	
	// Yield submissions generated from received data.
	// Responses from the push endpoint consist of a sequence of submissions.
	// Each submission is prefixed with its length followed by a newline.
	// The buffer may not be decodable as UTF-8 if there's a split multi-byte
	// character at the end. To handle this, do a "best effort" decode of the
	// buffer to decode as much of it as possible.
	// The length is actually the length of the string as reported by
	// JavaScript. JavaScript's string length function returns the number of
	// code units in the string, represented in UTF-16. We can emulate this by
	// encoding everything in UTF-16 and multipling the reported length by 2.
	// Note that when encoding a string in UTF-16, Python will prepend a
	// byte-order character, so we need to remove the first two bytes.
	public func getChunks(newBytes: NSData) -> [String] {
		buf.appendData(newBytes)
		var submissions = [String]()
		
		while buf.length > 0 {
			if let decoded = bestEffortDecode(buf) {
				let bufUTF16 = decoded.dataUsingEncoding(NSUTF16BigEndianStringEncoding)!
				let decodedUtf16LengthInChars = bufUTF16.length / 2
				
				let lengths = Regex("([0-9]+)\n").match(decoded, all: true)
				if let length_str = lengths.first {
					let length_str_without_newline = length_str.substringToIndex(length_str.endIndex.advancedBy(-1))
					if let length = Int(length_str_without_newline) {
						if decodedUtf16LengthInChars - length_str.characters.count < length {
							break
						}
						
						let subData = bufUTF16.subdataWithRange(NSMakeRange(length_str.characters.count * 2, length * 2))
						let submission = NSString(data: subData, encoding: NSUTF16BigEndianStringEncoding)! as String
						submissions.append(submission)
						
						let submissionAsUTF8 = submission.dataUsingEncoding(NSUTF8StringEncoding)!
						
						let removeRange = NSMakeRange(0, length_str.characters.count + submissionAsUTF8.length)
						buf.replaceBytesInRange(removeRange, withBytes: nil, length: 0)
					} else {
						break
					}
				} else {
					break
				}
			}
		}
		return submissions
	}
	
	// Decode data_bytes into a string using UTF-8.
	// If data_bytes cannot be decoded, pop the last byte until it can be or
	// return an empty string.
	public func bestEffortDecode(data: NSData) -> String? {
		for var i = 0; i < data.length; i++ {
			if let s = NSString(data: data.subdataWithRange(NSMakeRange(0, data.length - i)), encoding: NSUTF8StringEncoding) {
				return s as String
			}
		}
		return nil
	}
}
