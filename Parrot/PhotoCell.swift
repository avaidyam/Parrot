import MochaUI
import ParrotServiceExtension

public class PhotoCell: NSCollectionViewItem {
    
    private lazy var personView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = false
        v.isEditable = false
        v.animates = true
        return v
    }()
    
    private lazy var photoView: NSImageView = {
        let v = NSImageView().modernize(wantsLayer: true)
        v.allowsCutCopyPaste = true
        v.isEditable = false
        v.animates = true
        v.imageAlignment = .alignCenter
        v.imageScaling = .scaleProportionallyUpOrDown
        return v
    }()
    
    private var incrementalImage: CGIncrementalImage? = nil
    
    public override func loadView() {
        self.view = NSView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.wantsLayer = true
        self.view.set(allowsVibrancy: true)
        self.view.add(subviews: self.personView, self.photoView) {
            self.personView.leftAnchor == self.view.leftAnchor + 8.0
            self.personView.bottomAnchor == self.view.bottomAnchor - 4.0
            self.personView.heightAnchor == 24.0
            self.personView.widthAnchor == 24.0
            
            self.photoView.leftAnchor == self.personView.rightAnchor + 8.0
            self.photoView.rightAnchor == self.view.rightAnchor - 8.0
            self.photoView.topAnchor == self.view.topAnchor + 4.0
            self.photoView.bottomAnchor == self.view.bottomAnchor - 4.0
            
            // So, since the photoView can be hidden (height = 0), we should manually
            // declare the height minimum constraint here.
            self.photoView.heightAnchor >= 24.0 /* personView.height */
        }
    }
    
    public override var representedObject: Any? {
        didSet {
            guard let b = self.representedObject as? EventBundle else { return }
            guard let o = b.current as? Message else { return }
            guard case .image(let url) = o.content else { return }
            let prev = b.previous as? Message
            
            //self.orientation = b.current.sender!.me ? .rightToLeft : .leftToRight // FIXME
            self.personView.image = o.sender.image
            self.personView.isHidden = /*(o.sender.me ?? false) || */(prev?.sender.identifier == o.sender.identifier)
            
            // Set up incremental loading of the image from the url.
            self.incrementalImage = CGIncrementalImage(url: url) { image, _, _ in
                self.photoView.image = image
            }
        }
    }
    
    /// Allows the circle crop and masking to dynamically change.
    public override func viewDidLayout() {
        if let layer = self.personView.layer {
            layer.masksToBounds = true
            layer.cornerRadius = layer.bounds.width / 2.0
        }
        
        self.photoView.layer!.backgroundColor = .ns(.white)
        self.photoView.layer?.masksToBounds = true
        self.photoView.layer?.cornerRadius = 10.0
    }
    
    // Given a string, a font size, and a base width, return the measured height of the cell.
    public static func measure(_ url: URL, _ width: CGFloat) -> CGFloat {
        var output: CGFloat = 0.0
        if let dims = PhotoCell.urlSizeMap[url] {
            output = dims.height * ((width - 46.0) / dims.width)
        } else {
            
            // Download and cache the info here.
            let header = CGIncrementalImage.retrieve(headersOf: url)
            let dims = header?.size ?? .zero
            PhotoCell.urlSizeMap[url] = dims
            
            output = dims.height * ((width - 46.0) / dims.width)
        }
        
        // PATCH: If you accidentally return `.nan` here, you'll basically kill the
        // NSCollectionView which doesn't know how to handle it correctly (drop it).
        return output == .nan ? 0.0 : output
    }
    
    /// Cache the URL to a size; not sure if we should expect the same url to return
    /// different sizes at any point, so this may be inaccurate. (Reload it maybe?)
    private static var urlSizeMap: [URL: CGSize] = [:]
}
