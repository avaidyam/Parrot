import Foundation
import Darwin.ncurses

let str1 = "Parrot is not yet implemented as a CLI."
let str2 = "Please try again later though!"

func center(dimension: Int) -> Int32 {
	return Int32((dimension / 2) - 1)
}

// Create a new window first.
var win = Terminal.begin()
let draw = {
	// Reinitialize the window to update data structures.
	Terminal.end()
	win = Terminal.begin()
	Terminal.startColors()
	wrefresh(win)
	wclear(win)
	
	// Draw our text in the middle of the window.
	// Set ColorPairs that we can use and looks cool!
	wattron(win, COLOR_PAIR(ColorPair(1, colors: (.Black, .Red)).rawValue))
	mvaddstr(center(Terminal.size().rows), center(Terminal.size().columns) - center(str1.characters.count), str1)
	wattron(win, COLOR_PAIR(ColorPair(2, colors: (.Black, .Blue)).rawValue))
	mvaddstr(center(Terminal.size().rows) + 1, center(Terminal.size().columns) - center(str2.characters.count), str2)
	wrefresh(win)
	
	// Draw a window border.
	wattron(win, COLOR_PAIR(ColorPair(3, colors: (.Yellow, .Black)).rawValue))
	let b = Border.fromString("||--****")!
	wborder(win, b.leftSide, b.rightSide, b.topSide, b.bottomSide,
		b.topLeft, b.topRight, b.bottomLeft, b.bottomRight)
	wrefresh(win)
}

// Method 1: We can refresh the UI only on size changes.
// We'll catch SIGWINCH's and mask them out when we update.
func redraw(sig: Int32) {
	signal(SIGWINCH, SIG_IGN)
	draw()
	signal(SIGWINCH, redraw)
}
signal(SIGWINCH, redraw)
redraw(Int32(0))

// Method 2: We can have a 60fps update event loop to refresh the UI.
// A 0.048 modifier gives us 16ms update latency. This is a TERRIBLE idea!
/*
EventLoop(name: "com.avaidyam.parrot-cli.main", frequency: 0.048) {
	draw()
	print("testing")
}
*/

// End the program when ESC is pressed.
Terminal.bell()
while getch() != 27 {}
Terminal.end()
