<<<<<<< Updated upstream
import MochaUI
import AVKit
import ParrotServiceExtension
=======
import AppKit
import Mocha
import ParrotServiceExtension
import MochaUI
>>>>>>> Stashed changes

public protocol TextInputHost {
    var image: NSImage? { get }
    func resized(to: Double)
    func typing()
    func send(message: String)
<<<<<<< Updated upstream
    func send(image: URL)
    func send(video: URL)
    func send(file: URL)
    func sendLocation()
    var settings: ConversationSettings? { get }
=======
>>>>>>> Stashed changes
}

public class MessageInputViewController: NSViewController, NSTextViewExtendedDelegate {
    
<<<<<<< Updated upstream
    internal static let regex = try! NSRegularExpression(pattern: "(\\*|\\_|\\~|\\`)(.+?)\\1",
                                                         options: [.caseInsensitive])
    
=======
>>>>>>> Stashed changes
    public var host: TextInputHost? = nil
    
    private var insertToken = false
    
<<<<<<< Updated upstream
    /// The background image and colors update Subscription.
    private var subscriptions: [String: Subscription] = [:]
    
    private lazy var photoMenu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(withTitle: "Send...", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(title: " Image") {
            runSelectionPanel(for: self.view.window!, fileTypes: [kUTTypeImage as String], multiple: true) { urls in
                for url in urls {
                    self.host?.send(image: url)
                }
            }
        }
        menu.addItem(title: " Screenshot") {
            let v = self.view.superview!
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let img = try screenshot(interactive: true)
                    let marked = try markup(for: img, in: v)
                    guard let dat = marked.data(for: .png) else { throw CocoaError(.userCancelled) }
                    
                    let url = URL(temporaryFileWithExtension: "png")
                    try dat.write(to: url, options: .atomic)
                    self.host?.send(image: url)
                } catch(let error) {
                    log.debug("Something happened while taking a screenshot or marking it up!")
                    log.debug("\(error)")
                }
            }
        }
        menu.addItem(title: " Drawing") {
            let v = self.view.superview!
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let img = NSImage(size: NSSize(width: 1024, height: 1024), flipped: false) { rect in
                        NSColor.white.set()
                        rect.fill()
                        return true
                    }
                    
                    let marked = try markup(for: img, in: v)
                    guard let dat = marked.data(for: .png) else { throw CocoaError(.userCancelled) }
                    
                    let url = URL(temporaryFileWithExtension: "png")
                    try dat.write(to: url, options: .atomic)
                    self.host?.send(image: url)
                } catch(let error) {
                    log.debug("Something happened while taking a screenshot or marking it up!")
                    log.debug("\(error)")
                }
            }
        }
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: " Photo", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: " Audio", action: nil, keyEquivalent: "")
        menu.addItem(title: " Video") {
            let width = self.view.bounds.width, height = (width * 9.0 / 16.0)
            let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Movie Recording \(Date().fullString(true)).mp4")
            
            let popover = NSPopover()
            let av = AVCaptureView(frame: NSRect(x: 0, y: 0, width: width, height: height))
            av.prepare(recordingURL: tmp) { [weak self, popover] in
                if let error = $0 {
                    log.debug("Something happened while saving your video.")
                } else {
                    self?.host?.send(video: tmp)
                }
                popover.contentView = nil
                popover.close()
                popover.contentViewController = nil
            }
            
            /* TODO: There's a retain cycle somewhere here; when the convo window closes, the iSight LED still glows. */
            
            popover.contentView = av
            popover.behavior = .applicationDefined
            popover.appearance = .dark
            popover.show(relativeTo: self.view.bounds, of: self.view, preferredEdge: .maxY)
        }
        menu.addItem(title: " File") {
            runSelectionPanel(for: self.view.window!, fileTypes: nil, multiple: false) { urls in
                self.host?.send(file: urls[0])
            }
        }
        menu.addItem(title: " Location") {
            self.host?.sendLocation()
        }
        return menu
    }()
    
    private lazy var photoView: NSButton = {
        let b = LayerButton(title: "", image: NSImage(named: .addTemplate)!,
                         target: nil, action: nil).modernize(wantsLayer: true)
        b.isBordered = false
        b.wantsLayer = true
        b.font = NSFont.from(name: .compactRoundedMedium, size: 13.0)
        b.performedAction = {
            self.photoMenu.popUp(positioning: self.photoMenu.item(at: 0),
                                 at: self.photoView.bounds.origin,
                                 in: self.photoView)
        }
        return b
=======
    private lazy var photoView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
>>>>>>> Stashed changes
    }()
    
    private lazy var textView: ExtendedTextView = {
        let v = ExtendedTextView().modernize(wantsLayer: true)
        v.isEditable = true
        v.isSelectable = true
        v.drawsBackground = false
        v.backgroundColor = NSColor.clear
        v.textColor = NSColor.labelColor
        v.textContainerInset = NSSize(width: 4, height: 4)
        
<<<<<<< Updated upstream
        v.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .vertical)
        v.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
=======
        v.setContentHuggingPriority(1, for: .vertical)
        v.setContentCompressionResistancePriority(1, for: .horizontal)
>>>>>>> Stashed changes
        
        v.placeholderString = "Send message..."
        v.shouldAlwaysPasteAsPlainText = true
        
        v.isAutomaticDataDetectionEnabled = true
        v.isAutomaticLinkDetectionEnabled = true
        v.isAutomaticTextReplacementEnabled = true
        
        v.delegate = self
        return v
    }()
    
    // Constraint setup here.
    public override func loadView() {
        self.view = NSView().modernize(wantsLayer: true)
<<<<<<< Updated upstream
        self.view.add(subviews: self.photoView, self.textView) {
            self.photoView.leftAnchor == self.view.leftAnchor + 8.0
            self.photoView.bottomAnchor == self.view.bottomAnchor - 4.0
            self.photoView.heightAnchor == 24.0
            self.photoView.widthAnchor == 24.0
            self.photoView.bottomAnchor == self.textView.bottomAnchor
            
            self.textView.leftAnchor == self.photoView.rightAnchor + 8.0
            self.textView.bottomAnchor == self.view.bottomAnchor - 4.0
            self.textView.rightAnchor == self.view.rightAnchor - 8.0
            self.textView.topAnchor == self.view.topAnchor + 4.0
            self.textView.heightAnchor >= self.photoView.heightAnchor
        }
=======
        self.view.add(subviews: [self.photoView, self.textView])
        
        // Install constraints.
        self.photoView.left == self.view.left + 8.0
        self.photoView.bottom == self.view.bottom - 4.0
        self.photoView.height == 24.0
        self.photoView.width == 24.0
        self.photoView.bottom == self.textView.bottom
        
        self.textView.left == self.photoView.right + 8.0
        self.textView.bottom == self.view.bottom - 4.0
        self.textView.right == self.view.right - 8.0
        self.textView.top == self.view.top + 4.0
        self.textView.height >= self.photoView.height
    }
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        
        // Mask the image into a circle and grab it.
        if let layer = self.photoView.layer {
            layer.masksToBounds = true
            layer.cornerRadius = 24.0 / 2.0 // FIXME: dynamic mask
        }
        self.photoView.image = self.host?.image
        
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.enclosingScrollView?.replaceInSuperview(with: self.textView)
>>>>>>> Stashed changes
    }
    
    // Set up dark/light notifications.
    public override func viewDidAppear() {
        super.viewDidAppear()
        self.resizeModule()
        self.view.window?.makeFirstResponder(self.textView)
<<<<<<< Updated upstream
        
        self.visualSubscriptions = [
            Settings.observe(\.interfaceStyle, options: [.initial, .new]) { _, change in
                
                // NSTextView doesn't automatically change its text color when the
                // backing view's appearance changes, so we need to set it each time.
                // In addition, make sure links aren't blue as usual.
                let text = self.textView
                text.appearance = NSAppearance.current == .dark ? .light : .dark
                text.layer?.masksToBounds = true
                text.layer?.cornerRadius = 10.0
                text.layer?.backgroundColor = .ns(.secondaryLabelColor)//NSColor.darkOverlay(forAppearance: self.view.window!.effectiveAppearance).cgColor
                
                text.textColor = NSColor.labelColor
                text.font = NSFont.systemFont(ofSize: 12.0)
                text.typingAttributes = [
                    NSAttributedStringKey.foregroundColor: text.textColor!,
                    NSAttributedStringKey.font: text.font!
                ]
                text.linkTextAttributes = [
                    NSAttributedStringKey.foregroundColor: NSColor.labelColor,
                    NSAttributedStringKey.cursor: NSCursor.pointingHand,
                    NSAttributedStringKey.underlineStyle: 1,
                ]
                text.selectedTextAttributes = [
                    NSAttributedStringKey.backgroundColor: NSColor.lightOverlay(forAppearance: self.view.window!.effectiveAppearance),
                    NSAttributedStringKey.foregroundColor: NSColor.labelColor,
                    NSAttributedStringKey.underlineStyle: 0,
                ]
                text.markedTextAttributes = [
                    NSAttributedStringKey.backgroundColor: NSColor.lightOverlay(forAppearance: self.view.window!.effectiveAppearance),
                    NSAttributedStringKey.foregroundColor: NSColor.labelColor,
                    NSAttributedStringKey.underlineStyle: 0,
                ]
                /*text.placeholderTextAttributes = [
                 NSForegroundColorAttributeName: NSColor.tertiaryLabelColor(),
                 NSFontAttributeName: text.font!
                 ]*/
                
                self.setColors()
            }
        ]
        
        self.subscriptions["sub"] = AutoSubscription(kind: .conversationAppearanceUpdated) { _ in
            self.setColors()
        }
    }
    private var visualSubscriptions: [NSKeyValueObservation] = []
    
    private func setColors() {
        let text = self.textView
        
        var color = NSColor.darkOverlay(forAppearance: self.view.effectiveAppearance)//NSColor.secondaryLabelColor
        if let c = self.host?.settings?.outgoingColor, c.alphaComponent > 0.0 {
            color = c
            
            // This automatically adjusts labelColor to the right XOR mask.
            text.appearance = color.isLight() ? .light : .dark
        } else {
            text.appearance = self.view.effectiveAppearance//self.appearance
        }
        text.layer?.backgroundColor = color.cgColor
    }
    
    public override func viewWillDisappear() {
        self.visualSubscriptions = []
    }
    
    //
    //
    //
    
    private func resizeModule() {
        NSAnimationContext.animate(duration: 200.milliseconds) { // TODO: FIX THIS
            NSAnimationContext.current.allowsImplicitAnimation = true
            NSAnimationContext.current.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
=======
        ParrotAppearance.registerInterfaceStyleListener(observer: self, invokeImmediately: true) { interface in
            
            // NSTextView doesn't automatically change its text color when the
            // backing view's appearance changes, so we need to set it each time.
            // In addition, make sure links aren't blue as usual.
            let text = self.textView
            text.appearance = NSAppearance.current() == .dark ? .light : .dark
            text.layer?.masksToBounds = true
            text.layer?.cornerRadius = 10.0
            text.layer?.backgroundColor = NSColor.secondaryLabelColor.cgColor//NSColor.darkOverlay(forAppearance: self.view.window!.effectiveAppearance).cgColor
            
            text.textColor = NSColor.labelColor
            text.font = NSFont.systemFont(ofSize: 12.0)
            text.typingAttributes = [
                NSForegroundColorAttributeName: text.textColor!,
                NSFontAttributeName: text.font!
            ]
            text.linkTextAttributes = [
                NSForegroundColorAttributeName: NSColor.labelColor,
                NSCursorAttributeName: NSCursor.pointingHand(),
                NSUnderlineStyleAttributeName: 1,
            ]
            text.selectedTextAttributes = [
                NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.view.window!.effectiveAppearance),
                NSForegroundColorAttributeName: NSColor.labelColor,
                NSUnderlineStyleAttributeName: 0,
            ]
            text.markedTextAttributes = [
                NSBackgroundColorAttributeName: NSColor.lightOverlay(forAppearance: self.view.window!.effectiveAppearance),
                NSForegroundColorAttributeName: NSColor.labelColor,
                NSUnderlineStyleAttributeName: 0,
            ]
            /*text.placeholderTextAttributes = [
             NSForegroundColorAttributeName: NSColor.tertiaryLabelColor(),
             NSFontAttributeName: text.font!
            ]*/
        }
    }
    
    public override func viewWillDisappear() {
        ParrotAppearance.unregisterInterfaceStyleListener(observer: self)
    }
    
    private func resizeModule() {
        NSAnimationContext.animate(duration: 0.6) { // TODO: FIX THIS
>>>>>>> Stashed changes
            self.textView.invalidateIntrinsicContentSize()
            self.textView.superview?.needsLayout = true
            self.textView.superview?.layoutSubtreeIfNeeded()
            self.host?.resized(to: Double(self.view.frame.height))
        }
    }
    
<<<<<<< Updated upstream
    // Clear any text styles and re-compute them.
    private func updateTextStyles() {
        guard let storage = self.textView.textStorage else { return }
        
        let base = NSRange(location: 0, length: storage.length)
        let matches = MessageInputViewController.regex.matches(in: storage.string, options: [], range: base)
        storage.setAttributes(self.textView.typingAttributes, range: base)
        storage.applyFontTraits([.unboldFontMask, .unitalicFontMask], range: base)
        
        for res in matches {
            let range = res.range(at: 2)
            switch storage.attributedSubstring(from: res.range(at: 1)).string {
            case "*": // bold
                storage.applyFontTraits(.boldFontMask, range: range)
            case "_": // italics
                storage.applyFontTraits(.italicFontMask, range: range)
            case "~": // strikethrough
                storage.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            case "`": // underline
                storage.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            default: break
            }
        }
    }
    
=======
>>>>>>> Stashed changes
    public func textDidChange(_ obj: Notification) {
        self.resizeModule()
        if self.textView.string == "" {
            self.textView.font = NSFont.systemFont(ofSize: 12.0)
            return
        }
        self.host?.typing()
<<<<<<< Updated upstream
        self.updateTextStyles()
=======
>>>>>>> Stashed changes
    }
    
    // If the user presses ENTER and doesn't hold SHIFT, send the message.
    // If the user presses TAB, insert four spaces instead. // TODO: configurable later
    public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
            
<<<<<<< Updated upstream
        case #selector(NSResponder.insertNewline(_:)) where !NSEvent.modifierFlags.contains(.shift):
            let text = self.textView.string
            guard text.count > 0 else { return true }
            NSSpellChecker.shared.dismissCorrectionIndicator(for: textView)
=======
        case #selector(NSResponder.insertNewline(_:)) where !NSEvent.modifierFlags().contains(.shift):
            guard let text = self.textView.string, text.characters.count > 0 else { return true }
            NSSpellChecker.shared().dismissCorrectionIndicator(for: textView)
>>>>>>> Stashed changes
            self.textView.string = ""
            self.resizeModule()
            self.host?.send(message: text)
            
        case #selector(NSResponder.insertTab(_:)):
            textView.textStorage?.append(NSAttributedString(string: "    ", attributes: textView.typingAttributes))
            
        default: return false
        }; return true
    }
    
    public func textView(_ textView: NSTextView, didInsertText string: Any, replacementRange: NSRange) {
        guard !insertToken else { insertToken = false; return }
        
        /* 
         // Only deal with actual Strings, not AttributedStrings.
         var inserted = string as? String
         if let str = string as? AttributedString {
             inserted = str.string
         }
         guard let insertedStr = inserted else { return }
        */
        
        // Use the user's last entered word as the entry.
        let tString = textView.attributedString().string as NSString
        var _r = tString.range(of: " ", options: .backwards)
        if _r.location == NSNotFound { _r.location = 0 } else { _r.location += 1 }
        let userRange = NSMakeRange(_r.location, tString.length - _r.location)
        let userStr = tString.substring(from: _r.location)
        
<<<<<<< Updated upstream
        NSSpellChecker.shared.dismissCorrectionIndicator(for: textView)
        if let r = Settings.emoticons[userStr] {
=======
        NSSpellChecker.shared().dismissCorrectionIndicator(for: textView)
        if let s = Settings[Preferences.Key.Completions] as? [String: Any], let r = s[userStr] as? String {
>>>>>>> Stashed changes
            insertToken = true // prevent re-entrance
            
            // If the entered text was a completion character, place the matching
            // one after the insertion point and move the cursor back.
            textView.insertText(r, replacementRange: self.textView.selectedRange())
            textView.moveBackward(nil)
            
            // Display a text bubble showing visual replacement to the user.
<<<<<<< Updated upstream
            let range = NSMakeRange(textView.attributedString().length - r.count, r.count)
=======
            let range = NSMakeRange(textView.attributedString().length - r.characters.count, r.characters.count)
>>>>>>> Stashed changes
            textView.showFindIndicator(for: range)
        } else if let found = emoticonDescriptors[userStr] {
            insertToken = true // prevent re-entrance
            
            // Handle emoticon replacement.
            let attr = NSAttributedString(string: found, attributes: textView.typingAttributes)
            textView.insertText(attr, replacementRange: userRange)
            let range = NSMakeRange(_r.location, 1)
<<<<<<< Updated upstream
            NSSpellChecker.shared.showCorrectionIndicator(
=======
            NSSpellChecker.shared().showCorrectionIndicator(
>>>>>>> Stashed changes
                of: .reversion,
                primaryString: userStr,
                alternativeStrings: [found],
                forStringIn: textView.characterRect(forRange: range),
                view: textView) { [weak textView] in
                    guard $0 != nil else { return }
<<<<<<< Updated upstream
                    log.debug("user selected \(String(describing: $0))")
=======
                    log.debug("user selected \($0)")
>>>>>>> Stashed changes
                    //textView?.insertText($0, replacementRange: range)
                    textView?.showFindIndicator(for: userRange)
            }
            textView.showFindIndicator(for: range)
        }
    }
}
