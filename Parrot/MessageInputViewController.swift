import AppKit
import Mocha
import ParrotServiceExtension
import MochaUI

public protocol TextInputHost {
    var image: NSImage? { get }
    func resized(to: Double)
    func typing()
    func send(message: String)
    func send(images: [URL])
}

public class MessageInputViewController: NSViewController, NSTextViewExtendedDelegate {
    
    public var host: TextInputHost? = nil
    
    private var insertToken = false
    
    private lazy var photoView: NSButton = {
        let img = NSImage(named: NSImage.Name(rawValue: "NSMediaBrowserMediaTypePhotosTemplate32"))!
        let b = NSButton(title: "", image: img, target: self,
                         action: #selector(self.loadImage(_:)))
            .modernize(wantsLayer: true)
        b.isBordered = false
        b.wantsLayer = true
        return b
    }()
    
    private lazy var textView: ExtendedTextView = {
        let v = ExtendedTextView().modernize(wantsLayer: true)
        v.isEditable = true
        v.isSelectable = true
        v.drawsBackground = false
        v.backgroundColor = NSColor.clear
        v.textColor = NSColor.labelColor
        v.textContainerInset = NSSize(width: 4, height: 4)
        
        v.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1), for: .vertical)
        v.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1), for: .horizontal)
        
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
    
    // Set up dark/light notifications.
    public override func viewDidAppear() {
        super.viewDidAppear()
        self.resizeModule()
        self.view.window?.makeFirstResponder(self.textView)
        ParrotAppearance.registerListener(observer: self, invokeImmediately: true) { interface, style in
            
            // NSTextView doesn't automatically change its text color when the
            // backing view's appearance changes, so we need to set it each time.
            // In addition, make sure links aren't blue as usual.
            let text = self.textView
            text.appearance = NSAppearance.current == .dark ? .light : .dark
            text.layer?.masksToBounds = true
            text.layer?.cornerRadius = 10.0
            text.layer?.backgroundColor = NSColor.secondaryLabelColor.cgColor//NSColor.darkOverlay(forAppearance: self.view.window!.effectiveAppearance).cgColor
            
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
    }
    
    private func setColors() {
        let text = self.textView
        
        var color = NSColor.darkOverlay(forAppearance: self.view.effectiveAppearance)//NSColor.secondaryLabelColor
        if let c = Settings.conversationOutgoingColor, c.alphaComponent > 0.0 {
            color = c
            
            // This automatically adjusts labelColor to the right XOR mask.
            text.appearance = color.isLight() ? .light : .dark
        } else {
            text.appearance = self.view.effectiveAppearance//self.appearance
        }
        text.layer?.backgroundColor = color.cgColor
    }
    
    public override func viewWillDisappear() {
        ParrotAppearance.unregisterListener(observer: self)
    }
    
    //
    //
    //
    
    @objc private func loadImage(_ sender: NSButton!) {
        runSelectionPanel(for: self.view.window!, fileTypes: [kUTTypeImage as String], multiple: true) { urls in
            self.host?.send(images: urls)
        }
    }
    
    //
    //
    //
    
    private func resizeModule() {
        NSAnimationContext.animate(duration: 0.6) { // TODO: FIX THIS
            self.textView.invalidateIntrinsicContentSize()
            self.textView.superview?.needsLayout = true
            self.textView.superview?.layoutSubtreeIfNeeded()
            self.host?.resized(to: Double(self.view.frame.height))
        }
    }
    
    public func textDidChange(_ obj: Notification) {
        self.resizeModule()
        if self.textView.string == "" {
            self.textView.font = NSFont.systemFont(ofSize: 12.0)
            return
        }
        self.host?.typing()
    }
    
    // If the user presses ENTER and doesn't hold SHIFT, send the message.
    // If the user presses TAB, insert four spaces instead. // TODO: configurable later
    public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
            
        case #selector(NSResponder.insertNewline(_:)) where !NSEvent.modifierFlags.contains(.shift):
            let text = self.textView.string
            guard text.characters.count > 0 else { return true }
            NSSpellChecker.shared.dismissCorrectionIndicator(for: textView)
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
        
        NSSpellChecker.shared.dismissCorrectionIndicator(for: textView)
        if let r = Settings.emoticons[userStr] {
            insertToken = true // prevent re-entrance
            
            // If the entered text was a completion character, place the matching
            // one after the insertion point and move the cursor back.
            textView.insertText(r, replacementRange: self.textView.selectedRange())
            textView.moveBackward(nil)
            
            // Display a text bubble showing visual replacement to the user.
            let range = NSMakeRange(textView.attributedString().length - r.characters.count, r.characters.count)
            textView.showFindIndicator(for: range)
        } else if let found = emoticonDescriptors[userStr] {
            insertToken = true // prevent re-entrance
            
            // Handle emoticon replacement.
            let attr = NSAttributedString(string: found, attributes: textView.typingAttributes)
            textView.insertText(attr, replacementRange: userRange)
            let range = NSMakeRange(_r.location, 1)
            NSSpellChecker.shared.showCorrectionIndicator(
                of: .reversion,
                primaryString: userStr,
                alternativeStrings: [found],
                forStringIn: textView.characterRect(forRange: range),
                view: textView) { [weak textView] in
                    guard $0 != nil else { return }
                    log.debug("user selected \($0)")
                    //textView?.insertText($0, replacementRange: range)
                    textView?.showFindIndicator(for: userRange)
            }
            textView.showFindIndicator(for: range)
        }
    }
}
