import AppKit

class SequentialTextSelectionManager: NSResponder {
	
	private private(set) var textViews = [String: TextViewMetadata]()
	private private(set) var sortedTextViews = NSMutableOrderedSet()
	private var currentSession: TextViewSelectionSession?
	private lazy var cachedAttributedText: AttributedString? = {
		return self.buildAttributedStringForCurrentSession()
	}()
	private var eventMonitor: AnyObject?
	private var firstResponder: Bool = false
	
	
	
	
	
	
	
	
	
	
	/// Register an NSTextView with the SequentialTextSelectionManager.
	/// Note that each NSTextView must have a unique identifier when registered.
	func register(textView: NSTextView, withUniqueIdentifier identifier: String) {
		self.register(textView: textView, withUniqueIdentifier: identifier, transformer: nil)
	}
	
	/// Register an NSTextView with the SequentialTextSelectionManager.
	/// Note that each NSTextView must have a unique identifier when registered.
	func register(textView: NSTextView, withUniqueIdentifier identifier: String,
	              transformer block: ((AttributedString) -> AttributedString)?) {
		
		self.unregister(textView: textView)
		textView.selectionIdentifier = identifier
		if (self.currentSession != nil) {
			let range = self.currentSession?.selectionRanges[identifier]
			if (range != nil) {
				textView.stsm_highlightSelectedTextInRange(range: range!.range, drawActive: self.firstResponder)
			}
		}
		self.textViews[identifier] = TextViewMetadata(textView: textView, transformationBlock: block)
		self.sortedTextViews.add(textView)
		self.sortTextViews()
	}
	
	/// Unregister an NSTextView from the SequentialTextSelectionManager.
	func unregister(textView: NSTextView) {
		if textView.selectionIdentifier == nil {
			return
		}
		self.textViews.removeValue(forKey: textView.selectionIdentifier!)
		self.sortedTextViews.remove(textView)
		self.sortTextViews()
		textView.selectionIdentifier = nil
	}
	
	/// Unregister all NSTextViews from the SequentialTextSelectionManager.
	func unregisterAll() {
		self.textViews.removeAll()
		self.sortedTextViews.removeAllObjects()
	}
	
	/// Add and remove the NSEventMonitor when we need to...
	override convenience init() {
		self.init(coder: NSCoder())!
	}
	required init?(coder: NSCoder) {
		super.init()
		self.eventMonitor = self.addLocalEventMonitor()
	}
	deinit {
		NSEvent.removeMonitor(self.eventMonitor!)
	}
	
	/// Begin monitoring for mouse events that indicate dragging of text.
	private func addLocalEventMonitor() -> AnyObject {
		let ev: NSEventMask = [.leftMouseDown, .leftMouseDragged, .leftMouseUp, .rightMouseDown]
		return NSEvent.addLocalMonitorForEvents(matching: ev) { event in
			switch event.type {
			case .leftMouseDown:
				return self.handleLeftMouseDown(event: event) ? nil : event
			case .leftMouseDragged:
				return self.handleLeftMouseDragged(event: event) ? nil : event
			case .leftMouseUp:
				return self.handleLeftMouseUp(event: event) ? nil : event
			case .rightMouseDown:
				return self.handleRightMouseDown(event: event) ? nil : event
			default: return event
			}
			}!
	}
	
	/// Determine whether the event matches a valid and registered text view.
	private func validTextView(event: NSEvent) -> NSTextView? {
		let contentView = event.window?.contentView
		let point = contentView?.convert(event.locationInWindow, from: nil)
		let view = contentView?.hitTest(point!)
		
		if  let textView = view as? NSTextView,
			let identifier = textView.selectionIdentifier
			where textView.isSelectable() {
			
			return (self.textViews[identifier] != nil) ? textView : nil
		} else { return nil }
	}
	
	/// End a current session and start a new one if applicable.
	private func handleLeftMouseDown(event: NSEvent) -> Bool {
		guard event.clickCount == 1 else { return false }
		self.endSession()
		if	let textView = self.validTextView(event: event)
			where textView.window?.firstResponder != textView {
			
			self.currentSession = TextViewSelectionSession(textView: textView, event: event)
			return true
		}
		return false
	}
	
	///
	private func handleLeftMouseUp(event: NSEvent) -> Bool {
		guard self.currentSession != nil else { return false }
		
		event.window?.makeFirstResponder(self)
		if	let textView = self.validTextView(event: event),
			let index = CharacterIndexForTextViewEvent(event, textView)
			where Int(index) < (textView.string! as NSString).length {
			
			var attributes = textView.attributedString().attributes(at: Int(index), effectiveRange: nil)
			if let link = attributes[NSLinkAttributeName] {
				textView.clicked(onLink: link, at: Int(index))
			}
		}
		return true
	}
	
	///
	private func handleLeftMouseDragged(event: NSEvent) -> Bool {
		guard self.currentSession != nil else { return false }
		
		if let textView = self.validTextView(event: event) {
			textView.window!.makeFirstResponder(textView)
			let identifier = self.currentSession?.textViewIdentifier
			
			let affinity: NSSelectionAffinity = (event.locationInWindow.y < self.currentSession?.windowPoint.y) ? .downstream : .upstream
			self.currentSession?.windowPoint = event.locationInWindow
			
			var current: UInt
			if textView.selectionIdentifier == identifier {
				current = (self.currentSession?.characterIndex)!
			} else {
				let meta = self.textViews[identifier!]
				let start = self.sortedTextViews.index(of: meta!.textView)
				let end = self.sortedTextViews.index(of: textView)
				current = UInt((end >= start) ? 0 : (textView.string! as NSString).length)
			}
			
			let index = CharacterIndexForTextViewEvent(event, textView)
			let range = ForwardRangeForIndices(idx1: index!, current)
			self.setSelectionRangeForTextView(textView: textView, withRange: range)
			self.processCompleteSelectionsForTargetTextView(textView: textView, affinity: affinity)
		}
		return true
	}
	
	/// Display a menu if right clicked atop a valid text view.
	private func handleRightMouseDown(event: NSEvent) -> Bool {
		guard self.currentSession != nil else { return false }
		
		event.window?.makeFirstResponder(self)
		if let textView = self.validTextView(event: event) {
			let menu = self.menuForEvent(theEvent: event)
			NSMenu.popUpContextMenu(menu, with: event, for: textView)
		}
		return true
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	func copy(sender: AnyObject) {
		NSPasteboard.general().clearContents()
		NSPasteboard.general().writeObjects([self.cachedAttributedText!])
	}
	
	func buildSharingMenu() -> NSMenu {
		let shareMenu = NSMenu(title: NSLocalizedString("Share", comment: ""))
		/*let services = NSSharingService.sharingServices(forItems: [self.cachedAttributedText!])
		for service: NSSharingService in services {
		let item = shareMenu.addItem(withTitle: service.title, action: Selector(("share:")), keyEquivalent: "")
		item.target = self
		item.image = service.image
		item.representedObject = service
		}
		*/
		return shareMenu
	}
	
	func menuForEvent(theEvent: NSEvent) -> NSMenu {
		return self.validTextView(event: theEvent)!.menu(for: theEvent)!
		/*
		let menu = NSMenu(title: NSLocalizedString("Text Actions", comment: ""))
		let copy = menu.addItem(withTitle: NSLocalizedString("Copy", comment: ""), action: #selector(NSText.copy(_:)), keyEquivalent: "")
		copy.target = self
		menu.addItem(NSMenuItem.separator())
		let share = menu.addItem(withTitle: NSLocalizedString("Share", comment: ""), action: nil, keyEquivalent: "")
		share.submenu = self.buildSharingMenu()
		return menu
		*/
	}
	
	func share(item: NSMenuItem) {
		//let service = item.representedObject
		//service?.perform([self.cachedAttributedText])
	}
	
	
	
	
	
	
	
	
	
	
	
	
	func rehighlightSelectedRangesAsActive(active: Bool) {
		let ranges = self.currentSession?.selectionRanges.values
		for range in ranges! {
			let meta = self.textViews[range.textViewIdentifier]!
			meta.textView.stsm_highlightSelectedTextInRange(range: range.range, drawActive: active)
		}
	}
	
	override func resignFirstResponder() -> Bool {
		self.rehighlightSelectedRangesAsActive(active: false)
		self.firstResponder = false
		return true
	}
	
	override func becomeFirstResponder() -> Bool {
		self.rehighlightSelectedRangesAsActive(active: true)
		self.firstResponder = true
		return true
	}
	
	func setSelectionRangeForTextView(textView: NSTextView, withRange range: NSRange) {
		if range.location == NSNotFound || NSMaxRange(range) == 0 {
			textView.stsm_deselectHighlightedText()
			self.currentSession?.removeSelectionRangeForTextView(textView: textView)
		} else {
			let selRange = TextViewSelectionRange(textView: textView, selectedRange: range)
			self.currentSession?.addSelectionRange(range: selRange)
			textView.stsm_highlightSelectedTextInRange(range: range, drawActive: true)
		}
	}
	
	func processCompleteSelectionsForTargetTextView(textView: NSTextView, affinity: NSSelectionAffinity) {
		if self.currentSession == nil {
			return
		}
		let meta = self.textViews[(self.currentSession?.textViewIdentifier)!]
		let start = self.sortedTextViews.index(of: (meta?.textView)!)
		let end = self.sortedTextViews.index(of: textView)
		if start == NSNotFound || end == NSNotFound {
			return
		}
		var subrange = NSMakeRange(NSNotFound, 0)
		var select = false
		let count = self.sortedTextViews.count
		if end > start {
			if affinity == NSSelectionAffinity.downstream {
				subrange = NSMakeRange(start, end - start)
				select = true
			} else if count > end + 1 {
				subrange = NSMakeRange(end + 1, count - end - 1)
			}
		} else if end < start {
			if affinity == NSSelectionAffinity.upstream {
				subrange = NSMakeRange(end + 1, start - end)
				select = true
			} else {
				subrange = NSMakeRange(0, end)
			}
		}
		
		var subarray: [NSTextView]? = nil
		if subrange.location == NSNotFound {
			let views = self.sortedTextViews.mutableCopy()
			views.remove(textView)
			subarray = views.array as? [NSTextView]
		} else {
			subarray = (self.sortedTextViews.array as NSArray).subarray(with: subrange) as? [NSTextView]
		}
		for tv: NSTextView in subarray! {
			var range: NSRange
			if select {
				let currentRange = tv.stsm_highlightedRange
				if affinity == NSSelectionAffinity.downstream {
					range = NSMakeRange(currentRange!.location, (tv.string! as NSString).length - currentRange!.location)
				} else {
					range = NSMakeRange(0, NSMaxRange(currentRange!) ?? (tv.string! as NSString).length)
				}
			} else {
				range = NSMakeRange(0, 0)
			}
			self.setSelectionRangeForTextView(textView: tv, withRange: range)
		}
	}
	
	func endSession() {
		for meta in self.textViews.values {
			meta.textView.stsm_deselectHighlightedText()
		}
		self.currentSession = nil
		self.cachedAttributedText = nil
	}
	
	func buildAttributedStringForCurrentSession() -> AttributedString? {
		if self.currentSession == nil {
			return nil
		}
		var ranges = self.currentSession!.selectionRanges
		/*var textViewComparator = self.textViewComparator
		ranges.sort(comparator: { (obj1: String, obj2: String) -> ComparisonResult in
		var meta1 = self.textViews[obj1]
		var meta2 = self.textViews[obj2]
		return textViewComparator(meta1.textView, meta2.textView)
		})*/
		let string = NSMutableAttributedString()
		string.beginEditing()
		for (key, _) in ranges {
			let range = ranges[key]
			let meta = self.textViews[(range?.textViewIdentifier)!]
			var fragment = range?.attributedText
			if meta?.transformationBlock != nil {
				fragment = meta?.transformationBlock!(fragment!)
			}
			string.append(fragment!)
			if string.length > 0 /*&& idx != keys.count - 1*/ { // FIXME
				let attributes = string.attributes(at: string.length - 1, effectiveRange: nil)
				let newline = AttributedString(string: "\n", attributes: attributes)
				string.append(newline)
			}
		}
		string.endEditing()
		return string
	}
	
	func textViewComparator() -> Comparator {
		return { obj1, obj2 in //(obj1: NSTextView, obj2: NSTextView) -> ComparisonResult in
			let frame1 = (obj1 as! NSTextView).convert(obj1.bounds, to: nil)
			let frame2 = (obj2 as! NSTextView).convert(obj2.bounds, to: nil)
			let y1 = NSMinY(frame1)
			let y2 = NSMinY(frame2)
			
			if y1 > y2 {
				return .orderedAscending
			} else if y1 < y2 {
				return .orderedDescending
			} else {
				return .orderedSame
			}
		}
	}
	
	func sortTextViews() {
		self.sortedTextViews.sort(comparator: self.textViewComparator())
	}
}

class AttributeRange: NSObject {
	private(set) var attribute: String
	private(set) var value: AnyObject
	private(set) var range: NSRange
	
	init(attribute: String, value: AnyObject, range: NSRange) {
		self.attribute = attribute
		self.value = value
		self.range = range
	}
}

class TextViewSelectionRange: NSObject {
	private(set) var textViewIdentifier: String
	private(set) var range: NSRange
	private(set) var attributedText: AttributedString
	
	init(textView: NSTextView, selectedRange range: NSRange) {
		self.textViewIdentifier = textView.selectionIdentifier!
		self.range = range
		self.attributedText = textView.attributedString().attributedSubstring(from: range)
	}
}

class TextViewSelectionSession: NSObject {
	private(set) var textViewIdentifier: String
	private(set) var characterIndex: UInt
	private(set) var selectionRanges = [String: TextViewSelectionRange]()
	var windowPoint: NSPoint
	
	func addSelectionRange(range: TextViewSelectionRange) {
		selectionRanges[range.textViewIdentifier] = range
	}
	
	func removeSelectionRangeForTextView(textView: NSTextView) {
		selectionRanges.removeValue(forKey: textView.selectionIdentifier!)
	}
	
	init(textView: NSTextView, event: NSEvent) {
		self.textViewIdentifier = textView.selectionIdentifier!
		self.characterIndex = CharacterIndexForTextViewEvent(event, textView)!
		self.windowPoint = event.locationInWindow
	}
}

class TextViewMetadata: NSObject {
	private(set) var textView: NSTextView
	private(set) var transformationBlock: ((AttributedString) -> AttributedString)?
	
	init(textView: NSTextView, transformationBlock: ((AttributedString) -> AttributedString)?) {
		self.textView = textView
		self.transformationBlock = transformationBlock
	}
}

func CharacterIndexForTextViewEvent(_ event: NSEvent, _ textView: NSTextView) -> UInt? {
	let contentView = event.window?.contentView
	let pt = contentView?.convert(event.locationInWindow, from: nil)
	guard let point = pt else { return nil }
	let textPoint = textView.convert(point, from: contentView)
	return UInt(textView.characterIndexForInsertion(at: textPoint))
}

func ForwardRangeForIndices(idx1: UInt, _ idx2: UInt) -> NSRange {
	var range: NSRange
	if idx2 >= idx1 {
		range = NSMakeRange(Int(idx1), Int(idx2 - idx1))
	} else if idx2 < idx1 {
		range = NSMakeRange(Int(idx2), Int(idx1 - idx2))
	} else {
		range = NSMakeRange(NSNotFound, 0)
	}
	return range
}

var UniqueIdentifierKey = "UniqueIdentifierKey"
var BackgroundColorRangesKey = "BackgroundColorRangesKey"
var HighlightedRangeKey = "HighlightedRangeKey"
extension NSTextView {
	var selectionIdentifier: String? {
		get { return objc_getAssociatedObject(self, &UniqueIdentifierKey) as? String }
		set { objc_setAssociatedObject(self, &UniqueIdentifierKey, newValue,
		                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	var stsm_backgroundColorRanges: [AttributeRange]? {
		get { return objc_getAssociatedObject(self, &BackgroundColorRangesKey) as? [AttributeRange] }
		set { objc_setAssociatedObject(self, &BackgroundColorRangesKey, newValue,
		                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	var stsm_highlightedRange: NSRange? {
		get { return objc_getAssociatedObject(self, &HighlightedRangeKey) as? NSRange }
		set { objc_setAssociatedObject(self, &HighlightedRangeKey, newValue,
		                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
}

extension NSTextView {
	func stsm_highlightSelectedTextInRange(range: NSRange, drawActive active: Bool) {
		if self.stsm_backgroundColorRanges == nil {
			self.stsm_backupBackgroundColorState()
		}
		self.stsm_highlightedRange = range
		var selectedColor: NSColor? = nil
		if active {
			selectedColor = self.selectedTextAttributes[NSBackgroundColorAttributeName] as? NSColor ?? NSColor.selectedTextBackgroundColor()
		}
		else {
			selectedColor = NSColor(deviceRed:0.83, green:0.83, blue:0.83, alpha:1.0)
		}
		self.textStorage?.beginEditing()
		self.textStorage?.removeAttribute(NSBackgroundColorAttributeName, range: NSMakeRange(0, self.textStorage!.length))
		self.textStorage?.addAttribute(NSBackgroundColorAttributeName, value: selectedColor!, range: range)
		self.textStorage?.endEditing()
		self.needsDisplay = true
	}
	
	func stsm_backupBackgroundColorState() {
		var ranges = [AttributeRange]()
		let attribute: String = NSBackgroundColorAttributeName
		self.textStorage?.enumerateAttribute(attribute, in: NSMakeRange(0, self.textStorage!.length), options: .reverse, using: { value, range, stop in
			if value == nil {
				return
			}
			let attrRange: AttributeRange = AttributeRange(attribute: attribute, value: value!, range: range)
			ranges.append(attrRange)
		})
		self.stsm_backgroundColorRanges = ranges
	}
	
	func stsm_deselectHighlightedText() {
		self.textStorage?.beginEditing()
		self.textStorage?.removeAttribute(NSBackgroundColorAttributeName, range: NSMakeRange(0, (self.string! as NSString).length))
		let ranges = self.stsm_backgroundColorRanges
		for range in ranges ?? [] {
			self.textStorage?.addAttribute(range.attribute, value: range.value, range: range.range)
		}
		self.textStorage?.endEditing()
		self.needsDisplay = true
		self.stsm_backgroundColorRanges = nil
		self.stsm_highlightedRange = NSMakeRange(0, 0)
	}
}
