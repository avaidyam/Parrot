import Cocoa

class INDSequentialTextSelectionManager: NSResponder {
	
	private private(set) var textViews = [String: INDTextViewMetadata]()
	private private(set) var sortedTextViews = NSMutableOrderedSet()
	private var currentSession: INDTextViewSelectionSession?
	private lazy var cachedAttributedText: AttributedString? = {
		return self.buildAttributedStringForCurrentSession()
	}()
	private var eventMonitor: AnyObject?
	private var firstResponder: Bool = false
	
	func registerTextView(textView: NSTextView, withUniqueIdentifier identifier: String) {
		self.registerTextView(textView, withUniqueIdentifier: identifier, transformationBlock: nil)
	}
	
	func registerTextView(_ textView: NSTextView, withUniqueIdentifier identifier: String,
	                      transformationBlock block: ((AttributedString) -> AttributedString)?) {
		self.unregisterTextView(textView)
		textView.selectionIdentifier = identifier
		if (self.currentSession != nil) {
			let range = self.currentSession?.selectionRanges[identifier]
			if (range != nil) {
				textView.ind_highlightSelectedTextInRange(range: range!.range, drawActive: self.firstResponder)
			}
		}
		self.textViews[identifier] = INDTextViewMetadata(textView: textView, transformationBlock: block)
		self.sortedTextViews.add(textView)
		self.sortTextViews()
	}
	
	func unregisterTextView(_ textView: NSTextView) {
		if textView.selectionIdentifier == nil {
			return
		}
		self.textViews.removeValue(forKey: textView.selectionIdentifier!)
		self.sortedTextViews.remove(textView)
		self.sortTextViews()
		textView.selectionIdentifier = nil
	}
	
	func unregisterAllTextViews() {
		self.textViews.removeAll()
		self.sortedTextViews.removeAllObjects()
	}
	
	override init() {
		super.init()
		self.eventMonitor = self.addLocalEventMonitor()
	}
	
	required init?(coder: NSCoder) {
		super.init()
	}
	
	deinit {
		NSEvent.removeMonitor(self.eventMonitor!)
	}
	
	func handleLeftMouseDown(event: NSEvent) -> Bool {
		if event.clickCount == 1 {
			self.endSession()
			if let textView = self.validTextView(event: event) {
				if textView.window?.firstResponder != textView {
					self.currentSession = INDTextViewSelectionSession(textView: textView, event: event)
					return true
				}
			}
		}
		return false
	}
	
	func handleLeftMouseUp(event: NSEvent) -> Bool {
		if self.currentSession == nil {
			return false
		}
		event.window?.makeFirstResponder(self)
		let textView = self.validTextView(event: event)
		if textView != nil {
			let index = INDCharacterIndexForTextViewEvent(event, textView!)
			if Int(index) < (textView!.string! as NSString).length {
				var attributes = textView?.attributedString().attributes(at: Int(index), effectiveRange: nil)
				let link = attributes?[NSLinkAttributeName]
				if link != nil {
					textView?.clicked(onLink: link!, at: Int(index))
				}
			}
		}
		return true
	}
	
	func handleLeftMouseDragged(event: NSEvent) -> Bool {
		if self.currentSession == nil {
			return false
		}
		
		if let textView = self.validTextView(event: event) {
			textView.window!.makeFirstResponder(textView)
			let affinity = (event.locationInWindow.y < self.currentSession?.windowPoint.y) ? NSSelectionAffinity.downstream : NSSelectionAffinity.upstream
			self.currentSession?.windowPoint = event.locationInWindow
			var current: UInt
			let identifier = self.currentSession?.textViewIdentifier
			if textView.selectionIdentifier == identifier {
				current = (self.currentSession?.characterIndex)!
			} else {
				let meta = self.textViews[identifier!]
				let start = self.sortedTextViews.index(of: meta!.textView)
				let end = self.sortedTextViews.index(of: textView)
				current = UInt((end >= start) ? 0 : (textView.string! as NSString).length)
			}
			let index = INDCharacterIndexForTextViewEvent(event, textView)
			let range = INDForwardRangeForIndices(idx1: index, current)
			self.setSelectionRangeForTextView(textView: textView, withRange: range)
			self.processCompleteSelectionsForTargetTextView(textView: textView, affinity: affinity)
		}
		return true
	}
	
	func handleRightMouseDown(event: NSEvent) -> Bool {
		if self.currentSession == nil {
			return false
		}
		event.window?.makeFirstResponder(self)
		let textView = self.validTextView(event: event)
		if textView != nil {
			let menu = self.menuForEvent(theEvent: event)
			NSMenu.popUpContextMenu(menu, with: event, for: textView!)
		}
		return true
	}
	
	func addLocalEventMonitor() -> AnyObject {
		return NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .leftMouseDragged, .leftMouseUp, .rightMouseDown],
		                                                    handler: { (event: NSEvent) -> NSEvent? in
			switch event.type {
			case NSLeftMouseDown:
				return self.handleLeftMouseDown(event: event) ? nil : event
			case NSLeftMouseDragged:
				return self.handleLeftMouseDragged(event: event) ? nil : event
			case NSLeftMouseUp:
				return self.handleLeftMouseUp(event: event) ? nil : event
			case NSRightMouseDown:
				return self.handleRightMouseDown(event: event) ? nil : event
			default: return event
			}
		})!
	}
	
	func validTextView(event: NSEvent) -> NSTextView? {
		let contentView = event.window?.contentView
		let point = contentView?.convert(event.locationInWindow, from: nil)
		let view = contentView?.hitTest(point!)
		if view is NSTextView {
			if  let textView = view as? NSTextView,
				let identifier = textView.selectionIdentifier {
				if textView.isSelectable {
					return (self.textViews[identifier] != nil) ? textView : nil
				}
			}
		}
		return nil
	}
	
	func copy(sender: AnyObject) {
		NSPasteboard.general().clearContents()
		NSPasteboard.general().writeObjects([self.cachedAttributedText!])
	}
	
	func buildSharingMenu() -> NSMenu {
		let shareMenu = NSMenu(title: NSLocalizedString("Share", comment: ""))
		let services = NSSharingService.sharingServices(forItems: [self.cachedAttributedText!])
		for service: NSSharingService in services {
			let item = shareMenu.addItem(withTitle: service.title, action: Selector(("share:")), keyEquivalent: "")
			item.target = self
			item.image = service.image
			item.representedObject = service
		}
		return shareMenu
	}
	
	func menuForEvent(theEvent: NSEvent) -> NSMenu {
		let menu = NSMenu(title: NSLocalizedString("Text Actions", comment: ""))
		let copy = menu.addItem(withTitle: NSLocalizedString("Copy", comment: ""), action: #selector(NSText.copy(_:)), keyEquivalent: "")
		copy.target = self
		menu.addItem(NSMenuItem.separator())
		let share = menu.addItem(withTitle: NSLocalizedString("Share", comment: ""), action: nil, keyEquivalent: "")
		share.submenu = self.buildSharingMenu()
		return menu
	}
	
	func share(item: NSMenuItem) {
		//let service = item.representedObject
		//service?.perform([self.cachedAttributedText])
	}
	
	func rehighlightSelectedRangesAsActive(active: Bool) {
		let ranges = self.currentSession?.selectionRanges.values
		for range in ranges! {
			let meta = self.textViews[range.textViewIdentifier]!
			meta.textView.ind_highlightSelectedTextInRange(range: range.range, drawActive: active)
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
			textView.ind_deselectHighlightedText()
			self.currentSession?.removeSelectionRangeForTextView(textView: textView)
		} else {
			let selRange = INDTextViewSelectionRange(textView: textView, selectedRange: range)
			self.currentSession?.addSelectionRange(range: selRange)
			textView.ind_highlightSelectedTextInRange(range: range, drawActive: true)
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
				let currentRange = tv.ind_highlightedRange
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
			meta.textView.ind_deselectHighlightedText()
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

class INDAttributeRange: NSObject {
	private(set) var attribute: String
	private(set) var value: AnyObject
	private(set) var range: NSRange

	init(attribute: String, value: AnyObject, range: NSRange) {
		self.attribute = attribute
		self.value = value
		self.range = range
	}
}

class INDTextViewSelectionRange: NSObject {
	private(set) var textViewIdentifier: String
	private(set) var range: NSRange
	private(set) var attributedText: AttributedString
	
	init(textView: NSTextView, selectedRange range: NSRange) {
		self.textViewIdentifier = textView.selectionIdentifier!
		self.range = range
		self.attributedText = textView.attributedString().attributedSubstring(from: range)
	}
}

class INDTextViewSelectionSession: NSObject {
	private(set) var textViewIdentifier: String
	private(set) var characterIndex: UInt
	private(set) var selectionRanges = [String: INDTextViewSelectionRange]()
	var windowPoint: NSPoint
	
	func addSelectionRange(range: INDTextViewSelectionRange) {
		selectionRanges[range.textViewIdentifier] = range
	}
	
	func removeSelectionRangeForTextView(textView: NSTextView) {
		selectionRanges.removeValue(forKey: textView.selectionIdentifier!)
	}
	
	init(textView: NSTextView, event: NSEvent) {
		self.textViewIdentifier = textView.selectionIdentifier!
		self.characterIndex = INDCharacterIndexForTextViewEvent(event, textView)
		self.windowPoint = event.locationInWindow
	}
}

class INDTextViewMetadata: NSObject {
	private(set) var textView: NSTextView
	private(set) var transformationBlock: ((AttributedString) -> AttributedString)?

	init(textView: NSTextView, transformationBlock: ((AttributedString) -> AttributedString)?) {
		self.textView = textView
		self.transformationBlock = transformationBlock
	}
}

func INDCharacterIndexForTextViewEvent(_ event: NSEvent, _ textView: NSTextView) -> UInt {
	let contentView = event.window!.contentView!
	let point = contentView.convert(event.locationInWindow, from: nil)
	let textPoint = textView.convert(point, from: contentView)
	return UInt(textView.characterIndexForInsertion(at: textPoint))
}

func INDForwardRangeForIndices(idx1: UInt, _ idx2: UInt) -> NSRange {
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

let INDUniqueIdentifierKey = "INDUniqueIdentifierKey"
let INDBackgroundColorRangesKey = "INDBackgroundColorRangesKey"
let INDHighlightedRangeKey = "INDHighlightedRangeKey"
extension NSTextView {
	var selectionIdentifier: String? {
		get { return objc_getAssociatedObject(self, INDUniqueIdentifierKey) as? String }
		set { objc_setAssociatedObject(self, INDUniqueIdentifierKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	var ind_backgroundColorRanges: [INDAttributeRange]? {
		get { return objc_getAssociatedObject(self, INDBackgroundColorRangesKey) as? [INDAttributeRange] }
		set { objc_setAssociatedObject(self, INDBackgroundColorRangesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	var ind_highlightedRange: NSRange? {
		get { return objc_getAssociatedObject(self, INDHighlightedRangeKey) as? NSRange }
		set { objc_setAssociatedObject(self, INDHighlightedRangeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
}

extension NSTextView {
	func ind_highlightSelectedTextInRange(range: NSRange, drawActive active: Bool) {
		if self.ind_backgroundColorRanges == nil {
			self.ind_backupBackgroundColorState()
		}
		self.ind_highlightedRange = range
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
	
	func ind_backupBackgroundColorState() {
		var ranges = [INDAttributeRange]()
		let attribute: String = NSBackgroundColorAttributeName
		self.textStorage?.enumerateAttribute(attribute, in: NSMakeRange(0, self.textStorage!.length), options: .reverse, using: { value, range, stop in
			if value == nil {
				return
			}
			let attrRange: INDAttributeRange = INDAttributeRange(attribute: attribute, value: value!, range: range)
			ranges.append(attrRange)
		})
		self.ind_backgroundColorRanges = ranges
	}
	
	func ind_deselectHighlightedText() {
		self.textStorage?.beginEditing()
		self.textStorage?.removeAttribute(NSBackgroundColorAttributeName, range: NSMakeRange(0, (self.string! as NSString).length))
		let ranges: [INDAttributeRange] = self.ind_backgroundColorRanges!
		for range in ranges {
			self.textStorage?.addAttribute(range.attribute, value: range.value, range: range.range)
		}
		self.textStorage?.endEditing()
		self.needsDisplay = true
		self.ind_backgroundColorRanges = nil
		self.ind_highlightedRange = NSMakeRange(0, 0)
	}
}
