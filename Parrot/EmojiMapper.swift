import Cocoa
import Hangouts

let RawEmoticonMap = [
    ["-<@%"]: 0x1f41d,
    [":(|)"]: 0x1f435,
    [":(:)"]: 0x1f437,
    ["(]:{"]: 0x1f473,
    ["<\\3", "</3"]: 0x1f494,
    ["<3"]: 0x1f49c,
    ["~@~"]: 0x1f4a9,
    [":D", ":-D"]: 0x1f600,
    ["^_^"]: 0x1f601,
    [":)", ":-)", "=)"]: 0x1f603,
    ["=D"]: 0x1f604,
    ["^_^;;"]: 0x1f605,
    ["O:)", "O:-)", "O=)"]: 0x1f607,
    ["}:)", "}:-)", "}=)"]: 0x1f608,
    [";)", ";-)"]: 0x1f609,
    ["B)", "B-)"]: 0x1f60e,
    [":-|", ":|", "=|"]: 0x1f610,
    ["-_-"]: 0x1f611,
    ["o_o;"]: 0x1f613,
    ["u_u"]: 0x1f614,
    [":\\", ":/", ":-\\", ":-/", "=\\", "=/"]: 0x1f615,
    [":S", ":-S", ":s", ":-s"]: 0x1f616,
    [":*", ":-*"]: 0x1f617,
    [";*", ";-*"]: 0x1f618,
    [":P", ":-P", "=P", ":p", ":-p", "=p"]: 0x1f61b,
    [";P", ";-P", ";p", ";-p"]: 0x1f61c,
    [":(", ":-(", "=("]: 0x1f61e,
    [">.<", ">:(", ">:-(", ">=("]: 0x1f621,
    ["T_T", ":'(", ";_;", "='("]: 0x1f622,
    [">_<"]: 0x1f623,
    ["D:"]: 0x1f626,
    ["o.o", ":o", ":-o", "=o"]: 0x1f62e,
    ["O.O", ":O", ":-O", "=O"]: 0x1f632,
    ["x_x", "X-O", "X-o", "X(", "X-("]: 0x1f635,
    [":X)", ":3", "(=^..^=)", "(=^.^=)", "=^_^="]: 0x1f638,
]

class EmojiMapper {
    static let emoticonMap: [String: Int] = {
        var acc = Dictionary<String, Int>()
        for (chars, unicodeChar) in RawEmoticonMap {
            for s in chars {
                acc[s as! String] = unicodeChar
            }
        }
        return acc
    }()

    static func replaceEmoticonsWithEmoji(str: String) -> String {
        return emoticonMap.reduce(str) { (str, b) -> String in
            let unichar = String(UnicodeScalar(b.1))
            return (str as NSString).stringByReplacingOccurrencesOfString(b.0, withString: unichar)
        }
    }
}