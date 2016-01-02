import Foundation
import Darwin.ncurses

// The string we want to show in the window for now.
let str = "Parrot is not yet implemented as a CLI."

// A nifty utility function for determining the centers of dimensions.
func center(dimension: Int) -> Int32 {
	return Int32((dimension / 2) - 1)
}
func center(dimension: Int32) -> Int32 {
	return Int32((dimension / 2) - 1)
}

// Create a new window first.
var win = initscr()

func redraw(sig: Int32) {
	
	// Block terminal resize signals for now.
	signal(SIGWINCH, SIG_IGN)
	
	// Reinitialize the window to update data structures.
	endwin()
	win = initscr()
	start_color()
	wrefresh(win)
	wclear(win)
	
	init_pair(1, Int16(Color.Black.rawValue), Int16(Color.Red.rawValue))
	
	// Draw our text in the middle of the window.
	attron(COLOR_PAIR(1))
	mvaddstr(center(LINES), center(COLS) - center(str.characters.count), str)
	wrefresh(win)
	
	// Allow terminal resizes again.
	signal(SIGWINCH, redraw);
}

// Catch all terminal resizes and call it initially for drawing.
signal(SIGWINCH, redraw)
redraw(Int32(0))

// End the program when ESC is pressed.
while wgetch(win) != 27 {}
endwin()
