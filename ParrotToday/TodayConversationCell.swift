import Foundation
import AppKit
import Mocha
import MochaUI
import protocol ParrotServiceExtension.Person
import protocol ParrotServiceExtension.Message
import protocol ParrotServiceExtension.Conversation

private let log = Logger(subsystem: "Parrot.Today.Cell")

// A visual representation of a Conversation in a ListView.
public class TodayConversationCell: NSTableCellView {
    
    public override var allowsVibrancy: Bool { return true }
    
    private static var wallclock = Wallclock()
    private var id = UUID() // for wallclock
    public var isSelected: Bool = false
    
    private lazy var photoView: NSImageView = {
        let v = NSImageView()
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var nameLabel: NSTextField = {
        let v = NSTextField(labelWithString: "")
        v.textColor = NSColor.labelColor
        v.font = NSFont.systemFont(ofSize: 13.0)
        return v
    }()
    
    private lazy var textLabel: NSTextField = {
        let v = NSTextField(labelWithString: "")
        v.textColor = NSColor.secondaryLabelColor
        v.font = NSFont.systemFont(ofSize: 11.0)
        v.usesSingleLineMode = false
        v.lineBreakMode = .byWordWrapping
        return v
    }()
    
    private lazy var timeLabel: NSTextField = {
        let v = NSTextField(labelWithString: "")
        v.textColor = NSColor.tertiaryLabelColor
        v.font = NSFont.systemFont(ofSize: 11.0)
        v.alignment = .right
        return v
    }()
    
    // Set up constraints after init.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareLayout()
    }
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        prepareLayout()
    }
    
    // Constraint setup here.
    private func prepareLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.canDrawSubviewsIntoLayer = true
        self.wantsLayer = true
        self.add(subviews: self.photoView, self.nameLabel, self.timeLabel, self.textLabel)
        
        self.photoView.left == self.left + 8
        self.photoView.centerY == self.centerY
        self.photoView.width == 48
        self.photoView.height == 48
        self.photoView.right == self.nameLabel.left - 8
        self.photoView.right == self.textLabel.left - 8
        self.nameLabel.top == self.top + 8
        self.nameLabel.right == self.timeLabel.left - 4
        self.nameLabel.bottom == self.textLabel.top - 4
        self.nameLabel.centerY == self.timeLabel.centerY
        self.timeLabel.top == self.top + 8
        self.timeLabel.right == self.right - 8
        self.timeLabel.bottom == self.textLabel.top - 4
        self.textLabel.right == self.right - 8
        self.textLabel.bottom == self.bottom - 8
    }
    
    // Upon assignment of the represented object, configure the subview contents.
    public override var objectValue: Any? {
        didSet {
            log.debug("OBJECTVALUE \(String(describing: self.objectValue))")
            guard let conversation = self.objectValue as? Conversation else { return }
            
            let messageSender = conversation.messages.last?.sender?.identifier ?? ""
            let selfSender = conversation.participants.filter { $0.me }.first?.identifier
            if let firstParticipant = (conversation.participants.filter { !$0.me }.first) {
                let photo = fetchImage(user: firstParticipant, monogram: true)
                self.photoView.image = photo
            }
            // FIXME: Group conversation prefixing doesn't work yet.
            self.prefix = messageSender != selfSender ? "↙ " : "↗ "
            //let prefix = conversation.users.count > 2 ? "Person: " : (messageSender != selfSender ? "" : "You: ")
            let _m = conversation.messages.last
            let subtitle = (_m?.text ?? "")
            let time = conversation.messages.last?.timestamp ?? .origin
            
            self.time = time
            self.nameLabel.stringValue = conversation.name
            self.nameLabel.toolTip = conversation.name
            self.textLabel.stringValue = subtitle
            self.textLabel.toolTip = subtitle
            self.timeLabel.stringValue = self.prefix + time.relativeString()
            self.timeLabel.toolTip = "\(time.fullString())"
            
            if conversation.unreadCount > 0 && (messageSender != selfSender) {
                self.timeLabel.textColor = #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1)
            } else {
                self.timeLabel.textColor = .tertiaryLabelColor
            }
        }
    }
    
    // Dynamically update the visible timestamp for the Conversation.
    private var time: Date = .origin
    private var prefix = " "
    public func updateTimestamp() {
        self.timeLabel.stringValue = self.prefix + self.time.relativeString()
    }
    
    // Allows the photo view's circle crop to dynamically match size.
    public override func layout() {
        super.layout()
        if let layer = self.photoView.layer {
            layer.masksToBounds = true
            layer.cornerRadius = self.photoView.bounds.width / 2.0
        }
    }
    
    public override func viewDidMoveToSuperview() {
        if let _ = self.superview { // onscreen
            TodayConversationCell.wallclock.add(target: (self, self.id, self.updateTimestamp))
        } else { // offscreen
            TodayConversationCell.wallclock.remove(target: (self, self.id, self.updateTimestamp))
        }
    }
}

private var _cache = Dictionary<String, Data>()

// Note that this is general purpose! It needs a unique ID and a resource URL string.
public func fetchData(_ id: String?, _ resource: String?, handler: ((Data?) -> Void)? = nil) -> Data? {
    
    // Case 1: No unique ID -> bail.
    guard let id = id else {
        handler?(nil)
        return nil
    }
    
    // Case 2: We've already fetched it -> return image.
    if let img = _cache[id] {
        handler?(img)
        return img
    }
    
    // Case 3: No resource URL -> bail.
    guard let photo_url = resource, let url = URL(string: photo_url) else {
        handler?(nil)
        return nil
    }
    
    // Case 4: We can request the resource -> return image.
    let semaphore = DispatchSemaphore(value: 0)
    URLSession.shared.request(request: URLRequest(url: url)) {
        if let data = $0.data {
            _cache[id] = data
            handler?(data)
        }
        semaphore.signal()
    }
    
    // Onlt wait on the semaphore if we don't have a handler.
    if handler == nil {
        _ = semaphore.wait(timeout: 3.seconds.later)
        return _cache[id]
    } else {
        return nil
    }
}

private var _imgCache = [String: NSImage]()
public func fetchImage(user: Person, monogram: Bool = false) -> NSImage {
    
    let output = _imgCache[user.identifier]
    guard output == nil else { return output! }
    
    // 1. If we can find or cache the photo URL, return that.
    // 2. If no photo URL can be used, and the name exists, create a monogram image.
    // 3. If a monogram is not possible, use the default image mask.
    
    var img: NSImage! = nil
    if let d = fetchData(user.identifier, user.photoURL) {
        img = NSImage(data: d)!
    } else {
        img = defaultImageForString(forString: user.fullName)
    }
    
    _imgCache[user.identifier] = img
    return img
}

public let materialIndex = [
    "Red": #colorLiteral(red: 0.9450980425, green: 0.1568627506, blue: 0.1294117719, alpha: 1), "Pink": #colorLiteral(red: 0.8941176534, green: 0, blue: 0.3098039329, alpha: 1), "Purple": #colorLiteral(red: 0.5411764979, green: 0, blue: 0.6392157078, alpha: 1), "Deep Purple": #colorLiteral(red: 0.3254902065, green: 0.1019607857, blue: 0.6705882549, alpha: 1), "Indigo": #colorLiteral(red: 0.1843137294, green: 0.2117647082, blue: 0.6627451181, alpha: 1), "Blue": #colorLiteral(red: 0.08235294372, green: 0.4941176474, blue: 0.9568627477, alpha: 1), "Light Blue": #colorLiteral(red: 0, green: 0.5843137503, blue: 0.9607843161, alpha: 1), "Cyan": #colorLiteral(red: 0, green: 0.6862745285, blue: 0.8000000119, alpha: 1), "Teal": #colorLiteral(red: 0.003921568859, green: 0.5254902244, blue: 0.4588235319, alpha: 1),
    "Green": #colorLiteral(red: 0.2352941185, green: 0.6470588446, blue: 0.2274509817, alpha: 1), "Light Green": #colorLiteral(red: 0.4745098054, green: 0.7372549176, blue: 0.1960784346, alpha: 1), "Lime": #colorLiteral(red: 0.7647058964, green: 0.8549019694, blue: 0.1019607857, alpha: 1), "Yellow": #colorLiteral(red: 1, green: 0.9254902005, blue: 0.08627451211, alpha: 1), "Amber": #colorLiteral(red: 1, green: 0.7176470757, blue: 0, alpha: 1), "Orange": #colorLiteral(red: 1, green: 0.5254902244, blue: 0, alpha: 1), "Deep Orange": #colorLiteral(red: 1, green: 0.2431372553, blue: 0.04705882445, alpha: 1), "Brown": #colorLiteral(red: 0.400000006, green: 0.2627451122, blue: 0.2156862766, alpha: 1), "Blue Gray": #colorLiteral(red: 0.3019607961, green: 0.4156862795, blue: 0.4745098054, alpha: 1), "Gray": #colorLiteral(red: 0.4599502683, green: 0.4599616528, blue: 0.4599555135, alpha: 1),
]
public let materialColors = Array(materialIndex.values)
public func defaultImageForString(forString source: String, size: NSSize = NSSize(width: 512.0, height: 512.0), colors: [NSColor] = materialColors) -> NSImage {
    return NSImage(size: size, flipped: false) { rect in
        colors[abs(source.hashValue) % colors.count].set()
        rect.fill()
        var r = rect.insetBy(dx: -size.width * 0.05, dy: -size.height * 0.05)
        r.origin.y -= size.height * 0.1
        NSImage(named: .userGuest)!.draw(in: r) // composite this somehow.
        return true
    }
}
