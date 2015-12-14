# Introduction
Parrot is an extensible instant messaging architecture for OS X. It currently features a reverse-engineered API for Google Hangouts, done by [Tom Dryer](https://github.com/tdryer/hangups), with scaffolding around it for multifaceted use. In the future, Facebook Messenger, custom Jabber, WhatsApp, and more protocols may be supported, depending on API availability (or reverse engineering).

# Architecture
The architecture is as follows:
	- Applications
		- Parrot (GUI):
			[todo]
		- parrot-cli (CLI):
			[todo]
	- Frameworks
		- Hangouts (framework)
			[todo]
		- HangoutsProvider (XPC)
			[todo]
	- Extensions
		- Share:
			[todo]
		- Link:
			[todo]
		- Today: 
			[todo]
	- Unit Tests
		[todo]

# Development
	[todo]

# Progress
	[ ] Support multiple conversation views.
	[ ] Support drag/drop: dragging images/text/links will add them.
	[ ] Support pasteboard: pasting a user will translate to: First Last <email@domain.com>.
	[ ] Support group views: Favorites will be pinned to top.
	[ ] Support tooltips: similar to pasteboard view.
	[ ] Support force touch and gestures for actions.
	[ ] Support menus (detail popover), force click, double click.
	[ ] Support toggling sidebar (once closed)
	[ ] Support pin to favorites and snooze for later.
	[ ] Sending voice and video messages, along with photos and stickers.
	[ ] Support a user list view instead of only conversations.
	[ ] Support keybindings ctrl+arrow to shift conversations.
	[ ] Support custom conversation sort (time, alphabet, or manually).
	[ ] Support showing images for users in chat view.
	[ ] Support sounds and vibrations in NotificationManager.
	[ ] Support auto-reply and hangouts mood + status.
	[ ] Add Transcript viewer.
	[ ] Support Date/Time, Address, Transit detectors.
	[ ] Fix proper bold, italics, underline.
