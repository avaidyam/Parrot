import Foundation
import Darwin.ncurses

let str1 = "Parrot is not yet ready as a CLI tool."
let str2 = "Press ESC to exit."

func center(dimension: Int) -> Int {
	return Int((dimension / 2) - 1)
}

Terminal.begin()
var window = Canvas.origin
window.refresh(true)
let str3 = "Debug[size: \(Terminal.size())]"

wattron(window.window, COLOR_PAIR(ColorPair(1, colors: (.Black, .Red)).rawValue))
window.write(str1, point: (center(Terminal.size().w) - center(str1.characters.count), center(Terminal.size().h) - 1))
wattron(window.window, COLOR_PAIR(ColorPair(2, colors: (.Black, .Blue)).rawValue))
window.write(str2, point: (center(Terminal.size().w) - center(str2.characters.count), center(Terminal.size().h) + 0))
wattron(window.window, COLOR_PAIR(ColorPair(3, colors: (.Black, .Yellow)).rawValue))
window.write(str3, point: (center(Terminal.size().w) - center(str3.characters.count), center(Terminal.size().h) + 1))

wattron(window.window, COLOR_PAIR(ColorPair(4, colors: (.Magenta, .Black)).rawValue))
window.setBorder("||--****")

// End the program when ESC is pressed.
Terminal.bell()
Terminal.wait(KeyCode(rawValue: 27))
Terminal.end()
