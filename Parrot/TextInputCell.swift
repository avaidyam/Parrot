import AppKit
import Mocha
import Hangouts
import ParrotServiceExtension
import MochaUI

public protocol TextInputHost {
    var image: NSImage? { get }
    func resized(to: Double)
    func typing()
    func send(message: String)
}

public class TextInputCell: NSViewController, NSTextViewExtendedDelegate {
    
    public var host: TextInputHost? = nil
    
    private var insertToken = false
    
    private lazy var photoView: NSImageView = {
        let v = NSImageView().modernize()
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var textView: NSExtendedTextView = {
        let v = NSExtendedTextView().modernize()
        v.isEditable = true
        v.isSelectable = true
        v.drawsBackground = false
        v.backgroundColor = NSColor.clear
        v.textColor = NSColor.labelColor
        
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
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.add(subviews: [self.photoView, self.textView])
        
        // Install constraints.
        self.photoView.left == self.view.left + 8.0
        self.photoView.bottom == self.view.bottom - 8.0
        self.photoView.height == 24.0
        self.photoView.width == 24.0
        self.photoView.bottom == self.textView.bottom
        
        self.textView.left == self.photoView.right + 8.0
        self.textView.bottom == self.view.bottom - 8.0
        self.textView.right == self.view.right - 8.0
        self.textView.top == self.view.top + 8.0
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
    }
    
    // Set up dark/light notifications.
    public override func viewDidAppear() {
        super.viewDidAppear()
        self.resizeModule()
        self.view.window?.makeFirstResponder(self.textView)
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
            
        case #selector(NSResponder.insertNewline(_:)) where !NSEvent.modifierFlags().contains(.shift):
            guard let text = self.textView.string, text.characters.count > 0 else { return true }
            NSSpellChecker.shared().dismissCorrectionIndicator(for: textView)
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
        
        NSSpellChecker.shared().dismissCorrectionIndicator(for: textView)
        if let s = Settings[Parrot.Completions] as? [String: Any], let r = s[userStr] as? String {
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
            NSSpellChecker.shared().showCorrectionIndicator(
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
