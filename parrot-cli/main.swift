import Foundation
import Darwin.ncurses

let str1 = "Parrot is not yet ready as a CLI tool."
let str2 = "Press ESC to exit."

func center(dimension: Int) -> Int {
	return Int((dimension / 2) - 1)
}

// Launch an encapsulated interactive Terminal.
Terminal.interactive {
	var window = Canvas()!
	window.setBorder(Border.`default`(), colors: ColorPair(4, colors: (.Magenta, .Black)))
	let str3 = "Debug[size: \(Terminal.size())]"
	
	window.write(str1,
		point: (center(Terminal.size().w) - center(str1.characters.count), center(Terminal.size().h) - 1),
		colors: ColorPair(1, colors: (.Black, .Red)))
	window.write(str2,
		point: (center(Terminal.size().w) - center(str2.characters.count), center(Terminal.size().h) + 0),
		colors: ColorPair(2, colors: (.Black, .Blue)))
	window.write(str3,
		point: (center(Terminal.size().w) - center(str3.characters.count), center(Terminal.size().h) + 1),
		colors: ColorPair(3, colors: (.Black, .Yellow)))
	
	/*Terminal.onResize {
		window.refresh(true)
		window.move((0, 0, Terminal.size().w, Terminal.size().h)) // stretch!
	}*/
	
	// End the program when ESC is pressed.
	Terminal.bell()
	Terminal.wait(KeyCode(27))
}
