#include <curses.h>

// #defines aren't accessible to Swift.
static const int _NORMAL = A_NORMAL;
static const int _ATTRIBUTES = A_ATTRIBUTES;
static const int _CHARTEXT = A_CHARTEXT;
static const int _COLOR = A_COLOR;
static const int _STANDOUT = A_STANDOUT;
static const int _UNDERLINE = A_UNDERLINE;
static const int _REVERSE = A_REVERSE;
static const int _BLINK = A_BLINK;
static const int _DIM = A_DIM;
static const int _BOLD = A_BOLD;
static const int _ALTCHARSET = A_ALTCHARSET;
static const int _INVIS = A_INVIS;
static const int _PROTECT = A_PROTECT;
static const int _HORIZONTAL = A_HORIZONTAL;
static const int _LEFT = A_LEFT;
static const int _LOW = A_LOW;
static const int _RIGHT = A_RIGHT;
static const int _TOP = A_TOP;
static const int _VERTICAL = A_VERTICAL;

// Seriously annoying bridged functions for Swift.
// NCurses is pulling some weird funky magic with these #defines.
static inline unsigned _ULCORNER() {
	return ACS_ULCORNER;
}
static inline unsigned _LLCORNER() {
	return ACS_LLCORNER;
}
static inline unsigned _URCORNER() {
	return ACS_URCORNER;
}
static inline unsigned _LRCORNER() {
	return ACS_LRCORNER;
}
static inline unsigned _LTEE() {
	return ACS_LTEE;
}
static inline unsigned _RTEE() {
	return ACS_RTEE;
}
static inline unsigned _BTEE() {
	return ACS_BTEE;
}
static inline unsigned _TTEE() {
	return ACS_TTEE;
}
static inline unsigned _HLINE() {
	return ACS_HLINE;
}
static inline unsigned _VLINE() {
	return ACS_VLINE;
}
static inline unsigned _PLUS() {
	return ACS_PLUS;
}
static inline unsigned _S1() {
	return ACS_S1;
}
static inline unsigned _S9() {
	return ACS_S9;
}
static inline unsigned _DIAMOND() {
	return ACS_DIAMOND;
}
static inline unsigned _CKBOARD() {
	return ACS_CKBOARD;
}
static inline unsigned _DEGREE() {
	return ACS_DEGREE;
}
static inline unsigned _PLMINUS() {
	return ACS_PLMINUS;
}
static inline unsigned _BULLET() {
	return ACS_BULLET;
}
static inline unsigned _LARROW() {
	return ACS_LARROW;
}
static inline unsigned _RARROW() {
	return ACS_RARROW;
}
static inline unsigned _DARROW() {
	return ACS_DARROW;
}
static inline unsigned _UARROW() {
	return ACS_UARROW;
}
static inline unsigned _BOARD() {
	return ACS_BOARD;
}
static inline unsigned _LANTERN() {
	return ACS_LANTERN;
}
static inline unsigned _BLOCK() {
	return ACS_BLOCK;
}
