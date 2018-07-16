import Cocoa


//
// MARK: - Control Delegate
//


/// The protocol that `delegate`s of a `KeyboardShortcutView` must conform to.
/// If the `KeyboardShortcutView` lacks a delegate, but has a `target`, that conforms
/// to this protocol, it will be consulted instead.
public protocol KeyboardShortcutViewDelegate: class {
    
    /// Return `true` to allow beginning the recording of user input for a shortcut.
    func keyboardShortcutViewShouldBeginRecording(_ keyboardShortcutView: KeyboardShortcutView) -> Bool
    
    /// Return `true` to accept the shortcut as valid and set it.
    func keyboardShortcutView(_ keyboardShortcutView: KeyboardShortcutView,
                              canRecordShortcut shortcut: KeyboardShortcutView.Pair) -> Bool
    
    /// The control has ended a recording session, possibly with a new shortcut.
    func keyboardShortcutViewDidEndRecording(_ keyboardShortcutView: KeyboardShortcutView)
}


//
// MARK: - Control View
//


/// The `KeyboardShortcutView` presents an effective way to record and display
/// user-facing keyboard shortcuts (or "hot keys"). No configuration is required,
/// and if `isEnabled` is set to `false`, it can be used to just display a
/// shortcut without allowing user recording. The control is undo-capable, and
/// if not the first responder, supports undo and redo to rollback a recorded or
/// set shortcut.
///
/// Note: `NSControl`'s `*Value` properties and `take*ValueFrom(_:)` are no-ops.
/// As such, Cocoa Bindings are not supported.
open class KeyboardShortcutView: NSControl, NSSecureCoding, NSAccessibilityButton, NSAccessibilityGroup {
    
    /// A `Pair` refers to a paired virtual key code and its modifier flags, if any.
    public typealias Pair = (keyCode: CGKeyCode, modifierFlags: CGEventFlags)
    
    
    //
    // MARK: - Localized Strings
    //
    
    
    /// Private utility container to get a localized string or fail with fallback.
    private enum Localized {
        private static func value(_ key: String, `default`: String, comment: String) -> String {
            return NSLocalizedString(key, tableName: nil, bundle: Bundle(for: KeyboardShortcutView.self),
                                     value: `default`, comment: comment) // helper!
        }
        
        fileprivate static var actionName: String {
            return value("action_name", default: "Record Shortcut",
                         comment: "The action name for undo and redo")
        }
        
        fileprivate static var voiceOverBegin: String {
            return value("voiceover_begin", default: "Now recording a shortcut",
                         comment: "The notification name for VoiceOver if the control began recording")
        }
        
        fileprivate static var voiceOverRecorded: String {
            return value("voiceover_recorded", default: "Shortcut recorded",
                         comment: "The notification name for VoiceOver if the control set a shortcut")
        }
        
        fileprivate static var voiceOverCleared: String {
            return value("voiceover_cleared", default: "Shortcut cleared",
                         comment: "The notification name for VoiceOver if the control cleared a shortcut")
        }
        
        fileprivate static var tooltipPrefix: String {
            return value("tooltip_prefix", default: "Keyboard Shortcut",
                         comment: "The prefix for the control's tooltip")
        }
        
        fileprivate static var buttonTooltip: String {
            return value("button_tooltip", default: "Clear or Record Shortcut",
                         comment: "The tooltip for the control's button")
        }
        
        fileprivate static var buttonRecordLabel: String {
            return value("button_record_label", default: "Record Shortcut",
                         comment: "The label for the control's button if recording")
        }
        
        fileprivate static var buttonClearLabel: String {
            return value("button_clear_label", default: "Clear Shortcut",
                         comment: "The label for the control's button if recorded")
        }
        
        fileprivate static var menuPrefix: String {
            return value("menu_prefix", default: "Use shortcut",
                         comment: "The prefix for the control's menu suggestions")
        }
        
        fileprivate static var noShortcut: String {
            return value("no_shortcut", default: "none",
                         comment: "The text to use when there is no shortcut set")
        }
        
        fileprivate static var help: String {
            return value("help_string", default: "Tap to record a new shortcut or delete an existing shortcut.",
                         comment: "The VoiceOver help suggestion for the control")
        }
    }
    
    
    //
    // MARK: - Static Members
    //
    
    
    /// Eh, why not. It's good practice.
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    /// We use constraint-based layout to manage our subviews.
    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    /// Using an `NSButtonCell` "stamp", we can mimic what the `NSSearchField`
    /// looks like when placed in a window titlebar semantic context.
    /// Relying on platform graphics may require a revisit upon macOS++.
    private static var stampCell: NSButtonCell = {
        let c = NSButtonCell()
        c.bezelStyle = .texturedRounded
        return c
    }()
    
    
    //
    // MARK: - Public Control Properties
    //
    
    
    /// The color of user-interactive elements within the control, such as the
    /// text color of the currently-recording shortcut.
    ///
    /// Note: by using a dynamic color, it will always match the current NSAppearance.
    @objc dynamic open var tintColor: NSColor = .keyboardFocusIndicatorColor {
        didSet { self.needsDisplay = true }
    }
    
    /// The string to display to the user when no shortcut is displayed by, or
    /// being recorded by the control.
    @objc dynamic open var placeholderString: String? {
        get { return self.textLabel.placeholderAttributedString?.string }
        set {
            let style = NSMutableParagraphStyle()
            style.alignment = self.alignment
            let attr = NSAttributedString(string: newValue ?? "", attributes: [
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: style
            ])
            
            // We have to wrap the string in an NSAttrStr... because the default
            // label color is way too dim/translucent and therefore hard to read.
            self.textLabel.placeholderAttributedString = attr
            self.invalidateIntrinsicContentSize()
        }
    }
    
    /// The `suggestions` are presented to the user upon right-clicking the control,
    /// and when selected, immediately replaces the shortcut without recording.
    /// The delegate(s) is/are not consulted about the validity of these shortcuts.
    ///
    /// Note: do not modify this value while the view's menu is displayed. It can
    /// lead to unexpected results.
    ///
    /// Note: This property is KVO-capable even though it is not marked `@objc`.
    /// The received observation info will be set to `nil`, however.
    /*@objc*/ open var suggestions: [KeyboardShortcutView.Pair] = [] {
        willSet { self.willChangeValue(forKey: #function) }
        didSet {
            self.didChangeValue(forKey: #function)
            self.invalidateRestorableState()
        }
    }
    
    /// The delegate governs the actions the control takes when it is presented
    /// with opportunities to begin to, or record a new shortcut from user input.
    ///
    /// If a `delegate` is not set, the `target` is consulted, if it conforms.
    ///
    /// Note: if no `delegate` is set, and the `target` is not a `KeyboardShortcutViewDelegate`,
    /// the default behavior of the control is to always allow recoding and to
    /// only allow shortcuts with at least one modifier flag attached. That is,
    /// the key `D` with no modifiers is not valid (except for Fn keys).
    ///
    /// Note: This property is KVO-capable even though it is not marked `@objc`.
    /// The received observation info will be set to `nil`, however.
    /*@objc*/ open weak var delegate: KeyboardShortcutViewDelegate? {
        willSet { self.willChangeValue(forKey: #function) }
        didSet { self.didChangeValue(forKey: #function) }
    }
    
    /// Returns `true` if the control is currently recording a new shortcut.
    @objc dynamic open private(set) var isRecording = false {
        willSet { self.willChangeValue(forKey: #function) }
        didSet { self.didChangeValue(forKey: #function) }
    }
    
    /// The shortcut recorded and/or shown by the control. If `nil`, the control
    /// may record a new shortcut and will display the `placeholderString`.
    ///
    /// Note: This property is KVO-capable even though it is not marked `@objc`.
    /// The received observation info will be set to `nil`, however.
    /*@objc*/ open var shortcut: KeyboardShortcutView.Pair? {
        willSet {
            guard self.shortcut?.keyCode != newValue?.keyCode &&
                self.shortcut?.modifierFlags != newValue?.modifierFlags else { return }
            self.willChangeValue(forKey: #function)
        }
        didSet {
            guard self.shortcut?.keyCode != oldValue?.keyCode &&
                self.shortcut?.modifierFlags != oldValue?.modifierFlags else { return }
            
            // Mark an undo target (using the responder chain's undo manager).
            if !self.isRestoringState {
                self.undoManager?.registerUndo(withTarget: self, name: Localized.actionName) { [oldValue] _ in
                    self.shortcut = oldValue
                }
            }
            
            // Send the control's action to its target or the first responder.
            _ = self.sendAction(self.action, to: self.target)
            NSAccessibilityPostNotification(self, .valueChanged)
            
            // Re-evaluate visual properties.
            self.needsDisplay = true
            self.invalidateIntrinsicContentSize()
            self.didChangeValue(forKey: #function)
            self.invalidateRestorableState()
        }
    }
    
    /// Determines whether the control is capable of modifying its shortcut or
    /// recording a new shortcut.
    @objc dynamic open override var isEnabled: Bool {
        didSet {
            if !self.isEnabled { self.endRecording() }
            self.needsDisplay = true
            self.noteFocusRingMaskChanged()
            self.invalidateRestorableState()
        }
    }
    
    /// Determines whether there is active user input; cannot be set.
    open override var isHighlighted: Bool {
        get { return self.isRecording }
        set { }
    }
    
    /// Determines the alignment of the human-formatted shortcut text in the control.
    /// See `NSTextField` for further details.
    @objc open override var alignment: NSTextAlignment {
        get { return self.textLabel.alignment }
        set { self.textLabel.alignment = newValue }
    }
    
    
    //
    // MARK: - Private Child Views & Layers
    //
    
    
    /// The record and clear button visible at the trailing edge of the control.
    private lazy var clearButton: NSButton = {
        let button = NSButton()
        button.wantsLayer = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.image = NSImage(named: .stopProgressTemplate)
        button.bezelStyle = .texturedRounded // for template image rendering
        button.setButtonType(.momentaryChange)
        button.isBordered = false
        button.title = ""
        button.target = self
        button.action = #selector(self.buttonAction(_:))
        button.toolTip = Localized.buttonTooltip
        button.setAccessibilityHelp(Localized.buttonTooltip)
        return button
    }()
    
    /// The shortcut or placeholder human-readable text visible within the control.
    private lazy var textLabel: NSTextField = {
        let label = NSTextField()
        label.wantsLayer = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isEditable = false
        label.isSelectable = false
        label.isContinuous = false
        label.isEnabled = true
        label.textColor = self.tintColor
        label.backgroundColor = .clear
        label.refusesFirstResponder = true
        label.drawsBackground = false
        label.isBezeled = false
        label.lineBreakMode = .byClipping
        
        // MARK: [Private SPI]
        // Without this flag, the label steals our firstMouse/responder status.
        label.setValue(true, forKey: "ignoreHitTest")
        return label
    }()
    
    /// The `underlayer` draws the bezel of the control.
    private lazy var underlayer = CALayer()
    
    
    //
    // MARK: - Private Members
    //
    
    
    /// All the constraints this control has set governing its subviews and layers.
    private var childConstraints: [NSLayoutConstraint] = []
    
    /// Keeps track of the global mode, to receive ALL key events when recording.
    private var savedOperatingMode: CGSGlobalHotKeyOperatingMode? = nil
    
    /// Allows us to prevent undo manager changes when restoring state.
    private var isRestoringState: Bool = false
    
    /// The currently tracked flags for the shortcut being recorded. It can be
    /// assumed that if equal to `[]`, there is no active user input.
    private var inputModifiers: NSEvent.ModifierFlags = [] {
        didSet {
            self.needsDisplay = true
            self.invalidateIntrinsicContentSize()
        }
    }
    
    /// The string representation of the currently recording shortcut.
    private var stringRepresentation: String {
        var modifiers: NSEvent.ModifierFlags = self.inputModifiers
        if self.isRecording {
            return modifiers.characters
        } else {
            if let shortcut = self.shortcut {
                modifiers.formUnion(NSEvent.ModifierFlags(shortcut.modifierFlags))
            }
            return modifiers.characters + (self.shortcut?.keyCode.characters ?? "")
        }
    }
    
    
    //
    // MARK: - Initialization & Deinitialization
    //
    
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.restoreState(with: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        // Set up our layer and layout properties:
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer?.addSublayer(self.underlayer)
        self.addSubview(self.clearButton)
        self.addSubview(self.textLabel)
        self.isEnabled = true // NSControl.isEnabled is false by default.
        self.alignment = .center
        
        // Add a cursor update tracking area. By setting `.inVisibleRect`,
        // we don't need to use `updateTrackingAreas()` to recreate it.
        self.addTrackingArea(NSTrackingArea(rect: .zero,
                                            options: [.activeInKeyWindow, .inVisibleRect, .cursorUpdate],
                                            owner: self, userInfo: nil))
    }
    
    /// Any residual hotkey or window key entities are reset.
    deinit {
        if self.savedOperatingMode != nil {
            _ = CGSSetGlobalHotKeyOperatingMode(CGSMainConnectionID(), self.savedOperatingMode!)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //
    // MARK: - NSCoding & State Restoration
    //
    
    
    open override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        self.encodeRestorableState(with: coder)
    }
    
    /// Encode the suggestions, shortcut, and current enabled state.
    open override func encodeRestorableState(with coder: NSCoder) {
        // While documentation says to call super, we actually don't have to.
        //super.encodeRestorableState(with: coder)
        
        coder.encode(self.suggestions.map { representation(of: $0) }, forKey: "suggestions")
        coder.encode(representation(of:self.shortcut), forKey: "shortcut")
        coder.encode(self.isEnabled as NSNumber, forKey: "isEnabled")
    }
    
    /// Decode the suggestions, shortcut, and current enabled state.
    open override func restoreState(with coder: NSCoder) {
        // While documentation says to call super, we actually don't have to.
        //super.restoreState(with: coder)
        
        // State restoration guard for undo management:
        self.isRestoringState = true
        defer {self.isRestoringState = false }
        
        let s = coder.decodeObject(of: NSArray.self, forKey: "suggestions") as? [NSDictionary]
        self.suggestions = (s ?? []).compactMap { representation(of: $0) }
        self.shortcut = representation(of: coder.decodeObject(of: NSDictionary.self, forKey: "shortcut"))
        self.isEnabled = coder.decodeObject(of: NSNumber.self, forKey: "isEnabled") as? Bool ?? false
    }
    
    
    //
    // MARK: - Layout & Display
    //
    
    
    /// Install any constraints we require for our label and button.
    /// It's not necessary to call setNeedsUpdateConstraints because it'll be done
    /// for us on the first pass of ordering the parent window onto the screen.
    ///
    /// Note: use `leading`/`trailingAnchor` instead of `left`/`rightAnchor` to
    /// automatically take `userInterfaceLayoutDirection` into account.
    open override func updateConstraints() {
        if self.childConstraints.count == 0 {
            self.childConstraints = [
                self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4.0),
                self.textLabel.trailingAnchor.constraint(equalTo: self.clearButton.leadingAnchor, constant: 0.0),
                self.clearButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
                self.clearButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0),
                self.clearButton.widthAnchor.constraint(equalTo: self.clearButton.heightAnchor, multiplier: 1.0),
                self.textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -1.0),
                self.clearButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ]
            NSLayoutConstraint.activate(self.childConstraints)
        }
        super.updateConstraints()
    }
    
    /// Scale the text font and synchronize the `underlayer` to our frame.
    open override func layout() {
        super.layout()
        
        // Disable actions when setting the frame to prevent jumpy animations.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.underlayer.frame = self.layer!.bounds
        CATransaction.commit()
        
        // Make sure to resize our font (or the system font) to match our height.
        if let font = self.font {
            self.textLabel.font = NSFontManager.shared.convert(font, toSize: self.bounds.height / 1.7)
        } else {
            self.textLabel.font = NSFont.systemFont(ofSize: self.bounds.height / 1.7)
        }
    }
    
    /// Update our layer properties and redraw anything we must.
    open override func updateLayer() {
        
        // Use an `NSButtonCell` stamp to draw the control's bezel, and do so
        // while setting the current `NSAppearance`. This allows us to draw exactly
        // what an AppKit button looks like on any appearance and any version,
        // as well as be compatible with any custom/future `NSAppearance`s.
        //
        // `-[NSButtonCell updateLayerWithFrame:inView:]` actually uses a private
        // NSLayerContentsFacet and CoreUI to optimize this, but it's a non-issue.
        var b = self.bounds.size; b.height = 22
        let img = NSImage(size: b, flipped: false) { r in
            self.effectiveAppearance.using {
                KeyboardShortcutView.stampCell.drawBezel(withFrame: r, in: self)
            }
            return true
        }
        
        // Disable actions when setting the contents to prevent unwanted fades.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.underlayer.contents = img
        self.underlayer.contentsScale = self.layer!.contentsScale // inherit
        self.underlayer.contentsCenter = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
        CATransaction.commit()
        
        self.textLabel.textColor = self.isEnabled ? self.tintColor : .disabledControlTextColor
        
        // Update textual properties.
        let str = self.stringRepresentation
        self.textLabel.stringValue = str
        self.toolTip = Localized.tooltipPrefix + ": " + (str.isEmpty ? Localized.noShortcut : str)
                        + "\n\n" + Localized.help
        
        // Update button visual state (and VoiceOver state).
        self.clearButton.isEnabled = self.isEnabled
        let canStop = self.isRecording || self.shortcut != nil
        self.clearButton.image = NSImage(named: canStop ? .stopProgressFreestandingTemplate
                                                        : .statusUnavailable)
        self.clearButton.setAccessibilityLabel(canStop ? Localized.buttonRecordLabel
                                                       : Localized.buttonClearLabel)
    }
    
    /// The `intrinsicContentSize` of the control is determined by the length
    /// of the human-readable shortcut string, the scaled size of the record
    /// button, and any padding between these elements.
    open override var intrinsicContentSize: NSSize {
        var _t = self.textLabel.intrinsicContentSize
        var _b = self.clearButton.intrinsicContentSize
        if _t.width == NSView.noIntrinsicMetric { _t.width = 0.0 }
        if _b.width == NSView.noIntrinsicMetric { _b.width = 0.0 }
        
        // Compute the sum/max of the intrinsicContentSizes of our subviews.
        return NSSize(width: _t.width + _b.width + 12.0 /* padding */,
                      height: max(_t.height, _b.height) /* 22.0? */)
    }
    
    
    //
    // MARK: - Focus Ring & Menu
    //
    
    
    /// Our exact bounds will be used to draw the focus ring.
    open override var focusRingMaskBounds: NSRect {
        return (self.isEnabled && self.window?.firstResponder == self) ? self.bounds : .zero
    }
    
    /// Just draw our `underlayer` with the bezel content as the mask.
    open override func drawFocusRingMask() {
        guard self.isEnabled && window?.firstResponder == self else { return }
        self.underlayer.render(in: NSGraphicsContext.current!.cgContext)
    }
    
    /// Dynamically constructs a suggestions menu; this property cannot be set
    /// to anything else. Instead, see `KeyboardShortcutView.suggestions`.
    open override var menu: NSMenu? {
        get {
            let menu = NSMenu()
            menu.autoenablesItems = false
            for (i, x) in self.suggestions.enumerated() {
                let str = Localized.menuPrefix + " " + x.modifierFlags.characters + x.keyCode.characters
                let item = NSMenuItem(title: str, action: #selector(self.selectAction(_:)),
                                      keyEquivalent: "")
                item.tag = i
                item.target = self
                item.isEnabled = self.isEnabled
                menu.addItem(item)
            }
            return menu
        }
        set { }
    }
    
    
    //
    // MARK: - View & Control Properties
    //
    
    
    open override var allowsVibrancy: Bool {
        return false
    }
    
    open override var wantsUpdateLayer: Bool {
        return true
    }
    
    open override func cursorUpdate(with event: NSEvent) {
        NSCursor.pointingHand.set()
    }
    
    open override var acceptsFirstResponder: Bool {
        return self.isEnabled
    }

    open override var canBecomeKeyView: Bool {
        return super.canBecomeKeyView && NSApp.isFullKeyboardAccessEnabled
    }

    open override var needsPanelToBecomeKey: Bool {
        return true
    }
    
    open override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    
    //
    // MARK: - Mouse & KeyEquivalent Tracking
    //
    
    
    /// Begin recording a new shortcut by becoming the first responder.
    open override func performClick(_ sender: Any?) {
        self.window?.makeFirstResponder(self)
    }

    open override func mouseDown(with event: NSEvent) {
        guard self.isEnabled else {
            super.mouseDown(with: event); return
        }

        // Clear the old shortcut and begin recording if the click was within us.
        let locationInView = self.convert(event.locationInWindow, from: nil)
        if self.mouse(locationInView, in: self.bounds) && !self.isRecording {
            self.inputModifiers = []
            _ = self.beginRecording()
        } else {
            super.mouseDown(with: event)
        }
    }

    /// Trampoline required for single-key "shortcut" handling.
    open override func keyDown(with event: NSEvent) {
        guard !self.performKeyEquivalent(with: event) else { return }
        super.keyDown(with: event)
    }

    /// When the control is told to perform a key equivalent, it actually first
    /// validates the shortcut (either with the `delegate`, `target`, or itself),
    /// and then ends recording to capture the shortcut.
    open override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if !self.isEnabled || !self.isRecording { return false }
        if self.window?.firstResponder != self { return false }
        let shortcut = (keyCode: CGKeyCode(event.keyCode),
                        modifierFlags: CGEventFlags(event.modifierFlags))
        
        // inline validation func if we have no delegate response:
        func validate() -> Bool {
            guard !shortcut.keyCode.isFunctionKey else { return true }
            return !shortcut.modifierFlags.intersection(.maskUserFlags).isEmpty
        }
        
        let del = (self.delegate ?? self.target as? KeyboardShortcutViewDelegate)
        if del?.keyboardShortcutView(self, canRecordShortcut: shortcut) ?? validate() {
            self.shortcut = shortcut
            self.endRecording()
            
            // Handle VoiceOver:
            NSAccessibilityPostNotificationWithUserInfo(self, .announcementRequested, [
                .announcement: Localized.voiceOverRecorded,
                .priority: NSAccessibilityPriorityLevel.high
            ])
            return true
        }
        return false
    }

    /// Track any modifier flag changes.
    open override func flagsChanged(with event: NSEvent) {
        self.inputModifiers = self.isRecording ? event.modifierFlags : []
        super.flagsChanged(with: event)
    }

    
    //
    // MARK: - Recording Management
    //
    
    
    /// Begin recording if the `delegate` or `target` allows it.
    public func beginRecording() -> Bool {
        if !self.isEnabled { return false }
        if self.isRecording { return true }
        
        let del = (self.delegate ?? self.target as? KeyboardShortcutViewDelegate)
        guard del?.keyboardShortcutViewShouldBeginRecording(self) ?? true else {
            NSSound.beep(); return false
        }
        self.isRecording = true
        
        // Present VoiceOver feedback.
        NSAccessibilityPostNotificationWithUserInfo(self, .announcementRequested, [
            .announcement: Localized.voiceOverBegin,
            .priority: NSAccessibilityPriorityLevel.high
        ])
        return true
    }

    /// End recording, resign first responder, and notify the `delegate`/`target`.
    public func endRecording() {
        if !self.isRecording { return }
        self.inputModifiers = []
        self.isRecording = false
        
        if self.window?.firstResponder == self && !self.canBecomeKeyView {
            self.window?.makeFirstResponder(nil)
        }
        let del = (self.delegate ?? self.target as? KeyboardShortcutViewDelegate)
        del?.keyboardShortcutViewDidEndRecording(self)
    }

    
    //
    // MARK: - Button Actions
    //
    
    
    /// The trailing record/stop button was pressed: start recording if we're
    /// not already doing so, and if we are, clear the shortcut and end recording.
    @objc dynamic private func buttonAction(_ button: NSButton) {
        if !self.isRecording && self.shortcut == nil { // cleared state
            self.window?.makeFirstResponder(self)
            _ = self.beginRecording()
        } else if self.isRecording && self.shortcut != nil { // cleared state
            self.endRecording()
        } else {
            if self.shortcut != nil { self.shortcut = nil }
            self.endRecording()
            
            // Handle VoiceOver:
            NSAccessibilityPostNotificationWithUserInfo(self, .announcementRequested, [
                .announcement: Localized.voiceOverCleared,
                .priority: NSAccessibilityPriorityLevel.high
            ])
        }
    }
    
    /// A `suggestions` shortcut was selected: circumvent recording and directly set.
    /// Note that a suggestion may be selected without the control being recording.
    @objc dynamic private func selectAction(_ item: NSMenuItem) {
        guard self.isEnabled else { return }
        self.endRecording()
        self.shortcut = self.suggestions[item.tag]
    }
    
    
    //
    // MARK: - Key Window & First Responder Tracking
    //
    
    
    open override func becomeFirstResponder() -> Bool {
        // We need to enqueue this block to the main queue because we haven't
        // yet become the first responder until this method returns!
        DispatchQueue.main.async {
            self.windowKeyednessChanged(Notification(name: NSWindow.didBecomeKeyNotification,
                                                     object: self.window, userInfo: nil))
        }
        return true
    }
    
    open override func resignFirstResponder() -> Bool {
        // We need to enqueue this block to the main queue because we haven't
        // yet resigned the first responder until this method returns!
        DispatchQueue.main.async {
            self.windowKeyednessChanged(Notification(name: NSWindow.didResignKeyNotification,
                                                     object: self.window, userInfo: nil))
        }
        self.endRecording()
        return true
    }
    
    /// Our window's keyed-ness changed: update UI and hotkey support.
    ///
    /// If the control is first responder in its key window, set the global CGS
    /// hot key operation mode to `.disable` - this way, we'll receive events that
    /// other applications have already claimed as hot keys. We need to do this
    /// temporarily so we may also register that hot key if we need to.
    ///
    /// If the window loses keyedness, the control will automaticall resign first
    /// responder and discard any recording shortcut.
    ///
    /// Note: Unbalanced global mode changes can dramatically impact system usability!
    @objc dynamic private func windowKeyednessChanged(_ note: Notification) {
        guard let window = self.window, (note.object as? NSWindow) == window else { return }
        if window.isKeyWindow && window.firstResponder == self { // becomeKey
            guard self.savedOperatingMode == nil else { return }
            
            // MARK: [Private SPI]
            _ = CGSGetGlobalHotKeyOperatingMode(CGSMainConnectionID(), &self.savedOperatingMode)
            _ = CGSSetGlobalHotKeyOperatingMode(CGSMainConnectionID(), .disable)
        } else { // resignKey
            guard self.savedOperatingMode != nil else { return }

            // MARK: [Private SPI]
            _ = CGSSetGlobalHotKeyOperatingMode(CGSMainConnectionID(), self.savedOperatingMode!)
            self.savedOperatingMode = nil
            window.makeFirstResponder(nil) // resign ourselves if window resigned
        }
    }
    
    /// Adjust the keyedness observer to watch our new parent window.
    open override func viewWillMove(toWindow newWindow: NSWindow?) {
        let n = NotificationCenter.default // shorthand
        if let oldWindow = self.window {
            n.removeObserver(self, name: NSWindow.didBecomeKeyNotification,
                             object: oldWindow)
            n.removeObserver(self, name: NSWindow.didResignKeyNotification,
                             object: oldWindow)
        }
        if let newWindow = newWindow {
            n.addObserver(self, selector: #selector(self.windowKeyednessChanged(_:)),
                          name: NSWindow.didBecomeKeyNotification, object: newWindow)
            n.addObserver(self, selector: #selector(self.windowKeyednessChanged(_:)),
                          name: NSWindow.didResignKeyNotification, object: newWindow)
        }

    }
    
    
    //
    // MARK: - Accessibility Element
    //
    
    
    open override func isAccessibilityElement() -> Bool {
        return true
    }
    open override func accessibilityHelp() -> String? {
        return Localized.help
    }
    open override func accessibilityRole() -> NSAccessibilityRole? {
        return .button
    }
    open override func accessibilityLabel() -> String? {
        let str = self.stringRepresentation
        return str.isEmpty ? Localized.noShortcut : str
    }
    open override func accessibilityValue() -> Any? {
        return self.accessibilityLabel()
    }
    open override func accessibilityRoleDescription() -> String? {
        return Localized.tooltipPrefix
    }
    open override var accessibilityFocusedUIElement: Any? {
        return self.window?.firstResponder == self
    }
    open override func accessibilityChildren() -> [Any]? {
        return [self.clearButton]
    }
    open override func accessibilityPerformPress() -> Bool {
        guard self.isEnabled else { return false }
        self.performClick(nil)
        return true
    }
}


//
// MARK: - KeyboardShortcutView.Pair Extensions
//


/// Transforms a `KeyboardShortcutView.Pair` into an `NSDictionary` for `NSCoding`.
/// This is compatible with `MASShortcut` and `ShortcutRecorder`.
public func representation(of pair: KeyboardShortcutView.Pair?) -> NSDictionary? {
    guard let pair = pair else { return nil }
    return [
        "keyCode": pair.keyCode,
        "modifierFlags": pair.modifierFlags.rawValue
        ] as NSDictionary
}

/// Transforms an `NSDictionary` into a `KeyboardShortcutView.Pair` for `NSCoding`.
/// This is compatible with `MASShortcut` and `ShortcutRecorder`.
public func representation(of dict: NSDictionary?) -> KeyboardShortcutView.Pair? {
    guard let dict = dict as? [String: Any],
        let kc = dict["keyCode"] as? CGKeyCode,
        let mf = dict["modifierFlags"] as? CGEventFlags.RawValue
        else { return nil }
    return (kc, CGEventFlags(rawValue: mf))
}


//
// MARK: - Cocoa Extensions
//


public extension NSAppearance {
    
    /// Convenience method to execute a block with a provided current appearance.
    /// Identical to private `+[NSAppearance _performWithCurrentAppearance:usingBlock:]`
    public func using(_ handler: () -> ()) {
        let x = NSAppearance.current
        NSAppearance.current = self
        handler()
        NSAppearance.current = x
    }
}

public extension UndoManager {
    
    /// Convenience method to register a target and set its action name simultaneously.
    @available(OSX 10.11, iOS 9.0, *)
    public func registerUndo<TargetType: AnyObject>(withTarget target: TargetType, name: String, handler: @escaping (TargetType) -> Void) {
        self.registerUndo(withTarget: target, handler: handler)
        self.setActionName(name)
    }
}


//
// MARK: - [Private SPI] CGSGlobalHotKeyOperatingMode
//


// Here lie dragons!
fileprivate typealias CGSConnectionID = UInt
fileprivate enum CGSGlobalHotKeyOperatingMode: UInt {
    case enable = 0, disable = 1, universalAccessOnly = 2
}
@_silgen_name("CGSMainConnectionID")
fileprivate func CGSMainConnectionID() -> CGSConnectionID
@_silgen_name("CGSGetGlobalHotKeyOperatingMode")
fileprivate func CGSGetGlobalHotKeyOperatingMode(_ connection: CGSConnectionID,
                                                 _ mode: UnsafeMutablePointer<CGSGlobalHotKeyOperatingMode?>) -> CGError
@_silgen_name("CGSSetGlobalHotKeyOperatingMode")
fileprivate func CGSSetGlobalHotKeyOperatingMode(_ connection: CGSConnectionID,
                                                 _ mode: CGSGlobalHotKeyOperatingMode) -> CGError

// MARK: -

