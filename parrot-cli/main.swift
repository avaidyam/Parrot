
// Start with the constant strings up here.
let str1 = "Parrot is not yet ready as a CLI tool."
let str2 = "Press ESC to exit."

// Launch an encapsulated interactive Terminal.
Terminal.interactive {
	var canvas = Canvas(pad(Terminal.size(), (2, 2)))
	canvas.border = Border.`default`()
	canvas.borderColor = ColorPair(4, colors: (.Magenta, .Black))
	
	// Write our three strings by centering them with specific colors.
	canvas.redraw = { c in
		
		// Readjust the size of the canvas.
		let str3 = "Debug[size: \(canvas.frame)]"
		c.size = pad(Terminal.size(), (2, 2)).s
		
		// Redraw all our strings.
		c.write(str1,
			point: (center(c.frame.s.w, str1.characters.count), center(c.frame.s.h, 0) - 1),
			colors: ColorPair(1, colors: (.Black, .Red)))
		c.write(str2,
			point: (center(c.frame.s.w, str2.characters.count), center(c.frame.s.h, 0) + 0),
			colors: ColorPair(2, colors: (.Black, .Blue)))
		c.write(str3,
			point: (center(c.frame.s.w, str3.characters.count), center(c.frame.s.h, 0) + 1),
			colors: ColorPair(3, colors: (.Black, .Yellow)))
	}
	
	// End the program when ESC is pressed.
	Terminal.bell()
	Terminal.wait(KeyCode(27))
}
