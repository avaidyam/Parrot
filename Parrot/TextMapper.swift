import Cocoa
import Hangouts

class TextMapper {
    class func segmentsForInput(text: String) -> [ChatMessageSegment] {
        let textWithUnicodeEmoji = EmojiMapper.replaceEmoticonsWithEmoji(text)
        return [ChatMessageSegment(text: textWithUnicodeEmoji)]
    }

    class func attributedStringForText(text: String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: text)

        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.ByWordWrapping

        let linkDetector = try! NSDataDetector(types: NSTextCheckingType.Link.rawValue)
        for match in linkDetector.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count)) {
            if let url = match.URL {
                attrString.addAttribute(NSLinkAttributeName, value: url, range: match.range)
                attrString.addAttribute(NSForegroundColorAttributeName, value: NSColor.blueColor(), range: match.range)
                attrString.addAttribute(
                    NSUnderlineStyleAttributeName,
                    value: NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue),
                    range: match.range
                )
            }
        }

        //  TODO: Move this paragraph style and font stuff to the view
        attrString.addAttribute(
            NSFontAttributeName,
            value: NSFont.systemFontOfSize(12),
            range: NSMakeRange(0, attrString.length)
        )

        attrString.addAttribute(
            NSParagraphStyleAttributeName,
            value: style,
            range: NSMakeRange(0, attrString.length)
        )

        return attrString
    }
}